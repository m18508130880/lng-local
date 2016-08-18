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
	ArrayList Lab_Store_Type = (ArrayList)session.getAttribute("Lab_Store_Type_" + Sid);
	ArrayList Lab_Store      = (ArrayList)session.getAttribute("Lab_Store_" + Sid);
  UserInfoBean UserInfo    = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  
%>
<body style="background:#CADFFF">
<form name="Lab_Store_Add" action="Lab_Store.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/lab_store_add.gif"></div><br><br><br>
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
							<td width='25%' align='center'>用品类型</td>
							<td width='75%' align='left'>
								<select id="Lab_Type_Chg" name="Lab_Type_Chg" style="width:200px;height:20px" onchange="doChange(this.value)">
								<%
								if(null != Lab_Store_Type)
								{
									Iterator typeiter = Lab_Store_Type.iterator();
									while(typeiter.hasNext())
									{
										AqscLabourTypeBean typeBean = (AqscLabourTypeBean)typeiter.next();
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
								<select id="Lab_Mode" name="Lab_Mode" style="width:200px;height:20px">
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>保底存量</td>
							<td width='75%' align='left'>
								<input type='text' name="Lab_A_Cnt" style="width:196px;height:16px" maxlength='4'>
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
<input type="hidden" name="Lab_Type" value="">
<input type="hidden" name="Operator" value="<%=Operator%>">
<input type="hidden" name="Cpm_Id"   value="">
<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Lab_Store_Add.jsp';

function doNO()
{
	location = "Lab_Store.jsp?Sid=<%=Sid%>";
}

function doChange(pId)
{
	//先删除
	var length = document.getElementById('Lab_Mode').length;
	for(var i=0; i<length; i++)
	{
		document.getElementById('Lab_Mode').remove(0);
	}
	
	//再添加
	if(pId.length > 0)
	{
		var Type    = pId.split('^')[0];
		var str_Now = '';
		<%
		if(null != Lab_Store)
		{
			Iterator riter = Lab_Store.iterator();
			while(riter.hasNext())
			{
				LabStoreBean rBean = (LabStoreBean)riter.next();
		%>
				if('<%=rBean.getLab_Type()%>' == Type)
				{
					str_Now += '<%=rBean.getLab_Mode()%>' + ',';
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
				document.getElementById('Lab_Mode').add(objOption);
			//}
		}
	}
}
doChange(Lab_Store_Add.Lab_Type_Chg.value);

function doAdd()
{
  if(Lab_Store_Add.Lab_Type_Chg.value.length < 1)
  {
  	alert('请选择用品类型!');
  	return;
  }
	if(Lab_Store_Add.Lab_Mode.value.length < 1)
  {
  	alert('请选择规格型号!');
  	return;
  }
  if(Lab_Store_Add.Lab_A_Cnt.value.Trim().length < 1 || Lab_Store_Add.Lab_A_Cnt.value <= 0)
  {
  	alert("保底存量输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Lab_Store_Add.Lab_A_Cnt.value.length; i++)
	{
		if(isNaN(Lab_Store_Add.Lab_A_Cnt.value.charAt(i)))
	  {
	    alert("保底存量输入有误，请重新输入!");
	    return;
	  }
	}
  Lab_Store_Add.Lab_Type.value = Lab_Store_Add.Lab_Type_Chg.value.split('^')[0];
  if(confirm("信息无误，确认提交?"))
  {
  	//Lab_Store_Add.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
		Lab_Store_Add.submit();
  }
}
</SCRIPT>
</html>