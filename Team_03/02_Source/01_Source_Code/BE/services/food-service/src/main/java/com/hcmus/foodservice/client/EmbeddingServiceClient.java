package com.hcmus.foodservice.client;

import com.fasterxml.jackson.databind.JsonNode;
import com.hcmus.foodservice.client.request.CreateFoodEmbeddingRequest;
import com.hcmus.foodservice.client.request.UpdateFoodEmbeddingRequest;
import com.hcmus.foodservice.config.FeignConfig;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@FeignClient(name = "embedding-service", url = "${host.embedding-service}", configuration = FeignConfig.class)
public interface EmbeddingServiceClient {

    // POST: Create Food Embedding
    @PostMapping(value = "/api/ai/food-embeddings/", consumes = MediaType.APPLICATION_JSON_VALUE)
    JsonNode createFoodEmbedding(@RequestBody CreateFoodEmbeddingRequest request);

    // PUT: Update Food Embedding
    @PutMapping(value = "/api/ai/food-embeddings/{food_id}", consumes = MediaType.APPLICATION_JSON_VALUE)
    JsonNode updateFoodEmbedding(@PathVariable("food_id") String foodId, @RequestBody UpdateFoodEmbeddingRequest request);

    // DELETE: Delete Food Embedding
    @DeleteMapping("/api/ai/food-embeddings/{food_id}")
    JsonNode deleteFoodEmbedding(@PathVariable("food_id") String foodId);
}

