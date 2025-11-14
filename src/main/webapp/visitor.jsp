<%@ page language="java" import="java.sql.*,java.time.*, java.time.format.DateTimeFormatter,java.sql.*,java.io.*,java.util.Base64,gatepass.CommonService"%>
<%@ page import="java.io.*"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.io.output.*"%>
<%@ page language="java" import="gatepass.Database"%>
<html>
<head>
<title>Visitor Gate Pass</title>

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
		  alert("Camera not supported in this browser.");
		  return;
		  } 
	  navigator.mediaDevices.getUserMedia({ video: true }) .then(stream => { 
		  currentStream = stream;
		  video.srcObject = stream;
		  }) .catch(err => { alert("Error accessing camera: " + err.message);
		  });
	  } 
  function capturePhoto() {
	  const video = document.getElementById("video");
	  const canvas = document.getElementById("canvas");
	  const previewImg = document.getElementById("photoPreview");
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
	  alert("Photo captured successfully!");
	  } 
  function retakePhoto() { 
	  const previewImg = document.getElementById("photoPreview");
	  previewImg.style.display = "none"; openCamera();
	  } 
  function capLtr(value, id) {
	  document.getElementById(id).value = value.toUpperCase();
	  } 
  function validateForm() {
	  const imageData = document.getElementById("imageData").value;
	  if (!imageData) { alert("Please capture a photo before submitting!");
	  return false; 
	  }
	  return true; 
	  } 
  
  </script>
<!-- 🌈 Modern CSS Styling -->
<style>
body {
	font-family: "Segoe UI", Arial, sans-serif;
	background: linear-gradient(135deg, #89f7fe, #66a6ff);
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

input[type="text"] {
	padding: 6px;
	border: 1px solid #ccc;
	border-radius: 5px;
	width: 90%;
	transition: 0.2s;
}

input[type="text"]:focus {
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
<%
if ("POST".equalsIgnoreCase(request.getMethod())) {

    String name = request.getParameter("name");
    String fathername = request.getParameter("fathername");
    String address = request.getParameter("address");
    String vehicle = request.getParameter("vehicle");
    String district = request.getParameter("district");
    String state = request.getParameter("state");
    String pincode = request.getParameter("pincode");
    String telephone = request.getParameter("number");
    String material = request.getParameter("material");
    String officer = request.getParameter("officertomeet");
    String purpose = request.getParameter("purpose");
    String date = request.getParameter("date");
    String time = request.getParameter("time");
    String imageData = request.getParameter("imageData");
    java.sql.Date sqlDate = null;
    if (date != null && !date.isEmpty()) {
        sqlDate = java.sql.Date.valueOf(date);
    }
    
    java.sql.Time sqlTime = null;
    if (time != null && !time.isEmpty()) {
        if (time.length() == 5) time += ":00";  // e.g., "10:25" → "10:25:00"
        sqlTime = java.sql.Time.valueOf(time);
    }
    try {
        Database db = new Database();
        Connection conn = db.getConnection();
        // 2️⃣ Get last inserted record ID
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT MAX(ID) FROM visitor");
        
        /* int id = rs.getInt(1); */
		int id = 1;
        if (rs.next())
        id = rs.getInt(1)+1;
        // ✅ Get Photo Base64
        String imageBase64 = request.getParameter("imageData");
if (imageBase64 == null || imageBase64.trim().isEmpty()) {
    throw new Exception("Please capture a photo before submitting!");
}

if (imageBase64.startsWith("data:image"))
    imageBase64 = imageBase64.substring(imageBase64.indexOf(",") + 1);

byte[] imageBytes = Base64.getDecoder().decode(imageBase64);


        // ✅ Image save to folder
        String saveDir = "C:/GatepassImages/Visitor/";
        File folder = new File(saveDir);
        if (!folder.exists()) folder.mkdirs();

        
        File imageFile = new File(saveDir + "Visitor_" + id + ".png");

        try (FileOutputStream fos = new FileOutputStream(imageFile)) {
            fos.write(imageBytes);
        }

        System.out.println("📷 Image saved at: " + imageFile.getAbsolutePath());
     // 1️⃣ Insert data (without image first)
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO visitor(ID, NAME,FATHERNAME, ADDRESS,VEHICLE,DISTRICT, STATE, PINCODE,PHONE, MATERIAL, OFFICERTOMEET,PURPOSE,ENTRYDATE, TIME,IMAGE,AGE) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		ps.setInt(1, id);
        ps.setString(2, name);
        ps.setString(3, fathername);
        ps.setString(4, address);
        ps.setString(5, vehicle);
        ps.setString(6, district);
        ps.setString(7, state);
        ps.setString(8, pincode);
        ps.setString(9, telephone);
        ps.setString(10, material);
        ps.setString(11, officer);
        ps.setString(12, purpose);
        ps.setDate(13, sqlDate);
        ps.setString(14, time);
     // ✅ Keep image stream open until after executeUpdate
       	FileInputStream fis = new FileInputStream(imageFile);
        ps.setBinaryStream(15, fis, (int) imageFile.length());
        ps.setString(16, request.getParameter("age"));
        ps.executeUpdate();

		rs.close();
		st.close();
		conn.close();
		response.sendRedirect("print_visitor_card.jsp?id=" + id);
        return;
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>❌ Error saving data: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
}
%>
<%
gatepass.Database db1 = new gatepass.Database();
Connection conn1 = db1.getConnection();
Statement st1 = conn1.createStatement();
int id = 1;

ResultSet rs1 = st1.executeQuery("select max(ID) from visitor");
if (rs1.next())  id = rs1.getInt(1)+1; 
rs1.close(); st1.close(); conn1.close();
%>
</head>
<body onload="openCamera()"
	onkeydown="if(event.keyCode==13){event.keyCode=9; return event.keyCode}">
	<div class="container">
		<h2>VISITOR GATEPASS REGISTRATION</h2>
		<table>
			<tr>
				<!-- 📝 Left Form -->
				<td width="60%">
					<form action="visitor.jsp" method="post"
						name="text_form" onsubmit="return validateForm()">
						<!-- ✅ Hidden field to send Base64 image -->
						<input type="hidden" id="imageData" name="imageData">
						<table cellpadding="6">
							<tr>
								<td>Visitor Gatepass No</td>
								<td><input type="text" id ="id" name="id" value="<%=id%>" readonly /></td>
							</tr>
							
							<tr>
								<td>Visiting Department</td>
								<td><input type="text" id="department"
									name="department"
									onkeyup="capLtr(this.value,'visitingDept');" /></td>
							</tr>
							<tr>
								<td>Name</td>
								<td><input type="text" id="name" name="name"
									onkeyup="capLtr(this.value,'name');" /></td>
							</tr>
							<tr>
								<td>Father Name</td>
								<td><input type="text" id="fathername" name="fathername"
									onkeyup="capLtr(this.value,'fathername');" /></td>
							</tr>
							<tr>
								<td>Material</td>
								<td><input type="text" id="material" name="material"
									onkeyup="capLtr(this.value,'material');" /></td>
							</tr>
							<tr>
								<td>Age</td>
								<td><input type="text" id="age" name="age" size="3" /></td>
							</tr>
							<tr>
								<td>Address</td>
								<td><input type="text" id="address"
									name="address"
									onkeyup="capLtr(this.value,'address');" /></td>
							</tr>
							<tr>
								<td>State</td>
								<td><input type="text" id="state"
									name="state"
									onkeyup="capLtr(this.value,'state');" /></td>
							</tr>
							<tr>
								<td>District </td>
								<td><input type="text" id="district"
									name="district"
									onkeyup="capLtr(this.value,'district');" /></td>
							</tr>
							<tr>
								<td>Pincode</td>
								<td><input type="pincode" id="pincode"
									name="state"
									onkeyup="capLtr(this.value,'pincode');" /></td>
							</tr>
							<tr>
								<td>Nationality</td>
								<td><input type="text" id="nationality" name="nationality"
									onkeyup="capLtr(this.value,'nationality');" /></td>
							</tr>
							<tr>
								<td>Telephone</td>
								<td><input type="text" id="number" name="number"
									onkeyup="capLtr(this.value,'number');" /></td>
							</tr>
							<tr>
								<td>Vehicle Number</td>
								<td><input type="text" id="vehicle" name="vehicle"
									onkeyup="capLtr(this.value,'vehicle');" /></td>
							</tr>
							
							<tr><%
    // Get current system date and time
    LocalDate currentDate = LocalDate.now();
    LocalTime currentTime = LocalTime.now();

    // Format them for HTML input elements
    String formattedDate = currentDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    String formattedTime = currentTime.format(DateTimeFormatter.ofPattern("HH:mm"));
%>
							<tr>
								<td>Date</td>
								<td><input type="date" id="date" name="date" value="<%= formattedDate %>" readonly
									onkeyup="capLtr(this.value,'date');" /></td>
							</tr>
							<tr>
								<td>Time</td>
								<td><input type="time" id="time" name="time" value="<%= formattedTime %>" readonly
									onkeyup="capLtr(this.value,'time');" /></td>
							</tr>
							<tr>
								<td>Purpose</td>
								<td><input type="text" id="purpose" name="purpose" 
									onkeyup="capLtr(this.value,'number');" /></td>
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
	<footer>
		©
		<%=java.time.Year.now()%>
		Gate Pass Management System | NFL Panipat
	</footer>
	
	<script>
let pincodeData = {};

async function loadPincodeData() {
  try {
    const response = await fetch("pincode_database.json");
    pincodeData = await response.json();
    console.log("✅ Pincode data loaded successfully");
  } catch (err) {
    console.error("❌ Failed to load pincode data", err);
  }
}

function fetchOfflinePincodeDetails() {
  const pincode = document.getElementById("pincode").value.trim();
  const districtField = document.getElementById("district");
  const stateField = document.getElementById("state");

  districtField.value = "";
  stateField.value = "";

  if (pincode.length !== 6 || isNaN(pincode)) {
    alert("Please enter a valid 6-digit Pincode");
    return;
  }

  const details = pincodeData[pincode];
  if (details) {
    districtField.value = details.district;
    stateField.value = details.state;
  } else {
    alert("Pincode not found in local data. Please check again.");
  }
}

// load JSON when page loads
window.addEventListener("load", loadPincodeData);
</script>
</body>
</html>