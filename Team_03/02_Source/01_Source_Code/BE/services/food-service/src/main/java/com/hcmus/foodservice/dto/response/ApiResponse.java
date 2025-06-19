package com.hcmus.foodservice.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.time.LocalDateTime;
import java.time.ZoneId;
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

    @Builder.Default
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Ho_Chi_Minh")
    private LocalDateTime timestamp = LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));


    public String toJson() {
        return "{"
                + "\"status\":" + status + ","
                + "\"generalMessage\":\"" + generalMessage + "\","
                + "\"data\":" + null + ","
                + "\"metadata\":" + null + ","
                + "\"timestamp\":\"" + timestamp + "\""
                + "}";
    }
}
