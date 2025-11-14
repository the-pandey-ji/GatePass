<%@ page language="java" import="java.sql.*" %>
<%@ page import="gatepass.Database" %>

<html>
<head>
<title>Contract Labour Register</title>


<!-- ✅ Internal Styling -->
<style>
body {
  font-family: 'Segoe UI', sans-serif;
  background: linear-gradient(135deg, #dfe9f3, #ffffff);
  margin: 0;
  padding: 0;
}

.container {
  background: #fff;
  width: 90%;
  max-width: 1100px;
  margin: 40px auto;
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0px 4px 20px rgba(0,0,0,0.1);
}

h2 {
  text-align: center;
  color: #003366;
  margin-bottom: 15px;
  letter-spacing: 1px;
}

.search-bar {
  text-align: center;
  margin-bottom: 20px;
}

.search-bar input {
  width: 60%;
  padding: 10px 15px;
  font-size: 15px;
  border: 1px solid #ccc;
  border-radius: 6px;
  box-shadow: 0px 2px 6px rgba(0,0,0,0.1);
  outline: none;
}

.search-bar input:focus {
  border-color: #1a75cf;
  box-shadow: 0px 2px 8px rgba(26,117,207,0.3);
}

table {
  width: 100%;
  border-collapse: collapse;
  background: #fafafa;
}

th {
  background-color: #1a75cf;
  color: white;
  padding: 10px;
  font-size: 15px;
  text-align: center;
}

td {
  border-bottom: 1px solid #ddd;
  text-align: center;
  padding: 8px;
  font-size: 14px;
}

tr:hover {
  background-color: #f2f8ff;
  transition: 0.3s;
}

a {
  color: #1a75cf;
  font-weight: bold;
  text-decoration: none;
}

a:hover {
  color: #003366;
  text-decoration: underline;
}

.btn-bar {
  text-align: center;
  margin-top: 25px;
}

.btn {
  background: linear-gradient(45deg, #1a75cf, #004d99);
  color: white;
  border: none;
  border-radius: 6px;
  padding: 10px 25px;
  font-size: 15px;
  cursor: pointer;
  transition: 0.3s;
  margin: 0 10px;
}

.btn:hover {
  background: linear-gradient(45deg, #004d99, #1a75cf);
  transform: scale(1.05);
}
</style>

<!-- ✅ JavaScript -->
<script>
function printPagePopUp(refNo){ 
  const newwindow = window.open(refNo, 'print', 'left=10,top=10,height=460,width=340');
  if (window.focus) newwindow.focus();
  return false;
}

function executeCommands(){
  try {
    var WshShell = new ActiveXObject("Wscript.Shell");
    WshShell.run("C://Users/cam.exe");
  } catch(e) {
    console.log("Webcam execution skipped: " + e.message);
  }
}

// ✅ Real-time Search Function
function filterTable() {
  const input = document.getElementById("searchInput");
  const filter = input.value.toUpperCase();
  const table = document.getElementById("registerTable");
  const tr = table.getElementsByTagName("tr");

  for (let i = 1; i < tr.length; i++) {
    const tds = tr[i].getElementsByTagName("td");
    let show = false;
    for (let j = 0; j < tds.length; j++) {
      const td = tds[j];
      if (td && td.textContent.toUpperCase().indexOf(filter) > -1) {
        show = true;
        break;
      }
    }
    tr[i].style.display = show ? "" : "none";
  }
}
</script>
</head>

<body onload="executeCommands();" 
      onkeydown="if(event.keyCode==13){event.keyCode=9; return event.keyCode;}">

<div class="container">
  <h2>CONTRACT LABOUR REGISTER</h2>

  <!-- ✅ Search bar -->
  <div class="search-bar">
    <input type="text" id="searchInput" onkeyup="filterTable()" 
           placeholder="Search by Name, Vehicle No, or any detail...">
  </div>

  <form action="saveContractLabourDetails" method="post" 
        name="text_form" enctype="multipart/form-data"
        onsubmit="return Blank_TextField_Validator()">

    <table id="registerTable">
      <tr>
        <th>SR.NO</th>
        <th>NAME</th>
        <th>FATHER NAME</th>
        <th>DESIGNATION</th>
        <th>AGE</th>
        <th>ADDRESS</th>
        <th>IDENTIFICATION</th>
        <th>VEHICLE NO.</th>
        <th>ISSUE DATE</th>
      </tr>

      <%
      Connection conn1 = null;
      Statement st1 = null;
      ResultSet rs1 = null;
      try {
        Database db1 = new Database();	
        conn1 = db1.getConnection();
        st1 = conn1.createStatement();

        // ✅ Fixed: Corrected column order (Oracle throws index error if wrong)
        String sql = "SELECT SER_NO, NAME, FATHER_NAME, DESIGNATION, AGE, LOCAL_ADDRESS, "
                   + "IDENTIFICATION, VEHICLE_NO, TO_CHAR(UPDATE_DATE, 'DD-MON-YYYY') AS ISSUE_DATE "
                   + "FROM GATEPASS_CONTRACT_LABOUR ORDER BY SER_NO DESC";
        rs1 = st1.executeQuery(sql);

        while (rs1.next()) {
      %>
      <tr>
        <td>
          <a href="PrintContractLabour.jsp?srNo=<%= rs1.getInt("SER_NO") %>" 
             onclick="return printPagePopUp(this.href);">
             <%= rs1.getInt("SER_NO") %>
          </a>
        </td>
        <td><%= rs1.getString("NAME") %></td>
        <td><%= rs1.getString("FATHER_NAME") %></td>
        <td><%= rs1.getString("DESIGNATION") %></td>
        <td><%= rs1.getString("AGE") %></td>
        <td><%= rs1.getString("LOCAL_ADDRESS") %></td>
        <td><%= rs1.getString("IDENTIFICATION") %></td>
        <td><%= rs1.getString("VEHICLE_NO") %></td>
        <td><%= rs1.getString("ISSUE_DATE") %></td>
      </tr>
      <%
        } // while end
      } catch (Exception e) {
        out.println("<tr><td colspan='9' style='color:red;text-align:center;'>Error: " + e.getMessage() + "</td></tr>");
        e.printStackTrace();
      } finally {
        if (rs1 != null) try { rs1.close(); } catch (Exception e) {}
        if (st1 != null) try { st1.close(); } catch (Exception e) {}
        if (conn1 != null) try { conn1.close(); } catch (Exception e) {}
      }
      %>
    </table>

    <div class="btn-bar">
      <button type="button" class="btn" onclick="window.location.href='ContractLabour.jsp'">
         New Entry
      </button>
      <button type="button" class="btn" onclick="window.print();">
         Print Register
      </button>
    </div>
  </form>
</div>

</body>
</html>
