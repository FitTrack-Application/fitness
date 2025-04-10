package com.hcmus.statisticserivce.controller;

import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.hcmus.statisticserivce.dto.AddWeightRequest;
import com.hcmus.statisticserivce.dto.WeightRequest;
import com.hcmus.statisticserivce.service.WeightService;

@AllArgsConstructor
@RestController
@RequestMapping("/api/statistic")
public class StatisticController {

    private final WeightService weightService;

    @GetMapping("/")
    public ResponseEntity<?> testServer() {
        return ResponseEntity.ok("Statistic Service");
    }


    @PostMapping("/addweight")
    public ResponseEntity<?> addWeight(@RequestBody AddWeightRequest addWeightRequest) {        ;
        return ResponseEntity.ok(weightService.addWeight(addWeightRequest));
    }

    @GetMapping("/weight")
    public ResponseEntity<?> getWeightProcess(@RequestBody WeightRequest weightRequest) {
        return ResponseEntity.ok(weightService.getWeightProcess(weightRequest));
    }



}
