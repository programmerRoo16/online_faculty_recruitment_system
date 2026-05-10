package com.roo.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.roo.daoImpl.CandidateDaoImpl;
import com.roo.feature.dto.ResumeData;
import com.roo.feature.service.ResumeParsingService;
import com.roo.pojo.AppliedVacancy;
import com.roo.pojo.Candidate;
import com.roo.pojo.Vacancy;

@Controller
public class CandidateController {

@Autowired
private CandidateDaoImpl candidateDaoImpl;	

@Autowired
private ResumeParsingService resumeParsingService;

@RequestMapping("/")
public String getIndex() {
	return"home";
}
@GetMapping("index")
public String getindex() {
	return "index";
}
//--------------------------------

@RequestMapping("candidate_setting")
public String getcandidate_setting() {
	return "candidate_setting";
}
@RequestMapping("my_profile")
public String getMy_profile() {
	return "my_profile";
}
//--------------------------------
@GetMapping("candidateHome")
public String gethome() {
	return "candidateHome";
}
@GetMapping("loginCandidate")
public String getlogin() {
	return "loginCandidate";
}
@GetMapping("updateProfile")
public String getupdate() {
	
  return "updateProfile";
}

@GetMapping("updatePassword")
public String getupdatePassword(){
	
	return "updatePassword";
}

@GetMapping("deactivate")
public String getdeactivate() {
	return "deactivate";
}
@GetMapping("seeAllVacancies")
public String getseeAllVacancies(Model m){
	List<Vacancy> list=candidateDaoImpl.getVacancy();
	m.addAttribute("list",list);
	return "seeAllVacancies";
}


@PostMapping("register")
public String register(@RequestParam("fname") String fname,
		               @RequestParam("lname") String lname,
					   @RequestParam("email") String email,
			     	   @RequestParam("password") String password,
       				   @RequestParam("gender") String gender,
       				   @RequestParam("date") String date,
       				   @RequestParam("address") String address,
       				   @RequestParam("contact") String contact,
       				   @RequestParam("qualification") String qualification,
       				   @RequestParam("experience") String exprience,Model model,@RequestParam("resume")MultipartFile file)throws IOException{
	 byte[] fileData=file.getBytes();
	 String fileName=file.getOriginalFilename();
	Candidate candidate=new Candidate(fname, lname, email, password, gender, date, address, contact, qualification, exprience, false,fileData,fileName);
	ResumeData resumeData = resumeParsingService.parse(fileData);
	candidate.setParsedEmail(resumeData.getExtractedEmail());
	candidate.setParsedPhone(resumeData.getExtractedPhone());
	candidate.setParsedSkills(String.join(",", resumeData.getExtractedSkills()));
	if(candidateDaoImpl.registerCandidate(candidate)) {
		model.addAttribute("candidate", candidate);
		return"loginCandidate";
	}
	else {
		return "index";
	}
}

@PostMapping("candidateLogin")
public String candidateLogin(@RequestParam("email") String email,@RequestParam("password") String password,Model m,HttpSession session, HttpServletRequest request)
{
	Candidate candidate=candidateDaoImpl.checkCandidate(email, password);
	session = request.getSession(false);
	if(session!=null)
	{
		session.invalidate();
	}
	session = request.getSession(true);
	if(candidate!=null) {
		session.setAttribute("candidate", candidate);
		return "redirect:/candidate_deshboard";
	}
	else {
		return "index";
	}
}

@PostMapping("update")
public String updateCandidate(@RequestParam("fname") String fname,
		               @RequestParam("lname") String lname,
					   @RequestParam("email") String email,
			     	   @RequestParam("password") String password,
       				   @RequestParam("gender") String gender,
       				   @RequestParam("date") String date,
       				   @RequestParam("address") String address,
       				   @RequestParam("contact") String contact,
       				   @RequestParam("qualification") String qualification,
       				   @RequestParam("experience") String exprience,
       				   @RequestParam("resume")MultipartFile file,
       				   Model model)throws IOException{
	byte[] finalFileData;
    String finalFileName;
    Candidate existingCandidate = candidateDaoImpl.getCandidate(email);
    if (file != null && !file.isEmpty()) {
        // User uploaded a NEW file
        finalFileData = file.getBytes();
        finalFileName = file.getOriginalFilename();
    } else {
        // User left the file input empty - RETAIN existing data
        finalFileData = existingCandidate.getFileData();
        finalFileName = existingCandidate.getFileName(); 
    }
	Candidate candidate=new Candidate(fname, lname, email, password, gender, date, address, contact, qualification, exprience, false,finalFileData,finalFileName);
	ResumeData resumeData = resumeParsingService.parse(finalFileData);
	candidate.setParsedEmail(resumeData.getExtractedEmail());
	candidate.setParsedPhone(resumeData.getExtractedPhone());
	candidate.setParsedSkills(String.join(",", resumeData.getExtractedSkills()));
	if(candidateDaoImpl.updateCandidate(candidate)) {
		model.addAttribute("msg","Profile Updated Successfully");
		return"redirect:/candidate_deshboard";
	}
	else {
		model.addAttribute("msg","Profile Could not be Updated");
		return "redirect:/candidate_deshboard";
	}
}

@PostMapping("deactivateAccount")
public String deactivate(@RequestParam("button") String button,HttpServletRequest request,HttpSession session, Model m) {
	if(button.equals("yes")){
		Candidate candidate=(Candidate)session.getAttribute("candidate");
	   if(candidateDaoImpl.deleteProfile(candidate)) {
		   session.invalidate();
		   m.addAttribute("msg","Account Deactivated");
		   return "loginCandidate";
	   }
	   else {
		   m.addAttribute("msg","Account Not Deactivated");
		   return "candidateHome";
	   }
	}else
	{
	return "candidateHome";
	}
	}
@PostMapping("passwordUpdate")
public String changePassword(@RequestParam("new")String newPassword,@RequestParam("old")String oldPassword,Model m,HttpSession session)
{
	Candidate candidate=(Candidate)session.getAttribute("candidate");
    if(candidateDaoImpl.updatePassword(oldPassword, newPassword, candidate.getEmail())){
    	      m.addAttribute("msg","Password Changed Succesfully");  
    	      return "candidateHome";
    }
    else
    {
    	m.addAttribute("msg","Password cannot be changed");
    	return "updatePassword";
    }
}

@GetMapping("candidate_deshboard")
public String getviewApplieVacancies(HttpSession session,Model m) {
	Candidate candidate=(Candidate)session.getAttribute("candidate");
	List<AppliedVacancy> list=candidateDaoImpl.appliedStetus(candidate);
	List<Vacancy> vacancyList=candidateDaoImpl.viewVacancies(candidate.getEmail());
  	String msg=(String)m.getAttribute("msg");

	 if(vacancyList.size()>0) {
		 m.addAttribute("msg", msg);
		 m.addAttribute("appliedList",list);
		 m.addAttribute("vacancyList",vacancyList);
		 return "candidate_deshboard";
	 }
	 else
	 {    m.addAttribute("msg", "Invalid User Credential");
		 return "loginCandidate";
	 }	}


@GetMapping("viewApplieVacancies")
public String getApplieVacancy(HttpSession session,Model m) {
	Candidate candidate=(Candidate)session.getAttribute("candidate");
	List<AppliedVacancy> list=candidateDaoImpl.appliedStetus(candidate);
  	

	 if(list.size()>0) {
		 m.addAttribute("list",list);
		 return "viewApplieVacancies";
	 }
	 else
	 {   
		 return "candidate_deshboard";
	 }	}
}

