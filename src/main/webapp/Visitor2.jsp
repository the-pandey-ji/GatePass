<%@ page language="java" import="java.time.*, java.time.format.DateTimeFormatter,java.sql.*,java.io.*,java.util.Base64,gatepass.CommonService" %>
<%@ page import="gatepass.Database" %>
<!DOCTYPE html>
<html>
<head>
<style>
#webcam-container {
    text-align: center;
    background: #f9fbff;
    border: 1px solid #ccd9ff;
    border-radius: 10px;
    padding: 15px;
    margin-bottom: 20px;
}

#video {
    width: 320px;
    height: 240px;
    border: 1px solid #aaa;
    border-radius: 8px;
    object-fit: cover;
}

#snapshot {
    width: 320px;
    height: 240px;
    border: 1px solid #aaa;
    border-radius: 8px;
    object-fit: cover;
    margin-top: 10px;
}

/* Capture Button Styling */
.capture-btn {
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 10px 20px;
    font-size: 15px;
    cursor: pointer;
    margin-top: 10px;
    transition: all 0.3s ease;
}

.capture-btn:hover {
    background-color: #0056b3;  /* darker blue on hover */
    transform: scale(1.05);     /* slight zoom-in */
}

@media print {
    #webcam-container {
        display: none; /* hide webcam section in print */
    }
}

</style>
<title>Gate Pass Entry</title>
<meta charset="UTF-8">

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
    String imageData = request.getParameter("webcam_image");
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
        ResultSet rs = st.executeQuery("SELECT MAX(ID) FROM visitor2");
        
        /* int id = rs.getInt(1); */
		int id = 1;
        if (rs.next())
        id = rs.getInt(1)+1;
        
        // ✅ Get Photo Base64
        String imageBase64 = request.getParameter("webcam_image");
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

/*         // 3️⃣ Save image to folder if captured
        if (imageData != null && imageData.startsWith("data:image")) {
            imageData = imageData.substring(imageData.indexOf(",") + 1);
            byte[] imgBytes = Base64.getDecoder().decode(imageData);

            String saveDir = "C:/GatepassImages/Visitor/";
            File folder = new File(saveDir);
            if (!folder.exists()) folder.mkdirs();

            File savedImageFile = "visitor_" + id + ".png";
            FileOutputStream fos = new FileOutputStream(saveDir + savedImageFile);
            fos.write(imgBytes);
            fos.close();

            PreparedStatement ps2 = conn.prepareStatement("UPDATE visitor2 SET IMAGE=? WHERE ID=?");
            ps2.setString(1, savedImageFile);
            ps2.setInt(2, id);
            ps2.executeUpdate();
            ps2.close();
        } */

        // 1️⃣ Insert data (without image first)
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO visitor2(ID, NAME,FATHERNAME, ADDRESS,VEHICLE,DISTRICT, STATE, PINCODE,PHONE, MATERIAL, OFFICERTOMEET,PURPOSE,ENTRYDATE, TIME,IMAGE) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
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
        ps.executeUpdate();


        rs.close();
        st.close();
        ps.close();
        conn.close();

        response.sendRedirect("print_visitor_card.jsp?id=" + id);
        return;

    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>❌ Error saving data: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
}

%>

<style>
/* ✅ keep your existing CSS */
body { background-color: #eef1f4; font-family: 'Segoe UI', sans-serif; margin: 0; padding: 0; }
#gatepass { background: #fff; max-width: 850px; margin: 35px auto; padding: 35px 45px; border-radius: 12px; box-shadow: 0px 6px 25px rgba(0,0,0,0.18); }
h2 { text-align: center; color: #222; margin-bottom: 25px; font-weight: 700; letter-spacing: .5px; }
.form-row { display: flex; gap: 20px; margin-bottom: 18px; }
.form-group { flex: 1; }
label { display: block; margin-bottom: 5px; font-weight: 600; color: #444; }
input, textarea, select { width: 100%; padding: 10px; font-size: 15px; border: 1px solid #bbb; border-radius: 6px; transition: .3s; }
input:focus, textarea:focus, select:focus { border-color: #007BFF; box-shadow: 0 0 8px rgba(0,123,255,0.4); outline: none; }
#webcam-container { text-align: center; background: #f9fbff; border: 1px solid #ccd9ff; border-radius: 10px; padding: 15px; margin-bottom: 20px; }
#video, #snapshot { width: 320px; height: 240px; border: 1px solid #aaa; border-radius: 8px; object-fit: cover; }
.btn-row { text-align: center; margin-top: 20px; }
button { padding: 12px 30px; border: none; border-radius: 6px; cursor: pointer; font-size: 15px; margin: 0 10px; transition: .3s; }
.save-btn { background: #007bff; color: white; } .save-btn:hover { background: #0056b3; }
.reset-btn { background: #6c757d; color: white; } .reset-btn:hover { background: #4e555b; }
</style>

<script>


let videoStream;
function startWebcam() {
    navigator.mediaDevices.getUserMedia({ video: true })
    .then(stream => { videoStream = stream; document.getElementById('video').srcObject = stream; })
    .catch(err => alert("Webcam Error: " + err));
}

function takeSnapshot() {
    const video = document.getElementById('video');
    const canvas = document.createElement('canvas');
    canvas.width = 320;
    canvas.height = 240;
    const ctx = canvas.getContext('2d');
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
    const dataURL = canvas.toDataURL("image/png");
    document.getElementById('snapshot').src = dataURL;
    document.getElementById('webcam_image').value = dataURL;
}

window.onload = startWebcam;
</script>
</head>
<body>

<div id="gatepass">
    <h2>Gate Pass Entry Form</h2>

<form method="post" name="text_form" action="Visitor2.jsp">
<input type="hidden" name="webcam_image" id="webcam_image">

<div class="form-row">
    <div class="form-group">
        <label>Name</label>
        <input type="text" name="name">
    </div>
    <div class="form-group">
        <label>Father Name</label>
        <input type="text" name="fathername">
    </div>
</div>

<div class="form-row">
    <div class="form-group">
        <label>Department</label>
        <input type="text" name="department">
    </div>
    <div class="form-group">
        <label>Material</label>
        <input type="text" name="material">
    </div>
</div>
<div class="form-row">
    <div class="form-group">
        <label>Address</label>
        <input type="text" name="address">
    </div>
    <div class="form-group">
    <label>State <span style="color:red;">*</span></label>
    <input type="text" name="state" id="state" readonly required>
  </div>
</div>
<div class="form-row">
  <div class="form-group">
    <label>District <span style="color:red;">*</span></label>
    <input type="text" name="district" id="district" readonly required>
  </div>
   <div class="form-group">
    <label>Pincode <span style="color:red;">*</span></label>
    <input type="text" name="pincode" id="pincode" maxlength="6" required onblur="fetchOfflinePincodeDetails()">
  </div>
</div>






<div class="form-row">
    <div class="form-group">
        <label>Telephone</label>
        <input type="text" name="number">
    </div>
    <div class="form-group">
        <label>Vehicle Number</label>
        <input type="text" name="vehicle">
    </div>
</div>

<div class="form-row">
    <div class="form-group">
        <label>Officer to Meet</label>
        <input type="text" name="officertomeet">
    </div>
</div>
<%
    // Get current system date and time
    LocalDate currentDate = LocalDate.now();
    LocalTime currentTime = LocalTime.now();

    // Format them for HTML input elements
    String formattedDate = currentDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    String formattedTime = currentTime.format(DateTimeFormatter.ofPattern("HH:mm"));
%>

<div class="form-row">
    <div class="form-group">
        <label>Date</label>
        <input type="date" name="date" value="<%= formattedDate %>" readonly>
    </div>
    <div class="form-group">
        <label>Time</label>
        <input type="time" name="time" value="<%= formattedTime %>" readonly>
    </div>
</div>

<div class="form-row">
    <div class="form-group">
        <label>Purpose</label>
        <textarea name="purpose" rows="3"></textarea>
    </div>
</div>

<div id="webcam-container">
    <video id="video" autoplay></video><br>
    <button type="button" onclick="takeSnapshot()" class="capture-btn">
        Capture Photo
    </button><br>
    <img id="snapshot">
</div>

<div class="btn-row">
    <button class="save-btn" type="submit">Save</button>
    <button class="reset-btn" type="reset">Reset</button>
</div>

</form>
</div>

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
