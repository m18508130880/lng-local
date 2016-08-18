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
<script type="text/javascript" src="../skin/js/jquery.js"></script>
<style> 
	#button_one
	{
	background:url(../skin/images/anniu.jpg);
	height: 20px;
	width: 50px;
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 0px;
	border-left-width: 0px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	cursor:pointer;
	}
</style> 

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
  ArrayList Pro_R_Type = (ArrayList)session.getAttribute("Pro_R_Type_" + Sid);
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
								
	ArrayList Ccm_Id = (ArrayList)session.getAttribute("Ccm_Id_" + Sid);
%>
<body style="background:#CADFFF" onload ="setfocus()">
<form name="Pro_O_Add" action="Pro_O_Add.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/pro_o_add.gif"></div><br><br>
	<div id="right_table_center">
		<table width="50%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">			
			<tr height='30'>
				<td width='100%' align='center'>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
						<tr height='30'>
							<td width='25%' align='center' >��עվ��</td>
							<td width='75%' align='left' colspan='2'>							
								<select name="Cpm_Id" style="width:282px;height:20px" onchange="doChange(this.value)">
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
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>ȼ������</td>
							<td width='75%' align='left' colspan='2'>
								<select id='Oil_CType' name='Oil_CType' style="width:282px;height:20px" onchange="toChange(this.value)" >
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>��עʱ��</td>
							<td width='75%' align='left' colspan='2'>
								<input name='BDate' type='text' style='width:100px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
								<select name="Hour" style="width:85px;height:20px">
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
								<select name="Minute" style="width:85px;height:20px">
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
							<td width='25%' align='center'>��������</td>
							<td width='75%' align='left' colspan='2'>
								<input type='radio' id='radio0' name='radio0' value='0' onclick="doRadio('0')">IC����
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type='radio' id='radio1' name='radio1' value='1' onclick="doRadio('1')">���ƺ�
							</td>
						</tr>			
						<tr height='30'>
							<td width='25%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='75%' align='left' colspan='2'>
								<input type="text"  name='Fill_Number' style='width:280px;height:18px;' value='' maxlength='10' onkeydown="changeEnter()">								
							</td>
							<tr>	
							<tr height='30'>
							<td  width='25%' align='center'>���ƺ�</td>
							<td id='T_Unq_Str' width='75%' align='left' onkeydown="changeEnter()" colspan='2'>&nbsp;</td>
						</tr>
						</tr>
							<tr height='30'>
							<td width='25%' align='center'>��ע����</td>
							<td width='45%' align='left' >
								<input type="text"  name='Value' style='width:280px;height:18px;' value='' maxlength='10' onkeydown="changeEnter()" onblur="Sum(this.value)"  >								
							</td>
							<td id='Unit' width='30%' align='left'>kg</td>
						</tr>	
						<tr height='30' style="display: none">
							<td width='25%' align='center'>��ע����</td>
							<td id='T_Price' width='75%' align='left' colspan='2'>
								<input name='Price' type="hidden" value='10' maxlength='10' > 
								10 Ԫ/L �� Ԫ/kg
							</td>
						</tr>					
						<tr height='30' style="display: none">
							<td width='25%' align='center'>��ע���</td>
							<td id='T_Amt_V' width='75%' align='left' colspan='2'>&nbsp;</td>
						</tr>																																																	
						<tr height='30' style="display: none">
							<td width='25%' align='center'>��������</td>
							<td id='T_Car' width='75%' align='left' colspan='2'> &nbsp;</td>
						</tr>
						<tr height='30' style="display: none">
							<td width='25%' align='center'>����˾��</td>
							<td id='T_Owner' width='75%' align='left' colspan='2'>&nbsp;</td>
						</tr>
						<tr height='30' style="display: none">
							<td width='25%' align='center'>����ƿ��</td>
							<td id='T_BH' width='75%' align='left' colspan='2'>&nbsp;</td>
						</tr>
						<tr height='30'style="display: none" >
							<td width='25%' align='center'>������λ</td>
							<td id='T_DW' width='75%' align='left' colspan='2'>&nbsp;</td>
						</tr>		
						<tr height='30' style="display: none">
							<td width='25%' align='center'>��ע��Ա</td>
							<td width='75%' align='left' colspan='2'>վ����Ա</td>
						</tr>																										
					</table>
				</td>
			</tr>
			<tr height='30'>
				<td width='100%' align='right'>				
					<!--<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doAdd()'>					
					<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>-->
					<input id='button_one' type="button" value="�ύ" onClick='doAdd()' >
				</td>
			</tr>		
		</table>
	</div>
</div>

<input name="Amt_V" 					type="hidden" value="" >
<input name="Car_CType" 			type="hidden" value="">
<input name="Car_CType_Name" 	type="hidden" value="">
<input name="Car_Owner" 			type="hidden" value="">
<input name="Car_BH" 					type="hidden" value="">
<input name="Car_DW" 					type="hidden" value="">
<input name="DW_ID" 					type="hidden" value="">
<input name="Worker" 					type="hidden" value="վ����Ա">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
			
function doNO()
{
	location = "Pro_O.jsp?Sid=<%=Sid%>";
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
		if(null != Pro_R_Type)
		{
			Iterator bussiter = Pro_R_Type.iterator();
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
doChange(Pro_O_Add.Cpm_Id.value);

function doRadio(pIndex)
{
	switch(parseInt(pIndex))
	{
		case 0:
				document.getElementById('radio0').checked = true;
				document.getElementById('radio1').checked = false;
				document.getElementById('T_Unq_Str').innerHTML = "<input type='text' name='Unq_Str' style='width:280px;height:16px;' value='' maxlength='20'>";
			break;
		case 1:
				document.getElementById('radio0').checked = false;
				document.getElementById('radio1').checked = true;
				document.getElementById('T_Unq_Str').innerHTML = "<select name='Unq_Str_Car' style='width:193px;height:20px'> <option value='��C-'>��C-</option>"
								<%
									if(null != Ccm_Id)
									{
										Iterator it = Ccm_Id.iterator();
										while(it.hasNext())
										{
										CcmInfoBean ccBean = (CcmInfoBean)it.next();
										if( ccBean.getId().equals("��C-") == false )
										{
								%>			
									 + "  <option value='<%=ccBean.getId()%>'><%=ccBean.getId()%></option>"			
									
								<%			
									}
										}										
									}							
								%>																																																			
																										 + "</select>"
																										 + "&nbsp;"
																										 + "<input type='text'  name='Unq_Str_Num' style='width:82px;height:16px;' value='' maxlength='5' onblur='doDown(this.value)' >";
			break;
	}
}
doRadio('1');


var reqAdd = null;
function doAdd()
{
  if(Pro_O_Add.Cpm_Id.value.length < 1)
  {
  	alert('��ѡ���עվ��!');
  	return;
  }  
   if(Pro_O_Add.Fill_Number.value.length < 1)
  {
  	alert('����д��ע����!');
  	return;
  }
  if(Pro_O_Add.Oil_CType.value.length < 1)
  {
  	alert('��ѡ��ȼ������!');
  	return;
  }
  if(Pro_O_Add.BDate.value.length < 1)
  {
  	alert('��ѡ���עʱ��!');
  	return;
  }
  /**var TDay = new Date().format("yyyy-MM-dd");
	if(Pro_O_Add.BDate.value != TDay)
	{
		alert('ֻ�ɼ��˵�����ˮ!');
		return;
	}**/
  if(Pro_O_Add.Value.value.Trim().length < 1 || Pro_O_Add.Value.value <= 0)
  {
  	alert("��ע��������,���ܵ�ԭ��\n\n  1.��ע����Ϊ�ա�\n\n  2.��ע����������ֵ��");
		return;
  }
	for(var i=0; i<Pro_O_Add.Value.value.length; i++)
	{
		if(Pro_O_Add.Value.value.charAt(0) == '.' || Pro_O_Add.Value.value.charAt(Pro_O_Add.Value.value.length-1) == '.')
		{
			alert("�����ע������������������!");
	    return;
		}
		if(Pro_O_Add.Value.value.charAt(i) != '.' && isNaN(Pro_O_Add.Value.value.charAt(i)))
	  {
	    alert("�����ע������������������!");
	    return;
	  }
	}
	if(Pro_O_Add.Value.value.indexOf(".") != -1)
	{
		if(Pro_O_Add.Value.value.substring(Pro_O_Add.Value.value.indexOf(".")+1,Pro_O_Add.Value.value.length).length >2)
		{
			alert("��ע����С��������ֻ��������λ!");
			return;
		}
	}
  if(Pro_O_Add.Price.value.Trim().length < 1 || Pro_O_Add.Price.value <= 0)
  {
  	alert("��ע���۴���,���ܵ�ԭ��\n\n  1.��ע����Ϊ�ա�\n\n  2.��ע���۲�����ֵ��");
		return;
  }
	for(var i=0; i<Pro_O_Add.Price.value.length; i++)
	{
		if(Pro_O_Add.Price.value.charAt(0) == '.' || Pro_O_Add.Price.value.charAt(Pro_O_Add.Price.value.length-1) == '.')
		{
			alert("�����ע������������������!");
	    return;
		}
		if(Pro_O_Add.Price.value.charAt(i) != '.' && isNaN(Pro_O_Add.Price.value.charAt(i)))
	  {
	    alert("�����ע������������������!");
	    return;
	  }
	}
	if(Pro_O_Add.Price.value.indexOf(".") != -1)
	{
		if(Pro_O_Add.Price.value.substring(Pro_O_Add.Price.value.indexOf(".")+1,Pro_O_Add.Price.value.length).length >2)
		{
			alert("��ע����С��������ֻ��������λ!");
			return;
		}
	}
	if(Pro_O_Add.Worker.value.Trim().length < 1)
  {
  	alert('����д��ע��Ա����!');
  	return;
  }
	
	var Unq_Flag = '';
	var Unq_Str = '';
	if(document.getElementById('radio0').checked)
	{
		if(Pro_O_Add.Unq_Str.value.Trim().length < 1)
	  {
	  	alert('����д��עIC����!');
	  	return;
	  }
	  Unq_Flag = '0';
	  Unq_Str = Pro_O_Add.Unq_Str.value.Trim();
	}
	else if(document.getElementById('radio1').checked)
	{
		if(Pro_O_Add.Unq_Str_Car.value.length < 1 || Pro_O_Add.Unq_Str_Car.value == '-1')
	  {
	  	alert('��ѡ�������ڵ�!');
	  	return;
	  }
	  if(Pro_O_Add.Unq_Str_Num.value.Trim().length != 5)
	  {
	  	alert('����β����д����!');
	  	return;
	  }
	  Unq_Flag = '1';
	  Unq_Str = Pro_O_Add.Unq_Str_Car.value.Trim() + Pro_O_Add.Unq_Str_Num.value.Trim();
	}
	 if(Pro_O_Add.Car_CType.value.length < 1)
  {
  	alert('�ó�û��¼��ϵͳ����ʱ�޷���ע¼��!');
  	return;
  }
	if(Pro_O_Add.Car_Owner.value.Trim().length < 1)
  {
  	alert('����д˾������!');
  	return;
  }
  if(Pro_O_Add.Car_BH.value.Trim().length < 1)
  {
  	alert('����д����ƿ��!');
  	return;
  }
  if(Pro_O_Add.Car_DW.value.Trim().length < 1)
  {
  	alert('����д������λ!');
  	return;
  }
 
 
 
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
						
						Pro_O_Add.Value.value = "";
						if(null != Pro_O_Add.Unq_Str)
						{
							Pro_O_Add.Unq_Str.value = "";
						}
						else if(null != Pro_O_Add.Unq_Str_Num)
						{
							Pro_O_Add.Unq_Str_Num.value = "";
						}
						
						document.getElementById("T_Amt_V").innerHTML = "&nbsp;";
						document.getElementById("T_Car").innerHTML = "&nbsp;";
						document.getElementById("T_Owner").innerHTML = "&nbsp;";
						document.getElementById("T_BH").innerHTML = "&nbsp;";
						document.getElementById("T_DW").innerHTML = "&nbsp;";
						document.getElementById("Car_CType").value = "";
						setfocus();
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
		var url = 'Pro_O_Add.do?Cmd=10&Sid=<%=Sid%>&Cpm_Id='+Pro_O_Add.Cpm_Id.value+'&Oil_CType='+Pro_O_Add.Oil_CType.value+'&CTime='+Pro_O_Add.BDate.value+' '+Pro_O_Add.Hour.value+':'+Pro_O_Add.Minute.value+':00'+'&Fill_Number='+Pro_O_Add.Fill_Number.value+'&Value='+Pro_O_Add.Value.value.Trim()+'&Price='+Pro_O_Add.Price.value.Trim()+'&Amt='+Pro_O_Add.Amt_V.value.Trim()+'&Worker='+Pro_O_Add.Worker.value+'&Unq_Flag='+Unq_Flag+'&Unq_Str='+Unq_Str+'&Car_CType='+Pro_O_Add.Car_CType.value+'&Car_Owner='+Pro_O_Add.Car_Owner.value.Trim()+'&Car_BH='+Pro_O_Add.Car_BH.value.Trim()+'&Car_DW='+Pro_O_Add.Car_DW.value.Trim()+'&DW_ID='+Pro_O_Add.DW_ID.value.Trim()+'&Operator=<%=Operator%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&CurrPage=<%=currStatus.getCurrPage()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)+" 00:00:00"%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)+" 23:59:59"%>&currtime='+new Date();
		reqAdd.open("post",url,true);
		reqAdd.send(null);
		return true;
  
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
								Pro_O_Add.DW_ID.value=str[0];																					
					  		Pro_O_Add.Car_Owner.value=str[3];
								Pro_O_Add.Car_BH.value=str[4];
								Pro_O_Add.Car_DW.value=str[6];								
								Pro_O_Add.Car_CType.value=str[8];
								Pro_O_Add.Car_CType_Name.value=str[9];
								document.getElementById('T_Owner').innerHTML=str[3];
								document.getElementById('T_BH').innerHTML=str[4];
								document.getElementById('T_DW').innerHTML=str[6];
								document.getElementById('T_Car').innerHTML=str[9];
							}	
						}else
						{
						alert("��������");
						}
					}
	};
	var turl ="Pro_Id_Car.do?Id="+Pro_O_Add.Unq_Str_Car.value+cId+"&Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>";
	reqAdd.open("post",turl,true);
	reqAdd.send(null);
	return true;
	Pro_O_Add.Value.focus(); 
}
//������
function Sum(num)
{	
	if(Pro_O_Add.Price.value.length>0 && Pro_O_Add.Value.value.length>0)
	{		
		var va = Pro_O_Add.Price.value;
		var vb = Pro_O_Add.Value.value;		
		Pro_O_Add.Amt_V.value = parseInt(va)*parseInt(vb);
		document.getElementById('T_Amt_V').innerHTML = Pro_O_Add.Amt_V.value + 'Ԫ';		
	}
}



//�س���ת��
function changeEnter()
{    
	if(event.keyCode==13)
	{
		event.keyCode=9;
	} 	
} 
	//��λ����ʼλ��
function setfocus() 
{  
  Pro_O_Add.Unq_Str_Num.focus(); 
}  

function toChange(pType)
{		
		var Oil_Detail = "";
		if(pType == 3002 || pType == 3001)
		{
			Oil_Detail =  "kg";
		}
		else
		{
			Oil_Detail =  "L";
		}
		
   document.getElementById('Unit').innerHTML = Oil_Detail;  
}


</SCRIPT>
</html>