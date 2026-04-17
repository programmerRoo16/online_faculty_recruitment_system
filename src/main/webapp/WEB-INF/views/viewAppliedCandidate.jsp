<%@page import="com.roo.pojo.AppliedVacancy"%>
<%@page import="com.roo.pojo.Vacancy"%>
<%@page import="com.roo.pojo.Candidate"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Applicants | OFRS</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- BASE THEME (MATCHING DASHBOARD) --- */
        :root {
            --primary-color: #0f766e; /* Teal */
            --primary-light: #14b8a6; 
            --secondary-color: #64748B;
            --background-color: #F1F5F9;
            --white: #ffffff;
            --text-dark: #1E293B;
            --border-color: #E2E8F0;
            --success: #10B981;
            --danger: #EF4444;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }

        body {
            background-color: var(--background-color);
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* --- SIDEBAR --- */
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

        .nav-links { list-style: none; flex-grow: 1; }
        .nav-links li { margin-bottom: 5px; }
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
            background-color: #ccfbf1;
            color: var(--primary-color);
        }
        .logout-btn { color: var(--danger) !important; cursor: pointer; }

        /* --- MAIN CONTENT --- */
        .main-content {
            flex: 1;
            overflow-y: auto;
            padding: 30px;
        }

        .page-header {
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .page-header h2 { font-size: 24px; color: var(--text-dark); }
        .page-header p { color: var(--secondary-color); font-size: 14px; margin-top: 5px; }

        /* --- TABLE DESIGN --- */
        .table-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        table { width: 100%; border-collapse: collapse; min-width: 1000px; }
        
        th, td {
            padding: 16px 20px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        th {
            background-color: #F8FAFC;
            color: var(--secondary-color);
            font-size: 12px;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        td { color: var(--text-dark); font-size: 14px; }
        
        tr:hover { background-color: #F8FAFC; }

        /* User Info Cell Styling */
        .user-cell { display: flex; flex-direction: column; }
        .user-name { font-weight: 600; color: var(--text-dark); }
        .user-meta { font-size: 12px; color: var(--secondary-color); }

        /* Action Buttons */
        .btn-select {
            background-color: var(--success);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .btn-select:hover { background-color: #059669; }

        .btn-disabled {
            background-color: #E2E8F0;
            color: var(--secondary-color);
            border: 1px solid var(--border-color);
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13px;
            cursor: not-allowed;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .btn-resume {
            color: var(--primary-color);
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            display: inline-block;
            margin-top: 5px;
        }
        .btn-resume:hover { text-decoration: underline; }

        .no-data {
            padding: 50px;
            text-align: center;
            color: var(--secondary-color);
            font-style: italic;
        }

    </style>
</head>
<body>

    <div class="sidebar">
        <div class="logo">
            <i class="fa-solid fa-briefcase"></i> OFRS Recruiter
        </div>
        <ul class="nav-links">
            <li><a href="recruiter_deshboard"><i class="fa-solid fa-gauge-high"></i> Dashboard</a></li>
            <li><a href="addVacancies"><i class="fa-solid fa-plus-circle"></i> Post New Vacancy</a></li>
            <li><a href="viewVacancies"><i class="fa-solid fa-list-check"></i> Manage Vacancies</a></li>
            <li><a href="viewAppliedCandidate" class="active"><i class="fa-solid fa-users-viewfinder"></i> Applicants</a></li>
            
            <li style="margin-top: 20px; margin-bottom: 10px; font-size: 11px; text-transform: uppercase; color: #94a3b8; padding-left: 16px;">Account</li>
            <li><a href="updateRecruiter"><i class="fa-solid fa-user-pen"></i> Update Profile</a></li>
            <li><a href="updateRecPassword"><i class="fa-solid fa-lock"></i> Change Password</a></li>
            <li><a href="deactivateRecruiter" style="color: #ef4444;"><i class="fa-solid fa-trash-can"></i> Deactivate</a></li>
        </ul>
        <ul class="nav-links" style="flex-grow: 0;">
             <li><a href="logout" class="logout-btn"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        
        <div class="page-header">
            <div>
                <h2>Manage Applicants</h2>
                <p>Review and shortlist candidates who applied to your vacancies.</p>
            </div>
        </div>

        <%
            @SuppressWarnings("unchecked")
            List<AppliedVacancy> list = (List<AppliedVacancy>)request.getAttribute("list");
        %>

        <div class="table-card">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Candidate Details</th>
                            <th>Applied For</th>
                            <th>Qualification</th>
                            <th>Experience</th>
                            <th>API Score</th>
                            <th>Parsed Skills</th>
                            <th>Contact Info</th>
                            <th>Location</th>
                            <th>Stage</th>
                            <th>Resume</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        if (list != null && list.size() > 0) {
                            for(int i=0; i<list.size(); i++) {
                                AppliedVacancy appliedVacancy = list.get(i);
                                Candidate candidate = appliedVacancy.getCandidate();
                                Vacancy vacancy = appliedVacancy.getVacancy();
                                
                                // Safe null check for status
                                String status = appliedVacancy.getStatusByRecruiter();
                                String interviewStage = appliedVacancy.getInterviewStage();
                                if(interviewStage == null || interviewStage.trim().isEmpty()) {
                                    interviewStage = "APPLIED";
                                }
                        %>
                        <tr>
                            <td>
                                <div class="user-cell">
                                    <span class="user-name"><%=candidate.getFname() + " " + candidate.getLname()%></span>
                                    <span class="user-meta"><%=candidate.getGender()%> • <%=candidate.getDate()%></span>
                                </div>
                            </td>
                            <td>
                                <span style="font-weight: 500; color: var(--primary-color);">
                                    <%=vacancy.getPost()%>
                                </span>
                            </td>
                            <td><%=candidate.getQualification()%></td>
                            <td><%=candidate.getExperience()%></td>
                            <td><%=candidate.getApiScore()%></td>
                            <td><%=candidate.getParsedSkills() == null ? "N/A" : candidate.getParsedSkills()%></td>
                            <td>
                                <div class="user-cell">
                                    <span class="user-meta"><i class="fa-solid fa-envelope"></i> <%=candidate.getEmail()%></span>
                                    <span class="user-meta"><i class="fa-solid fa-phone"></i> <%=candidate.getContact()%></span>
                                </div>
                            </td>
                            <td><%=candidate.getAddress()%></td>
                            <td><span class="user-meta" style="font-weight:600;"><%=interviewStage.replace("_", " ")%></span></td>
                            <td>
                                <% if(candidate.getFileData() != null) { %>
                                    <a href="view_resume?email=<%=candidate.getEmail()%>" target="_blank" class="btn-resume">
                                        <i class="fa-regular fa-file-pdf"></i> View PDF
                                    </a>
                                <% } else { %>
                                    <span class="user-meta">No File</span>
                                <% } %>
                            </td>
                            
                            <td>
                                <form action="selectCandidate" method="post" style="margin:0; display:flex; gap:8px; align-items:center;">
                                    <input type="hidden" name="id" value="<%=appliedVacancy.getId()%>">
                                    <select name="status" style="padding:7px; border:1px solid #cbd5e1; border-radius:6px; font-size:12px;">
                                        <option value="Applied" <%= "APPLIED".equalsIgnoreCase(interviewStage) ? "selected" : "" %>>Applied</option>
                                        <option value="Written Test" <%= "WRITTEN_TEST".equalsIgnoreCase(interviewStage) ? "selected" : "" %>>Written Test</option>
                                        <option value="Interview" <%= "INTERVIEW".equalsIgnoreCase(interviewStage) ? "selected" : "" %>>Interview</option>
                                        <option value="HR Round" <%= "HR_ROUND".equalsIgnoreCase(interviewStage) ? "selected" : "" %>>HR Round</option>
                                        <option value="Offered" <%= "OFFERED".equalsIgnoreCase(interviewStage) ? "selected" : "" %>>Offered</option>
                                        <option value="Rejected" <%= "REJECTED".equalsIgnoreCase(interviewStage) ? "selected" : "" %>>Rejected</option>
                                    </select>
                                    <button type="submit" class="btn-select">
                                        <i class="fa-solid fa-floppy-disk"></i> Update
                                    </button>
                                </form>
                            </td>
                        </tr> 
                        <% 
                            } 
                        } else { 
                        %>
                        <tr>
                            <td colspan="11" class="no-data">
                                No candidates have applied for your vacancies yet.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</body>
</html>