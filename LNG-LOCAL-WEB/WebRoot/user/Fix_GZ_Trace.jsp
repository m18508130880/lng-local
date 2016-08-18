<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/util.js'></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	String FpId = UserInfo.getFp_Role();
	String FpList = "";
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
 	
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	
	ArrayList User_User_Info = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	ArrayList Dev_List_Breed = (ArrayList)session.getAttribute("Dev_List_Breed_" + Sid);
	ArrayList Dev_List       = (ArrayList)session.getAttribute("Dev_List_" + Sid);
  ArrayList Fix_GZ_Trace      = (ArrayList)session.getAttribute("Fix_GZ_Trace_" + Sid);
  ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
  
  int sn = 0; 
  
%>
<body style="background:#CADFFF">
<form name="Fix_GZ_Trace"  action="Fix_Trace.do" method="post" target="mFrame">
	
		<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='25' valign='middle'>
				<td width='5%'  align='center' class="table_deep_blue">序号</td>
				<td width='15%' align='center' class="table_deep_blue">申请日期</td>				
				<td width='15%' align='center' class="table_deep_blue">故障设备</td>
				<td width='35%' align='center' class="table_deep_blue">问题描述</td>
				<td width='15%' align='center' class="table_deep_blue">开工日期</td>			
				<td width='15%' align='center' class="table_deep_blue">完成日期</td>
			</tr>
			<%
			if(Fix_GZ_Trace != null)
			{
				Iterator iterator = Fix_GZ_Trace.iterator();
				while(iterator.hasNext())
				{
					FixTraceBean Bean = (FixTraceBean)iterator.next();
					String SN         = Bean.getSN();
					String Cpm_Name   = Bean.getCpm_Name();
					String Apply_Time = Bean.getApply_Time();
					
					//申请信息
					String Dev_Name      = Bean.getDev_Name();
					String Apply_Des     = Bean.getApply_Des();
					String Apply_Man     = Bean.getApply_Man();
					String Apply_Pre     = Bean.getApply_Pre();
					String Apply_OP_Name = Bean.getApply_OP_Name();
					String Fix_BTime     = Bean.getFix_BTime();
					String Check_Time    = Bean.getCheck_Time();
	if(null !=Fix_BTime &&Fix_BTime.length()>0){}else {Fix_BTime="尚未开工";}
									
				if(null != Check_Time &&Check_Time.length()>0){}else{ Check_Time="尚未完成";}
								
					sn++;
			%>
			<tr height='25' valign='middle'>
				<td width='5%'  align='center' ><%=sn%></td>
				<td width='15%' align='center' ><%=Apply_Time%></td>				
				<td width='15%' align='center' ><%=Dev_Name%></td>
				<td width='35%' align='center' ><%=Apply_Des%></td>
				<td width='15%' align='center' ><%=Fix_BTime%></td>			
				<td width='15%' align='center' ><%=Check_Time%></td>
			</tr>						
			<%		
							
				}
			}			
			%>    		 
		</table>
</form>
</body>
</html>