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
<title>Gate Pass Login</title>
<link rel="stylesheet" href="index2.css">
<script src="login.js"></script>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* === PAGE TITLE (used in login screen) === */
.page-title {
    text-align: center;
    font-family: 'Poppins', sans-serif;
    font-size: 26px;
    font-weight: 700;
    letter-spacing: 1px;
    text-transform: uppercase;
    color: #ffffff;
    background: linear-gradient(135deg, #004e92, #000428);
    padding: 15px 20px;
    border-radius: 10px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.3);
    width: fit-content;
    margin: 30px auto;
}

/* === GLOBAL === */
body {
    background-color: #f4f6fb;
    color: #333;
    min-height: 100vh;
    overflow-x: hidden;
}

/* === HEADER === */
.header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 15px 20px;
    background: #1e3c72;
    color: white;
    position: fixed;
    width: 100%;
    top: 0;
    z-index: 1000;
    box-shadow: 0 3px 10px rgba(0,0,0,0.2);
}

.logo {
    height: 80px;
}

.center-text {
    text-align: center;
    flex: 1;
}

.center-text h1 {
    font-size: 28px;
    font-weight: bold;
    margin-bottom: 5px;
}

.center-text h2 {
    font-size: 18px;
    font-weight: 500;
    opacity: 0.9;
}

/* === SIDEBAR === */
.sidebar {
    position: fixed;
    top: 110px;
    left: 0;
    width: 260px;
    bottom: 50px;
    background: #ffffff;
    border-right: 2px solid #1e3c72;
    overflow-y: auto;
    transition: all 0.3s ease;
}

.sidebar table {
    width: 100%;
    border-collapse: collapse;
}

.sidebar td {
    padding: 14px 18px;
    border-bottom: 1px solid #eaeaea;
    transition: all 0.3s ease;
}

.sidebar td:hover {
    background: #1e3c72;
}

.sidebar a {
    color: #1e3c72;
    font-weight: 500;
    text-decoration: none;
    display: block;
}

.sidebar td:hover a {
    color: #ffffff;
}

.sidebar a.logout {
    color: #d9534f !important;
    font-weight: 600;
}

.sidebar a.logout:hover {
    background: #ffe6e6 !important;
    color: #c9302c !important;
}

/* === MAIN CONTENT AREA === */
.main-content {
    position: fixed;
    top: 110px;
    left: 260px;
    right: 0;
    bottom: 50px;
    background-image: url('nfl-bg.jpg'); /* Change this path if needed */
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    overflow: hidden;
    z-index: 500;
}

.main-content iframe {
    width: 100%;
    height: 100%;
    border: none;
    background: transparent;
}

/* === FOOTER === */
iframe.bot {
    width: 100%;
    height: 50px;
    border: none;
    position: fixed;
    bottom: 0;
    left: 0;
    background: #1e3c72;
    color: white;
    z-index: 900;
}

/* === LOGIN SCREEN === */
.login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background: linear-gradient(135deg, #74ABE2, #5563DE);
    padding: 20px;
}

.login-form {
    background: #fff;
    border-radius: 20px;
    padding: 40px 35px;
    width: 100%;
    max-width: 360px;
    text-align: center;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
    animation: slideIn 0.4s ease;
}

@keyframes slideIn {
    from { transform: translateY(40px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
}

.login-form h2 {
    color: #333;
    font-weight: 700;
    margin-bottom: 25px;
}

.login-form input {
    width: 100%;
    padding: 12px;
    margin: 10px 0;
    border: 1px solid #ccc;
    border-radius: 10px;
    font-size: 15px;
    transition: all 0.2s ease;
}

.login-form input:focus {
    border-color: #5563DE;
    box-shadow: 0 0 6px rgba(85, 99, 222, 0.3);
    outline: none;
}

.btn-container {
    display: flex;
    justify-content: space-between;
    margin-top: 10px;
}

.login-form button {
    width: 48%;
    background: #5563DE;
    color: white;
    border: none;
    padding: 10px;
    border-radius: 10px;
    font-size: 15px;
    cursor: pointer;
    transition: 0.3s ease;
}

.login-form button:hover {
    background: #2F3ED7;
}

.error-label {
    color: #ff4d4f;
    margin-top: 12px;
    font-size: 14px;
    display: block;
    animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-5px); }
    to { opacity: 1; transform: translateY(0); }
}
</style>
</head>

<body onload="document.login?.username?.focus()">

<%
    if (loginSuccess) {
%>
    <!-- === DASHBOARD VIEW === -->
    <header class="header">
        <img src="logo1.png" class="logo" alt="Logo 1">
        <div class="center-text">
            <h1>CISF GATE PASS MANAGEMENT SYSTEM</h1>
            <h2>NATIONAL FERTILIZERS LIMITED, PANIPAT UNIT</h2>
        </div>
        <img src="logo2.png" class="logo" alt="Logo 2">
    </header>

    <nav class="sidebar">
        <table>
            <tr><td><a href="ContractLabour.jsp" target="right">Contract Labour/Trainee Gate Pass</a></td></tr>
            <tr><td><a href="ContractLabourHistory.jsp" target="right">Contract Labour History</a></td></tr>
            <tr><td><a href="ForeignerGatepass.jsp" target="right">Foreigner Gate Pass</a></td></tr>
            <tr><td><a href="ForeignerGatepassHistory.jsp" target="right">Foreigner Pass History</a></td></tr>
            <tr><td><a href="visitor.jsp" target="right">Visitor Gatepass</a></td></tr>
            <tr><td><a href="view.jsp" target="right">Visitor View by Date</a></td></tr>
            <tr><td><a href="selectname.jsp" target="right">View by Officer to Meet</a></td></tr>
            <tr><td><a href="viewall.jsp" target="right">View All Visitors</a></td></tr>
            <tr><td><a href="selectstate.jsp" target="right">View Visitors by State</a></td></tr>
            <tr><td><a href="selectid.jsp" target="right">Visitor Revisit</a></td></tr>
            <tr><td><a href="login.jsp" target="_top" class="logout">Logout</a></td></tr>
        </table>
    </nav>

    <main class="main-content">
        <iframe src="pic.jpg" name="right" scrolling="yes"></iframe>
    </main>

    <iframe class="bot" src="footer.html" scrolling="no"></iframe>

<%
    } else {
%>
    <!-- === LOGIN FORM === -->
    <div class="login-container">
        <div class="login-form">
            <h2>Login</h2>
            <form name="login" method="post" action="login.jsp">
                <input type="hidden" name="formSubmitted" value="true">
                <input type="text" name="username" placeholder="Username" maxlength="10" required>
                <input type="password" name="password" placeholder="Password" required>
                <div class="btn-container">
                    <button type="submit">Login</button>
                    <button type="reset">Reset</button>
                </div>
                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                    <label class="error-label"><%= error %></label>
                <% } %>
            </form>
        </div>
    </div>
<%
    }
%>
</body>
</html>
