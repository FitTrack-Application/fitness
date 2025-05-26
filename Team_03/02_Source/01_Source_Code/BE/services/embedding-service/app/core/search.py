from typing import List, Dict
from openai import OpenAI
import json
from app.models.search import FoodSearchRequest, FoodEntry, FoodSearchResponse
from app.config.settings import settings
from app.core.vectordb import vector_db_service
import numpy as np

class SearchService:
    def __init__(self):
        self.openai_client = None
        self._load_ai_client()

    def _load_ai_client(self):
        try:
            self.openai_client = OpenAI(api_key=settings.ai_api_key)
            print("OpenAI loaded successfully")
        except Exception as e:
            print(f"Error loading OpenAI client: {e}")
            raise

    def search_food_by_description(self, description: str) -> Dict:
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
            print(f"Error in search_food_by_description: {e}")
            return {
                "food_id": None,
                "food_name": None,
                "found": False
            }

    def parse_meal_description(self, meal_description: str, unit_conversions_description: str) -> List[Dict]:
        system_prompt = self.get_system_prompt(unit_conversions_description=unit_conversions_description)
        
        functions = [
            {
                "name": "search_food_by_description",
                "description": "Search for one most relevant food item available in the system database by a short English description about that food item.",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "description": {
                            "type": "string",
                            "description": "Short description of the food item, including food name, to search for. The description should be in English."
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
                    
                    if func_name == "search_food_by_description":
                        result = self.search_food_by_description(args["description"])
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
    
    def get_system_prompt(self, unit_conversions_description: str) -> str:
        return f"""
        You are a meal parser assistant. Your task is to analyze a user's meal description and extract all food items consumed.
        For each food item identified:
        1. Use the search_food_by_description function to find the food in the system.
        2. Extract the quantity and unit from the description.
        3. The unit must be one of the available units in the system, as specified in the `unit_conversions_description`. Each unit has an associated `serving_unit` (ID) and `unit_name`.     
        4. If no quantity is specified, assume 100 with gram and 1 with other serving unit.
        5. If the unit is ambiguous or not found in the `unit_conversions_description`, default to the "gram" unit and its corresponding `serving_unit` ID, using international or Vietnamese standards (e.g., 1 cup = 240g, 1 tablespoon = 15g, 1 teaspoon = 5g, tô = 200g, bát = 150g, chén = 100g, ly = 250g, muỗng = 10g, piece = 50g, slice = 30g) to estimate the quantity in grams.
        6. Use the `unit_conversions_description` to clarify ambiguous units when possible.

        Available units in the system and their gram conversions:
        {unit_conversions_description}

        Return the result as a JSON array of objects, each with:
        - food_id: from search result (string or null)
        - food_name: from search result (string or null)
        - serving_unit_id: the `serving_unit` ID from the `unit_conversions_description` (string)
        - number_of_servings: quantity of the unit (number)

        Example output:
        [
        {{"food_id": "food-0000001", "food_name": "Beef Pho", "serving_unit_id": "unit-0000001", "number_of_servings": 15.3}},
        {{"food_id": "food-0000002", "food_name": "Chicken", "serving_unit_id": "unit-0000001", "number_of_servings": 100}}
        ]

        Handle all food items in the description."""

search_service = SearchService()