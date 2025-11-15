<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.io.output.*"%>
<%@ page language="java" import="gatepass.Database.*"%>

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
gatepass.Database db1 = new gatepass.Database();
Connection conn = null;
Statement st = null;
ResultSet rs = null;
int id = 1;

try {
    conn = db1.getConnection();
    st = conn.createStatement();
    rs = st.executeQuery("select max(SER_NO)+1 from GATEPASS_FOREIGNER");
    if (rs.next())
	    id = rs.getInt(1);
} catch (SQLException e) {
    System.err.println("Database error generating Sr. No.: " + e.getMessage());
} catch (Exception e) {
    System.err.println("General error generating Sr. No.: " + e.getMessage());
} finally {
    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
    if (st != null) try { st.close(); } catch (SQLException ignore) {}
    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
}
%>
<html>
<head>
<title>Foreigner Gate Pass</title>

<!-- 📷 Camera Script -->
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
		  console.error("Camera not supported in this browser.");
		  return;
		  } 
	  navigator.mediaDevices.getUserMedia({ video: true }) .then(stream => { 
		  currentStream = stream;
		  video.srcObject = stream;
		  }) .catch(err => { console.error("Error accessing camera: " + err.message);
		  });
	  } 
  function capturePhoto() {
	  const video = document.getElementById("video");
	  const canvas = document.getElementById("canvas");
	  const previewImg = document.getElementById("photoPreview");

      if (video.style.display === 'none' || video.paused) {
          console.error("Video feed not active.");
          return; 
      }
      
	  const context = canvas.getContext("2d");
	  context.drawImage(video, 0, 0, canvas.width, canvas.height);
	  if (currentStream) { currentStream.getTracks().forEach(track => track.stop());
	  } 
	  const dataUrl = canvas.toDataURL("image/png");
	  previewImg.src = dataUrl;
	  previewImg.style.display = "block";
	  video.style.display = "none";
	  canvas.style.display = "none";
	  // ✅ Save image to hidden field 
	  document.getElementById("imageData").value = dataUrl;
	  // alert("Photo captured successfully!"); // Removed alert
	  } 
  function retakePhoto() { 
	  const previewImg = document.getElementById("photoPreview");
	  previewImg.style.display = "none"; 
      document.getElementById("imageData").value = ""; // Clear old data
      openCamera();
	  } 
  function capLtr(value, id) {
	  const input = document.getElementById(id);
      if (input) {
	      input.value = value.toUpperCase();
      }
	  } 
  function validateForm() {
	  const imageData = document.getElementById("imageData").value;
	  if (!imageData) { 
          // alert("Please capture a photo before submitting!"); // Removed alert
          console.error("Please capture a photo before submitting!");
	      return false; 
	  }
	  return true; 
	  } 
  
  </script>
<!-- 🌈 Modern CSS Styling -->
<style>
body {
	font-family: "Segoe UI", Arial, sans-serif;
	background: #f4f7f6;
	margin: 0;
	padding: 30px;
}

.container {
	background-color: white;
	width: 1100px;
	margin: auto;
	padding: 25px 40px;
	border-radius: 15px;
	box-shadow: 0px 5px 25px rgba(0, 0, 0, 0.2);
	animation: fadeIn 1s ease;
}

@
keyframes fadeIn {from { opacity:0;
	transform: translateY(20px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
h2 {
	text-align: center;
	color: #003366;
	margin-bottom: 15px;
}

table {
	width: 100%;
}

input[type="text"], input[type="date"] {
	padding: 6px;
	border: 1px solid #ccc;
	border-radius: 5px;
	width: 90%;
	transition: 0.2s;
}

input[type="text"]:focus, input[type="date"]:focus {
	border-color: #0078d4;
	box-shadow: 0 0 4px rgba(0, 120, 212, 0.3);
	outline: none;
}

button, input[type="submit"], input[type="reset"] {
	background-color: #0078d4;
	border: none;
	color: white;
	padding: 8px 18px;
	font-size: 14px;
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
	box-shadow: 0px 3px 10px rgba(0, 0, 0, 0.1);
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

td {
	vertical-align: top;
	padding: 5px;
}

td:first-child {
	font-weight: bold;
	color: #333;
}
</style>
</head>
<body onload="openCamera()"
	onkeydown="if(event.keyCode==13){event.keyCode=9; return event.keyCode}">
	<div class="container">
		<h2>Foreigner Gate Pass Registration</h2>
		<table>
			<tr>
				<!-- 📝 Left Form -->
				<td width="60%">
					<form action="SaveForeignerGatePasData" method="post"
						name="text_form" onsubmit="return validateForm()">
						<!-- ✅ Hidden field to send Base64 image -->
						<input type="hidden" id="imageData" name="imageData">
						<table cellpadding="6">
							<tr>
								<td>Sr. No.</td>
								<td><input type="text" id ="srNo" name="srNo" value="<%=id%>" readonly /></td>
							</tr>
							<tr>
								<td>Work Site</td>
								<td><input type="text" id ="workSite" name="workSite" value="NFL, PANIPAT"
									readonly /></td>
							</tr>
							<tr>
								<td>Visiting Dept.</td>
								<td><input type="text" id="visitingDept"
									name="visitingDept"
									onkeyup="capLtr(this.value,'visitingDept');" /></td>
							</tr>
							<tr>
								<td>Name</td>
								<td><input type="text" id="name" name="name"
									onkeyup="capLtr(this.value,'name');" /></td>
							</tr>
							<tr>
								<td>Father Name</td>
								<td><input type="text" id="fatherName" name="fatherName"
									onkeyup="capLtr(this.value,'fatherName');" /></td>
							</tr>
							<tr>
								<td>Designation</td>
								<td><input type="text" id="desig" name="desig"
									onkeyup="capLtr(this.value,'desig');" /></td>
							</tr>
							<tr>
								<td>Age</td>
								<td><input type="text" id="age" name="age" size="3" /></td>
							</tr>
							<tr>
								<td>Local Address</td>
								<td><input type="text" id="localAddress"
									name="localAddress"
									onkeyup="capLtr(this.value,'localAddress');" /></td>
							</tr>
							<tr>
								<td>Permanent Address</td>
								<td><input type="text" id="permanentAddress"
									name="permanentAddress"
									onkeyup="capLtr(this.value,'permanentAddress');" /></td>
							</tr>
							<tr>
								<td>Nationality</td>
								<td><input type="text" id="nationality" name="nationality"
									onkeyup="capLtr(this.value,'nationality');" /></td>
							</tr>
							<tr>
								<td>Validity Period</td>
								<td>From: <input type="date" id="valdity_fromDate"
									name="valdity_fromDate" required /><br> To: <input
									type="date" id="valdity_toDate" name="valdity_toDate" required />
								</td>
							</tr>
							<tr>
								<td colspan="2" align="center"><input type="submit"
									value=" Submit" /> <input type="reset" value="Reset" /></td>
							</tr>
						</table>
					</form>
				</td>
				<!-- 📷 Right Camera -->
				<td width="40%">
					<div class="video-container">
						<h3>Live Camera</h3>
						<video id="video" width="320" height="240" autoplay></video>
						<canvas id="canvas" width="320" height="240"
							style="display: none;"></canvas>
						<img id="photoPreview" alt="Captured Photo Preview" /> <br>
						<br>
						<button type="button" onclick="capturePhoto()">Capture
							Photo</button>
						<button type="button" onclick="retakePhoto()">Retake
							Photo</button>
					</div>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>