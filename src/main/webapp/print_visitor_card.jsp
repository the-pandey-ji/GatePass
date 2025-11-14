<%@ page import="java.sql.*,gatepass.Database" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Visitor Gate Pass</title>

<style>
body {
    margin: 0;
    padding: 0;
    font-family: Arial, sans-serif;
}

/* Card Layout */
.card {
    width: 340px;
    padding: 10px;
    margin: 20px auto;
    border: 1px solid #000;
    font-size: 12px;
    background-color: #fff;
}

.card table {
    width: 100%;
    border-collapse: collapse;
}

.card td {
    padding: 3px 5px;
    vertical-align: top;
}
h3 {
    text-align: center;
    margin: 5px 0 10px 0;
    font-size: 14px;
    font-weight: bold;
    letter-spacing: 0.5px;
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
String id = request.getParameter("id");

if(id == null || id.trim().isEmpty()) {
%>
<p style="color:red; text-align:center;">Error: Missing or invalid Visitor Pass Number</p>
<%
} else {
    Database db = new Database();
    Connection conn = db.getConnection();
    Statement st = conn.createStatement();

    String query = "SELECT NAME, FATHERNAME, ENTRYDATE, VEHICLE, DISTRICT, STATE, PHONE, PURPOSE, " +
                   "TO_CHAR(SYSDATE, 'DD-MON-YYYY') AS CURR_DATE,AGE " +
                   "FROM visitor WHERE ID=" + id;

    ResultSet rs = st.executeQuery(query);
    if(rs.next()) {
%>

<div class="print-container">
    <button id="printPageButton" class="print-button" onclick="printPage()">Print Gate Pass</button>
</div>

<div class="card">
<h3>VISITOR GATE PASS</h3>
    <table>
	<tr>
            <td colspan="2" style="text-align:center;">
                <img src="ShowVisitor.jsp?id=<%= id %>" 
                     class="photo" alt="Foreigner Photo">
            </td>
        </tr>
        <tr>
            <!-- Left: visitor info -->
            <td><b>Visitor Pass No:</b></td>
            <td><%= id %></td>
        </tr>
        <tr>
        	<td><b>Name:</b></td>
            <td><%= rs.getString("NAME") %></td>
        </tr>
        <tr>
        	<td><b>Father Name:</b></td>
            <td><%= rs.getString("FATHERNAME") %></td>
        </tr>
        <tr>
        	<td><b>AGE:</b></td>
            <td><%= rs.getString("AGE") %></td>
        </tr>
        <tr>
        	<td><b>Vehicle:</b></td>
            <td><%= rs.getString("VEHICLE") %></td>
        </tr>
        <tr>
        	<td><b>District:</b></td>
            <td><%= rs.getString("DISTRICT") %></td>
        </tr>
        <tr>
        	<td><b>State:</b></td>
            <td><%= rs.getString("STATE") %></td>
        </tr>
        <tr>
        	<td><b>Contact:</b></td>
            <td><%= rs.getString("PHONE") %></td>
        </tr>
        <tr>
        	<td><b>Date:</b></td>
            <td><%= rs.getString("ENTRYDATE") %></td>
        </tr>
        <tr>
        	<td><b>Purpose:</b></td>
            <td><%= rs.getString("PURPOSE") %></td>
        </tr>

        <!-- Signature area -->
        <tr><td></td></tr>
         <tr><td></td></tr>

        <tr>
            <td >Sign of Card Holder</td>
            <td >Sign of Issuing Authority</td>
        </tr>
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
        out.println("<p style='color:red;text-align:center;'>Record Not Found</p>");
    }
    rs.close(); st.close(); conn.close();
}
%>

</body>
</html>
