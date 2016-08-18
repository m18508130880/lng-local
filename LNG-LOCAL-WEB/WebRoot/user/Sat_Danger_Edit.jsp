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
</head>
<%
	
	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String CType = CommUtil.StrToGB2312(request.getParameter("CType"));
	String SN    = CommUtil.StrToGB2312(request.getParameter("SN"));
	
	CurrStatus currStatus        = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Sat_Danger_Type    = (ArrayList)session.getAttribute("Sat_Danger_Type_" + Sid);
	ArrayList Sat_Danger_Level   = (ArrayList)session.getAttribute("Sat_Danger_Level_" + Sid);
	ArrayList User_User_Info     = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	ArrayList Sat_Danger         = (ArrayList)session.getAttribute("Sat_Danger_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId = UserInfo.getManage_Role();
	
	String Cpm_Id = "";
	String Cpm_Name = "";
	String Danger_Type = "";
	String Danger_Type_Name = "";
	String Danger_Level = "";
	String Danger_Level_Name = "";
	String Danger_Des = "";
	String Danger_BTime = "";
	String Danger_ETime = "";
	String OperName = "";
	String Danger_Plan = "";
	String Danger_Plan_Des = "";
	String Danger_Plan_OP = "";
	String Danger_Act = "";
	String Danger_Act_Des = "";
	String Danger_Act_OP = "";
	String Danger_Check = "";
	String Danger_Check_OP = "";
	String Status = "";
	if(Sat_Danger != null)
	{
		Iterator iterator = Sat_Danger.iterator();
		while(iterator.hasNext())
		{
			SatDangerBean Bean = (SatDangerBean)iterator.next();
			if(Bean.getSN().equals(SN))
			{
				Cpm_Id = Bean.getCpm_Id();
				Cpm_Name = Bean.getCpm_Name();
				Danger_Type = Bean.getDanger_Type();
				Danger_Type_Name = Bean.getDanger_Type_Name();
				Danger_Level = Bean.getDanger_Level();
				Danger_Level_Name = Bean.getDanger_Level_Name();
				Danger_Des = Bean.getDanger_Des();
				Danger_BTime = Bean.getDanger_BTime();
				Danger_ETime = Bean.getDanger_ETime();
				OperName = Bean.getOperator_Name();
				Danger_Plan = Bean.getDanger_Plan();
				Danger_Plan_Des = Bean.getDanger_Plan_Des();
				Danger_Plan_OP = Bean.getDanger_Plan_OP();
				Danger_Act = Bean.getDanger_Act();
				Danger_Act_Des = Bean.getDanger_Act_Des();
				Danger_Act_OP = Bean.getDanger_Act_OP();
				Danger_Check = Bean.getDanger_Check();
				Danger_Check_OP = Bean.getDanger_Check_OP();
				Status = Bean.getStatus();
				
				if(null == Danger_Plan){Danger_Plan = "";}
				if(null == Danger_Plan_Des){Danger_Plan_Des = "";}
				if(null == Danger_Plan_OP){Danger_Plan_OP = "";}
				if(null == Danger_Act){Danger_Act = "";}
				if(null == Danger_Act_Des){Danger_Act_Des = "";}
				if(null == Danger_Act_OP){Danger_Act_OP = "";}
				if(null == Danger_Check){Danger_Check = "";}
				if(null == Danger_Check_OP){Danger_Check_OP = "";}
				
				break;
			}
		}
	}
	
	//录入人员
	String Danger_Plan_OP_Name = "";
	String Danger_Act_OP_Name = "";
	String Danger_Check_OP_Name = "";
	if(User_User_Info != null)
	{
		for(int i=0; i<User_User_Info.size(); i++)
		{
			UserInfoBean Info = (UserInfoBean)User_User_Info.get(i);
			if(Info.getId().equals(Danger_Plan_OP))
				Danger_Plan_OP_Name = Info.getCName();
			if(Info.getId().equals(Danger_Act_OP))
				Danger_Act_OP_Name = Info.getCName();
			if(Info.getId().equals(Danger_Check_OP))
				Danger_Check_OP_Name = Info.getCName();
		}
	}
	
%>
<body style="background:#CADFFF">
<form name="Sat_Danger_Edit" action="Sat_Danger_File.do" method="post" target="mFrame" enctype="multipart/form-data">
<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
<%
switch(Integer.parseInt(CType))
{
	case 1:
%>
			<tr height='30' class='table_blue'>
			  <td width='100%' align='center' colspan=4><B>隐患基本信息(录入人员:<%=OperName%>)</B></td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>隐患分类</td>
				<td width='30%' align='left'>
					<select name="Danger_Type" style="width:95%;height:20px">
						<option value='*'>请选择...</option>
						<%
						if(null != Sat_Danger_Type)
						{
							Iterator typeiter = Sat_Danger_Type.iterator();
							while(typeiter.hasNext())
							{
								AqscDangerTypeBean typeBean = (AqscDangerTypeBean)typeiter.next();
								if(typeBean.getStatus().equals("0"))
								{
						%>
									<option value='<%=typeBean.getId()%>' <%=typeBean.getId().equals(Danger_Type)?"selected":""%>><%=typeBean.getCName()%></option>
						<%
								}
							}
						}
						%>
					</select>
				</td>
				<td width='20%' align='center'>隐患级别</td>
				<td width='30%' align='left'>
					<select name="Danger_Level" style="width:95%;height:20px">
						<option value='*'>请选择...</option>
						<%
						if(null != Sat_Danger_Level)
						{
							Iterator leveliter = Sat_Danger_Level.iterator();
							while(leveliter.hasNext())
							{
								AqscDangerLevelBean levelBean = (AqscDangerLevelBean)leveliter.next();
								if(levelBean.getStatus().equals("0"))
								{
						%>
									<option value='<%=levelBean.getId()%>' <%=levelBean.getId().equals(Danger_Level)?"selected":""%>><%=levelBean.getCName()%></option>
						<%
								}
							}
						}
						%>
					</select>
				</td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>隐患描述</td>
				<td width='30%' align='left'>
					<textarea name='Danger_Des' rows='3' cols='21' maxlength=128><%=Danger_Des%></textarea>
				</td>
				<td width='20%' align='center'>责任部门</td>
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
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>发现日期</td>
				<td width='30%' align='left'>
					<input name='Danger_BTime' type='text' style='width:94%;height:18px;' value='<%=Danger_BTime%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				</td>
				<td width='20%' align='center'>整改期限</td>
				<td width='30%' align='left'>
					<input name='Danger_ETime' type='text' style='width:94%;height:18px;' value='<%=Danger_ETime%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				</td>
			</tr>
<%
		break;
	case 2:
%>
			<input type="hidden" name="Cpm_Id" value="<%=Cpm_Id%>">
			<tr height='30' class='table_blue'>
			  <td width='100%' align='center' colspan=4><B>确定方案(录入人员:<%=Danger_Plan_OP_Name%>)</B></td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>简要描述</td>
				<td width='80%' align='left' colspan=3>
					<textarea name='Danger_Plan_Des' rows='5' cols='65' maxlength=128><%=Danger_Plan_Des%></textarea>
				</td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>原有文档</td>
				<td width='80%' align='left' colspan=3>
					<%
					if(Danger_Plan.length() > 0)
					{
					%>
						<a href='../files/upfiles/<%=Danger_Plan%>' title='点击下载'><%=Danger_Plan%></a>
					<%
					}
					else
					{
					%>
						尚未上传文档!
					<%
					}
					%>
					<input type='hidden' name='Danger_Plan' value='<%=Danger_Plan%>'>
				</td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>文档上传</td>
				<td width='80%' align='left' colspan=3>
					<input name='file' type='file' style='width:99%;height:20px;' title='文档上传'>
				</td>
			</tr>
<%
		break;
	case 3:
%>
			<input type="hidden" name="Cpm_Id" value="<%=Cpm_Id%>">
			<tr height='30' class='table_blue'>
			  <td width='100%' align='center' colspan=4><B>实施整改(录入人员:<%=Danger_Act_OP_Name%>)</B></td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>简要描述</td>
				<td width='80%' align='left' colspan=3>
					<textarea name='Danger_Act_Des' rows='5' cols='65' maxlength=128><%=Danger_Act_Des%></textarea>
				</td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>原有文档</td>
				<td width='80%' align='left' colspan=3>
					<%
					if(Danger_Act.length() > 0)
					{
					%>
						<a href='../files/upfiles/<%=Danger_Act%>' title='点击下载'><%=Danger_Act%></a>
					<%
					}
					else
					{
					%>
						尚未上传文档!
					<%
					}
					%>
					<input type='hidden' name='Danger_Act' value='<%=Danger_Act%>'>
				</td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>文档上传</td>
				<td width='80%' align='left' colspan=3>
					<input name='file' type='file' style='width:99%;height:20px;' title='文档上传'>
				</td>
			</tr>
<%
		break;
	case 4:
%>
			<input type="hidden" name="Cpm_Id" value="<%=Cpm_Id%>">
			<tr height='30' class='table_blue'>
			  <td width='100%' align='center' colspan=4><B>审核验收(录入人员:<%=Danger_Check_OP_Name%>)</B></td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>简要描述</td>
				<td width='80%' align='left' colspan=3>
					<textarea name='Danger_Check' rows='5' cols='65' maxlength=128><%=Danger_Check%></textarea>
				</td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>状态跟踪</td>
				<td width='80%' align='left' colspan=3>
					<select name='Status' style='width:120px;height:20px;'>
						<option value='0' <%=Status.equals("0")?"selected":""%>>整改中</option>
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
<input type="hidden" name="Danger_Plan_OP"  value="<%=Operator%>">
<input type="hidden" name="Danger_Act_OP"   value="<%=Operator%>">
<input type="hidden" name="Danger_Check_OP" value="<%=Operator%>">
<input type="hidden" name="Func_Corp_Id"    value="<%=currStatus.getFunc_Corp_Id()%>">
<input type="hidden" name="Func_Type_Id"    value="<%=currStatus.getFunc_Type_Id()%>">
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
				if(Sat_Danger_Edit.Danger_Type.value.length < 1 || Sat_Danger_Edit.Danger_Type.value == '*')
			  {
			  	alert('请选择隐患类型!');
			  	return;
			  }
			  if(Sat_Danger_Edit.Danger_Level.value.length < 1 || Sat_Danger_Edit.Danger_Level.value == '*')
			  {
			  	alert('请选择隐患级别!');
			  	return;
			  }
			  if(Sat_Danger_Edit.Cpm_Id.value.length < 1)
			  {
			  	alert('请选择责任部门!');
			  	return;
			  }
			  if(Sat_Danger_Edit.Danger_BTime.value.length < 1)
			  {
			  	alert('请选择发现日期!');
			  	return;
			  }
			  if(Sat_Danger_Edit.Danger_ETime.value.length < 1)
			  {
			  	alert('请选择整改期限!');
			  	return;
			  }
			  if(Sat_Danger_Edit.Danger_BTime.value > Sat_Danger_Edit.Danger_ETime.value)
			  {
			  	alert('发现日期需在整改期限之前!');
			  	return;
			  }
				if(Sat_Danger_Edit.Danger_Des.value.Trim().length < 1)
				{
					alert('请简要描述隐患情况!');
					return;
				}
				if(Sat_Danger_Edit.Danger_Des.value.Trim().length > 128)
			  {
			    alert("隐患情况描述过长，请简化!");
			    return;
			  }
			  Sat_Danger_Edit.Cmd.value = 11;
			  if(confirm("信息无误,确定提交?"))
			  {
			  	parent.location = "Sat_Danger.do?Cmd=11&Sid=<%=Sid%>&SN=<%=SN%>&Operator=<%=Operator%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&CurrPage=<%=currStatus.getCurrPage()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>"
			  	         		    + "&Cpm_Id=" + Sat_Danger_Edit.Cpm_Id.value
			  	         			  + "&Danger_Type=" + Sat_Danger_Edit.Danger_Type.value
			  	         			  + "&Danger_Level=" + Sat_Danger_Edit.Danger_Level.value
			  	         			  + "&Danger_Des=" + Sat_Danger_Edit.Danger_Des.value
			  	         			  + "&Danger_BTime=" + Sat_Danger_Edit.Danger_BTime.value
			  	        	 		  + "&Danger_ETime=" + Sat_Danger_Edit.Danger_ETime.value;
			  }
			break;
		case 2:
				if(Sat_Danger_Edit.Danger_Plan_Des.value.Trim().length < 1)
				{
					alert('请填写简要描述!');
					return;
				}
				if(Sat_Danger_Edit.Danger_Plan_Des.value.Trim().length > 128)
			  {
			    alert("简要描述过长，请简化!");
			    return;
			  }
				if(Sat_Danger_Edit.file.value.Trim().length > 0)
			  {
			  	if(Sat_Danger_Edit.file.value.indexOf('.doc') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.DOC') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.docx') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.DOCX') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.xls') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.XLS') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.xlsx') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.XLSX') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.pdf') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.PDF') == -1)
					{
						alert('请确认文档格式,支持doc,docx,xls,xlsx,pdf格式!');
						return;
					}
			  }
				Sat_Danger_Edit.Cmd.value = 12;
				var currFirm = '信息无误,确定提交?';
				if('<%=Danger_Plan%>'.length > 0 && Sat_Danger_Edit.file.value.Trim().length > 0)
				{
					currFirm = '原有文档已存在,确定替换?';
				}
				if(confirm(currFirm))
			  {
					Sat_Danger_Edit.submit();
			  }
			break;
		case 3:
				if(Sat_Danger_Edit.Danger_Act_Des.value.Trim().length < 1)
				{
					alert('请填写简要描述!');
					return;
				}
				if(Sat_Danger_Edit.Danger_Act_Des.value.Trim().length > 128)
			  {
			    alert("简要描述过长，请简化!");
			    return;
			  }
				if(Sat_Danger_Edit.file.value.Trim().length > 0)
			  {
			  	if(Sat_Danger_Edit.file.value.indexOf('.doc') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.DOC') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.docx') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.DOCX') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.xls') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.XLS') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.xlsx') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.XLSX') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.pdf') == -1 
			  	&& Sat_Danger_Edit.file.value.indexOf('.PDF') == -1)
					{
						alert('请确认文档格式,支持doc,docx,xls,xlsx,pdf格式!');
						return;
					}
			  }
				Sat_Danger_Edit.Cmd.value = 13;
				var currFirm = '信息无误,确定提交?';
				if('<%=Danger_Act%>'.length > 0 && Sat_Danger_Edit.file.value.Trim().length > 0)
				{
					currFirm = '原有文档已存在,确定替换?';
				}
				if(confirm(currFirm))
			  {
					Sat_Danger_Edit.submit();
			  }
			break;
		case 4:
				if(Sat_Danger_Edit.Danger_Check.value.Trim().length < 1)
				{
					alert('请填写简要描述!');
					return;
				}
				if(Sat_Danger_Edit.Danger_Check.value.Trim().length > 128)
			  {
			    alert("简要描述过长，请简化!");
			    return;
			  }
				Sat_Danger_Edit.Cmd.value = 14;
				if(confirm("信息无误,确定提交?"))
			  {
			  	parent.location = "Sat_Danger.do?Cmd=14&Sid=<%=Sid%>&SN=<%=SN%>&Danger_Check_OP=<%=Operator%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&CurrPage=<%=currStatus.getCurrPage()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>"
			  	         		    + "&Cpm_Id=" + Sat_Danger_Edit.Cpm_Id.value
			  	         		    + "&Danger_Check=" + Sat_Danger_Edit.Danger_Check.value
			  	         			  + "&Status=" + Sat_Danger_Edit.Status.value;
			  }
			break;
	}
}
</SCRIPT>
</html>