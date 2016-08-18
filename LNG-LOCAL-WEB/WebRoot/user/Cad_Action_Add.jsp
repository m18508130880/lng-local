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

	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String BDate = CommUtil.getDate();
	
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	ArrayList Cad_Action_Type = (ArrayList)session.getAttribute("Cad_Action_Type_" + Sid);
	ArrayList User_User_Info  = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
	String ManageId = UserInfo.getManage_Role();
	
	int cnt = 0;
	int dnt = 0;
%>
<body style="background:#CADFFF">
<form name="Cad_Action_Add" action="Cad_Action.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/cad_action_add.gif"></div><br><br><br>
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
							<td width='25%' align='center'>观 察 人</td>
							<td width='75%' align='left'>
								<select name="Observe_OP" style="width:120px;height:20px">
									<option value='*'>请选择...</option>
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
															<option value='<%=userBean.getSys_Id()%>'><%=userBean.getCName()%></option>
									<%
														break;
													case 10:
														String Role_List = "";
														String Devi_List = "";
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
																	Devi_List += statBean.getId() + ",";												
																}
															}
														}
														if(Devi_List.contains(userBean.getDept_Id()))
														{
									%>
															<option value='<%=userBean.getSys_Id()%>'><%=userBean.getCName()%></option>
									<%
														}
														break;
												}
											}
										}
									}
									%>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>被观察人</td>
							<td width='75%' align='left'>
								<select name="Observe_BY" style="width:120px;height:20px">
									<option value='*'>请选择...</option>
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
															<option value='<%=userBean.getSys_Id()%>'><%=userBean.getCName()%></option>
									<%
														break;
													case 10:
														String Role_List = "";
														String Devi_List = "";
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
																	Devi_List += statBean.getId() + ",";												
																}
															}
														}
														if(Devi_List.contains(userBean.getDept_Id()))
														{
									%>
															<option value='<%=userBean.getSys_Id()%>'><%=userBean.getCName()%></option>
									<%
														}
														break;
												}
											}
										}
									}
									%>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>观察时间</td>
							<td width='75%' align='left'>
								<input type='text' name='Observe_Time' style='width:118px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态</td>
							<td width='75%' align='left'>
								<select name='Status' style='width:120px;height:20px;'>
									<option value='0'>整改中</option>
									<option value='1'>已关闭</option>
								</select>
							</td>
						</tr>			
						<tr height='30'>
							<td width='25%' align='center'>观察地点</td>
							<td width='75%' align='left'>
								<input type='text' name='Observe_Addr' style='width:98%;height:18px;' value='' maxlength=64>
							</td>
						</tr>
						<tr height='30'>
							<td width='100%' align='center' colspan=2>
								<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
									<tr height=30>
										<td width=10% align=center><B>N<B></td>
										<td width=45% align=center><B>行为观察<B></td>
										<td width=45% align=center><B>描述<B></td>
									</tr>
									<%
									if(null != Cad_Action_Type)
									{
										int curr_index = 0; 
										Iterator typeiter = Cad_Action_Type.iterator();
										while(typeiter.hasNext())
										{
											AqscActTypeBean typeBean = (AqscActTypeBean)typeiter.next();
											if(typeBean.getStatus().equals("0") && typeBean.getId().length() == 2)
											{
												curr_index = 0;
												Iterator curriter = Cad_Action_Type.iterator();
												while(curriter.hasNext())
												{
													AqscActTypeBean currBean = (AqscActTypeBean)curriter.next();
													if(currBean.getStatus().equals("0") && currBean.getId().length() == 4 && currBean.getId().substring(0,2).equals(typeBean.getId()))
													{
														curr_index++;
													}
												}
									%>
												<tr height=30>
													<td width=10% align=center><B><%=typeBean.getId()%><B></td>
													<td width=45% align=center><B><%=typeBean.getCName()%><B></td>
													<td width=45% align=center>全都安全<input type='checkbox' id='checkbox<%=cnt%>' name='checkbox<%=cnt%>' value='<%=typeBean.getId()%>' onClick="doSeltAll(this.value, '<%=cnt%>')"></td>
												</tr>
									<%
												cnt++;
												dnt++;
											}
											else if(typeBean.getStatus().equals("0") && typeBean.getId().length() == 4)
											{
												if(curr_index > 0)
												{
									%>
													<tr height=30>
														<td width=10% align=center><%=typeBean.getId()%></td>
														<td width=45% align=left><input type='checkbox' id='checkbox<%=cnt%>' name='checkbox<%=cnt%>' value='<%=typeBean.getId()%>'><%=typeBean.getCName()%></td>
														<td width=45% align=left rowspan='<%=curr_index%>'><textarea id='textarea<%=dnt%>' name='textarea<%=dnt%>' rows='10' cols='30' maxlength=128></textarea></td>
													</tr>
									<%
												}
												else
												{
									%>
													<tr height=30>
														<td width=10% align=center><%=typeBean.getId()%></td>
														<td width=45% align=left><input type='checkbox' id='checkbox<%=cnt%>' name='checkbox<%=cnt%>' value='<%=typeBean.getId()%>'><%=typeBean.getCName()%></td>														
													</tr>
									<%
												}
												curr_index = 0;
												cnt++;
											}
										}
									}
									%>
								</table>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>激励措施</td>
							<td width='75%' align='left'>
								<textarea name='Act_Plan' rows='5' cols='53' maxlength=128></textarea>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>整改建议</td>
							<td width='75%' align='left'>
								<textarea name='Act_Sugg' rows='5' cols='53' maxlength=128></textarea>
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
<input type="hidden" name="Cmd"         value="10">
<input type="hidden" name="Sid"         value="<%=Sid%>">
<input type="hidden" name="Operator"    value="<%=Operator%>">
<input type="hidden" name="Observe_Act" value="">
<input type="hidden" name="Observe_Des" value="">
<input type="hidden" name="UId"         value="">
<input type="hidden" name="BTime"       value="<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>">
<input type="hidden" name="ETime"       value="<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>">
<input type="hidden" name="Func_Sub_Id" value="<%=currStatus.getFunc_Sub_Id()%>">
<input type="hidden" name="CurrPage"    value="<%=currStatus.getCurrPage()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Cad_Action_Add.jsp';

function doNO()
{
	location = "Cad_Action.jsp?Sid=<%=Sid%>";
}

function doSeltAll(pId, pIndex)
{
	for(var i=0; i<<%=cnt%>; i++)
	{
		if(document.getElementById('checkbox'+i).value.substring(0,2) == pId)
		{
			if(document.getElementById('checkbox'+pIndex).checked)
				document.getElementById('checkbox'+i).checked = true;
			else
				document.getElementById('checkbox'+i).checked = false;
		}
	}
}

function doAdd()
{
  if(Cad_Action_Add.Observe_OP.value.length < 1 || Cad_Action_Add.Observe_OP.value == '*')
  {
  	alert('请选择观察人!');
  	return;
  }
  if(Cad_Action_Add.Observe_BY.value.length < 1 || Cad_Action_Add.Observe_BY.value == '*')
  {
  	alert('请选择被观察人!');
  	return;
  }
  if(Cad_Action_Add.Observe_Time.value.length < 1)
  {
  	alert('请选择观察时间!');
  	return;
  }
  if(Cad_Action_Add.Observe_Addr.value.Trim().length < 1)
  {
  	alert('请填写观察地点!');
  	return;
  }
  
  var Observe_Act = '';
  for(var i=0; i<<%=cnt%>; i++)
	{
		if(document.getElementById('checkbox'+i).checked)
			Observe_Act += document.getElementById('checkbox'+i).value + ',';
	}
  Cad_Action_Add.Observe_Act.value = Observe_Act;
  
  var Observe_Des = '';
  for(var i=1; i<=<%=dnt%>; i++)
  {
  	if(document.getElementById('textarea'+i).value.Trim().length > 64)
  	{
  		alert('描述内容过长，请简化');
  		return;
  	}
  	Observe_Des += document.getElementById('textarea'+i).value.Trim() + ' ^';
  }
  Cad_Action_Add.Observe_Des.value = Observe_Des;
  
  if(confirm("信息无误，确认提交?"))
  {
  	Cad_Action_Add.UId.value = Cad_Action_Add.Observe_BY.value;
  	Cad_Action_Add.submit();
  }
}
</SCRIPT>
</html>