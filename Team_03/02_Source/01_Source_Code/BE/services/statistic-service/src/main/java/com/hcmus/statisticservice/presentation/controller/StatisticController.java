package com.hcmus.statisticservice.presentation.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Controller for general statistics operations
 * Currently not in use as functionality has been split into separate
 * controllers
 */
@RequiredArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/statistics")
public class StatisticController {
    // Empty controller - functionality moved to specialized controllers
}