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
	
%>
<body style="background:#CADFFF">
<form name="Aqsc_Card_Type_Add" action="Aqsc_Card_Type.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/aqsc_card_type.gif"></div><br><br><br>
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
								<input type='text' name='CName' style='width:96%;height:18px;' value='' maxlength='32'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>��֤��λ</td>
							<td width='80%' align='left' colspan=3>
								<input type='text' name='Lssue_Dept' style='width:96%;height:18px;' value='' maxlength='32'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>��ѵ����</td>
							<td width='80%' align='left' colspan=3>
								<input type='text' name='Train_Dept' style='width:96%;height:18px;' value='' maxlength='32'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>���ܲ���</td>
							<td width='80%' align='left' colspan=3>
								<input type='text' name='Manag_Dept' style='width:96%;height:18px;' value='' maxlength='32'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>��������</td>
							<td width='80%' align='left' colspan=3>
								<input type='text' name='Review_Inteval' style='width:40px;height:18px;' value='' maxlength='3'> ��
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='80%' align='left' colspan=3>
								<textarea name='Des' rows='8' cols='69' maxlength=128></textarea>
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
<input name="Sid" type="hidden" value="<%=Sid%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doNO()
{
	location = "Aqsc_Card_Type.jsp?Sid=<%=Sid%>";
}

function doAdd()
{
  if(Aqsc_Card_Type_Add.CName.value.Trim().length < 1)
  {
    alert("����������!");
    return;
  }
  if(Aqsc_Card_Type_Add.Lssue_Dept.value.Trim().length < 1)
  {
    alert("�����뷢֤��λ!");
    return;
  }
  if(Aqsc_Card_Type_Add.Train_Dept.value.Trim().length < 1)
  {
    alert("��������ѵ����!");
    return;
  }
  if(Aqsc_Card_Type_Add.Manag_Dept.value.Trim().length < 1)
  {
    alert("���������ܲ���!");
    return;
  }
  if(Aqsc_Card_Type_Add.Review_Inteval.value.Trim().length < 1 || Aqsc_Card_Type_Add.Review_Inteval.value <= 0)
  {
  	alert("���븴�����Ѵ���,���ܵ�ԭ��\n\n  1.Ϊ�ա�\n\n  2.������ֵ��");
		return;
  }
	for(var i=0; i<Aqsc_Card_Type_Add.Review_Inteval.value.length; i++)
	{
		if(isNaN(Aqsc_Card_Type_Add.Review_Inteval.value.charAt(i)))
	  {
	    alert("���븴��������������������!");
	    return;
	  }
	}
  if(Aqsc_Card_Type_Add.Des.value.Trim().length > 128)
  {
    alert("�������������!");
    return;
  }
  if(confirm("��Ϣ����,ȷ���ύ?"))
  {
  	Aqsc_Card_Type_Add.submit();
  }
}
</SCRIPT>
</html>