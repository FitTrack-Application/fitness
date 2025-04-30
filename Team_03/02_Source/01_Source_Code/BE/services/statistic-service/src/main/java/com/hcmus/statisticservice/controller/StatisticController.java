package com.hcmus.statisticservice.controller;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@AllArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/statistics")
public class StatisticController {

//    private final StatisticService statisticService;
//
//    private final JwtUtil jwtUtil;
//
//    @PostMapping("/add-weight")
//    public ResponseEntity<?> addWeight(@RequestBody WeightLogRequest weightLogRequest, @RequestHeader("Authorization") String authorizationHeader) {
//        UUID userId = jwtUtil.getCurrentUserId();
//        return ResponseEntity.ok(statisticService.addWeight(weightLogRequest, userId));
//    }
//
//    @GetMapping("/weight")
//    public ResponseEntity<?> getWeightProcess(@RequestHeader("Authorization") String authorizationHeader, @RequestParam(value = "days", defaultValue = "7") Integer days) {
//        UUID userId = jwtUtil.getCurrentUserId();
//        return ResponseEntity.ok(statisticService.getWeightProcess(userId, days));
//    }
//
//    @PostMapping("/init-weight-goal")
//    public ResponseEntity<?> initWeightGoal(@RequestBody InitWeightGoalRequest initWeightGoalRequest, @RequestHeader("Authorization") String authorizationHeader) {
//        UUID userId = jwtUtil.getCurrentUserId();
//        return ResponseEntity.ok(statisticService.initWeightGoal(initWeightGoalRequest, userId));
//    }
//
//    @PostMapping("/init-calories-goal")
//    public ResponseEntity<?> initCaloriesGoal(@RequestBody InitCaloriesGoalRequest initCaloriesGoalRequest, @RequestHeader("Authorization") String authorizationHeader) {
//        UUID userId = jwtUtil.getCurrentUserId();
//        return ResponseEntity.ok(statisticService.initCaloriesGoal(initCaloriesGoalRequest, userId));
//    }
//
//    @PostMapping("/add-steps")
//    public ResponseEntity<?> addStep(@RequestBody StepLogRequest stepLogRequest, @RequestHeader("Authorization") String authorizationHeader) {
//        UUID userId = jwtUtil.getCurrentUserId();
//        return ResponseEntity.ok(statisticService.addStep(stepLogRequest, userId));
//    }
//
//    @GetMapping("/steps")
//    public ResponseEntity<?> getStepProcess(@RequestHeader("Authorization") String authorizationHeader, @RequestParam(value = "days", defaultValue = "7") Integer days) {
//        UUID userId = jwtUtil.getCurrentUserId();
//        return ResponseEntity.ok(statisticService.getStepProcess(userId, days));
//    }
//    private final StatisticService statisticService;
//
//    private final JwtUtil jwtUtil;
//
//    @GetMapping
//    public ResponseEntity<?> getGoal() {
//        UUID userId = jwtUtil.getCurrentUserId();
//        return ResponseEntity.ok(statisticService.getGoal(userId));
//    }
//
//    @PutMapping("/edit")
//    public ResponseEntity<?> editGoal(@RequestBody UpdateWeightGoalRequest updateWeightGoalRequest) {
//        UUID userId = jwtUtil.getCurrentUserId();
//        return ResponseEntity.ok(statisticService.editGoal(updateWeightGoalRequest, userId));
//    }
//
//    @GetMapping("/nutrition")
//    public ResponseEntity<?> getNutritionGoal() {
//        UUID userId = jwtUtil.getCurrentUserId();
//        return ResponseEntity.ok(statisticService.getNutritionGoal(userId));
//    }
}
