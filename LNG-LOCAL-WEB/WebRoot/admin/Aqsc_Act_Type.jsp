<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type='text/css' href='../skin/css/style.css' rel='stylesheet'/>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Aqsc_Act_Type = (ArrayList)session.getAttribute("Aqsc_Act_Type_" + Sid);
	
%>
<body  style=" background:#CADFFF">
<form name="Aqsc_Act_Type" action="Aqsc_Act_Type.do" method="post" target="mFrame">
<div id="down_bg_2">
  <div id="cap"><img src="../skin/images/aqsc_act_type.gif"></div><br><br><br>
  <div id="right_table_center">
  	<table width="90%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30' valign='middle'>
				<td width='100%' align='right' colspan=2>
					<img src="../skin/images/mini_button_add.gif" style='cursor:hand;' onClick='doAdd()'>
				</td>
			</tr>
			<tr height='30' valign='middle'>
				<td width='100%' align='center' colspan=2>
					<table width="100%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			 			<tr>
							<td width="10%" class="table_deep_blue">编 号</td>
							<td width="20%" class="table_deep_blue">名 称</td>
							<td width="20%" class="table_deep_blue">子 项</td>
							<td width="10%" class="table_deep_blue">状 态</td>
							<td width="20%" class="table_deep_blue">描 述</td>
						</tr>
						<%
						if(Aqsc_Act_Type != null)
						{
							int sn = 0;
							Iterator iterator = Aqsc_Act_Type.iterator();
							while(iterator.hasNext())
							{
								AqscActTypeBean statBean = (AqscActTypeBean)iterator.next();
								if(statBean.getId().length() == 2)
								{
									String Id = statBean.getId();
									String CName = statBean.getCName();
									String Status = statBean.getStatus();
									String Des = statBean.getDes();
									
									if(null == Des)
									{
										Des = "";
									}
									
									String str_Status = "";
									switch(Integer.parseInt(Status))
									{
										case 0:
												str_Status = "启用";
											break;
										case 1:
												str_Status = "注销";
											break;
									}
									
									sn++;
						%>
									<tr height='50' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
										<%
										if(Status.equals("0"))
										{
										%>
											<td align=center><a href="#" title="点击编辑" onClick="doEdit('<%=Id%>')"><U><%=Id%></U></a></td>
											<td align=left><%=CName%></td>
											<td align=left valign='top'>
												&nbsp;<img src='../skin/images/device_cmdadd.png' style='cursor:hand' title='子项添加' onclick="doActAdd('<%=Status%>', '<%=Id%>')">
												<%
												if(Aqsc_Act_Type != null)
												{
													int cnt = 0;
													Iterator actiter = Aqsc_Act_Type.iterator();
													while(actiter.hasNext())
													{
														AqscActTypeBean actBean = (AqscActTypeBean)actiter.next();
														if(actBean.getId().length() == 4 && actBean.getId().substring(0,2).equals(Id))
														{
															cnt++;
												%>
															<br>
															&nbsp;<img src='../skin/images/agent_edit.gif' style='cursor:hand;' title='子项编辑' onclick="doActEdit('<%=Status%>', '<%=actBean.getId()%>')">															
															<%
															if(actBean.getStatus().equals("0"))
															{
															%>
																&nbsp;<%=cnt%>、<%=actBean.getCName()%>
															<%
															}
															else
															{
															%>
																&nbsp;<font color=gray><%=cnt%>、<%=actBean.getCName()%></font>
															<%
															}
														}
													}
												}
												%>
											</td>
										  <td align=center><%=str_Status%></td>
										  <td align=left><%=Des%>&nbsp;</td>
										<%
										}
										else
										{
										%>
											<td align=center><a href="#" title="点击编辑" onClick="doEdit('<%=Id%>')"><font color=gray><U><%=Id%></U></font></a></td>
											<td align=left><font color=gray><%=CName%></font></td>
											<td align=left valign='top'><font color=gray>
												&nbsp;<img src='../skin/images/device_cmdadd.png' style='cursor:hand' title='子项添加' onclick="doActAdd('<%=Status%>', '<%=Id%>')">
												<%
												if(Aqsc_Act_Type != null)
												{
													int cnt = 0;
													Iterator actiter = Aqsc_Act_Type.iterator();
													while(actiter.hasNext())
													{
														AqscActTypeBean actBean = (AqscActTypeBean)actiter.next();
														if(actBean.getId().length() == 4 && actBean.getId().substring(0,2).equals(Id))
														{
															cnt++;
												%>
															<br>
															&nbsp;<img src='../skin/images/agent_edit.gif' style='cursor:hand;' title='子项编辑' onclick="doActEdit('<%=Status%>', '<%=actBean.getId()%>')">
															<%
															if(actBean.getStatus().equals("0"))
															{
															%>
																&nbsp;<%=cnt%>、<%=actBean.getCName()%>
															<%
															}
															else
															{
															%>
																&nbsp;<font color=gray><%=cnt%>、<%=actBean.getCName()%></font>
															<%
															}
														}
													}
												}
												%>
											</font></td>
										  <td align=center><font color=gray><%=str_Status%></font></td>
										  <td align=left><font color=gray><%=Des%>&nbsp;</font></td>
										<%
										}
										%>
									</tr>
						<%
								}
							}
						}
						%>
			 		</table>
				</td>
			</tr>
		</table>
	</div>
</div>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

function doAdd()
{
	location = "Aqsc_Act_Type_Add.jsp?Sid=<%=Sid%>";
}

function doEdit(pId)
{
	location = "Aqsc_Act_Type_Edit.jsp?Sid=<%=Sid%>&Id="+pId;
}

function doActAdd(pStatus, pId)
{
	if('1' == pStatus)
	{
		alert('当前行为类型已注销,不可添加子项!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 360;
	diag.Height = 164;
	diag.Title = "子项添加";
	diag.URL = 'Aqsc_Act_Type_SubAdd.jsp?Sid=<%=Sid%>&Id='+pId;
	diag.show();
}

function doActEdit(pStatus, pId)
{
	if('1' == pStatus)
	{
		alert('当前行为类型已注销,不可编辑子项!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 360;
	diag.Height = 164;
	diag.Title = "子项编辑";
	diag.URL = 'Aqsc_Act_Type_SubEdit.jsp?Sid=<%=Sid%>&Id='+pId;
	diag.show();
}
</SCRIPT>
</html>