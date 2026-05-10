package com.roo.pojo;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Lob;

@Entity
public class Candidate {
	private String fname;
	private String lname;
	@Id
	private String email;
	private String password;
	private String gender;
	private String date;
	private String address;
	private String contact;
	private String qualification;
	private String experience;
	private boolean verified;
	@Lob
	private byte[] fileData;
	private String fileName;
	private String parsedEmail;
	private String parsedPhone;
	private String parsedSkills;
	private double apiScore;
	public Candidate() {
		super();
	}
	public Candidate(String fname, String lname, String email, String password, String gender, String date,
			String address, String contact, String qualification, String experience, boolean verified,byte[] fileData, String fileName) {
		super();
		this.fname = fname;
		this.lname = lname;
		this.email = email;
		this.password = password;
		this.gender = gender;
		this.date = date;
		this.address = address;
		this.contact = contact;
		this.qualification = qualification;
		this.experience = experience;
		this.verified = verified;
		this.fileData=fileData;
		this.fileName = fileName;
	}
	public String getFname() {
		return fname;
	}
	public void setFname(String fname) {
		this.fname = fname;
	}
	public String getLname() {
		return lname;
	}
	public void setLname(String lname) {
		this.lname = lname;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getContact() {
		return contact;
	}
	public void setContact(String contact) {
		this.contact = contact;
	}
	public String getQualification() {
		return qualification;
	}
	public void setQualification(String qualification) {
		this.qualification = qualification;
	}
	public String getExperience() {
		return experience;
	}
	public void setExperience(String experience) {
		this.experience = experience;
	}
	public boolean isVerified() {
		return verified;
	}
	public void setVerified(boolean verified) {
		this.verified = verified;
	}
	public byte[] getFileData() {
		return fileData;
	}
	public void setFileData(byte[] fileData) {
		this.fileData = fileData;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getParsedEmail() {
		return parsedEmail;
	}
	public void setParsedEmail(String parsedEmail) {
		this.parsedEmail = parsedEmail;
	}
	public String getParsedPhone() {
		return parsedPhone;
	}
	public void setParsedPhone(String parsedPhone) {
		this.parsedPhone = parsedPhone;
	}
	public String getParsedSkills() {
		return parsedSkills;
	}
	public void setParsedSkills(String parsedSkills) {
		this.parsedSkills = parsedSkills;
	}
	public double getApiScore() {
		return apiScore;
	}
	public void setApiScore(double apiScore) {
		this.apiScore = apiScore;
	}
	public double getExperienceInYears() {
		if (experience == null) {
			return 0.0;
		}
		String numericPart = experience.replaceAll("[^0-9.]", "");
		if (numericPart.isEmpty()) {
			return 0.0;
		}
		try {
			return Double.parseDouble(numericPart);
		} catch (NumberFormatException ex) {
			return 0.0;
		}
	}
}
