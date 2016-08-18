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
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
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
	
  CurrStatus currStatus        = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList Dev_List           = (ArrayList)session.getAttribute("Dev_List_" + Sid);
  ArrayList Dev_List_Breed     = (ArrayList)session.getAttribute("Dev_List_Breed_" + Sid);
  ArrayList Dev_List_Card      = (ArrayList)session.getAttribute("Dev_List_Card_" + Sid);
  ArrayList Dev_List_Card_List = (ArrayList)session.getAttribute("Dev_List_Card_List_" + Sid);
  
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
<body style="background:#CADFFF">
<form name="Dev_List"  action="Dev_List.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				����վ��:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >					
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
				�豸Ʒ��:
				<select name='Func_Corp_Id' style='width:120px;height:20px;' onchange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>ȫ��</option>
					<%
					if(null != Dev_List_Breed)
					{
						Iterator breediter = Dev_List_Breed.iterator();
						while(breediter.hasNext())
						{
							AqscDeviceBreedBean breedBean = (AqscDeviceBreedBean)breediter.next();
					%>
							<option value='<%=breedBean.getId()%>' <%=currStatus.getFunc_Corp_Id().equals(breedBean.getId())?"selected":""%>><%=breedBean.getCName()%></option>
					<%
						}
					}
					%>
				</select>
				��¼״̬:
				<select name='Func_Sel_Id' style='width:90px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sel_Id() == 9 ? "selected":""%>>ȫ��</option>
					<option value='0' <%=currStatus.getFunc_Sel_Id() == 0 ? "selected":""%>>ȱ֤</option>
					<option value='1' <%=currStatus.getFunc_Sel_Id() == 1 ? "selected":""%>>����</option>
				</select>
			</td>
			<td width='30%' align='right'>
				<img src="../skin/images/mini_button_add.gif" onClick='doAdd()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='130107' ctype='1'/>">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' >
			</td>
		</tr>
		<tr height='30'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=2 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25'>
						<td width='4%'  align='center' class="table_deep_blue">���</td>
						<td width='8%' align='center' class="table_deep_blue">��վ����</td>
						<td width='8%' align='center' class="table_deep_blue">�豸Ʒ��</td>
						<td width='8%' align='center' class="table_deep_blue">�豸����</td>
						<td width='8%' align='center' class="table_deep_blue">�豸����</td>						
						<td width='8%' align='center' class="table_deep_blue">�����ĵ�</td>										
						<td width='24%' align='center' class="table_deep_blue">�ر�֤��</td>
						<td width='8%' align='center' class="table_deep_blue">�Ƿ�ȱ֤</td>
						<td width='8%' align='center' class="table_deep_blue">�豸��ϸ</td>		
						<td width='8%' align='center' class="table_deep_blue">�豸״̬</td>				
						<td width='8%' align='center' class="table_deep_blue">ά������</td>
					</tr>
					<%
					if(Dev_List != null)
					{
						Iterator iterator = Dev_List.iterator();
						while(iterator.hasNext())
						{
							DevListBean Bean = (DevListBean)iterator.next();
							String SN            = Bean.getSN();
							String Cpm_Id      = Bean.getCpm_Id();
					  	String Cpm_Name      = Bean.getCpm_Name();
					  	String CType_Name    = Bean.getCType_Name();
					  	String CType         = Bean.getCType();
					  	String Dev_Type      = Bean.getDev_Type();
					  	String Dev_Name      = Bean.getDev_Name();
					  	String Dev_Type_Name = Bean.getDev_Type_Name();
						  String Dev_Id        = Bean.getDev_Id();
						  String Dev_Date      = Bean.getDev_Date();
						  String Dev_Canshu      = Bean.getCraft();
						  String Dev_Wendang      = Bean.getDev_Wendang();
						  String Dev_Zhuangtai      = Bean.getDev_Zhuangtai();
						  String str           = "";
							if(Dev_Wendang.length()>1){str = "�ĵ�����";}else{str ="�����ĵ�";} 						  
						  String Dev_Jishu      = Bean.getTechnology();
							
							//�ر�֤��
							String Card_List_Y = Bean.getCard_List();
							if(null == Card_List_Y)
							{
								Card_List_Y = "";
							}
							
							//�ѱ�֤��
			  			String Card_List_N = "";
			  			if(null != Dev_List_Card_List)
				    	{
				    		Iterator caditer = Dev_List_Card_List.iterator();
								while(caditer.hasNext())
								{
									DevListCardBean cadBean = (DevListCardBean)caditer.next();
									if(cadBean.getSN().equals(SN))
									{
										Card_List_N += cadBean.getCard_Type() + ",";
									}
								}
				    	}
			  			
			  			//�Ƿ�ȱ֤
							String str_Card = "";
							int isCard = 1;
				    	if(Card_List_Y.length() > 0)
				    	{
				    		String[] Card_YList = Card_List_Y.split(",");
				    		for(int i=0; i<Card_YList.length && Card_YList[i].length()>0; i++)
				    		{
				    			if(!Card_List_N.contains(Card_YList[i]))
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
							
			  			switch(currStatus.getFunc_Sel_Id())
							{
								case 9:
									{
											sn++;
											%>
											<tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%> title='[�������:<%=Dev_Id%>]&#10;[��������<%=Dev_Date%>]&#10;[���ղ���:<%=Bean.getCraft()%>]&#10;[��������:<%=Bean.getTechnology()%>]&#10;[��������:<%=Bean.getDev_ShuXing()%>]'>
									  		<td align=center><%=sn%></td>
									  		<td align=left><%=Cpm_Name%></td>
									  		<td align=left><%=CType_Name%></td>
									  		<td align=left><%=Dev_Type_Name%></td>
									  		<td align=left><%=Dev_Name%></td>									  		
									  		<td align=left onClick="doFile('<%=SN%>','<%=Dev_Wendang%>')"><font color="red"><%=str%></font></td>									  		
									    	<td align=left valign=top>
									    		<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
									    		<%
													int type_cnt = 0;
													if(null != Dev_List_Card)
													{
														Iterator typeiter = Dev_List_Card.iterator();
														while(typeiter.hasNext())
														{
															AqscDeviceCardBean typeBean = (AqscDeviceCardBean)typeiter.next();
															if(Card_List_Y.contains(typeBean.getId()))
															{
																type_cnt++;
																if(Card_List_N.contains(typeBean.getId()))
																{
													%>
																	<tr height='30px'>
																		<td width='80%' align=left>
																			&nbsp;<img src='../skin/images/02_y.png'>
																			<%=type_cnt%>��<%=typeBean.getCName()%>
																		</td>
																		<td width='20%' align=left>
																			<img src='../skin/images/sat_danger_01.png' title='֤���༭' onclick="doCardEdt('<%=SN%>', '<%=typeBean.getId()%>', '<%=Cpm_Name%>', '<%=Dev_Name%>')">
																			&nbsp;
																			<img src='../skin/images/cmddel.gif'        title='֤��ɾ��' onclick="doCardDel('<%=SN%>', '<%=typeBean.getId()%>')">
																		</td>
																	</tr>
													<%
																}
																else
																{
													%>
																	<tr height='30px'>
																		<td width='80%' align=left>
																			&nbsp;<img src='../skin/images/02_n.png'>
																			<%=type_cnt%>��<%=typeBean.getCName()%>
																		</td>
																		<td width='20%' align=left>
																			<img src='../skin/images/device_cmdadd.png'  title='֤�����' onclick="doCardAdd('<%=SN%>', '<%=typeBean.getId()%>', '<%=Cpm_Name%>', '<%=Dev_Name%>')">
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
									    	<td align=center >
									    		<img src='../skin/images/sat_danger_01.png'  title='�༭�豸' onclick="doEdit('<%=SN%>')">
									    		&nbsp;
									    		<img src='../skin/images/cmddel.gif'        title='ɾ���豸' onclick="doDel('<%=SN%>')">
									    	</td>
									    	<td align=center>&nbsp;<a href="#" onClick="doZhuangtai('<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Dev_Type%>', '<%=Dev_Type_Name%>', '<%=Dev_Name%>', '<%=Dev_Zhuangtai%>', '<%=CType%>' )" title="�޸�״̬"><%=Dev_Zhuangtai%></a></td>
									    	<td align=center onClick="doWX('<%=Dev_Type%>')"><font color="red">ά������</font></td>
											</tr>										
											<%
									}
									break;
								case 0:
								case 1:
									{
										if(isCard == currStatus.getFunc_Sel_Id())
										{
											sn++;
											%>
											<tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%> 
												title='[�������:<%=Dev_Id%>]&#10;[��������:<%=Dev_Date%>]&#10;[���ղ���:<%=Bean.getCraft()%>]&#10;[��������:<%=Bean.getTechnology()%>]&#10;[��������:<%=Bean.getDev_ShuXing()%>]'>
										  	<td align=center><%=sn%></td>
										  	<td align=left><%=Cpm_Name%></td>
										  	<td align=left><%=CType_Name%></td>
										  	<td align=left><%=Dev_Type_Name%></td>
										  	<td align=left><%=Dev_Name%></td>										  
									  		<td align=left onClick="doFile('<%=SN%>','<%=Dev_Wendang%>')"><font color="red"><%=str%></font></td>									  		
										    <td align=left valign=top>
										    	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
									    		<%
													int type_cnt = 0;
													if(null != Dev_List_Card)
													{
														Iterator typeiter = Dev_List_Card.iterator();
														while(typeiter.hasNext())
														{
															AqscDeviceCardBean typeBean = (AqscDeviceCardBean)typeiter.next();
															if(Card_List_Y.contains(typeBean.getId()))
															{
																type_cnt++;
																if(Card_List_N.contains(typeBean.getId()))
																{
													%>
																	<tr height='30px'>
																		<td width='80%' align=left>
																			&nbsp;<img src='../skin/images/02_y.png'>
																			<%=type_cnt%>��<%=typeBean.getCName()%>
																		</td>
																		<td width='20%' align=left>
																			<img src='../skin/images/sat_danger_01.png'  title='֤���༭' onclick="doCardEdt('<%=SN%>', '<%=typeBean.getId()%>', '<%=Cpm_Name%>', '<%=Dev_Name%>')">
																			&nbsp;
																			<img src='../skin/images/cmddel.gif'         title='֤��ɾ��' onclick="doCardDel('<%=SN%>', '<%=typeBean.getId()%>')">
																		</td>
																
									    						
																	</tr>
													<%
																}
																else
																{
													%>
																	<tr height='30px'>
																		<td width='80%' align=left>
																			&nbsp;<img src='../skin/images/02_n.png'>
																			<%=type_cnt%>��<%=typeBean.getCName()%>
																		</td>
																		<td width='20%' align=left>
																			<img src='../skin/images/device_cmdadd.png'  title='֤�����' onclick="doCardAdd('<%=SN%>', '<%=typeBean.getId()%>', '<%=Cpm_Name%>', '<%=Dev_Name%>')">
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
										    <td align=center >
									    		<img src='../skin/images/sat_danger_01.png'  title='�༭�豸' onclick="doEdit('<%=SN%>')">
									    		&nbsp;
									    		<img src='../skin/images/cmddel.gif'         title='ɾ���豸' onclick="doDel('<%=SN%>')">
									    	</td>		
									    	<td align=center>&nbsp;<a href="#" onClick="doZhuangtai('<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Dev_Type%>', '<%=Dev_Type_Name%>', '<%=Dev_Name%>', '<%=Dev_Zhuangtai%>', '<%=CType%>')" title="�޸�״̬"><%=Dev_Zhuangtai%></a></td>
									    	<td align=center onClick="doWX('<%=Dev_Type%>')"><font color="red">ά������</font></td>						  
											</tr>											
											<%
										}
									}
									break;
							}
						}
					}
					if(0 == sn)
					{
					%>
						<tr height=30>
							<td width='100%' align=center colspan=13>��!</td>
						</tr>
					<%
					}
					%>
					<tr><td colspan=11></td></tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd"    value="0">
<input type="hidden" name="Sid"    value="<%=Sid%>">
<input type="hidden" name="SN"     value="">
<input type="hidden" name="Cpm_Id" value="">
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Dev_List.jsp';

function doSelect()
{
	Dev_List.Cpm_Id.value = Dev_List.Func_Cpm_Id.value;
	Dev_List.submit();
}

function doAdd()
{
	
	location = "Dev_List_Add.jsp?Sid=<%=Sid%>";
}

function doEdit(pSN)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130108' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�༭���豸!');
		return;
	}
	location = "Dev_List_Edit.jsp?Sid=<%=Sid%>&SN="+pSN;
}

function doDel(pSN)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130105' ctype='1'/>' == 'none')
	{
		alert('����Ȩɾ�����豸!');
		return;
	}
	if(confirm('ȷ��ɾ��?'))
	{
		Dev_List.Cmd.value = 12;
		Dev_List.SN.value  = pSN;
		Dev_List.Cpm_Id.value = Dev_List.Func_Cpm_Id.value;
		Dev_List.submit();
	}
}

//֤�����
function doCardAdd(pSN, pCard_Type, pCpm_Name, pDev_Name)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130102' ctype='1'/>' == 'none')
	{
		alert('����Ȩ��Ӹ�֤��!');
		return;
	}
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 254;
	diag.Title = "֤�����";
	diag.URL = 'Dev_List_Card_Add.jsp?Sid=<%=Sid%>&SN='+pSN+'&Card_Type='+pCard_Type+'&Cpm_Name='+pCpm_Name+'&Dev_Name='+pDev_Name;
	diag.show();
}

//֤���༭
function doCardEdt(pSN, pCard_Type, pCpm_Name, pDev_Name)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130104' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�༭��֤��!');
		return;
	}
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 254;
	diag.Title = "֤���༭";
	diag.URL = 'Dev_List_Card_Edt.jsp?Sid=<%=Sid%>&SN='+pSN+'&Card_Type='+pCard_Type+'&Cpm_Name='+pCpm_Name+'&Dev_Name='+pDev_Name;
	diag.show();
}

//֤��ɾ��
function doCardDel(pSN, pCard_Type)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130103' ctype='1'/>' == 'none')
	{
		alert('����Ȩɾ����֤��!');
		return;
	}
	
	if(confirm("ȷ��ɾ����ǰ֤��?"))
	{
		if(window.XMLHttpRequest)
	  {
			reqAdd = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqAdd = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//���ûص�����
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
						alert('�ɹ�');
						doSelect();
						return;
					}
					else
					{
						alert('ʧ�ܣ������²���');
						return;
					}
				}
				else
				{
					alert("ʧ�ܣ������²���");
					return;
				}
			}
		};
		var url = 'Dev_List_Card.do?Cmd=12&Sid=<%=Sid%>&SN='+pSN+'&Card_Type='+pCard_Type+'&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&currtime='+new Date();
		reqAdd.open("post",url,true);
		reqAdd.send(null);
		return true;
	}
}


//�ĵ��ϴ�
function doFile(pSN,pDev_Wendang)
{	
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130106' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�ϴ��ĵ�!');
		return;
	}
	var Cpm_Id = Dev_List.Func_Cpm_Id.value;
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 400;
	diag.Height = 200;
	diag.Title = "�ĵ�����";
	diag.URL = 'Dev_List_File.jsp?Sid=<%=Sid%>&Dev_Wendang='+pDev_Wendang+"&SN="+pSN+"&Cpm_Id="+Cpm_Id;
	diag.show();
}

//ά�����ϲ�ѯ
function doWX(pDev_Type)
{		
	window.parent.frames.mFrame.location = "Fix_To_Trace.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+Dev_List.Func_Cpm_Id.value+"&Func_Sub_Id=0&Func_Corp_Id="+pDev_Type;
}

//����Excel
var req = null;
function doExport()
{
	
	if(0 == <%=sn%>)
	{
		alert('��ǰ�޼�¼!');
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
		var url = "Dev_List_Export.do?Sid=<%=Sid%>&Cpm_Id="+Dev_List.Func_Cpm_Id.value+"&Func_Corp_Id="+Dev_List.Func_Corp_Id.value;
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

function doZhuangtai(pCpm_Id, pCpm_Name, pDev_Type, pDev_Type_Name, pDev_Name, pDev_Zhuangtai, pCType)
{
	
	var Cpm_Id = Dev_List.Func_Cpm_Id.value;
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 400;
	diag.Height = 180;
	diag.Title = "�豸״̬";
	diag.URL = "Dev_List_ZT.jsp?Sid=<%=Sid%>&Cpm_Id="+pCpm_Id+"&Cpm_Name="+pCpm_Name+"&Dev_Type="+pDev_Type+"&Dev_Type_Name="+pDev_Type_Name+"&Dev_Name="+pDev_Name+"&Dev_Zhuangtai="+pDev_Zhuangtai+"&CType="+pCType;
	diag.show();		
}

</SCRIPT>
</html>