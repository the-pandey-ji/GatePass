<%@ page language="java" import="java.sql.*" %>
<%@ page import="gatepass.Database.*" %>

<html>
<head>
<title>Foreigner Gatepass Register</title>

<script src="calendar.js"></script>
<script src="/visitor/javascript/FormValidation.js"></script>   
<link href="calendar.css" rel="stylesheet" type="text/css">
<script src="/GatepassVisitor/javascript/datetimepicker.js"></script>   

<style>
  body {
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(135deg, #e8f0ff, #ffffff);
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

  .table-container {
    max-height: 400px; /* scrollable height */
    overflow-y: auto;
    border: 1px solid #ddd;
    border-radius: 8px;
  }

  table {
    width: 100%;
    border-collapse: collapse;
  }

  thead th {
    position: sticky;
    top: 0;
    background-color: #1a75cf;
    color: white;
    padding: 10px;
    font-size: 15px;
    text-align: center;
    z-index: 2;
  }

  tbody td {
    border-bottom: 1px solid #ddd;
    text-align: center;
    padding: 8px;
    font-size: 14px;
  }

  tbody tr:hover {
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

<script>
function printPagePopUp(refNo){ 
  const newwindow = window.open(refNo,'print','left=10,right=10,height=460,width=340');
  if (window.focus) newwindow.focus();
  newwindow.print(); 
}

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

<body onkeydown="if(event.keyCode==13){event.keyCode=9; return event.keyCode}">

<div class="container">
  <h2>FOREIGNER GATEPASS REGISTER</h2>

  <div class="search-bar">
    <input type="text" id="searchInput" onkeyup="filterTable()" 
           placeholder=" Search by Name, Nationality, or any field...">
  </div>

  <form action="ssaveForeignerGatePasDetails" method="post" 
        name="text_form" enctype="multipart/form-data"
        onsubmit="return Blank_TextField_Validator()">

    <div class="table-container">
      <table id="registerTable">
        <thead>
          <tr>
            <th>SR.NO</th>
            <th>NAME</th>
            <th>FATHER NAME</th>
            <th>DESIGNATION</th>
            <th>AGE</th>
            <th>LOCAL ADDRESS</th>
            <th>PERMANENT ADDRESS</th>
            <th>NATIONALITY</th>
            <th>ISSUE DATE</th>
          </tr>
        </thead>
        <tbody>
          <%
          Connection conn1 = null;
          Statement st1 = null;
          try {
            gatepass.Database db1 = new gatepass.Database();	
            conn1 = db1.getConnection();
            st1 = conn1.createStatement();
            ResultSet rs1 = st1.executeQuery(
              "SELECT SER_NO, NAME, FATHER_NAME, DESIGNATION, AGE, LOCAL_ADDRESS, PERMANENT_ADDRESS, NATIONALITY, TO_CHAR(UPDATE_DATE,'DD-MON-YYYY') FROM GATEPASS_FOREIGNER ORDER BY SER_NO DESC"
            );

            while(rs1.next()) {
          %>
          <tr>
            <td>
              <a href="PrintForeignerGatePass.jsp?srNo=<%=rs1.getInt(1)%>"
                 onclick="printPagePopUp(this.href); return false;">
                 <%=rs1.getInt(1)%>
              </a>
            </td>
            <td><%=rs1.getString(2)%></td>
            <td><%=rs1.getString(3)%></td>
            <td><%=rs1.getString(4)%></td>
            <td><%=rs1.getString(5)%></td>
            <td><%=rs1.getString(6)%></td>
            <td><%=rs1.getString(7)%></td>
            <td><%=rs1.getString(8)%></td>
            <td><%=rs1.getString(9)%></td>
          </tr>
          <%
            } // end while
            rs1.close();
            st1.close();
            conn1.close();
          } catch (Exception e) {
            e.printStackTrace();
          }
          %>
        </tbody>
      </table>
    </div>

    <div class="btn-bar">
      <button type="button" class="btn" onclick="window.location.href='ForeignerGatepass.jsp'">
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
