<%@ page language="java" import="java.util.*,java.sql.*,java.io.*,gatepass.Database" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Foreigner Gate Pass</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<style>
body {
    font-family: Arial, sans-serif;
    background-color: #fff;
    color: #000;
    margin: 10px;
}

.card {
    width: 300px;
    padding: 20px;
    margin: 20px auto;
    border: 1px solid #000;
    background: #fff;
    font-size: 11px;
}

h3 {
    text-align: center;
    margin: 5px 0 10px 0;
    font-size: 14px;
    font-weight: bold;
    letter-spacing: 0.5px;
}

table {
    width: 100%;
    border-collapse: collapse;
}

td {
    padding: 3px 5px;
    vertical-align: top;
    font-size: 11px;
}

.photo {
    width: 95px;
    height: 80px;
    border: 1px solid #000;
    object-fit: cover;
}

.instructions {
    font-size: 10px;
    margin-top: 5px;
}

.print-container {
    text-align: center;
    margin-bottom: 10px;
}

.print-button {
    background-color: #007bff;
    color: #fff;
    border: none;
    padding: 8px 15px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 13px;
}

.print-button:hover {
    background-color: #0056b3;
}

@media print {
    .print-container { display: none; }
    body { margin: 0; }
    @page { size: auto; margin: 0mm; }
}
</style>

<script>
function printPage() {
    const btn = document.getElementById("printPageButton");
    btn.style.display = 'none';
    window.print();
    btn.style.display = 'inline-block';
}

function printPagePopUp(refNo) {
    const w = window.open(refNo, 'print', 'left=10,top=10,width=350,height=470');
    if (window.focus) w.focus();
    w.print();
}
</script>
</head>

<body>

<%
String srNo = request.getParameter("srNo");
if (srNo == null || srNo.trim().isEmpty()) {
%>
<p style="color:red;text-align:center;">Error: Missing or invalid Gate Pass Serial Number.</p>
<%
} else {
	Database db = new Database();
	Connection conn = null;
	Statement st=null;
	ResultSet rs = null;
    try {
        conn = db.getConnection();
        st = conn.createStatement();
        String qry = "SELECT SER_NO,VISIT_DEPT,WORKSITE,NAME,FATHER_NAME,DESIGNATION,AGE,LOCAL_ADDRESS,PERMANENT_ADDRESS,NATIONALITY,"
                   + "TO_CHAR(VALIDITY_PERIOD_FROM,'DD-MON-YYYY'),TO_CHAR(VALIDITY_PERIOD_TO,'DD-MON-YYYY'),PHOTO_IMAGE,TO_CHAR(SYSDATE,'MM-MON-YYYY') "
                   + "FROM GATEPASS_FOREIGNER WHERE SER_NO='" + srNo + "'";
        System.out.println("Select all data from Qry--" + qry);
        rs = st.executeQuery(qry);

        if (rs.next()) {
%>

<div class="print-container">
    <button id="printPageButton" class="print-button" onclick="printPage()">🖨️ Print Gate Pass</button>
</div>

<div class="card">
    <h3>FOREIGNER GATE PASS</h3>
    <table >
    <tr>
            <td colspan="2" style="text-align:center;">
                <img src="ShowImageForeigner.jsp?srNo=<%= rs.getString("SER_NO") %>" 
                     class="photo" alt="Foreigner Photo">
            </td>
        </tr>
        <tr>
            <td><b>Gate Pass No:</b></td>
            <td><%= rs.getString(1) %></td>
        </tr>
        <tr>
            <td><b>Visiting Dept:</b></td>
            <td><%= rs.getString(2) %></td>
        </tr>
        <tr>
            <td colspan="2" style="text-align:center;"><b>(Work Site: NFL, Panipat)</b></td>
        </tr>

        <tr>
            <td><b>Name:</b></td>
            <td><%= rs.getString(4) %></td>
        </tr>
        <tr>
            <td><b>Father's Name:</b></td>
            <td><%= rs.getString(5) %></td>
        </tr>
        <tr>
            <td><b>Designation:</b></td>
            <td><%= rs.getString(6) %></td>
        </tr>
        <tr>
            <td><b>Age:</b></td>
            <td><%= rs.getString(7) %></td>
        </tr>
        <tr>
            <td><b>Local Address:</b></td>
            <td><%= rs.getString(8) %></td>
        </tr>
        <tr>
            <td><b>Permanent Address:</b></td>
            <td><%= rs.getString(9) %></td>
        </tr>
        <tr>
            <td><b>Nationality:</b></td>
            <td><%= rs.getString(10) %></td>
        </tr>

        <tr>
            <td><b>Valid From:</b></td>
            <td><%= rs.getString(11) %></td>
        </tr>
        <tr>
            <td><b>Valid Upto:</b></td>
            <td><%= rs.getString(12) %></td>
        </tr>
        <tr>
            <td><b>Date of Issue:</b></td>
            <td><%= rs.getString(14) %></td>
        </tr>

        <tr><td></td></tr>
         <tr><td></td></tr>

        <tr>
            <td >Sign of Card Holder</td>
            <td >Sign of Issuing Authority</td>
        </tr>
    </table>
	<br><br>
    <div class="instructions">
        <b>Instructions:</b><br>
        1. This card must be produced before security staff on demand.<br>
        2. This card is non-transferable.<br>
        3. Loss of card must be reported immediately to the issuing authority.<br>
        4. The contractor does not guarantee employment. This only permits entry to the factory when required by the contractor.
    </div>
</div>

<%
        } else {
            out.println("<p style='color:red;text-align:center;'>No record found for Serial No: " + srNo + "</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (st != null) try { st.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
}
%>

</body>
</html>
