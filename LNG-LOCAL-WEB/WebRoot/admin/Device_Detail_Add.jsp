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
	String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
 	String Station_Info = "";
	if(null != Corp_Info)
	{
		Station_Info = Corp_Info.getStation_Info();
		if(null == Station_Info)
		{
			Station_Info = "";
		}
	}
	
%>
<body style="background:#CADFFF">
<form name="Device_Detail_Add" action="Device_Detail.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/device_detail.gif"></div><br><br><br>
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
								<input type='text' name='Id' style='width:90%;height:18px;' value='' maxlength='10'>							
							</td>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<input type='text' name='CName' style='width:90%;height:18px;' value='' maxlength='15'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<input type='text' name='Pwd' style='width:90%;height:18px;' value='' maxlength='20'>
							</td>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<input type='text' name='Brief' style='width:90%;height:18px;' value='' maxlength='5'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>״&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;̬</td>
							<td width='30%' align='left'>								
							  <select name="Status" style="width:92%;height:20px;">
							  	<option value='0'>����</option>
							  	<option value='1'>ע��</option>
							  </select>								
							</td>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
							<td width='30%' align='left'>
								<select name="CType" style="width:92%;height:20px">
								<%
								if(Station_Info.trim().length() > 0)
								{
									String[] StationList = Station_Info.split(",");
								  String pCType_Id = "";
								  String pCType_Name = "";
								  for(int i=0; i<StationList.length; i++)
								  {
										pCType_Id = CommUtil.IntToStringLeftFillZero(i+1, 4);
										pCType_Name = StationList[i];
								%>
								    <option value="<%=pCType_Id%>"><%=pCType_Name%></option>
								<%
		    					}
								}
								%>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>Ͷ��ʱ��</td>
							<td width='30%' align='left'>
								<input name='CTime' type='text' style='width:90%;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
							<td width='20%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ע</td>
							<td width='30%' align='left'>
								<input type='text' name='Memo' style='width:90%;height:18px;' value='' maxlength='64'>
							</td>
						</tr>			
						<tr height='30'>
							<td width='20%' align='center'>����IP</td>
							<td width='30%' align='left'>
								<input type='text' name='Link_Url'  style='width:90%;height:18px;' value='' maxlength='20'>
							</td>
							<td width='20%' align='center'>����Port</td>
							<td width='30%' align='left'>
								<input type='text' name='Link_Port' style='width:90%;height:18px;' value='' maxlength='6'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>�����˻�</td>
							<td width='30%' align='left'>
								<input type='text' name='Link_Id'  style='width:90%;height:18px;' value='' maxlength='20'>
							</td>
							<td width='20%' align='center'>��������</td>
							<td width='30%' align='left'>
								<input type='text' name='Link_Pwd' style='width:90%;height:18px;' value='' maxlength='6'>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input name="Cmd" type="hidden" value="10">
<input name="Sid" type="hidden" value="<%=Sid%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doNO()
{
	location = "Device_Detail.jsp?Sid=<%=Sid%>";
}

function doAdd()
{
  if(Device_Detail_Add.Id.value.Trim().length != 10)
  {
    alert("������10λ���!");
    return;
  }
  if(Device_Detail_Add.CName.value.Trim().length < 1)
  {
    alert("����������!");
    return;
  }
  if(Device_Detail_Add.Brief.value.Trim().length < 1)
  {
    alert("��������!");
    return;
  }
  if(Device_Detail_Add.CType.value.Trim().length < 1)
  {
    alert("��ѡ������!");
    return;
  }
  if(Device_Detail_Add.CTime.value.Trim().length < 1)
  {
    alert("������Ͷ��ʱ��!");
    return;
  }
  if(confirm("��Ϣ����,ȷ���ύ?"))
  {
  	Device_Detail_Add.submit();
  }
}
</SCRIPT>
</html>