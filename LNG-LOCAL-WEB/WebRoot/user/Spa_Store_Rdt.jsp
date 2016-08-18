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
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid      = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Spa_Type = CommUtil.StrToGB2312(request.getParameter("Spa_Type"));
	String Spa_Mode = CommUtil.StrToGB2312(request.getParameter("Spa_Mode"));
	
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Spa_Store   = (ArrayList)session.getAttribute("Spa_Store_" + Sid);
	
	String Spa_Type_Name = "";
	String Model = "";
	String Spa_Mode_Name = "/";
	String Spa_I_Cnt = "";
	String Spa_O_Cnt = "";
	String Spa_S_Cnt = "";
	String Spa_R_Cnt = "";
	String Unit = "";
	if(Spa_Store != null)
	{
		Iterator iterator = Spa_Store.iterator();
		while(iterator.hasNext())
		{
			SpaStoreBean Bean = (SpaStoreBean)iterator.next();
			if(Bean.getSpa_Type().equals(Spa_Type) && Bean.getSpa_Mode().equals(Spa_Mode))
			{
				Spa_Type_Name = Bean.getSpa_Type_Name();
				Model = Bean.getModel();
				Spa_I_Cnt = Bean.getSpa_I_Cnt();
				Spa_O_Cnt = Bean.getSpa_O_Cnt();
				Spa_S_Cnt = Bean.getSpa_S_Cnt();
				Spa_R_Cnt = Bean.getSpa_R_Cnt();
				Unit = Bean.getUnit();
				
				if(null != Model && Model.length() > 0)
				{
					String[] List = Model.split(",");
					if(List.length >= Integer.parseInt(Spa_Mode))
						Spa_Mode_Name = List[Integer.parseInt(Spa_Mode)-1];
				}			
			}
		}
	}
	
%>
<body style="background:#CADFFF">
<form name="Spa_Store_Rdt" action="Spa_Store.do" method="post" target="mFrame">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">					
		<tr height='30'>
			<td width='25%' align='center'>备品备件</td>
			<td width='75%' align='left'>
				<%=Spa_Type_Name%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>规格型号</td>
			<td width='75%' align='left'>
				<%=Spa_Mode_Name%>
			</td>
		</tr>						
		<tr height='30'>
			<td width='25%' align='center'>在库数量</td>
			<td width='75%' align='left'>
				<%=Spa_I_Cnt%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>出库数量</td>
			<td width='75%' align='left'>
				<%=Spa_O_Cnt%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>报废数量</td>
			<td width='75%' align='left'>
				<%=Spa_S_Cnt%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>保底存量</td>
			<td width='75%' align='left'>
				<input type='text' name='Spa_R_Cnt' style='width:60px;height:16px;' value='<%=Spa_R_Cnt%>' maxlength=4>							
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;位</td>
			<td width='75%' align='left'>
				<%=Unit%>
			</td>
		</tr>
		<tr height='40'>
			<td width='100%' align='center' colspan=2>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
			</td>
		</tr>
	</table>
	<input type="hidden" name="Cmd"      value="11">
	<input type="hidden" name="Sid"      value="<%=Sid%>">
	<input type="hidden" name="Spa_Type" value="<%=Spa_Type%>">
	<input type="hidden" name="Spa_Mode" value="<%=Spa_Mode%>">
	<input type="hidden" name="Cpm_Id"   value="">
	<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
	<input type="hidden" name="Func_Sub_Id"  value="<%=currStatus.getFunc_Sub_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doEdit()
{
	if(Spa_Store_Rdt.Spa_R_Cnt.value.Trim().length < 1 || Spa_Store_Rdt.Spa_R_Cnt.value < 0)
  {
  	alert("保底存量输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Spa_Store_Rdt.Spa_R_Cnt.value.length; i++)
	{
		if(isNaN(Spa_Store_Rdt.Spa_R_Cnt.value.charAt(i)))
	  {
	    alert("保底存量输入有误，请重新输入!");
	    return;
	  }
	}
  if(confirm("信息无误，确认提交?"))
  {
  	//Spa_Store_Rdt.Cpm_Id.value = parent.window.parent.frames.lFrame.document.getElementById('id').value;
		Spa_Store_Rdt.submit();
  }
}
</SCRIPT>
</html>