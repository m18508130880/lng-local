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
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String BDate = CommUtil.getDate();
	
	ArrayList Sat_Danger_Type    = (ArrayList)session.getAttribute("Sat_Danger_Type_" + Sid);
	ArrayList Sat_Danger_Level   = (ArrayList)session.getAttribute("Sat_Danger_Level_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId = UserInfo.getManage_Role();
	
%>
<body style="background:#CADFFF">
<form name="Sat_Danger_Add" action="Sat_Danger.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/sat_danger_add.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="50%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
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
							<td width='25%' align='center'>隐患分类</td>
							<td width='75%' align='left'>
								<select name="Danger_Type" style="width:120px;height:20px">
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
												<option value='<%=typeBean.getId()%>'><%=typeBean.getCName()%></option>
									<%
											}
										}
									}
									%>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>隐患级别</td>
							<td width='75%' align='left'>
								<select name="Danger_Level" style="width:120px;height:20px">
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
												<option value='<%=levelBean.getId()%>'><%=levelBean.getCName()%></option>
									<%
											}
										}
									}
									%>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>责任部门</td>
							<td width='75%' align='left'>							
								<select name="Cpm_Id" style="width:120px;height:20px">
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
							<td width='25%' align='center'>发现日期</td>
							<td width='75%' align='left'>
								<input name='Danger_BTime' type='text' style='width:118px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>整改期限</td>
							<td width='75%' align='left'>
								<input name='Danger_ETime' type='text' style='width:118px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>					
						<tr height='30'>
							<td width='25%' align='center'>隐患描述</td>
							<td width='75%' align='left'>
								<textarea name='Danger_Des' rows='5' cols='53' maxlength=128></textarea>
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
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Sat_Danger_Add.jsp';

function doNO()
{
	location = "Sat_Danger.jsp?Sid=<%=Sid%>";
}

var reqAdd = null;
function doAdd()
{
	if(Sat_Danger_Add.Danger_Type.value.length < 1 || Sat_Danger_Add.Danger_Type.value == '*')
  {
  	alert('请选择隐患类型!');
  	return;
  }
  if(Sat_Danger_Add.Danger_Level.value.length < 1 || Sat_Danger_Add.Danger_Level.value == '*')
  {
  	alert('请选择隐患级别!');
  	return;
  }
  if(Sat_Danger_Add.Cpm_Id.value.length < 1)
  {
  	alert('请选择责任部门!');
  	return;
  }
  if(Sat_Danger_Add.Danger_BTime.value.length < 1)
  {
  	alert('请选择发现日期!');
  	return;
  }
  if(Sat_Danger_Add.Danger_ETime.value.length < 1)
  {
  	alert('请选择整改期限!');
  	return;
  }
  if(Sat_Danger_Add.Danger_BTime.value > Sat_Danger_Add.Danger_ETime.value)
  {
  	alert('发现日期需在整改期限之前!');
  	return;
  }
	if(Sat_Danger_Add.Danger_Des.value.Trim().length < 1)
	{
		alert('请简要描述隐患情况!');
		return;
	}
	if(Sat_Danger_Add.Danger_Des.value.Trim().length > 128)
  {
    alert("隐患情况描述过长，请简化!");
    return;
  }
  if(confirm("信息无误,确定提交?"))
  {
  	if(window.XMLHttpRequest)
	  {
			reqAdd = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqAdd = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//设置回调函数
		reqAdd.onreadystatechange = function()
		{
			var state = reqAdd.readyState;
			if(state == 4)
			{
				if(reqAdd.status == 200)
				{
					var resp = reqAdd.responseText;			
					if(resp != null && resp.substring(0,4) == '0000')
					{
						alert('成功');
						Sat_Danger_Add.Danger_Des.value   = '';
						return;
					}
					else
					{
						alert('失败，请重新操作');
						return;
					}
				}
				else
				{
					alert("失败，请重新操作");
					return;
				}
			}
		};
		var url = 'Sat_Danger_Add.do?Cmd=10&Sid=<%=Sid%>&Cpm_Id='+Sat_Danger_Add.Cpm_Id.value+'&Danger_Type='+Sat_Danger_Add.Danger_Type.value+'&Danger_Level='+Sat_Danger_Add.Danger_Level.value+'&Danger_BTime='+Sat_Danger_Add.Danger_BTime.value+'&Danger_ETime='+Sat_Danger_Add.Danger_ETime.value+'&Danger_Des='+Sat_Danger_Add.Danger_Des.value.Trim()+'&Operator=<%=Operator%>&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&currtime='+new Date();
		reqAdd.open("post",url,true);
		reqAdd.send(null);
		return true;
  }
}
</SCRIPT>
</html>