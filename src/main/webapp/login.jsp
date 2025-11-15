<%@ page language="java" import="java.io.*, java.sql.*, java.util.*, gatepass.Database" pageEncoding="UTF-8" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String formSubmitted = request.getParameter("formSubmitted");
    boolean loginSuccess = false;

    if ("true".equals(formSubmitted)) {
        if ("gatepass".equals(username) && "gatepass".equals(password)) {
            loginSuccess = true;
            session.setAttribute("username", username);
        } else {
            request.setAttribute("error", "*Incorrect Username or Password");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gate Pass Management System</title>
<link rel="stylesheet" href="index2.css">
<script src="login.js"></script>


<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* === GLOBAL === */
body {
    background-color: #f4f7f6;
    color: #333;
    min-height: 100vh;
    overflow-x: hidden;
}

/* === HEADER (Cleaned up: only Logos and Title) === */
.header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 10px 20px; 
    background: linear-gradient(90deg, #1e3c72 0%, #2a5298 100%); 
    color: white;
    position: fixed;
    width: 100%;
    top: 0;
    z-index: 1000;
    box-shadow: 0 4px 15px rgba(0,0,0,0.3);
    height: 110px;
}

/* Logo Styling */
.logo {
    height: 85px;
    filter: drop-shadow(0 0 5px rgba(255, 255, 255, 0.2));
    transition: transform 0.2s;
    flex-shrink: 0; /* Ensures logos don't shrink */
}
.logo:hover {
    cursor: pointer;
    transform: scale(1.05);
}

/* Center Title */
.center-text {
    text-align: center;
    flex-grow: 1;
    padding: 0 20px;
}
.center-text h1 {
    font-size: 30px;
    font-weight: 800;
    letter-spacing: 1px;
    margin-bottom: 2px;
}
.center-text h2 {
    font-size: 17px;
    font-weight: 500;
    opacity: 0.9;
}

/* ------------------------------------------------------------------- */
/* === DROPDOWN NAVIGATION MENU STYLES === */
/* ------------------------------------------------------------------- */
.navbar {
    position: fixed;
    top: 110px;
    left: 0;
    width: 100%;
    height: 50px;
    background: #ffffff;
    border-bottom: 2px solid #1e3c72;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    z-index: 999;
    /* Use flex to align menu items and buttons */
    display: flex; 
    justify-content: space-between; /* Push menu to left, buttons to right */
}

/* Menu List Container */
.navbar ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    display: flex;
    height: 100%;
}
.navbar ul li {
    display: block;
    position: relative;
    line-height: 50px;
    text-align: center;
}
.navbar ul li a.main-link {
    display: block;
    padding: 0 20px;
    text-decoration: none;
    color: #1e3c72;
    font-weight: 600;
    transition: background-color 0.3s, color 0.3s;
    border-right: 1px solid #eaeaea;
}
.navbar ul li:hover > a.main-link {
    background: #1e3c72;
    color: #ffffff;
}

/* Dropdown Sub-menu */
.dropdown-content {
    display: none;
    position: absolute;
    top: 50px;
    left: 0;
    min-width: 250px;
    background-color: #ffffff;
    box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
    z-index: 1000;
    text-align: left;
    border: 1px solid #1e3c72;
    border-top: none;
}
.dropdown-content a {
    color: #333;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
    font-weight: 500;
    white-space: nowrap;
    border-bottom: 1px solid #f0f0f0;
}
.dropdown-content a:hover {
    background-color: #e3f2fd;
    color: #1e3c72;
}
.navbar ul li:hover .dropdown-content {
    display: block;
}

/* === ACTION BUTTONS (Moved into Navbar) === */
.action-buttons-container {
    display: flex;
    align-items: center;
    padding: 0 15px; /* Add padding on the right side */
    height: 100%;
}

.action-button {
    color: white;
    border: none;
    padding: 8px 15px;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    text-decoration: none;
    margin-left: 10px;
    transition: background-color 0.3s, transform 0.1s;
}

.change-password-button {
    background: #007bff; 
}
.change-password-button:hover {
    background: #0056b3;
    transform: translateY(-1px);
}

.logout-button {
    background: #d9534f; 
}
.logout-button:hover {
    background: #c9302c;
    transform: translateY(-1px);
}

/* ------------------------------------------------------------------- */
/* === MAIN CONTENT AREA & FOOTER (Kept Consistent) === */
/* ------------------------------------------------------------------- */
.main-content {
    position: fixed;
    top: 160px; /* Header (110px) + Navbar (50px) */
    left: 0;
    right: 0;
    bottom: 50px;
    background: #f4f7f6;
    overflow: hidden;
    z-index: 500;
}
.main-content iframe {
    width: 100%;
    height: 97%;
    border: none;
    background: transparent;
}
.footer {
	display:flex;
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    background-color: #1e3c72;
    color: #fff;
    text-align: center;
    padding: 8px 0;
    font-size: 13px;
    align-items:center;
    justify-content:center;
    height: 50px;
    z-index: 1000;
}
.footer img{
      height: 34px;
    }
}
</style>

<script>
function confirmLogout() {
    if (confirm("Are you sure you want to log out of the Gate Pass Management System?")) {
        window.top.location.href = 'login1.jsp';
    }
}
function changePassword() {
    const iframe = document.getElementsByName("right")[0];
    if (iframe) {
        iframe.src = 'change_password.jsp'; 
    } else {
        alert("Error: Main content frame not found.");
    }
}
</script>
</head>

<body onload="document.login?.username?.focus()">

<%
    if (loginSuccess) {
%>
    <header class="header">
        
        <img src="logo1.png" class="logo" alt="NFL Logo" onclick="window.location.href='login.jsp';">

        <div class="center-text">
            <h1>CISF GATE PASS MANAGEMENT SYSTEM</h1>
            <h2>NATIONAL FERTILIZERS LIMITED, PANIPAT UNIT</h2>
        </div>
        
        <img src="logo2.png" class="logo" alt="CISF Logo" onclick="window.location.href='http://10.3.122.199/';">
        
    </header>

    <nav class="navbar">
        <ul>
        <li>
                <a href="login.jsp" class="main-link">Home</a>
            </li>
            <li>
                <a href="#" class="main-link">Contract</a>
                <div class="dropdown-content">
                    <a href="Contract.jsp" target="right">Contract Registration</a>
                    <a href="Contract_History.jsp" target="right">Contract History</a>
                </div>
            </li>
            
            <li>
                <a href="#" class="main-link">Visitor</a>
                <div class="dropdown-content">
                    <a href="visitor.jsp" target="right">Visitor Gatepass</a>
                    <a href="view.jsp" target="right">View by Date</a>
                    <a href="selectname.jsp" target="right">View by Officer to Meet</a>
                    <a href="viewall.jsp" target="right">View All Visitors</a>
                    <a href="selectstate.jsp" target="right">View Visitors by State</a>
                    <a href="selectid.jsp" target="right">Visitor Revisit</a>
                </div>
            </li>
            <li>
            	<a href="#" class="main-link">Contract Labour/Trainee </a>
                <div class="dropdown-content">
                    <a href="ContractLabour.jsp" target="right">Contract Labour/Trainee Gate Pass</a>
                    <a href="ContractLabourHistory.jsp" target="right">Contract Labour Traine/History</a>
                </div>
            </li>
            <li>
                <a href="#" class="main-link">Foreigner</a>
                <div class="dropdown-content">
                    <a href="ForeignerGatepass.jsp" target="right">Foreigner Gate Pass</a>
                    <a href="ForeignerGatepassHistory.jsp" target="right">Foreigner Pass History</a>
                </div>
            </li>
        </ul>
        
        <div class="action-buttons-container">
            <button class="action-button change-password-button" onclick="changePassword()">
                🔑 Change Password
            </button>
            
            <button class="action-button logout-button" onclick="confirmLogout()">
                🚪 Log Out
            </button>
        </div>
    </nav>

    <main class="main-content">
        <iframe src="" name="right" scrolling="yes"></iframe>
    </main>


<%
    } else {
    	response.sendRedirect("login1.jsp");
    }
%>
<div class="footer">
<img src="logo2.png" alt="CISF Logo">
 &nbsp;
    <p>&copy; <%= java.time.Year.now() %>, IT Department NFL, Panipat</p>
</div>
</body>
</html>