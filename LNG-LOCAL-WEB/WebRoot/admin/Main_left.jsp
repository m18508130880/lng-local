<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
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
			<a href="#" onclick="DoMenu('ChildMenu1')">公司信息</a>
			<ul id="ChildMenu1" class="collapsed">
				<li><a href="Corp_Info.do?Cmd=0&Sid=<%=Sid%>"                 target="mFrame">公司配置</a></li>
	   		<li><a href="User_Role.do?Cmd=0&Sid=<%=Sid%>"                 target="mFrame">功能权限</a></li>
				<li><a href="User_Role.do?Cmd=1&Sid=<%=Sid%>"                 target="mFrame">管理权限</a></li>
				<li><a href="User_Position.do?Cmd=0&Sid=<%=Sid%>"           	target="mFrame">岗位管理</a></li>
				<li><a href="User_Info.do?Cmd=1&Func_Corp_Id=99&Sid=<%=Sid%>" target="mFrame">公司人员</a></li>
	   	</ul>
		</li>
		<li>
			<a href="#" onclick="DoMenu('ChildMenu2')">站级信息</a>
			<ul id="ChildMenu2" class="collapsed">
				<li><a href="Device_Detail.do?Cmd=0&Sid=<%=Sid%>"                     target="mFrame">站级配置</a></li>
				<li><a href="Map.jsp?Sid=<%=Sid%>"                                    target="mFrame">站级标注</a></li>
			<!--	<li><a href="User_Info.do?Cmd=3&Func_Corp_Id=9999999999&Sid=<%=Sid%>" target="mFrame">站级人员</a></li>-->
	   	</ul>
		</li>
		<!--<li>
			<a href="#" onclick="DoMenu('ChildMenu3')">客户信息</a>
			<ul id="ChildMenu3" class="collapsed">
				<li><a href="Crm_Info.do?Cmd=0&Sid=<%=Sid%>&Func_Sub_Id=9" 	  target="mFrame">客户管理</a></li>
	   	</ul>
		</li>
		-->
		<li>
			<a href="#" onclick="DoMenu('ChildMenu4')">安全生产</a>
	  	<ul id="ChildMenu4" class="collapsed">
	  		<li><a href="Aqsc_Exam_Type.do?Cmd=0&Sid=<%=Sid%>"            target="mFrame">检查类型</a></li>
				<li><a href="Aqsc_Danger_Type.do?Cmd=0&Sid=<%=Sid%>"          target="mFrame">隐患类型</a></li>
				<li><a href="Aqsc_Danger_Level.do?Cmd=0&Sid=<%=Sid%>"         target="mFrame">隐患级别</a></li>
				<li><a href="Aqsc_Train_Type.do?Cmd=0&Sid=<%=Sid%>"           target="mFrame">培训类型</a></li>
				<li><a href="Aqsc_Drill_Type.do?Cmd=0&Sid=<%=Sid%>"           target="mFrame">演练类型</a></li>
	   	</ul>
		</li>
		<!--<li>
			<a href="#" onclick="DoMenu('ChildMenu5')">证件管理</a>
	  	<ul id="ChildMenu5" class="collapsed">
	  		<li><a href="Aqsc_Card_Type.do?Cmd=0&Sid=<%=Sid%>"            target="mFrame">证件类型</a></li>
	  		<li><a href="Aqsc_Act_Type.do?Cmd=0&Sid=<%=Sid%>"             target="mFrame">行为类型</a></li>
	   	</ul>
		</li>
		<li>
			<a href="#" onclick="DoMenu('ChildMenu6')">劳保用品</a>
	  	<ul id="ChildMenu6" class="collapsed">
	  		<li><a href="Aqsc_Labour_Type.do?Cmd=0&Sid=<%=Sid%>"          target="mFrame">用品类型</a></li>
	   	</ul>
		</li>
		<li>
			<a href="#" onclick="DoMenu('ChildMenu7')">设备管理</a>
	  	<ul id="ChildMenu7" class="collapsed">
	  		<li><a href="Aqsc_Device_Breed.do?Cmd=0&Sid=<%=Sid%>"         target="mFrame">设备品种</a></li>
				<li><a href="Aqsc_Device_Card.do?Cmd=0&Sid=<%=Sid%>"          target="mFrame">设备证件</a></li>
	   	</ul>
		</li>-->
	<!--	<li>
			<a href="#" onclick="DoMenu('ChildMenu8')">备品备件</a>
	  	<ul id="ChildMenu8" class="collapsed">
	  		<li><a href="Aqsc_Spare_Type.do?Cmd=0&Sid=<%=Sid%>&Func_Sub_Id=9"  target="mFrame">备品类型</a></li>
	   	</ul>
		</li>
		<!--
		<li>
			<a href="#" onclick="DoMenu('ChildMenu9')">检查维修</a>
	  	<ul id="ChildMenu9" class="collapsed">
	  		<li><a href="#" target="mFrame">维修类型</a></li>
				<li><a href="#" target="mFrame">故障类型</a></li>
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
	 if((LastLeftID!="")&&(emid!=LastLeftID)) //关闭上一个Menu
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