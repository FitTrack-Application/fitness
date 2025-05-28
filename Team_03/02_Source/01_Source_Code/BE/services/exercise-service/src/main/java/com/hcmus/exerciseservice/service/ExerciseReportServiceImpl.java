package com.hcmus.exerciseservice.service;

import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.TopExerciseDto;
import com.hcmus.exerciseservice.dto.response.ExerciseReportResponse;
import com.hcmus.exerciseservice.model.Exercise;
import com.hcmus.exerciseservice.repository.ExerciseRepository;
import com.hcmus.exerciseservice.repository.ExerciseLogEntryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@Service
public class ExerciseReportServiceImpl implements ExerciseReportService {

    private final ExerciseRepository exerciseRepository;

    private final ExerciseLogEntryRepository exerciseLogEntryRepository;

    @Override
    public ApiResponse<ExerciseReportResponse> getExerciseReport() {
        Integer totalExerciseCount = (int) exerciseRepository.count();

        List<UUID> distinctExerciseIdsUsed = exerciseLogEntryRepository.findDistinctExerciseIdsUsed();

        Integer usedCustomExercise = 0;
        Integer usedAvailableExercise = 0;

        for (UUID exerciseId : distinctExerciseIdsUsed) {
            if (exerciseRepository.existsByExerciseIdAndUserIdIsNotNull(exerciseId)) {
                usedCustomExercise ++;
            } else {
                usedAvailableExercise ++;
            }
        }

        Pageable topFive = PageRequest.of(0, 5);
        List<UUID> topFiveExerciseIds = exerciseLogEntryRepository.findTopMostUsedExerciseIds(topFive);

        List<TopExerciseDto> topExerciseDtos = new ArrayList<>();

        for (UUID exerciseId : topFiveExerciseIds) {
            Exercise exercise = exerciseRepository.findByExerciseId(exerciseId);
            TopExerciseDto topExerciseDto = new TopExerciseDto();
            topExerciseDto.setName(exercise.getExerciseName());
            topExerciseDto.setCount(exerciseLogEntryRepository.countByExercise_ExerciseId(exerciseId));
            topExerciseDtos.add(topExerciseDto);
        }

        ExerciseReportResponse reportResponse = new ExerciseReportResponse();
        reportResponse.setTotalExercise(totalExerciseCount);
        reportResponse.setUsedCustomExercise(usedCustomExercise);
        reportResponse.setUsedAvailableExercise(usedAvailableExercise);
        reportResponse.setTopExercises(topExerciseDtos);

        return ApiResponse.<ExerciseReportResponse>builder()
                .status(200)
                .generalMessage("Successfully retrieved exercise report")
                .data(reportResponse)
                .build();
    }


    

}
