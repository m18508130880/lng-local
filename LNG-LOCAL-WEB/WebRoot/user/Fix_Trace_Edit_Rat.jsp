<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Index = CommUtil.StrToGB2312(request.getParameter("Index"));
	
%>
<body style="background:#e0e6ed">
<form name="Fix_Trace_Edit_Rat" action="" method="post" target="_self">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
		<tr height='30'>
			<td width='30%' align='center'>开始日期</td>
			<td width='70%' align='left'>
				<input name='Rate_BTime' type='text' style='width:90%;height:18px;' value='' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
		</tr>
		<tr height='30'>
			<td width='30%' align='center'>结束日期</td>
			<td width='70%' align='left'>
				<input name='Rate_ETime' type='text' style='width:90%;height:18px;' value='' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
		</tr>
		<tr height='30'>
			<td width='30%' align='center'>进度描述</td>
			<td width='70%' align='left' id='Spa_From'>
				<input name='Rate_Memos' type='text' style='width:90%;height:16px;' value='' maxlength='64'>
			</td>
		</tr>
		<tr height='40'>
			<td width='100%' align='center' colspan=2>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doSave()'>
				<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>
			</td>
		</tr>
	</table>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doNO()
{
	parent.closeDiv();
}

function doSave()
{
	if(Fix_Trace_Edit_Rat.Rate_BTime.value.length < 1)
	{
		alert('请选择开始日期!');
		return;
	}
	if(Fix_Trace_Edit_Rat.Rate_ETime.value.length < 1)
	{
		alert('请选择结束日期!');
		return;
	}
	if(Fix_Trace_Edit_Rat.Rate_BTime.value > Fix_Trace_Edit_Rat.Rate_ETime.value)
	{
		alert('结束日期不可在开始日期之前!');
		return;
	}
	if(Fix_Trace_Edit_Rat.Rate_Memos.value.Trim().length < 1)
	{
		alert('请填写进度描述!');
		return;
	}
	
	var str_Value = Fix_Trace_Edit_Rat.Rate_BTime.value 
	              + '^' 
	              + Fix_Trace_Edit_Rat.Rate_ETime.value 
	              + '^' 
	              + Fix_Trace_Edit_Rat.Rate_Memos.value.Trim();
	
	var str_CName = (parseInt(<%=Index%>)+1) + '、' + '[' + Fix_Trace_Edit_Rat.Rate_BTime.value + ' - ' + Fix_Trace_Edit_Rat.Rate_ETime.value + '] ' + '[' + Fix_Trace_Edit_Rat.Rate_Memos.value.Trim() + ']';
	
	parent.document.getElementById('RatD<%=Index%>').innerHTML = "<img src='../skin/images/cmddel.gif' style='cursor:hand;' title='进度删除' onclick=\"doRateDel('<%=Index%>')\">"
																														 + "&nbsp;"
	                                                    			 + str_CName
	                                                    			 + "<input type='hidden' id='RatDValue<%=Index%>' name='RatDValue<%=Index%>' value='"+str_Value+"'>";
	parent.document.getElementById('RatD<%=Index%>').style.display = '';
	parent.closeDiv();
}
</SCRIPT>
</html>