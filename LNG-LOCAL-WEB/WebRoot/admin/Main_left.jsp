<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	
%>
</head>
<body style="background:#0B80CC;">
<div id="PARENT">
	<ul id="nav">
		<li>
			<a href="#" onclick="DoMenu('ChildMenu1')">��˾��Ϣ</a>
			<ul id="ChildMenu1" class="collapsed">
				<li><a href="Corp_Info.do?Cmd=0&Sid=<%=Sid%>"                 target="mFrame">��˾����</a></li>
	   		<li><a href="User_Role.do?Cmd=0&Sid=<%=Sid%>"                 target="mFrame">����Ȩ��</a></li>
				<li><a href="User_Role.do?Cmd=1&Sid=<%=Sid%>"                 target="mFrame">����Ȩ��</a></li>
				<li><a href="User_Position.do?Cmd=0&Sid=<%=Sid%>"           	target="mFrame">��λ����</a></li>
				<li><a href="User_Info.do?Cmd=1&Func_Corp_Id=99&Sid=<%=Sid%>" target="mFrame">��˾��Ա</a></li>
	   	</ul>
		</li>
		<li>
			<a href="#" onclick="DoMenu('ChildMenu2')">վ����Ϣ</a>
			<ul id="ChildMenu2" class="collapsed">
				<li><a href="Device_Detail.do?Cmd=0&Sid=<%=Sid%>"                     target="mFrame">վ������</a></li>
				<li><a href="Map.jsp?Sid=<%=Sid%>"                                    target="mFrame">վ����ע</a></li>
			<!--	<li><a href="User_Info.do?Cmd=3&Func_Corp_Id=9999999999&Sid=<%=Sid%>" target="mFrame">վ����Ա</a></li>-->
	   	</ul>
		</li>
		<!--<li>
			<a href="#" onclick="DoMenu('ChildMenu3')">�ͻ���Ϣ</a>
			<ul id="ChildMenu3" class="collapsed">
				<li><a href="Crm_Info.do?Cmd=0&Sid=<%=Sid%>&Func_Sub_Id=9" 	  target="mFrame">�ͻ�����</a></li>
	   	</ul>
		</li>
		-->
		<li>
			<a href="#" onclick="DoMenu('ChildMenu4')">��ȫ����</a>
	  	<ul id="ChildMenu4" class="collapsed">
	  		<li><a href="Aqsc_Exam_Type.do?Cmd=0&Sid=<%=Sid%>"            target="mFrame">�������</a></li>
				<li><a href="Aqsc_Danger_Type.do?Cmd=0&Sid=<%=Sid%>"          target="mFrame">��������</a></li>
				<li><a href="Aqsc_Danger_Level.do?Cmd=0&Sid=<%=Sid%>"         target="mFrame">��������</a></li>
				<li><a href="Aqsc_Train_Type.do?Cmd=0&Sid=<%=Sid%>"           target="mFrame">��ѵ����</a></li>
				<li><a href="Aqsc_Drill_Type.do?Cmd=0&Sid=<%=Sid%>"           target="mFrame">��������</a></li>
	   	</ul>
		</li>
		<!--<li>
			<a href="#" onclick="DoMenu('ChildMenu5')">֤������</a>
	  	<ul id="ChildMenu5" class="collapsed">
	  		<li><a href="Aqsc_Card_Type.do?Cmd=0&Sid=<%=Sid%>"            target="mFrame">֤������</a></li>
	  		<li><a href="Aqsc_Act_Type.do?Cmd=0&Sid=<%=Sid%>"             target="mFrame">��Ϊ����</a></li>
	   	</ul>
		</li>
		<li>
			<a href="#" onclick="DoMenu('ChildMenu6')">�ͱ���Ʒ</a>
	  	<ul id="ChildMenu6" class="collapsed">
	  		<li><a href="Aqsc_Labour_Type.do?Cmd=0&Sid=<%=Sid%>"          target="mFrame">��Ʒ����</a></li>
	   	</ul>
		</li>
		<li>
			<a href="#" onclick="DoMenu('ChildMenu7')">�豸����</a>
	  	<ul id="ChildMenu7" class="collapsed">
	  		<li><a href="Aqsc_Device_Breed.do?Cmd=0&Sid=<%=Sid%>"         target="mFrame">�豸Ʒ��</a></li>
				<li><a href="Aqsc_Device_Card.do?Cmd=0&Sid=<%=Sid%>"          target="mFrame">�豸֤��</a></li>
	   	</ul>
		</li>-->
	<!--	<li>
			<a href="#" onclick="DoMenu('ChildMenu8')">��Ʒ����</a>
	  	<ul id="ChildMenu8" class="collapsed">
	  		<li><a href="Aqsc_Spare_Type.do?Cmd=0&Sid=<%=Sid%>&Func_Sub_Id=9"  target="mFrame">��Ʒ����</a></li>
	   	</ul>
		</li>
		<!--
		<li>
			<a href="#" onclick="DoMenu('ChildMenu9')">���ά��</a>
	  	<ul id="ChildMenu9" class="collapsed">
	  		<li><a href="#" target="mFrame">ά������</a></li>
				<li><a href="#" target="mFrame">��������</a></li>
	   	</ul>
		</li>
		-->
	</ul>
</div>
</body>
<SCRIPT LANGUAGE=javascript>
var LastLeftID = "";
function DoMenu(emid)
{
	
	 var obj = document.getElementById(emid); 
	 obj.className = (obj.className.toLowerCase() == "expanded"?"collapsed":"expanded");
	 if((LastLeftID!="")&&(emid!=LastLeftID)) //�ر���һ��Menu
	 {
	  	document.getElementById(LastLeftID).className = "collapsed";
	 }
	 LastLeftID = emid;
}

function DoHide(emid)
{ 
	 document.getElementById(emid).className = "collapsed";	 
}
</SCRIPT>
</html>