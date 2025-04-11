package com.hcmus.statisticserivce.service;

import com.hcmus.statisticserivce.dto.AddWeightRequest;
import com.hcmus.statisticserivce.dto.request.WeightRequest;
import com.hcmus.statisticserivce.dto.response.WeightResponse;
import com.hcmus.statisticserivce.repository.WeightRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class WeightServiceImpl {
    // private final WeightRepository weightRepository;

    // public AddWeightResponse addWeight(AddWeightRequest request) {
    //     WeightProgress weightProgress = new WeightProgress();

    //     weightProgress.setUserId(request.getUserId());
    //     weightProgress.setGoalId(request.getGoalId());
    //     weightProgress.setWeight(request.getWeight());
    //     weightProgress.setUpdateDate(LocalDate.now());
    //     weightProgress.setProgressPhoto(request.getProgressPhoto());

    //     weightRepository.save(weightProgress);
    //     return AddWeightResponse.builder()
    //             .status("success")
    //             .message("Weight added successfully")
    //             .build();
    // }

    // public WeightResponse getWeightProcess(WeightRequest request) {
    //     List<WeightProgress> weightProgressList = weightRepository.findByUserIdAndGoalId(request.getUserId(), request.getGoalId());
    //     if (weightProgressList == null) {
    //         return new WeightResponse("No weight data found for the user", null);
    //     }
    //     return buildWeightResponse("success", weightProgressList);
    // }


    // private WeightResponse buildWeightResponse(String message, List<WeightProgress> weightProgressList) {

    //     List<WeightProgressDto> dtoList = weightProgressList.stream()
    //             .map(w -> new WeightProgressDto(w.getUpdateDate(), w.getWeight(), w.getProgressPhoto()))
    //             .toList();

    //     return WeightResponse.builder()
    //             .message(message)
    //             .data(dtoList)
    //             .build();
    // }
}
