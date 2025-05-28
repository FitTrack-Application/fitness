from typing import List, Dict
from openai import AzureOpenAI
import json
from app.config.settings import settings
from app.core.vectordb import vector_db_service

UNIT_CONVERSIONS = {
    "gram": 1,
    "g": 1,
    "kilogram": 1000,
    "kg": 1000,
    "ounce": 28.35,
    "oz": 28.35,
    "pound": 453.59,
    "lb": 453.59,
    "cup": 240, 
    "tablespoon": 15,
    "tbsp": 15,
    "teaspoon": 5,
    "tsp": 5,
    "milliliter": 1,
    "ml": 1,
    "liter": 1000,
    "l": 1000,
    "tô": 200, 
    "bát": 150,
    "chén": 100, 
    "ly": 250,   
    "muỗng": 10, 
    "piece": 50,
    "slice": 30,
}

class SearchService:
    def __init__(self):
        self.openai_client = None
        self._load_ai_client()

    def _load_ai_client(self):
        try:
            self.openai_client = AzureOpenAI(
                api_key=settings.ai_api_key,  
                api_version=settings.ai_api_version,
                azure_endpoint = settings.ai_azure_endpoint
            )
            print("OpenAI loaded successfully")
        except Exception as e:
            print(f"Error loading OpenAI client: {e}")
            raise

    def search_food_by_food_description(self, description: str) -> Dict:
        try:
            result = vector_db_service.search_most_similar_food(description)
            if result["food_id"]:
                return {
                    "food_id": result["food_id"],
                    "food_name": result["food_name"],
                    "found": True
                }
            return {
                "food_id": None,
                "food_name": None,
                "found": False
            }
        except Exception as e:
            print(f"Error in search_food_by_food_description: {e}")
            return {
                "food_id": None,
                "food_name": None,
                "found": False
            }

    def parse_meal_description(self, meal_description: str) -> List[Dict]:
        system_prompt = self.get_system_prompt()
        
        functions = [
            {
                "name": "search_food_by_food_description",
                "description": "Search for one most relevant food item in the system database by a short English description about that food item.",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "description": {
                            "type": "string",
                            "description": "Short description of the food item, including food name, to search for. The description should be translated into English."
                        }
                    },
                    "required": ["description"]
                }
            }
        ]
        try:
            messages = [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": f"Analyze this meal description and return an array of all food items: {meal_description}"}
            ]
            food_log = []

            while True:
                response = self.openai_client.chat.completions.create(
                    model=settings.ai_model_name,
                    messages=messages,
                    functions=functions,
                    function_call="auto",
                    max_tokens=2000
                )
        
                message = response.choices[0].message
                messages.append(message)
                
                if message.function_call:
                    func_name = message.function_call.name
                    args = json.loads(message.function_call.arguments)
                    
                    if func_name == "search_food_by_food_description":
                        result = self.search_food_by_food_description(args["description"])
                        messages.append({
                            "role": "function",
                            "name": func_name,
                            "content": json.dumps(result, ensure_ascii=False)
                        })
                else:
                    if message.content:
                        try:
                            json_str = message.content.strip()
                            start_marker = "```json"
                            end_marker = "```"
                            start_pos = json_str.find(start_marker)
                            end_pos = json_str.rfind(end_marker)
                            
                            if start_pos != -1 and end_pos != -1 and start_pos < end_pos:
                                json_str = json_str[start_pos + len(start_marker):end_pos].strip()
                                food_log = json.loads(json_str)
                                for item in food_log:
                                    if not all(key in item for key in ["food_id", "food_name", "serving_unit_id", "number_of_servings"]):
                                        raise ValueError("Invalid food item structure in response")
                                    if not isinstance(item["number_of_servings"], (int, float)) or item["number_of_servings"] < 0:
                                        raise ValueError("Invalid number_of_servings")
                                break
                            else:
                                print("No valid JSON block found in message content")
                                return []
                        except json.JSONDecodeError as e:
                            print(f"Error parsing JSON response: {e}")
                            return []
                        except ValueError as e:
                            print(f"Validation error: {e}")
                            return []
                    else:
                        print("No content in final message")
                        return []

            return [
                {
                    "food_id": item["food_id"] or "",
                    "serving_unit_id": item["serving_unit_id"],
                    "number_of_servings": item["number_of_servings"]
                }
                for item in food_log
                if item["food_id"] 
            ]

        except Exception as e:
            print(f"Error in parse_meal_description: {e}")
            return []
        
    def get_system_prompt(self) -> str:
        unit_list = ", ".join(UNIT_CONVERSIONS.keys())
        return f"""
        You are an assistant specialized in analyzing and parsing meal description. Your task is to analyze a user's meal description and extract all food items consumed.
        
        For each food item identified:
        1. Use the search_food_by_food_description function to find the food in the system.
        2. Extract the quantity and unit from the description.
        3. The unit extracted can be in various forms, such as grams, milliliters, cups, etc. If the unit is not specified, assume it is grams for solid foods and milliliters for liquid foods.  
        4. Convert the quantity to grams or milliliters using these available units: {unit_list}. There may be some additional units in the description that are not in the list, then you should use international standards to convert the amount into grams or mimilliliters. The amount will be stored in number_of_servings, and the unit using will be either gram or milliliter.
        5. If no quantity is specified, assume number of serving is 100 for gram unit or milliliter unit (100g or 100ml). 
        
        Available units and their gram conversions:
        {json.dumps(UNIT_CONVERSIONS, indent=2, ensure_ascii=False)}
        
        Return the result as a JSON array of objects, each with:
        - food_id: The food identifier from search result (string)
        - food_name: The food name from search result (string)
        - serving_unit_id: The corresponding ID of the serving unit. Should be set to {settings.gram_id} for solid foods (foods to eat), or {settings.milliliter_id} for liquid foods (foods to drink).
        - number_of_servings: The estimated quantity, represented as the number of grams or milliliters.

        Example output:
        [
            {{"food_id": "food-0000001", "food_name": "Beef Pho", "serving_unit_id": {settings.gram_id}, "number_of_servings": 15.3}},
            {{"food_id": "food-0000002", "food_name": "Apple Juice", "serving_unit_id": {settings.milliliter_id}, "number_of_servings": 20}},
            ...
        ]

        Handle all food items in the description."""

search_service = SearchService()