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
	ArrayList Aqsc_Device_Type = (ArrayList)session.getAttribute("Aqsc_Device_Type_" + Sid);
	int cnt = 0;
	
 	String Id = request.getParameter("Id");
  String CName = "";
	String Status = "0";
	String Des = "";
	String Model = "";
	String Craft = "";
	String Technology = "";
	String Agent = "";
	String Agent_Man = "";
	String Agent_Tel = "";
	String Card_List = "";
	if(Aqsc_Device_Type != null)
	{
		Iterator iterator = Aqsc_Device_Type.iterator();
		while(iterator.hasNext())
		{
			AqscDeviceTypeBean statBean = (AqscDeviceTypeBean)iterator.next();
			if(statBean.getId().equals(Id))
			{
				CName = statBean.getCName();
				Status = statBean.getStatus();
				Des = statBean.getDes();
				Model = statBean.getModel();
				Craft = statBean.getCraft();
				Technology = statBean.getTechnology();
				Agent = statBean.getAgent();
				Agent_Man = statBean.getAgent_Man();
				Agent_Tel = statBean.getAgent_Tel();
				Card_List = statBean.getCard_List();
				
				if(null == Des){Des = "";}
				if(null == Craft){Craft = "";}
				if(null == Technology){Technology = "";}
				if(null == Card_List){Card_List = "";}
			}
		}
 	}
 	
%>
<body style="background:#CADFFF">
<form name="Aqsc_Device_Type_Edit" action="Aqsc_Device_Type.do" method="post" target="_self">
	<br>
	<table width="80%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='30'>
			<td width='100%' align='center'>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='30'>
						<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
						<td width='30%' align='left'>
							<%=Id%>
						</td>
						<td width='20%' align='center'>״&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;̬</td>
						<td width='30%' align='left'>
						  <select name="Status" style="width:92%;height:20px;">
						  	<option value='0' <%=Status.equals("0")?"selected":""%>>����</option>
						  	<option value='1' <%=Status.equals("1")?"selected":""%>>ע��</option>
						  </select>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
						<td width='30%' align='left'>
							<input type='text' name='CName' style='width:90%;height:18px;' value='<%=CName%>' maxlength='15'>
						</td>
						<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
						<td width='30%' align='left'>
						  <input type='text' name='Model' style='width:90%;height:18px;' value='<%=Model%>' maxlength='10'>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
						<td width='80%' align='left' colspan=3>
							<input type='text' name='Agent' style='width:96%;height:18px;' value='<%=Agent%>' maxlength='32'>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>�� ϵ ��</td>
						<td width='30%' align='left'>
							<input type='text' name='Agent_Man' style='width:90%;height:18px;' value='<%=Agent_Man%>' maxlength='10'>
						</td>
						<td width='20%' align='center'>��ϵ�绰</td>
						<td width='30%' align='left'>
						  <input type='text' name='Agent_Tel' style='width:90%;height:18px;' value='<%=Agent_Tel%>' maxlength='12'>
						</td>
					</tr>	
					<tr height='30'>
						<td width='20%' align='center'>���ղ���</td>
						<td width='80%' align='left' colspan=3>
							<textarea name='Craft' rows='3' cols='72' maxlength=128><%=Craft%></textarea>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>��������</td>
						<td width='80%' align='left' colspan=3>
							<textarea name='Technology' rows='3' cols='72' maxlength=128><%=Technology%></textarea>
						</td>
					</tr>
					<tr height='30'>
						<td width='20%' align='center'>��Ϣ����</td>
						<td width='80%' align='left' colspan=3>
							<textarea name='Des' rows='3' cols='72' maxlength=128><%=Des%></textarea>
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
												<input type='checkbox' id='checkbox<%=cnt%>' name='checkbox<%=cnt%>' value='<%=DeviceCard.getId()%>' <%=Card_List.contains(DeviceCard.getId())?"checked":""%>><%=DeviceCard.getCName()%>
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
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
				<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>
			</td>
		</tr>
	</table>
	<input name="Cmd"       type="hidden" value="11">
	<input name="Id"        type="hidden" value="<%=Id%>">
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

function doEdit()
{
  if(Aqsc_Device_Type_Edit.CName.value.Trim().length < 1)
  {
    alert("����������!");
    return;
  }
  if(Aqsc_Device_Type_Edit.Model.value.Trim().length < 1)
  {
    alert("�������ͺ�!");
    return;
  }
  if(Aqsc_Device_Type_Edit.Agent.value.Trim().length < 1)
  {
    alert("�����볧��!");
    return;
  }
  if(Aqsc_Device_Type_Edit.Agent_Man.value.Trim().length < 1)
  {
    alert("��������ϵ��!");
    return;
  }
  if(Aqsc_Device_Type_Edit.Agent_Tel.value.Trim().length < 1)
  {
    alert("��������ϵ�绰!");
    return;
  }
  if(Aqsc_Device_Type_Edit.Craft.value.Trim().length > 128)
  {
    alert("���ղ������������!");
    return;
  }
  if(Aqsc_Device_Type_Edit.Technology.value.Trim().length > 128)
  {
    alert("�����������������!");
    return;
  }
  if(Aqsc_Device_Type_Edit.Des.value.Trim().length > 128)
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
	Aqsc_Device_Type_Edit.Card_List.value = Card_List;
  if(confirm("��Ϣ����,ȷ���ύ?"))
  {
  	Aqsc_Device_Type_Edit.submit();
  }
}
</SCRIPT>
</html>