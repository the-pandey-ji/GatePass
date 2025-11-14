<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
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
   <form action="viewbystate.jsp" >
  <h2 style="position:absolute;left:100px;top:165px;width:200px;height:22px;z-index:31">Select State</h2> <select name="state" size="1" id="Combobox1" class="Heading 5 <h5>" style="position:absolute;left:346px;top:180px;width:200px;height:22px;z-index:31">
<option value="Andhra Pradesh">Andhra Pradesh</option>
<option value="Arunachal Pradesh">Arunachal Pradesh</option>
<option value="Assam">Assam</option>
<option value="Bihar">Bihar</option>
<option value="Chhatisgarh">Chhatisgarh</option> 
<option value="Goa ">Goa</option> 
<option value="Gujarat">Gujarat</option>
<option value="Haryana">Haryana </option>
<option value="Himachal Pradesh ">Himachal Pradesh</option> 
<option value="Jammu & Kashmir">Jammu & Kashmir</option>
<option value="Jharkhand">Jharkhand</option>
<option value="Karnataka">Karnataka</option>
<option value="Kerala">Kerala</option>
<option value="Madhya Pradesh">Madhya Pradesh </option>
<option value="Maharashtra">Maharashtra</option>
<option value="Manipur">Manipur</option>
<option value="Meghalaya ">Meghalaya </option>
<option value="Mizoram">Mizoram </option>
<option value="Nagaland ">Nagaland </option>
<option value="Orissa">Orissa</option>
<option value="Punjab">Punjab </option>
<option value="Rajasthan">Rajasthan</option>
<option value="Sikkim">Sikkim</option>
<option value="Tamil Nadu">Tamil Nadu</option>
<option value="Tripura">Tripura</option>
<option value="Uttar Pradesh">Uttar Pradesh</option>
<option value="Uttaranchal">Uttaranchal</option>
<option value="West Bengal">West Bengal</option>
<option value="Andaman and Nicobar Islands">Andaman & Nicobar Islands</option>
<option value="Chandigarh">Chandigarh</option>
<option value="Dadra and Nagar Haveli">Dadra & Nagar Haveli</option> 
<option value="Daman & Diu">Daman & Diu
<option value="Delhi">Delhi 
<option value="Lakshadweep">Lakshadweep
<option value="Pondicherry ">Pondicherry 

</select>
<input type="Submit" name="view" value="View" style="position:absolute;left:579px;top:175px;width:100px;height:30px;z-index:31">
   
   </form>
  </body>
</html>
