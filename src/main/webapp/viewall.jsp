<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %> 
<%@ page language="java" import="gatepass.Database.*" %>

<html>
<head>
    <title>Visitor Details - Modern View</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
            margin: 0;
            padding: 20px;
        }

        h2 {
            text-align: center;
            color: #1e3c72;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* 🔍 Search Bar */
        .search-container {
            text-align: center;
            margin-bottom: 20px;
        }

        .search-bar {
            width: 60%;
            max-width: 500px;
            padding: 10px 15px;
            border: 2px solid #1e3c72;
            border-radius: 25px;
            font-size: 15px;
            outline: none;
            transition: 0.3s;
        }

        .search-bar:focus {
            box-shadow: 0 0 10px rgba(30, 60, 114, 0.3);
            border-color: #324ea8;
        }

        /* Card Layout */
        .visitor-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 20px;
            padding: 10px;
        }

        .visitor-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border-left: 5px solid #1e3c72;
        }

        .visitor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .card-header {
            background: #1e3c72;
            color: #fff;
            text-align: center;
            padding: 10px;
            font-weight: bold;
            font-size: 18px;
        }

        .card-body {
            padding: 15px 20px;
            line-height: 1.6;
            color: #333;
        }

        .card-body strong {
            color: #1e3c72;
        }

        .visitor-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-top: 1px solid #ddd;
            border-bottom: 1px solid #ddd;
        }

        .card-footer {
            padding: 10px 20px;
            text-align: right;
            background: #f4f4f9;
            border-top: 1px solid #eee;
        }

        .print-link {
            text-decoration: none;
            color: #fff;
            background: #1e3c72;
            padding: 6px 12px;
            border-radius: 5px;
            font-size: 13px;
            transition: 0.3s;
        }

        .print-link:hover {
            background: #324ea8;
        }

        /* 🔹 No Results Message */
        #noResults {
            display: none;
            text-align: center;
            color: #888;
            font-size: 16px;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<%
    String id = request.getParameter("id");

    try {
        Connection conn = null;
        gatepass.Database db = new gatepass.Database();    
        conn = db.getConnection();
        String ip = db.getServerIp();

        ResultSet rs;
        Statement st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM visitor ORDER BY id DESC");
%>

<h2>Visitor Records</h2>

<!-- 🔍 Search Bar -->
<div class="search-container">
    <input type="text" id="searchInput" class="search-bar" placeholder="Search by name, officer, ID, purpose, or department...">
</div>

<div class="visitor-container" id="visitorContainer">

<%
    while (rs.next()) {
%>

    <div class="visitor-card">
        <div class="card-header">
            Visitor ID: 
            <a href="print_visitor_card.jsp?id=<%=rs.getInt("ID")%>" 
               class="print-link" 
               onclick="printPagePopUp(this.href); return false;">
               <%=rs.getInt("ID")%>
            </a>
        </div>
        <a href="ShowVisitor.jsp?id=<%=rs.getInt("id")%>" 
               class="visitor-image" 
               onclick="printPagePopUp(this.href); return false;">
               <img class="visitor-Photo" src="ShowVisitor.jsp?id=<%= id %>" 
                     alt="Visitor Photo">
            </a>
		
    

        <div class="card-body">
            <p><strong>Name:</strong> <span class="search-text"><%=rs.getString("NAME")%></span></p>
            <p><strong>Father's Name:</strong> <%=rs.getString("FATHERNAME")%></p>
            <p><strong>Age:</strong> <%=rs.getString("AGE")%></p>
            <p><strong>Address:</strong> 
                <%=rs.getString("ADDRESS")%>, 
                <%=rs.getString("DISTRICT")%>, 
                <%=rs.getString("STATE")%> - 
                <%=rs.getString("PINCODE") %>
            </p>
            <p><strong>Phone:</strong> <%=rs.getString("PHONE")%></p>
            <p><strong>Date of Visit:</strong> <%=rs.getString("ENTRYDATE")%></p>
            <p><strong>Time of Visit:</strong> <%=rs.getString("TIME")%></p>
            <p><strong>Officer to Meet:</strong> <span class="search-text"><%=rs.getString("OFFICERTOMEET")%></span></p>
            <p><strong>Purpose:</strong> <span class="search-text"><%=rs.getString("PURPOSE")%></span></p>
            <p><strong>Material:</strong> <%=rs.getString("MATERIAL")%></p>
            <p><strong>Vehicle:</strong> <%=rs.getString("VEHICLE")%></p>
            <p><strong>Department:</strong> <span class="search-text"><%=rs.getString("DEPARTMENT")%></span></p>
        </div>

        <div class="card-footer">
            <a href="print_visitor_card.jsp?id=<%=rs.getInt("ID")%>" class="print-link">Print Pass</a>
        </div>
    </div>

<%
    }
    rs.close();
    conn.close();
} catch (Exception ex) {
    System.out.print(ex);
}
%>

</div>

<!-- No Results Message -->
<p id="noResults">No matching visitor records found.</p>

<!-- 🔍 Live Search Script -->
<script>
document.getElementById("searchInput").addEventListener("keyup", function() {
    let input = this.value.toLowerCase();
    let cards = document.getElementsByClassName("visitor-card");
    let found = false;

    for (let card of cards) {
        let text = card.innerText.toLowerCase();
        if (text.includes(input)) {
            card.style.display = "";
            found = true;
        } else {
            card.style.display = "none";
        }
    }

    document.getElementById("noResults").style.display = found ? "none" : "block";
});
</script>

</body>
</html>
