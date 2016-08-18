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
	
	String Sid        = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Cpm_Id     = CommUtil.StrToGB2312(request.getParameter("Cpm_Id"));
	String Cpm_Name   = CommUtil.StrToGB2312(request.getParameter("Cpm_Name"));
	String Check_Time = CommUtil.StrToGB2312(request.getParameter("Check_Time"));
	String Check_SN   = CommUtil.StrToGB2312(request.getParameter("Check_SN"));
	ArrayList User_User_Info = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	CurrStatus currStatus    = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	UserInfoBean UserInfo    = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  
%>
<body style="background:#CADFFF">
<form name="Sat_Check_Add_Break" action="Sat_Check_Add_Break.do" method="post" target="mFrame">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='30'>
			<td width='25%' align='center'>������վ</td>
			<td width='75%' align='left'>
				<%=Cpm_Name%>
				<input type='hidden' name='Cpm_Id' value='<%=Cpm_Id%>'>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>Υ��ʱ��</td>
			<td width='75%' align='left'>
				<%=Check_Time%>
				<input type='hidden' name='Break_Time' value='<%=Check_Time%>'>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>Υ �� ��</td>
			<td width='75%' align='left'>
				<select name="Break_OP" style="width:91%;height:20px">
					<option value='*'>��ѡ��...</option>
					<%
					if(null != User_User_Info)
					{
						Iterator useriter = User_User_Info.iterator();
						while(useriter.hasNext())
						{
							UserInfoBean userBean = (UserInfoBean)useriter.next();
							if(userBean.getStatus().equals("0") && userBean.getDept_Id().equals(Cpm_Id))
							{
					%>
								<option value='<%=userBean.getId()%>'><%=userBean.getCName()%></option>
					<%
							}
						}
					}
					%>
				</select>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>ֱ�ӹ�����</td>
			<td width='75%' align='left'>
				<select name="Manag_OP" style="width:91%;height:20px">
					<option value='*'>��ѡ��...</option>
					<%
					if(null != User_User_Info)
					{
						Iterator useriter = User_User_Info.iterator();
						while(useriter.hasNext())
						{
							UserInfoBean userBean = (UserInfoBean)useriter.next();
							if(userBean.getStatus().equals("0") && (userBean.getDept_Id().equals(Cpm_Id) || userBean.getDept_Id().length() == 2))
							{
					%>
								<option value='<%=userBean.getId()%>'><%=userBean.getCName()%></option>
					<%
							}
						}
					}
					%>
				</select>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>��Ч�ҹ�</td>
			<td width='75%' align='left'>
				<input type='text' name='Break_Point' style="width:90%;height:16px" value=''> ��
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>Υ����Ϊ<br>(Υ������)</td>
			<td width='75%' align='left'>
				<textarea name='Break_Des' rows='5' cols='32' maxlength=128></textarea>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>¼����Ա</td>
			<td width='75%' align='left'>
				<%=Operator_Name%>
				<input type='hidden' name='Operator' value='<%=Operator%>'>
			</td>
		</tr>
		<tr height='40'>
			<td width='100%' align='center' colspan=2>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doSave()'>
			</td>
		</tr>
	</table>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
var reqAdd = null;
function doSave()
{
  if(Sat_Check_Add_Break.Break_Time.value.length < 1)
  {
  	alert('��ѡ��Υ��ʱ��!');
  	return;
  }
  if(Sat_Check_Add_Break.Break_OP.value.length < 1 || Sat_Check_Add_Break.Break_OP.value == '*')
  {
  	alert('��ѡ��Υ����!');
  	return;
  }
  if(Sat_Check_Add_Break.Manag_OP.value.length < 1 || Sat_Check_Add_Break.Manag_OP.value == '*')
  {
  	alert('��ѡ��ֱ�ӹ�����!');
  	return;
  }
  if(Sat_Check_Add_Break.Break_Point.value.Trim().length < 1 || Sat_Check_Add_Break.Break_Point.value > 0)
  {
  	alert("��Ч�ҹ��۷ִ���,���ܵ�ԭ��\n\n  1.Ϊ�ա�\n\n  2.���Ǹ�ֵ��");
		return;
  }
	for(var i=0; i<Sat_Check_Add_Break.Break_Point.value.length; i++)
	{
		if(Sat_Check_Add_Break.Break_Point.value.charAt(Sat_Check_Add_Break.Break_Point.value.length-1) == '-')
		{
			alert("���뼨Ч�ҹ��۷���������������!");
	    return;
		}
		if(Sat_Check_Add_Break.Break_Point.value.charAt(i) == '-' && i != 0)
		{
			alert("���뼨Ч�ҹ��۷���������������!");
	    return;
		}
		if(Sat_Check_Add_Break.Break_Point.value.charAt(i) != '-' && isNaN(Sat_Check_Add_Break.Break_Point.value.charAt(i)))
	  {
	    alert("���뼨Ч�ҹ��۷���������������!");
	    return;
	  }
	}
	if(Sat_Check_Add_Break.Break_Des.value.Trim().length < 1)
	{
		alert('���Ҫ����Υ����Ϊ��Υ���������!');
		return;
	}
	if(Sat_Check_Add_Break.Break_Des.value.Trim().length > 128)
  {
    alert("Υ����Ϊ��Υ�������������������!");
    return;
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
						parent.doSelect();
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
		var url = 'Sat_Break_Add.do?Cmd=10&Sid=<%=Sid%>&Check_SN=<%=Check_SN%>&Cpm_Id='+Sat_Check_Add_Break.Cpm_Id.value+'&Break_Time='+Sat_Check_Add_Break.Break_Time.value+'&Break_OP='+Sat_Check_Add_Break.Break_OP.value+'&Manag_OP='+Sat_Check_Add_Break.Manag_OP.value+'&Break_Point='+Sat_Check_Add_Break.Break_Point.value.Trim()+'&Break_Des='+Sat_Check_Add_Break.Break_Des.value.Trim()+'&Operator=<%=Operator%>&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&currtime='+new Date();
		reqAdd.open("post",url,true);
		reqAdd.send(null);
		return true;
  }
}
</SCRIPT>
</html>