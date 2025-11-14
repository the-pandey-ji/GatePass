<%@ page language="java" import="java.sql.*" %>
<%@page import="java.lang.*" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@page import="org.apache.commons.fileupload.FileUploadException" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@page import="org.apache.commons.io.output.*" %>

<%@page import="java.io.*" %>
<%@page import="javaQuery.j2ee.GeoLocation" %>


<html>
<head>
<%
	Connection conn = null;
    	Statement st=null;
    	 String id=request.getParameter("id");
  System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+id);

    	gatepass.Database db = new gatepass.Database();	
		conn = db.getConnection();
	
		System.out.println("Inside class DatabaseConnection----");
		st=conn.createStatement();
		ResultSet rs = st.executeQuery("select * from visitor where id='"+id+"'");
		while(rs.next()){
%>
<title>Gate Pass Entry Details</title>
<script type="text/javascript" language="javascript">
        function Blank_TextField_Validator()
{
// Check the value of the element named text_name from the form named text_form
if (text_form.text_name.value == "")
{
  // If null display and alert box
   alert("Please fill the NAME");
  // Place the cursor on the field for revision
   text_form.text_name.focus();
  // return false to stop further processing
   return (false);
}
if (text_form.line1.value == "")
{
  // If null display and alert box
   alert("Please fill the address");
  // Place the cursor on the field for revision
   text_form.line1.focus();
  // return false to stop further processing
   return (false);
}
if (text_form.vehicle.value == "")
{
  // If null display and alert box
   alert("Please fill the vehicle number");
  // Place the cursor on the field for revision
   text_form.vehicle.focus();
  // return false to stop further processing
   return (false);
}




if (text_form.district.value == "")
{
  // If null display and alert box
   alert("Please fill the district");
  // Place the cursor on the field for revision
   text_form.district.focus();
  // return false to stop further processing
   return (false);
}


if (text_form.state.value == "")
{
  // If null display and alert box
   alert("Please fill the state");
  // Place the cursor on the field for revision
   text_form.state.focus();
  // return false to stop further processing
   return (false);
}


if (text_form.material.value == "")
{
  // If null display and alert box
   alert("Please fill the material");
  // Place the cursor on the field for revision
   text_form.material.focus();
  // return false to stop further processing
   return (false);
}


if (text_form.purpose.value == "")
{
  // If null display and alert box
   alert("Please fill the purpose");
  // Place the cursor on the field for revision
   text_form.purpose.focus();
  // return false to stop further processing
   return (false);
}

// If text_name is not null continue processing
return (true);
}


function executeCommands()
{
// Instantiate the Shell object and invoke
//its execute method.

  WshShell = new ActiveXObject("Wscript.Shell"); //Create WScript Object
   WshShell.run("C://Users/cam.exe");

}


    </script>
       

</head>
<body bgcolor="#CED8F6" onload="executeCommands();">
<div id="gatepass" style="position:absolute;background-color:#E6E6E6;left:200px;width:570px;height:530px;">
<form action="http://10.3.111.103:8080/visitor/up" method="post" name="text_form"
                        enctype="multipart/form-data"  onsubmit="return Blank_TextField_Validator()">
<div id="bv_Text1" style="margin:0;padding:0;position:absolute;left:171px;top:5px;width:315px;height:27px;text-align:center;z-index:21;">
<h3>Gate Pass Details</h3></div>
<div id="bv_Text2" style="margin:0;padding:0;position:absolute;left:97px;top:97px;width:150px;height:22px;text-align:left;z-index:22;">
<h6>Name</h6></div>
<input type="text" id="Editbox1"  style="position:absolute;left:344px;top:90px;width:197px;height:25px;border:1px #C0C0C0 solid;font-family:'Courier New';font-size:16px;z-index:23" name="text_name" value="<%=rs.getString(1)%>">

<div id="bv_Text3" style="margin:0;padding:0;position:absolute;left:96px;top:155px;width:150px;height:22px;text-align:left;z-index:24;">
<h6>Address</h6>
</div>


<div id="bv_xt3" style="margin:0;padding:0;position:absolute;left:240px;top:130px;width:150px;height:22px;text-align:left;z-index:24;">
<h6>Address</h6></div>
<input type="text" value="<%=rs.getString(2)%>"  name="line1" id="TextArea1" style="position:absolute;left:346px;top:125px;width:200px;height:20px;border:1px #C0C0C0 solid;font-family:'Courier New';font-size:16px;z-index:25">



<div id="bv_Te" style="margin:0;padding:0;position:absolute;left:240px;top:155px;width:150px;height:22px;text-align:left;z-index:24;">
<h6>District</h6>
</div>
<input type="text" name="district" value="<%=rs.getString(14)%>"  id="TextArea1" style="position:absolute;left:346px;top:150px;width:200px;height:22px;border:1px #C0C0C0 solid;font-family:'Courier New';font-size:16px;z-index:25" >


<div id="bvTex" style="margin:0;padding:0;position:absolute;left:240px;top:180px;width:150px;height:22px;text-align:left;z-index:24;">
<h6>state</h6>
</div>
<select name="state" size="1" id="Combobox1" class="Heading 5 <h6>" style="position:absolute;left:346px;top:175px;width:200px;height:22px;z-index:31">
<option value="<%=rs.getString(13)%>"><%=rs.getString(13)%></option>


</select>


<div id="bvxt3" style="margin:0;padding:0;position:absolute;left:240px;top:205px;width:150px;height:22px;text-align:left;z-index:24;">
<h6>Pin code</h6>
</div>
<input type="text" value="<%=rs.getString(15)%>" name="pincode" id="TextArea1" style="position:absolute;left:346px;top:200px;width:201px;height:22px;border:1px #C0C0C0 solid;font-family:'Courier New';font-size:16px;z-index:25" >







<div id="bv_Text4" style="margin:0;padding:0;position:absolute;left:98px;top:260px;width:150px;height:22px;text-align:left;z-index:26;">
<h6>Material</h6></div>
<input type="text" name="material" value="<%=rs.getString(3)%>" id="TextArea2" style="position:absolute;left:346px;top:240px;width:200px;height:41px;border:1px #C0C0C0 solid;font-family:'Courier New';font-size:16px;z-index:27" >
<div id="bv_Text5" style="margin:0;padding:0;position:absolute;left:96px;top:310px;width:221px;height:22px;text-align:left;z-index:28;">
<h6>Vehicle Number if any:</h6></div>
<input type="text" value="<%=rs.getString(4)%>" id="Editbox2" style="position:absolute;left:347px;top:306px;width:197px;height:20px;border:1px #C0C0C0 solid;font-family:'Courier New';font-size:16px;z-index:29" name="vehicle" value="">
<div id="6" style="margin:0;padding:0;position:absolute;left:93px;top:350px;width:203px;height:22px;text-align:left;z-index:30;">
<h6>Officer whom to meet</h6></div>

<select name="officertomeet" size="1" id="Combobox1" class="Heading 5 <h6>" onBlur="javascript:changeMe();" style="position:absolute;left:348px;top:350px;width:203px;height:52px;z-index:31">




<option value="<%=rs.getString(5)%>"><%=rs.getString(5)%></option>

</select>
<input type="text" name=department disabled="disabled" size="1" style="margin:0;padding:0;position:absolute;left:0px;top:0px;width:2px;height:1px;text-align:left;">
<div id="bv_Text8" style="margin:0;padding:0;position:absolute;left:96px;top:410px;width:150px;height:22px;text-align:left;z-index:34;">
<h6>Purpose</h6></div>
<input type="text" value="<%=rs.getString(7)%>" id="Editbox5" style="position:absolute;left:350px;top:410px;width:194px;height:20px;border:1px #C0C0C0 solid;font-family:'Courier New';font-size:16px;z-index:35" name="purpose">



<div id="bv_Text8" style="margin:0;padding:0;position:absolute;left:96px;top:460px;width:150px;height:22px;text-align:left;z-index:34;">
<h6>Telephone number</h6></div>
<input type="text" id="Editbox5" value="<%=rs.getString(16)%>" style="position:absolute;left:350px;top:460px;width:194px;height:20px;border:1px #C0C0C0 solid;font-family:'Courier New';font-size:16px;z-index:35" name="number" value="">
<input type="submit" id="Button1" name="Button1" value="Submit" style="position:absolute;left:250px;top:490px;width:75px;height:24px;font-family:Arial;font-size:13px;z-index:36">
<input type="reset" id="Button3" name="reset" value="Reset" style="position:absolute;left:450px;top:490px;width:75px;height:24px;font-family:Arial;font-size:13px;z-index:38">
<div id="bv_Text9" style="margin:0;padding:0;position:absolute;left:95px;top:543px;width:150px;height:22px;text-align:left;z-index:39;">
</div>

</form>

</div>


<% } rs.close();conn.close();%>



</body>
</html>