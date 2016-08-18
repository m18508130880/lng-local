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
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String CType = CommUtil.StrToGB2312(request.getParameter("CType"));
	String SN    = CommUtil.StrToGB2312(request.getParameter("SN"));
	
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Spa_Store   = (ArrayList)session.getAttribute("Spa_Store_" + Sid);
	ArrayList Spa_Store_I = (ArrayList)session.getAttribute("Spa_Store_I_" + Sid);
  UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  
  String Spa_Type      = "";
  String Spa_Mode      = "";
  String Spa_I_Time    = "";
  String Spa_I_Numb    = "";
  String Spa_I_Cnt     = "";
  String Spa_I_Price   = "";
  String Spa_I_Amt     = "";
  String Spa_I_Memo    = "";
  String Operator_Name = "";
  
  String Status         = "";
	String Status_OP_Name = "";
	String Status_Memo    = "";
  if(Spa_Store_I != null)
	{
		Iterator iterator = Spa_Store_I.iterator();
		while(iterator.hasNext())
		{
			SpaStoreIBean Bean = (SpaStoreIBean)iterator.next();
			if(Bean.getSN().equals(SN))
			{
				Spa_Type      = Bean.getSpa_Type();
			  Spa_Mode      = Bean.getSpa_Mode();
			  Spa_I_Time    = Bean.getSpa_I_Time();
			  Spa_I_Numb    = Bean.getSpa_I_Numb();
			  Spa_I_Cnt     = Bean.getSpa_I_Cnt();
			  Spa_I_Price   = Bean.getSpa_I_Price();
			  Spa_I_Amt     = Bean.getSpa_I_Amt();
			  Spa_I_Memo    = Bean.getSpa_I_Memo();
			  Operator_Name = Bean.getOperator_Name();
			  
			  Status         = Bean.getStatus();
				Status_OP_Name = Bean.getStatus_OP_Name();
				Status_Memo    = Bean.getStatus_Memo();
				if(null == Status_OP_Name){Status_OP_Name = "";}
				if(null == Status_Memo){Status_Memo = "";}
			}
		}
	}
	
%>
<body style="background:#CADFFF">
<form name="Spa_Store_I_Edt" action="Spa_Store_I.do" method="post" target="mFrame">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
	<%
	switch(Integer.parseInt(CType))
	{
		case 1:
	%>
				<tr height='30'>
					<td width='25%' align='center'>备品备件</td>
					<td width='75%' align='left'>
						<select name="Spa_Type_Chg" style="width:250px;height:20px">
						<%
						if(null != Spa_Store)
						{
							Iterator typeiter = Spa_Store.iterator();
							while(typeiter.hasNext())
							{
								SpaStoreBean typeBean = (SpaStoreBean)typeiter.next();										
								String type_Id = typeBean.getSpa_Type();
								String type_Name = typeBean.getSpa_Type_Name();
								String type_Mode = typeBean.getSpa_Mode();
								String type_Model = typeBean.getModel();										
								String type_Mode_Name = "/";
								if(null != type_Model && type_Model.length() > 0)
								{
									String[] List = type_Model.split(",");
									if(List.length >= Integer.parseInt(type_Mode))
										type_Mode_Name = List[Integer.parseInt(type_Mode)-1];
								}
						%>
								<option value='<%=type_Id+type_Mode%>' <%=(Spa_Type+Spa_Mode).equals(type_Id+type_Mode)?"selected":""%>><%=type_Name%>{型号:<%=type_Mode_Name%>}</option>
						<%										
							}
						}
						%>
						</select>
					</td>
				</tr>
				<tr height='30'>
					<td width='25%' align='center'>申购时间</td>
					<td width='75%' align='left'>
						<input name='Spa_I_Time' type='text' style='width:248px;height:18px;' value='<%=Spa_I_Time%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
					</td>
				</tr>
				<tr height='30'>
					<td width='25%' align='center'>申购单号</td>
					<td width='75%' align='left'>
						<input name='Spa_I_Numb' type='text' style='width:248px;height:18px;' value='<%=Spa_I_Numb%>' maxlength=20>
					</td>
				</tr>
				<tr height='30'>
					<td width='25%' align='center'>申购数量</td>
					<td width='75%' align='left'>
						<input name='Spa_I_Cnt' type='text' style='width:248px;height:18px;' value='<%=Spa_I_Cnt%>' maxlength=4>
					</td>
				</tr>
				<tr height='30'>
					<td width='25%' align='center'>申购单价</td>
					<td width='75%' align='left'>
						<input name='Spa_I_Price' type='text' style='width:248px;height:18px;' value='<%=Spa_I_Price%>' maxlength=8>
					</td>
				</tr>
				<tr height='30'>
					<td width='25%' align='center'>申购金额</td>
					<td width='75%' align='left'>
					  <input name='Spa_I_Amt' type='text' style='width:248px;height:18px;' value='<%=Spa_I_Amt%>' maxlength='8'>
					</td>
				</tr>
				<tr height='30'>
					<td width='25%' align='center'>申购备注</td>
					<td width='75%' align='left'>
						<textarea name='Spa_I_Memo' rows='5' cols='33' maxlength=128><%=Spa_I_Memo%></textarea>
					</td>
				</tr>
				<tr height='30'>
					<td width='25%' align='center'>申购人员</td>
					<td width='75%' align='left'>
						<%=Operator_Name%>
					</td>
				</tr>
	<%
			break;
		case 2:
	%>
				<input type='hidden' name='Spa_I_Numb' value='<%=Spa_I_Numb%>'>
				<tr height='40'>
					<td width='25%' align='center'>审核状态</td>
					<td width='75%' align='left'>
						<input type='radio' id='radio1' name='radio1' value='1' onclick="doChange(1)">审核通过
						&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input type='radio' id='radio2' name='radio2' value='2' onclick="doChange(2)">审核无效
					</td>
				</tr>
				<tr height='30'>
					<td width='25%' align='center'>审核备注</td>
					<td width='75%' align='left'>
						<textarea name='Status_Memo' rows='5' cols='61' maxlength=128><%=Status_Memo%></textarea>
					</td>
				</tr>
				<tr height='30'>
					<td width='25%' align='center'>审核人员</td>
					<td width='75%' align='left'>
						<%=Status_OP_Name%>&nbsp;
					</td>
				</tr>
				<tr height='30'>
					<td width='25%' align='center'>一键审批</td>
					<td width='75%' align='left'>
						<input type='checkbox' id='checkbox1' name='checkbox1' value='1' checked>同一申购单号一键审批
					</td>
				</tr>
	<%
			break;
	}
	%>
		
		<tr height='40'>
			<td width='100%' align='center' colspan=2>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
			</td>
		</tr>
	</table>
	<input type="hidden" name="Cmd"       value="11">
	<input type="hidden" name="Sid"       value="<%=Sid%>">
	<input type="hidden" name="SN"        value="<%=SN%>">
	<input type="hidden" name="Spa_Type"  value="">
	<input type="hidden" name="Spa_Mode"  value="">
	<input type="hidden" name="Status"    value="">
	<input type="hidden" name="Operator"  value="<%=Operator%>">
	<input type="hidden" name="Status_OP" value="<%=Operator%>">
	<input type="hidden" name="Cpm_Id"    value="">
	<input type="hidden" name="BTime"     value="<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>">
	<input type="hidden" name="ETime"     value="<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>">
	<input type="hidden" name="CurrPage"  value="<%=currStatus.getCurrPage()%>">
	<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
	<input type="hidden" name="Func_Sub_Id"  value="<%=currStatus.getFunc_Sub_Id()%>">
	<input type="hidden" name="Func_Sel_Id"  value="<%=currStatus.getFunc_Sel_Id()%>">
	<input type="hidden" name="Func_Type_Id" value="<%=currStatus.getFunc_Type_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doChange(pIndex)
{
	switch(parseInt(pIndex))
	{
		case 1:
				document.getElementById('radio1').checked = true;
				document.getElementById('radio2').checked = false;
			break;
		case 2:
				document.getElementById('radio1').checked = false;
				document.getElementById('radio2').checked = true;
			break;
	}
}

function doEdit()
{
	switch(parseInt(<%=CType%>))
	{
		case 1:
				if(Spa_Store_I_Edt.Spa_Type_Chg.value.length < 1)
			  {
			  	alert('请选择备品备件!');
			  	return;
			  }
				if(Spa_Store_I_Edt.Spa_I_Time.value.length < 1)
			  {
			  	alert('请选择申购时间!');
			  	return;
			  }
			  if(Spa_Store_I_Edt.Spa_I_Numb.value.Trim().length < 1)
			  {
			  	alert('请填写申购单号!');
			  	return;
			  }
			  if(Spa_Store_I_Edt.Spa_I_Cnt.value.Trim().length < 1 || Spa_Store_I_Edt.Spa_I_Cnt.value <= 0)
			  {
			  	alert("申购数量输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
					return;
			  }
			  for(var i=0; i<Spa_Store_I_Edt.Spa_I_Cnt.value.length; i++)
				{
					if(isNaN(Spa_Store_I_Edt.Spa_I_Cnt.value.charAt(i)))
				  {
				    alert("申购数量输入有误，请重新输入!");
				    return;
				  }
				}
				if(Spa_Store_I_Edt.Spa_I_Price.value.Trim().length < 1 || Spa_Store_I_Edt.Spa_I_Price.value <= 0)
			  {
			  	alert("申购单价错误,可能的原因：\n\n  1.申购单价为空。\n\n  2.申购单价不是正值。");
					return;
			  }
				for(var i=0; i<Spa_Store_I_Edt.Spa_I_Price.value.length; i++)
				{
					if(Spa_Store_I_Edt.Spa_I_Price.value.charAt(0) == '.' || Spa_Store_I_Edt.Spa_I_Price.value.charAt(Spa_Store_I_Edt.Spa_I_Price.value.length-1) == '.')
					{
						alert("输入申购单价有误，请重新输入!");
				    return;
					}
					if(Spa_Store_I_Edt.Spa_I_Price.value.charAt(i) != '.' && isNaN(Spa_Store_I_Edt.Spa_I_Price.value.charAt(i)))
				  {
				    alert("输入申购单价有误，请重新输入!");
				    return;
				  }
				}
				if(Spa_Store_I_Edt.Spa_I_Price.value.indexOf(".") != -1)
				{
					if(Spa_Store_I_Edt.Spa_I_Price.value.substring(Spa_Store_I_Edt.Spa_I_Price.value.indexOf(".")+1,Spa_Store_I_Edt.Spa_I_Price.value.length).length >2)
					{
						alert("申购单价小数点后最多只能输入两位!");
						return;
					}
				}
				if(Spa_Store_I_Edt.Spa_I_Amt.value.Trim().length < 1 || Spa_Store_I_Edt.Spa_I_Amt.value <= 0)
			  {
			  	alert("申购金额错误,可能的原因：\n\n  1.申购金额为空。\n\n  2.申购金额不是正值。");
					return;
			  }
				for(var i=0; i<Spa_Store_I_Edt.Spa_I_Amt.value.length; i++)
				{
					if(Spa_Store_I_Edt.Spa_I_Amt.value.charAt(0) == '.' || Spa_Store_I_Edt.Spa_I_Amt.value.charAt(Spa_Store_I_Edt.Spa_I_Amt.value.length-1) == '.')
					{
						alert("输入申购金额有误，请重新输入!");
				    return;
					}
					if(Spa_Store_I_Edt.Spa_I_Amt.value.charAt(i) != '.' && isNaN(Spa_Store_I_Edt.Spa_I_Amt.value.charAt(i)))
				  {
				    alert("输入申购金额有误，请重新输入!");
				    return;
				  }
				}
				if(Spa_Store_I_Edt.Spa_I_Amt.value.indexOf(".") != -1)
				{
					if(Spa_Store_I_Edt.Spa_I_Amt.value.substring(Spa_Store_I_Edt.Spa_I_Amt.value.indexOf(".")+1,Spa_Store_I_Edt.Spa_I_Amt.value.length).length >2)
					{
						alert("申购金额小数点后最多只能输入两位!");
						return;
					}
				}
				if(Spa_Store_I_Edt.Spa_I_Memo.value.Trim().length < 1)
				{
					alert('请简要填写申购备注!');
					return;
				}
				if(Spa_Store_I_Edt.Spa_I_Memo.value.Trim().length > 128)
			  {
			    alert("申购备注描述过长，请简化!");
			    return;
			  }
			  if(confirm("信息无误，确认提交?"))
			  {
			  	Spa_Store_I_Edt.Cmd.value      = 11;
			  //	Spa_Store_I_Edt.Cpm_Id.value   = parent.window.parent.frames.lFrame.document.getElementById('id').value;
			  	Spa_Store_I_Edt.Spa_Type.value = Spa_Store_I_Edt.Spa_Type_Chg.value.substring(0,4);
			  	Spa_Store_I_Edt.Spa_Mode.value = Spa_Store_I_Edt.Spa_Type_Chg.value.substring(4,8);
					Spa_Store_I_Edt.submit();
			  }
			break;
		case 2:
				var Status = '';
				for(var i=1; i<=2; i++)
				{
					if(document.getElementById('radio'+i).checked)
						Status = document.getElementById('radio'+i).value;
				}
				if(Status.length < 1)
				{
					alert('请选择审核结果状态!');
					return;
				}
				if(confirm("信息无误，确认提交?"))
			  {
			  	if(document.getElementById('checkbox1').checked)
					  Spa_Store_I_Edt.Cmd.value  = 13;
					else
						Spa_Store_I_Edt.Cmd.value  = 12;
						
			  	//Spa_Store_I_Edt.Cpm_Id.value = parent.window.parent.frames.lFrame.document.getElementById('id').value;
					Spa_Store_I_Edt.Status.value = Status;
					Spa_Store_I_Edt.submit();
			  }
			break;
	}
}
</SCRIPT>
</html>