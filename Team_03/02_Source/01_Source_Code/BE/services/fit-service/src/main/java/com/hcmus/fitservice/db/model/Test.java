package com.hcmus.fitservice.db.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "test")
public class Test {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "test_id_gen")
    @SequenceGenerator(name = "test_id_gen", sequenceName = "test_id_seq", allocationSize = 1)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Size(max = 255)
    @ColumnDefault("'hello world'")
    @Column(name = "content")
    private String content;
}