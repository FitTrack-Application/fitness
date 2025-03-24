package com.hcmus.statisticserivce.controller;

import com.hcmus.statisticserivce.dto.GoalDto;
import com.hcmus.statisticserivce.service.GoalService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/goals")
@RequiredArgsConstructor
public class GoalController {

    private final GoalService goalService;

    @GetMapping
    public ResponseEntity<List<GoalDto>> getAllGoals() {
        return ResponseEntity.ok(goalService.getAllGoals());
    }

    @GetMapping("/{id}")
    public ResponseEntity<GoalDto> getGoalById(@PathVariable UUID id) {
        return ResponseEntity.ok(goalService.getGoalById(id));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<GoalDto>> getGoalsByUserId(@PathVariable UUID userId) {
        return ResponseEntity.ok(goalService.getGoalsByUserId(userId));
    }

    @GetMapping("/user/{userId}/type/{goalType}")
    public ResponseEntity<List<GoalDto>> getGoalsByUserIdAndType(
            @PathVariable UUID userId,
            @PathVariable String goalType) {
        return ResponseEntity.ok(goalService.getGoalsByUserIdAndType(userId, goalType));
    }

    @GetMapping("/user/{userId}/deadline/before")
    public ResponseEntity<List<GoalDto>> getGoalsByUserIdAndDeadlineBefore(
            @PathVariable UUID userId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return ResponseEntity.ok(goalService.getGoalsByUserIdAndDeadlineBefore(userId, date));
    }

    @GetMapping("/user/{userId}/deadline/after")
    public ResponseEntity<List<GoalDto>> getGoalsByUserIdAndDeadlineAfter(
            @PathVariable UUID userId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return ResponseEntity.ok(goalService.getGoalsByUserIdAndDeadlineAfter(userId, date));
    }

    @GetMapping("/user/{userId}/status")
    public ResponseEntity<List<GoalDto>> getGoalsByUserIdAndAchievedStatus(
            @PathVariable UUID userId,
            @RequestParam Boolean achieved) {
        return ResponseEntity.ok(goalService.getGoalsByUserIdAndAchievedStatus(userId, achieved));
    }

    @PostMapping
    public ResponseEntity<GoalDto> createGoal(@Valid @RequestBody GoalDto goalDto) {
        return new ResponseEntity<>(goalService.createGoal(goalDto), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<GoalDto> updateGoal(@PathVariable UUID id, @Valid @RequestBody GoalDto goalDto) {
        return ResponseEntity.ok(goalService.updateGoal(id, goalDto));
    }

    @PatchMapping("/{id}/progress")
    public ResponseEntity<GoalDto> updateGoalProgress(
            @PathVariable UUID id,
            @RequestParam Double currentValue) {
        return ResponseEntity.ok(goalService.updateGoalProgress(id, currentValue));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteGoal(@PathVariable UUID id) {
        goalService.deleteGoal(id);
        return ResponseEntity.noContent().build();
    }
}