package main.java.com.hcmus.userservice.service;

import org.springframework.stereotype.Service;

@Service 
public class UpdateInforUserService {
    private final UserRepository userRepository;

    public UpdateInforUserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void updateUserProfile(UserUpdateRequest userUpdateRequest, UUID userId) {
        User user = userRepository.findById(userId).orElseThrow(() -> new UserNotFoundException("Không tìm thấy người dùng"));
        user.setName(userUpdateRequest.getName());
        user.setAge(userUpdateRequest.getAge());
        user.setGender(userUpdateRequest.getGender());
        user.setHeight(userUpdateRequest.getHeight());
        user.setWeight(userUpdateRequest.getWeight());
        user.setImageUrl(userUpdateRequest.getImageUrl());
        userRepository.save(user);
    }
}
