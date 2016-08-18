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
<link type="text/css" href="../../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../../skin/js/util.js"></script>
<script type="text/javascript" src="../../skin/js/day.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
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
	
	ArrayList Pro_R_Type   = (ArrayList)session.getAttribute("Pro_R_Type_" + Sid);
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
	
	int Year  = Integer.parseInt(CommUtil.getDate().substring(0,4));
  int Month = Integer.parseInt(CommUtil.getDate().substring(5,7));
  int Week = 1;
  if(null != (String)session.getAttribute("Year_" + Sid)  && ((String)session.getAttribute("Year_" + Sid)).trim().length() > 0) {Year = CommUtil.StrToInt((String)session.getAttribute("Year_" + Sid));}
  if(null != (String)session.getAttribute("Month_" + Sid) && ((String)session.getAttribute("Month_" + Sid)).trim().length() > 0){Month = CommUtil.StrToInt((String)session.getAttribute("Month_" + Sid));}
  if(null != (String)session.getAttribute("Week_" + Sid)  && ((String)session.getAttribute("Week_" + Sid)).trim().length() > 0) {Week = CommUtil.StrToInt((String)session.getAttribute("Week_" + Sid));}
  
  ArrayList Pro_C_W = (ArrayList)session.getAttribute("Pro_C_W_" + Sid);
  ArrayList Pro_Y_W = (ArrayList)session.getAttribute("Pro_Y_W_" + Sid);
  ArrayList Pro_L_W = (ArrayList)session.getAttribute("Pro_L_W_" + Sid);
	String T_Cpm_Id   = "";
  String T_Cpm_Name = "";
	int cnt           = 0;
	
%>
<body style=" background:#CADFFF">
<form name="Pro_L_W"  action="Pro_L.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				ȼ������:
				<select name='Func_Corp_Id' style='width:150px;height:20px' onChange="doSelect()">				
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
	        <option value="1" <%=(currStatus.getFunc_Sub_Id() == 1 ?"SELECTED":"")%>>�±���</option>
	        <option value="2" <%=(currStatus.getFunc_Sub_Id() == 2 ?"SELECTED":"")%>>�ܱ���</option>
	        <option value="3" <%=(currStatus.getFunc_Sub_Id() == 3 ?"SELECTED":"")%>>�ձ���</option>
	      </select>
	      <select name="Year" style="width:70px;height:20px;">
        <%
        for(int j=2012; j<=2030; j++)
        {
        %>
          <option value="<%=j%>" <%=(Year == j?"selected":"")%>><%=j%>��</option>
        <%
        }
        %>
        </select>
        <select name="Month" style="width:60px;height:20px;">
        <%
        for(int k=1; k<13; k++)
        {
       	%>
       		<option value="<%=k%>" <%=(Month == k?"selected":"")%>><%=k%>��</option>
       	<%
       	}
       	%>
        </select>
	      <select name="Week" style="width:70px;height:20px;">
        	<option value="1" <%=(Week == 1?"selected":"")%>>��һ��</option>
        	<option value="2" <%=(Week == 2?"selected":"")%>>�ڶ���</option>
        	<option value="3" <%=(Week == 3?"selected":"")%>>������</option>
        	<option value="4" <%=(Week == 4?"selected":"")%>>������</option>
        	<option value="5" <%=(Week == 5?"selected":"")%>>������</option>
        </select>
			</td>
			<td width='30%' align='right'>		
				<img id="img1" src="../../skin/images/mini_button_search.gif" onClick='doSelect()' style='cursor:hand;'>
				<img id="img2" src="../../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='020402' ctype='1'/>">
				<img id="img3" src="../../skin/images/tubiaofenxi.gif"        onClick='doGraph()'  style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='020403' ctype='1'/>">
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
				<%
				if(null != Pro_L_W)
				{
					Iterator iterator = Pro_L_W.iterator();
					while(iterator.hasNext())
					{
						ProLBean Bean = (ProLBean)iterator.next();
						cnt++;
						if(!T_Cpm_Id.equals(Bean.getCpm_Id()))
						{
							if(T_Cpm_Id.length() > 0)
							{
								//�����������С��
								int Car_Cnt = 0;
								if(null != Pro_C_W)
								{
									Iterator cariter = Pro_C_W.iterator();
									while(cariter.hasNext())
									{
										ProLBean carBean = (ProLBean)cariter.next();
										if(carBean.getCpm_Id().equals(T_Cpm_Id))
										{
											Car_Cnt++;
										}
									}
								}
								String Summary = "1����վ����Ӫ������"+ Car_Cnt +"̨;";
				%>
								<tr height='100'>
								  <td width='24%' align=center colspan=2><strong>�����������С��</strong></td>
								  <td width='76%' align=left colspan=9 valign=top><%=Summary%></td>
								</tr>							
								<tr height='30'>
								  <td width='32%' align=center colspan=3><strong>�Ʊ�: </strong>ϵͳ</td>
								  <td width='24%' align=center colspan=3><strong>���: </strong><%=Operator_Name%></td>
								  <td width='44%' align=center colspan=5><strong>�ϱ�����: </strong><%=CommUtil.getDate()%></td>
								</tr>
				<%
							}
							T_Cpm_Name = Bean.getCpm_Name();							
				%>
							<tr height='50'>
								<td width='100%' align=center colspan=11><font size=4><B>����վ/����վ������Ӫ�ܱ���[<%=Oil_Name%>]</B></font></td>
							</tr>
							<tr height='30'>
								<td width='100%' align=center colspan=11>
									<table width="100%" border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
										<tr height='30'>
											<td width='10%' align=center>&nbsp;</td>
											<td width='55%' align=left><strong>վ������: <%=T_Cpm_Name%></strong></td>
											<td width='35%' align=left><strong>��������: <%=BDate%> �� <%=EDate%></strong></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr height='30'>
						    <td width='24%' align=center rowspan='2' colspan=2><strong>��Ŀ\����</strong></td>
						    <td width='8%'  align=center><strong>������</strong></td>
						    <td width='8%'  align=center><strong>����һ</strong></td>
						    <td width='8%'  align=center><strong>���ڶ�</strong></td>
						    <td width='8%'  align=center><strong>������</strong></td>
						    <td width='8%'  align=center><strong>������</strong></td>
						    <td width='8%'  align=center><strong>������</strong></td>
						    <td width='8%'  align=center><strong>������</strong></td>
						    <td width='10%' align=center rowspan='2'><strong>�����ۼ�</strong></td>
						    <td width='10%' align=center rowspan='2'><strong>�����ۼ�</strong></td>
						  </tr>
						  <%
						  String Name1 = "";
						  String Name2 = "";
					  	switch(Integer.parseInt(currStatus.getFunc_Corp_Id()))
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
										Name1 = "ȼ����(L)";
								    Name2 = "�ۺ�����(kg)";
									break;
								case 3001://CNG
								case 3002://LNG
										Name1 = "ȼ����(kg)";
								    Name2 = "�ۺ���̬(m3)";
									break;
							}
						  %>
						  <%
						  //���� - ����
						  String a_Value_O     = "0";
						  String a_Value_O_Gas = "0";
						  String a_Value_I     = "0";
						  String a_Value_I_Gas = "0";
						  String a_Value_R     = "0";
						  String a_Value_R_Gas = "0";
						  
						  String b_Value_O     = "0";
						  String b_Value_O_Gas = "0";
						  String b_Value_I     = "0";
						  String b_Value_I_Gas = "0";
						  String b_Value_R     = "0";
						  String b_Value_R_Gas = "0";
						  
						  String c_Value_O     = "0";
						  String c_Value_O_Gas = "0";
						  String c_Value_I     = "0";
						  String c_Value_I_Gas = "0";
						  String c_Value_R     = "0";
						  String c_Value_R_Gas = "0";
						  
						  String d_Value_O     = "0";
						  String d_Value_O_Gas = "0";
						  String d_Value_I     = "0";
						  String d_Value_I_Gas = "0";
						  String d_Value_R     = "0";
						  String d_Value_R_Gas = "0";
						  
						  String e_Value_O     = "0";
						  String e_Value_O_Gas = "0";
						  String e_Value_I     = "0";
						  String e_Value_I_Gas = "0";
						  String e_Value_R     = "0";
						  String e_Value_R_Gas = "0";
						  
						  String f_Value_O     = "0";
						  String f_Value_O_Gas = "0";
						  String f_Value_I     = "0";
						  String f_Value_I_Gas = "0";
						  String f_Value_R     = "0";
						  String f_Value_R_Gas = "0";
						  
						  String g_Value_O     = "0";
						  String g_Value_O_Gas = "0";
						  String g_Value_I     = "0";
						  String g_Value_I_Gas = "0";
						  String g_Value_R     = "0";
						  String g_Value_R_Gas = "0";
						  if(null != Pro_L_W)
							{
								Iterator dataiter = Pro_L_W.iterator();
								while(dataiter.hasNext())
								{
									ProLBean dataBean = (ProLBean)dataiter.next();
									if(dataBean.getCpm_Id().equals(Bean.getCpm_Id()))
									{
										if(0 == CommUtil.getCompareDay(dataBean.getCTime(), BDate))
										{
											a_Value_O     = dataBean.getValue_O();
										  a_Value_O_Gas = dataBean.getValue_O_Gas();
										  a_Value_I     = dataBean.getValue_I();
										  a_Value_I_Gas = dataBean.getValue_I_Gas();
										  a_Value_R     = dataBean.getValue_R();
										  a_Value_R_Gas = dataBean.getValue_R_Gas();
										}
										if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(BDate + " 00:00:00", 1).substring(0,10)))
										{
											b_Value_O     = dataBean.getValue_O();
										  b_Value_O_Gas = dataBean.getValue_O_Gas();
										  b_Value_I     = dataBean.getValue_I();
										  b_Value_I_Gas = dataBean.getValue_I_Gas();
										  b_Value_R     = dataBean.getValue_R();
										  b_Value_R_Gas = dataBean.getValue_R_Gas();
										}
										if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(BDate + " 00:00:00", 2).substring(0,10)))
										{
											c_Value_O     = dataBean.getValue_O();
										  c_Value_O_Gas = dataBean.getValue_O_Gas();
										  c_Value_I     = dataBean.getValue_I();
										  c_Value_I_Gas = dataBean.getValue_I_Gas();
										  c_Value_R     = dataBean.getValue_R();
										  c_Value_R_Gas = dataBean.getValue_R_Gas();
										}
										if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(BDate + " 00:00:00", 3).substring(0,10)))
										{
											d_Value_O     = dataBean.getValue_O();
										  d_Value_O_Gas = dataBean.getValue_O_Gas();
										  d_Value_I     = dataBean.getValue_I();
										  d_Value_I_Gas = dataBean.getValue_I_Gas();
										  d_Value_R     = dataBean.getValue_R();
										  d_Value_R_Gas = dataBean.getValue_R_Gas();
										}
										if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(BDate + " 00:00:00", 4).substring(0,10)))
										{
											e_Value_O     = dataBean.getValue_O();
										  e_Value_O_Gas = dataBean.getValue_O_Gas();
										  e_Value_I     = dataBean.getValue_I();
										  e_Value_I_Gas = dataBean.getValue_I_Gas();
										  e_Value_R     = dataBean.getValue_R();
										  e_Value_R_Gas = dataBean.getValue_R_Gas();
										}
										if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(BDate + " 00:00:00", 5).substring(0,10)))
										{
											f_Value_O     = dataBean.getValue_O();
										  f_Value_O_Gas = dataBean.getValue_O_Gas();
										  f_Value_I     = dataBean.getValue_I();
										  f_Value_I_Gas = dataBean.getValue_I_Gas();
										  f_Value_R     = dataBean.getValue_R();
										  f_Value_R_Gas = dataBean.getValue_R_Gas();
										}
										if(0 == CommUtil.getCompareDay(dataBean.getCTime(), EDate))
										{
											g_Value_O     = dataBean.getValue_O();
										  g_Value_O_Gas = dataBean.getValue_O_Gas();
										  g_Value_I     = dataBean.getValue_I();
										  g_Value_I_Gas = dataBean.getValue_I_Gas();
										  g_Value_R     = dataBean.getValue_R();
										  g_Value_R_Gas = dataBean.getValue_R_Gas();
										}
									}
						  	}
						  }
						  
						  //�����ۼ�
						  double Value_O_All     = 0.0;
						  double Value_O_Gas_All = 0.0;
						  double Value_I_All     = 0.0;
						  double Value_I_Gas_All = 0.0;
						  double Value_R_All     = 0.0;
						  double Value_R_Gas_All = 0.0;
						  
						  Value_O_All = Double.parseDouble(a_Value_O) 
						              + Double.parseDouble(b_Value_O) 
						              + Double.parseDouble(c_Value_O) 
						              + Double.parseDouble(d_Value_O) 
						              + Double.parseDouble(e_Value_O) 
						              + Double.parseDouble(f_Value_O) 
						              + Double.parseDouble(g_Value_O);
						              
						  Value_O_Gas_All = Double.parseDouble(a_Value_O_Gas) 
						              		+ Double.parseDouble(b_Value_O_Gas) 
						              		+ Double.parseDouble(c_Value_O_Gas) 
						              		+ Double.parseDouble(d_Value_O_Gas) 
						              		+ Double.parseDouble(e_Value_O_Gas) 
						              		+ Double.parseDouble(f_Value_O_Gas) 
						              		+ Double.parseDouble(g_Value_O_Gas);
						  
						  Value_I_All = Double.parseDouble(a_Value_I) 
						              + Double.parseDouble(b_Value_I) 
						              + Double.parseDouble(c_Value_I) 
						              + Double.parseDouble(d_Value_I) 
						              + Double.parseDouble(e_Value_I) 
						              + Double.parseDouble(f_Value_I) 
						              + Double.parseDouble(g_Value_I);
						              
						  Value_I_Gas_All = Double.parseDouble(a_Value_I_Gas) 
						              		+ Double.parseDouble(b_Value_I_Gas) 
						              		+ Double.parseDouble(c_Value_I_Gas) 
						              		+ Double.parseDouble(d_Value_I_Gas) 
						              		+ Double.parseDouble(e_Value_I_Gas) 
						              		+ Double.parseDouble(f_Value_I_Gas) 
						              		+ Double.parseDouble(g_Value_I_Gas);
						              		
						  Value_R_All = Double.parseDouble(a_Value_R) 
						              + Double.parseDouble(b_Value_R) 
						              + Double.parseDouble(c_Value_R) 
						              + Double.parseDouble(d_Value_R) 
						              + Double.parseDouble(e_Value_R) 
						              + Double.parseDouble(f_Value_R) 
						              + Double.parseDouble(g_Value_R);
						              
						  Value_R_Gas_All = Double.parseDouble(a_Value_R_Gas) 
						              		+ Double.parseDouble(b_Value_R_Gas) 
						              		+ Double.parseDouble(c_Value_R_Gas) 
						              		+ Double.parseDouble(d_Value_R_Gas) 
						              		+ Double.parseDouble(e_Value_R_Gas) 
						              		+ Double.parseDouble(f_Value_R_Gas) 
						              		+ Double.parseDouble(g_Value_R_Gas);
						  
						  //�����ۼ�
						  String Value_O_Y     = "0";
						  String Value_O_Gas_Y = "0";
						  String Value_I_Y     = "0";
						  String Value_I_Gas_Y = "0";
						  String Value_R_Y     = "0";
						  String Value_R_Gas_Y = "0";
							if(null != Pro_Y_W)
							{
								Iterator yeariter = Pro_Y_W.iterator();
								while(yeariter.hasNext())
								{
									ProLBean yearBean = (ProLBean)yeariter.next();
									if(yearBean.getCpm_Id().equals(Bean.getCpm_Id()))
									{
										Value_O_Y     = yearBean.getValue_O();
										Value_O_Gas_Y = yearBean.getValue_O_Gas();
										Value_I_Y     = yearBean.getValue_I();
										Value_I_Gas_Y = yearBean.getValue_I_Gas();
										Value_R_Y     = yearBean.getValue_R();
										Value_R_Gas_Y = yearBean.getValue_R_Gas();
									}
								}
							}
							
						  %>
						  <tr height='30'>
						    <td width='8%' align=center><strong>(<%=BDate.substring(5,10)%>)</strong></td>
						    <td width='8%' align=center><strong>(<%=CommUtil.getDateAfter(BDate + " 00:00:00", 1).substring(5,10)%>)</strong></td>
						    <td width='8%' align=center><strong>(<%=CommUtil.getDateAfter(BDate + " 00:00:00", 2).substring(5,10)%>)</strong></td>
						    <td width='8%' align=center><strong>(<%=CommUtil.getDateAfter(BDate + " 00:00:00", 3).substring(5,10)%>)</strong></td>
						    <td width='8%' align=center><strong>(<%=CommUtil.getDateAfter(BDate + " 00:00:00", 4).substring(5,10)%>)</strong></td>
						    <td width='8%' align=center><strong>(<%=CommUtil.getDateAfter(BDate + " 00:00:00", 5).substring(5,10)%>)</strong></td>
						    <td width='8%' align=center><strong>(<%=EDate.substring(5,10)%>)</strong></td>
						  </tr>
						  <tr height='30'>
						    <td width='12%' align=center rowspan=2>��������</td>
						    <td width='12%' align=center><%=Name1%></td>
						    <td width='8%'  align=center><%=a_Value_O%></td>
						    <td width='8%'  align=center><%=b_Value_O%></td>
						    <td width='8%'  align=center><%=c_Value_O%></td>
						    <td width='8%'  align=center><%=d_Value_O%></td>
						    <td width='8%'  align=center><%=e_Value_O%></td>
						    <td width='8%'  align=center><%=f_Value_O%></td>
						    <td width='8%'  align=center><%=g_Value_O%></td>
						    <td width='10%' align=center><%=new BigDecimal(Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></td>
						    <td width='10%' align=center><%=Value_O_Y%></td>
						  </tr>
						  <tr height='30'>
						    <td width='12%' align=center><%=Name2%></td>
						    <td width='8%'  align=center><%=a_Value_O_Gas%></td>
						    <td width='8%'  align=center><%=b_Value_O_Gas%></td>
						    <td width='8%'  align=center><%=c_Value_O_Gas%></td>
						    <td width='8%'  align=center><%=d_Value_O_Gas%></td>
						    <td width='8%'  align=center><%=e_Value_O_Gas%></td>
						    <td width='8%'  align=center><%=f_Value_O_Gas%></td>
						    <td width='8%'  align=center><%=g_Value_O_Gas%></td>
						    <td width='10%' align=center><%=new BigDecimal(Value_O_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></td>
						    <td width='10%' align=center><%=Value_O_Gas_Y%></td>
						  </tr>
						  <tr height='30'>
						    <td width='12%' align=center rowspan=2>��������</td>
						    <td width='12%' align=center><%=Name1%></td>
						    <td width='8%'  align=center><%=a_Value_I%></td>
						    <td width='8%'  align=center><%=b_Value_I%></td>
						    <td width='8%'  align=center><%=c_Value_I%></td>
						    <td width='8%'  align=center><%=d_Value_I%></td>
						    <td width='8%'  align=center><%=e_Value_I%></td>
						    <td width='8%'  align=center><%=f_Value_I%></td>
						    <td width='8%'  align=center><%=g_Value_I%></td>
						    <td width='10%' align=center><%=new BigDecimal(Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></td>
						    <td width='10%' align=center><%=Value_I_Y%></td>
						  </tr>
						  <tr height='30'>
						    <td width='12%' align=center><%=Name2%></td>
						    <td width='8%'  align=center><%=a_Value_I_Gas%></td>
						    <td width='8%'  align=center><%=b_Value_I_Gas%></td>
						    <td width='8%'  align=center><%=c_Value_I_Gas%></td>
						    <td width='8%'  align=center><%=d_Value_I_Gas%></td>
						    <td width='8%'  align=center><%=e_Value_I_Gas%></td>
						    <td width='8%'  align=center><%=f_Value_I_Gas%></td>
						    <td width='8%'  align=center><%=g_Value_I_Gas%></td>
						    <td width='10%' align=center><%=new BigDecimal(Value_I_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></td>
						    <td width='10%' align=center><%=Value_I_Gas_Y%></td>
						  </tr>
						  <tr height='30'>
						    <td width='12%' align=center rowspan=2>�������</td>
						    <td width='12%' align=center><%=Name1%></td>
						    <td width='8%'  align=center><%=a_Value_R%></td>
						    <td width='8%'  align=center><%=b_Value_R%></td>
						    <td width='8%'  align=center><%=c_Value_R%></td>
						    <td width='8%'  align=center><%=d_Value_R%></td>
						    <td width='8%'  align=center><%=e_Value_R%></td>
						    <td width='8%'  align=center><%=f_Value_R%></td>
						    <td width='8%'  align=center><%=g_Value_R%></td>
						    <td width='10%' align=center><%=new BigDecimal(Value_R_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></td>
						    <td width='10%' align=center><%=Value_R_Y%></td>
						  </tr>
						  <tr height='30'>
						    <td width='12%' align=center><%=Name2%></td>
						    <td width='8%'  align=center><%=a_Value_R_Gas%></td>
						    <td width='8%'  align=center><%=b_Value_R_Gas%></td>
						    <td width='8%'  align=center><%=c_Value_R_Gas%></td>
						    <td width='8%'  align=center><%=d_Value_R_Gas%></td>
						    <td width='8%'  align=center><%=e_Value_R_Gas%></td>
						    <td width='8%'  align=center><%=f_Value_R_Gas%></td>
						    <td width='8%'  align=center><%=g_Value_R_Gas%></td>
						    <td width='10%' align=center><%=new BigDecimal(Value_R_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></td>
						    <td width='10%' align=center><%=Value_R_Gas_Y%></td>
						  </tr>
				<%
						}
						T_Cpm_Id = Bean.getCpm_Id();
						if(cnt == Pro_L_W.size())
						{
							//�����������С��
							int Car_Cnt = 0;
							if(null != Pro_C_W)
							{
								Iterator cariter = Pro_C_W.iterator();
								while(cariter.hasNext())
								{
									ProLBean carBean = (ProLBean)cariter.next();
									if(carBean.getCpm_Id().equals(T_Cpm_Id))
									{
										Car_Cnt++;
									}
								}
							}
							String Summary = "1����վ����Ӫ������"+ Car_Cnt +"̨;";
				%> 
							<tr height='100'>
								  <td width='24%' align=center colspan=2><strong>�����������С��</strong></td>
								  <td width='76%' align=left colspan=9 valign=top><%=Summary%></td>
								</tr>
							<tr height='30'>
							  <td width='32%' align=center colspan=3><strong>�Ʊ�: </strong>ϵͳ</td>
							  <td width='24%' align=center colspan=3><strong>���: </strong><%=Operator_Name%></td>
							  <td width='44%' align=center colspan=5><strong>�ϱ�����: </strong><%=CommUtil.getDate()%></td>
							</tr>
				<%			
						}
					}
				}
				else
				{
				%>
					<tr height='30'>
						<td width='100%' align=center colspan=11>��!</td>
					</tr>
				<%
				}
				%>
				</table>
			</td>
		</tr>
	</table>
</div>
<input name="Cmd"    type="hidden" value="3">
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Pro_L_W.jsp';

function doChangeSelect(pFunc_Sub_Id)
{
	switch(parseInt(pFunc_Sub_Id))
	{
		case 1://����
  			var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
			  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
			  var Year  = BTime.substring(0,4);
			  var Month = BTime.substring(5,7);
				window.parent.frames.mFrame.location = "Pro_L.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_L_W.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
			break;
		case 2://����
				var TDay  = new Date().format("yyyy-MM-dd");
				var Year  = TDay.substring(0,4);
				var Month = TDay.substring(5,7);
				var Week  = "1";
				var BTime = TDay;
				var ETime = TDay;
				window.parent.frames.mFrame.location = "Pro_L.do?Cmd=3&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_L_W.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month+"&Week="+Week;
			break;
		case 3://����
				var BTime = showPreviousDay().format("yyyy-MM-dd");
				window.parent.frames.mFrame.location = "Pro_L.do?Cmd=4&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_L_W.Func_Corp_Id.value+"&BTime="+BTime;
			break;
	}
}

function doSelect()
{
	Pro_L_W.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Pro_L_W.BTime.value = new Date().format("yyyy-MM-dd");
  Pro_L_W.ETime.value = new Date().format("yyyy-MM-dd");
	Pro_L_W.submit();
}

var req = null;
function doExport()
{
	if(0 == <%=cnt%>)
	{
		alert('��ǰ�ޱ���!');
		return;
	}
	var BTime = new Date().format("yyyy-MM-dd");
	var ETime = new Date().format("yyyy-MM-dd");
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
		var url = "Pro_L_W_Export.do?Sid=<%=Sid%>&Operator_Name=<%=Operator_Name%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&BTime="+BTime+"&ETime="+ETime+"&Func_Sub_Id="+Pro_L_W.Func_Sub_Id.value+"&Func_Corp_Id="+Pro_L_W.Func_Corp_Id.value+"&Year="+Pro_L_W.Year.value+"&Month="+Pro_L_W.Month.value+"&Week="+Pro_L_W.Week.value;
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
			location.href = "../../files/excel/" + resp + ".xls";
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
  window.parent.frames.mFrame.location = "Pro_G.do?Cmd=20&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Corp_Id=3001&Func_Sub_Id=1&Func_Sel_Id=1&BYear="+BYear+"&BMonth="+BMonth+"&EYear="+EYear+"&EMonth="+EMonth;
}
</SCRIPT>
</html>