<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %> 
<%@ page language="java" import="gatepass.Database.*" %>
<html>
<head>
    <title>display data from the table using jsp</title>
</head>
<body bgcolor="#CED8F6">

<%
	String id= request.getParameter("id");

      try {
     Connection conn = null;
	gatepass.Database db = new gatepass.Database();	
	conn = db.getConnection();
	String ip = db.getServerIp();
	
	
String name = null;
ResultSet rs;
Statement st = conn.createStatement();
	rs= st.executeQuery("select * from visitor order by id desc  " ); //where id ='"+id+"'
%>	
 <h2><center>Details Of all visitors</center></h2>
	<TABLE cellpadding="15" border="1" style="background-color: #E6E6E6" align="center">		
		 <TR>
		  <th>VISITOR ID</th><th>NAME</th>
		  <th>FATHER NAME</th>
		  <th>AGE</th>
  <th> ADDRESS  </th>
    <th>CONTACT NUMBER  </th>
     <th>DATE OF VISIT</th>
    <th>TIME OF VISIT</th>
      <th>Officer to meet</th>
   <th>PURPOSE</th>
   <th>IMAGE</th>
 	<th>MATERIAL</th>
 	<th>VEHICLE</th>
 	<th>DEPARTMENT TO MEET</th>
 				  
   
   
    </TR>
		<%
    while (rs.next()) {
     %>
   
     <TR>       <td>
				<a href="print_visitor_card.jsp?id=<%=rs.getInt("ID")%>"
                 onclick="printPagePopUp(this.href); return false;">
                 <%=rs.getInt("ID")%>
              </a>     </td>
        
        <TD><%=rs.getString("NAME")%> </TD>
        <td><%=rs.getString("FATHERNAME") %></td>
        <TD><%=rs.getString("AGE")%></TD>
         <TD><%=rs.getString("ADDRESS")%><br><%=rs.getString("DISTRICT")%><BR><%=rs.getString("STATE")%><br><%=rs.getString("PINCODE") %></TD>
         <TD><%=rs.getString("PHONE")%></TD>
   		<TD><%=rs.getString("ENTRYDATE")%></TD>
   		<TD><%=rs.getString("TIME")%></TD>
   		
   		<TD><%=rs.getString("OFFICERTOMEET")%></TD>
        <TD><%=rs.getString("PURPOSE")%></TD>
          <td ><a href="http://<%=ip %>/visitor/name?id=<%=rs.getString("ID") %>"><img src="http://<%=ip %>/visitor/name?id=<%=rs.getString("ID") %>" alt="" name="image5" width="100" height="70" /> </a></td>
        <td><%=rs.getString("MATERIAL") %> 
        <TD><%=rs.getString("VEHICLE")%></TD>
		<td><%=rs.getString("DEPARTMENT") %>       
        
       
    </TR>
    <%  }    
    rs.close();
    conn.close(); 
    }  
catch (Exception ex) {
System.out.print(ex);
}
    %>	
			</TABLE>
      </body>
</html>
      
