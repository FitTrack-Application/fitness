package com.hcmus.statisticservice.application.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateWeightGoalRequest {
    @NotNull(message = "Cân nặng hiện tại không được để trống")
    @Positive(message = "Cân nặng hiện tại phải là số dương")
    private Double startWeight;

    @NotNull(message = "Cân nặng mục tiêu không được để trống")
    @Positive(message = "Cân nặng mục tiêu phải là số dương")
    private Double targetWeight;

    @NotNull(message = "Ngày bắt đầu không được để trống")
    private LocalDate startDate;

    @NotNull(message = "Ngày mục tiêu không được để trống")
    @Future(message = "Ngày mục tiêu phải trong tương lai")
    private LocalDate targetDate;
}