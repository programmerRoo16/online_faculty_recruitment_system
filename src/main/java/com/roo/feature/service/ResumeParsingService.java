package com.roo.feature.service;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.tika.Tika;
import org.springframework.stereotype.Service;

import com.roo.feature.dto.ResumeData;

@Service
public class ResumeParsingService {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+");
    private static final Pattern PHONE_PATTERN = Pattern.compile("(\\+?\\d[\\d\\- ]{8,}\\d)");

    private static final List<String> TRACKED_SKILLS = Arrays.asList(
            "java", "spring", "hibernate", "python", "machine learning", "nlp",
            "data science", "sql", "mysql", "research", "teaching", "api");

    private final Tika tika = new Tika();

    public ResumeData parse(byte[] data) {
        ResumeData resumeData = new ResumeData();
        if (data == null || data.length == 0) {
            return resumeData;
        }

        try {
            String text = tika.parseToString(new ByteArrayInputStream(data));
            resumeData.setExtractedEmail(extract(EMAIL_PATTERN, text));
            resumeData.setExtractedPhone(extract(PHONE_PATTERN, text));
            resumeData.setExtractedSkills(extractSkills(text));
        } catch (Exception ignored) {
            // Keep registration flow resilient even when PDF parsing fails.
        }

        return resumeData;
    }

    private String extract(Pattern pattern, String text) {
        Matcher matcher = pattern.matcher(text == null ? "" : text);
        if (!matcher.find()) {
            return null;
        }
        if (matcher.groupCount() >= 1 && matcher.group(1) != null) {
            return matcher.group(1);
        }
        return matcher.group();
    }

    private List<String> extractSkills(String text) {
        String lower = text == null ? "" : text.toLowerCase();
        Set<String> skills = new LinkedHashSet<String>();
        for (String skill : TRACKED_SKILLS) {
            if (lower.contains(skill)) {
                skills.add(skill);
            }
        }
        return new ArrayList<String>(skills);
    }
}
