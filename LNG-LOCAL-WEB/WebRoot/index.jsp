<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="rmi.*" %>
<%@ page import="util.*" %>
<%@page import="java.awt.*, java.awt.image.*, java.io.*, com.sun.image.codec.jpeg.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>������ԴLNG��˾����Ϣ������ƽ̨</title>
<link rel="icon" type="image/png" href="skin/images/logo_32.png">
<link rel="apple-touch-icon" href="skin/images/logo_57.png" />
<link href="skin/css/index.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="skin/js/one.js"></script>
<script type="text/javascript" src="skin/js/md5.js"></script>
<script type='text/javascript' src='skin/js/util.js'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
<style>
  html,body{width:100%; height:100%; margin:0; padding:0;}
  .mesWindow{border:#358ee1 3px solid;background:#f0f5f0;}
  .mesWindowTop{display:none;background:#3ea3f9;padding:5px;margin:0;font-weight:bold;text-align:left;font-size:12px; clear:both; line-height:1.5em; position:relative; clear:both;}
  .mesWindowTop span{display:none;position:absolute; right:5px; top:3px;}
  .mesWindowContent{margin:4px;font-size:12px; clear:both;}
  .mesWindow .close{height:15px;width:28px; cursor:pointer;text-decoration:underline;background:#fff}
</style>
</head>
<%
	
  String Cook_Emp_Id = "";
  Cookie[] cookies = request.getCookies();
  if(cookies!=null)
  {
	  for(int i=0;i<cookies.length;i++)
	  {
	  	Cookie cookie=cookies[i];
	    if(cookie.getName().toString().equals("Cook_Emp_Id"))
	    {
	      Cook_Emp_Id = cookie.getValue();
	    }
	 	}
  }
  
  //��ȡΨһSid
  String Sid = CommUtil.SessionId();
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  if(currStatus == null)
  {
  		currStatus = new CurrStatus();
  		currStatus.setResult("");
  		session.setAttribute("CurrStatus_" + Sid, currStatus);
  }
  
%>

<body onload="MM_preloadImages('skin/images/d1_down.gif','skin/images/c1_down.gif')"  bgcolor="#085F9C">
<form  name="login" action="Login.do"  method="post" target="_self">
<div class="center">
<div class="top1">
	<div><img src="skin/images/logoV2.0.jpg" /></div>
	<div class="top3">
		<div class="fontsz">
	  	<table width="231" border="0">
	    	<tr>
	      	<td width="82"><label></label></td>
	      	<td width="139" colspan=2 >&nbsp;</td>
	    	</tr>
	    	<tr>
	      	<td>��  �� ���� </td>
	      	<td colspan=2 ><input  id="Id" name="Id" maxlength="20" style="background-color:transparent" type="text" id="textfield2" size="14"  value="<%=Cook_Emp_Id%>" /></td>
	    	</tr>
	    	<tr>
	      	<td>�� ��  �룺</td>
	      	<td colspan=2 ><input name="Pwd" maxlength="6" style="background-color:transparent" type="password" id="textfield3" size="14" /></td>
	   	 	</tr>
	    	<tr>
		      <td>��  ֤ �룺</td>
		      <td width="66"><input name="Check_Code" maxlength="4" type="text" id="textfield4"  style="background-color:transparent;margin-bottom:0px;margin-top:0px;vertical-align:middle;" size="4" runat="server" onkeydown="fnTrapKD('Image4')"/></td>
		      <td align=left vertical-align=middle> <img src="index.do?Sid=<%=Sid%>"></td>
		    </tr>
		  </table>
		</div>
		<div class="fontsz2">
				<a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image4','','skin/images/d1_down.gif',1)"><img onClick="doSubmit()" src="skin/images/d1_over.gif" name="Image4" width="97" height="28" border="0" id="Image4" /></a>��
				<a href="#" onClick="" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image5','','skin/images/c1_down.gif',1)"><img onClick="PwdEdit()" src="skin/images/c1_over.gif" name="Image5" width="97" height="28" border="0" id="Image5" /></a>
		</div>
		<div class="fontsz3" style='text-align:left;margin-left:200px'>
			��˾:���ݰ��´������Ƽ����޹�˾
			&nbsp;&nbsp;&nbsp;&nbsp;
			�绰:0571-85357888
		  <br>
		  ��ַ:�����й�������԰·28���ָ��ǻ�԰8��¥5¥
		</div>
	</div>
	<div><img src="skin/images/t4.gif" /></div>
</div>
</div>
<input type="hidden" name="Old_Pwd" value="">
<input type="hidden" name="New_Pwd" value="">
<input type="hidden" name="User_Id" value="">
<input type="hidden" name="Cmd" value="21">
<input type="hidden" name="StrMd5" value="">
<input type="hidden" name="Sid" value="<%=Sid%>">
</form>
<SCRIPT LANGUAGE=javascript>
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

function fnTrapKD(btn)
{
  if(event.keyCode == 13)  
  {  
     event.returnValue=false; 
     event.cancel = true; 
     document.getElementById(btn).click();
  }  
} 

function doSubmit()
{
	if(login.Id.value.length < 1)
  {
     alert("�������û���!");
     return;
  }
  if(login.Pwd.value.length < 1)
  {
     alert("�������¼����!");
     return;
  }
  if(login.Check_Code.value.length < 1)
  {
     alert("��������֤��!");
     return;
  }
  doLoad();
  var ID = StrRightFillSpace(login.Id.value.toUpperCase(), 20);
	var checkcode = StrRightFillSpace(login.Check_Code.value, 6);
	login.StrMd5.value = ID + checkcode + hex_md5(ID + checkcode + login.Pwd.value).toUpperCase();
  CheckCookie();
  login.submit();  
}

function doLoad()
{
	var messContent = "";
	messContent += "<div style='text-align:center;'>";
	messContent += "  <br><img style='width:32px;height:32px;' src='skin/images/loading.gif'><br><br>ϵͳ������...";
	messContent += "</div>";
	showMessageBox('ϵͳ������...', messContent , 100, 100);
}

function CheckCookie()
{
	var Emp  = document.login.Id.value;
	var Pwd  = document.login.Pwd.value;
	var Days = 30; //����һ����
  var expiration = new Date(); 
  expiration.setTime(expiration.getTime() + Days*24*60*60*1000);
	document.cookie = "Cook_Emp_Id=" + Emp + ";expires=" + expiration.toGMTString() + ";path=/";
	document.cookie = "Cook_PWd_Id=" + Pwd + ";expires=" + expiration.toGMTString() + ";path=/";
}
 
function PwdEdit()
{
	login.Id.value = '';
	login.Pwd.value = '';
	login.Check_Code.value = '';
}	

function StrRightFillSpace(strData, len)
{
  var str = strData;
	var FillLen = len - str.length;
	for(var i=0; i < FillLen; i++)
	{
		str += " ";
	}
	return str;
}
</script>
</body>
</html>