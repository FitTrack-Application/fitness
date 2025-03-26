package com.hcmus.userservice.service;

import com.hcmus.userservice.dto.SurveyResponse;
import com.hcmus.userservice.model.Role;
import com.hcmus.userservice.model.User;
import com.hcmus.userservice.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("Không tìm thấy người dùng với email: " + username));
    }

    public SurveyResponse survey(SurveyRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            return buildSurveyResponse("error", "Invalid information. Please try again");
        }

        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setAge(request.getAge());
        user.setGender(request.getGender());
        user.setHeight(request.getHeight());
        user.setWeight(request.getWeight());
        user.setImageUrl(request.getImageUrl());

        // Nếu role không được chỉ định, mặc định là USER
        user.setRole(request.getRole() != null ? request.getRole() : Role.USER);

        userRepository.save(user);

        return buildSurveyResponse("success", new DataResponse(user.getUserId(), "Information is successfully saved"));
    }

    private SurveyResponse buildSurveyResponse(String status, DataResponse data) {
        return SurveyResponse.builder()
                .status(status)
                .data(data)
                .build();

    }
}

class DataResponse{
    private long userId;
    private String message;

    public DataResponse(long userId, String message) {
        this.userId = userId;
        this.message = message;
    }
}