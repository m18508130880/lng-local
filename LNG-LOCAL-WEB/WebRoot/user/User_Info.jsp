<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/util.js' charset='gb2312'></script>
<script type="text/javascript" src='../skin/js/My97DatePicker/WdatePicker.js'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	
%>
</head>
<body style=" background:#CADFFF">
<form name="Info_Edit" action="Info_Edit" method="post" target="_self">
<div id="down_bg_2">
	<div id="cap">
		<img src="../skin/images/user_info.gif"/>
	</div><br><br><br>
  <div id="right_table_center">
		<table id="datasave" style='margin:auto' width="50%" border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		 	<tr valign="middle" height="30px">
				<td width="100%" align="right"><img style="cursor:hand" onClick="doSubmit()" src="../skin/images/mini_button_submit.gif"></td>
		 	</tr>
		 	<tr valign="middle" height="30px">
				<td width="100%" align="center">
					<table id="datasave" width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
						<tr height='30px'>
					    <td width='20%' align='center' class='table_blue'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
					    <td width='30%' align='left'>
					      <%=UserInfo.getId()%>
					    </td>
					    <td width='20%' align='center' class='table_blue'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
					    <td width='30%' align='left'>
					      <input type='text' name='CName' style='width:95%;height:18px;' value='<%=UserInfo.getCName()%>' maxlength='6'>
					    </td>
					  </tr>
				  	<tr height='30px'>
					    <td width='20%' align='center' class='table_blue'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
					    <td width='30%' align='left'>
					      <input type='text' name='Tel' style='width:95%;height:18px;' value='<%=UserInfo.getTel()%>' maxlength='12'>
					    </td>
					    <td width='20%' align='center' class='table_blue'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
					    <td width='30%' align='left'>
					      <select name='Sex' style='width:98%;height:20px'>
						      <option value='0' <%=UserInfo.getSex().equals("0")?"selected":""%>>��</option>
						      <option value='1' <%=UserInfo.getSex().equals("1")?"selected":""%>>Ů</option>
					      </select>
					    </td>
					  </tr>
				  	<tr height='30px'>
					    <td width='20%' align='center' class='table_blue'>��ְʱ��</td>
					    <td width='30%' align='left'>
					      <input type='text' name='Birthday' style='width:95%;' value='<%=UserInfo.getBirthday()%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
					    </td>
					    <td width='20%' align='center' class='table_blue'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ַ</td>
					    <td width='30%' align='left'>
					      <input type='text' name='Addr' style='width:95%;height:18px;' value='<%=UserInfo.getAddr()%>' maxlength='64'>
					    </td>
					  </tr>
					</table>
				</td>
		 	</tr>
		</table>
	</div>
</div>
</center>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
var req = null;
function doSubmit()
{ 
	if(Info_Edit.CName.value.Trim().length < 1)
	{
		alert('����д����');
		return;
	}
	if(Info_Edit.Tel.value.Trim().length < 1)
	{
		alert('����д��ϵ�绰');
		return;
	}
	if(Info_Edit.Birthday.value.Trim().length < 1)
	{
		alert('����д��ְʱ��');
		return;
	}
	if(Info_Edit.Addr.value.Trim().length < 1)
	{
		alert('����д��ϸ��ַ');
		return;
	}
	if(confirm("ȷ��Ҫ�޸����ĸ�����Ϣ?"))
	{
		xhr = createXHR();
	  if(xhr)
	  {
	    xhr.onreadystatechange=callbackFunction;
	    var url = "PwdEdit.do?Cmd=12&Sid=<%=Sid%>&Id=<%=UserInfo.getId()%>&CName="+Info_Edit.CName.value+"&Tel="+Info_Edit.Tel.value
	            + "&Sex="+Info_Edit.Sex.value+"&Birthday="+Info_Edit.Birthday.value+"&Addr="+Info_Edit.Addr.value
	            + "&currtime="+new Date();        
	    xhr.open("get", url);
	    xhr.send(null);
	  }
	  else
	  {
	    alert("�������֧�֣�������������");
	  }
	}
}

function createXHR() 
{
	var xhr;
  try 
  {
    xhr = new ActiveXObject("Msxml2.XMLHTTP");
  }
  catch (e)
  {
    try 
    {
      xhr = new ActiveXObject("Microsoft.XMLHTTP");
    }
    catch(E) 
    {
      xhr = false;
    }
  }
  if(!xhr && typeof XMLHttpRequest != 'undefined')
  {
  	xhr = new XMLHttpRequest();
  }
  return xhr;
}

function callbackFunction()
{
	if(xhr.readyState == 4) 
	{
	  if(xhr.status == 200) 
	  {
	    var returnValue = xhr.responseText;
	    if(returnValue != null && returnValue == '0000')
	    {    	
	  		alert('�����ɹ�');
	    }
	    else if(returnValue != null && returnValue == '1001')
	    {
	    	alert('ʧ��,�������');
	    }
	    else
	    {
	      alert("ʧ��,�����²���");
	    }
	  } 
	  else 
	  {
	    alert("ʧ��,�����²���");
	  }
	}
}
</SCRIPT>
</html>