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
<script type="text/javascript" src="../../skin/js/day.js"></script>
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
					<li style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0201' ctype='1'/>">
						<img onClick="doPro_R()" style="cursor:hand" src="../../skin/images/top_pro_r.gif"        alt="实时库存"/>
					</li>
					<li style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0202' ctype='1'/>">
						<img onClick="doPro_I()" style="cursor:hand" src="../../skin/images/top_pro_i.gif"        alt="卸车记录"/>
					</li>
					<li style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0203' ctype='1'/>">
						<img onClick="doPro_O()" style="cursor:hand" src="../../skin/images/top_pro_o.gif"        alt="加注记录"/>
					</li>
					<li style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0204' ctype='1'/>">
						<img onClick="doPro_L()" style="cursor:hand" src="../../skin/images/top_pro_l_stat.gif"   alt="场站报表"/>
					</li>					
					<li style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0205' ctype='1'/>">
						<img onClick="doPro_S()" style="cursor:hand" src="../../skin/images/top_pro_l_corp.gif"   alt="公司报表"/>
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

function doPro_R()
{
	window.parent.frames.mFrame.location = "Pro_R.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9";
}

function doPro_I()
{
	window.parent.frames.mFrame.location = "Pro_I.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Sub_Id=2&Func_Corp_Id=9999&Func_Type_Id=";
}

function doPro_O()
{
	window.parent.frames.mFrame.location = "Pro_O.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Sub_Id=0&Func_Corp_Id=9999&Func_Type_Id=";
}

function doPro_L()
{
  var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
  var Year  = BTime.substring(0,4);
  var Month = BTime.substring(5,7);
	window.parent.frames.mFrame.location = "Pro_L.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Sub_Id=1&Func_Corp_Id=3001&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
}

function doPro_S()
{
	var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
  var Year  = BTime.substring(0,4);
  var Month = BTime.substring(5,7);
	window.parent.frames.mFrame.location = "Pro_L_Crp.do?Cmd=1&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Sub_Id=1&Func_Corp_Id=3001&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
}
</SCRIPT>
</html>