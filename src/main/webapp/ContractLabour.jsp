<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.lang.*" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@page import="org.apache.commons.fileupload.FileUploadException" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@page import="org.apache.commons.io.output.*" %>
<%@page import="java.io.*" %>
<%@ page language="java" import="gatepass.Database.*" %>

<%
    // ==========================================================
    // 🛡️ SECURITY HEADERS TO PREVENT CACHING THIS PAGE
    // ==========================================================
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache");    // HTTP 1.0.
    response.setDateHeader("Expires", 0);        // Proxies.

    // ==========================================================
    // 🔑 SESSION AUTHENTICATION CHECK
    // ==========================================================
    // Check if the "username" session attribute exists (set during successful login)
    if (session.getAttribute("username") == null) {
        // If not authenticated, redirect to the main login page
        response.sendRedirect("login.jsp");
        return; // Stop processing the rest of the page
    }
%>

<%
// Database connection and ID generation
// NOTE: I'm wrapping the existing logic in a block to isolate resource management.
gatepass.Database db1 = new gatepass.Database();
Connection conn1 = null;
Statement st1 = null;
ResultSet rs1 = null;
int id = 1;

try {
    conn1 = db1.getConnection();
    st1 = conn1.createStatement();
    rs1 = st1.executeQuery("select max(SER_NO)+1 from GATEPASS_CONTRACT_LABOUR");
    if (rs1.next())  id = rs1.getInt(1); 
    
} catch (SQLException e) {
    System.err.println("Database error generating Sr. No.: " + e.getMessage());
} catch (Exception e) {
    System.err.println("General error generating Sr. No.: " + e.getMessage());
} finally {
    if (rs1 != null) try { rs1.close(); } catch (SQLException ignore) {}
    if (st1 != null) try { st1.close(); } catch (SQLException ignore) {}
    if (conn1 != null) try { conn1.close(); } catch (SQLException ignore) {}
}
%>

<html>
<head>
<title>Contract Labour / Trainee Gate Pass</title>



<!-- Camera Script -->
<script>
let currentStream;

function openCamera() {
  const video = document.getElementById("video");
  const canvas = document.getElementById("canvas");
  const previewImg = document.getElementById("photoPreview");

  canvas.style.display = "none";
  previewImg.style.display = "none";
  video.style.display = "block";

  if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
    // Replace alert() with console log or UI message, as per constraints
    console.error("Camera not supported in this browser."); 
    return;
  }

  navigator.mediaDevices.getUserMedia({ video: true })
    .then(stream => {
      currentStream = stream;
      video.srcObject = stream;
    })
    .catch(err => {
      // Replace alert() with console log or UI message, as per constraints
      console.error("Error accessing camera: " + err.message);
    });
}

function capturePhoto() {
  const video = document.getElementById("video");
  const canvas = document.getElementById("canvas");
  const previewImg = document.getElementById("photoPreview");

  // Ensure video is playing and not hidden before attempting capture
  if (video.style.display === 'none' || video.paused) {
      // Optionally provide a message if the video feed is not active
      return; 
  }

  const context = canvas.getContext("2d");
  context.drawImage(video, 0, 0, canvas.width, canvas.height);

  if (currentStream) {
    currentStream.getTracks().forEach(track => track.stop());
  }

  const dataUrl = canvas.toDataURL("image/png");
  previewImg.src = dataUrl;
  previewImg.style.display = "block";
  video.style.display = "none";
  canvas.style.display = "none";

  // ✅ Save image to hidden field
  document.getElementById("imageData").value = dataUrl;

  // alert("Photo captured successfully!"); // Removed alert as per constraint
}

function retakePhoto() {
  const previewImg = document.getElementById("photoPreview");
  previewImg.style.display = "none";
  document.getElementById("imageData").value = ""; // Clear old data
  openCamera();
}

function capLtr(value, id) {
	  document.getElementById(id).value = value.toUpperCase();
}


function validateForm() {
	  const imageData = document.getElementById("imageData").value;
	  if (!imageData) {
	    // Replace alert() with error display logic if needed
	    console.error("Please capture a photo before submitting!");
	    return false;
	  }
	  return true;
}
	
	
// === Existing AJAX & Validation Functions (Updated to modern JS) ===
let reqRefNoDetails;

function retrieveSerNoDetails() {
  var refNo = document.getElementById('refNo').value; 
  var urlRefNoDetails = "LabourGatePassSerNoDetail?refNo=" + refNo;

  if (refNo.trim() === "") return;

  fetch(urlRefNoDetails)
    .then(response => {
        if (!response.ok) throw new Error('Network response was not ok.');
        return response.text();
    })
    .then(responseText => {
        var eQtrArr = responseText.split('|');
        var fields = ["name","fatherName","desig","age","localAddress","permanentAddress","contrctrNameAddress","identification","vehicleNumber"];
        
        for (let i=0; i<fields.length; i++) {
          const value = (eQtrArr[i] && eQtrArr[i] !== "null") ? eQtrArr[i] : "";
          const element = document.getElementById(fields[i]);
          if (element) {
              element.value = value;
              // Also ensure fields are updated with capLtr logic if needed
              capLtr(value, fields[i]); 
          }
        }
    })
    .catch(error => {
        console.error('Error fetching details:', error);
    });
}

function enableRefNo() {
  const selectElement = document.forms["text_form"].renwlTypeSel;
  const refNoInput = document.getElementById("refNo");

  if (selectElement && refNoInput) {
    if (selectElement.value == "Old") {
      refNoInput.disabled = false;
      refNoInput.focus();
    } else {
      refNoInput.disabled = true;
      refNoInput.value = "";
    }
  }
}

// Initial call to disable refNo if default is "New"
document.addEventListener('DOMContentLoaded', () => {
    enableRefNo();
});

</script>

<!-- 🌈 Modern CSS Styling -->
<style>
body {
  font-family: "Segoe UI", Arial, sans-serif;
  background: #f4f7f6;;
  margin: 0;
  padding: 30px;
}

.container {
  background-color: white;
  width: 1100px;
  margin: auto;
  padding: 25px 40px;
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
  color: #003366;
  margin-bottom: 20px;
  letter-spacing: 0.5px;
}

table {
  width: 100%;
}

td {
  padding: 8px;
  vertical-align: top;
}

td:first-child {
  font-weight: bold;
  color: #333;
  width: 40%;
}

input[type="text"], select, input[type="date"] {
  padding: 7px;
  border: 1px solid #ccc;
  border-radius: 6px;
  width: 95%;
  transition: 0.2s;
  font-size: 14px;
}

input[type="text"]:focus, select:focus, input[type="date"]:focus {
  border-color: #0078d4;
  box-shadow: 0 0 5px rgba(0,120,212,0.3);
  outline: none;
}

button, input[type="submit"], input[type="reset"] {
  background-color: #0078d4;
  border: none;
  color: white;
  padding: 10px 22px;
  font-size: 15px;
  border-radius: 6px;
  cursor: pointer;
  transition: 0.3s;
  margin: 5px;
}

button:hover, input[type="submit"]:hover, input[type="reset"]:hover {
  background-color: #005fa3;
  transform: translateY(-2px);
}

.video-container {
  text-align: center;
  background: #f8faff;
  border-radius: 10px;
  padding: 15px;
  box-shadow: 0px 3px 10px rgba(0,0,0,0.1);
}

#video, #canvas, #photoPreview {
  border-radius: 8px;
  border: 1px solid #ccc;
}

#photoPreview {
  width: 320px;
  height: 240px;
  object-fit: cover;
  display: none;
}


</style>

 	

</head>

<body onload="openCamera()" onkeydown="if(event.keyCode==13){event.keyCode=9; return event.keyCode}">
<div class="container">
  <h2>Contract Labour / Trainee Gate Pass</h2>
  <table>
    <tr>
      <!-- 📝 Left side: form -->
      <td width="60%">
        <form action="saveContractLabourData" method="post" 
              name="text_form" enctype="multipart/form-data" 
              onsubmit="return validateForm()">
              <!-- ✅ Hidden field to send Base64 image -->
              <input type="hidden" id="imageData" name="imageData">
              
              
          <table  cellpadding="6">
            <tr><td>Sr. No.</td>
                <td><input type="text" name="srNo" value="<%=id%>" readonly /></td></tr>

            <tr><td>Pass Type</td>
                <td>
                  <select name="renwlTypeSel" onchange="enableRefNo();">
                    <option value="New">New</option>
                    <option value="Old">Old</option>
                  </select>
                  Ref. No: 
                  <input type="text" id="refNo" name="refNo" disabled="true" onblur="retrieveSerNoDetails();"/>
                </td>
            </tr>

            <tr>
  <td>Name</td>
  <td><input type="text" id="name" name="name" 
             onkeyup="capLtr(this.value,'name');" 
             onkeypress="return /[A-Za-z\s]/.test(event.key);" 
             required/></td>
</tr>

<tr>
  <td>Father Name</td>
  <td><input type="text" id="fatherName" name="fatherName" 
             onkeyup="capLtr(this.value,'fatherName');" 
             onkeypress="return /[A-Za-z\s]/.test(event.key);" 
             required/></td>
</tr>

<tr>
  <td>Designation</td>
  <td><input type="text" id="desig" name="desig" 
             onkeyup="capLtr(this.value,'desig');" 
             onkeypress="return /[A-Za-z\s]/.test(event.key);" 
             required/></td>
</tr>

<tr>
  <td>Age</td>
  <td><input type="text" id="age" name="age" maxlength="2" 
             onkeypress="return /[0-9]/.test(event.key);" 
             required/></td>
</tr>

<tr>
  <td>Local Address</td>
  <td><input type="text" id="localAddress" name="localAddress" 
             onkeyup="capLtr(this.value,'localAddress');" 
             onkeypress="return /[A-Za-z0-9\s,.-]/.test(event.key);" 
             required/></td>
</tr>

<tr>
  <td>Permanent Address</td>
  <td><input type="text" id="permanentAddress" name="permanentAddress" 
             onkeyup="capLtr(this.value,'permanentAddress');" 
             onkeypress="return /[A-Za-z0-9\s,.-]/.test(event.key);" 
             required/></td>
</tr>

<tr>
  <td>Contractor Name / Address</td>
  <td><input type="text" id="contrctrNameAddress" name="contrctrNameAddress" 
             onkeyup="capLtr(this.value,'contrctrNameAddress');" 
             onkeypress="return /[A-Za-z0-9\s,.-]/.test(event.key);" 
             required/></td>
</tr>

<tr>
  <td>Vehicle No.</td>
  <td><input type="text" id="vehicleNumber" name="vehicleNumber" 
             onkeyup="capLtr(this.value,'vehicleNumber');" 
             onkeypress="return /[A-Za-z0-9]/.test(event.key);" 
             maxlength="12" required/></td>
</tr>

<tr>
  <td>Identification Mark</td>
  <td><input type="text" id="identification" name="identification" 
             onkeyup="capLtr(this.value,'identification');" 
             onkeypress="return /[A-Za-z\s]/.test(event.key);" 
             required/></td>
</tr>

<tr>
  <td>Validity Period</td>
<td>
    From:  <input type="date" id="valdity_fromDate" name="valdity_fromDate" required/><br> To:  <input type="date" id="valdity_toDate" name="valdity_toDate" required/>
</td>

</tr>

         
            

            <tr>
              <td colspan="2" align="center">
                <input type="submit" value="Submit"/>
                <input type="reset" value="Reset"/>
              </td>
            </tr>
          </table>
        </form>
      </td>

      <!-- 📷 Right side: Camera -->
      <td width="40%">
        <div class="video-container">
          <h3> Live Camera</h3>
          <video id="video" width="320" height="240" autoplay></video>
          <canvas id="canvas" width="320" height="240" style="display:none;"></canvas>
          <img id="photoPreview" alt="Captured Photo Preview"/>
          <br><br>
          <button type="button" onclick="capturePhoto()"> Capture Photo</button>
          <button type="button" onclick="retakePhoto()"> Retake Photo</button>
        </div>
      </td>
    </tr>
  </table>
</div>

</body>
</html>