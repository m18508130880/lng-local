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

	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	
	CurrStatus currStatus    = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Spa_Store      = (ArrayList)session.getAttribute("Spa_Store_" + Sid);
	ArrayList Spa_Store_Type = (ArrayList)session.getAttribute("Spa_Store_Type_" + Sid);
  UserInfoBean UserInfo    = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  
%>
<body style="background:#CADFFF">
<form name="Spa_Store_Add" action="Spa_Store.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/spa_store_add.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="50%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
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
							<td width='25%' align='center'>备品备件</td>
							<td width='75%' align='left'>
								<select id="Spa_Type_Chg" name="Spa_Type_Chg" style="width:200px;height:20px" onchange="doChange(this.value)">
								<%
								if(null != Spa_Store_Type)
								{
									Iterator typeiter = Spa_Store_Type.iterator();
									while(typeiter.hasNext())
									{
										AqscSpareTypeBean typeBean = (AqscSpareTypeBean)typeiter.next();
										if(typeBean.getStatus().equals("0"))
										{
								%>
											<option value='<%=typeBean.getId()+"^"+typeBean.getModel()%>'><%=typeBean.getCName()%></option>
								<%
										}
									}
								}
								%>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>规格型号</td>
							<td width='75%' align='left'>
								<select id="Spa_Mode" name="Spa_Mode" style="width:200px;height:20px">
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>保底存量</td>
							<td width='75%' align='left'>
								<input type='text' name="Spa_R_Cnt" style="width:196px;height:16px" value="10" maxlength=4>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>录入人员</td>
							<td width='75%' align='left'>
								<%=Operator_Name%>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input type="hidden" name="Cmd"      value="11">
<input type="hidden" name="Sid"      value="<%=Sid%>">
<input type="hidden" name="Spa_Type" value="">
<input type="hidden" name="Operator" value="<%=Operator%>">
<input type="hidden" name="Cpm_Id"   value="">
<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
<input type="hidden" name="Func_Sub_Id"  value="<%=currStatus.getFunc_Sub_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Spa_Store_Add.jsp';

function doNO()
{
	location = "Spa_Store.jsp?Sid=<%=Sid%>";
}

function doChange(pId)
{
	//先删除
	var length = document.getElementById('Spa_Mode').length;
	for(var i=0; i<length; i++)
	{
		document.getElementById('Spa_Mode').remove(0);
	}
	
	//再添加
	if(pId.length > 0)
	{
		var Type    = pId.split('^')[0];
		var str_Now = '';
		<%
		if(null != Spa_Store)
		{
			Iterator riter = Spa_Store.iterator();
			while(riter.hasNext())
			{
				SpaStoreBean rBean = (SpaStoreBean)riter.next();
		%>
				if('<%=rBean.getSpa_Type()%>' == Type)
				{
					str_Now += '<%=rBean.getSpa_Mode()%>' + ',';
				}
		<%
			}
		}
		%>
		
		var Mode = pId.split('^')[1];
		var List = Mode.split(',');
		for(var i=0; i<List.length; i++)
		{
			//if(str_Now.indexOf(StrLeftFillZero((i+1)+'', 4)) < 0)
			//{
				var objOption = document.createElement('OPTION');
				objOption.value = StrLeftFillZero((i+1)+'', 4);
				objOption.text  = List[i];
				document.getElementById('Spa_Mode').add(objOption);
			//}
		}
	}
}
doChange(Spa_Store_Add.Spa_Type_Chg.value);

function doAdd()
{
  if(Spa_Store_Add.Spa_Type_Chg.value.length < 1)
  {
  	alert('请选择备品备件!');
  	return;
  }
	if(Spa_Store_Add.Spa_Mode.value.length < 1)
  {
  	alert('请选择规格型号!');
  	return;
  }
  if(Spa_Store_Add.Spa_R_Cnt.value.Trim().length < 1 || Spa_Store_Add.Spa_R_Cnt.value < 0)
  {
  	alert("保底存量输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Spa_Store_Add.Spa_R_Cnt.value.length; i++)
	{
		if(isNaN(Spa_Store_Add.Spa_R_Cnt.value.charAt(i)))
	  {
	    alert("保底存量输入有误，请重新输入!");
	    return;
	  }
	}
	
  Spa_Store_Add.Spa_Type.value = Spa_Store_Add.Spa_Type_Chg.value.split('^')[0];
  if(confirm("信息无误，确认提交?"))
  {
  	//Spa_Store_Add.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
		Spa_Store_Add.submit();
  }
}
</SCRIPT>
</html>