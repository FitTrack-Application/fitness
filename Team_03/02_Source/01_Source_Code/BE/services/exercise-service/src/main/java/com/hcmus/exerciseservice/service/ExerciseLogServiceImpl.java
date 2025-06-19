package com.hcmus.exerciseservice.service;

import com.hcmus.exerciseservice.dto.request.ExerciseLogEntryRequest;
import com.hcmus.exerciseservice.dto.request.InitiateExerciseLogRequest;
import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseLogEntryResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseLogResponse;
import com.hcmus.exerciseservice.exception.ResourceAlreadyExistsException;
import com.hcmus.exerciseservice.exception.ResourceNotFoundException;
import com.hcmus.exerciseservice.mapper.ExerciseLogEntryMapper;
import com.hcmus.exerciseservice.mapper.ExerciseLogMapper;
import com.hcmus.exerciseservice.model.Exercise;
import com.hcmus.exerciseservice.model.ExerciseLog;
import com.hcmus.exerciseservice.model.ExerciseLogEntry;
import com.hcmus.exerciseservice.repository.ExerciseLogEntryRepository;
import com.hcmus.exerciseservice.repository.ExerciseLogRepository;
import com.hcmus.exerciseservice.repository.ExerciseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ExerciseLogServiceImpl implements ExerciseLogService {

    private final ExerciseLogRepository exerciseLogRepository;

    private final ExerciseLogEntryRepository exerciseLogEntryRepository;

    private final ExerciseRepository exerciseRepository;

    private final ExerciseLogEntryMapper exerciseLogEntryMapper;

    private final ExerciseLogMapper exerciseLogMapper;

    @Override
    public ApiResponse<?> createExerciseLog(InitiateExerciseLogRequest initiateExerciseLogRequest, UUID userId) {
        // Check if exercise log is already existed
        if (exerciseLogRepository.existsByUserIdAndDate(userId, initiateExerciseLogRequest.getDate())) {
            throw new ResourceAlreadyExistsException("Exercise log already exists at this date");
        }

        // Create new exercise log
        ExerciseLog exerciseLog = new ExerciseLog();
        exerciseLog.setUserId(userId);
        exerciseLog.setDate(initiateExerciseLogRequest.getDate());
        exerciseLog.setExerciseLogEntries(new ArrayList<>());

        exerciseLogRepository.save(exerciseLog);

        return ApiResponse.builder()
                .status(201)
                .generalMessage("Successfully created exercise log")
                .build();
    }

    @Override
    public ApiResponse<ExerciseLogEntryResponse> addExerciseLogEntry(UUID exerciseLogId, ExerciseLogEntryRequest exerciseLogEntryRequest) {
        ExerciseLog exerciseLog = exerciseLogRepository.findById(exerciseLogId)
                .orElseThrow(() -> new ResourceNotFoundException("Exercise log not found with ID: " + exerciseLogId));

        Exercise exercise = exerciseRepository.findById(exerciseLogEntryRequest.getExerciseId())
                .orElseThrow(() -> new ResourceNotFoundException("Exercise not found with ID: " + exerciseLogEntryRequest.getExerciseId()));

        // Create new exercise log entry
        ExerciseLogEntry exerciseLogEntry = new ExerciseLogEntry();
        exerciseLogEntry.setExerciseLog(exerciseLog);
        exerciseLogEntry.setExercise(exercise);
        exerciseLogEntry.setDuration(exerciseLogEntryRequest.getDuration());

        exerciseLogEntryRepository.save(exerciseLogEntry);

        // Convert to Dto
        ExerciseLogEntryResponse exerciseLogEntryResponse = exerciseLogEntryMapper.convertToExerciseLogEntryResponse(exerciseLogEntry);

        return ApiResponse.<ExerciseLogEntryResponse>builder()
                .status(201)
                .generalMessage("Successfully added exercise log entry")
                .data(exerciseLogEntryResponse)
                .build();
    }

    public ApiResponse<ExerciseLogResponse> getExerciseLogByUserIdAndDate(UUID userId, Date date) {
        ExerciseLog exerciseLog = exerciseLogRepository.findByUserIdAndDate(userId, date)
                .orElseThrow(() -> new ResourceNotFoundException("Exercise log not found for user ID: " + userId + " and date: " + date));

        // Convert to Dto
        ExerciseLogResponse exerciseLogResponse = exerciseLogMapper.convertToExerciseLogResponse(exerciseLog);

        return ApiResponse.<ExerciseLogResponse>builder()
                .status(200)
                .generalMessage("Successfully retrieved exercise log")
                .data(exerciseLogResponse)
                .build();
    }
}
