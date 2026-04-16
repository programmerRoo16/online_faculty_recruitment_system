package com.roo.controller;

import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.roo.daoImpl.AplliedVacancyDaoImpl;
import com.roo.feature.service.EmailNotificationService;
import com.roo.feature.workflow.InterviewStage;
import com.roo.pojo.AppliedVacancy;
import com.roo.pojo.Candidate;
import com.roo.pojo.Recruiter;
import com.roo.pojo.Vacancy;


@Controller
public class AplliedVacancyController {
    @Autowired
	private AplliedVacancyDaoImpl aplliedVacancyDaoImpl;

	@Autowired
	private EmailNotificationService emailNotificationService;
      
    
    
	@PostMapping("apllyVacancy")
	public String getApplyVac(@RequestParam("vid") int vId,
			                  HttpSession session,
			                  Model m) {
		Candidate candidate=(Candidate)session.getAttribute("candidate");
		Vacancy vacancy=aplliedVacancyDaoImpl.getVacancy(vId);
		Recruiter recruiter=aplliedVacancyDaoImpl.getRecruiter(vacancy.getEmail());
		
		AppliedVacancy appliedVacancy=new AppliedVacancy(vacancy, candidate, recruiter, "Applied");
		appliedVacancy.setInterviewStage(InterviewStage.APPLIED.name());
		if(aplliedVacancyDaoImpl.saveAplliedVacancy(appliedVacancy))
		{  	return "redirect:/seeAllVacancies";
        } else {
            return "redirect:/seeAllVacancies";
        }
	}
	
	@GetMapping("viewAppliedCandidate")
	public String getViewCandidates(HttpSession session, Model m) {
		Recruiter recruiter=(Recruiter)session.getAttribute("recruiter");
		List<AppliedVacancy> list=aplliedVacancyDaoImpl.viewCandidate(recruiter);
		 if(list.size()>0) {
			 m.addAttribute("list",list);
			 return "viewAppliedCandidate";
		 }
		 else
		 {   
			 return "redirect:/recruiter_deshboard";
		 }
	}
	
	
	
	
	
	@PostMapping("selectCandidate")
	public String setStatusByRecruiter(HttpSession session, 
			                         @RequestParam("id")int id,
			                         @RequestParam("status")String status,Model m) {
	    AppliedVacancy appliedVacancy=aplliedVacancyDaoImpl.findById(id);
	    appliedVacancy.setStatusByRecruiter(status);
	    InterviewStage stage = InterviewStage.fromRecruiterStatus(status);
	    appliedVacancy.setInterviewStage(stage.name());
	    if (stage != InterviewStage.APPLIED && stage != InterviewStage.REJECTED) {
	    	emailNotificationService.sendInterviewNotification(appliedVacancy.getCandidate().getEmail(), stage.name(), new java.util.Date());
	    }
	    if(aplliedVacancyDaoImpl.updateStatus(appliedVacancy)) {
	    	Recruiter recruiter=(Recruiter)session.getAttribute("recruiter");
			List<AppliedVacancy> list=aplliedVacancyDaoImpl.viewCandidate(recruiter);
			 if(list.size()>0) {
				 m.addAttribute("list",list);
				 return "viewAppliedCandidate";
			 }
			 else
			 {   
				 return "redirect:/recruiter_deshboard";
			 }
	    }
	    else {
	    	return "viewAppliedCandidate";
	    }
	}
}
