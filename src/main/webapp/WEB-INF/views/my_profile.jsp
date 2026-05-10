<%@page import="com.roo.pojo.Candidate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Candidate Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary-color: #4F46E5;
            --secondary-color: #64748B;
            --background-color: #F1F5F9;
            --white: #ffffff;
            --text-dark: #1E293B;
            --border-color: #E2E8F0;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }

        body { background-color: var(--background-color); display: flex; height: 100vh; }

        /* Sidebar (Consistent) */
        .sidebar { width: 260px; background: var(--white); border-right: 1px solid var(--border-color); padding: 20px; display: flex; flex-direction: column; overflow-y: auto; }
        .logo { font-size: 24px; font-weight: 700; color: var(--primary-color); margin-bottom: 40px; display: flex; align-items: center; gap: 10px; }
        .nav-links { list-style: none; flex: 1; }
        .nav-links a { text-decoration: none; color: var(--secondary-color); padding: 12px 16px; display: flex; gap: 12px; border-radius: 8px; margin-bottom: 5px; transition: 0.3s; }
        .nav-links a:hover, .nav-links a.active { background: #EEF2FF; color: var(--primary-color); }

        /* Main Content */
        .main-content { flex: 1; padding: 30px; overflow-y: auto; }
        
        .header-area { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .page-title h2 { font-size: 24px; color: var(--text-dark); }
        .save-btn { background-color: var(--primary-color); color: white; border: none; padding: 10px 20px; border-radius: 6px; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 8px; }
        .save-btn:hover { background-color: #4338ca; }

        /* Grid Layout */
        .profile-grid {
            display: grid;
            grid-template-columns: 320px 1fr; /* Fixed Left, Flexible Right */
            gap: 25px;
        }

        /* Generic Card Style */
        .card { background: var(--white); border-radius: 12px; border: 1px solid var(--border-color); overflow: hidden; margin-bottom: 25px; }
        .card-header { padding: 20px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; }
        .card-header h3 { font-size: 16px; color: var(--text-dark); font-weight: 600; }
        .card-body { padding: 20px; }

        /* Inputs */
        .form-group { margin-bottom: 15px; }
        label { display: block; font-size: 12px; font-weight: 600; color: var(--secondary-color); margin-bottom: 6px; text-transform: uppercase; }
        input, textarea { width: 100%; padding: 10px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 14px; outline: none; }
        input:focus, textarea:focus { border-color: var(--primary-color); }
        textarea { resize: vertical; min-height: 100px; }

        /* Left Column Specifics */
        .profile-summary { text-align: center; padding: 30px 20px; }
        .avatar-large { width: 100px; height: 100px; background: var(--primary-color); border-radius: 50%; margin: 0 auto 15px; display: flex; align-items: center; justify-content: center; color: white; font-size: 32px; font-weight: bold; position: relative; }
        .edit-avatar { position: absolute; bottom: 0; right: 0; background: var(--text-dark); width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; border: 2px solid white; font-size: 12px; }
        
        /* Resume Upload */
        .upload-zone { border: 2px dashed var(--border-color); padding: 20px; text-align: center; border-radius: 8px; background: #F8FAFC; cursor: pointer; transition: 0.2s; }
        .upload-zone:hover { border-color: var(--primary-color); background: #EEF2FF; }
        .file-icon { font-size: 24px; color: var(--secondary-color); margin-bottom: 8px; }

        /* Skills Tags */
        .skills-container { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 10px; }
        .skill-tag { background: #EEF2FF; color: var(--primary-color); padding: 5px 12px; border-radius: 20px; font-size: 13px; font-weight: 500; display: flex; align-items: center; gap: 6px; }
        .remove-skill { cursor: pointer; font-size: 12px; }
        .add-skill-input { border: none; border-bottom: 1px solid var(--border-color); padding: 5px 0; border-radius: 0; width: 100%; margin-top: 10px; }

        /* Experience Section */
        .experience-item { display: flex; gap: 15px; padding-bottom: 10px; border-bottom: 1px solid var(--border-color); margin-bottom: 20px; }
        .experience-item:last-child { border-bottom: none; margin-bottom: 0; }
        .company-logo-placeholder { width: 50px; height: 50px; background: #F1F5F9; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: var(--secondary-color); font-size: 20px; flex-shrink: 0; }
        .job-details {}
        .row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 10px; }
        
        .add-btn { background: none; border: 1px dashed var(--secondary-color); width: 100%; padding: 12px; border-radius: 8px; color: var(--secondary-color); cursor: pointer; font-weight: 500; display: flex; align-items: center; justify-content: center; gap: 8px; margin-top: 10px; transition: 0.2s; }
        .add-btn:hover { border-color: var(--primary-color); color: var(--primary-color); background: #EEF2FF; }

    </style>
</head>
<body>

    <div class="sidebar">
        <div class="logo"><i class="fa-solid fa-briefcase"></i> JobPortal</div>
        <ul class="nav-links">
            <li><a href="#"><i class="fa-solid fa-grid-2"></i> Dashboard</a></li>
            <li><a href="#" class="active"><i class="fa-solid fa-user"></i> My Profile</a></li>
            <li><a href="#"><i class="fa-solid fa-magnifying-glass"></i> Find Jobs</a></li>
            <li><a href="#"><i class="fa-solid fa-file-lines"></i> Applications</a></li>
            <li><a href="#"><i class="fa-solid fa-gear"></i> Settings</a></li>
        </ul>
    </div>

    <div class="main-content">
        
        <div class="header-area">
            <div class="page-title">
                <h2>My Professional Profile</h2>
            </div>
            <button class="save-btn"><i class="fa-solid fa-check"></i> Save Changes</button>
        </div>
          <%Candidate candidate=(Candidate)session.getAttribute("candidate");
          %>
        <div class="profile-grid">
            
            <div class="left-col">
                
                <div class="card profile-summary">
                    <div class="avatar-large">
                        <%=candidate.getFname().charAt(0)+" "+candidate.getLname().charAt(0)%>
                        <div class="edit-avatar"><i class="fa-solid fa-camera"></i></div>
                    </div>
                    <h3><%=candidate.getFname()+" "+candidate.getLname()%></h3>
                    <p style="color: var(--secondary-color); font-size: 14px; margin-bottom: 15px;"></p>
                    <input type="hidden" name="fname" value="<%=candidate.getFname()%>">
                    <input type="hidden" name="lname" value="<%=candidate.getLname()%>">
                    <input type="hidden" name="verifie" value="<%=candidate.isVerified()%>">
                                        
                    <div class="form-group" style="text-align: left;">
                        <label>Location</label>
                        <input type="text" value="<%=candidate.getAddress()%>">
                    </div>
                    <div class="form-group" style="text-align: left;">
                        <label>Date of Birth</label>
                        <input type="date" value="<%=candidate.getDate()%>">
                    </div>
                   
                </div>

                <div class="card">
                    <div class="card-header"><h3>Contact Info</h3></div>
                    <div class="card-body">
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" value="<%=candidate.getEmail()%>" disabled style="background: #F8FAFC;">
                        </div>
                        <div class="form-group">
                            <label>Phone</label>
                            <input type="tel" name="contact" value="<%=candidate.getContact()%>">
                        </div>
                        
                    </div>
                </div>
       
     <div class="card">
    <div class="card-header"><h3>Resume</h3></div>
    <div class="card-body">
        
        <div class="upload-zone" id="dropZone">
            <input type="file" id="resumeInput" name="resume" accept=".pdf,.docx">
            
            <i class="fa-solid fa-cloud-arrow-up file-icon"></i>
            <p style="font-size: 13px; color: var(--text-dark); font-weight: 500; margin: 0;">
                Click to upload Resume or Drag & Drop
            </p>
            <p style="font-size: 11px; color: var(--secondary-color); margin-top: 5px;">
                PDF or DOCX (Max 5MB)
            </p>
        </div>

        <p class="error-msg" id="errorMsg"></p>

        <div id="fileListContainer">
            </div>

    </div>
</div>

            
                <div class="card">
                    <div class="card-header"><h3>Education</h3></div>
                    <div class="card-body">
                        <div class="experience-item">
                            <div class="company-logo-placeholder"><i class="fa-solid fa-graduation-cap"></i></div>
                            <div class="job-details">
                                <div class="row">
                                    <input type="text" name="qualification" value="<%=candidate.getQualification()%>" placeholder="Degree">
                                    <input type="text" value="University of Tech" placeholder="School/University">
                                </div>
                                <div class="row">
                                    <input type="text" value="2014" placeholder="Start Year">
                                    <input type="text" value="2018" placeholder="End Year">
                                </div>
                                <div class="row">
                                    <label>Experience</label>
                                    <input type="text" name="experience" value="<%=candidate.getExperience()%>" placeholder="Start Year">
                                </div>
                            </div>
                        </div>
                        <button class="add-btn"><i class="fa-solid fa-plus"></i> Add Education</button>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>