package com.hcmus.statisticservice.domain.service;

import com.hcmus.statisticservice.domain.model.WeightGoal;
import com.hcmus.statisticservice.domain.model.WeightLog;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.List;

@Service
public class WeightCalculationService {

    /**
     * Tính toán tiến độ đạt được của mục tiêu cân nặng
     *
     * @param weightGoal    Mục tiêu cân nặng
     * @param currentWeight Cân nặng hiện tại
     * @return Phần trăm tiến độ đạt được
     */
    public double calculateProgressPercentage(WeightGoal weightGoal, double currentWeight) {
        double totalWeightChange = weightGoal.getGoalWeight() -
                weightGoal.getStartingWeight();
        double actualWeightChange = currentWeight - weightGoal.getStartingWeight();

        if (totalWeightChange == 0) {
            return 100.0; // Nếu mục tiêu đã đạt được
        }

        // Nếu mục tiêu là tăng cân
        if (totalWeightChange > 0) {
            if (actualWeightChange >= totalWeightChange) {
                return 100.0;
            } else if (actualWeightChange <= 0) {
                return 0.0;
            } else {
                return (actualWeightChange / totalWeightChange) * 100.0;
            }
        }
        // Nếu mục tiêu là giảm cân
        else {
            if (actualWeightChange <= totalWeightChange) {
                return 100.0;
            } else if (actualWeightChange >= 0) {
                return 0.0;
            } else {
                return (actualWeightChange / totalWeightChange) * 100.0;
            }
        }
    }

    /**
     * Ước tính thời gian còn lại để đạt mục tiêu
     *
     * @param weightGoal Mục tiêu cân nặng
     * @param weightLogs Danh sách lịch sử cân nặng
     * @return Số ngày ước tính để đạt mục tiêu
     */
    public long estimateDaysToTarget(WeightGoal weightGoal, List<WeightLog> weightLogs) {
        if (weightLogs.isEmpty() || weightLogs.size() < 2) {
            // Tính dựa trên kế hoạch ban đầu nếu không có đủ dữ liệu
            LocalDate targetDate = convertToLocalDate(weightGoal.getStartingDate()).plusDays(30); // Giả sử 30
            // kngày
            return ChronoUnit.DAYS.between(LocalDate.now(), targetDate);
        }

        // Sắp xếp theo thời gian ghi nhận
        weightLogs.sort((a, b) -> a.getDate().compareTo(b.getDate()));

        // Lấy cân nặng mới nhất
        double latestWeight = weightLogs.get(weightLogs.size() - 1).getWeight();

        // Tính tốc độ giảm/tăng cân trung bình (kg/ngày)
        double firstWeight = weightLogs.get(0).getWeight();
        long daysBetween = ChronoUnit.DAYS.between(
                convertToLocalDate(weightLogs.get(0).getDate()),
                convertToLocalDate(weightLogs.get(weightLogs.size() - 1).getDate()));

        if (daysBetween == 0) {
            LocalDate targetDate = convertToLocalDate(weightGoal.getStartingDate()).plusDays(30);
            return ChronoUnit.DAYS.between(LocalDate.now(), targetDate);
        }

        double weightChangeRate = (latestWeight - firstWeight) / daysBetween;

        // Nếu tốc độ thay đổi cân nặng là 0 hoặc ngược chiều với mục tiêu
        if (weightChangeRate == 0 ||
                (weightGoal.getGoalWeight() > weightGoal.getStartingWeight() &&
                        weightChangeRate < 0)
                ||
                (weightGoal.getGoalWeight() < weightGoal.getStartingWeight() &&
                        weightChangeRate > 0)) {
            LocalDate targetDate = convertToLocalDate(weightGoal.getStartingDate()).plusDays(30);
            return ChronoUnit.DAYS.between(LocalDate.now(), targetDate);
        }

        // Tính số ngày còn lại để đạt mục tiêu
        double remainingChange = weightGoal.getGoalWeight() - latestWeight;
        long estimatedDays = (long) Math.abs(remainingChange / weightChangeRate);

        return estimatedDays;
    }

    /**
     * Kiểm tra xem mục tiêu có đạt được không dựa trên cân nặng hiện tại
     *
     * @param weightGoal    Mục tiêu cân nặng
     * @param currentWeight Cân nặng hiện tại
     * @return true nếu đã đạt được mục tiêu
     */
    public boolean isGoalAchieved(WeightGoal weightGoal, double currentWeight) {
        // Nếu mục tiêu là tăng cân
        if (weightGoal.getGoalWeight() > weightGoal.getStartingWeight()) {
            return currentWeight >= weightGoal.getGoalWeight();
        }
        // Nếu mục tiêu là giảm cân
        else if (weightGoal.getGoalWeight() < weightGoal.getStartingWeight()) {
            return currentWeight <= weightGoal.getGoalWeight();
        }
        // Nếu mục tiêu là giữ nguyên cân nặng
        else {
            return Math.abs(currentWeight - weightGoal.getGoalWeight()) < 0.5; // Cho
            // phép sai số 0.5kg
        }
    }

    private LocalDate convertToLocalDate(Date date) {
        return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    }
}