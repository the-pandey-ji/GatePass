<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page  import="java.sql.*" %>
<%@page import="java.lang.*" %>
<%@ page language="java" import="gatepass.Database.*" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'selectstate.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body bgcolor="#CED8F6">
   <form action="vname.jsp" >
  <h2 style="position:absolute;left:100px;top:165px;width:200px;height:22px;z-index:31">Select Officer</h2> 
  <select name="officertomeet" size="1" id="Combobox1" class="Heading 5 <h5>" style="position:absolute;left:346px;top:180px;width:200px;height:22px;z-index:31">
  
  <%
  	Connection conn = null;
      	Statement st=null;
      	int id=0;
      	gatepass.Database db = new gatepass.Database();	
  		conn = db.getConnection();
  		st=conn.createStatement();
  		ResultSet rs = st.executeQuery("select officers from officertomeet"); // Executing the Query
  		while(rs.next()){
  %>
		
 
  
<option value="<%=rs.getString(1)%>"><%=rs.getString(1)%></option>

<% }conn.close(); %>
</select>
<input type="Submit" name="view" value="View" style="position:absolute;left:579px;top:175px;width:100px;height:30px;z-index:31">
   
   </form>
  </body>
</html>
