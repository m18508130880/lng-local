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
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>

<script language="javascript">
	var now=new Date();
	
</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId = UserInfo.getManage_Role();
  String BDate = CommUtil.getDate();
  
  ArrayList Pro_R = (ArrayList)session.getAttribute("Pro_R_" + Sid);
  CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
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
<form name="Pro_R_Add" action="Pro_R.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/pro_r_add_jh.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="50%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
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
							<td width='25%' align='center'>վ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='75%' align='left'>							
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
							<td width='75%' align='left'>
								<select id="Oil_CType" name="Oil_CType" style="width:282px;height:20px" onchange="doChang()">
			<%						
						if(Oil_Info.trim().length() > 0)
						{
		  				String[] List = Oil_Info.split(";");
		 				 for(int i=0; i<List.length && List[i].length()>0; i++)
		  				{
		  					String[] subList = List[i].split(",");	
		  	%>				
		  			<option value='<%=subList[0]%>'><%=subList[0]%>|<%=subList[1]%></option>
		  	<%					
		  				}
		  			}		
			%>						
								</select>
							</td>
						</tr>
						
						<tr height='30'>
							<td width='25%' align='center'>���޺�</td>
							<td width='75%' align='left'>
								<select id="Tank_No" name="Tank_No" style="width:282px;height:20px" onchange="doChang()">
									<option value='1'>1�Ź�</option>
									<option value='2'>2�Ź�</option>
								</select>
							</td>
						</tr>
						
						<!--20150314�޸�-->	
						<tr height='30'>
							<td width='25%' align='center'>ж���ƻ�</td>
							<td width='75%' align='left'>
								<input type='text' name='Value_Plan' style='width:200px;height:18px;' value='0.00' maxlength='10'> 
								<select name="PUnit" style='width:74px;height:20px;'>
										<option value='kg'>kg</option>
										<option value='L'>L</option>
										<option value='NM3'>NM3</option>
								</select>
							</td>
						</tr>
						
						<tr height='30'>
							<td width='25%' align='center'>¼��ʱ��</td>
							<td width='75%' align='left'>
								<input name='BDate' type='text' style='width:282px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10' onchange="doChang()">
							<!--	<select name="Hour" style="width:85px;height:20px">
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
								</select>-->							
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>��ǰ���</td>
							<td width='75%' align='left'>
								<input type='text' name='Value' style='width:200px;height:18px;' value='0.00' maxlength='10'> 
								<select name="VUnit" style='width:74px;height:20px;'>
										<option value='kg'>kg</option>
										<option value='L'>L</option>
										<option value='NM3'>NM3</option>
								</select>
							</td>
						</tr>
						
						<tr height='30'>
							<td width='25%' align='center'>Ԥ����ֵ</td>
							<td width='75%' align='left'>
								<input type='text' name='Value_Ware' style='width:200px;height:18px;' value='0.00' maxlength='10'> 
								<select name="WUnit" style='width:74px;height:20px;'>
										<option value='kg'>kg</option>
										<option value='L'>L</option>
										<option value='NM3'>NM3</option>
								</select>
							</td>
						</tr>
						
					
						
		
						<tr height='30'>
							<td width='25%' align='center'>��Ӫ״̬</td>
							<td width='75%' align='left'>
								<select name='Status' style='width:282px;height:20px;'>
									<option value='0'>����</option>
									<option value='1'>ͣ��</option>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>¼����Ա</td>
							<td width='75%' align='left'>
								<%=Operator%>
							</td>
						</tr>						
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input type='hidden' name='Cmd' value='10'>
<input type='hidden' name='Sid' value='<%=Sid%>'>
<input type='hidden' name='Operator'     value='<%=Operator%>'>
<input type='hidden' name='Func_Corp_Id' value='<%=currStatus.getFunc_Corp_Id()%>'>
<input type='hidden' name='Func_Sub_Id'  value='<%=currStatus.getFunc_Sub_Id()%>'>
<input type='hidden' name='Func_Sel_Id'  value='<%=currStatus.getFunc_Sel_Id()%>'>
<input type='hidden' name='Func_Cpm_Id'  value='<%=currStatus.getFunc_Cpm_Id()%>'>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//��ʼ��
var txt;
function doNO()
{
	location = "Pro_R.jsp?Sid=<%=Sid%>";
}
//ѡ��վ�� ���ȼ������&���ޱ��
function doChange(pId)
{
/**--------------------------ȼ������--------------------------------
	//��ɾ��
	var length = document.getElementById('Oil_CType').length;
	for(var i=0; i<length; i++)
	{
		document.getElementById('Oil_CType').remove(0);
	}
	
	//�����
	if(pId.length > 0)
	{
		var str_Now = '';
		<%
		if(null != Pro_R)
		{
			Iterator riter = Pro_R.iterator();
			while(riter.hasNext())
			{
				ProRBean rBean = (ProRBean)riter.next();
		%>
				if('<%=rBean.getCpm_Id()%>' == pId)
				{
					str_Now += '<%=rBean.getOil_CType()%>' + ',';
				}
		<%
			}
		}
		if(Oil_Info.trim().length() > 0)
		{
		  String[] List = Oil_Info.split(";");
		  for(int i=0; i<List.length && List[i].length()>0; i++)
		  {
		  	String[] subList = List[i].split(",");
		%>
				if(str_Now.indexOf('<%=subList[0]%>') < 0)
				{
					var objOption = document.createElement('OPTION');
					objOption.value = '<%=subList[0]%>';
					objOption.text  = '<%=subList[0]%>|<%=subList[1]%>';
					document.getElementById('Oil_CType').add(objOption);
				}
		<%
		  }
		}
		%>
	}
	
------------------------���޺�---------------------------
	//��ɾ��
	var length1 = document.getElementById('Tank_No').length;
	for(var i=0; i<length1; i++)
	{
		document.getElementById('Tank_No').remove(0);
	}
	//�����
	if(pId.length > 0)
	{
		var str_Now_Tank = '';
		<%
		if(null != Pro_R)
		{
			Iterator riter = Pro_R.iterator();
			while(riter.hasNext())
			{
				ProRBean rBean = (ProRBean)riter.next();
		%>
				if('<%=rBean.getCpm_Id()%>' == pId)
				{
					str_Now_Tank += '<%=rBean.getTank_No()%>' + ',';
				}
		<%
			}
		}
		for(int j=1; j<3; j++)
		{
		%>
				if(str_Now_Tank.indexOf('<%=j%>') < 0)
				{
					var objOption = document.createElement('OPTION');
					objOption.value = '<%=j%>';
					objOption.text  = '<%=j%>�Ź�';
					document.getElementById('Tank_No').add(objOption);
				}
		<%
		 }
		%>
	}**/
	doChang();
}
doChange(Pro_R_Add.Cpm_Id.value);

function doAdd()
{
  if(Pro_R_Add.Cpm_Id.value.length < 1)
  {
  	alert('��ѡ��վ��!');
  	return;
  }
  if(Pro_R_Add.Oil_CType.value.length < 1)
  {
  	alert('��ѡ��ȼ������!');
  	return;
  }

  if(Pro_R_Add.Value.value.Trim().length < 1 || Pro_R_Add.Value.value < 0)
  {
  	alert("��ǰ������,���ܵ�ԭ��\n\n  1.����Ϊ�ա�\n\n  2.����������ֵ��");
		return;
  }
	for(var i=0; i<Pro_R_Add.Value.value.length; i++)
	{
		if(Pro_R_Add.Value.value.charAt(0) == '.' || Pro_R_Add.Value.value.charAt(Pro_R_Add.Value.value.length-1) == '.')
		{
			alert("���뵱ǰ�����������������!");
	    return;
		}
		if(Pro_R_Add.Value.value.charAt(i) != '.' && isNaN(Pro_R_Add.Value.value.charAt(i)))
	  {
	    alert("���뵱ǰ�����������������!");
	    return;
	  }
	}
	if(Pro_R_Add.Value.value.indexOf(".") != -1)
	{
		if(Pro_R_Add.Value.value.substring(Pro_R_Add.Value.value.indexOf(".")+1,Pro_R_Add.Value.value.length).length >2)
		{
			alert("С��������ֻ��������λ!");
			return;
		}
	}
	if(Pro_R_Add.Value_Ware.value.Trim().length < 1 || Pro_R_Add.Value_Ware.value < 0)
  {
  	alert("Ԥ����ֵ����,���ܵ�ԭ��\n\n  1.����Ϊ�ա�\n\n  2.����������ֵ��");
		return;
  }
	for(var i=0; i<Pro_R_Add.Value_Ware.value.length; i++)
	{
		if(Pro_R_Add.Value_Ware.value.charAt(0) == '.' || Pro_R_Add.Value_Ware.value.charAt(Pro_R_Add.Value_Ware.value.length-1) == '.')
		{
			alert("����Ԥ����ֵ��������������!");
	    return;
		}
		if(Pro_R_Add.Value_Ware.value.charAt(i) != '.' && isNaN(Pro_R_Add.Value_Ware.value.charAt(i)))
	  {
	    alert("����Ԥ����ֵ��������������!");
	    return;
	  }
	}
	if(Pro_R_Add.Value_Ware.value.indexOf(".") != -1)
	{
		if(Pro_R_Add.Value_Ware.value.substring(Pro_R_Add.Value_Ware.value.indexOf(".")+1,Pro_R_Add.Value_Ware.value.length).length >2)
		{
			alert("С��������ֻ��������λ!");
			return;
		}
	}
	
	
	 if(Pro_R_Add.Value_Plan.value.Trim().length < 1 || Pro_R_Add.Value_Plan.value < 0)
  {
  	alert("��ǰж���ƻ�����,���ܵ�ԭ��\n\n  1.����Ϊ�ա�\n\n  2.����������ֵ��");
		return;
  }
	for(var i=0; i<Pro_R_Add.Value_Plan.value.length; i++)
	{
		if(Pro_R_Add.Value_Plan.value.charAt(0) == '.' || Pro_R_Add.Value_Plan.value.charAt(Pro_R_Add.Value_Plan.value.length-1) == '.')
		{
			alert("���뵱ǰж���ƻ���������������!");
	    return;
		}
		if(Pro_R_Add.Value_Plan.value.charAt(i) != '.' && isNaN(Pro_R_Add.Value_Plan.value.charAt(i)))
	  {
	    alert("���뵱ǰж���ƻ���������������!");
	    return;
	  }
	}
	if(Pro_R_Add.Value_Plan.value.indexOf(".") != -1)
	{
		if(Pro_R_Add.Value_Plan.value.substring(Pro_R_Add.Value_Plan.value.indexOf(".")+1,Pro_R_Add.Value_Plan.value.length).length >2)
		{
			alert("С��������ֻ��������λ!");
			return;
		}
	}
	if(txt == 1)
	{
		alert('��վ���ռƻ����ϱ�!');
		return;
		}
	if(confirm("��Ϣ����,ȷ���ύ?"))
  {
  	Pro_R_Add.Func_Cpm_Id.value = Pro_R_Add.Cpm_Id.value;
  	Pro_R_Add.submit();
  }
 
}


//��ѯ��ǰʱ�������Ƿ���¼��
function doChang()
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
							txt = reqAdd.responseText;														
						}
					}
	};
	var turl = 'Pro_R_Date.do?Sid=<%=Sid%>&Cpm_Id='+Pro_R_Add.Cpm_Id.value+'&Oil_CType='+Pro_R_Add.Oil_CType.value+'&CTime='+Pro_R_Add.BDate.value+'&Tank_No='+Pro_R_Add.Tank_No.value;
	reqAdd.open("post",turl,true);
	reqAdd.send(null);	
}
</SCRIPT>
</html>