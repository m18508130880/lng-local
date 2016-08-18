<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<html>
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type='text/css' href='../skin/css/style.css' rel='stylesheet'/>
<script type='text/javascript' src='../skin/js/My97DatePicker/WdatePicker.js'></script>
<script type='text/javascript' src='../skin/js/util.js'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String BDate = CommUtil.getDate();
	
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId = UserInfo.getManage_Role();
  
 	CurrStatus currStatus      = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Sat_Drill_Type   = (ArrayList)session.getAttribute("Sat_Drill_Type_" + Sid);
	
%>
<body style="background:#CADFFF">
<form name="Sat_Drill_Add" action="Sat_Drill.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/sat_drill_add.gif"></div><br><br><br>
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
							<td width='25%' align='center'>演练单位</td>
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
							<td width='25%' align='center'>演练类型</td>
							<td width='75%' align='left'>
								<select name="Drill_Type" style="width:120px;height:20px">
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
							<td width='25%' align='center'>演练时间</td>
							<td width='75%' align='left'>
								<input name='Drill_Time' type='text' style='width:118px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>参演人数</td>
							<td width='75%' align='left'>
								<input type='text' name='Drill_Cnt' style="width:118px;height:18px" value='' maxlength=4> 人
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>演练名称</td>
							<td width='75%' align='left'>
								<input type='text' name='Drill_Title' style="width:99%;height:18px" value='' maxlength=32>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>演练备注</td>
							<td width='75%' align='left'>
								<textarea name='Drill_Memo' rows='5' cols='53' maxlength=128></textarea>
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
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Sat_Drill_Add.jsp';

function doNO()
{
	location = "Sat_To_Drill.jsp?Sid=<%=Sid%>";
}

var reqAdd = null;
function doAdd()
{
  if(Sat_Drill_Add.Cpm_Id.value.length < 1)
  {
  	alert('请选择演练单位!');
  	return;
  }
  if(Sat_Drill_Add.Drill_Type.value.length < 1)
  {
  	alert('请选择演练类型!');
  	return;
  }
  if(Sat_Drill_Add.Drill_Time.value.length < 1)
  {
  	alert('请选择演练时间!');
  	return;
  }
  if(Sat_Drill_Add.Drill_Cnt.value.Trim().length < 1 || Sat_Drill_Add.Drill_Cnt.value <= 0)
  {
  	alert("参演人数输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Sat_Drill_Add.Drill_Cnt.value.length; i++)
	{
		if(isNaN(Sat_Drill_Add.Drill_Cnt.value.charAt(i)))
	  {
	    alert("参演人数输入有误，请重新输入!");
	    return;
	  }
	}
  if(Sat_Drill_Add.Drill_Title.value.Trim().length < 1)
  {
  	alert('请填写演练名称!');
  	return;
  }
  if(Sat_Drill_Add.Drill_Memo.value.Trim().length > 128)
  {
    alert("演练备注描述过长，请简化!");
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
						Sat_Drill_Add.Drill_Cnt.value = '';
						Sat_Drill_Add.Drill_Title.value = '';
						Sat_Drill_Add.Drill_Memo.value = '';
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
		var url = 'Sat_Drill_Add.do?Cmd=10&Sid=<%=Sid%>&Cpm_Id='+Sat_Drill_Add.Cpm_Id.value
		        + '&Drill_Type='+Sat_Drill_Add.Drill_Type.value
		        + '&Drill_Time='+Sat_Drill_Add.Drill_Time.value
		        + '&Drill_Cnt='+Sat_Drill_Add.Drill_Cnt.value.Trim()
		        + '&Drill_Title='+Sat_Drill_Add.Drill_Title.value.Trim()
		        + '&Drill_Memo='+Sat_Drill_Add.Drill_Memo.value.Trim()
		        + '&Operator=<%=Operator%>&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&currtime='+new Date();
		reqAdd.open("post",url,true);
		reqAdd.send(null);
		return true;
  }
}
</SCRIPT>
</html>