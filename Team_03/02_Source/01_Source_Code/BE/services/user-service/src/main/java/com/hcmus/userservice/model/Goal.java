package com.hcmus.userservice.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;
import java.time.LocalDate;

import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "goals")
public class Goal {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "userid", updatable = false, nullable = false)
    private UUID goalId;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private String goalType;
    private Double target;
    private Double goalPerWeek;
    private LocalDate startingDay;
}
