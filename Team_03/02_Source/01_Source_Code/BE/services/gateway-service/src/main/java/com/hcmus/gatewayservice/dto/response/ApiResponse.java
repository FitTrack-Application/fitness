package com.hcmus.gatewayservice.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ApiResponse<T> {

    private Integer status;

    private String generalMessage;

    private T data;

    private Map<String, Object> metadata;

    private List<String> errorDetails;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime timestamp;

    public String toJson() {
        StringBuilder errorDetailsStr = new StringBuilder("[");
        for (int i = 0; i < errorDetails.size(); i++) {
            errorDetailsStr.append("\"").append(errorDetails.get(i)).append("\"");
            if (i < errorDetails.size() - 1) {
                errorDetailsStr.append(",");
            }
        }
        errorDetailsStr.append("]");
        return "{"
                + "\"status\":" + status + ","
                + "\"generalMessage\":\"" + generalMessage + "\","
                + "\"data\":" + null + ","
                + "\"metadata\":" + null + ","
                + "\"errorDetails\":" + errorDetailsStr + ","
                + "\"timestamp\":\"" + timestamp + "\""
                + "}";
    }
}
