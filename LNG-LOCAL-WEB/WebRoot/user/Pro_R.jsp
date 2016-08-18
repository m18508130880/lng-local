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
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/util.js'></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<!--<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
-->
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
	String Operator = UserInfo.getId();
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
	
	CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Oil_Info = "";
	if(null != Corp_Info)
	{
		Oil_Info = Corp_Info.getOil_Info();
		if(null == Oil_Info){Oil_Info = "";}
	}
	
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
  ArrayList Pro_R = (ArrayList)session.getAttribute("Pro_R_" + Sid);
  ArrayList Pro_R_All = (ArrayList)session.getAttribute("Pro_R_Type_" + Sid);
  int sn = 0;
  String Manage_List = "";
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
											Manage_List += R_Point;
										}
									}
								}
								String Dept_Id = UserInfo.getDept_Id();
								if(Dept_Id.length()>3){Manage_List = Dept_Id; }
%>
<body style=" background:#CADFFF">
<form name="Pro_R"  action="Pro_R.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
		<tr height='25px' class='sjtop'>
			<td width='80%' align='left'>
				����վ��:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >											
								<option value="<%=Manage_List%>" <%=currStatus.getFunc_Cpm_Id().equals(Manage_List)?"selected":""%>>ȫ��վ��</option>				
								<%
								if(Manage_List.length() > 0 && null != User_Device_Detail)
								{
									Iterator iterator = User_Device_Detail.iterator();
									while(iterator.hasNext())
									{
										DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
										if(Manage_List.contains(statBean.getId()))
										{
								%>
											<option value='<%=statBean.getId()%>' <%=currStatus.getFunc_Cpm_Id().equals(statBean.getId())?"selected":""%>><%=statBean.getBrief()%></option>
								<%
										}
									}
								}
								%>
				</select>
				ȼ������:
				<select name='Func_Corp_Id' style='width:100px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>ȫ��</option>
					<%
					
					String Oil_List = "";
					if(null != Pro_R_All)
					{
						Iterator riter = Pro_R_All.iterator();
						while(riter.hasNext())
						{
							ProRBean rBean = (ProRBean)riter.next();
							if(currStatus.getFunc_Cpm_Id().contains(rBean.getCpm_Id()))
							{
								Oil_List += rBean.getOil_CType() + ",";
							}
						}
					}
					
					if(Oil_Info.trim().length() > 0)
					{
					  String[] List = Oil_Info.split(";");
					  for(int i=0; i<List.length && List[i].length()>0; i++)
					  {
					  	String[] subList = List[i].split(",");
					  	if(Oil_List.contains(subList[0]))
					  	{
					%>
					  	<option value='<%=subList[0]%>' <%=currStatus.getFunc_Corp_Id().equals(subList[0])?"selected":""%>><%=subList[0]%>|<%=subList[1]%></option>
					<%
							}
					  }
					}
					%>
				</select>					
				��Ӫ״̬:			
				<select  name='Func_Sub_Id' style='width:90px;height:20px' onChange="doSelect()">					
					<option value='9' <%=currStatus.getFunc_Sub_Id() == 9 ? "selected":""%>>ȫ��</option>
					<option value='0' <%=currStatus.getFunc_Sub_Id() == 0 ? "selected":""%>>����</option>
					<option value='1' <%=currStatus.getFunc_Sub_Id() == 1 ? "selected":""%>>ͣ��</option>
				</select>		
				Ԥ��״̬:		
				<select  name='Func_Sel_Id' style='width:90px;height:20px' onChange="doSelect()">				
					<option value='9' <%=currStatus.getFunc_Sel_Id() == 9 ? "selected":""%>>ȫ��</option>
					<option value='0' <%=currStatus.getFunc_Sel_Id() == 0 ? "selected":""%>>����</option>
					<option value='1' <%=currStatus.getFunc_Sel_Id() == 1 ? "selected":""%>>ƫ��</option>
				</select>
				ʵʱ/��ʷ:
				<select name='Func_Id' style='width:90px;height:20px' onChange="doChangeSelect(this.value)">
					<option value='1' >ʵʱ����</option>
					<option value='2' >��ʷ����</option>						
				</select>	
			</td>
			<td width='30%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style='cursor:hand;'>
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='020102' ctype='1'/>">
				<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()'    style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='020103' ctype='1'/>">
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='5%'  align='center' class="table_deep_blue">���</td>
						<td width='7%' align='center' class="table_deep_blue">����</td>
						<td width='8%' align='center' class="table_deep_blue">վ��</td>
						<td width='5%'  align='center' class="table_deep_blue">���޺�</td>
						<td width='10%'  align='center' class="table_deep_blue">ȼ������</td>
						<td width='10%' align='center' class="table_deep_blue">ж���ƻ�</td>						
						<td width='10%' align='center' class="table_deep_blue">��ǰ���</td>
						<td width='10%' align='center' class="table_deep_blue">Ԥ����ֵ</td>
						<td width='5%'  align='center' class="table_deep_blue">Ԥ��״̬</td>
						<td width='5%'  align='center' class="table_deep_blue">��Ӫ״̬</td>
						<td width='5%'  align='center' class="table_deep_blue">�����޸�</td>
					</tr>
					<%
					 if(Pro_R != null)
					 {
						Iterator iterator = Pro_R.iterator();
						while(iterator.hasNext())
						{
							ProRBean Bean = (ProRBean)iterator.next();
							String Cpm_Id = Bean.getCpm_Id();						
							String SQLtime = Bean.getCTime();
							String CTime = SQLtime.substring(0,10);
							String Cpm_Name = Bean.getCpm_Name();
							String Oil_CType = Bean.getOil_CType();
							String Value = Bean.getValue();
							String Value_Ware = Bean.getValue_Ware();
							String Status = Bean.getStatus();
							String Tank_No = Bean.getTank_No();
							String Value_Plan = Bean.getValue_Plan();
							String PUnit      = Bean.getPUnit();
							String VUnit      = Bean.getVUnit();
							String WUnit      = Bean.getWUnit();
							String Operator_Name = Bean.getOperator_Name();							
							if(null == Oil_CType){Oil_CType = "1000";}
							if(null == Value){Value = "0";}
							if(null == Value_Ware){Value_Ware = "0";}
							
							String Oil_CName = "��";
							if(Oil_Info.trim().length() > 0)
							{
							  String[] List = Oil_Info.split(";");
							  for(int i=0; i<List.length && List[i].length()>0; i++)
							  {
							  	String[] subList = List[i].split(",");
							  	if(subList[0].equals(Oil_CType))
							  	{
							  		Oil_CName = subList[1];
							  		break;
							  	}
							  }
							}
							
						/**	String Unit = "";
							switch(Integer.parseInt(Oil_CType))
							{
								default:
								case 1000://����
								case 1010://90#����
								case 1011://90#��Ǧ����
								case 1012://90#�������
								case 1020://92#����
								case 1021://92#��Ǧ����
								case 1022://92#�������
								case 1030://93#����
								case 1031://93����Ǧ����
								case 1032://93#�������
								case 1040://95#����
								case 1041://95#��Ǧ����
								case 1042://95#�������
								case 1050://97#����
								case 1051://97#��Ǧ����
								case 1052://97#�������
								case 1060://120������
								case 1080://������������
								case 1090://98#����
								case 1091://98#��Ǧ����
								case 1092://98���������
								case 1100://��������
								case 1200://��������
								case 1201://75#��������
								case 1202://95#��������
								case 1203://100#��������
								case 1204://������������
								case 1300://��������
								case 2000://����
								case 2001://0#����
								case 2002://+5#����
								case 2003://+10#����
								case 2004://+15#����
								case 2005://+20#����
								case 2006://-5#����
								case 2007://-10#����
								case 2008://-15#����
								case 2009://-20#����
								case 2010://-30#����
								case 2011://-35#����
								case 2015://-50#����
								case 2100://�����
								case 2016://���������
								case 2200://�ز���
								case 2012://10#�ز���
								case 2013://20#�ز���
								case 2014://�����ز���
								case 2300://���ò���
								case 2301://-10#���ò���
								case 2900://��������
										Unit = "L";
									break;
								case 3001://CNG
								case 3002://LNG
										Unit = "kg";
									break;
							}
							**/
							String str_Value_Ware = "<font color=green>����</font>";
							if(Double.parseDouble(Value) < Double.parseDouble(Value_Ware))
							{
								str_Value_Ware = "<font color=red>ƫ��</font>";
							}
							
							switch(currStatus.getFunc_Sel_Id())
							{
								case 9:
										sn++;
					%>
										<tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
											<%
											if(Status.equals("0"))
											{
											%>
												<td align=center><%=sn%></td>
												<td align=center ><%=CTime%></td>
												<td align=center><%=Cpm_Name%></td>
												<td align=center><%=Tank_No%></td>
												<td align=center><%=Oil_CName%></td>
												<td align=center><%=Value_Plan%>&nbsp;<%=PUnit%></td>
												<td align=center><%=Value%>&nbsp;<%=VUnit%>	</td>				
												<td align=center><%=Value_Ware%>&nbsp;<%=WUnit%></td>
												<td align=center><%=str_Value_Ware%></td>
												<td align=center>
													<a href="#" onClick="doStatus('<%=Cpm_Id%>', '<%=Oil_CType%>', '<%=Tank_No%>','1')" title="��Ϊͣ��"><U>����</U></a>
												</td>
												<td align=center><a href="#" onClick="doValue_Plan('<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Oil_CType%>', '<%=Value_Ware%>', '<%=Value_Plan%>','<%=Value%>','<%=Tank_No%>','<%=Status%>', '<%=PUnit%>', '<%=VUnit%>', '<%=WUnit%>')" title="�����޸�"><font color=red><U>�����޸�</U></font></a></td>
											<%
											}
											else
											{
											%>
												<td align=center><font color=gray><%=sn%></font></td>
												<td align=senter><font color=gray><%=CTime%></font></td>
												<td align=center><font color=gray><%=Cpm_Name%></font></td>
												<td align=center><font color=gray><%=Tank_No%></font></td>
												<td align=center><font color=gray><%=Oil_CName%></font></td>
												<td align=center>	<font color=gray><%=Value_Plan%>&nbsp;<%=PUnit%></font>	</td>
												<td align=center><%=Value%>&nbsp;<%=VUnit%></td>
												<td align=center><font color=gray><%=Value_Ware%>&nbsp;<%=WUnit%></font></td>
												<td align=center><font color=gray><%=str_Value_Ware%></font></td>							
												<td align=center>
													<a href="#" onClick="doStatus('<%=Cpm_Id%>', '<%=Oil_CType%>', '<%=Tank_No%>', '0')" title="��Ϊ����"><font color=gray><U>ͣ��</U></font></a>								
												</td>
												<td align=center><font color=gray><a href="#" onClick="doValue_Plan('<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Oil_CType%>', '<%=Value_Ware%>', '<%=Value_Plan%>','<%=Value%>','<%=Tank_No%>','<%=Status%>', '<%=PUnit%>', '<%=VUnit%>', '<%=WUnit%>')" title="�����޸�"><font color=red><U>�����޸�</U></font></a></font></td>
											<%
											}
											%>
										</tr>
					<%
									break;
								case 0:
										if(Double.parseDouble(Value) >= Double.parseDouble(Value_Ware))
										{
											sn++;
					%>
											<tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
												<%
												if(Status.equals("0"))
												{
												%>
													<td align=center><%=sn%></td>
													<td align=center><%=CTime%></td>
													<td align=center><%=Cpm_Name%></td>
													<td align=center><%=Tank_No%></td>
													<td align=center><%=Oil_CName%></td>
													<td align=center><%=Value_Plan%>&nbsp;<%=PUnit%></td>
													<td align=center><%=Value%>&nbsp;<%=VUnit%></td>							
													<td align=center><%=Value_Ware%>&nbsp;<%=WUnit%></td>
													<td align=center><%=str_Value_Ware%></td>
													<td align=center>
														<a href="#" onClick="doStatus('<%=Cpm_Id%>', '<%=Oil_CType%>', '<%=Tank_No%>', '1')" title="��Ϊͣ��"><U>����</U></a>
													</td>
													<td align=center><a href="#" onClick="doValue_Plan('<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Oil_CType%>', '<%=Value_Ware%>', '<%=Value_Plan%>','<%=Value%>','<%=Tank_No%>','<%=Status%>', '<%=PUnit%>', '<%=VUnit%>', '<%=WUnit%>')" title="�����޸�"><font color=red><U>�����޸�</U></font></a></td>
												<%
												}
												else
												{
												%>
													<td align=center><font color=gray><%=sn%></font></td>
													<td align=senter><font color=gray><%=CTime%></font></td>
													<td align=center><font color=gray><%=Cpm_Name%></font></td>
													<td align=center><font color=gray><%=Tank_No%></font></td>
													<td align=center><font color=gray><%=Oil_CName%></font></td>
													<td align=center><font color=gray><%=Value_Plan%>&nbsp;<%=PUnit%></font>
													<td align=center><%=Value%>&nbsp;<%=VUnit%></td>
													<td align=center><font color=gray><%=Value_Ware%>&nbsp;<%=WUnit%></font></td>
													<td align=center><font color=gray><%=str_Value_Ware%></font></td>							
													<td align=center>
														<a href="#" onClick="doStatus('<%=Cpm_Id%>', '<%=Oil_CType%>', '<%=Tank_No%>', '0')" title="��Ϊ����"><font color=gray><U>ͣ��</U></font></a>								
													</td>
													<td align=center><font color=gray><a href="#" onClick="doValue_Plan('<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Oil_CType%>', '<%=Value_Ware%>', '<%=Value_Plan%>','<%=Value%>','<%=Tank_No%>','<%=Status%>', '<%=PUnit%>', '<%=VUnit%>', '<%=WUnit%>')" title="�����޸�"><font color=red><U>�����޸�</U></font></a></font></td>
												<%
												}
												%>
											</tr>
					<%
										}
									break;
								case 1:
										if(Double.parseDouble(Value) < Double.parseDouble(Value_Ware))
										{
											sn++;
					%>
											<tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
												<%
												if(Status.equals("0"))
												{
												%>
													<td align=center><%=sn%></td>
													<td align=center><%=CTime%></td>
													<td align=center><%=Cpm_Name%></td>
													<td align=center><%=Tank_No%></td>
													<td align=center><%=Oil_CName%></td>
													<td align=center><%=Value_Plan%>&nbsp;<%=PUnit%></td>
													<td align=center><%=Value%>&nbsp;<%=VUnit%></td>							
													<td align=center><%=Value_Ware%>&nbsp;<%=WUnit%></td>
													<td align=center><%=str_Value_Ware%></td>
													<td align=center>
														<a href="#" onClick="doStatus('<%=Cpm_Id%>', '<%=Oil_CType%>', '<%=Tank_No%>', '1')" title="��Ϊͣ��"><U>����</U></a>
													</td>
													<td align=center><a href="#" onClick="doValue_Plan('<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Oil_CType%>', '<%=Value_Ware%>', '<%=Value_Plan%>','<%=Value%>','<%=Tank_No%>','<%=Status%>', '<%=PUnit%>', '<%=VUnit%>', '<%=WUnit%>')" title="�����޸�"><font color=red><U>�����޸�</U></font></a></td>
												<%
												}
												else
												{
												%>
													<td align=center><font color=gray><%=sn%></font></td>
													<td align=senter><font color=gray><%=CTime%></font></td>
													<td align=center><font color=gray><%=Cpm_Name%></font></td>
													<td align=center><font color=gray><%=Tank_No%></font></td>
													<td align=center><font color=gray><%=Oil_CName%></font></td>
													<td align=center><font color=gray><%=Value_Plan%>&nbsp;<%=PUnit%></font>
													<td align=center><%=Value%>&nbsp;<%=VUnit%>	</td>
													<td align=center><font color=gray><%=Value_Ware%>&nbsp;<%=WUnit%></font></td>
													<td align=center><font color=gray><%=str_Value_Ware%></font></td>							
													<td align=center>
														<a href="#" onClick="doStatus('<%=Cpm_Id%>', '<%=Oil_CType%>', '<%=Tank_No%>', '0')" title="��Ϊ����"><font color=gray><U>ͣ��</U></font></a>								
													</td>
													<td align=center><font color=gray><a href="#" onClick="doValue_Plan('<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Oil_CType%>', '<%=Value_Ware%>', '<%=Value_Plan%>','<%=Value%>','<%=Tank_No%>','<%=Status%>', '<%=PUnit%>', '<%=VUnit%>', '<%=WUnit%>')" title="�����޸�"><font color=red><U>�����޸�</U></font></a></font></td>
												<%
												}
												%>
											</tr>
					<%
										}
									break;
							}
						}
					}
					%> 
				</table>
			</td>
		</tr>
	</table>
</div>
<input name="Cmd"       type="hidden"   value="0">
<input name="Sid"       type="hidden"   value="<%=Sid%>">
<input name="Oil_CType" type="hidden"   value=""/>
<input name="Cpm_Id"    type="hidden"   value=""/>
<input name="Status"    type="hidden"   value=""/>
<input name="Tank_No"    type="hidden"   value=""/>
<input name="Operator"  type="hidden"   value="<%=Operator%>"/>
<input type="button"    id="CurrButton" onClick="doSelect()" style="display:none">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

//ipad��������
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
{
	document.getElementById('img2').style.display = 'none';
}

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Pro_R.jsp';

function doSelect()
{
	Pro_R.Cpm_Id.value = Pro_R.Func_Cpm_Id.value;
	Pro_R.submit();
}

function doStatus(pCpm_Id, pOil_CType, pTank_No, pStatus)
{	
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='020104' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�ޱ����ǰҵ����Ӫ״̬!');
		return;
	}
	var curr_Firm = '';
	switch(parseInt(pStatus))
	{
		case 0:
				curr_Firm = 'ȷ������ǰȼ����Ϊ[����]?';
			break;
		case 1:
				curr_Firm = 'ȷ������ǰȼ����Ϊ[ͣ��]?';
			break;
	}
	if(confirm(curr_Firm))
	{
		Pro_R.Cmd.value = 11;
		Pro_R.Cpm_Id.value = pCpm_Id;
		Pro_R.Oil_CType.value = pOil_CType;
		Pro_R.Status.value = pStatus;
		Pro_R.Tank_No.value = pTank_No;
		Pro_R.submit();
	}
}

function doValue(pCpm_Id, pCpm_Name, pOil_CType, pValue_Ware, pValue, pWUnit, pVUnit)
{
	/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='020104' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�޾�ƫ��ǰ��漰����Ԥ����ֵ!');
		return;
	}
	**/
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 360;
	diag.Height = 172;
	diag.Title = "����ƫ����ֵ���";
	diag.URL = 'Pro_R_Value.jsp?Sid=<%=Sid%>&Operator=<%=Operator%>&Cpm_Id='+pCpm_Id+'&Cpm_Name='+pCpm_Name+'&Oil_CType='+pOil_CType+'&Value_Ware='+pValue_Ware+'&Value='+pValue+'&WUnit='+pWUnit+'&VUnit='+pVUnit;
	diag.show();
}

var req = null;
function doExport()
{
	if(0 == <%=sn%>)
	{
		alert('��ǰ�޼�¼!');
		return;
	}
	if(65000 <= <%=currStatus.getTotalRecord()%>)
	{
		alert('��¼���࣬���������!');
		return;
	}
	if(confirm("ȷ������?"))
  {
		if(window.XMLHttpRequest)
	  {
			req = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			req = new ActiveXObject("Microsoft.XMLHTTP");
		}
		//���ûص�����
		req.onreadystatechange = callbackForName;
		var url = "Pro_R_Export.do?Sid=<%=Sid%>&Cpm_Id="+Pro_R.Func_Cpm_Id.value+"&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>";
		req.open("post",url,true);
		req.send(null);
		return true;
	}
}

function callbackForName()
{
	var state = req.readyState;
	if(state==4)
	{
		var resp = req.responseText;			
		var str = "";
		if(resp != null)
		{
			location.href = "../files/excel/" + resp + ".xls";
		}
	}
}

function doAdd()
{
	location = "Pro_R_Add.jsp?Sid=<%=Sid%>";
}
function doValue_Plan(pCpm_Id, pCpm_Name, pOil_CType, pValue_Ware, pValue_Plan,pValue,pTank_No,pStatus, pPUnit, pVUnit, pWUnit)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='020104' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�ύ����!');
		return;
	}
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 360;
	Pdiag.Height = 200;
	Pdiag.Title = "ÿ���ύ";

	Pdiag.URL = 'Pro_R_Value_Plan.jsp?Sid=<%=Sid%>&Operator=<%=Operator%>&Cpm_Id='+pCpm_Id+'&Cpm_Name='+pCpm_Name+'&Oil_CType='+pOil_CType+'&Value_Ware='+pValue_Ware+'&Value_Plan='+pValue_Plan+'&Value='+pValue+'&Tank_No='+pTank_No+'&Status='+pStatus+'&PUnit='+pPUnit+'&VUnit='+pVUnit+'&WUnit='+pWUnit;
	Pdiag.show();
}
function doChangeSelect(pFunc_Id)
{
	switch(parseInt(pFunc_Id))
	{
		case 1://ʵʱ����				
				window.parent.frames.mFrame.location = "Pro_R.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+Pro_R.Func_Cpm_Id.value+"&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9";
		break;	
		case 2://��ʷ����
				window.parent.frames.mFrame.location = "Pro_R.do?Cmd=3&Sid=<%=Sid%>&Cpm_Id="+Pro_R.Func_Cpm_Id.value+"&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9";
		break;
	}	
}

</SCRIPT>
</html>