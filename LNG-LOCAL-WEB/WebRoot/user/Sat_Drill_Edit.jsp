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
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String CType = CommUtil.StrToGB2312(request.getParameter("CType"));
	String SN    = CommUtil.StrToGB2312(request.getParameter("SN"));
	
	CurrStatus currStatus        = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList User_User_Info     = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	ArrayList Sat_Drill_Type     = (ArrayList)session.getAttribute("Sat_Drill_Type_" + Sid);
  ArrayList Sat_Drill          = (ArrayList)session.getAttribute("Sat_Drill_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId = UserInfo.getManage_Role();
	
	String Cpm_Id = "";
	String Cpm_Name = "";
	String Drill_Type = "";
	String Drill_Type_Name = "";
	String Drill_Title = "";
	String Drill_Time = "";
	String Drill_Cnt = "";
	String Drill_Memo = "";
	String OperName = "";
	String Drill_Assess_Des = "";
	String Drill_Assess_OP = "";
	String View_Assess_Des = "";
	String View_Assess_OP = "";
	String Status = "";
	if(Sat_Drill != null)
	{
		Iterator iterator = Sat_Drill.iterator();
		while(iterator.hasNext())
		{
			SatDrillBean Bean = (SatDrillBean)iterator.next();
			if(Bean.getSN().equals(SN))
			{
				Cpm_Id = Bean.getCpm_Id();
				Cpm_Name = Bean.getCpm_Name();
				Drill_Type = Bean.getDrill_Type();
				Drill_Type_Name = Bean.getDrill_Type_Name();				
				Drill_Title = Bean.getDrill_Title();
				Drill_Time = Bean.getDrill_Time();			
				Drill_Cnt = Bean.getDrill_Cnt();
				Drill_Memo = Bean.getDrill_Memo();		
				OperName = Bean.getOperator_Name();
				Drill_Assess_Des = Bean.getDrill_Assess_Des();
				Drill_Assess_OP = Bean.getDrill_Assess_OP();
				View_Assess_Des = Bean.getView_Assess_Des();
				View_Assess_OP = Bean.getView_Assess_OP();
				Status = Bean.getStatus();
				
				if(null == Drill_Memo){Drill_Memo = "";}				
				if(null == Drill_Assess_Des){Drill_Assess_Des = "";}
				if(null == Drill_Assess_OP){Drill_Assess_OP = "";}			
				if(null == View_Assess_Des){View_Assess_Des = "";}
				if(null == View_Assess_OP){View_Assess_OP = "";}
				
				break;
			}
		}
	}
	
	//录入人员
	String Drill_Assess_OP_Name = "";
	String View_Assess_OP_Name  = "";
	if(User_User_Info != null)
	{
		for(int i=0; i<User_User_Info.size(); i++)
		{
			UserInfoBean Info = (UserInfoBean)User_User_Info.get(i);
			if(Info.getId().equals(Drill_Assess_OP))
				Drill_Assess_OP_Name = Info.getCName();
			if(Info.getId().equals(View_Assess_OP))
				View_Assess_OP_Name = Info.getCName();
		}
	}
	
%>
<body style="background:#CADFFF">
<form name="Sat_Drill_Edit" action="Sat_Drill.do" method="post" target="mFrame">
<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
<%
switch(Integer.parseInt(CType))
{
	case 1:
%>
			<tr height='30' class='table_blue'>
			  <td width='100%' align='center' colspan=4><B>演练基本信息(录入人员:<%=OperName%>)</B></td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>演练单位</td>
				<td width='30%' align='left'>
					<select name="Cpm_Id" style="width:95%;height:20px">
					<%
					String Role_List = "";
					if(ManageId.length() > 0 && null != User_Manage_Role)
					{
						Iterator iterator = User_Manage_Role.iterator();
						while(iterator.hasNext())
						{
							UserRoleBean statBean = (UserRoleBean)iterator.next();
							if(statBean.getId().substring(0,4).equals(ManageId) && statBean.getId().length() == 8)
							{
								String R_Point = statBean.getPoint();
								if(null == R_Point){R_Point = "";}
								Role_List += R_Point;
							}
						}
					}
					if(Role_List.length() > 0 && null != User_Device_Detail)
					{
						Iterator iterator = User_Device_Detail.iterator();
						while(iterator.hasNext())
						{
							DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
							if(Role_List.contains(statBean.getId()))
							{
					%>
								<option value='<%=statBean.getId()%>' <%=statBean.getId().equals(Cpm_Id)?"selected":""%>><%=statBean.getBrief()%></option>
					<%
							}
						}
					}
					%>
					</select>
				</td>
				<td width='20%' align='center'>演练类型</td>
				<td width='30%' align='left'>
					<select name="Drill_Type" style="width:95%;height:20px">
					<%
					if(null != Sat_Drill_Type)
					{
						Iterator typeiter = Sat_Drill_Type.iterator();
						while(typeiter.hasNext())
						{
							AqscDrillTypeBean typeBean = (AqscDrillTypeBean)typeiter.next();
							if(typeBean.getStatus().equals("0"))
							{
					%>
								<option value='<%=typeBean.getId()%>' <%=typeBean.getId().equals(Drill_Type)?"selected":""%>><%=typeBean.getCName()%></option>
					<%
							}
						}
					}
					%>
					</select>
				</td>								
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>演练时间</td>
				<td width='30%' align='left'>
					<input type='text' name='Drill_Time' style='width:94%;height:18px;' value='<%=Drill_Time%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				</td>
				<td width='20%' align='center'>参演人数</td>
				<td width='30%' align='left'>
					<input type='text' name='Drill_Cnt'  style="width:82%;height:16px" value='<%=Drill_Cnt%>' maxlength=4> 人
				</td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>演练名称</td>
				<td width='80%' align='left' colspan=3>
					<input type='text' name='Drill_Title' style="width:97%;height:16px" value='<%=Drill_Title%>' maxlength=32>
				</td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>演练备注</td>
				<td width='80%' align='left' colspan=3>
					<textarea name='Drill_Memo' rows='6' cols='64' maxlength=128><%=Drill_Memo%></textarea>
				</td>
			</tr>
<%
		break;
	case 2:
%>
			<input type="hidden" name="Cpm_Id" value="<%=Cpm_Id%>">
			<tr height='30' class='table_blue'>
			  <td width='100%' align='center' colspan=4><B>演练效果评估(评估人员:<%=Drill_Assess_OP_Name%>)</B></td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>简要描述</td>
				<td width='80%' align='left' colspan=3>
					<textarea name='Drill_Assess_Des' rows='10' cols='65' maxlength=128><%=Drill_Assess_Des%></textarea>
				</td>
			</tr>
<%
		break;
	case 3:
%>
			<input type="hidden" name="Cpm_Id" value="<%=Cpm_Id%>">
			<tr height='30' class='table_blue'>
			  <td width='100%' align='center' colspan=4><B>观摩效果评估(评估人员:<%=View_Assess_OP_Name%>)</B></td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>简要描述</td>
				<td width='80%' align='left' colspan=3>
					<textarea name='View_Assess_Des' rows='10' cols='65' maxlength=128><%=View_Assess_Des%></textarea>
				</td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>状态跟踪</td>
				<td width='80%' align='left' colspan=3>
					<select name='Status' style='width:120px;height:20px;'>
						<option value='0' <%=Status.equals("0")?"selected":""%>>计划中</option>
						<option value='1' <%=Status.equals("1")?"selected":""%>>已关闭</option>
					</select>
				</td>
			</tr>
<%
		break;
}
%>
	<tr height='40'>
		<td width='100%' align='center' colspan=4>
			<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
		</td>
	</tr>
</table>
<input type="hidden" name="Cmd"             value="11">
<input type="hidden" name="Sid"             value="<%=Sid%>">
<input type="hidden" name="SN"              value="<%=SN%>">
<input type="hidden" name="Operator"        value="<%=Operator%>">
<input type="hidden" name="Drill_Assess_OP" value="<%=Operator%>">
<input type="hidden" name="View_Assess_OP"  value="<%=Operator%>">
<input type="hidden" name="Func_Corp_Id"    value="<%=currStatus.getFunc_Corp_Id()%>">
<input type="hidden" name="Func_Sub_Id"     value="<%=currStatus.getFunc_Sub_Id()%>">
<input type="hidden" name="CurrPage"        value="<%=currStatus.getCurrPage()%>">
<input type="hidden" name="BTime"           value="<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>">
<input type="hidden" name="ETime"           value="<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doEdit()
{
	switch(parseInt(<%=CType%>))
	{
		case 1:
				if(Sat_Drill_Edit.Cpm_Id.value.length < 1)
			  {
			  	alert('请选择演练单位!');
			  	return;
			  }
				if(Sat_Drill_Edit.Drill_Type.value.length < 1 || Sat_Drill_Edit.Drill_Type.value == '*')
			  {
			  	alert('请选择演练类型!');
			  	return;
			  }			  
			  if(Sat_Drill_Edit.Drill_Time.value.length < 1)
			  {
			  	alert('请选择演练时间!');
			  	return;
			  }
			  if(Sat_Drill_Edit.Drill_Cnt.value.Trim().length < 1 || Sat_Drill_Edit.Drill_Cnt.value <= 0)
			  {
			  	alert("参演人数输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
					return;
			  }
			  for(var i=0; i<Sat_Drill_Edit.Drill_Cnt.value.length; i++)
				{
					if(isNaN(Sat_Drill_Edit.Drill_Cnt.value.charAt(i)))
				  {
				    alert("参演人数输入有误，请重新输入!");
				    return;
				  }
				}
				if(Sat_Drill_Edit.Drill_Title.value.Trim().length < 1)
			  {
			  	alert('请填写演练名称!');
			  	return;
			  }
			  if(Sat_Drill_Edit.Drill_Memo.value.Trim().length > 128)
			  {
			    alert("演练备注描述过长，请简化!");
			    return;
			  }
			  Sat_Drill_Edit.Cmd.value = 11;
			break;
		case 2:
				if(Sat_Drill_Edit.Drill_Assess_Des.value.Trim().length < 1)
				{
					alert('请填写简要描述!');
					return;
				}
				if(Sat_Drill_Edit.Drill_Assess_Des.value.Trim().length > 128)
			  {
			    alert("简要描述过长，请简化!");
			    return;
			  }
				Sat_Drill_Edit.Cmd.value = 12;
			break;
		case 3:
				if(Sat_Drill_Edit.View_Assess_Des.value.Trim().length < 1)
				{
					alert('请填写简要描述!');
					return;
				}
				if(Sat_Drill_Edit.View_Assess_Des.value.Trim().length > 128)
			  {
			    alert("简要描述过长，请简化!");
			    return;
			  }
				Sat_Drill_Edit.Cmd.value = 13;
			break;
	}
	if(confirm("信息无误,确定提交?"))
  {
		Sat_Drill_Edit.submit();
  }
}
</SCRIPT>
</html>