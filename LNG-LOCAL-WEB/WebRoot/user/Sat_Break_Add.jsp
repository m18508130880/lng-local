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
	ArrayList User_User_Info     = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId = UserInfo.getManage_Role();
	
%>
<body style="background:#CADFFF">
<form name="Sat_Break_Add" action="Sat_Break.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/sat_break_add.gif"></div><br><br><br>
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
							<td width='25%' align='center'>所属场站</td>
							<td width='75%' align='left'>							
								<select name="Cpm_Id" style="width:120px;height:20px" onchange="doChange(this.value)">
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
							<td width='25%' align='center'>违章时间</td>
							<td width='75%' align='left'>
								<input name='Break_Time' type='text' style='width:118px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>违 章 人</td>
							<td width='75%' align='left'>
								<select id="Break_OP" name="Break_OP" style="width:120px;height:20px">
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>直接管理人</td>
							<td width='75%' align='left'>
								<select id="Manag_OP" name="Manag_OP" style="width:120px;height:20px">
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>绩效挂钩</td>
							<td width='75%' align='left'>
								<input type='text' name='Break_Point' style="width:118px;height:18px" value='' maxlength=4> 分
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>违章行为<br>(违反条款)</td>
							<td width='75%' align='left'>
								<textarea name='Break_Des' rows='5' cols='53' maxlength=128></textarea>
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
window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Sat_Break_Add.jsp';

function doNO()
{
	location = "Sat_Break.jsp?Sid=<%=Sid%>";
}

function doChange(pCpm_Id)
{
	//先删除
	var length1 = document.getElementById('Break_OP').length;
	for(var i=0; i<length1; i++)
	{
		document.getElementById('Break_OP').remove(0);
	}
	
	var length2 = document.getElementById('Manag_OP').length;
	for(var i=0; i<length2; i++)
	{
		document.getElementById('Manag_OP').remove(0);
	}
	
	//再添加
	if(pCpm_Id.length > 0)
	{
		<%
		if(null != User_User_Info)
		{
			Iterator useriter = User_User_Info.iterator();
			while(useriter.hasNext())
			{
				UserInfoBean userBean = (UserInfoBean)useriter.next();
				if(userBean.getStatus().equals("0"))
				{
					switch(userBean.getDept_Id().length())
					{
						case 2:
		%>
							if(1 == 1)
							{
								var objOption = document.createElement('OPTION');
								objOption.value = '<%=userBean.getId()%>';
								objOption.text  = '<%=userBean.getCName()%>';
								document.getElementById('Manag_OP').add(objOption);
							}
		<%
							break;
						case 10:
		%>
							if('<%=userBean.getDept_Id()%>' == pCpm_Id)
							{
								var objOption1 = document.createElement('OPTION');
								objOption1.value = '<%=userBean.getId()%>';
								objOption1.text  = '<%=userBean.getCName()%>';
								document.getElementById('Break_OP').add(objOption1);
								
								var objOption2 = document.createElement('OPTION');
								objOption2.value = '<%=userBean.getId()%>';
								objOption2.text  = '<%=userBean.getCName()%>';
								document.getElementById('Manag_OP').add(objOption2);
							}
		<%
							break;
					}
				}
			}
		}
		%>
	}
}
doChange(Sat_Break_Add.Cpm_Id.value);

var reqAdd = null;
function doAdd()
{
  if(Sat_Break_Add.Cpm_Id.value.length < 1)
  {
  	alert('请选择所属场站!');
  	return;
  }
  if(Sat_Break_Add.Break_Time.value.length < 1)
  {
  	alert('请选择违章时间!');
  	return;
  }
  if(Sat_Break_Add.Break_OP.value.length < 1 || Sat_Break_Add.Break_OP.value == '*')
  {
  	alert('请选择违章人!');
  	return;
  }
  if(Sat_Break_Add.Manag_OP.value.length < 1 || Sat_Break_Add.Manag_OP.value == '*')
  {
  	alert('请选择直接管理人!');
  	return;
  }
  if(Sat_Break_Add.Break_Point.value.Trim().length < 1 || Sat_Break_Add.Break_Point.value > 0)
  {
  	alert("绩效挂钩扣分错误,可能的原因：\n\n  1.为空。\n\n  2.不是负值。");
		return;
  }
	for(var i=0; i<Sat_Break_Add.Break_Point.value.length; i++)
	{
		if(Sat_Break_Add.Break_Point.value.charAt(Sat_Break_Add.Break_Point.value.length-1) == '-')
		{
			alert("输入绩效挂钩扣分有误，请重新输入!");
	    return;
		}
		if(Sat_Break_Add.Break_Point.value.charAt(i) == '-' && i != 0)
		{
			alert("输入绩效挂钩扣分有误，请重新输入!");
	    return;
		}
		if(Sat_Break_Add.Break_Point.value.charAt(i) != '-' && isNaN(Sat_Break_Add.Break_Point.value.charAt(i)))
	  {
	    alert("输入绩效挂钩扣分有误，请重新输入!");
	    return;
	  }
	}
	if(Sat_Break_Add.Break_Des.value.Trim().length < 1)
	{
		alert('请简要描述违章行为及违反条款情况!');
		return;
	}
	if(Sat_Break_Add.Break_Des.value.Trim().length > 128)
  {
    alert("违章行为及违反条款描述过长，请简化!");
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
						Sat_Break_Add.Break_Point.value = '';
						Sat_Break_Add.Break_Des.value   = '';
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
		var url = 'Sat_Break_Add.do?Cmd=10&Sid=<%=Sid%>&Cpm_Id='+Sat_Break_Add.Cpm_Id.value+'&Break_Time='+Sat_Break_Add.Break_Time.value+'&Break_OP='+Sat_Break_Add.Break_OP.value+'&Manag_OP='+Sat_Break_Add.Manag_OP.value+'&Break_Point='+Sat_Break_Add.Break_Point.value.Trim()+'&Break_Des='+Sat_Break_Add.Break_Des.value.Trim()+'&Operator=<%=Operator%>&CurrPage=<%=currStatus.getCurrPage()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&currtime='+new Date();
		reqAdd.open("post",url,true);
		reqAdd.send(null);
		return true;
  }
}
</SCRIPT>
</html>