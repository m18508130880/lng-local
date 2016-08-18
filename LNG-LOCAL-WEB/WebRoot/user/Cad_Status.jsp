<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type='text/css' href='../skin/css/style.css' rel='stylesheet'/>
<!--<script type='text/javascript'  src="../skin/js/zDrag_L2.js"   charset='gb2312'></script>
<script type='text/javascript'  src="../skin/js/zDialog_L2.js" charset='gb2312'></script>-->
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>

</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String UId = CommUtil.StrToGB2312(request.getParameter("UId"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	String FpId   = UserInfo.getFp_Role();
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
		
	CorpInfoBean Corp_Info   = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Dept = "";
  if(Corp_Info != null)
	{
		Dept = Corp_Info.getDept();
    if(Dept == null)
    {
    	Dept = "";
    }
 	}
 	
  CurrStatus currStatus     = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList User_User_Info  = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
  ArrayList User_Device_Detail  = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  ArrayList Cad_Status_Position = (ArrayList)session.getAttribute("Cad_Status_Position_" + Sid);
	ArrayList Cad_Status_Type     = (ArrayList)session.getAttribute("Cad_Status_Type_" + Sid);
  ArrayList Cad_Status          = (ArrayList)session.getAttribute("Cad_Status_" + Sid);
  ArrayList Cad_Status_UserInfo          = (ArrayList)session.getAttribute("Cad_Status_UserInfo_" + Sid);
 	String Card_Images = "";
  int sn = 0;
  
%>
<body style=" background:#CADFFF">
<form name="Cad_Status"  action="Cad_Status.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='100%' align='left'>
				&nbsp;���ţ�
				<select  name='Func_Type_Id' style='width:100px;height:20px' onChange="doSelect()" >		
					<option value='999' <%=currStatus.getFunc_Type_Id().equals("999")?"selected":""%>>���в���</option>	
			<%	
					if(null != Corp_Info)
					{
						String Dept1 = Corp_Info.getDept();
						if(Dept1.trim().length() > 0)
						{
							String[] DeptLists = Dept1.split(",");
							for(int i=0; i<DeptLists.length; i++)
							{								
									 String Dept_Name1 = DeptLists[i];	
									 int uc  = 1+i;
									 String  num  = "0"+uc;									 									 	
				%>
					<option value='<%=num%>' <%=currStatus.getFunc_Type_Id().equals(num)?"selected":""%>><%=Dept_Name1%></option>	
				<%					 			
							}
						}
					}
					if(null != User_Device_Detail)
					{
						Iterator deviter1 = User_Device_Detail.iterator();
						while(deviter1.hasNext())
						{
							DeviceDetailBean devBean1 = (DeviceDetailBean)deviter1.next();							
								String Dept_Name2 = devBean1.getBrief();
								String Id         = devBean1.getId();
			%>
					<option value='<%=Id%>' <%=currStatus.getFunc_Type_Id().equals(Id)?"selected":""%>><%=Dept_Name2%></option>	
			<%	
						}
					}
			%>	
				</select>
				��Ա����:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >		
					<%				
								String Manage_List = "";
								if( null != User_User_Info )
								{
									Iterator iterator = User_User_Info.iterator();
									while(iterator.hasNext())
									{
										UserInfoBean usertBean = (UserInfoBean)iterator.next();		
										String sys = 	usertBean.getSys_Id();							
										Manage_List  = Manage_List+sys;
									}
								}
				%>					
								<option value='<%=Manage_List%>' <%=currStatus.getFunc_Cpm_Id().equals(Manage_List)?"selected":""%>>ȫ����Ա</option>															
				<%						
								if( null != User_User_Info )
								{
									Iterator iterator = User_User_Info.iterator();
									while(iterator.hasNext())
									{
										UserInfoBean usertBean = (UserInfoBean)iterator.next();										
				%>
								<option value='<%=usertBean.getSys_Id()%>'<%=currStatus.getFunc_Cpm_Id().equals(usertBean.getSys_Id())?"selected":""%> ><%=usertBean.getCName()%></option>
				<%
									}
								}
				%>
				</select>				
				��¼״̬:
				<select name='Func_Sub_Id' style='width:90px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sub_Id() == 9 ? "selected":""%>>ȫ��</option>
					<option value='0' <%=currStatus.getFunc_Sub_Id() == 0 ? "selected":""%>>ȱ֤</option>
					<option value='1' <%=currStatus.getFunc_Sub_Id() == 1 ? "selected":""%>>����</option>
				</select>
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center'>
				<table width="100%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'><td colspan="6">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;֤&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;״</td></tr>
					<tr height='25' valign='middle'>
						<td width='5%'  align='center' class="table_deep_blue">���</td>
						<td width='10%' align='center' class="table_deep_blue">����</td>
						<td width='15%' align='center' class="table_deep_blue">����</td>
						<td width='15%' align='center' class="table_deep_blue">��λ</td>
						<td width='45%' align='center' class="table_deep_blue">�ر�֤��</td>
						<td width='10%' align='center' class="table_deep_blue">�Ƿ�ȱ֤</td>
					</tr>
					<%
					if(Cad_Status_UserInfo != null)
					{
						Iterator iterator = Cad_Status_UserInfo.iterator();
						while(iterator.hasNext())
						{
							UserInfoBean Bean = (UserInfoBean)iterator.next();
							if(null != UId && UId.contains(Bean.getSys_Id()))
						  {
						  	String Sys_Id = Bean.getSys_Id();
						  	String CName = Bean.getCName();
						  	String Dept_Id = Bean.getDept_Id();
						  	String Job_Position = Bean.getJob_Position();
						  		
						  	String Dept_Name = "��";
							  if(null != Dept_Id)
							 	{
							 		switch(Dept_Id.length())
							 		{
							 			case 2:
							 					if(Dept.trim().length() > 0)
										 		{
											 		String[] DeptList = Dept.split(",");
													for(int i=0; i<DeptList.length; i++)
													{
											    	if(Dept_Id.equals(CommUtil.IntToStringLeftFillZero(i+1, 2)))
											    	{
													  	Dept_Name = DeptList[i];
													  }
													}
												}
							 				break;
							 			case 10:
							 					if(null != User_Device_Detail)
							 					{
							 						Iterator deviter = User_Device_Detail.iterator();
													while(deviter.hasNext())
													{
														DeviceDetailBean devBean = (DeviceDetailBean)deviter.next();
														if(Dept_Id.equals(devBean.getId()))
														{
															Dept_Name = devBean.getBrief();
														}
													}
							 					}
							 				break;
							 		}
							 	}
						  	
						  	//�ر�֤��
						  	String PositionName = "��";
						  	String PosCard_Y = "";
								if(null != Job_Position && Cad_Status_Position != null)
								{
									for(int i=0; i<Cad_Status_Position.size(); i++)
									{
										UserPositionBean Position = (UserPositionBean)Cad_Status_Position.get(i);
										if(Position.getId().equals(Job_Position))
										{
											PositionName = Position.getCName();
											PosCard_Y = Position.getCard_List();
											if(null == PosCard_Y)
											{
												PosCard_Y = "";
											}
											break;
										}
									}
								}
								
								//�ѱ�֤��
								String PosCard_N = "";
								if(null != Cad_Status)
					    	{
					    		Iterator caditer = Cad_Status.iterator();
									while(caditer.hasNext())
									{
										CadStatusBean cadBean = (CadStatusBean)caditer.next();
										if(cadBean.getSys_Id().equals(Sys_Id))
										{
											Card_Images = cadBean.getCard_Images();
											PosCard_N += cadBean.getCard_Type() + ",";
										}
									}
					    	}
					    	
								//�Ƿ�ȱ֤
								String str_Card = "";
								int isCard = 1;
								if(null != PosCard_Y && PosCard_Y.length() > 0)
								{
									String[] Card_YList = PosCard_Y.split(",");
									for(int i=0; i<Card_YList.length && Card_YList[i].length()>0; i++)
									{
										if(!PosCard_N.contains(Card_YList[i]))
										{
											isCard = 0;
											break;
										}
									}
								}
								
								switch(isCard)
								{
									case 0:
										str_Card = "<font color=red>��</font>";
										break;
									case 1:
										str_Card = "<font color=green>��</font>";										
										break;
								}
								
								switch(currStatus.getFunc_Sub_Id())
								{
									case 9:
										{
												sn++;
											%>
												<tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
										  		<td align=center><%=sn%></td>
										  		<td align=left><%=CName%></td>
										  		<td align=left><%=Dept_Name%></td>
										    	<td align=left><%=PositionName%></td>
										    	<td align=left valign=top>
										    		<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
										    		<%
														int type_cnt = 0;
														if(null != PosCard_Y && null != Cad_Status_Type)
														{
															Iterator typeiter = Cad_Status_Type.iterator();
															while(typeiter.hasNext())
															{
																AqscCardTypeBean typeBean = (AqscCardTypeBean)typeiter.next();
																if(PosCard_Y.contains(typeBean.getId()))
																{
																	type_cnt++;
																	if(PosCard_N.contains(typeBean.getId()))
																	{
																	
														%>
																		<tr height='30px'>
																			<td width='70%' align=left>
																				&nbsp;<img src='../skin/images/02_y.png'>
																				<%=type_cnt%>��<%=typeBean.getCName()%>
																			</td>
																			<td width='30%' align=left>
																				<img src='../skin/images/sat_danger_01.png'  title='֤���༭' onclick="doCardEdt('<%=Sys_Id%>', '<%=typeBean.getId()%>', '<%=CName%>', '<%=Dept_Id%>', '<%=Dept_Name%>', '<%=PositionName%>')">
																				&nbsp;
																				<img src='../skin/images/shangchuan.jpg' title='ͼƬ�ϴ�' onclick="doFile('<%=Sys_Id%>', '<%=typeBean.getId()%>', '<%=CName%>', '<%=typeBean.getCName()%>', '<%=Card_Images%>' )" >
																				&nbsp;
																				<img src='../skin/images/cmddel.gif'         title='֤��ɾ��' onclick="doCardDel('<%=Sys_Id%>', '<%=typeBean.getId()%>', '<%=Dept_Id%>')">
																			</td>
																		</tr>
														<%
																	}
																	else
																	{
														%>
																		<tr height='30px'>
																			<td width='70%' align=left>
																				&nbsp;<img src='../skin/images/02_n.png'>
																				<%=type_cnt%>��<%=typeBean.getCName()%>
																			</td>
																			<td width='30%' align=left>
																				<img src='../skin/images/device_cmdadd.png'  title='֤�����' onclick="doCardAdd('<%=Sys_Id%>', '<%=typeBean.getId()%>', '<%=CName%>', '<%=Dept_Id%>', '<%=Dept_Name%>', '<%=PositionName%>')">																				
																			</td>
																		</tr>
														<%
																	}
																}
															}
														}
														if(0 == type_cnt)
														{
														%>
															<tr height='30px'>
																<td width='100%' align=left colspan=2>
																	&nbsp;�������֤��!
																</td>
															</tr>
														<%
														}
														%>
														</table>
										    	</td>
										   		<td align=center><%=str_Card%></td>
												</tr> 	
											<%
										}
										break;
									case 0:
									case 1:
										{
											if(isCard == currStatus.getFunc_Sub_Id())
											{
												sn++;
												%>
												<tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
											  	<td align=center><%=sn%></td>
											  	<td align=left><%=CName%></td>
											  	<td align=left><%=Dept_Name%></td>
											    <td align=left><%=PositionName%></td>
											    <td align=left valign=top>
											    	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
										    		<%
														int type_cnt = 0;
														if(null != PosCard_Y && null != Cad_Status_Type)
														{
															Iterator typeiter = Cad_Status_Type.iterator();
															while(typeiter.hasNext())
															{
																AqscCardTypeBean typeBean = (AqscCardTypeBean)typeiter.next();
																if(PosCard_Y.contains(typeBean.getId()))
																{
																	type_cnt++;
																	if(PosCard_N.contains(typeBean.getId()))
																	{
														%>
																		<tr height='30px'>
																			<td width='70%' align=left>
																				&nbsp;<img src='../skin/images/02_y.png'>
																				<%=type_cnt%>��<%=typeBean.getCName()%>
																			</td>
																			<td width='30%' align=left>
																				<img src='../skin/images/sat_danger_01.png'  title='֤���༭' onclick="doCardEdt('<%=Sys_Id%>', '<%=typeBean.getId()%>', '<%=CName%>', '<%=Dept_Id%>', '<%=Dept_Name%>', '<%=PositionName%>')">
																				&nbsp;
																				<img src='../skin/images/shangchuan.jpg' title='ͼƬ�ϴ�' onclick="doFile('<%=Sys_Id%>', '<%=typeBean.getId()%>', '<%=CName%>', '<%=typeBean.getCName()%>', '<%=Card_Images%>' )" >
																				&nbsp;
																				<img src='../skin/images/cmddel.gif'         title='֤��ɾ��' onclick="doCardDel('<%=Sys_Id%>', '<%=typeBean.getId()%>', '<%=Dept_Id%>')">
																			</td>
																		</tr>
														<%
																	}
																	else
																	{
														%>
																		<tr height='30px'>
																			<td width='70%' align=left>
																				&nbsp;<img src='../skin/images/02_n.png'>
																				<%=type_cnt%>��<%=typeBean.getCName()%>
																			</td>
																			<td width='30%' align=left>
																				<img src='../skin/images/device_cmdadd.png'  title='֤�����' onclick="doCardAdd('<%=Sys_Id%>', '<%=typeBean.getId()%>', '<%=CName%>', '<%=Dept_Id%>', '<%=Dept_Name%>', '<%=PositionName%>')">
																			</td>
																		</tr>
														<%
																	}
																}
															}
														}
														if(0 == type_cnt)
														{
														%>
															<tr height='30px'>
																<td width='100%' align=left colspan=2>
																	&nbsp;�������֤��!
																</td>
															</tr>
														<%
														}
														%>
														</table>
										    	</td>
											   	<td align=center><%=str_Card%></td>
												</tr>
												<%
											}
										}
										break;
								}
							}
						}
					}
					if(0 == sn)
					{
					%>
						<tr height=30>
							<td width='100%' align=center colspan=6>��!</td>
						</tr>
					<%
					}
					%>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd" value="0">
<input type="hidden" name="Sid" value="<%=Sid%>">
<input type="hidden" name="UId" value="">
<input type="button" id="CurrButton" onClick="doSelect()" style="display:none">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

function doSelect()
{
	Cad_Status.UId.value = Cad_Status.Func_Cpm_Id.value;
	Cad_Status.submit();
}

//֤�����
function doCardAdd(pSys_Id, pCard_Type, pCName, pDept_Id, pDept_Name,  pPositionName)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='100102' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�����֤��!');
		return;
	}
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 212;
	diag.Title = "֤�����";
	diag.URL = 'Cad_Status_Add.jsp?Sid=<%=Sid%>&Sys_Id='+pSys_Id+'&Card_Type='+pCard_Type+'&CName='+pCName+'&Dept_Name='+pDept_Name+'&PositionName='+pPositionName+'&UId='+Cad_Status.Func_Cpm_Id.value+'&Dept_Id='+pDept_Id;
	diag.show();
}

//֤���༭
function doCardEdt(pSys_Id, pCard_Type, pCName, pDept_Id, pDept_Name, pPositionName)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='100104' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�༭֤��!');
		return;
	}
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 212;
	diag.Title = "֤���༭";
	diag.URL = 'Cad_Status_Edt.jsp?Sid=<%=Sid%>&Sys_Id='+pSys_Id+'&Card_Type='+pCard_Type+'&CName='+pCName+'&Dept_Name='+pDept_Name+'&PositionName='+pPositionName+'&UId='+Cad_Status.Func_Cpm_Id.value+'&Dept_Id='+pDept_Id;
	diag.show();
}

//֤��ɾ��
function doCardDel(pSys_Id, pCard_Type, pDept_Id)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='100103' ctype='1'/>' == 'none')
	{
		alert('����Ȩɾ����֤��!');
		return;
	}
	if(confirm("ȷ��ɾ����ǰ֤��?"))
	{
		location = "Cad_Status.do?Cmd=12&Sid=<%=Sid%>&UId="+Cad_Status.Func_Cpm_Id.value+"&Sys_Id="+pSys_Id+"&Card_Type="+pCard_Type+"&Func_Type_Id="+pDept_Id+"&Func_Cpm_Id="+pSys_Id+"&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
	}
}
//֤��ͼƬ�ϴ�
function doFile(pSys_Id, pTid, pRCName, pZCName, pCard_Images)
{	
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='100105' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�ϴ�֤��ͼƬ!');
		return;
	}
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 600;
	Pdiag.Height = 300;
	Pdiag.Title = "ͼƬ�ϴ�";
	Pdiag.URL = 'Card_Images.jsp?Sid=<%=Sid%>&Sys_Id='+pSys_Id+'&Tid='+pTid+'&RCName='+pRCName+'&ZCName='+pZCName+'&Card_Images='+pCard_Images;
	Pdiag.show();	
	
	
}


</SCRIPT>
</html>