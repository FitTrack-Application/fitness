package com.hcmus.statisticservice.infrastructure.repository;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import com.hcmus.statisticservice.domain.model.FitProfile;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import java.util.*;

class FitProfileRepositoryAdapterTest {

    @Mock
    private JpaFitProfileRepository jpaFitProfileRepository;

    @InjectMocks
    private FitProfileRepositoryAdapter adapter;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testSave() {
        FitProfile profile = new FitProfile();
        when(jpaFitProfileRepository.save(profile)).thenReturn(profile);

        FitProfile saved = adapter.save(profile);

        assertEquals(profile, saved);
        verify(jpaFitProfileRepository).save(profile);
    }

    @Test
    void testFindByUserId() {
        UUID userId = UUID.randomUUID();
        FitProfile profile = new FitProfile();
        when(jpaFitProfileRepository.findByUserId(userId)).thenReturn(Optional.of(profile));

        Optional<FitProfile> result = adapter.findByUserId(userId);

        assertTrue(result.isPresent());
        assertEquals(profile, result.get());
        verify(jpaFitProfileRepository).findByUserId(userId);
    }

    @Test
    void testExistsByUserId() {
        UUID userId = UUID.randomUUID();
        when(jpaFitProfileRepository.existsByUserId(userId)).thenReturn(true);

        boolean exists = adapter.existsByUserId(userId);

        assertTrue(exists);
        verify(jpaFitProfileRepository).existsByUserId(userId);
    }

    @Test
    void testCount() {
        when(jpaFitProfileRepository.count()).thenReturn(10L);

        Integer count = adapter.count();

        assertEquals(10, count);
        verify(jpaFitProfileRepository).count();
    }

    @Test
    void testCountNewUsersByWeek() {
        Object[] row1 = new Object[]{2025, 1, 5L};
        Object[] row2 = new Object[]{2025, 2, 8L};
        Object[] row3 = new Object[]{2025, 3, 4L};
        List<Object[]> data = List.of(row1, row2, row3);
        when(jpaFitProfileRepository.countNewUsersByWeek()).thenReturn(data);

        List<Object[]> result = adapter.countNewUsersByWeek();

        assertEquals(data.size(), result.size());
        assertArrayEquals(data.get(0), result.get(0));
        verify(jpaFitProfileRepository).countNewUsersByWeek();
    }

    @Test
    void testCountEarlyChurnByWeek() {
        Object[] row1 = new Object[]{2025, 1, 5L};
        Object[] row2 = new Object[]{2025, 2, 8L};
        Object[] row3 = new Object[]{2025, 3, 4L};
        List<Object[]> data = List.of(row1, row2, row3);
        when(jpaFitProfileRepository.countEarlyChurnByWeek()).thenReturn(data);

        List<Object[]> result = adapter.countEarlyChurnByWeek();

        assertEquals(data.size(), result.size());
        assertArrayEquals(data.get(0), result.get(0));
        verify(jpaFitProfileRepository).countEarlyChurnByWeek();
    }


    @Test
    void testDeleteById() {
        UUID id = UUID.randomUUID();

        adapter.deleteById(id);

        verify(jpaFitProfileRepository).deleteById(id);
    }
}
