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
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>

</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String BDate = CommUtil.getDate();
	
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId = UserInfo.getManage_Role();
  
  ArrayList Pro_R_Buss = (ArrayList)session.getAttribute("Pro_R_Buss_" + Sid);
  ArrayList Pro_Tank_NO = (ArrayList)session.getAttribute("Pro_R_Tank_No_" + Sid);
  CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
  ArrayList Pro_I_All = (ArrayList)session.getAttribute("Pro_R_Type_" + Sid);
	String Oil_Info = "";
	if(null != Corp_Info)
	{
		Oil_Info = Corp_Info.getOil_Info();
		if(null == Oil_Info){Oil_Info = "";}
	}
	
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
								String Dept_Id = UserInfo.getDept_Id();
							if(Dept_Id.length()>3){Role_List = Dept_Id; }
%>
<body style="background:#CADFFF">
<form name="Pro_I_Add" action="Pro_I.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/pro_i_add.gif"></div><br><br>
	<div id="right_table_center">
		<table width="80%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
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
							<td width='11%'>ж��վ��</td>
							<td width='22%'>
								<select name="Cpm_Id" style="width:95%;height:20px" onchange="doChange(this.value)" onkeydown="changeEnter()">
								<%								
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
							<td width='11%'>ȼ������</td>
							<td width='22%'>
								<select id="Oil_CType" name="Oil_CType" style="width:95%;height:20px" onkeydown="changeEnter()">
								</select>
							</td>	
							<td>ж��޺�</td>
							<td>
								<select name="Func_Id" style="width:97%;height:18px" onchange="doSel(this.value)">
									<option value='0' > ȫ������ </option>
									<option value='1' > 1�Ŵ��� </option>
									<option value='2' > 2�Ŵ��� </option>									
								</select>
							</td>							
						</tr>						
						<tr height='30'>
							<td>��վʱ��</td>
							<td>
								<input name='BDate_A' type='text' style='width:40%;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10' onkeydown="changeEnter()">
								<select name="Hour_A" style="width:25%;height:20px" onkeydown="changeEnter()">
									<option value='00'>0��</option>
									<option value='01'>1��</option>
									<option value='02'>2��</option>
									<option value='03'>3��</option>
									<option value='04'>4��</option>
									<option value='05'>5��</option>
									<option value='06'>6��</option>
									<option value='07'>7��</option>
									<option value='08'>8��</option>
									<option value='09' selected>9��</option>
									<option value='10'>10��</option>
									<option value='11'>11��</option>
									<option value='12'>12��</option>
									<option value='13'>13��</option>
									<option value='14'>14��</option>
									<option value='15'>15��</option>
									<option value='16'>16��</option>
									<option value='17'>17��</option>
									<option value='18'>18��</option>
									<option value='19'>19��</option>
									<option value='20'>20��</option>
									<option value='21'>21��</option>
									<option value='22'>22��</option>
									<option value='23'>23��</option>
								</select>
								<select name="Minute_A" style="width:25%;height:20px" onkeydown="changeEnter()">
									<option value='05'>5��</option>
									<option value='10'>10��</option>
									<option value='15'>15��</option>
									<option value='20'>20��</option>
									<option value='25'>25��</option>
									<option value='30' selected>30��</option>
									<option value='35'>35��</option>
									<option value='40'>40��</option>
									<option value='45'>45��</option>
									<option value='50'>50��</option>
									<option value='55'>55��</option>
								</select>
							</td>	
							<td>��ʼж��ʱ��</td>
							<td>
								<input name='BDate_C' type='text' style='width:40%;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10' onkeydown="changeEnter()">
								<select name="Hour_C" style="width:25%;height:20px" onkeydown="changeEnter()">
									<option value='00'>0��</option>
									<option value='01'>1��</option>
									<option value='02'>2��</option>
									<option value='03'>3��</option>
									<option value='04'>4��</option>
									<option value='05'>5��</option>
									<option value='06'>6��</option>
									<option value='07'>7��</option>
									<option value='08'>8��</option>
									<option value='09' selected>9��</option>
									<option value='10'>10��</option>
									<option value='11'>11��</option>
									<option value='12'>12��</option>
									<option value='13'>13��</option>
									<option value='14'>14��</option>
									<option value='15'>15��</option>
									<option value='16'>16��</option>
									<option value='17'>17��</option>
									<option value='18'>18��</option>
									<option value='19'>19��</option>
									<option value='20'>20��</option>
									<option value='21'>21��</option>
									<option value='22'>22��</option>
									<option value='23'>23��</option>
								</select>
								<select name="Minute_C" style="width:25%;height:20px" onkeydown="changeEnter()">
									<option value='05'>5��</option>
									<option value='10'>10��</option>
									<option value='15'>15��</option>
									<option value='20'>20��</option>
									<option value='25'>25��</option>
									<option value='30' selected>30��</option>
									<option value='35'>35��</option>
									<option value='40'>40��</option>
									<option value='45'>45��</option>
									<option value='50'>50��</option>
									<option value='55'>55��</option>
								</select>
							</td>	
							<td>�뿪ʱ��</td>
							<td>
								<input name='BDate_D' type='text' style='width:40%;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10' onkeydown="changeEnter()">
								<select name="Hour_D" style="width:25%;height:20px" onkeydown="changeEnter()">
									<option value='00'>0��</option>
									<option value='01'>1��</option>
									<option value='02'>2��</option>
									<option value='03'>3��</option>
									<option value='04'>4��</option>
									<option value='05'>5��</option>
									<option value='06'>6��</option>
									<option value='07'>7��</option>
									<option value='08'>8��</option>
									<option value='09' selected>9��</option>
									<option value='10'>10��</option>
									<option value='11'>11��</option>
									<option value='12'>12��</option>
									<option value='13'>13��</option>
									<option value='14'>14��</option>
									<option value='15'>15��</option>
									<option value='16'>16��</option>
									<option value='17'>17��</option>
									<option value='18'>18��</option>
									<option value='19'>19��</option>
									<option value='20'>20��</option>
									<option value='21'>21��</option>
									<option value='22'>22��</option>
									<option value='23'>23��</option>
								</select>
								<select name="Minute_D" style="width:25%;height:20px" onkeydown="changeEnter()">
									<option value='05'>5��</option>
									<option value='10'>10��</option>
									<option value='15'>15��</option>
									<option value='20'>20��</option>
									<option value='25'>25��</option>
									<option value='30' selected>30��</option>
									<option value='35'>35��</option>
									<option value='40'>40��</option>
									<option value='45'>45��</option>
									<option value='50'>50��</option>
									<option value='55'>55��</option>
								</select>
							</td>	
						</tr>
						<tr height='30'>
							<td>ж������</td>
							<td align='left'>
								<input type='text' name='Order_Id' style='width:97%;height:18px;' value='' maxlength='20' >	
							</td>	
							<td>���ʱ��浥</td>
							<td align='left'>
								<input type='text' name='Temper_Report' style='width:97%;height:18px;' value='' maxlength='20' >	
							</td>	
							<td width='11%'>��ҵ��Ա</td>
							<td width='22%' align='left'>
								<input type='text' name='Worker' style='width:97%;height:18px;' value='' maxlength='20' >	
							</td>	
						</tr>
					</table>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">	
						<tr>
							<td rowspan='8' > LNG�۳� </td>
						</tr>
						<tr>	
							<td width="14%">���䳵��</td>
							<td width="30%" align='left'>
								<select name="Car_Id" style="width:46%;height:20px" onkeydown="changeEnter()">
									<option value='-1'>=========�㶫ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-' selected>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>
									<option value='��T-'>��T-</option>
									<option value='��U-'>��U-</option>
									<option value='��V-'>��V-</option>
									<option value='-1'>=========�ӱ�ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>
									<option value='��T-'>��T-</option>
									<option value='-1'>=========����ʡ(ԥ)=========</option>
									<option value='ԥA-'>ԥA-</option>
									<option value='ԥB-'>ԥB-</option>
									<option value='ԥC-'>ԥC-</option>
									<option value='ԥD-'>ԥD-</option>
									<option value='ԥE-'>ԥE-</option>
									<option value='ԥF-'>ԥF-</option>
									<option value='ԥG-'>ԥG-</option>
									<option value='ԥH-'>ԥH-</option>
									<option value='ԥJ-'>ԥJ-</option>
									<option value='ԥK-'>ԥK-</option>
									<option value='ԥL-'>ԥL-</option>
									<option value='ԥM-'>ԥM-</option>
									<option value='ԥN-'>ԥN-</option>
									<option value='ԥP-'>ԥP-</option>
									<option value='ԥQ-'>ԥQ-</option>
									<option value='ԥR-'>ԥR-</option>
									<option value='ԥS-'>ԥS-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>								
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>=========������ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='-1'>=========ɽ��ʡ(³)=========</option>
									<option value='³A-'>³A-</option>
									<option value='³B-'>³B-</option>
									<option value='³C-'>³C-</option>
									<option value='³D-'>³D-</option>
									<option value='³E-'>³E-</option>
									<option value='³F-'>³F-</option>
									<option value='³G-'>³G-</option>
									<option value='³H-'>³H-</option>
									<option value='³J-'>³J-</option>
									<option value='³K-'>³K-</option>
									<option value='³L-'>³L-</option>
									<option value='³M-'>³M-</option>
									<option value='³N-'>³N-</option>
									<option value='³P-'>³P-</option>
									<option value='³Q-'>³Q-</option>
									<option value='³R-'>³R-</option>
									<option value='³S-'>³S-</option>
									<option value='-1'>=========�½�ά���(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>=========�㽭ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='-1'>=========����׳��(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>=========ɽ��ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='-1'>=========���ɹ�(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='-1'>=========�Ĵ�ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>
									<option value='��T-'>��T-</option>
									<option value='��U-'>��U-</option>
									<option value='��V-'>��V-</option>
									<option value='��W-'>��W-</option>
									<option value='-1'>=========�ຣʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='-1'>=========����(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='-1'>=========���Ļ���(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='-1'>=========������(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='-1'>=========������(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='-1'>=========�����(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='-1'>=========�Ϻ���(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>				
								</select>
								<input type='text' name='Car_Id_Num' style='width:46%;height:16px;' value='' maxlength='5' onkeydown="changeEnter()">
							</td>
							<td width="15%">ж��ǰ���</td>
							<td width="30%" align='left'>
								<input type='text' name='Pre_Check' style='width:85%;height:18px;' value='' maxlength='20' >&nbsp;&nbsp;
							</td>
						</tr>
						<tr>							
							<td>�ҳ�����</td>
							<td align='left'>
								<select name="Trailer_No" style="width:46%;height:20px" onkeydown="changeEnter()">
									<option value='-1'>=========�㶫ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-' selected>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>
									<option value='��T-'>��T-</option>
									<option value='��U-'>��U-</option>
									<option value='��V-'>��V-</option>
									<option value='-1'>=========�ӱ�ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>
									<option value='��T-'>��T-</option>
									<option value='-1'>=========����ʡ(ԥ)=========</option>
									<option value='ԥA-'>ԥA-</option>
									<option value='ԥB-'>ԥB-</option>
									<option value='ԥC-'>ԥC-</option>
									<option value='ԥD-'>ԥD-</option>
									<option value='ԥE-'>ԥE-</option>
									<option value='ԥF-'>ԥF-</option>
									<option value='ԥG-'>ԥG-</option>
									<option value='ԥH-'>ԥH-</option>
									<option value='ԥJ-'>ԥJ-</option>
									<option value='ԥK-'>ԥK-</option>
									<option value='ԥL-'>ԥL-</option>
									<option value='ԥM-'>ԥM-</option>
									<option value='ԥN-'>ԥN-</option>
									<option value='ԥP-'>ԥP-</option>
									<option value='ԥQ-'>ԥQ-</option>
									<option value='ԥR-'>ԥR-</option>
									<option value='ԥS-'>ԥS-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>								
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>=========������ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='-1'>=========ɽ��ʡ(³)=========</option>
									<option value='³A-'>³A-</option>
									<option value='³B-'>³B-</option>
									<option value='³C-'>³C-</option>
									<option value='³D-'>³D-</option>
									<option value='³E-'>³E-</option>
									<option value='³F-'>³F-</option>
									<option value='³G-'>³G-</option>
									<option value='³H-'>³H-</option>
									<option value='³J-'>³J-</option>
									<option value='³K-'>³K-</option>
									<option value='³L-'>³L-</option>
									<option value='³M-'>³M-</option>
									<option value='³N-'>³N-</option>
									<option value='³P-'>³P-</option>
									<option value='³Q-'>³Q-</option>
									<option value='³R-'>³R-</option>
									<option value='³S-'>³S-</option>
									<option value='-1'>=========�½�ά���(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>=========�㽭ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='-1'>=========����׳��(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>=========ɽ��ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='-1'>=========���ɹ�(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='-1'>=========�Ĵ�ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>
									<option value='��T-'>��T-</option>
									<option value='��U-'>��U-</option>
									<option value='��V-'>��V-</option>
									<option value='��W-'>��W-</option>
									<option value='-1'>=========�ຣʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='-1'>=========����(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='-1'>=========����ʡ(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='-1'>=========���Ļ���(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='-1'>=========������(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='-1'>=========������(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='-1'>=========�����(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='-1'>=========�Ϻ���(��)=========</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>						
								</select>
								<input type='text' name='Trailer_No_Num' style='width:46%;height:16px;' value='' maxlength='5' onkeydown="changeEnter()">
							</td>
							<td>ж�����̼��</td>
							<td align='left'>
								<input type='text' name='Pro_Check' style='width:85%;height:18px;' value='' maxlength='20' >&nbsp;&nbsp;
							</td>
						</tr>
						<tr>							
							<td>�۳�˾��</td>
							<td align='left'>
								<input type='text' name='Car_Owner' style='width:85%;height:18px;' value='' maxlength='20' >&nbsp;&nbsp;
							</td>
							<td>ж������</td>
							<td align='left'>
								<input type='text' name='Lat_Check' style='width:85%;height:18px;' value='' maxlength='20' >&nbsp;&nbsp;
							</td>
						</tr>
						<tr>							
							<td>ж��ǰ����</td>
							<td align='left'>
								<input type='text' name='Pre_Weight' style='width:85%;height:18px;' value='' maxlength='20' >kg
							</td>
							<td>װ��ë��</td>
							<td align='left'>
								<input type='text' name='Gross_Weight' style='width:85%;height:18px;' value='' maxlength='20' >kg
							</td>
						</tr>
						<tr>							
							<td>ж��������</td>
							<td align='left'>
								<input type='text' name='Lat_Weight' style='width:85%;height:18px;' value='' maxlength='20'onblur="Sum3(this.value)" >kg
							</td>
							<td>װ��Ƥ��</td>
							<td align='left'>
								<input type='text' name='Tear_Weight' style='width:85%;height:18px;' value='' maxlength='20' onblur="Sum1(this.value)">kg
							</td>
						</tr>
						<tr>							
							<td>ж����</td>
							<td align='left'>
								<input type='text' name='Value' style='width:85%;height:18px;' value='' maxlength='20' readonly>kg
							</td>
							<td>װ������</td>
							<td align='left'>
								<input type='text' name='Ture_Weight' style='width:85%;height:18px;' value='' maxlength='20' readonly>kg
							</td>
						</tr>
						<tr>							
							<td>������λ</td>
							<td align='left'>
								<input type='text' name='Forward_Unit' style='width:85%;height:18px;' value='' maxlength='20' >&nbsp;&nbsp;
							</td>
							<td>���˵�λ</td>
							<td align='left'>
								<input type='text' name='Car_Corp' style='width:85%;height:18px;' value='' maxlength='20' >&nbsp;&nbsp;
							</td>
						</tr>
					</table>					
					<table id='table_One' width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff" style="display:''">	
						<tr>
							<td rowspan='4'>1�Ź�</td>								
						</tr>
						<tr>
							<td width="11%">ж��ǰ����</td>
							<td width="18%" align='left'>
								<input type='text' name='Pre_Tank_V' style='width:85%;height:18px;' value='' maxlength='20' >L
							</td>
							<td width="11%">ж�������</td>
							<td width="19%" align='left'>
								<input type='text' name='Lat_Tank_V' style='width:85%;height:18px;' value='' maxlength='20' onblur="Sum2(this.value)" >L
							</td>
							<td width="11%">ж���ݻ�</td>
							<td width="19%" align='left'>
								<input type='text' name='Unload' style='width:85%;height:18px;' value='' maxlength='20' readonly>L
							</td>
						</tr> 
						<tr>
							<td>ж��ǰ�¶�</td>
							<td colspan='2' align='left'>
								<input type='text' name='Pre_Temper' style='width:85%;height:18px;' value='' maxlength='20' >&nbsp;&nbsp;&nbsp;��
							</td>
							<td>ж�����¶�</td>
							<td colspan='2' align='left'>
								<input type='text' name='Lat_Temper' style='width:85%;height:18px;' value='' maxlength='20' >&nbsp;&nbsp;&nbsp;��
							</td>	
						</tr>
						<tr>
							<td>ж��ǰѹ��</td>
							<td colspan='2' align='left'>
								<input type='text' name='Pre_Press' style='width:85%;height:18px;' value='' maxlength='20' >Mpa
							</td>
							<td>ж����ѹ��</td>
							<td colspan='2' align='left'>
								<input type='text' name='Lat_Press' style='width:85%;height:18px;' value='' maxlength='20' >Mpa
							</td>							
						</tr>
						<tr  id='ME' style="display:none">
							<td>��ע:</td>	
							<td colspan='6'  align='left'>
								<textarea name='Memo1' rows='2' cols='95' maxlength=128></textarea>
							</td>	
						</tr>
					</table>
					<table id='table_Two' width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff" style="display:''">	
						<tr>
							<td rowspan='4'>2�Ź�</td>								
						</tr>
						<tr>
							<td width="11%">ж��ǰ����</td>
							<td width="18%" align='left'>
								<input type='text' name='Pre_Tank_VT' style='width:85%;height:18px;' value='' maxlength='20' >L
							</td>
							<td width="11%">ж�������</td>
							<td width="19%" align='left'>
								<input type='text' name='Lat_Tank_VT' style='width:85%;height:18px;' value='' maxlength='20' onblur="Sum4(this.value)">L
							</td>
							<td width="11%">ж���ݻ�</td>
							<td width="19%" align='left'>
								<input type='text' name='UnloadT' style='width:85%;height:18px;' value='' maxlength='20' readonly>L
							</td>
						</tr> 
						<tr>
							<td>ж��ǰ�¶�</td>
							<td colspan='2' align='left'>
								<input type='text' name='Pre_TemperT' style='width:85%;height:18px;' value='' maxlength='20' >&nbsp;&nbsp;&nbsp;��
							</td>
							<td>ж�����¶�</td>
							<td colspan='2' align='left'>
								<input type='text' name='Lat_TemperT' style='width:85%;height:18px;' value='' maxlength='20' >&nbsp;&nbsp;&nbsp;��
							</td>	
						</tr>
						<tr>
							<td>ж��ǰѹ��</td>
							<td colspan='2' align='left'>
								<input type='text' name='Pre_PressT' style='width:85%;height:18px;' value='' maxlength='20' >Mpa
							</td>
							<td>ж����ѹ��</td>
							<td colspan='2' align='left'>
								<input type='text' name='Lat_PressT' style='width:85%;height:18px;' value='' maxlength='20' >Mpa
							</td>							
						</tr>
						<tr>
							<td>��ע:</td>	
							<td colspan='6' align='left'>
								<textarea name='Memo' rows='2' cols='95' maxlength=128></textarea>
							</td>	
						</tr>
					</table>		
				</td>						
			</tr>	
		</table>
	</div>
</div>
<input name="Order_Value" type="hidden" value="0" />
<input name="Tank_No" type="hidden" value="0" />
</form>
</body>
<SCRIPT LANGUAGE=javascript>

function doNO()
{
	location = "Pro_I.jsp?Sid=<%=Sid%>";
}

function doChange(pId)
{
	//��ɾ��
	var length = document.getElementById('Oil_CType').length;
	for(var i=0; i<length; i++)
	{
		document.getElementById('Oil_CType').remove(0);
	}
	
	//�����
	if(pId.length > 0)
	{
		<%
		if(null != Pro_I_All)
		{
			Iterator bussiter = Pro_I_All.iterator();
			while(bussiter.hasNext())
			{
				ProRBean bussBean = (ProRBean)bussiter.next();
				String buss_cpmid = bussBean.getCpm_Id();
				String buss_oilid = bussBean.getOil_CType();
				String buss_oilname = "��";
				if(Oil_Info.trim().length() > 0)
				{
				  String[] List = Oil_Info.split(";");
				  for(int i=0; i<List.length && List[i].length()>0; i++)
				  {
				  	String[] subList = List[i].split(",");
				  	if(buss_oilid.equals(subList[0]))
				  	{
				  		buss_oilname = subList[1];
				  		break;
				  	}
				  }
				}
		%>
				
					var objOption = document.createElement('OPTION');
					objOption.value = '<%=buss_oilid%>';
					objOption.text  = '<%=buss_oilid%>' + '|' + '<%=buss_oilname%>';
					document.getElementById('Oil_CType').add(objOption);
				
		<%
			}
		}
		%>
	}
}
doChange(Pro_I_Add.Cpm_Id.value);

var reqAdd = null;
function doAdd() 
{
  if(Pro_I_Add.Cpm_Id.value.length < 1)
  {
  	alert('��ѡ��ж��վ��!');
  	return;
  }
  if(Pro_I_Add.Oil_CType.value.length < 1)
  {
  	alert('��ѡ��ȼ������!');
  	return;
  }
  if(Pro_I_Add.Tank_No.value.length < 1)
  {
  	alert('��ѡ�����ޱ��');
  	return;
  }
  if(Pro_I_Add.Order_Id.value.Trim().length < 1)
  {
  	alert('����д�������!');
  	return;
  }

  if(Pro_I_Add.BDate_C.value.length < 1)
  {
  	alert('��ѡ��ж��ʱ��!');
  	return;
  }
 /** var TDay = new Date().format("yyyy-MM-dd");
	if(Pro_I_Add.BDate_C.value != TDay)
	{
		alert('ֻ�ɼ��˵�����ˮ!');
		return;
	}
 			**/
	if(Pro_I_Add.Car_Id.value.length < 1 || Pro_I_Add.Car_Id.value == '-1')
  {
  	alert('��ѡ�����䳵�����ڵ�!');
  	return;
  }
  if(Pro_I_Add.Car_Id_Num.value.Trim().length != 5)
  {
  	alert('����β����д����!');
  	return;
  }
  if(Pro_I_Add.Trailer_No.value.length < 1 || Pro_I_Add.Trailer_No.value == '-1')
  {
  	alert('��ѡ�����䳵�����ڵ�!');
  	return;
  }
  
  if(Pro_I_Add.Trailer_No_Num.value.Trim().length != 5)
  {
  	alert('�ҳ�����β����д����!');
  	return;
  }
  if(Pro_I_Add.Car_Owner.value.Trim().length < 1)
  {
  	alert('����дѺ����Ա����!');
  	return;
  }
  if(Pro_I_Add.Car_Corp.value.Trim().length < 1)
  {
  	alert('����д���˵�λ����!');
  	return;
  }
  if(Pro_I_Add.Worker.value.Trim().length < 1)
  {
  	alert('����д��ҵ��Ա����!');
  	return;
  }

  if(Pro_I_Add.Tear_Weight.value.Trim().length < 1)
  {
  	alert('����дƤ������!');
  	return;
  }
  if(Pro_I_Add.Gross_Weight.value.Trim().length < 1)
  {
  	alert('����дë������!');
  	return;
  }
  if(Pro_I_Add.Ture_Weight.value.Trim().length < 1)
  {
  	alert('����д��������!');
  	return;
  }
  
  if(Pro_I_Add.Func_Id.value == 1)
  {
  	Pro_I_Add.Memo.value = Pro_I_Add.Memo1.value;
  	
  	} 
  if(confirm("��Ϣ����,ȷ���ύ?"))
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
	
						Pro_I_Add.Order_Value.value = '1';
						Pro_I_Add.Value.value = '';
						Pro_I_Add.Gross_Weight.value = '';
						Pro_I_Add.Tear_Weight.value = '';
						Pro_I_Add.Ture_Weight.value = '';
						Pro_I_Add.Pre_Tank_V.value = '';
						Pro_I_Add.Lat_Tank_V.value = '';
						Pro_I_Add.Pre_Temper.value = '';
						Pro_I_Add.Lat_Temper.value = '';
						Pro_I_Add.Pre_Press.value = '';
						Pro_I_Add.Lat_Press.value = '';
						Pro_I_Add.Pre_Weight.value = '';
						Pro_I_Add.Lat_Weight.value = '';
						Pro_I_Add.Unload.value = '';
						
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
		var url = 'Pro_I_Add.do?Cmd=10&Sid=<%=Sid%>&Cpm_Id='+Pro_I_Add.Cpm_Id.value+'&Oil_CType='+Pro_I_Add.Oil_CType.value+'&Car_Id='+Pro_I_Add.Car_Id.value+Pro_I_Add.Car_Id_Num.value+'&Car_Owner='+Pro_I_Add.Car_Owner.value+'&Car_Corp='+Pro_I_Add.Car_Corp.value+'&CTime='+Pro_I_Add.BDate_C.value+' '+Pro_I_Add.Hour_C.value+':'+Pro_I_Add.Minute_C.value+':00'+'&Value='+Pro_I_Add.Value.value.Trim()+'&Memo='+Pro_I_Add.Memo.value+'&Order_Id='+Pro_I_Add.Order_Id.value+'&Order_Value=1&Worker='+Pro_I_Add.Worker.value+'&Pre_Check='+Pro_I_Add.Pre_Check.value+'&Pro_Check='+Pro_I_Add.Pro_Check.value+'&Lat_Check='+Pro_I_Add.Lat_Check.value+'&Pre_Tank_V='+Pro_I_Add.Pre_Tank_V.value+'&Lat_Tank_V='+Pro_I_Add.Lat_Tank_V.value+'&Pre_Temper='+Pro_I_Add.Pre_Temper.value+'&Lat_Temper='+Pro_I_Add.Lat_Temper.value+'&Pre_Press='+Pro_I_Add.Pre_Press.value+'&Lat_Press='+Pro_I_Add.Lat_Press.value+'&Pre_Weight='+Pro_I_Add.Pre_Weight.value+'&Lat_Weight='+Pro_I_Add.Lat_Weight.value+'&Gross_Weight='+Pro_I_Add.Gross_Weight.value+'&Tear_Weight='+Pro_I_Add.Tear_Weight.value+'&Ture_Weight='+Pro_I_Add.Ture_Weight.value+'&Trailer_No='+Pro_I_Add.Trailer_No.value+Pro_I_Add.Trailer_No_Num.value+'&Forward_Unit='+Pro_I_Add.Forward_Unit.value+'&Temper_Report='+Pro_I_Add.Temper_Report.value+'&Tank_No='+Pro_I_Add.Tank_No.value+'&Unload='+Pro_I_Add.Unload.value+'&Pre_Tank_VT='+Pro_I_Add.Pre_Tank_VT.value+'&Lat_Tank_VT='+Pro_I_Add.Lat_Tank_VT.value+'&Pre_TemperT='+Pro_I_Add.Pre_TemperT.value+'&Lat_TemperT='+Pro_I_Add.Lat_TemperT.value+'&Pre_PressT='+Pro_I_Add.Pre_PressT.value+'&Lat_PressT='+Pro_I_Add.Lat_PressT.value+'&UnloadT='+Pro_I_Add.UnloadT.value+'&Arrive_Time='+Pro_I_Add.BDate_A.value+' '+Pro_I_Add.Hour_A.value+':'+Pro_I_Add.Minute_A.value+':00'+'&Depart_Time='+Pro_I_Add.BDate_D.value+' '+Pro_I_Add.Hour_D.value+':'+Pro_I_Add.Minute_D.value+':00'+'&Func_Id='+Pro_I_Add.Func_Id.value+'&Operator=<%=Operator%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>&CurrPage=<%=currStatus.getCurrPage()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)+" 00:00:00"%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)+" 23:59:59"%>&currtime='+new Date();
		reqAdd.open("post",url,true);
		reqAdd.send(null);
		return true;
  }
}

function Sum3()
{ 
	if(Pro_I_Add.Pre_Weight.value.length>0 && Pro_I_Add.Lat_Weight.value.length>0)
	{		
		var va = Pro_I_Add.Pre_Weight.value;
		var vb = Pro_I_Add.Lat_Weight.value;		
		Pro_I_Add.Value.value = Math.round((va - vb)*100)/100;		
	}
}

	function Sum2()
{ 
	if(Pro_I_Add.Pre_Tank_V.value.length>0 && Pro_I_Add.Lat_Tank_V.value.length>0)
	{		
		var va = Pro_I_Add.Lat_Tank_V.value;
		var vb = Pro_I_Add.Pre_Tank_V.value;		
		Pro_I_Add.Unload.value =  Math.round((va - vb)*100)/100;
		
	}
}
	function Sum4()
{ 
	if(Pro_I_Add.Pre_Tank_VT.value.length>0 && Pro_I_Add.Lat_Tank_VT.value.length>0)
	{		
		var vaT = Pro_I_Add.Lat_Tank_VT.value;
		var vbT = Pro_I_Add.Pre_Tank_VT.value;		
		Pro_I_Add.UnloadT.value =  Math.round((vaT - vbT)*100)/100;
		
	}
}
	function Sum1()
{ 
	if(Pro_I_Add.Gross_Weight.value.length>0 && Pro_I_Add.Tear_Weight.value.length>0)
	{		
		var va = Pro_I_Add.Gross_Weight.value;
		var vb = Pro_I_Add.Tear_Weight.value;		
		Pro_I_Add.Ture_Weight.value =  Math.round((va - vb)*100)/100;
		
	}
	
}

function changeEnter()
{    
	if(event.keyCode==13)
	{
		event.keyCode=9;
	} 	
} 
function doSel(cnt)
{
	switch(parseInt(cnt))
	{
		case 0:
			document.getElementById('table_One').style.display = '';  
			document.getElementById('table_Two').style.display = ''; 
			document.getElementById('ME').style.display = 'none';
			break;
		case 1:
			document.getElementById('table_One').style.display = '';  
			document.getElementById('table_Two').style.display = 'none';
			document.getElementById('ME').style.display = '';
			break;
			
			case 2:
			document.getElementById('table_One').style.display = 'none';  
			document.getElementById('table_Two').style.display = '';
			document.getElementById('ME').style.display = 'none';
			break;
			
		
	}
}

</SCRIPT>
</html>