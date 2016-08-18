<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/util.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/des.js'></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	
	String ManageId = UserInfo.getManage_Role();
	String IdList = "";
	if(null != ManageId && ManageId.length() > 0 && null != User_Manage_Role)
	{
		Iterator roleiter = User_Manage_Role.iterator();
		while(roleiter.hasNext())
		{
			UserRoleBean roleBean = (UserRoleBean)roleiter.next();
			if(roleBean.getId().substring(0,4).equals(ManageId) && roleBean.getId().length() == 8 && roleBean.getPoint() != null)
			{
				IdList += roleBean.getPoint();
			}
		}
	}
	String Dept_Id = UserInfo.getDept_Id();
	if(Dept_Id.length()>3){IdList = Dept_Id; }
	
%>
</head>
<body style=" background:#CADFFF">
<form name="Dvr_Info" action="Dvr_Info" method="post" target="_self">
<div id="down_bg_2">
	<table style='margin:auto' width="90%" border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
	 	<tr height='30px'>
		<%
		if(IdList.length() > 0 && null != User_Device_Detail)
		{
			int cnt = 0;
			Iterator iterator = User_Device_Detail.iterator();
			while(iterator.hasNext())
			{
				DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
				if(IdList.contains(statBean.getId()))
				{
					String _Id = statBean.getId();
					String _Brief = statBean.getBrief();
					String _Status = statBean.getStatus();
					String _LinkUrl = statBean.getLink_Url();
					String _LinkPort = statBean.getLink_Port();
					String _LinkId = statBean.getLink_Id();
					String _LinkPwd = statBean.getLink_Pwd();
					
					if(null == _LinkUrl){_LinkUrl = "";}
					if(null == _LinkId){_LinkId = "";}
					if(null == _LinkPwd){_LinkPwd = "";}
					 
					if(0 == cnt%4 && cnt > 0)
					{
			%>
						</tr>
						<tr height='30px'>
			<%
					}
			%>
					<td width='25%' height="140px" align='center'>
						<img src="../skin/images/linkcpm.gif" style="width:80px;height:60px;cursor:hand;" onClick="doSel('<%=_Status%>', '<%=_Brief%>', '<%=_LinkUrl%>', '<%=_LinkPort%>', '<%=_LinkId%>', '<%=_LinkPwd%>')">
						<br>
						<%
						if(_Status.equals("0"))
						{
						%>
							<font color=green><B><%=_Brief%></B></font>
						<%
						}
						else
						{
						%>
							<font color=gray ><B><%=_Brief%></B></font>
						<%
						}
						%>
					</td>
			<%										
					cnt++;
				}
			}
			int index = cnt%4;
			switch(index)
			{
				case 0:
					break;
				case 1:
		%>
					<td width='25%' height="140px" align='center'>&nbsp;</td>
					<td width='25%' height="140px" align='center'>&nbsp;</td>
					<td width='25%' height="140px" align='center'>&nbsp;</td>
		<%
					break;
				case 2:
		%>
					<td width='25%' height="140px" align='center'>&nbsp;</td>
					<td width='25%' height="140px" align='center'>&nbsp;</td>
		<%
					break;
				case 3:
		%>				
					<td width='25%' height="140px" align='center'>&nbsp;</td>
		<%
					break;
			}
		}
		%>
		</tr>
	</table>
</div>
</center>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doSel(pStatus, pCName, pLink_Url, pLink_Port, pLink_Id, pLink_Pwd)
{
	if('1' == pStatus)
	{
		alert('当前站点已注销!');
		return;
	}
	
	if(pLink_Url.Trim().length < 1 || pLink_Id.Trim().length < 1 || pLink_Pwd.Trim().length < 1)
	{
		alert('当前站点配置错误，无法远程查看!');
		return;
	}
	
	//ipad禁掉视频监控
	if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
	{
		alert("暂不支持Ipad网页查看视频!");
		return;
	}
	
	//链接
	var D_LinkStr = '';
	if(pLink_Port.Trim().length < 1)
		D_LinkStr = 'http://' + pLink_Url + '/cgi-bin/login.cgi?username=' + pLink_Id + '&password=' + pLink_Pwd + '&link=04';
	else
		D_LinkStr = 'http://' + pLink_Url + ':' + pLink_Port + '/cgi-bin/login.cgi?username=' + pLink_Id + '&password=' + pLink_Pwd + '&link=04';
		
	DES.init(DesKey, D_LinkStr);
	var E_LinkStr  = DES.Encrypt();
	parent.location = "L_Main.jsp?Sid=<%=Sid%>&p1="+E_LinkStr+"&p2="+pCName+"&p3=3";			
}
</SCRIPT>
</html>