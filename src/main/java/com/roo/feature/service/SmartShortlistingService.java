package com.roo.feature.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.stereotype.Service;

import com.roo.pojo.AppliedVacancy;
import com.roo.pojo.Candidate;

@Service
public class SmartShortlistingService {

    public List<AppliedVacancy> rankByMerit(List<AppliedVacancy> applications) {
        if (applications == null) {
            return Collections.emptyList();
        }

        List<AppliedVacancy> ranked = new ArrayList<AppliedVacancy>(applications);
        for (AppliedVacancy application : ranked) {
            Candidate candidate = application.getCandidate();
            double apiScore = candidate != null ? candidate.getApiScore() : 0.0;
            double experienceWeight = candidate != null ? candidate.getExperienceInYears() * 5.0 : 0.0;
            application.setShortlistScore((apiScore * 0.7) + (experienceWeight * 0.3));
        }

        Collections.sort(ranked, new Comparator<AppliedVacancy>() {
            @Override
            public int compare(AppliedVacancy a1, AppliedVacancy a2) {
                return Double.compare(a2.getShortlistScore(), a1.getShortlistScore());
            }
        });

        return ranked;
    }
}
