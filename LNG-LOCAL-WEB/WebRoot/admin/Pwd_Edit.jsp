<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	
%>
</head>
<body style=" background:#CADFFF">
<form name="Pwd_Edit" action="Pwd_Edit.do" method="post" target="_self">
<div id="down_bg_2">
	<div id="cap">
		<img src="../skin/images/cap_pwd_edit.gif"/>
	</div><br><br><br>
  <div id="right_table_center">
		<table id="datasave" style='margin:auto' width="50%" border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		 	<tr valign="middle" height="30px">
				<td width="100%" align="right"><img style="cursor:hand" onClick="doSubmit()" src="../skin/images/mini_button_submit.gif"></td>
		 	</tr>
		 	<tr valign="middle" height="30px">
				<td width="100%" align="center">
					<table id="datasave" width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
						<tr valign="middle" height="30px">
							<td width="15%" align="center" valign="middle"><span class="style1">��¼�˺�</span></td>
					    <td width="25%" align="left" valign="middle" bgcolor="#F7F7F7">admin</td>
					 	</tr>
					 	<tr valign="middle" height="30px">
					 		<td width="15%" align="center" valign="middle"><span class="style1">������</span></td>
					    <td width="25%" align="left" valign="middle" bgcolor="#F7F7F7"><input name="OldPwd" type="password" maxlength="6" value="" size="20"></td>
					 	</tr>
					 	<tr valign="middle" height="30px">
					 		<td width="15%" align="center" valign="middle"><span class="style1">������</span></td>
					    <td width="25%" align="left" valign="middle" bgcolor="#F7F7F7"><input name="NewPwd" type="password" maxlength="6" value="" size="20"></td>
					 	</tr>
					 	<tr valign="middle" height="30px">
					 		<td width="15%" align="center" valign="middle"><span class="style1">ȷ��������</span></td>
					    <td width="25%" align="left" valign="middle" bgcolor="#F7F7F7"><input name="ConfirmNewPwd" type="password" maxlength="6" value="" size="20"></td>
					 	</tr>
					</table>
				</td>
		 	</tr>
		</table>
	</div>
</div>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
var req = null;
function doSubmit()
{ 
	  if(Pwd_Edit.OldPwd.value == null || Pwd_Edit.OldPwd.value.length < 1)
	  {
	  	 alert("��������������!");
	  	 return;
	  }
	  if(Pwd_Edit.NewPwd.value == null || Pwd_Edit.NewPwd.value.length < 1)
	  {
	  	 alert("����������������!");
	  	 return;
	  }
	  if(Pwd_Edit.ConfirmNewPwd.value == null || Pwd_Edit.ConfirmNewPwd.value.length < 1)
	  {
	  	 alert("����������ȷ������!");
	  	 return;
	  }
	  if(Pwd_Edit.NewPwd.value != Pwd_Edit.ConfirmNewPwd.value)
	  {
	  	 alert("���������������ȷ�����벻һ�£�����������");
	  	 return;
	  }
	  if(confirm("ȷ��Ҫ�޸���������?"))
	  {
	  	 xhr = createXHR();
	     if(xhr)
	     {
	        xhr.onreadystatechange=callbackFunction;
	        var url = "PwdEdit.do?Cmd=23&Sid=<%=Sid%>&Id=admin&Pwd=" + Pwd_Edit.OldPwd.value+ "&NewPwd=" + Pwd_Edit.NewPwd.value + "&currtime="+new Date();        
	        xhr.open("get", url);
	        xhr.send(null);
	     }
	     else
	     {
	        alert("�������֧�֣�������������");
	     }
		 
	  }
}

/*
 *�����첽���ʶ���
 */
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

    if (!xhr && typeof XMLHttpRequest != 'undefined') 
    {
        xhr = new XMLHttpRequest();
    }

    return xhr;
}

/*
 *�첽�ص���������
 */
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
	              Pwd_Edit.OldPwd.value = "";
								Pwd_Edit.NewPwd.value = "";
								Pwd_Edit.ConfirmNewPwd.value = "";      
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