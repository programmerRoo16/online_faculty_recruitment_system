<%@page import="com.roo.pojo.Candidate"%>
<%@page import="com.roo.pojo.AppliedVacancy"%>
<%@page import="com.roo.pojo.Vacancy"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Dashboard | OFRS</title>
    
    <!-- Fonts and Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- THEME VARIABLES (Teal/Cyan - Matching Recruiter Dashboard) --- */
        :root {
            --primary-color: #0f766e; /* Teal */
            --primary-light: #14b8a6; 
            --primary-hover: #0d9488;
            --secondary-color: #64748B; /* Slate Gray */
            --background-color: #F1F5F9;
            --white: #ffffff;
            --text-dark: #1E293B;
            --border-color: #E2E8F0;
            --danger: #EF4444;
            --success: #10B981;
            --warning: #F59E0B;
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
        /* Teal hover state */
        .nav-links a:hover, .nav-links a.active {
            background-color: #ccfbf1; 
            color: var(--primary-color);
        }
        
        .section-label {
            font-size: 11px;
            text-transform: uppercase;
            color: #94a3b8;
            padding-left: 16px;
            margin: 20px 0 10px;
            font-weight: 600;
        }

        .logout-btn { color: var(--danger) !important; cursor: pointer; }
        .logout-btn:hover { background-color: #fee2e2 !important; }

        /* --- MAIN CONTENT --- */
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

        .user-welcome h2 { font-size: 24px; color: var(--text-dark); }
        .user-welcome p { color: var(--secondary-color); font-size: 14px; margin-top: 5px; }

        .profile-bubble {
            width: 45px; height: 45px; border-radius: 50%;
            background-color: var(--primary-color); color: white;
            display: flex; justify-content: center; align-items: center;
            font-weight: bold; font-size: 18px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        /* --- STATS CARDS --- */
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

        .card h3 { font-size: 14px; color: var(--secondary-color); font-weight: 500; }
        .card .number { font-size: 28px; font-weight: 700; color: var(--text-dark); margin-top: 10px; }
        .card-icon { align-self: flex-end; margin-top: -20px; color: var(--primary-light); font-size: 20px; opacity: 0.5; }

        /* --- TABLES & SECTIONS --- */
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

        table { width: 100%; border-collapse: collapse; min-width: 1000px; }
        th, td { padding: 15px 20px; text-align: left; border-bottom: 1px solid var(--border-color); vertical-align: middle; }
        th { background-color: #F8FAFC; color: var(--secondary-color); font-size: 12px; text-transform: uppercase; font-weight: 600; }
        td { color: var(--text-dark); font-size: 14px; }
        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #F8FAFC; }
        
        /* Status Badges */
        .status-badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; display: inline-block; }
        .status-pending { background-color: #F3F4F6; color: #4B5563; }
        .status-shortlisted { background-color: #D1FAE5; color: #065F46; }
        .status-rejected { background-color: #FEE2E2; color: #991B1B; }

        /* Buttons */
        .btn-apply {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-apply:hover { background-color: var(--primary-hover); }

        .btn-view {
            text-decoration: none;
            color: var(--primary-color);
            font-weight: 500;
            font-size: 13px;
        }
        .btn-view:hover { text-decoration: underline; }

        .no-data { padding: 40px; text-align: center; color: var(--secondary-color); font-style: italic; }
        .message-box { background-color: #ecfdf5; color: var(--success); padding: 10px 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #a7f3d0; font-size: 14px; }
        
       /* --- RESPONSIVE MEDIA QUERIES --- */

@media (max-width: 1024px) {
    .stats-grid {
        grid-template-columns: repeat(2, 1fr); /* 2 columns on tablets */
    }
}

@media (max-width: 768px) {
    body {
        flex-direction: column; /* Stack sidebar on top of content */
        overflow-y: auto;
    }

    /* Adjust Sidebar for Mobile */
    .sidebar {
        width: 100%;
        height: auto;
        border-right: none;
        border-bottom: 1px solid var(--border-color);
        padding: 15px;
    }

    .logo {
        margin-bottom: 15px;
        justify-content: center;
    }

    .nav-links {
        display: flex;
        flex-wrap: wrap;
        gap: 5px;
        justify-content: center;
    }

    .nav-links li {
        margin-bottom: 0;
    }

    .nav-links a {
        padding: 8px 12px;
        font-size: 13px;
    }

    .section-label {
        display: none; /* Hide labels like "Account" to save space */
    }

    /* Adjust Main Content */
    .main-content {
        padding: 20px 15px;
    }

    .top-bar {
        flex-direction: column-reverse;
        text-align: center;
        gap: 15px;
    }

    .stats-grid {
        grid-template-columns: 1fr; /* Single column for stats */
    }

    /* Table Responsiveness */
    .table-container {
        overflow-x: auto; /* Enable horizontal scrolling for wide tables */
        -webkit-overflow-scrolling: touch;
    }

    table {
        min-width: 800px; /* Ensures table doesn't squish too much */
    }

    .section-title {
        flex-direction: column;
        align-items: flex-start;
        gap: 5px;
    }
}

@media (max-width: 480px) {
    .nav-links a span {
        display: none; /* Optional: hide text, show icons only if space is tight */
    }
    
    .user-welcome h2 {
        font-size: 20px;
    }
    
    .card .number {
        font-size: 22px;
    }
}
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="logo">
            <i class="fa-solid fa-graduation-cap"></i>OFRS Candidate 
        </div>
        <ul class="nav-links">
            <li><a href="candidateHome" class="active"><i class="fa-solid fa-grid-2"></i> Dashboard</a></li>
            <li><a href="seeAllVacancies"><i class="fa-solid fa-magnifying-glass"></i> Find Jobs</a></li>
            <li><a href="viewApplieVacancies"><i class="fa-solid fa-file-circle-check"></i> Applications</a></li>
            
            <li class="section-label">Account</li>
            <li><a href="updateProfile"><i class="fa-solid fa-user-gear"></i> My Profile</a></li>
            <li><a href="updatePassword"><i class="fa-solid fa-lock"></i> Security</a></li>
            <li><a href="deactivate" style="color: #ef4444;"><i class="fa-solid fa-trash-can"></i> Deactivate</a></li>
        </ul>
        <ul class="nav-links" style="flex-grow: 0;">
             <li><a href="logout" class="logout-btn"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a></li>
        </ul>
    </div>

    <% 
    Candidate candidate = (Candidate)session.getAttribute("candidate"); 
    String initials = "C";
    String fullName = "Candidate";
    if(candidate != null) {
        fullName = candidate.getFname();
        initials = String.valueOf(candidate.getFname().charAt(0)) + String.valueOf(candidate.getLname().charAt(0));
    }
    
    // Retrieving Lists passed from Controller
    // NOTE: Ensure your controller does: 
    // request.setAttribute("appliedList", appliedList); 
    // request.setAttribute("vacancyList", vacancyList);
    List<AppliedVacancy> appliedList = (List<AppliedVacancy>)request.getAttribute("appliedList");
    List<Vacancy> vacancyList = (List<Vacancy>)request.getAttribute("vacancyList");
    
    int appliedCount = (appliedList != null) ? appliedList.size() : 0;
    int vacancyCount = (vacancyList != null) ? vacancyList.size() : 0;
    %>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        
        <div class="hero-panel">
            <div class="user-welcome">
                <h2>Hello, <%= fullName %>!</h2>
                <p>Your AI-assisted recruitment workspace is ready. Review resume insights, calculate your API score, track each application stage, and apply for matching faculty vacancies faster.</p>
            </div>
            <div class="hero-actions">
                <a href="seeAllVacancies" class="hero-btn primary"><i class="fa-solid fa-magnifying-glass"></i> Find Jobs</a>
                <a href="updateProfile" class="hero-btn"><i class="fa-solid fa-file-arrow-up"></i> Update Resume</a>
                <div class="profile-bubble"><%= initials %></div>
            </div>
        </div>

        <%
        String msg = (String)request.getAttribute("msg");
        if(msg != null){
        %>
            <div class="message-box">
                <i class="fa-solid fa-circle-check"></i> <%= msg %>
            </div>
        <% } %>

        <!-- STATS CARDS -->
        <div class="stats-grid">
            <div class="card">
                <h3>My Applications</h3>
                <div class="number"><%= appliedCount %></div>
                <div class="card-icon"><i class="fa-solid fa-file-circle-check"></i></div>
            </div>
            <div class="card">
                <h3>Open Opportunities</h3>
                <div class="number"><%= vacancyCount %></div>
                <div class="card-icon"><i class="fa-solid fa-briefcase"></i></div>
            </div>
            <div class="card">
                <h3>Profile Status</h3>
                <div class="number" style="font-size: 18px; color: var(--success); margin-top: 15px;">Active</div>
                <div class="card-icon"><i class="fa-solid fa-user-check"></i></div>
            </div>
        </div>

        <div class="section-title">
            <span>AI Profile & API Calculator</span>
        </div>
        <div class="table-container ai-lab">
            <div class="insight-grid">
                <div class="insight-card"><label>Resume Email</label><span><%= candidate != null && candidate.getParsedEmail()!=null ? candidate.getParsedEmail() : "Not extracted" %></span></div>
                <div class="insight-card"><label>Resume Phone</label><span><%= candidate != null && candidate.getParsedPhone()!=null ? candidate.getParsedPhone() : "Not extracted" %></span></div>
                <div class="insight-card"><label>Detected Skills</label><span><%= candidate != null && candidate.getParsedSkills()!=null ? candidate.getParsedSkills() : "Upload a readable PDF resume to auto-fill skills" %></span></div>
                <div class="insight-card"><label>API Score</label><span id="apiScoreValue" class="api-score-number"><%= candidate != null ? candidate.getApiScore() : 0 %></span></div>
            </div>

            <% if(candidate != null) { %>
            <form id="apiScoreForm" class="api-form-grid">
                <input class="api-input" type="number" min="0" name="journalsScopus" placeholder="Scopus Journals">
                <input class="api-input" type="number" min="0" name="journalsUgc" placeholder="UGC Journals">
                <input class="api-input" type="number" min="0" name="books" placeholder="Books">
                <input class="api-input" type="number" min="0" name="conferences" placeholder="Conferences">
                <input class="api-input" type="number" min="0" name="patents" placeholder="Patents">
                <button type="submit" class="btn-apply"><i class="fa-solid fa-calculator"></i> Calculate API</button>
            </form>
            <small id="apiScoreMsg" style="display:block; margin-top:10px; color:#475569;"></small>
            <script>
            (function() {
                var form = document.getElementById('apiScoreForm');
                if (!form) return;
                form.addEventListener('submit', function(e) {
                    e.preventDefault();
                    var data = {
                        journalsScopus: Number(form.journalsScopus.value || 0),
                        journalsUgc: Number(form.journalsUgc.value || 0),
                        books: Number(form.books.value || 0),
                        conferences: Number(form.conferences.value || 0),
                        patents: Number(form.patents.value || 0)
                    };
                    fetch('api/recruitment/candidate/<%=candidate.getEmail()%>/api-score', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify(data)
                    })
                    .then(function(r){ return r.json(); })
                    .then(function(res){
                        if (res && typeof res.apiScore !== 'undefined') {
                            document.getElementById('apiScoreValue').textContent = res.apiScore;
                            document.getElementById('apiScoreMsg').textContent = 'API score updated successfully.';
                        } else {
                            document.getElementById('apiScoreMsg').textContent = 'Unable to calculate API score.';
                        }
                    })
                    .catch(function(){
                        document.getElementById('apiScoreMsg').textContent = 'Request failed. Please try again.';
                    });
                });
            })();
            </script>
            <% } %>
        </div>

        <!-- TABLE 1: RECENT APPLICATIONS -->
        <div class="section-title">
            <span>Recent Applications</span>
            <a href="viewApplieVacancies" class="section-action">View All <i class="fa-solid fa-arrow-right"></i></a>
        </div>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Job Role</th>
                        <th>Recruiter</th>
                        <th>Contact Email</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (appliedCount > 0) { 
                        // Show max 3 recent applications
                        int limit = Math.min(appliedCount, 3);
                        for(int i=0; i<limit; i++) {
                            AppliedVacancy av = appliedList.get(i);
                            String stage = av.getInterviewStage();
                            String badgeClass = "stage-badge stage-applied";
                            String label = (stage == null || stage.trim().isEmpty()) ? "Applied" : stage.replace("_", " ");
                            if("OFFERED".equalsIgnoreCase(stage) || "SHORTLISTED".equalsIgnoreCase(stage)) { badgeClass = "stage-badge stage-offered"; }
                            else if("REJECTED".equalsIgnoreCase(stage)) { badgeClass = "stage-badge stage-rejected"; }
                            else if(!"APPLIED".equalsIgnoreCase(stage)) { badgeClass = "stage-badge stage-progress"; }
                    %>
                    <tr>
                        <td style="font-weight: 500;"><%= av.getVacancy().getPost() %></td>
                        <td><%= av.getRecruiter().getName() %></td>
                        <td><%= av.getRecruiter().getEmail() %></td>
                        <td><span class="<%= badgeClass %>"><i class="fa-solid fa-circle-dot"></i> <%= label %></span></td>
                        <td><a href="viewApplieVacancies" class="btn-view">View Details</a></td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="5" class="no-data">You haven't applied to any jobs yet.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- TABLE 2: AVAILABLE VACANCIES -->
        <div class="section-title">
            <span>Recommended for You</span>
            <a href="seeAllVacancies" class="section-action">Browse All <i class="fa-solid fa-arrow-right"></i></a>
        </div> 

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Job Title</th>
                        <th>Subject</th>
                        <th>Location</th>
                        <th>Criteria</th>
                        <th>Openings</th>
                        <th>Salary</th>
                        <th>Dates (Adv - End)</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (vacancyCount > 0) {
                        // Show max 5 vacancies
                        int limit = Math.min(vacancyCount, 5);
                        for(int i=0; i<limit; i++) {
                            Vacancy v = vacancyList.get(i);
                    %>
                    <tr>
                        <td>
                            <div style="font-weight: 600;"><%= v.getPost() %></div>
                            <div style="font-size: 12px; color: var(--secondary-color);"><%= v.getNameOfRecruiter() %></div>
                        </td>
                        <td><%= v.getSubject() %></td>
                        <td><%= v.getLocation() %></td>
                        <td>
                            <div style="max-width: 150px; font-size: 12px; white-space: normal;"><%= v.getCriteria() %></div>
                        </td>
                        <td style="text-align: center;"><%= v.getNoVacancy() %></td>
                        <td><%= v.getSalary() %></td>
                        <td>
                            <div style="font-size: 11px; color: var(--secondary-color);"><%= v.getAdvDate() %></div>
                            <div style="font-size: 12px; color: #EF4444; font-weight: 500;"><%= v.getLastDate() %></div>
                        </td>
                        <td>
                            <form action="apllyVacancy" method="post" style="margin:0;">
                                <button type="submit" class="btn-apply" name="vid" value="<%=v.getVacancyId()%>">Apply</button>
                            </form>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="8" class="no-data">No active vacancies available.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
    </div>
</body>
</html>