<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="gatepass.Database" %>
<%
%>
<html>
<head>
<title>Contract Registration</title>

<style>
body {
  font-family: "Segoe UI", Arial, sans-serif;
  background: #f4f7f6;
  margin: 0;
  padding: 30px;
}

.container {
  background-color: white;
  width: 90%; 
  max-width: 1000px; /* Slightly wider for better two-column balance */
  margin: auto;
  padding: 30px 40px;
  border-radius: 15px;
  box-shadow: 0px 5px 25px rgba(0,0,0,0.2);
  animation: fadeIn 1s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

h2 {
  text-align: center;
  color: #1e3c72; /* Darker blue for professionalism */
  margin-bottom: 30px;
  letter-spacing: 0.5px;
  font-weight: 600;
}

h3 {
  color: #1e3c72;
  font-size: 1.2em;
  margin-top: 0;
  margin-bottom: 15px;
}

/* Adjust main two-column table */
.main-layout-table {
  width: 100%;
}
.main-layout-table td {
  padding: 10px;
  vertical-align: top;
}

/* Adjust form layout table */
.form-layout-table {
  width: 100%;
}

.form-layout-table td {
  padding: 8px;
  vertical-align: middle;
}

.form-layout-table td:first-child {
  font-weight: bold;
  color: #333;
  width: 35%; /* Reduced width to give more space to input fields */
}

/* Validity Period inputs (Inline arrangement) */
.date-group {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
}

.date-group label {
    font-weight: normal;
    color: #555;
    white-space: nowrap;
    margin-right: 5px;
}

.date-group input[type="date"] {
    flex-grow: 1;
    width: auto !important;
}

input[type="text"], input[type="date"], select {
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 6px;
  width: 95%;
  transition: 0.2s;
  font-size: 14px;
  box-sizing: border-box;
}

input[type="text"]:focus, input[type="date"]:focus, select:focus {
  border-color: #1e3c72;
  box-shadow: 0 0 5px rgba(0,60,114,0.3);
  outline: none;
}

/* Button Styling */
input[type="submit"], input[type="reset"] {
  background-color: #1e3c72;
  border: none;
  color: white;
  padding: 10px 25px;
  font-size: 15px;
  border-radius: 6px;
  cursor: pointer;
  transition: 0.3s;
  margin: 5px 10px 5px 0;
}

input[type="submit"]:hover, input[type="reset"]:hover {
  background-color: #0078d4;
  transform: translateY(-1px);
}

/* Document Upload Container (Right Column) */
.document-upload-container {
  text-align: center;
  background: #f8faff;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0px 3px 15px rgba(0,0,0,0.1);
  margin-top: 20px;
  border: 1px dashed #ccc;
  min-height: 400px; /* Give it some vertical presence */
}

.document-upload-container input[type="file"] {
    width: 90%;
    margin: 15px auto;
    border: none;
    padding: 10px;
    background: #e9ecef;
    border-radius: 5px;
    cursor: pointer;
    font-size: 14px;
}
.document-upload-container input[type="file"]:hover {
    background: #dee2e6;
}

</style>

<script>
    function capLtr(value, fieldId) {
        let input = document.getElementById(fieldId);
        if (input) {
            input.value = value.toUpperCase();
        }
    }

    function validateForm() {
        let fromDate = new Date(document.getElementById('valdity_fromDate').value);
        let toDate = new Date(document.getElementById('valdity_toDate').value);

        if (fromDate && toDate && fromDate > toDate) {
            alert("Validity 'From Date' cannot be after 'To Date'.");
            return false;
        }
        return true; 
    }
</script>


<%
// 1. Database connection and ID generation
Connection conn1 = null;
Statement st1 = null;
ResultSet rs1 = null;
int id = 1;

try {
    gatepass.Database db1 = new gatepass.Database();
    conn1 = db1.getConnection();
    st1 = conn1.createStatement();
    // Assuming Oracle NVL function for handling the initial NULL max value
    rs1 = st1.executeQuery("SELECT NVL(MAX(ID), 1) + 1 FROM GATEPASS_CONTRACT");
    if (rs1.next()) {
        id = rs1.getInt(1);
    }
} catch (SQLException e) {
    System.err.println("Database error generating contract ID: " + e.getMessage());
} finally {
    if (rs1 != null) try { rs1.close(); } catch (SQLException ignore) {}
    if (st1 != null) try { st1.close(); } catch (SQLException ignore) {}
    if (conn1 != null) try { conn1.close(); } catch (SQLException ignore) {}
}
%>

</head>

<body onkeydown="if(event.keyCode==13){event.keyCode=9; return event.keyCode}">
<div class="container">
  <h2>Contract Registration</h2>
  
  <form action="saveContract" method="post" 
        name="text_form" enctype="multipart/form-data" 
        onsubmit="return validateForm()">
        
    <input type="hidden" id="imageData" name="imageData">
    
    <table class="main-layout-table">
        <tr>
            <td width="60%">
                <table class="form-layout-table">
                	<tr>
                        <td>WorkSite.</td>
                        <td><input type="text" name="worksite" value="NFL Panipat" readonly /></td>
                    </tr>
                    <tr>
                        <td>Contract No.</td>
                        <td><input type="text" name="id" value="<%=id%>" readonly /></td>
                    </tr>

                    <tr>
                        <td>Contract Name</td>
                        <td><input type="text" id="name" name="name" 
                                   onkeyup="capLtr(this.value, 'name');" 
                                   onkeypress="return /[A-Za-z\s]/.test(event.key);" 
                                   required/></td>
                    </tr>

                    <tr>
                        <td>Contract Type</td>
                        <td><input type="text" id="type" name="type" 
                                   onkeyup="capLtr(this.value, 'type');" 
                                   onkeypress="return /[A-Za-z\s]/.test(event.key);" 
                                   required/></td>
                    </tr>
                    
                    <tr>
                        <td>Contractor Name</td>
                        <td><input type="text" id="ContractorName" name="Contractor" 
                                   onkeyup="capLtr(this.value, 'ContractorName');" 
                                   onkeypress="return /[A-Za-z\s]/.test(event.key);" 
                                   required/></td>
                    </tr>

                    <tr>
                        <td>Department</td>
                        <td><input type="text" id="dept" name="dept" 
                                   onkeyup="capLtr(this.value, 'dept');" 
                                   onkeypress="return /[A-Za-z\s]/.test(event.key);" 
                                   required/></td>
                    </tr>

                    <tr>
                        <td>Contractor Address</td>
                        <td><input type="text" id="address" name="address" 
                                   onkeyup="capLtr(this.value, 'address');" 
                                   onkeypress="return /[A-Za-z0-9\s,.-]/.test(event.key);" 
                                   required/></td>
                    </tr>

                    <tr>
                        <td>Contractor Adhar No.</td>
                        <td><input type="text" id="adhar" name="adhar" 
                                   onkeyup="capLtr(this.value, 'adhar');" 
                                   onkeypress="return /[0-9]/.test(event.key);" 
                                   maxlength="12"
                                   required/></td>
                    </tr>

                    <tr>
                        <td>Contract Registration No.</td>
                        <td><input type="text" id="reg" name="reg" 
                                   onkeyup="capLtr(this.value, 'reg');" 
                                   onkeypress="return /[A-Za-z0-9\s]/.test(event.key);" 
                                   required/></td>
                    </tr>

                    <tr>
                        <td>Validity Period</td>
                        <td>
                            <div class="date-group">
                                <label for="valdity_fromDate">From:</label>
                                <input type="date" id="valdity_fromDate" name="valdity_fromDate" required />
                                
                                <label for="valdity_toDate">To:</label>
                                <input type="date" id="valdity_toDate" name="valdity_toDate" required />
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td>Description</td>
                        <td><input type="text" id="desp" name="desp" 
                                   onkeyup="capLtr(this.value, 'desp');" 
                                   required/></td>
                    </tr>
                    
                    <tr>
                        <td></td>
                        <td>
                            <input type="submit" value="Register Contract">
                            <input type="reset" value="Clear Form">
                        </td>
                    </tr>
                </table>
            </td>
            
            <td width="40%">
                <div class="document-upload-container">
                    <h3>Contract Document Upload 📄</h3>
                    <input type="file" id="Document" name="Document" 
                           accept=".pdf, .doc, .docx, .jpg, .jpeg, .png"  />
                    <p style="font-size: 13px; color: #555;">
                        (Max size 5MB. Accepted formats: PDF, DOC, DOCX, JPG. JPEG, PNG.)
                        (OPTIONAL)
                    
                    </p>
                    </div>
            </td>
        </tr>
    </table>
  </form>
</div>
</body>
</html>