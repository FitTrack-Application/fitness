package com.hcmus.fitservice.client;

import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "open-food-fact", url = "https://world.openfoodfacts.org")
public interface OpenFoodFactClient {
    @GetMapping("/api/v2/product/{barcode}.json")
    JsonNode getProductByBarcode(@PathVariable String barcode);
}