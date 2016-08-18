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
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/day.js"></script>
</head>
<%
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
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
	String cpm_name = "";
	Double 		Total_Value_All = 0.00;																									//�ܺϼ�ֵ
	ArrayList Crm_Info = (ArrayList)session.getAttribute("Crm_Info_" + Sid);
  ArrayList Pro_R_Type = (ArrayList)session.getAttribute("Pro_R_Type_" + Sid);			//����ȼ������
  ArrayList Pro_L_Crm   = (ArrayList)session.getAttribute("Pro_Crm_MX_" + Sid);						//��������
  ArrayList Pro_L_Stat_Day   = (ArrayList)session.getAttribute("Pro_Crm_Date_" + Sid);		//���������ݵ�������X�죩
  ArrayList Pro_L_Stat_Car   = (ArrayList)session.getAttribute("Pro_Crm_User_" + Sid);		//���������ݵ�������X�죩
  List<String> Pro_L_Day = new ArrayList<String>();				//����������������
	List<Double> Pro_Value_Day = new ArrayList<Double>();		//��������ÿ�����ڵ��ۼ�ֵ
  int Cnt_Car = 0;
  int sn      = 0;
  String Car_DW = "";
  String Car_More = "";
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
<form name="Pro_L_Crm"  action="Pro_L_Crm.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">			
		<tr height='25px' class='sjtop'>
			<td td width='80%' align='left'>		
				����վ��:
				<select  name='Func_Cpm_Id' style='width:150px;height:20px' onChange="doSelect()" >															
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
				<select name='Func_Corp_Id' style='width:150px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>ȫ��</option>
					<%
					
					String Oil_List = "";
					if(null != Pro_R_Type)
					{
						Iterator riter = Pro_R_Type.iterator();
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
				ʱ�����ڣ�
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>			
			</td>						
			<td width='20%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style='cursor:hand;'>
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' >
				
			</td>
		</tr>
		<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='50'>
				<td width='100%' align=center colspan=7><font size=4><B>�к����麣����Դ���޹�˾�������˱�</B></font></td>
			</tr>
			<tr height='30'>
				<td width='100%' align=center colspan=7>
					<table width="100%" border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
							<tr height='30'>
		<%
					if(null != Pro_L_Crm)
					{
						Iterator staIter = Pro_L_Crm.iterator();
						PLCrmBean 	pBean = (PLCrmBean)staIter.next();
					 	Car_More = pBean.getCpm_Name();	
					 	
						cpm_name = Car_More;
					}
		%>						
								<td width='10%' align=center>&nbsp;</td>
								<td width='65%' align=left><strong>վ������:   <%=cpm_name%><%=Car_DW%></strong></td>
								<td width='25%' align=left><strong>��������: <%=BDate%>��<%=EDate%></strong></td>
							</tr>
						</table>
					</td>
				</tr>
	 </table>		
	<table width="100%" border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='30'>
				<td width='100%' align=center colspan=9>
						<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
							 <tr height='30'>
										<td width='100px' align=center ><strong>��λ(��)</strong></td>		
										<%		
/**********************************�Ȱ����ڱ������������table��̨ͷΪ���ƺţ����� 1 2 3 4�ȣ��ϼ�**********************************/																			
											if(null != Pro_L_Stat_Day)
											{
													Iterator riter = Pro_L_Stat_Day.iterator();
													while(riter.hasNext())
													{
													sn++;
														PLCrmBean dayBean = (PLCrmBean)riter.next();
														Pro_L_Day.add(dayBean.getCTime().substring(5,10));
														Pro_Value_Day.add(0.00);
										%>
											<td width='100px' align=center  ><strong><%=dayBean.getCTime().substring(8,10)%>��</strong></td>
										<%
													}
											}
										%>
										<td width='100px' align=center><strong>�ϼ�</strong></td>
					     </tr>	
								<%		
/**************************************�������пͻ�********************************************************************************/													
									if(null != Pro_L_Stat_Car)
									{
										Iterator riter = Pro_L_Stat_Car.iterator();
										while(riter.hasNext())
										{
											PLCrmBean carBean 				= (PLCrmBean)riter.next();
											String carName 					= carBean.getCrm_Name();
											Double Total_Value_Car 	= 0.00;
											Cnt_Car ++;
											
							%>
									<tr height='30'>
										<td width='100px'><%=carName%></td>
							<%
/****************�������ڣ���ÿ��Pro_L_Stat��ȡ����Ӧ�ģ����ڣ����ƣ����뵱ǰ��****************************************************/							
											if(null != Pro_L_Day)
											{
												Iterator dayIter = Pro_L_Day.iterator();
												int i = 0;												//�����Ƿ������ݣ�����LIST��������++
												while(dayIter.hasNext())
												{
													boolean flagHaveData = false;		//�жϸó������Ƿ������ݣ����������td������ӿհ�td
													String tmpDay = (String)dayIter.next();	
													if(null != Pro_L_Crm)
													{
														Iterator valueIter = Pro_L_Crm.iterator();
														while(valueIter.hasNext())
														{
															PLCrmBean valueBean 	= (PLCrmBean)valueIter.next();
															String 		CValue 		= valueBean.getValue_I_Cnt();										//��ǰProOBean��Value
															String 		CDay 			= valueBean.getCTime().substring(5,10);		//��ǰProOBean������
															String 		CUnqStr		= valueBean.getCrm_Name();									//��ǰProOBean�ĳ��ƺ�
															if(tmpDay.equals(CDay) && carName.equals(CUnqStr))
															{
																flagHaveData = true;
																Total_Value_Car += Double.parseDouble(CValue);
																Total_Value_All += Double.parseDouble(CValue);
																Pro_Value_Day.set(i, Pro_Value_Day.get(i) + Double.parseDouble(CValue));
									%>										
										<td width='100px' align=center>
											<%=new BigDecimal(Double.parseDouble(CValue)).divide(new BigDecimal(1),0,java.math.RoundingMode.HALF_UP)%>
										</td>
									<%	
															}				
														}		
													}
													if(!flagHaveData)
													{//�����ݣ�����հ�td
									%>										
										<td width='100px' align=center>0</td>
									<%					
													}
													i++;							//�����Ƿ������ݣ�����LIST��������++
												}							
											}
							%>
										<td width='100px' align=center><strong><%=new BigDecimal(Total_Value_Car).divide(new BigDecimal(1),0,java.math.RoundingMode.HALF_UP)%></strong></td>
									</tr>
							<%
									
										}
									}
								%>					     
					     				     								
										<tr height='30'>
											<td width='100px' align=center><strong>�ϼ�:&nbsp;</strong></td>
										<%
/********************ÿ�պϼ�**************************************************************************************************/
											if(null != Pro_Value_Day)
											{
												Iterator dayIter = Pro_Value_Day.iterator();
												while(dayIter.hasNext())
												{
													Double Value_Day = (Double)dayIter.next();
											%>
												<td width='100px' align=center><strong><%=new BigDecimal(Value_Day).divide(new BigDecimal(1),0,java.math.RoundingMode.HALF_UP)%></strong></td>
											<%
												}
											}
										%>
										<td width='100px' align=center><strong><%=Total_Value_All%></strong></td>
										</tr>									
									</table>
								</td>
					</tr>					
		</table>			
	</table>
</div>
<input name="Cmd"      type="hidden" value="1">
<input name="Sid"      type="hidden" value="<%=Sid%>">
<input name="Cpm_Id"   type="hidden" value=""/>
<input name="DW_ID"   type="hidden" value=""/>
<input name="BTime"    type="hidden" value="">
<input name="ETime"    type="hidden" value="">
<input name="Func_Type_Id"    type="hidden" value="">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doSelect()
	{		
		Pro_L_Crm.DW_ID.value = Pro_L_Crm.Func_Type_Id.value;	
		Pro_L_Crm.Cpm_Id.value = Pro_L_Crm.Func_Cpm_Id.value;	
		Pro_L_Crm.BTime.value = Pro_L_Crm.BDate.value + " 00:00:00";
		Pro_L_Crm.ETime.value = Pro_L_Crm.EDate.value + " 23:59:59";
		Pro_L_Crm.submit();
	}
	
	var req = null;
function doExport()
{	
	var days = new Date(Pro_L_Crm.EDate.value.replace(/-/g, "/")).getTime() - new Date(Pro_L_Crm.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	if(dcnt < 0)
	{
		alert('��ֹ��������ڿ�ʼ����');
		return;
	}
	if((dcnt + 1) > 31)
	{
		alert('���ڿ�Խ������31��');
		return;
	}
	
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
		var url = "Pro_L_Crm_Export.do?Sid=<%=Sid%>&Car_DW=<%=Car_DW%>&Cpm_Id="+Pro_L_Crm.Func_Cpm_Id.value+"&DW_ID="+Pro_L_Crm.Func_Type_Id.value+"&Func_Corp_Id="+Pro_L_Crm.Func_Corp_Id.value+"&BTime="+Pro_L_Crm.BDate.value + ' 00:00:00'+"&ETime="+Pro_L_Crm.EDate.value + ' 23:59:59' ;
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

</SCRIPT>
</html>