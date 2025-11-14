<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %> 
<%@ page import="java.text.*" %> 
<%@ page language="java" import="gatepass.Database.*" %>
<html>
<head>
    <title>display data from the table using jsp</title>
</head>
<body bgcolor="#CED8F6">

<%
	String fromdate= request.getParameter("datum1");
	System.out.println("JSP View By Date --fromdate-"+fromdate);
	String todate= request.getParameter("datum");
	System.out.println("JSP View By Date --todate-"+todate);
	
	
	
      try {
     Connection conn = null;
	gatepass.Database db = new gatepass.Database();	
	conn = db.getConnection();
	String ip = db.getServerIp();
		
ResultSet rs;
Statement st = conn.createStatement();
	rs= st.executeQuery("select * from visitor where entrydate1 between '"+fromdate+"' and '"+todate+"' order by id desc" ); //where id ='"+id+"'
String selQry = "select * from visitor where entrydate1 between '"+fromdate+"' and '"+todate+"' order by id desc";
System.out.println("JSP View By Date --selQry-"+selQry);	 
%>	
 <h2>Details of visitors from :-<%=fromdate %> to:-<%=todate %></h2>
	<TABLE cellpadding="15" border="1" style="background-color: #E6E6E6;">		
		  	 <TR> 
		  	 <th>CLICK</th>
		  	 <th>VISITOR ID</th><th>NAME</th>
  <th> ADDRESS  </th>
    <th>CONTACT NUMBER  </th>
     <th>DATE OF VISITt</th>
    <th>TIME OF VISIT</th>
      <th>VISITOR</th>
      <th>Officer to meet</th>
   <th>PURPOSE</th>
 				  <th>MATERIAL</th>
   
     
    </TR>
		<%
    while (rs.next()) {
    System.out.println("View By Date result Id is -->"+rs.getString(11));
     %>
   
     <TR>    
     
     <td><a href="PRINTTEST.jsp?id=<%= rs.getString(11) %>" target="blank" >REPRINT</a><br><BR><a href="My.jsp?id=<%= rs.getString(11) %>" >GATEPASS</a></td>
        <td>  <%= rs.getString(11) %></td>

     
      
        <TD><%=rs.getString(1).toUpperCase()%> </TD>
         <TD><%=rs.getString(2)%><br><%=rs.getString(14)%><BR><%=rs.getString(13)%><br><%=rs.getString(15) %></TD>
   		   		<TD><%=rs.getString(16)%></TD>
   		
   		<TD><%=rs.getString(12)%></TD>
        <TD><%=rs.getString(10)%></TD>
          <td align="left" width="100px" height="70" rowspan="0" colspan="0" bgcolor="lightblue" bordercolor="#400040"><a href="http://<%=ip %>/visitor/name?id=<%=rs.getString(11) %>"><img src="http://<%=ip %>/visitor/name?id=<%=rs.getString(11) %>" alt="" name="image5" width="100" height="70" /> </a></td>
        <TD><%=rs.getString(5)%></TD>
         <TD><%=rs.getString(7)%></TD>
        <TD><%=rs.getString(3)%></TD>
       
    </TR>

    <%    }  rs.close();conn.close();  %>
     <%
   
} catch (Exception ex) {System.out.print("Error in View by date-->"+ex);}
    %>	
			</TABLE>
      </body>
</html>
      
