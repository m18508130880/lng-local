<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../../skin/js/util.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	ArrayList User_Manage_Role = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	String CName = UserInfo.getCName();
	String FpId = UserInfo.getFp_Role();
	String ManageId = UserInfo.getManage_Role();
	String FpIdName = "无";
	String ManageName = "无";
	String FpList = "";
	
	if(null != FpId && FpId.length() > 0 && null != User_FP_Role)
	{
		Iterator roleiter = User_FP_Role.iterator();
		while(roleiter.hasNext())
		{
			UserRoleBean roleBean = (UserRoleBean)roleiter.next();
			if(roleBean.getId().equals(FpId))
			{
				FpIdName = roleBean.getCName();
			}
		}
	}
	
	if(null != ManageId && ManageId.length() > 0 && null != User_Manage_Role)
	{
		Iterator roleiter = User_Manage_Role.iterator();
		while(roleiter.hasNext())
		{
			UserRoleBean roleBean = (UserRoleBean)roleiter.next();
			if(roleBean.getId().equals(ManageId))
			{
				ManageName = roleBean.getCName();
			}
		}
	}
	
	if(null != FpId && FpId.length() > 0 && null != User_FP_Role)
	{
		Iterator roleiter = User_FP_Role.iterator();
		while(roleiter.hasNext())
		{
			UserRoleBean roleBean = (UserRoleBean)roleiter.next();
			if(roleBean.getId().equals(FpId) && null != roleBean.getPoint())
			{
				FpList = roleBean.getPoint();
			}
		}
	}
	
	String p3 = CommUtil.StrToGB2312(request.getParameter("p3"));
	if(null == p3)
	{
		p3 = "1";
	}
	
%>
<body>
	<div class="top">
		<div class="logo"><img src="../../skin/images/logo_sub_application_manage.gif" /></div>
		<div class="home" style="cursor:hand"><img onClick="ReturnMain()" src="../../skin/images/home.gif" /></div>
		<div class="exit" style="cursor:hand"><img onClick="doExit()" src="../../skin/images/exit.gif" /></div>
		<div class="bar">
			<div class="ren"><img src="../../skin/images/ren.gif" width="13" height="15" /></div>
			<div class="js">您好: <%=CName%> [功能权限: <font color=green><%=FpIdName%></font> | 管理权限: <font color=green><%=ManageName%></font>]</div>
			<div class="line"><img src="../../skin/images/bar_line.gif" /> </div>
			<div class="js2" id="time"></div>
			<div id="banner_r">
				<ul>
					<li style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0701' ctype='1'/>">
						<img onClick="doSat01()" style="cursor:hand" src="../../skin/images/top_menu_sat_01.gif" alt="安全检查"/>
					</li>	
					<li style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0702' ctype='1'/>">
						<img onClick="doSat02()" style="cursor:hand" src="../../skin/images/top_menu_sat_02.gif" alt="全部隐患"/>
					</li>
					<li style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0703' ctype='1'/>">
						<img onClick="doSat03()" style="cursor:hand" src="../../skin/images/top_menu_sat_03.gif" alt="全部违章"/>
					</li>	
					<li style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0704' ctype='1'/>">
						<img onClick="doSat04()" style="cursor:hand" src="../../skin/images/top_menu_sat_04.gif" alt="安全培训"/>
					</li>
					<li style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0705' ctype='1'/>">
						<img onClick="doSat05()" style="cursor:hand" src="../../skin/images/top_menu_sat_05.gif" alt="应急演练"/>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
<SCRIPT LANGUAGE=javascript>
//setInterval("time.innerHTML= new Date().toLocaleString()+' 星期'+'日一二三四五六'.charAt(new Date().getDay());",1000);
setInterval("time.innerHTML= new Date().toLocaleString().substring(0, new Date().toLocaleString().indexOf('日')+1)",1000);

function ReturnMain()
{
	switch(parseInt('<%=p3%>'))
	{
		case 1:
				window.parent.location = "../MapMain.jsp?Sid=<%=Sid%>";
			break;
		case 2:
				window.parent.location = "../MapFullScreen.jsp?Sid=<%=Sid%>";
			break;
		default:
				window.parent.location = "../MapMain.jsp?Sid=<%=Sid%>";
			break;
	}
}

function doExit()
{
	if(confirm("确定要安全退出本系统?"))
	{
	  alert("谢谢您的使用!");
		location = "IILogout.do?Sid=<%=Sid%>";
	}
}

function doSat01()
{
	window.parent.frames.mFrame.location = "Sat_Check.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Corp_Id=9999";
}

function doSat02()
{
	window.parent.frames.mFrame.location = "Sat_Danger.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Corp_Id=9999&Func_Type_Id=9999&Func_Sub_Id=0";
}

function doSat03()
{
	window.parent.frames.mFrame.location = "Sat_Break.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value;
}

function doSat04()
{
	window.parent.frames.mFrame.location = "Sat_Train.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Corp_Id=9999";
}

function doSat05()
{
	window.parent.frames.mFrame.location = "Sat_Drill.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Corp_Id=9999&Func_Sub_Id=0";
}
</SCRIPT>
</html>