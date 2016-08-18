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
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Aqsc_Spare_Type = (ArrayList)session.getAttribute("Aqsc_Spare_Type_" + Sid);
	
 	String Id = request.getParameter("Id");
  String CName = "";
	String Status = "0";
	String Des = "";
	String CType = "";
	String Model = "";
	String Unit = "";
	String Brand = "";
	String Seller = "";
	if(Aqsc_Spare_Type != null)
	{
		Iterator iterator = Aqsc_Spare_Type.iterator();
		while(iterator.hasNext())
		{
			AqscSpareTypeBean statBean = (AqscSpareTypeBean)iterator.next();
			if(statBean.getId().equals(Id))
			{
				CName = statBean.getCName();
				Status = statBean.getStatus();
				Des = statBean.getDes();				
				CType = statBean.getCType();
				Model = statBean.getModel();
				Unit = statBean.getUnit();
				Brand = statBean.getBrand();
				Seller = statBean.getSeller();				
				if(null == Des){Des = "";}				
			}
		}
 	}
 	
%>
<body style="background:#CADFFF">
<form name="Aqsc_Spare_Type_Edit" action="Aqsc_Spare_Type.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/aqsc_spare_type.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="60%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30'>
				<td width='100%' align='right'>
					<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
					<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>
				</td>
			</tr>
			<tr height='30'>
				<td width='100%' align='center'>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
						<tr height='30'>
							<td width='20%' align='center'>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号</td>
							<td width='30%' align='left'>
								<%=Id%>
							</td>
							<td width='20%' align='center'>状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态</td>
							<td width='30%' align='left'>
							  <select name="Status" style="width:92%;height:20px;">
							  	<option value='0' <%=Status.equals("0")?"selected":""%>>启用</option>
							  	<option value='1' <%=Status.equals("1")?"selected":""%>>注销</option>
							  </select>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称</td>
							<td width='80%' align='left' colspan=3>
								<input type='text' name='CName' style='width:96%;height:18px;' value='<%=CName%>' maxlength='32'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>类&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;型</td>
							<td width='30%' align='left'>
								<select name="CType" style="width:92%;height:20px;">
									<option value='1' <%=CType.equals("1")?"selected":""%>>电气类</option>
									<option value='2' <%=CType.equals("2")?"selected":""%>>工艺类</option>
								</select>
							</td>
							<td width='20%' align='center'>单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;位</td>
							<td width='30%' align='left'>
								<input type='text' name='Unit' style='width:90%;height:18px;' value='<%=Unit%>' maxlength='5'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>型&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号</td>
							<td width='80%' align='left' colspan=3>
								<input type='text' name='Model' style='width:96%;height:18px;' value='<%=Model%>' maxlength='128'>
							</td>						
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>品&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;牌</td>
							<td width='30%' align='left'>
								<input type='text' name='Brand' style='width:90%;height:18px;' value='<%=Brand%>' maxlength='15'>
							</td>
							<td width='20%' align='center'>供货单位</td>
							<td width='30%' align='left'>
								<input type='text' name='Seller' style='width:90%;height:18px;' value='<%=Seller%>' maxlength='32'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>描&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;述</td>
							<td width='80%' align='left' colspan=3>
								<textarea name='Des' rows='8' cols='69' maxlength=128><%=Des%></textarea>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input name="Cmd" type="hidden" value="11">
<input name="Id"  type="hidden" value="<%=Id%>">
<input name="Sid" type="hidden" value="<%=Sid%>">
<input name="Func_Sub_Id" type="hidden" value="<%=currStatus.getFunc_Sub_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doNO()
{
	location = "Aqsc_Spare_Type.jsp?Sid=<%=Sid%>";
}

function doEdit()
{
  if(Aqsc_Spare_Type_Edit.CName.value.Trim().length < 1)
  {
    alert("请输入名称!");
    return;
  }
  if(Aqsc_Spare_Type_Edit.Unit.value.Trim().length < 1)
  {
    alert("请输入单位!");
    return;
  }
  if(Aqsc_Spare_Type_Edit.Model.value.Trim().length < 1)
  {
    alert("请输入型号!");
    return;
  }
  if(Aqsc_Spare_Type_Edit.Brand.value.Trim().length < 1)
  {
    alert("请输入品牌!");
    return;
  }
  if(Aqsc_Spare_Type_Edit.Seller.value.Trim().length < 1)
  {
    alert("请输入供货单位!");
    return;
  }
  if(Aqsc_Spare_Type_Edit.Des.value.Trim().length > 128)
  {
    alert("描述过长，请简化!");
    return;
  }
  if(confirm("信息无误,确定提交?"))
  {
  	Aqsc_Spare_Type_Edit.submit();
  }
}
</SCRIPT>
</html>