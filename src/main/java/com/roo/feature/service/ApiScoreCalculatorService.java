package com.roo.feature.service;

import org.springframework.stereotype.Service;

import com.roo.feature.dto.PublicationInput;

@Service
public class ApiScoreCalculatorService {

    public double calculate(PublicationInput publicationInput) {
        if (publicationInput == null) {
            return 0.0;
        }

        double score = 0.0;
        score += publicationInput.getJournalsScopus() * 10.0;
        score += publicationInput.getJournalsUgc() * 7.0;
        score += publicationInput.getBooks() * 12.0;
        score += publicationInput.getConferences() * 4.0;
        score += publicationInput.getPatents() * 15.0;

        return Math.min(score, 125.0);
    }
}
