package com.hcmus.userservice.dto.response;

import lombok.*;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RefreshResponse {

    private String accessToken;
}