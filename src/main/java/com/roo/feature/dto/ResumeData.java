package com.roo.feature.dto;

import java.util.Collections;
import java.util.List;

public class ResumeData {
    private String extractedEmail;
    private String extractedPhone;
    private List<String> extractedSkills = Collections.emptyList();

    public String getExtractedEmail() {
        return extractedEmail;
    }

    public void setExtractedEmail(String extractedEmail) {
        this.extractedEmail = extractedEmail;
    }

    public String getExtractedPhone() {
        return extractedPhone;
    }

    public void setExtractedPhone(String extractedPhone) {
        this.extractedPhone = extractedPhone;
    }

    public List<String> getExtractedSkills() {
        return extractedSkills;
    }

    public void setExtractedSkills(List<String> extractedSkills) {
        this.extractedSkills = extractedSkills;
    }
}
