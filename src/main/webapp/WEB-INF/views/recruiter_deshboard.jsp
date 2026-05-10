<%@page import="com.roo.pojo.Recruiter"%>
<%@page import="com.roo.pojo.Vacancy"%>
<%@page import="com.roo.pojo.AppliedVacancy"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recruiter Dashboard | OFRS</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- COPYING CANDIDATE PORTAL CSS BASE --- */
        :root {
            /* Changed Primary to Teal/Cyan to match Recruiter Theme preferences */
            --primary-color: #0f766e; /* Darker Teal */
            --primary-light: #14b8a6; /* Light Teal */
            --secondary-color: #64748B; /* Slate Gray */
            --background-color: #F1F5F9;
            --white: #ffffff;
            --text-dark: #1E293B;
            --border-color: #E2E8F0;
            --success: #10B981;
            --warning: #F59E0B;
            --danger: #EF4444;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--background-color);
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* --- Sidebar Navigation --- */
        .sidebar {
            width: 260px;
            background-color: var(--white);
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            padding: 20px;
        }

        .logo {
            font-size: 20px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 40px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-links {
            list-style: none;
            flex-grow: 1;
        }

        .nav-links li {
            margin-bottom: 5px;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--secondary-color);
            padding: 12px 16px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 14px;
        }

        .nav-links a:hover, .nav-links a.active {
            background-color: #ccfbf1; /* Very light teal */
            color: var(--primary-color);
        }

        .logout-btn {
            color: var(--danger) !important;
            cursor: pointer;
        }
        
        .logout-btn:hover {
            background-color: #fee2e2 !important; /* Light red */
        }

        /* --- Main Content Area --- */
        .main-content {
            flex: 1;
            overflow-y: auto;
            padding: 30px;
        }

        /* Top Bar */
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .user-welcome h2 {
            color: var(--text-dark);
            font-size: 24px;
        }

        .user-welcome p {
            color: var(--secondary-color);
            font-size: 14px;
            margin-top: 5px;
        }

        .profile-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background-color: var(--primary-color);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: bold;
            font-size: 18px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: var(--white);
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            border: 1px solid var(--border-color);
        }

        .card h3 {
            font-size: 14px;
            color: var(--secondary-color);
            font-weight: 500;
        }

        .card .number {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-dark);
            margin-top: 10px;
        }
        
        .card-icon {
            align-self: flex-end;
            margin-top: -20px;
            color: var(--primary-light);
            font-size: 20px;
            opacity: 0.5;
        }

        /* Tables */
        .section-title {
            font-size: 18px;
            color: var(--text-dark);
            margin-bottom: 15px;
            margin-top: 30px;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .section-action {
            font-size: 13px;
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        .table-container {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            overflow: hidden;
            margin-bottom: 10px;
            border: 1px solid var(--border-color);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px 20px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        th {
            background-color: #F8FAFC;
            color: var(--secondary-color);
            font-size: 12px;
            text-transform: uppercase;
            font-weight: 600;
        }

        td {
            color: var(--text-dark);
            font-size: 14px;
        }
        
        /* Action Buttons in Table */
        .btn-action {
            padding: 6px 12px;
            border-radius: 6px;
            border: none;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        
        .btn-select {
            background-color: var(--success);
            color: white;
        }
        
        .btn-disabled {
            background-color: var(--secondary-color);
            color: white;
            cursor: not-allowed;
            opacity: 0.7;
        }
        
        .btn-edit {
            color: var(--primary-color);
            background: #e0f2fe;
            text-decoration: none;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .no-data {
            padding: 30px;
            text-align: center;
            color: var(--secondary-color);
            font-style: italic;
        }

        /* Action Menu (Quick Actions) */
        .quick-actions {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .quick-btn {
            background-color: var(--primary-color);
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        
        .quick-btn:hover {
            transform: translateY(-2px);
            background-color: #0d9488;
        }
        
        .message-box {
            background-color: #fee2e2;
            color: var(--danger);
            padding: 10px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #fecaca;
            font-size: 14px;
        }


        .hero-panel {
            background: linear-gradient(135deg, #0f172a 0%, #0f766e 55%, #14b8a6 100%);
            color: white;
            border-radius: 22px;
            padding: 28px;
            margin-bottom: 26px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 24px;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.22);
        }
        .hero-panel h2 { color: white; font-size: 30px; margin-bottom: 8px; }
        .hero-panel p { color: #d1fae5; line-height: 1.6; max-width: 720px; font-size: 14px; }
        .hero-profile { display:flex; gap:14px; align-items:center; color:white; }
        .hero-profile span { color:#ccfbf1 !important; }
        .automation-panel {
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
            border: 1px solid var(--border-color);
            border-radius: 18px;
            padding: 22px;
            margin-bottom: 22px;
            box-shadow: 0 8px 28px rgba(15, 23, 42, 0.06);
        }
        .automation-head { display:flex; justify-content:space-between; align-items:flex-start; gap:16px; margin-bottom:16px; }
        .automation-head h3 { color:#1E293B; font-size:20px; margin-bottom:6px; }
        .automation-head p { color:#64748B; font-size:13px; line-height:1.5; }
        .shortlist-controls { display:grid; grid-template-columns:minmax(220px, 1fr) auto; gap:12px; align-items:center; }
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            background: white;
            outline: none;
        }
        .form-control:focus { border-color: var(--primary-color); box-shadow: 0 0 0 3px #ccfbf1; }
        .shortlist-result-card {
            margin-top: 16px;
            padding: 14px;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 14px;
            font-size: 13px;
            color:#334155;
        }
        .rank-row { padding: 10px 0; border-bottom: 1px solid #e2e8f0; display:flex; justify-content:space-between; gap:12px; }
        .rank-row:last-child { border-bottom: none; }
        .rank-score { color:#0f766e; font-weight:800; }
        .pipeline-chip { padding:5px 10px; border-radius:999px; font-size:11px; font-weight:800; background:#fef3c7; color:#92400e; display:inline-flex; align-items:center; gap:5px; }
        .pipeline-chip.success { background:#dcfce7; color:#166534; }
        .pipeline-chip.danger { background:#fee2e2; color:#991b1b; }


    </style>
</head>
<body>

    <div class="sidebar">
        <div class="logo">
            <i class="fa-solid fa-briefcase"></i> OFRS Recruiter
        </div>
        <ul class="nav-links">
            <li><a href="recruiter_deshboard" class="active"><i class="fa-solid fa-gauge-high"></i> Dashboard</a></li>
            <li><a href="addVacancies"><i class="fa-solid fa-plus-circle"></i> Post New Vacancy</a></li>

            <li><a href="viewVacancies"><i class="fa-solid fa-list-check"></i> Manage Vacancies</a></li>
            <li><a href="viewAppliedCandidate"><i class="fa-solid fa-users-viewfinder"></i> Applicants</a></li>
            
            <li style="margin-top: 20px; margin-bottom: 10px; font-size: 11px; text-transform: uppercase; color: #94a3b8; padding-left: 16px;">Account</li>
            
            <li><a href="updateRecruiter"><i class="fa-solid fa-user-pen"></i> Update Profile</a></li>
            <li><a href="updateRecPassword"><i class="fa-solid fa-lock"></i> Change Password</a></li>
            <li><a href="deactivateRecruiter" style="color: #ef4444;"><i class="fa-solid fa-trash-can"></i> Deactivate</a></li>
        </ul>
        <ul class="nav-links" style="flex-grow: 0;">
             <li><a href="logout" class="logout-btn"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a></li>
        </ul>
    </div>

    <% 
    Recruiter recruiter = (Recruiter)session.getAttribute("recruiter"); 
    List<AppliedVacancy> applicantList = (List<AppliedVacancy>)request.getAttribute("applicantList");
    List<Vacancy> vacancyList = (List<Vacancy>)request.getAttribute("vacancyList");
    
    // Safely calculate counts for stats
    int appCount = (applicantList != null) ? applicantList.size() : 0;
    int vacCount = (vacancyList != null) ? vacancyList.size() : 0;
    
    // Handle Profile Initials
    String initials = "R";
    if(recruiter != null && recruiter.getName() != null && !recruiter.getName().isEmpty()){
        initials = String.valueOf(recruiter.getName().charAt(0));
    }
    %>

    <div class="main-content">
        
        <div class="hero-panel">
            <div class="user-welcome">
                <h2>Welcome back, <%= (recruiter != null) ? recruiter.getName() : "Recruiter" %></h2>
                <p>Use the upgraded recruiter workspace to post vacancies, compare API scores, review resume-extracted skills, generate smart shortlists, and move candidates through each interview stage.</p>
            </div>
            <div class="hero-profile">
                <div style="text-align: right; font-size: 14px;">
                    <strong><%= (recruiter != null) ? recruiter.getEmail() : "" %></strong>
                    <span style="display:block; font-size: 12px;"><%= (recruiter != null) ? recruiter.getRecruiter().toUpperCase() : "" %></span>
                </div>
                <div class="avatar"><%= initials %></div>
            </div>
        </div>    
        
        <%
        String msg = (String)request.getAttribute("msg");
        if(msg != null){
        %>
            <div class="message-box"><%= msg %></div>
        <% } %>

        <div class="stats-grid">                                
            <div class="card">
                <h3>Total Posted Vacancies</h3>
                <div class="number"><%= vacCount %></div>
                <div class="card-icon"><i class="fa-solid fa-bullhorn"></i></div>
            </div>
            <div class="card">
                <h3>Total Applicants</h3>
                <div class="number"><%= appCount %></div>
                <div class="card-icon"><i class="fa-solid fa-users"></i></div>
            </div>
            <div class="card">
                <h3>Actions Pending</h3>
                <div class="number">--</div> <div class="card-icon"><i class="fa-solid fa-clock-rotate-left"></i></div>
            </div>
        </div>

        <div class="quick-actions">
            <a href="addVacancies" class="quick-btn"><i class="fa-solid fa-plus"></i> Create New Vacancy</a>
            <a href="updateRecruiter" class="quick-btn" style="background-color: #334155;"><i class="fa-solid fa-pen-to-square"></i> Edit Profile</a>
        </div>

        <div class="automation-panel">
            <div class="automation-head">
                <div>
                    <h3><i class="fa-solid fa-wand-magic-sparkles"></i> Smart Shortlisting</h3>
                    <p>Select one of your posted vacancies and generate a preliminary merit list using candidate API score plus experience weightage.</p>
                </div>
                <a href="viewAppliedCandidate" class="section-action">Open full applicant review <i class="fa-solid fa-arrow-right"></i></a>
            </div>
            <div class="shortlist-controls">
                <select id="shortlistVacancyId" class="form-control">
                    <option value="">Select vacancy</option>
                    <% if(vacancyList != null) { for(int i=0; i<vacancyList.size(); i++) { Vacancy v = vacancyList.get(i); %>
                        <option value="<%=v.getVacancyId()%>">#<%=v.getVacancyId()%> - <%=v.getPost()%> (<%=v.getSubject()%>)</option>
                    <% } } %>
                </select>
                <button type="button" class="quick-btn" style="border:none; cursor:pointer;" onclick="loadShortlist()">
                    <i class="fa-solid fa-ranking-star"></i> Generate Merit List
                </button>
            </div>
            <div id="shortlistResult" class="shortlist-result-card">Select a vacancy to preview ranked candidates here.</div>
        </div>

        <script>
        function loadShortlist() {
            var vacancyId = document.getElementById('shortlistVacancyId').value;
            var result = document.getElementById('shortlistResult');
            if (!vacancyId) {
                result.textContent = 'Please enter a vacancy ID.';
                return;
            }
            result.textContent = 'Loading shortlist...';
            fetch('api/recruitment/vacancy/' + vacancyId + '/shortlist')
              .then(function(r){ return r.json(); })
              .then(function(data){
                  if (!data || !data.length) {
                      result.textContent = 'No applicants found for this vacancy.';
                      return;
                  }
                  var html = '<div>';
                  for (var i = 0; i < data.length; i++) {
                      var item = data[i];
                      var name = item.candidate ? (item.candidate.fname + ' ' + item.candidate.lname) : 'Candidate';
                      var score = (typeof item.shortlistScore !== 'undefined') ? Number(item.shortlistScore).toFixed(2) : '0.00';
                      var stage = item.interviewStage ? item.interviewStage.replace(/_/g, ' ') : 'APPLIED';
                      html += '<div class="rank-row"><span><strong>#' + (i + 1) + ' ' + name + '</strong><br><small>Stage: ' + stage + '</small></span><span class="rank-score">' + score + '</span></div>';
                  }
                  html += '</div>';
                  result.innerHTML = html;
              })
              .catch(function(){
                  result.textContent = 'Unable to fetch shortlist.';
              });
        }
        </script>

        <div class="section-title">
            <span>Recent Applications</span>
            <a href="viewAppliedCandidate" class="section-action">View All <i class="fa-solid fa-arrow-right"></i></a>
        </div>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Candidate Name</th>
                        <th>Applied For</th>
                        <th>Qualification</th>
                        <th>Experience</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (appCount > 0) { 
                        // Show max 5 for dashboard
                        int limit = Math.min(appCount, 5);
                        for(int i=0; i<limit; i++) {
                            AppliedVacancy av = applicantList.get(i);
                    %>
                    <tr>
                        <td style="font-weight: 500;"><%= av.getCandidate().getFname() + " " + av.getCandidate().getLname() %></td>
                        <td><%= av.getVacancy().getPost() %></td>
                        <td><%= av.getCandidate().getQualification() %></td>
                        <td><%= av.getCandidate().getExperience() %></td>
                        <td>
                            <% String stage = av.getInterviewStage();
                               if(stage == null || stage.trim().isEmpty()) { stage = "APPLIED"; }
                               if("OFFERED".equalsIgnoreCase(stage) || "SHORTLISTED".equalsIgnoreCase(stage)) { %>
                                <span class="pipeline-chip success"><i class="fa-solid fa-check"></i> <%=stage.replace("_", " ")%></span>
                            <% } else if("REJECTED".equalsIgnoreCase(stage)) { %>
                                <span class="pipeline-chip danger"><i class="fa-solid fa-xmark"></i> Rejected</span>
                            <% } else { %>
                                <span class="pipeline-chip"><i class="fa-solid fa-spinner"></i> <%=stage.replace("_", " ")%></span>
                            <% } %>
                        </td>
                        <td>
                            <form action="selectCandidate" method="post" style="margin:0;">
                                <input type="hidden" name="id" value="<%=av.getId()%>">
                                <input type="hidden" name="status" value="Interview">
                                <% if("null".equals(av.getStatusByRecruiter()) || av.getStatusByRecruiter() == null) { %>
                                    <button type="submit" class="btn-action btn-select">Select</button>
                                <% } else { %>
                                    <button type="button" class="btn-action btn-disabled" disabled>Selected</button>
                                <% } %>
                            </form>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="6" class="no-data">No applications received yet.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="section-title">
            <span>Your Active Vacancies</span>
            <a href="viewVacancies" class="section-action">Manage All <i class="fa-solid fa-arrow-right"></i></a>
        </div> 

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Post Title</th>
                        <th>Subject</th>
                        <th>Positions</th>
                        <th>Deadline</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (vacCount > 0) {
                        // Show max 5 for dashboard
                        int limit = Math.min(vacCount, 5);
                        for(int i=0; i<limit; i++) {
                            Vacancy v = vacancyList.get(i);
                    %>
                    <tr>
                        <td style="font-weight: 500;"><%= v.getPost() %></td>
                        <td><%= v.getSubject() %></td>
                        <td><%= v.getNoVacancy() %></td>
                        <td><%= v.getLastDate() %></td>
                        <td>
                           <form action="getVacancy" method="post">
                           <button name="vId" value="<%=v.getVacancyId()%>" class="btn-edit"><i class="fa-solid fa-pen"></i> Edit</button>
                           </form>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="5" class="no-data">
                            You haven't posted any vacancies yet. <a href="addVacancies" style="color: var(--primary-color);">Post one now.</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
    </div>
</body>
</html>