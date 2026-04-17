package com.roo.feature.workflow;

public enum InterviewStage {
    APPLIED,
    WRITTEN_TEST,
    INTERVIEW,
    HR_ROUND,
    OFFERED,
    REJECTED;

    public static InterviewStage fromRecruiterStatus(String status) {
        if (status == null) {
            return APPLIED;
        }

        String value = status.trim().toUpperCase();
        switch (value) {
            case "APPLIED":
            case "PENDING":
                return APPLIED;
            case "WRITTEN TEST":
            case "WRITTEN_TEST":
                return WRITTEN_TEST;
            case "INTERVIEW":
                return INTERVIEW;
            case "HR ROUND":
            case "HR_ROUND":
                return HR_ROUND;
            case "OFFERED":
            case "SELECTED":
                return OFFERED;
            default:
                return REJECTED;
        }
    }
}
