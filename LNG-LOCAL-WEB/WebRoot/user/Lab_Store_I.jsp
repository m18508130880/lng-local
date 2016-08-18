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
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	String Operator = UserInfo.getId();
	String FpId   = UserInfo.getFp_Role();
	String FpList = "";
	if(null != FpId && FpId.length() > 0 && null != User_FP_Role)
	{
		Iterator roleiter = User_FP_Role.iterator();
		while(roleiter.hasNext())
		{
			UserRoleBean roleBean = (UserRoleBean)roleiter.next();
			if(roleBean.getId().equals(FpId) && null != roleBean.getPoint())
			{
				FpList = roleBean.getPoint();
			}
		}
	}
 	
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	
	ArrayList Lab_Store_I = (ArrayList)session.getAttribute("Lab_Store_I_" + Sid);
	ArrayList Lab_Store   = (ArrayList)session.getAttribute("Lab_Store_" + Sid);
  int sn = 0;
  
%>
<body style=" background:#CADFFF">
<form name="Lab_Store_I"  action="Lab_Store_I.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='80%' align='left'>
				用品类型:
				<select name='Func_Corp_Id' style='width:120px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Lab_Store)
					{
						String c_Type = "";
						Iterator typeiter = Lab_Store.iterator();
						while(typeiter.hasNext())
						{
							LabStoreBean typeBean = (LabStoreBean)typeiter.next();
							if(!typeBean.getLab_Type().equals(c_Type))
							{
					%>
								<option value='<%=typeBean.getLab_Type()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getLab_Type())?"selected":""%>><%=typeBean.getLab_Type_Name()%></option>
					<%
							}
							c_Type = typeBean.getLab_Type();
						}
					}
					%>
				</select>
				记录状态:
				<select name='Func_Sub_Id' style='width:130px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sub_Id() == 9 ? "selected":""%>>全部</option>
					<option value='0' <%=currStatus.getFunc_Sub_Id() == 0 ? "selected":""%>>待审核</option>
					<option value='1' <%=currStatus.getFunc_Sub_Id() == 1 ? "selected":""%>>审核有效</option>
					<option value='2' <%=currStatus.getFunc_Sub_Id() == 2 ? "selected":""%>>审核无效</option>
				</select>
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				-
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				申购单号:<input type='text' name='Func_Type_Id' style='width:100px;height:16px;' value='<%=currStatus.getFunc_Type_Id()%>'>
			</td>
			<td width='20%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='110202' ctype='1'/>">
				<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()'    style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='110203' ctype='1'/>">
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='5%'  align='center' class="table_deep_blue"> 序号      </td>
						<td width='8%' align='center' class="table_deep_blue"> 产品名称  </td>
						<td width='15%' align='center' class="table_deep_blue"> 规格型号  </td>
						<td width='8%' align='center' class="table_deep_blue"> 申购时间  </td>
						<td width='40%' align='center' class="table_deep_blue"> 申购信息  </td>
						<td width='24%' align='center' class="table_deep_blue"> 审核状态  </td>
					</tr>
					<%
					if(Lab_Store_I != null)
					{
						Iterator iterator = Lab_Store_I.iterator();
						while(iterator.hasNext())
						{
							LabStoreIBean Bean = (LabStoreIBean)iterator.next();
							String SN            = Bean.getSN();
							String Lab_Type_Name = Bean.getLab_Type_Name();
							String Lab_Mode      = Bean.getLab_Mode();
							String Model         = Bean.getModel();
							String Lab_I_Time    = Bean.getLab_I_Time();
							String Lab_Mode_Name = "/";
							if(null != Model && Model.length() > 0)
							{
								String[] List = Model.split(",");
								if(List.length >= Integer.parseInt(Lab_Mode))
									Lab_Mode_Name = List[Integer.parseInt(Lab_Mode)-1];
							}
							
							//申购信息
							String Lab_I_Numb    = Bean.getLab_I_Numb();
							String Lab_I_Cnt     = Bean.getLab_I_Cnt();
							String Lab_I_Price   = Bean.getLab_I_Price();
							String Lab_I_Amt     = Bean.getLab_I_Amt();
							String Lab_I_Memo    = Bean.getLab_I_Memo();
							String Operator_Name = Bean.getOperator_Name();
							String str_Des1    =  "数量:<font color=red>" + Lab_I_Cnt+"个</font>"
							                   + "&nbsp;&nbsp;&nbsp;"
							                   + "单价: " + Lab_I_Price+"元"
							                   + "&nbsp;&nbsp;&nbsp;"
							                   + "金额: " + Lab_I_Amt+"元"
							                   + "&nbsp;&nbsp;&nbsp;"
							                   + "备注: " + Lab_I_Memo;
							                  
							                   
							         
							
							//审核信息
							String Status         = Bean.getStatus();
							String Status_OP_Name = Bean.getStatus_OP_Name();
							String Status_Memo    = Bean.getStatus_Memo();
							if(null == Status_OP_Name){Status_OP_Name = "";}
							if(null == Status_Memo){Status_Memo = "";}
							
							String str_Des2       = "";
							switch(Integer.parseInt(Status))
							{
								case 0:
										str_Des2 = "状态: " + "<font color=red>待审核</font>"
										         + "&nbsp;&nbsp;&nbsp;"
										         + "审核人员: " + Status_OP_Name
										         + "&nbsp;&nbsp;&nbsp;"
										         + "备注: " + Status_Memo;
										   
									break;
								case 1:
										str_Des2 = "状态: " + "<font color=green>有效</font>"
										         + "&nbsp;&nbsp;&nbsp;"
										         + "审核人员: " + Status_OP_Name
										         + "&nbsp;&nbsp;&nbsp;"
										         + "备注: " + Status_Memo;										 
									break;
								case 2:
										str_Des2 = "状态: " + "<font color=gray>无效</font>"
										         + "&nbsp;&nbsp;&nbsp;"
										         + "审核人员: " + Status_OP_Name
										         + "&nbsp;&nbsp;&nbsp;"
										         + "备注: " + Status_Memo;
									break;
							}
							
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%> >
								<td align=center> <%=sn%> </td>
								<td align=left> <%=Lab_Type_Name%> </td>
						    <td align=left> <%=Lab_Mode_Name%> </td>
						    <td align=center> <%=Lab_I_Time%> </td>
						    <td align=center valign=top style='cursor:hand;' title='编辑申购信息' onclick="doEdit01('<%=SN%>', '<%=Status%>')"><%=str_Des1%></td>
						    <td align=center valign=top style='cursor:hand;' title='审核申购信息' onclick="doEdit02('<%=SN%>', '<%=Status%>')"><%=str_Des2%></td>
							</tr>
					<%
						}
					}
					for(int i=0;i<(MsgBean.CONST_PAGE_SIZE - sn);i++)
					{
						if(sn % 2 != 0)
					  {
					%>   				  
				      <tr <%=((i%2)==0?"class='table_blue'":"class='table_white_l'")%>>
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%> 
     		 	<tr>
						<td colspan="6" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Lab_Store_I")%></td>
			    			</tr>			    		
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd"    value="0">
<input type="hidden" name="Sid"    value="<%=Sid%>">
<input type="hidden" name="Cpm_Id" value="">
<input type="hidden" name="BTime"  value="">
<input type="hidden" name="ETime"  value="">
<input type="hidden" name="CurrPage" value="<%=currStatus.getCurrPage()%>">
<input type="button" id="CurrButton" onClick="doSelect()" style="display:none">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

//ipad禁掉导出
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
{
	document.getElementById('img2').style.display = 'none';
}

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Lab_Store_I.jsp';

switch(parseInt(<%=currStatus.getFunc_Sub_Id()%>))
{
	case 0:
			document.getElementById('BDate').style.display = 'none';
			document.getElementById('EDate').style.display = 'none';
		break;
	case 1:
	case 9:
			document.getElementById('BDate').style.display = '';
			document.getElementById('EDate').style.display = '';
		break;
}

function doSelect()
{
	/**var days = new Date(Lab_Store_I.EDate.value.replace(/-/g, "/")).getTime() - new Date(Lab_Store_I.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	if(dcnt < 0)
	{
		alert('截止日期需大于开始日期');
		return;
	}
	if((dcnt + 1) > 31)
	{
		alert('日期跨越不超过31天');
		return;
	}
	**/
	//Lab_Store_I.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Lab_Store_I.BTime.value = Lab_Store_I.BDate.value;
	Lab_Store_I.ETime.value = Lab_Store_I.EDate.value;
	Lab_Store_I.submit();
}

function GoPage(pPage)
{
	/**var days = new Date(Lab_Store_I.EDate.value.replace(/-/g, "/")).getTime() - new Date(Lab_Store_I.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	if(dcnt < 0)
	{
		alert('截止日期需大于开始日期');
		return;
	}
	if((dcnt + 1) > 31)
	{
		alert('日期跨越不超过31天');
		return;
	}
	**/
	if(pPage == "")
	{
		 alert("请输入目标页面的数值!");
		 return;
	}
	if(pPage < 1)
	{
	   	alert("请输入页数大于1");
		  return;	
	}
	if(pPage > <%=currStatus.getTotalPages()%>)
	{
		pPage = <%=currStatus.getTotalPages()%>;
	}
	//Lab_Store_I.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Lab_Store_I.BTime.value = Lab_Store_I.BDate.value;
	Lab_Store_I.ETime.value = Lab_Store_I.EDate.value;
	Lab_Store_I.CurrPage.value = pPage;
	Lab_Store_I.submit();
}

//添加申购信息
function doAdd()
{
	location = "Lab_Store_I_Add.jsp?Sid=<%=Sid%>";
}

//编辑申购信息
function doEdit01(pSN, pStatus)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='110204' ctype='1'/>' == 'none')
	{
		alert('您无权限修改申购信息!');
		return;
	}
	
	if('0' != pStatus)
	{
		alert('当前记录已审核，不可再修改申购信息!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 349;
	diag.Title = "编辑申购信息";
	diag.URL = "Lab_Store_I_Edt.jsp?Sid=<%=Sid%>&CType=1&SN=" + pSN;
	diag.show();
}

//审核申购信息
function doEdit02(pSN, pStatus)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='110205' ctype='1'/>' == 'none')
	{
		alert('您无权限修改审核信息!');
		return;
	}
	
	if('0' != pStatus)
	{
		alert('当前记录已审核，不可再审核申购信息!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 350;
	diag.Title = "审核申购信息";
	diag.URL = "Lab_Store_I_Edt.jsp?Sid=<%=Sid%>&CType=2&SN=" + pSN;
	diag.show();
}

var req = null;
function doExport()
{
	/**var days = new Date(Lab_Store_I.EDate.value.replace(/-/g, "/")).getTime() - new Date(Lab_Store_I.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	if(dcnt < 0)
	{
		alert('截止日期需大于开始日期');
		return;
	}
	if((dcnt + 1) > 31)
	{
		alert('日期跨越不超过31天');
		return;
	}
	**/
	if(0 == <%=sn%>)
	{
		alert('当前无记录!');
		return;
	}
	if(65000 <= <%=currStatus.getTotalRecord()%>)
	{
		alert('记录过多，请分批导出!');
		return;
	}
	if(confirm("确定导出?"))
  {
		if(window.XMLHttpRequest)
	  {
			req = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			req = new ActiveXObject("Microsoft.XMLHTTP");
		}
		//设置回调函数
		req.onreadystatechange = callbackForName;
		var url = "Lab_Store_I_Export.do?Sid=<%=Sid%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>";
		req.open("post",url,true);
		req.send(null);
		return true;
	}
}

function callbackForName()
{
	var state = req.readyState;
	if(state==4)
	{
		var resp = req.responseText;
		var str = "";
		if(resp != null)
		{
			location.href = "../files/excel/" + resp + ".xls";
		}
	}
}
</SCRIPT>
</html>