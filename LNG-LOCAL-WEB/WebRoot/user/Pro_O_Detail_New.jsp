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
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String BDate = CommUtil.getDate();
	
	ArrayList Pro_R_Buss = (ArrayList)session.getAttribute("Pro_R_Buss_" + Sid);
	CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Oil_Info = "";
	String Car_Info = "";
	if(null != Corp_Info)
	{
		Oil_Info = Corp_Info.getOil_Info();
		Car_Info = Corp_Info.getCar_Info();
		if(null == Oil_Info){Oil_Info = "";}
		if(null == Car_Info){Car_Info = "";}
	}
	
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId = UserInfo.getManage_Role();
  
  
  ArrayList Pro_O = (ArrayList)session.getAttribute("Pro_O_" + Sid);
  ArrayList Pro_O_Corp = (ArrayList)session.getAttribute("Pro_O_Corp_" + Sid);
  String SN = request.getParameter("SN");
	String Cpm_Id  = "";
	String Cpm_Name = "";
	String Oil_CType = "";	
	String Oil_CName = "��";
	String CTime = "";
	String Memo = "";
	
	//��ע��Ϣ
	String Value = "";
	String Value_Gas = "";
	String Price = "";
  String Amt = "";
	String Worker = "";
	
	//�ͻ���Ϣ
	String Unq_Flag = "";
	String Unq_Str = "";
	String Car_More = "";
	String Car_CType = "";
	String Car_Owner = "";
	String Car_BH = "";
	String Car_DW = "";
	String DW_ID  = "";
	
	//�����Ϣ
	String Status = "";
	String Checker_Name = "";
	
	//����
	String Fill_Number = "";
	
	
  if(Pro_O != null)
	{
		Iterator iterator = Pro_O.iterator();
		while(iterator.hasNext())
		{
			ProOBean Bean = (ProOBean)iterator.next();
			if(Bean.getSN().equals(SN))			
			{
			
			
				Cpm_Id    = Bean.getCpm_Id();
				
				if( null != User_Device_Detail)
						{
							Iterator Uiterator = User_Device_Detail.iterator();
							while(Uiterator.hasNext())
							{
								DeviceDetailBean sBean = (DeviceDetailBean)Uiterator.next();
								if(sBean.getId().equals(Cpm_Id))
								{
									Cpm_Name = sBean.getBrief();
								}
							}
						}

				
				Oil_CType = Bean.getOil_CType();
				
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
				
				CTime     = Bean.getCTime();
				Memo      = Bean.getMemo();
				
				
				Value     = Bean.getValue();
				Value_Gas = Bean.getValue_Gas();
				Price     = Bean.getPrice();
			  Amt       = Bean.getAmt();
				Worker    = Bean.getWorker();
				Cpm_Id    = Bean.getCpm_Id();
				
				Unq_Flag  = Bean.getUnq_Flag();
				Unq_Str   = Bean.getUnq_Str();
				Car_More  = Bean.getCar_More();
				Car_CType = Bean.getCar_CType();
				Car_Owner = Bean.getCar_Owner();
				Car_BH 	  = Bean.getCar_BH();
				Car_DW 	  = Bean.getCar_DW();
				DW_ID     = Bean.getDW_ID();
				
				Status        = Bean.getStatus();
				Checker_Name  = Bean.getChecker_Name();
				
				
				Fill_Number   = Bean.getFill_Number();
			}
		}
 	}
  
%>
<body style="background:#CADFFF">
<form name="Pro_O_Detail" action="Pro_O_Add.do" method="post" target="mFrame">
		<table width="75%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">			
			<tr height='30'>
				<td width='100%' align='center'>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">			         
						<tr height='30'>
						 	<td width='25%' align='center'>��עʱ��</td>
						 	<td width='75%' align='left'>
						 		<input name='BDate' type='text' style='width:50%;height:20px;' value='<%=CTime.substring(0,10)%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
								<select name="Hour" style="width:20%;height:20px">
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
								<select name="Minute" style="width:25%;height:20px">
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
							<td width='25%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='75%' align='left'>
								<input type="text"  name='Fill_Number' style='width:280px;height:18px;' value='<%= Fill_Number%>' maxlength='10' >							
								</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>��ע����</td>
							<td width='75%' align='left'>
								<input type="text"  name='Value' style='width:280px;height:18px;' value='<%= Value%>' maxlength='10' >						
								</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'><%=Unq_Flag.equals("0")?"IC����":"���ƺ�"%></td>
							<td width='75%' align='left'>
								<input type="text"  name='Unq_Str' style='width:280px;height:18px;' value='<%= Unq_Str%>' maxlength='10' onblur='doDown(this.value)'  >									
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>��������</td>
							<td id='T_Car' width='75%' align='left'>			
	<%
							String str1 = "";
							String str_ctype = "";
							if(null != Pro_O_Corp)
							{
								 Iterator iter = Pro_O_Corp.iterator();
								while(iter.hasNext())
								{
									CorpInfoBean corpBean = (CorpInfoBean)iter.next();	
									String[] strs = corpBean.getCar_Info().split(";");
									for(int j =0;j<strs.length&&strs[j].length()>0;j++)
									{
										String[] substr = strs[j].split(",");
										if(Car_CType.equals(substr[0]))
										{
											str1 = substr[1];
											str_ctype = substr[0];
											break;
										}
									}
								}
							}	
	%>																																										
								&nbsp;<%= str1%></td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>����˾��</td>
							<td id='T_Owner' width='75%' align='left'>&nbsp;<%= Car_Owner%></td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>����ƿ��</td>
							<td id='T_BH' width='75%' align='left'>&nbsp;<%= Car_BH%></td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>������λ</td>
							<td  id='T_DW' width='75%' align='left'>&nbsp;<%= Car_DW%></td>
						</tr>		
					</table>
				</td>
			</tr>
			<tr><td align='center'>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>	
			</td></tr>
		</table>
<input name="SN" type="hidden" value="<%=SN%>" />
<input name="Cmd"      type="hidden" value="12">
<input name="Sid"      type="hidden" value="<%=Sid%>">
<input name="Cpm_Id"      type="hidden" value="<%=Cpm_Id%>">

<input name="CTime"      type="hidden" value="">
<input name="BTime"      type="hidden" value="<%=CTime%>">
<input name="ETime"      type="hidden" value="<%=CTime%>">
<input name="Func_Corp_Id" 		type="hidden" value="<%=Oil_CType%>">
<input name="Car_CType" 			type="hidden" value="<%=str_ctype%>">
<input name="Car_CType_Name" 	type="hidden" value="">
<input name="Car_Owner" 			type="hidden" value="<%= Car_Owner%>">
<input name="Car_BH" 					type="hidden" value="<%= Car_BH%>">
<input name="Car_DW" 					type="hidden" value="<%= Car_DW%>">
<input name="DW_ID" 					type="hidden" value="<%=DW_ID%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doNO()
{
	location = "Pro_O.jsp?Sid=<%=Sid%>";
	
}
function doEdit()
{		
		Pro_O_Detail.CTime.value = Pro_O_Detail.BDate.value+' '+Pro_O_Detail.Hour.value+':'+Pro_O_Detail.Minute.value+':00';
		Pro_O_Detail.submit();
}

function doDown(cId)
{ 
	if(window.XMLHttpRequest)
	  {
			reqAdd = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqAdd = new ActiveXObject("Microsoft.XMLHTTP");
		}		
	reqAdd.onreadystatechange=function()
	{
					if(reqAdd.readyState == 4)
					{ 
						if(reqAdd.status == 200)
						{
							var txt = reqAdd.responseText;
						
							if(txt.length >5)
							{
								var str = txt.split(',');		
								Pro_O_Detail.DW_ID.value=str[0];																					
					  		Pro_O_Detail.Car_Owner.value=str[3];
								Pro_O_Detail.Car_BH.value=str[4];
								Pro_O_Detail.Car_DW.value=str[6];								
								Pro_O_Detail.Car_CType.value=str[8];
								Pro_O_Detail.Car_CType_Name.value=str[9];
								document.getElementById('T_Owner').innerHTML=str[3];
								document.getElementById('T_BH').innerHTML=str[4];
								document.getElementById('T_DW').innerHTML=str[6];
								document.getElementById('T_Car').innerHTML=str[9];
							}	else
							{
								Pro_O_Detail.DW_ID.value='������';																					
					  		Pro_O_Detail.Car_Owner.value='������';
								Pro_O_Detail.Car_BH.value='������';
								Pro_O_Detail.Car_DW.value='������';								
								Pro_O_Detail.Car_CType.value='������';
								Pro_O_Detail.Car_CType_Name.value='������';
								}		
						}else
						{
						alert("��������");
						}
					}
	};
	var turl ="Pro_Id_Car.do?Id="+Pro_O_Detail.Unq_Str.value+"&Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>";
	reqAdd.open("post",turl,true);
	reqAdd.send(null);
	return true;
	Pro_O_Add.Value.focus(); 
}
</SCRIPT>
</html>