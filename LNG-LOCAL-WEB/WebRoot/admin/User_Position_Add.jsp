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

	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Aqsc_Card_Type = (ArrayList)session.getAttribute("Aqsc_Card_Type_" + Sid);
	int cnt = 0;
	
%>
<body style="background:#CADFFF">
<form name="User_Position_Add" action="User_Position.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/cap_position_info.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="70%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
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
							<td width='80%' align='left' colspan=3>
								<input type='text' name='CName' style='width:96%;height:18px;' value='' maxlength='15'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='80%' align='left' colspan=3>
								<textarea name='Des' rows='6' cols='80' maxlength=128></textarea>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>�ر�֤��</td>
							<td width='80%' align='left' colspan=3>
								<table width='100%' border=0>
									<tr height='30px'>
									<%
									if(Aqsc_Card_Type != null)
									{
										Iterator carditer = Aqsc_Card_Type.iterator();
										while(carditer.hasNext())
										{
											AqscCardTypeBean CardType = (AqscCardTypeBean)carditer.next();
											if(CardType.getStatus().equals("0"))
											{											
												if(0 == cnt%2 && cnt > 0)
												{
									%>
													</tr>
													<tr height='30px'>
									<%
												}
									%>
												<td width='50%' align='left'>
													<input type='checkbox' id='checkbox<%=cnt%>' name='checkbox<%=cnt%>' value='<%=CardType.getId()%>'><%=CardType.getCName()%>
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
		</table>
	</div>
</div>
<input name="Cmd" type="hidden" value="10">
<input name="Id"  type="hidden" value="***">
<input name="Card_List" type="hidden" value="">
<input name="Sid" type="hidden" value="<%=Sid%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doNO()
{
	location = "User_Position.jsp?Sid=<%=Sid%>";
}

function doAdd()
{
  if(User_Position_Add.CName.value.Trim().length < 1)
  {
    alert("����������!");
    return;
  }
  if(User_Position_Add.Des.value.Trim().length > 128)
  {
    alert("�������������!");
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
	User_Position_Add.Card_List.value = Card_List;
  if(confirm("��Ϣ����,ȷ���ύ?"))
  {
  	User_Position_Add.submit();
  }
}
</SCRIPT>
</html>