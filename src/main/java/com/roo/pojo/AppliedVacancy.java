package com.roo.pojo;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import com.roo.feature.workflow.InterviewStage;

@Entity
public class AppliedVacancy {
@Id
@GeneratedValue(strategy = GenerationType.AUTO)
private int id;
@ManyToOne
@JoinColumn(name = "vacancyId")
private Vacancy vacancy;
@ManyToOne
@JoinColumn(name ="candidate_email", referencedColumnName = "email")
private Candidate candidate;
@ManyToOne
@JoinColumn(name = "recruiter_email",referencedColumnName = "email")
private Recruiter recruiter;

private String statusByRecruiter;
private String interviewStage;
private double shortlistScore;
public AppliedVacancy() {
	super();
}

public AppliedVacancy(int id, Vacancy vacancy, Candidate candidate, Recruiter recruiter, String statusByRecruiter) {
	super();
	this.id = id;
	this.vacancy = vacancy;
	this.candidate = candidate;
	this.recruiter = recruiter;
	this.statusByRecruiter = statusByRecruiter;
	this.interviewStage = InterviewStage.APPLIED.name();
}

public AppliedVacancy(Vacancy vacancy, Candidate candidate, Recruiter recruiter,
		String statusByRecruiter) {
	super();
	this.vacancy = vacancy;
	this.candidate = candidate;
	this.recruiter = recruiter;
	this.statusByRecruiter = statusByRecruiter;
	this.interviewStage = InterviewStage.APPLIED.name();
}
public int getId() {
	return id;
}
public void setId(int id) {
	this.id = id;
}
public Vacancy getVacancy() {
	return vacancy;
}
public void setVacancy(Vacancy vacancy) {
	this.vacancy = vacancy;
}
public Candidate getCandidate() {
	return candidate;
}
public void setCandidate(Candidate candidate) {
	this.candidate = candidate;
}
public Recruiter getRecruiter() {
	return recruiter;
}
public void setRecruiter(Recruiter recruiter) {
	this.recruiter = recruiter;
}

public String getStatusByRecruiter() {
	return statusByRecruiter;
}
public void setStatusByRecruiter(String statusByRecruiter) {
	this.statusByRecruiter = statusByRecruiter;
}

public String getInterviewStage() {
	return interviewStage;
}

public void setInterviewStage(String interviewStage) {
	this.interviewStage = interviewStage;
}

public double getShortlistScore() {
	return shortlistScore;
}

public void setShortlistScore(double shortlistScore) {
	this.shortlistScore = shortlistScore;
}

}
