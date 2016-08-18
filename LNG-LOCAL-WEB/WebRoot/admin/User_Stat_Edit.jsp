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
	CurrStatus currStatus   = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
 	ArrayList FP_Role       = (ArrayList)session.getAttribute("FP_Role_" + Sid);
  ArrayList Manage_Role   = (ArrayList)session.getAttribute("Manage_Role_" + Sid);
  ArrayList User_Position = (ArrayList)session.getAttribute("User_Position_" + Sid);
  ArrayList Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
 	ArrayList User_Stat     = (ArrayList)session.getAttribute("User_Stat_" + Sid);
 	
 	String Id = request.getParameter("Id");
  String CName = "";
  String Dept_Id = "";
	String Sex = "";
	String Birthday = "";
	String Addr = "";
	String Tel = "";
	String Status = "";
	String RoleId = "";
	String Job_Id = "";
	String Job_Position = "";
	String Pwd = "";
	String FpId = "";
	String HP_LoginId = "";
	String HP_LoginPwd = "";
	String HP_LoginIp = "";
	String HP_LoginPort = "";
	if(User_Stat != null)
	{
		Iterator iterator = User_Stat.iterator();
		while(iterator.hasNext())
		{
			UserInfoBean statBean = (UserInfoBean)iterator.next();
			if(statBean.getId().equals(Id))
			{
					CName = statBean.getCName();
					Dept_Id = statBean.getDept_Id();
					Sex = statBean.getSex();
					Birthday = statBean.getBirthday();
					Addr = statBean.getAddr();
					Tel = statBean.getTel();
					Status = statBean.getStatus();
					RoleId = statBean.getManage_Role();
					Job_Id = statBean.getJob_Id();
					Job_Position = statBean.getJob_Position();
					Pwd = statBean.getPwd();
					FpId = statBean.getFp_Role();
					HP_LoginId = statBean.getHP_LoginId();
					HP_LoginPwd = statBean.getHP_LoginPwd();
					HP_LoginIp = statBean.getHP_LoginIp();
					HP_LoginPort = statBean.getHP_LoginPort();
					
					if(Job_Id == null){Job_Id = "";}
	        if(Job_Position == null){Job_Position = "";}
	        if(HP_LoginId == null){HP_LoginId = "";}
	        if(HP_LoginPwd == null){HP_LoginPwd = "";}
	        if(HP_LoginIp == null){HP_LoginIp = "";}
	        if(HP_LoginPort == null){HP_LoginPort = "";}
			}
		}
 	}
  
  UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid); 
  ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
  String ManageId = UserInfo.getManage_Role();
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
								String Dept_Id_t = UserInfo.getDept_Id();
								if(Dept_Id_t.length()>3){Manage_List = Dept_Id_t; } 
%>
<body style="background:#CADFFF">
<form name="User_Stat_Edit"  action="User_Info.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/cap_user_stat.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="60%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30'>
				<td width='100%' align='right'>
					<img src="../skin/images/mini_button_submit.gif"    style='cursor:hand;' onClick='doEdit()'>
					<img src="../skin/images/mini_button_pwd_reset.gif" style='cursor:hand;' onClick='doPwdEdit()'>
					<img src="../skin/images/button10.gif"              style='cursor:hand;' onclick='doNO()'>
				</td>
			</tr>
			<tr height='30'>
				<td width='100%' align='center'>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
						<tr height='30'>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<%=Id%>
							</td>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<select name="Dept_Id" style="width:97%;height:20px">									
								<%
								if(Manage_List.length() > 0 && null != Device_Detail)
								{
									Iterator iterator = Device_Detail.iterator();
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
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<input type='text' name='CName' style='width:96%;height:20px;' value='<%=CName%>' maxlength='6'>
							</td>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<select name='Sex' style='width:97%;height:20px'>
									<option value='0' <%=Sex.equals("0")?"selected":""%>>��</option>
									<option value='1' <%=Sex.equals("1")?"selected":""%>>Ů</option>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<input type='text' name='Tel' style='width:96%;height:20px;' value='<%=Tel%>' maxlength='11'>
							</td>
							<td width='20%' align='center'>��ְʱ��</td>
							<td width='30%' align='left'>
								<input type="text" name="Birthday" onClick="WdatePicker({readOnly:true})" class="Wdate" maxlength="10" style='width:97%;' value='<%=Birthday%>'>
							</td>
						</tr>
						<tr height='30'>	
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<input type='text' name='Job_Id' style='width:96%;height:18px;' value='<%=Job_Id%>' maxlength='20'>
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
											<option value='<%=R_Id%>' <%=Job_Position.equals(R_Id)?"selected":""%>><%=R_CName%></option>
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
									<option value='0' <%=Status.equals("0")?"selected":""%>>����</option>
									<option value='1' <%=Status.equals("1")?"selected":""%>>ע��</option>
								</select>
							</td>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ַ</td>
							<td width='30%' align='left'>
								<input type='text' name='Addr' style='width:96%;height:20px;' value='<%=Addr%>' maxlength='60'>
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
											<option value='<%=R_Id%>' <%=FpId.equals(R_Id)?"selected":""%>><%=R_CName%></option>
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
											<option value='<%=R_Id%>' <%=RoleId.equals(R_Id)?"selected":""%>><%=R_CName%></option>
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
								<input type='text' name='HP_LoginId'  style='width:96%;height:18px;' value='<%=HP_LoginId%>' maxlength='32'>
							</td>
							<td width='20%' align='center'>��ƽ����</td>
							<td width='30%' align='left'>
								<input type='text' name='HP_LoginPwd' style='width:96%;height:18px;' value='<%=HP_LoginPwd%>' maxlength='32'>
							</td>
						</tr>
						<tr height='30'>	
							<td width='20%' align='center'>��ƽ IP</td>
							<td width='30%' align='left'>
								<input type='text' name='HP_LoginIp'   style='width:96%;height:18px;' value='<%=HP_LoginIp%>' maxlength='20'>
							</td>
							<td width='20%' align='center'>��ƽPort</td>
							<td width='30%' align='left'>
								<input type='text' name='HP_LoginPort' style='width:96%;height:18px;' value='<%=HP_LoginPort%>' maxlength='5'>
							</td>
						</tr>
						-->
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input name="Cmd" type="hidden" value="11">
<input name="Id" type="hidden" value="<%=Id%>">
<input name="Sid" type="hidden" value="<%=Sid%>">
<input name="Func_Corp_Id" type="hidden" value="<%=currStatus.getFunc_Corp_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doEdit()
{
  if(User_Stat_Edit.Dept_Id.value.Trim().length < 1)
  {
    alert("��ѡ����!");
    return;
  }
  if(User_Stat_Edit.CName.value.Trim().length < 1)
  {
    alert("����������!");
    return;
  }
  if(User_Stat_Edit.Tel.value.Trim().length < 1)
  {
    alert("��������ϵ�绰!");
    return;
  }
  if(User_Stat_Edit.Birthday.value.Trim().length < 1)
  {
    alert("��������ְʱ��!");
    return;
  }
  if(User_Stat_Edit.Job_Position.value.Trim().length < 1)
  {
    alert("��ѡ���λ!");
    return;
  }
  if(User_Stat_Edit.Addr.value.Trim().length < 1)
  {
    alert("�������ַ!");
    return;
  }
  if(User_Stat_Edit.Fp_Role.value.Trim().length < 1)
  {
    alert("�븳�赱ǰ�ʺŹ���Ȩ�޽�ɫ!");
    return;
  }
  if(User_Stat_Edit.Manage_Role.value.Trim().length < 1)
  {
    alert("�븳�赱ǰ�ʺŹ���Ȩ�޽�ɫ!");
    return;
  }  
  if(confirm("��Ϣ����,ȷ���༭?"))
  {
  	User_Stat_Edit.submit();
  }
}

function doPwdEdit()
{
	if(confirm("ȷ�Ͻ���������Ϊ111111?"))
	{
		m_PwdEdit = createXHR();
		if(m_PwdEdit)
		{
			m_PwdEdit.onreadystatechange = callbackForPwdEdit;
			var url = "PwdEdit.do?Cmd=24&Sid=<%=Sid%>&Id=<%=Id%>&Pwd=<%=Pwd%>&NewPwd=111111&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&currtime="+new Date();
			m_PwdEdit.open("get", url);
			m_PwdEdit.send(null);
		}
		else
		{
			alert("�������֧�֣�������������");
		}
	}
}

function callbackForPwdEdit()
{
	if(m_PwdEdit.readyState == 4)
	{
		if(m_PwdEdit.status == 200)
		{
			var returnValue = m_PwdEdit.responseText;
			if(returnValue != null && returnValue == '0000')
      {    	
      		alert('���óɹ�');     
      }
      else if(returnValue != null && returnValue == '1001')
      {
      		alert('ʧ��,�������');
      }
      else
      {
          alert("ʧ��,�����²���");
      }
		}
		else
		{
			  alert("ʧ��,�����²���");
		}
	}
}

function createXHR()
{
	var xhr;
	try
	{
		xhr = new ActiveXObject("Msxml2.XMLHTTP");
	}
	catch(e)
	{
		try
		{
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		}
		catch(E)
		{
			xhr = false;
		}
	}
	if(!xhr && typeof XMLHttpRequest != 'undefined')
	{
		xhr = new XMLHttpRequest();
	}
	return xhr;
}

function doNO()
{
	location = "User_Stat.jsp?Sid=<%=Sid%>";
}
</SCRIPT>
</html>