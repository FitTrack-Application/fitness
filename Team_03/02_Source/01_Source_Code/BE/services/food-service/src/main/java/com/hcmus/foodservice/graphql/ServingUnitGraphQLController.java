package com.hcmus.foodservice.graphql;

import com.hcmus.foodservice.dto.response.ServingUnitResponse;
import com.hcmus.foodservice.service.ServingUnitService;
import lombok.RequiredArgsConstructor;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@RequiredArgsConstructor
@Controller
public class ServingUnitGraphQLController {

    private final ServingUnitService servingUnitService;

    @QueryMapping
    public List<ServingUnitResponse> getAllServingUnits() {
        // Gọi service và trả về data (chỉ lấy phần data thôi)
        return servingUnitService.getAllServingUnits().getData();
    }

    @QueryMapping
    public ServingUnitResponse getServingUnitById(@Argument String servingUnitId) {
        // Convert String sang UUID và gọi service
        return servingUnitService.getServingUnitById(java.util.UUID.fromString(servingUnitId)).getData();
    }
}
