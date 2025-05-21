package com.hcmus.fitservice.db.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "demo")
public class Demo {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "demo_id_gen")
    @SequenceGenerator(name = "demo_id_gen", sequenceName = "demo_id_seq", allocationSize = 1)
    @Column(nullable = false)
    private Integer id;

    @Size(max = 255)
    @ColumnDefault("'demo'")
    private String content;
}