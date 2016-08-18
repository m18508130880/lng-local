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
	String BDate = CommUtil.getDate();
	
	CurrStatus currStatus        = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Dev_List           = (ArrayList)session.getAttribute("Dev_List_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator      = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId      = UserInfo.getManage_Role();
	
%>
<body style="background:#CADFFF">
<form name="Fix_Trace_Add" action="Fix_Trace.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/fix_trace_add.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="60%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30'>
				<td width='100%' align='right'>
					<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doAdd()'>
					<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>
				</td>
			</tr>
			<tr height='30'>
				<td width='100%' align='center'>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">						
						<tr height='30'>
							<td width='25%' align='center'>申请场站</td>
							<td width='75%' align='left'>							
								<select name="Cpm_Id" style="width:91%;height:20px" onchange="doChange(this.value)">
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
											<option value='<%=statBean.getId()%>'><%=statBean.getBrief()%></option>
								<%
										}
									}
								}
								%>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>故障设备</td>
							<td width='75%' align='left'>							
								<select id="Dev_SN" name="Dev_SN" style="width:91%;height:20px">
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>申请日期</td>
							<td width='75%' align='left'>
								<input name='Apply_Time' type='text' style='width:90%;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>问题描述</td>
							<td width='75%' align='left'>
								<textarea name='Apply_Des' rows='4' cols='59' maxlength=128></textarea>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>应急措施</td>
							<td width='75%' align='left'>
								<textarea name='Apply_Pre' rows='4' cols='59' maxlength=128></textarea>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>申请人员</td>
							<td width='75%' align='left'>
								<input name='Apply_Man' type='text' style='width:90%;height:16px;' value='' maxlength='10'>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>录入人员</td>
							<td width='75%' align='left'>
								<%=Operator_Name%>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input type="hidden" name="Cmd"      value="10">
<input type="hidden" name="Sid"      value="<%=Sid%>">
<input type="hidden" name="Apply_OP" value="<%=Operator%>">
<input type="hidden" name="BTime"    value="<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>">
<input type="hidden" name="ETime"    value="<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>">
<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
<input type="hidden" name="Func_Sub_Id"  value="<%=currStatus.getFunc_Sub_Id()%>">
<input type="hidden" name="CurrPage"     value="<%=currStatus.getCurrPage()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Fix_Trace_Add.jsp';

function doNO()
{
	location = "Fix_To_Trace.jsp?Sid=<%=Sid%>";
}

function doChange(pCpm_Id)
{
	//先删除
	var length = document.getElementById('Dev_SN').length;
	for(var i=0; i<length; i++)
	{
		document.getElementById('Dev_SN').remove(0);
	}
	
	//再添加
	if(pCpm_Id.length > 0)
	{
		<%
		if(null != Dev_List)
		{
			Iterator deviter = Dev_List.iterator();
			while(deviter.hasNext())
			{
				DevListBean devBean = (DevListBean)deviter.next();
				String dev_sn   = devBean.getSN();
				String dev_id   = devBean.getCpm_Id();
				String dev_name = devBean.getDev_Name();
		%>
				if('<%=dev_id%>' == pCpm_Id)
				{
					var objOption = document.createElement('OPTION');
					objOption.value = '<%=dev_sn%>';
					objOption.text  = '<%=dev_name%>';
					document.getElementById('Dev_SN').add(objOption);
				}
		<%
			}
		}
		%>
	}
}
doChange(Fix_Trace_Add.Cpm_Id.value);

function doAdd()
{
	if(Fix_Trace_Add.Cpm_Id.value.length < 1)
  {
  	alert('请选择申请场站!');
  	return;
  }
  if(Fix_Trace_Add.Dev_SN.value.length < 1)
  {
  	alert('请选择故障设备!');
  	return;
  }
  if(Fix_Trace_Add.Apply_Time.value.length < 1)
  {
  	alert('请选择申请日期!');
  	return;
  }
  if(Fix_Trace_Add.Apply_Des.value.Trim().length < 1)
	{
		alert('请填写问题描述!');
		return;
	}
	if(Fix_Trace_Add.Apply_Des.value.Trim().length > 128)
  {
    alert("问题描述过长，请简化!");
    return;
  }
  if(Fix_Trace_Add.Apply_Pre.value.Trim().length < 1)
	{
		alert('请填写应急措施!');
		return;
	}
	if(Fix_Trace_Add.Apply_Pre.value.Trim().length > 128)
  {
    alert("应急措施过长，请简化!");
    return;
  }
  if(Fix_Trace_Add.Apply_Man.value.Trim().length < 1)
  {
  	alert('请填写申请人员!');
  	return;
  }
  if(confirm("信息无误,确定提交?"))
  {
		Fix_Trace_Add.submit();
  }
}
</SCRIPT>
</html>