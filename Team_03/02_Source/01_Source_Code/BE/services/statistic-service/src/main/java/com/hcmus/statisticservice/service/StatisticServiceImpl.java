package com.hcmus.statisticservice.service;

import com.hcmus.statisticservice.client.UserClient;
import com.hcmus.statisticservice.dto.request.AddWeightRequest;
import com.hcmus.statisticservice.dto.request.InitWeightGoalRequest;
import com.hcmus.statisticservice.dto.request.InitCaloriesGoalRequest;
import com.hcmus.statisticservice.dto.request.EditGoalRequest;
import com.hcmus.statisticservice.dto.request.UpdateProfileRequest;
import com.hcmus.statisticservice.dto.request.AddStepRequest;
import com.hcmus.statisticservice.dto.response.UserProfileResponse;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.GetGoalResponse;
import com.hcmus.statisticservice.dto.response.GetNutritionGoalResponse;
import com.hcmus.statisticservice.model.NutritionGoal;
import com.hcmus.statisticservice.model.StepLog;
import com.hcmus.statisticservice.model.WeightGoal;
import com.hcmus.statisticservice.model.WeightLog;
import com.hcmus.statisticservice.repository.WeightGoalRepository;
import com.hcmus.statisticservice.repository.WeightLogRepository;
import com.hcmus.statisticservice.repository.NutritionGoalRepository;
import com.hcmus.statisticservice.repository.StepLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class StatisticServiceImpl implements StatisticService {

    private final WeightLogRepository weightLogRepository;

    private final WeightGoalRepository weightGoalRepository;

    private final NutritionGoalRepository nutritionGoalRepository;

    private final StepLogRepository stepLogRepository;

    private final UserClient userClient;

    public ApiResponse<?> addWeight(AddWeightRequest addWeightRequest, UUID userId) {
        WeightLog weightLog = WeightLog.builder()
                .weight(addWeightRequest.getWeight())
                .date(addWeightRequest.getUpdateDate())
                .userId(userId)
                .imageUrl(addWeightRequest.getProgressPhoto())
                .build();        

        weightLogRepository.save(weightLog);

        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully added weight log")
                .timestamp(LocalDateTime.now())
                .build();
    }

    public ApiResponse<List<Map<String, Object>>> getWeightProcess(UUID userId, Integer numDays) {
        List<WeightLog> weightLogs = weightLogRepository.findByUserId(userId);

        if (weightLogs.isEmpty()) {
            return ApiResponse.<List<Map<String, Object>>>builder()
                    .status(HttpStatus.NOT_FOUND.value())
                    .generalMessage("No weight logs found for this user")
                    .timestamp(LocalDateTime.now())
                    .build();
        }

            
        
        long currentTime = System.currentTimeMillis();
        long fromTime = currentTime - Duration.ofDays(numDays).toMillis();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Map<String, WeightLog> logsPerDay = new LinkedHashMap<>();

        weightLogs.stream()
                .filter(log -> {                    
                    long logTimestamp = log.getDate().getTime();
                    return logTimestamp >= fromTime && logTimestamp <= currentTime;
                })
                .sorted(Comparator.comparing(WeightLog::getDate)) 
                .forEach(log -> {
                    String dayKey = sdf.format(log.getDate()); 
                    logsPerDay.putIfAbsent(dayKey, log); 
                });

        List<Map<String, Object>> dataList = logsPerDay.values().stream()
                .map(log -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("weight", log.getWeight());
                    map.put("date", log.getDate());
                    return map;
                })
                .toList();

        return ApiResponse.<List<Map<String, Object>>>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully retrieved weight logs")
                .data(dataList)
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<?> initWeightGoal(InitWeightGoalRequest initWeightGoalRequest, UUID userId) {
        WeightGoal weightGoal = WeightGoal.builder()
                .goalWeight(initWeightGoalRequest.getGoalWeight())
                .weeklyGoal(initWeightGoalRequest.getWeeklyGoal())
                .startingWeight(initWeightGoalRequest.getStartingWeight())
                .startingDate(initWeightGoalRequest.getStartingDate())
                .userId(userId)
                .build();
        weightGoalRepository.save(weightGoal);

        WeightLog weightLog = WeightLog.builder()
                .weight(initWeightGoalRequest.getStartingWeight())
                .date(initWeightGoalRequest.getStartingDate())
                .userId(userId)
                .imageUrl(null)
                .build();        

        weightLogRepository.save(weightLog);

        return ApiResponse.builder()
                .status(HttpStatus.CREATED.value())
                .generalMessage("Successfully initialized weight goal!")
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<?> initCaloriesGoal(InitCaloriesGoalRequest initCaloriesGoalRequest, UUID userId) {
        Double caloriesGoal = 0.0;

        if(initCaloriesGoalRequest.getGender() == "MALE") {
            caloriesGoal = 10*initCaloriesGoalRequest.getWeight() + 6.25*initCaloriesGoalRequest.getHeight() - 5*initCaloriesGoalRequest.getAge() + 5;   

        } else {
            caloriesGoal = 10*initCaloriesGoalRequest.getWeight() + 6.25*initCaloriesGoalRequest.getHeight() - 5*initCaloriesGoalRequest.getAge() - 161;   
        }

        if(initCaloriesGoalRequest.getActivityLevel() == "SEDENTARY") {
            caloriesGoal = caloriesGoal * 1.2;
        } else if(initCaloriesGoalRequest.getActivityLevel() == "LIGHT") {
            caloriesGoal = caloriesGoal * 1.375;
        } else if(initCaloriesGoalRequest.getActivityLevel() == "MODERATE") {
            caloriesGoal = caloriesGoal * 1.55;
        } else if(initCaloriesGoalRequest.getActivityLevel() == "ACTIVE") {
            caloriesGoal = caloriesGoal * 1.725;
        } else if(initCaloriesGoalRequest.getActivityLevel() == "VERY_ACTIVE") {
            caloriesGoal = caloriesGoal * 1.9;
        }
        
        if(initCaloriesGoalRequest.getGoalType() == "DOWN") {
            caloriesGoal = caloriesGoal - 1100*initCaloriesGoalRequest.getWeeklyGoal();
        } else if(initCaloriesGoalRequest.getGoalType() == "UP") {
            caloriesGoal = caloriesGoal + 1100*initCaloriesGoalRequest.getWeeklyGoal();
        }

        Double protein = caloriesGoal*0.3/4;
        Double fat = caloriesGoal*0.25/9;
        Double carb = caloriesGoal*0.45/4;

        Integer caloriesGoalInt = (int) Math.round(caloriesGoal);

        NutritionGoal existingGoal = nutritionGoalRepository.findByUserId(userId);

        if(existingGoal != null) {
            
            existingGoal.setCalories(caloriesGoalInt);
            existingGoal.setProtein(protein);
            existingGoal.setFat(fat);
            existingGoal.setCarbs(carb);

            nutritionGoalRepository.save(existingGoal);            

        } else {
            NutritionGoal nutritionGoal = NutritionGoal.builder()
                    .userId(userId)
                    .calories(caloriesGoalInt)
                    .protein(protein)
                    .fat(fat)
                    .carbs(carb)
                    .build();
            nutritionGoalRepository.save(nutritionGoal);
        }      

        
        return ApiResponse.builder()
                .status(HttpStatus.CREATED.value())
                .generalMessage("Successfully initialized calories goal!")
                .timestamp(LocalDateTime.now())
                .build();

    }

    
    @Transactional
    public ApiResponse<?> getGoal(UUID userId, String authorizationHeader) {

        WeightGoal weightGoal = weightGoalRepository.findByUserId(userId);
        WeightLog weightLog = weightLogRepository.findFirstByUserIdOrderByDateDesc(userId);

        ApiResponse<UserProfileResponse> userProfileResponse = userClient.getUserProfile(authorizationHeader);

        if (userProfileResponse.getStatus() != HttpStatus.OK.value()) {
            return ApiResponse.builder()
                    .status(HttpStatus.NOT_FOUND.value())
                    .generalMessage("User not found!")
                    .timestamp(LocalDateTime.now())
                    .build();
        }
        UserProfileResponse userProfile = userProfileResponse.getData();

        GetGoalResponse getGoalResponse = GetGoalResponse.builder()                
                .startingDate(weightGoal.getStartingDate())
                .startingWeight(weightGoal.getStartingWeight())
                .currentWeight(weightLog.getWeight())
                .goalWeight(weightGoal.getGoalWeight())
                .weeklyGoal(weightGoal.getWeeklyGoal())
                .activityLevel(userProfile.getActivityLevel())
                .build();

        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully retrieved goal!")
                .data(getGoalResponse)
                .timestamp(LocalDateTime.now())
                .build();
        
    }

    
    @Transactional
    public ApiResponse<?> editGoal(EditGoalRequest editGoalRequest, UUID userId, String authorizationHeader) {
        WeightGoal weightGoal = weightGoalRepository.findByUserId(userId);

        if (weightGoal == null) {
            return ApiResponse.builder()
                    .status(HttpStatus.NOT_FOUND.value())
                    .generalMessage("Weight goal not found!")
                    .timestamp(LocalDateTime.now())
                    .build();
        }

        weightGoal.setWeeklyGoal(editGoalRequest.getWeeklyGoal());
        weightGoal.setStartingWeight(editGoalRequest.getStartingWeight());
        weightGoal.setStartingDate(editGoalRequest.getStartingDate());
        weightGoal.setGoalWeight(editGoalRequest.getGoalWeight());

        weightGoalRepository.save(weightGoal);

        ApiResponse<UserProfileResponse> userProfileResponse = userClient.getUserProfile(authorizationHeader);

        if (userProfileResponse.getStatus() != HttpStatus.OK.value()) {
            return ApiResponse.builder()
                    .status(HttpStatus.NOT_FOUND.value())
                    .generalMessage("User not found!")
                    .timestamp(LocalDateTime.now())
                    .build();
        }
        UserProfileResponse userProfile = userProfileResponse.getData();

        String goalType = "";
        if (editGoalRequest.getGoalWeight() > editGoalRequest.getCurrentWeight()) {
            goalType = "UP";
        } else if (editGoalRequest.getGoalWeight() < editGoalRequest.getCurrentWeight()) {
            goalType = "DOWN";
        } else {
            goalType = "Maintain weight";
        }

        InitCaloriesGoalRequest initCaloriesGoalRequest = InitCaloriesGoalRequest.builder()
                .gender(userProfile.getGender())
                .weight(editGoalRequest.getCurrentWeight())
                .height(userProfile.getHeight())
                .age(userProfile.getAge())
                .activityLevel(editGoalRequest.getActivitylevel())
                .weeklyGoal(editGoalRequest.getWeeklyGoal())
                .goalType(goalType)
                .build();

        ApiResponse<?> caloriesResponse = initCaloriesGoal(initCaloriesGoalRequest, userId);


        UpdateProfileRequest updateProfileRequest = UpdateProfileRequest.builder()
                .name(userProfile.getName())
                .age(userProfile.getAge())
                .gender(userProfile.getGender())
                .height(userProfile.getHeight())
                .weight(editGoalRequest.getCurrentWeight())
                .activityLevel(editGoalRequest.getActivitylevel())
                .imageUrl(userProfile.getImageUrl())
                .build();

        ApiResponse<?> updateProfileResponse = userClient.updateUserProfile(updateProfileRequest, authorizationHeader);

        if (updateProfileResponse.getStatus() != HttpStatus.OK.value()) {
            return ApiResponse.builder()
                    .status(HttpStatus.INTERNAL_SERVER_ERROR.value())
                    .generalMessage("Failed to update user profile!")
                    .timestamp(LocalDateTime.now())
                    .build();
        }

        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully updated goal!")
                .timestamp(LocalDateTime.now())
                .build();
    }


    
    public ApiResponse<?> getNutritionGoal(UUID userId) {
        NutritionGoal nutritionGoal = nutritionGoalRepository.findByUserId(userId);

        if (nutritionGoal == null) {
            return ApiResponse.builder()
                    .status(HttpStatus.NOT_FOUND.value())
                    .generalMessage("Nutrition goal not found!")
                    .timestamp(LocalDateTime.now())
                    .build();
        }

        GetNutritionGoalResponse getNutritionGoalResponse = GetNutritionGoalResponse.builder()
                .calories(nutritionGoal.getCalories())
                .macronutrients(
                GetNutritionGoalResponse.Macronutrients.builder()                    
                    .protein(nutritionGoal.getProtein())
                    .fat(nutritionGoal.getFat())
                    .carbs(nutritionGoal.getCarbs())
                    .build())
                .build();

        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully retrieved nutrition goal!")
                .data(getNutritionGoalResponse)
                .timestamp(LocalDateTime.now())
                .build();
    }

    public ApiResponse<?> addStep(AddStepRequest addStepRequest, UUID userId) {
        StepLog stepLog = StepLog.builder()
                .stepCount(addStepRequest.getSteps())
                .date(addStepRequest.getUpdateDate())
                .userId(userId)
                .build();

        stepLogRepository.save(stepLog);

        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully added step data")
                .timestamp(LocalDateTime.now())
                .build();
    }

    public ApiResponse<List<Map<String, Object>>> getStepProcess(UUID userId, Integer numDays) {
        List<StepLog> stepLogs = stepLogRepository.findByUserId(userId);

        if (stepLogs.isEmpty()) {
            return ApiResponse.<List<Map<String, Object>>>builder()
                    .status(HttpStatus.NOT_FOUND.value())
                    .generalMessage("No step logs found for this user")
                    .timestamp(LocalDateTime.now())
                    .build();
        }

            
        
        long currentTime = System.currentTimeMillis();
        long fromTime = currentTime - Duration.ofDays(numDays).toMillis();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Map<String, StepLog> logsPerDay = new LinkedHashMap<>();

        stepLogs.stream()
                .filter(log -> {                    
                    long logTimestamp = log.getDate().getTime();
                    return logTimestamp >= fromTime && logTimestamp <= currentTime;
                })
                .sorted(Comparator.comparing(StepLog::getDate)) 
                .forEach(log -> {
                    String dayKey = sdf.format(log.getDate()); 
                    logsPerDay.putIfAbsent(dayKey, log); 
                });

        List<Map<String, Object>> dataList = logsPerDay.values().stream()
                .map(log -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("steps", log.getStepCount());
                    map.put("date", log.getDate());
                    return map;
                })
                .toList();

        return ApiResponse.<List<Map<String, Object>>>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully retrieved step logs")
                .data(dataList)
                .timestamp(LocalDateTime.now())
                .build();
    }




}
