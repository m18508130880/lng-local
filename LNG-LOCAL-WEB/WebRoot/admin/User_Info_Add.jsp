<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("Corp_Info_" + Sid);
  String Dept = "";
  if(Corp_Info != null)
	{
		Dept = Corp_Info.getDept();
    if(Dept == null)
    {
    	Dept = "";
    }
 	}
 	
  ArrayList FP_Role       = (ArrayList)session.getAttribute("FP_Role_" + Sid);
  ArrayList Manage_Role   = (ArrayList)session.getAttribute("Manage_Role_" + Sid);
  ArrayList User_Position = (ArrayList)session.getAttribute("User_Position_" + Sid);
  
%>
<body style="background:#CADFFF">
<form name="User_Info_Add"  action="User_Info.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/cap_user_info.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="60%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
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
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<table width='98%'>
									<tr>
										<td width='60%' align='left'><input type='text' name='Id' style='width:98%;height:18px;' value='' maxlength='20' onkeyup="doCheck(this.value)"><td>
										<td width='40%' align='left' id='ErrorMsg' style="color:red;">&nbsp;</td>
									</tr>
								</table>
							</td>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<select name="Dept_Id" style="width:97%;height:20px"> 
								<%
								if(Dept.trim().length() > 0)
								{
									String[] DeptList = Dept.split(",");
								  String pDept_Id = "";
								  String pDept_Name = "";
								  for(int i=0; i<DeptList.length; i++)
								  {
										pDept_Id = CommUtil.IntToStringLeftFillZero(i+1, 2);
										pDept_Name = DeptList[i];
								%>
								    <option value="<%=pDept_Id%>"><%=pDept_Name%></option>
								<%
		    					}
								}
								%>
								</select>								        
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<input type='text' name='CName' style='width:96%;height:20px;' value='' maxlength='6'>
							</td>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<select name='Sex' style='width:97%;height:20px'>
									<option value='0'>��</option>
									<option value='1'>Ů</option>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<input type='text' name='Tel' style='width:96%;height:20px;' value='' maxlength='11'>
							</td>
							<td width='20%' align='center'>��ְʱ��</td>
							<td width='30%' align='left'>
								<input type="text" name="Birthday" onClick="WdatePicker({readOnly:true})" class="Wdate" maxlength="10" style='width:97%;'>
							</td>
						</tr>
						<tr height='30'>	
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<input type='text' name='Job_Id' style='width:96%;height:18px;' value='' maxlength='20'>
							</td>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;λ</td>
							<td width='30%' align='left'>
								<select name='Job_Position' style='width:97%;height:20px'>
								<%
								if(User_Position != null && User_Position.size() > 0)
								{
									for(int i=0; i<User_Position.size(); i++)
									{
										UserPositionBean Position = (UserPositionBean)User_Position.get(i);
										if(Position.getStatus().equals("0"))
										{
											String R_Id = Position.getId();
											String R_CName = Position.getCName();
								%>
											<option value='<%=R_Id%>'><%=R_CName%></option>
								<%
										}
									}
								}
								%>
								</select>
							</td>
						</tr>
						<tr height='30'>	
							<td width='20%' align='center'>״&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;̬</td>
							<td width='30%' align='left'>
								<select name='Status' style='width:97%;height:20px'>
									<option value='0'>����</option>
									<option value='1'>ע��</option>
								</select>
							</td>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ַ</td>
							<td width='30%' align='left'>
								<input type='text' name='Addr' style='width:96%;height:20px;' value='' maxlength='60'>
							</td>						
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>����Ȩ��</td>
							<td width='30%' align='left'>
								<select name='Fp_Role' style='width:97%;height:20px'>	
								<%
								if(FP_Role != null && FP_Role.size() > 0)
								{
									for(int i=0; i<FP_Role.size(); i++)
									{
										UserRoleBean Role = (UserRoleBean)FP_Role.get(i);
										if(Role.getId().length() == 3)
										{
											String R_Id = Role.getId();
											String R_CName = Role.getCName();
								%>
											<option value='<%=R_Id%>'><%=R_CName%></option>
								<%
										}
									}
								}
								%>									
								</select>
							</td>
							<td width='20%' align='center'>����Ȩ��</td>
							<td width='30%' align='left'>
								<select name='Manage_Role' style='width:97%;height:20px'>	
								<%
								if(Manage_Role != null && Manage_Role.size() > 0)
								{
									for(int i=0; i<Manage_Role.size(); i++)
									{
										UserRoleBean Role = (UserRoleBean)Manage_Role.get(i);
										if(Role.getId().length() == 4)
										{
											String R_Id = Role.getId();
											String R_CName = Role.getCName();
								%>
											<option value='<%=R_Id%>'><%=R_CName%></option>
								<%
										}
									}
								}
								%>									
								</select>
							</td>
						</tr>
						<!--
						<tr height='30'>	
							<td width='20%' align='center'>��ƽ�˺�</td>
							<td width='30%' align='left'>
								<input type='text' name='HP_LoginId'  style='width:96%;height:18px;' value='' maxlength='32'>
							</td>
							<td width='20%' align='center'>��ƽ����</td>
							<td width='30%' align='left'>
								<input type='text' name='HP_LoginPwd' style='width:96%;height:18px;' value='' maxlength='32'>
							</td>
						</tr>
						<tr height='30'>	
							<td width='20%' align='center'>��ƽ IP</td>
							<td width='30%' align='left'>
								<input type='text' name='HP_LoginIp'   style='width:96%;height:18px;' value='' maxlength='20'>
							</td>
							<td width='20%' align='center'>��ƽPort</td>
							<td width='30%' align='left'>
								<input type='text' name='HP_LoginPort' style='width:96%;height:18px;' value='' maxlength='5'>
							</td>
						</tr>
						-->
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input name="Cmd" type="hidden" value="10">
<input name="Sid" type="hidden" value="<%=Sid%>">
<input name="Func_Corp_Id" type="hidden" value="<%=currStatus.getFunc_Corp_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
var Flag = 0;
//�Զ����ʺż��
function doCheck(pId)
{
	if(pId.Trim().length == 0)
	{
		Flag = 0;
		document.getElementById("ErrorMsg").innerText = " ";
		return;
	}
	if(pId.Trim().length > 0 && pId.Trim().length < 2)
	{
		 document.getElementById("ErrorMsg").innerText = " X ��2-20λ!";
		 Flag = 0;
		 return;
	}
	//Ajax�����ύ
	if(window.XMLHttpRequest)
  {
			req = new XMLHttpRequest();
  }
  else if(window.ActiveXObject)
  {
			req = new ActiveXObject("Microsoft.XMLHTTP");
  }		
	//���ûص�����
	req.onreadystatechange = callbackCheckName;
	var url = "IdCheck.do?Id="+pId+"&Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>";
	req.open("post",url,true);
	req.send(null);
	return true;
}
function callbackCheckName()
{
		var state = req.readyState;
		if(state==4)
		{
			var resp = req.responseText;			
			var str = "";
			if(resp != null && resp == '0000')
			{
				 document.getElementById("ErrorMsg").innerText = " �� ����!";
				 Flag = 1;
				 return;
			}
			else if(resp != null && resp == '3006')
			{
				 document.getElementById("ErrorMsg").innerText = " X �Ѵ���!";
				 Flag = 0;
				 return;
			}
		}
}

function doAdd()
{
	if(Flag == 0)
  {
  	alert("�ʺ��������������룡");
  	return;
  }
  if(User_Info_Add.Dept_Id.value.Trim().length < 1)
  {
    alert("��ѡ����!");
    return;
  }
  if(User_Info_Add.CName.value.Trim().length < 1)
  {
    alert("����������!");
    return;
  }
  if(User_Info_Add.Tel.value.Trim().length < 1)
  {
    alert("��������ϵ�绰!");
    return;
  }
  if(User_Info_Add.Birthday.value.Trim().length < 1)
  {
    alert("��������ְʱ��!");
    return;
  }
  if(User_Info_Add.Job_Position.value.Trim().length < 1)
  {
    alert("��ѡ���λ!");
    return;
  }
  if(User_Info_Add.Addr.value.Trim().length < 1)
  {
    alert("�������ַ!");
    return;
  }
  if(User_Info_Add.Fp_Role.value.Trim().length < 1)
  {
    alert("�븳�赱ǰ�ʺŹ���Ȩ�޽�ɫ!");
    return;
  }
  if(User_Info_Add.Manage_Role.value.Trim().length < 1)
  {
    alert("�븳�赱ǰ�ʺŹ���Ȩ�޽�ɫ!");
    return;
  }
  if(confirm("��Ϣ����,ȷ�����?"))
  {
  	User_Info_Add.submit();
  }
}

function doNO()
{
	location = "User_Info.jsp?Sid=<%=Sid%>";
}
</SCRIPT>
</html>