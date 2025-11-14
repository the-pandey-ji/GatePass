<%@ page language="java" import="java.sql.*" %>
<%@page import="java.lang.*" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@page import="org.apache.commons.fileupload.FileUploadException" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@page import="org.apache.commons.io.output.*" %>
<%@page import="java.io.*" %>
<%@ page language="java" import="gatepass.Database.*" %>

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
    alert("Camera not supported in this browser.");
    return;
  }

  navigator.mediaDevices.getUserMedia({ video: true })
    .then(stream => {
      currentStream = stream;
      video.srcObject = stream;
    })
    .catch(err => {
      alert("Error accessing camera: " + err.message);
    });
}

function capturePhoto() {
  const video = document.getElementById("video");
  const canvas = document.getElementById("canvas");
  const previewImg = document.getElementById("photoPreview");

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

  alert("Photo captured successfully!");
}

function retakePhoto() {
  const previewImg = document.getElementById("photoPreview");
  previewImg.style.display = "none";
  openCamera();
}

function capLtr(value, id) {
	  document.getElementById(id).value = value.toUpperCase();
	}


function validateForm() {
	  const imageData = document.getElementById("imageData").value;
	  if (!imageData) {
	    alert("Please capture a photo before submitting!");
	    return false;
	  }
	  return true;
	}
	
	
// === Existing AJAX & Validation Functions ===
function retrieveSerNoDetails() {
  var refNo = document.getElementById('refNo').value; 
  var urlRefNoDetails = "LabourGatePassSerNoDetail?refNo=" + refNo;

  if (window.XMLHttpRequest) {
    reqRefNoDetails = new XMLHttpRequest();
    reqRefNoDetails.onreadystatechange = processStateChangeRefNoDetails;
    reqRefNoDetails.open("GET", urlRefNoDetails, true);
    reqRefNoDetails.send(null);
  } else if (window.ActiveXObject) {
    reqRefNoDetails = new ActiveXObject("Microsoft.XMLHTTP");
    if (reqRefNoDetails) {
      reqRefNoDetails.onreadystatechange = processStateChangeRefNoDetails;
      reqRefNoDetails.open("GET", urlRefNoDetails, true);
      reqRefNoDetails.send();
    }
  }
}

function processStateChangeRefNoDetails() {
  if (reqRefNoDetails.readyState == 4 && reqRefNoDetails.status == 200) {
    var eQtrArr = reqRefNoDetails.responseText.split('|');
    var fields = ["name","fatherName","desig","age","localAddress","permanentAddress","contrctrNameAddress","identification","vehicleNumber"];
    for (let i=0; i<fields.length; i++) {
      document.getElementById(fields[i]).value = (eQtrArr[i] && eQtrArr[i] != "null") ? eQtrArr[i] : "";
    }
  }
}

function enableRefNo() {
  if (text_form.renwlTypeSel.value == "Old") {
    /* alert("Please Enter Previous Serial Number as Ref No.");  */
    text_form.refNo.disabled = false;
  } else {
    text_form.refNo.disabled = true;
  }
}




</script>

<!-- 🌈 Modern CSS Styling -->
<style>
body {
  font-family: "Segoe UI", Arial, sans-serif;
  background: linear-gradient(135deg, #74ebd5, #ACB6E5);
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

input[type="text"], select {
  padding: 7px;
  border: 1px solid #ccc;
  border-radius: 6px;
  width: 95%;
  transition: 0.2s;
  font-size: 14px;
}

input[type="text"]:focus, select:focus {
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

footer {
  text-align: center;
  font-size: 12px;
  color: #777;
  margin-top: 15px;
}
</style>

<%
gatepass.Database db1 = new gatepass.Database();
Connection conn1 = db1.getConnection();
Statement st1 = conn1.createStatement();
int id = 1;

ResultSet rs1 = st1.executeQuery("select max(SER_NO)+1 from GATEPASS_CONTRACT_LABOUR");
if (rs1.next())  id = rs1.getInt(1); 
rs1.close(); st1.close(); conn1.close();
%>

 	

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
                  <select name="renwlTypeSel" onchange="enableRefNo(this);">
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
  <td>Contractor’s Name / Address</td>
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
<footer>© <%= java.time.Year.now() %> Gate Pass Management System | NFL Panipat </footer>
</body>
</html>
