package com.roo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.roo.daoImpl.AplliedVacancyDaoImpl;
import com.roo.daoImpl.CandidateDaoImpl;
import com.roo.feature.dto.PublicationInput;
import com.roo.feature.service.ApiScoreCalculatorService;
import com.roo.feature.service.SmartShortlistingService;
import com.roo.pojo.AppliedVacancy;
import com.roo.pojo.Candidate;

@RestController
@RequestMapping("/api/recruitment")
public class RecruitmentAutomationController {

    @Autowired
    private CandidateDaoImpl candidateDaoImpl;

    @Autowired
    private AplliedVacancyDaoImpl aplliedVacancyDaoImpl;

    @Autowired
    private ApiScoreCalculatorService apiScoreCalculatorService;

    @Autowired
    private SmartShortlistingService smartShortlistingService;

    @PostMapping("/candidate/{email}/api-score")
    public Candidate updateApiScore(@PathVariable("email") String email, @RequestBody PublicationInput publicationInput) {
        Candidate candidate = candidateDaoImpl.getCandidate(email);
        if (candidate == null) {
            return null;
        }

        candidate.setApiScore(apiScoreCalculatorService.calculate(publicationInput));
        candidateDaoImpl.updateCandidate(candidate);
        return candidate;
    }

    @GetMapping("/vacancy/{vacancyId}/shortlist")
    public List<AppliedVacancy> getSmartShortlist(@PathVariable("vacancyId") int vacancyId) {
        List<AppliedVacancy> applications = aplliedVacancyDaoImpl.findByVacancyId(vacancyId);
        return smartShortlistingService.rankByMerit(applications);
    }
}
