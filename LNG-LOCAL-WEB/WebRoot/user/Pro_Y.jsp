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
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/day.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
	String Operator_Name = UserInfo.getCName();
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
	
	ArrayList Pro_R_Type = (ArrayList)session.getAttribute("Pro_R_Type_" + Sid);
	CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Oil_Info = "";
	String Oil_Name = "";
	if(null != Corp_Info)
	{
		Oil_Info = Corp_Info.getOil_Info();
		if(null == Oil_Info){Oil_Info = "";}
		if(null != currStatus.getFunc_Corp_Id() && Oil_Info.length() > 0)
		{
			String[] List = Oil_Info.split(";");
		  for(int i=0; i<List.length && List[i].length()>0; i++)
		  {
		  	String[] subList = List[i].split(",");
		  	if(currStatus.getFunc_Corp_Id().equals(subList[0]))
		  	{
		  		Oil_Name = subList[1];
		  		break;
		  	}
  		}
		}
	}
	
	int Year = Integer.parseInt(CommUtil.getDate().substring(0,4));
  int Month = Integer.parseInt(CommUtil.getLastMonth(CommUtil.getDate().substring(0,7)).substring(5,7));
  if(null != (String)session.getAttribute("Year_" + Sid) && ((String)session.getAttribute("Year_" + Sid)).trim().length() > 0){Year = CommUtil.StrToInt((String)session.getAttribute("Year_" + Sid));}
  if(null != (String)session.getAttribute("Month_" + Sid) && ((String)session.getAttribute("Month_" + Sid)).trim().length() > 0){Month = CommUtil.StrToInt((String)session.getAttribute("Month_" + Sid));}
  
  ArrayList Pro_Y_N = (ArrayList)session.getAttribute("Pro_Y_N_" + Sid);
  ArrayList Pro_L = (ArrayList)session.getAttribute("Pro_L_" + Sid);
  String T_Cpm_Id       = "";
  String T_Cpm_Name     = "";
	String CTime          = "";
	String DTime          = "";
	String Value_O        = "0";
	String Value_O_Gas    = "0";
	String Value_I        = "0";
	String Value_I_Gas    = "0";
	String Value_R        = "0";
	String Value_R_Gas    = "0";
	String Value_PAL      = "0";
	String Value_PAL_Gas    = "0";
	
	//�����ۼ�
  double Value_O_All     = 0.0;
	double Value_O_Gas_All = 0.0;
	double Value_I_All     = 0.0;
	double Value_I_Gas_All = 0.0;
	double Value_R_All = 0.0;
	double Value_R_Gas_All = 0.0;
	double Value_PAL_All = 0.0;
	double Value_PAL_Gas_All = 0.0;
	
	//�����ۼ�
	String Value_O_Y     = "0";
	String Value_O_Gas_Y = "0";
	String Value_I_Y     = "0";
	String Value_I_Gas_Y = "0";
	String Value_R_Y     = "0";
	String Value_R_Gas_Y = "0";
	String Value_PAL_Y     = "0";
	String Value_PAL_Gas_Y = "0";
	
	//ͳ������
	int cnt              = 0;
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
<form name="Pro_Y"  action="Pro_Y.do" method="post" target="mFrame">
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
				<select name='Func_Corp_Id' style='width:150px;height:20px;' onChange="doSelect()">				
				<%
				if(null != Pro_R_Type)
				{
					Iterator typeiter = Pro_R_Type.iterator();
					while(typeiter.hasNext())
					{
						ProRBean typeBean = (ProRBean)typeiter.next();
						String type_Id = typeBean.getOil_CType();
						String type_Name = "��";
												
						if(Oil_Info.trim().length() > 0)
						{
						  String[] List = Oil_Info.split(";");
						  for(int i=0; i<List.length && List[i].length()>0; i++)
						  {
						  	String[] subList = List[i].split(",");
						  	if(type_Id.equals(subList[0]))
						  	{
						  		type_Name = subList[1];
						  		break;
						  	}
				  		}
				  	}
				%>
				  	<option value='<%=type_Id%>' <%=currStatus.getFunc_Corp_Id().equals(type_Id)?"selected":""%>><%=type_Id%>|<%=type_Name%></option>
				<%				  	
					}
				}
				%>
				</select>
				<select name="Func_Sub_Id"  style="width:90px;height:20px" onChange="doChangeSelect(this.value)">
					<option value="4" <%=(currStatus.getFunc_Sub_Id() == 4 ?"SELECTED":"")%>>�걨��</option>
	        <option value="1" <%=(currStatus.getFunc_Sub_Id() == 1 ?"SELECTED":"")%>>�±���</option>
	        <option value="2" <%=(currStatus.getFunc_Sub_Id() == 2 ?"SELECTED":"")%>>�ܱ���</option>
	        <option value="3" <%=(currStatus.getFunc_Sub_Id() == 3 ?"SELECTED":"")%>>�ձ���</option>
	      </select>
	      <select name="Year" style="width:70px;height:20px" onChange="doSelect()">
        <%
        for(int j=2012; j<=2030; j++)
        {
        %>
          <option value="<%=j%>" <%=(Year == j?"selected":"")%>><%=j%>��</option>
        <%
        }
        %>
        </select>        
			</td>
			<td width='30%' align='right'>		
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style='cursor:hand;'>
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' >
				
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">	
				
							<tr height='50'>
								<td width='100%' align=center colspan=9><font size=4><B>����վ������Ӫ�걨��[<%=Oil_Name%>]</B></font></td>
							</tr>
							<tr height='30'>
								<td width='100%' align=center colspan=9>
									<table width="100%" border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
										<tr height='30'>
											<td width='10%' align=center>&nbsp;</td>
				<%
									if(null != Pro_Y_N)
									{
										Iterator Piter = Pro_Y_N.iterator();
										while(Piter.hasNext())
										{
											ProLBean prBean = (ProLBean)Piter.next();
											if(!T_Cpm_Id.equals(prBean.getCpm_Id()))
											{
											T_Cpm_Name = prBean.getCpm_Name();
											}
											
										}									
									
									}
				%>						
											<td width='65%' align=left><strong>վ������:�к����麣����Դ���޹�˾<%=T_Cpm_Name%>վ</strong></td>
											<td width='25%' align=left><strong>��������: <%=Year%>��</strong></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr height='30'>
						    <td width='12%' align=center rowspan='2'><strong>����\��Ŀ</strong></td>
						    <td width='22%' align=center colspan='2'><strong>��������</strong></td>
						    <td width='22%' align=center colspan='2'><strong>��������</strong></td>
						    <td width='22%' align=center colspan='2'><strong>�������</strong></td>
						    <td width='22%' align=center colspan='2'><strong>ӯ������</strong></td>
						  </tr>
						  <tr height='30'>
						  	<%
						  	String Name1 = "";
						  	String Name2 = "";
						  	String Name3 = "";
						  	switch(Integer.parseInt(currStatus.getFunc_Corp_Id()))
								{
									default:
									case 1000://����
									Name1 = "����(L)";
								  Name2 = "�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1010://90#����
									Name1 = "90#����(L)";
								  Name2 = "90#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1011://90#��Ǧ����
									Name1 = "90#��Ǧ����(L)";
								  Name2 = "90#��Ǧ�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1012://90#�������
									Name1 = "90#�������(L)";
								  Name2 = "90#��������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1020://92#����
									Name1 = "92#����(L)";
								  Name2 = "92#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1021://92#��Ǧ����
									Name1 = "92#��Ǧ����(L)";
								  Name2 = "92#��Ǧ�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1022://92#�������
									Name1 = "92#�������(L)";
								  Name2 = "92#��������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1030://93#����
									Name1 = "93#����(L)";
								  Name2 = "93#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1031://93����Ǧ����
									Name1 = "93����Ǧ����(L)";
								  Name2 = "93����Ǧ�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1032://93#�������
									Name1 = "93#�������(L)";
								  Name2 = "93#��������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1040://95#����
									Name1 = "95#����(L)";
								  Name2 = "95#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1041://95#��Ǧ����
									Name1 = "95#��Ǧ����(L)";
								  Name2 = "95#��Ǧ�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1042://95#�������
									Name1 = "95#�������(L)";
								  Name2 = "95#��������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1050://97#����
									Name1 = "97#����(L)";
								  Name2 = "97#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1051://97#��Ǧ����
									Name1 = "97#��Ǧ����(L)";
								  Name2 = "97#��Ǧ�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1052://97#�������
									Name1 = "97#�������(L)";
								  Name2 = "97#��������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1060://120������
									Name1 = "120������(L)";
								  Name2 = "120�������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1080://������������
									Name1 = "������������(L)";
								  Name2 = "�������������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1090://98#����
									Name1 = "98#����(L)";
								  Name2 = "98#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1091://98#��Ǧ����
									Name1 = "98#��Ǧ����(L)";
								  Name2 = "98#��Ǧ�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1092://98���������
									Name1 = "98���������(L)";
								  Name2 = "98����������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1100://��������
									Name1 = "��������(L)";
								  Name2 = "���������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1200://��������
									Name1 = "��������(L)";
								  Name2 = "���������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1201://75#��������
									Name1 = "75#��������(L)";
								  Name2 = "75#���������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1202://95#��������
									Name1 = "95#��������(L)";
								  Name2 = "95#���������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1203://100#��������
									Name1 = "100#��������(L)";
								  Name2 = "100#���������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1204://������������
									Name1 = "������������(L)";
								  Name2 = "�������������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 1300://��������
									Name1 = "��������(L)";
								  Name2 = "���������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2000://����
									Name1 = "����(L)";
								  Name2 = "�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2001://0#����
									Name1 = "0#����(L)";
								  Name2 = "0#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2002://+5#����
									Name1 = "+5#����(L)";
								  Name2 = "+5#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2003://+10#����
									Name1 = "+10#����(L)";
								  Name2 = "+10#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2004://+15#����
									Name1 = "+15#����(L)";
								  Name2 = "+15#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2005://+20#����
									Name1 = "+20#����(L)";
								  Name2 = "+20#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2006://-5#����
									Name1 = "-5#����(L)";
								  Name2 = "-5#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2007://-10#����
									Name1 = "-10#����(L)";
								  Name2 = "-10#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2008://-15#����
									Name1 = "-15#����(L)";
								  Name2 = "-15#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2009://-20#����
									Name1 = "-20#����(L)";
								  Name2 = "-20#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2010://-30#����
									Name1 = "-30#����(L)";
								  Name2 = "-30#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2011://-35#����
									Name1 = "-35#����(L)";
								  Name2 = "-35#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2015://-50#����
									Name1 = "-50#����(L)";
								  Name2 = "-50#�����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2100://�����
									Name1 = "�����(L)";
								  Name2 = "������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2016://���������
									Name1 = "���������(L)";
								  Name2 = "����������ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2200://�ز���
									Name1 = "�ز���(L)";
								  Name2 = "�ز����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2012://10#�ز���
									Name1 = "10#�ز���(L)";
								  Name2 = "10#�ز����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2013://20#�ز���
									Name1 = "20#�ز���(L)";
								  Name2 = "20#�ز����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2014://�����ز���
									Name1 = "�����ز���(L)";
								  Name2 = "�����ز����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2300://���ò���
									Name1 = "���ò���(L)";
								  Name2 = "���ò����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2301://-10#���ò���
									Name1 = "-10#���ò���(L)";
								  Name2 = "-10#���ò����ۺ�����(kg)";
								  Name3 = "(L)";
									break;
								case 2900://��������
										Name1 = "��������(L)";
								    Name2 = "���������ۺ�����(kg)";
								    Name3 = "(L)";
									break;
								case 3001://CNG
									Name1 = "CNGȼ����(kg)";
								    Name2 = "CNG�ۺ���̬(Nm3)";
								    Name3 = "(kg)";
									break;
								case 3002://LNG
										Name1 = "LNGȼ����(kg)";
								    Name2 = "LNG�ۺ���̬(Nm3)";
								    Name3 = "(kg)";
									break;
							}
							%>
											<td width='10%' align=center><%=Name1%></td>
									    <td width='10%' align=center><%=Name2%></td>
									    <td width='10%' align=center><%=Name1%></td>
									    <td width='10%' align=center><%=Name2%></td>
									    <td width='10%' align=center><%=Name1%></td>
									    <td width='10%' align=center><%=Name2%></td>
									    <td width='12%' align=center><%=Name1%></td>
									    <td width='12%' align=center><%=Name2%></td>
							
						  </tr>
							<%
								if(null != Pro_Y_N)
								{
									cnt++;
									Iterator iterator = Pro_Y_N.iterator();
									while(iterator.hasNext())
									{
										ProLBean Bean = (ProLBean)iterator.next();			
										
										
										if(!T_Cpm_Id.equals(Bean.getCpm_Id()))
											{
												
																								
										CTime = Bean.getCTime();
										DTime = CTime.substring(4,6);
										Value_O = Bean.getValue_O();
										Value_O_Gas = Bean.getValue_O_Gas();
										Value_I = Bean.getValue_I();
										Value_I_Gas = Bean.getValue_I_Gas();
										Value_R = Bean.getValue_R();
										Value_R_Gas = Bean.getValue_R_Gas();
										Value_PAL = Bean.getValue_PAL();
										Value_PAL_Gas = Bean.getValue_PAL_Gas();
										
										Value_O_All     = Value_O_All + Double.parseDouble(Value_O);
										Value_O_Gas_All = Value_O_Gas_All + Double.parseDouble(Value_O_Gas);
										Value_I_All     = Value_I_All + Double.parseDouble(Value_I);
										Value_I_Gas_All = Value_I_Gas_All + Double.parseDouble(Value_I_Gas);
										Value_R_All     = Value_R_All + Double.parseDouble(Value_R);
										Value_R_Gas_All = Value_R_Gas_All + Double.parseDouble(Value_R_Gas);
										Value_PAL_All     = Value_PAL_All + Double.parseDouble(Value_PAL);
										Value_PAL_Gas_All = Value_PAL_Gas_All + Double.parseDouble(Value_PAL_Gas);
										%>
								<tr height='30'>
						    <td width='12%' align=center><%= DTime%>��</td>
						    <td width='11%' align=center><%= Value_O%></td>
						    <td width='11%' align=center><%= Value_O_Gas%></td>
						    <td width='11%' align=center><%= Value_I%></td>
						    <td width='11%' align=center><%= Value_I_Gas%></td>
						    <td width='11%' align=center><%= Value_R%></td>
						    <td width='11%' align=center><%= Value_R_Gas%></td>
						    <td width='11%' align=center><%= Value_PAL%>&nbsp;</td>
						    <td width='11%' align=center><%= Value_PAL_Gas%>&nbsp;</td>
						  </tr>	
						  
						  <%	
						  			}					
									}
								}
							%>
																	  											
							<tr height='30'>
							  <td width='12%' align=center><strong>�����ۼ�</strong></td>
							  <td width='11%' align=center><strong><%=new BigDecimal(Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
							  <td width='11%' align=center><strong><%=new BigDecimal(Value_O_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
							  <td width='11%' align=center><strong><%=new BigDecimal(Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
							  <td width='11%' align=center><strong><%=new BigDecimal(Value_I_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
							  <td width='11%' align=center><strong><%=new BigDecimal(Value_R_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
							  <td width='11%' align=center><strong><%=new BigDecimal(Value_R_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
							  <td width='11%' align=center><strong><%=new BigDecimal(Value_PAL_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%>&nbsp;</strong></td>
							  <td width='11%' align=center><strong><%=new BigDecimal(Value_PAL_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%>&nbsp;</strong></td>
							</tr>
							<tr height='30'>
							  <td width='30%' align=center colspan=2><strong>�Ʊ�: </strong>ϵͳ</td>
							  <td width='28%' align=center colspan=3><strong>���: </strong>\</td>
							  <td width='42%' align=center colspan=4><strong>�ϱ�����: </strong>\</td>
							</tr>	
				</table>
			</td>
		</tr>
	</table>
</div>
<input name="Cmd"    type="hidden" value="5">
<input name="Sid"    type="hidden" value="<%=Sid%>">
<input name="Cpm_Id" type="hidden" value=""/>
<input name="BTime"  type="hidden" value="">
<input name="ETime"  type="hidden" value="">
<input type="button" id="CurrButton" onClick="doSelect()" style="display:none">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//ipad��������
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
{
	document.getElementById('img2').style.display = 'none';
}

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Pro_Y.jsp';

function doChangeSelect(pFunc_Sub_Id)
{  
	
	switch(parseInt(pFunc_Sub_Id))
	{
		case 1://����
  			var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
			  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
			  var Year  = BTime.substring(0,4);
			  var Month = BTime.substring(5,7);
				window.parent.frames.mFrame.location = "Pro_Y.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+Pro_Y.Func_Cpm_Id.value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_Y.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
			break;
		case 2://����
				var TDay  = new Date().format("yyyy-MM-dd");
				var Year  = TDay.substring(0,4);
				var Month = TDay.substring(5,7);
				var Week  = "1";
				var BTime = TDay;
				var ETime = TDay;
				window.parent.frames.mFrame.location = "Pro_Y.do?Cmd=3&Sid=<%=Sid%>&Cpm_Id="+Pro_Y.Func_Cpm_Id.value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_Y.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month+"&Week="+Week;
			break;
		case 3://����
				var BTime = showPreviousDay().format("yyyy-MM-dd");
				window.parent.frames.mFrame.location = "Pro_Y.do?Cmd=4&Sid=<%=Sid%>&Cpm_Id="+Pro_Y.Func_Cpm_Id.value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_Y.Func_Corp_Id.value+"&BTime="+BTime;
				break;
		case 4: //��
				window.parent.frames.mFrame.location = "Pro_L.do?Cmd=5&Sid=<%=Sid%>&Cpm_Id="+Pro_L.Func_Cpm_Id.value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_L.Func_Corp_Id.value+"&Year=2015";
				break;
	}
}

function doSelect()
{
	Pro_Y.Cpm_Id.value = Pro_Y.Func_Cpm_Id.value;
	Pro_Y.BTime.value = Pro_Y.Year.value + '-01-01';
  Pro_Y.ETime.value = Pro_Y.Year.value + '-02-31';
	Pro_Y.submit();
}

var req = null;
function doExport()
{
	if(0 == <%=cnt%>)
	{
		alert('��ǰ�ޱ���!');
		return;
	}
	var BTime = Pro_Y.Year.value  + '-01-01';
	var ETime = Pro_Y.Year.value  + '-12-31';
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
		var url = "Pro_L_Y_Export.do?Sid=<%=Sid%>&Operator_Name=<%=Operator_Name%>&Cpm_Id="+Pro_Y.Func_Cpm_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Func_Sub_Id="+Pro_Y.Func_Sub_Id.value+"&Func_Corp_Id="+Pro_Y.Func_Corp_Id.value+"&Year="+Pro_Y.Year.value;
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

function doGraph()
{
	//���·���
	var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var BYear  = BTime.substring(0,4);
  var BMonth = BTime.substring(5,7);
  var EYear  = BTime.substring(0,4);
  var EMonth = BTime.substring(5,7);
  window.parent.frames.mFrame.location = "Pro_G.do?Cmd=20&Sid=<%=Sid%>&Cpm_Id="+Pro_Y.Func_Cpm_Id.value+"&Func_Corp_Id=3001&Func_Sub_Id=1&Func_Sel_Id=1&BYear="+BYear+"&BMonth="+BMonth+"&EYear="+EYear+"&EMonth="+EMonth;
}
</SCRIPT>
</html>