<%@ page language="java" pageEncoding="ISO-8859-1"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title></title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
  </head>
  
  <body bgcolor="#CED8F6">
   <form action="My.jsp"> 
  <h2 style="position:absolute;left:150px;top:170px;width:200px;height:22px;z-index:31">Fill ID</h2> 
  <input type="text" name="id" size="1" id="Combobox1" class="Heading 5 <h5>" style="position:absolute;left:346px;top:180px;width:200px;height:22px;z-index:31">
 
		
 
  

<input type="Submit" name="view" value="View" style="position:absolute;left:579px;top:175px;width:100px;height:30px;z-index:31">
   
   </form>
  </body>
</html>
