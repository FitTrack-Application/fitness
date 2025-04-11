package com.hcmus.statisticserivce.controller;

import com.hcmus.statisticserivce.dto.AddWeightRequest;
import com.hcmus.statisticserivce.dto.request.WeightRequest;
import com.hcmus.statisticserivce.service.WeightService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@AllArgsConstructor
@RestController
@RequestMapping("/api/statistics")
public class StatisticController {

    private final WeightService weightService;

    @GetMapping("/")
    public ResponseEntity<?> testServer() {
        return ResponseEntity.ok("Statistic Service");
    }


    @PostMapping("/addweight")
    public ResponseEntity<?> addWeight(@RequestBody AddWeightRequest addWeightRequest) {
        return ResponseEntity.ok(weightService.addWeight(addWeightRequest));
    }

    @GetMapping("/weight")
    public ResponseEntity<?> getWeightProcess(@RequestBody WeightRequest weightRequest) {
        return ResponseEntity.ok(weightService.getWeightProcess(weightRequest));
    }


}
