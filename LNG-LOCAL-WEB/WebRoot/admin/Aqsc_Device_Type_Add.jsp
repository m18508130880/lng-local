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
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String CType = CommUtil.StrToGB2312(request.getParameter("CType"));
	ArrayList Aqsc_Device_Card = (ArrayList)session.getAttribute("Aqsc_Device_Card_" + Sid);
	int cnt = 0;
	
%>
<body style="background:#CADFFF">
<form name="Aqsc_Device_Type_Add" action="Aqsc_Device_Type.do" method="post" target="_self">
	<br>
	<table width="80%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='30'>
			<td width='100%' align='center'>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">				
					<tr height='30'>
						<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
						<td width='30%' align='left'>
							***
						</td>
						<td width='20%' align='center'>״&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;̬</td>
						<td width='30%' align='left'>
						  <select name="Status" style="width:92%;height:20px;">
						  	<option value='0'>����</option>
						  	<option value='1'>ע��</option>
						  </select>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
						<td width='30%' align='left'>
							<input type='text' name='CName' style='width:90%;height:18px;' value='' maxlength='15'>
						</td>
						<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
						<td width='30%' align='left'>
						  <input type='text' name='Model' style='width:90%;height:18px;' value='' maxlength='10'>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
						<td width='80%' align='left' colspan=3>
							<input type='text' name='Agent' style='width:96%;height:18px;' value='' maxlength='32'>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>�� ϵ ��</td>
						<td width='30%' align='left'>
							<input type='text' name='Agent_Man' style='width:90%;height:18px;' value='' maxlength='10'>
						</td>
						<td width='20%' align='center'>��ϵ�绰</td>
						<td width='30%' align='left'>
						  <input type='text' name='Agent_Tel' style='width:90%;height:18px;' value='' maxlength='12'>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>���ղ���</td>
						<td width='80%' align='left' colspan=3>
							<textarea name='Craft' rows='3' cols='72' maxlength=128></textarea>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>��������</td>
						<td width='80%' align='left' colspan=3>
							<textarea name='Technology' rows='3' cols='72' maxlength=128></textarea>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>��Ϣ����</td>
						<td width='80%' align='left' colspan=3>
							<textarea name='Des' rows='3' cols='72' maxlength=128></textarea>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>�ر�֤��</td>
						<td width='80%' align='left' colspan=3>
							<table width='100%' border=0>
								<tr height='25px'>
								<%
								if(Aqsc_Device_Card != null)
								{
									Iterator carditer = Aqsc_Device_Card.iterator();
									while(carditer.hasNext())
									{
										AqscDeviceCardBean DeviceCard = (AqscDeviceCardBean)carditer.next();
										if(DeviceCard.getStatus().equals("0"))
										{											
											if(0 == cnt%2 && cnt > 0)
											{
								%>
												</tr>
												<tr height='25px'>
								<%
											}
								%>
											<td width='50%' align='left'>
												<input type='checkbox' id='checkbox<%=cnt%>' name='checkbox<%=cnt%>' value='<%=DeviceCard.getId()%>'><%=DeviceCard.getCName()%>
											</td>
								<%
											cnt++;
										}
									}
								}
								%>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height='32px'>
			<td width='100%' align='center'>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doAdd()'>
				<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>
			</td>
		</tr>
	</table>
	<input name="Cmd"       type="hidden" value="10">
	<input name="Id"        type="hidden" value="***">
	<input name="Sid"       type="hidden" value="<%=Sid%>">
	<input name="CType"     type="hidden" value="<%=CType%>">
	<input name="Card_List" type="hidden" value="">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doNO()
{
	location = "Aqsc_Device_Type.jsp?Sid=<%=Sid%>&CType=<%=CType%>";
}

function doAdd()
{
  if(Aqsc_Device_Type_Add.CName.value.Trim().length < 1)
  {
    alert("����������!");
    return;
  }
  if(Aqsc_Device_Type_Add.Model.value.Trim().length < 1)
  {
    alert("�������ͺ�!");
    return;
  }
  if(Aqsc_Device_Type_Add.Agent.value.Trim().length < 1)
  {
    alert("�����볧��!");
    return;
  }
  if(Aqsc_Device_Type_Add.Agent_Man.value.Trim().length < 1)
  {
    alert("��������ϵ��!");
    return;
  }
  if(Aqsc_Device_Type_Add.Agent_Tel.value.Trim().length < 1)
  {
    alert("��������ϵ�绰!");
    return;
  }
  if(Aqsc_Device_Type_Add.Craft.value.Trim().length > 128)
  {
    alert("���ղ������������!");
    return;
  }
  if(Aqsc_Device_Type_Add.Technology.value.Trim().length > 128)
  {
    alert("�����������������!");
    return;
  }
  if(Aqsc_Device_Type_Add.Des.value.Trim().length > 128)
  {
    alert("��ע���������!");
    return;
  }
  
  var Card_List = '';
	for(var i=0; i<<%=cnt%>; i++)
	{
		if(document.getElementById('checkbox'+i) && document.getElementById('checkbox'+i).checked)
		{
			Card_List += document.getElementById('checkbox'+i).value + ',';
		}
	} 	
	Aqsc_Device_Type_Add.Card_List.value = Card_List;
  if(confirm("��Ϣ����,ȷ���ύ?"))
  {
  	Aqsc_Device_Type_Add.submit();
  }
}
</SCRIPT>
</html>