package com.hcmus.foodservice.client;

import com.fasterxml.jackson.databind.JsonNode;
import com.hcmus.foodservice.config.FeignConfig;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "open-food-fact", url = "https://world.openfoodfacts.org", configuration = FeignConfig.class)
public interface OpenFoodFactClient {

    @GetMapping("/api/v2/product/{barcode}.json")
    JsonNode getProductByBarcode(@PathVariable String barcode);
}