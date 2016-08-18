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
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type='text/javascript' src='../skin/js/util.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
	String Operator = UserInfo.getId();
	String FpId = UserInfo.getFp_Role();
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
	
	ArrayList Lab_Store_O = (ArrayList)session.getAttribute("Lab_Store_O_" + Sid);
	ArrayList Lab_Store   = (ArrayList)session.getAttribute("Lab_Store_" + Sid);
	ArrayList Lab_Store_Type   = (ArrayList)session.getAttribute("Lab_Store_Type_" + Sid);
	

  int sn = 0;
  String Manage_List = "";
								if(ManageId.length() > 0 && null != User_Manage_Role)
								{
									Iterator iterator = User_Manage_Role.iterator();
									while(iterator.hasNext())
									{
										UserRoleBean statBean = (UserRoleBean)iterator.next();
										if(statBean.getId().substring(0,4).equals(ManageId) && statBean.getId().length() == 8)
										{
											String R_Point = statBean.getPoint();
											if(null == R_Point){R_Point = "";}
											Manage_List += R_Point;
										}
									}
								}
  
%>
<body style=" background:#CADFFF">
<form name="Lab_Store_O"  action="Lab_Store_O.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				领用站点:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >		
					<option value='666' <%=currStatus.getFunc_Cpm_Id().equals(666)?"selected":""%>>全部</option>						
						<%																
								if( null != Lab_Store)
								{
									Iterator iterator = Lab_Store.iterator();
									while(iterator.hasNext())
									{
										LabStoreOBean statBean = (LabStoreOBean)iterator.next();
										
								%>
											<option value='<%=statBean.getOperator()%>' <%=currStatus.getFunc_Cpm_Id().equals(statBean.getOperator())?"selected":""%>><%=statBean.getOperator()%></option>
								<%
									}
								}
								%>
				</select>
				用品类型:
				<select name='Func_Corp_Id' style='width:120px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Lab_Store_Type)
					{
						
						Iterator typeiter = Lab_Store_Type.iterator();
						while(typeiter.hasNext())
						{
							LabStoreOBean typeBean = (LabStoreOBean)typeiter.next();						
					%>
								<option value='<%=typeBean.getLab_Type()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getLab_Type())?"selected":""%>><%=typeBean.getLab_Type()%></option>
					<%							
						}
					}
					%>
				</select>
				
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				-
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
			<td width='30%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<!--<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='110402' ctype='1'/>">
				<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()'    style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='110403' ctype='1'/>">-->
				<img src="../skin/images/pldr.gif" style='cursor:hand;' onClick='doDAORU()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='110302' ctype='1'/>">	
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='5%'  align='center' class="table_deep_blue">序号</td>
						<td width='10%' align='center' class="table_deep_blue">产品名称</td>
						<td width='10%' align='center' class="table_deep_blue">规格型号</td>
						<td width='10%' align='center' class="table_deep_blue">应发数量</td>
						<td width='10%' align='center' class="table_deep_blue">实发数量</td>
						<td width='15%' align='center' class="table_deep_blue">领用单位</td>
						<td width='10%' align='center' class="table_deep_blue">领用人</td>
						<td width='10%' align='center' class="table_deep_blue">发货人</td>
						<td width='10%' align='center' class="table_deep_blue">发货日期</td>
						<td width='10%' align='center' class="table_deep_blue">备注信息</td>
					</tr>
					<%
					if(Lab_Store_O != null)
					{
						Iterator iterator = Lab_Store_O.iterator();
						while(iterator.hasNext())
						{
							LabStoreOBean Bean = (LabStoreOBean)iterator.next();
							String SN            = Bean.getSN();
							String Lab_Type = Bean.getLab_Type();
							String Lab_Mode      = Bean.getLab_Mode();
							String Lab_O_Ycnt    = Bean.getLab_O_Ycnt();
							String Lab_O_Scnt    = Bean.getLab_O_Scnt();
							String Operator1      = Bean.getOperator();
							String Operator_Name      = Bean.getOperator_Name();
							String Foperator      = Bean.getFoperator();
							String CTime          = Bean.getCTime();
							String Status_Memo    = Bean.getStatus_Memo();
							
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
								<td align=center><a href="#" onclick="DeSn('<%=SN%>')"><U><%=sn%></U></a></td>
								<td align=left><%=Lab_Type%></td>
						    <td align=left><%=Lab_Mode%></td>
						    <td align=center><%=Lab_O_Ycnt%></td>
						    <td align=center><%=Lab_O_Scnt%></td>	
						    <td align=center><%=Operator1%></td>				    						    						
						    <td align=center><%=Operator_Name%></td>
						    <td align=center><%=Foperator%></td>
						    <td align=left><%=CTime%></td>
						    <td align=left><%=Status_Memo%>&nbsp;</td>
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
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%>
     		 	<tr>
						<td colspan="7" class="table_deep_blue">
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0">
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Lab_Store_O")%></td>
			    			</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd"      value="0">
<input type="hidden" name="Sid"      value="<%=Sid%>">
<input type="hidden" name="Cpm_Id"   value="">
<input type="hidden" name="BTime"    value="">
<input type="hidden" name="ETime"    value="">
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Lab_Store_O.jsp';

function doSelect()
{
	/**var days = new Date(Lab_Store_O.EDate.value.replace(/-/g, "/")).getTime() - new Date(Lab_Store_O.BDate.value.replace(/-/g, "/")).getTime();
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
	Lab_Store_O.Cpm_Id.value = Lab_Store_O.Func_Cpm_Id.value;
	Lab_Store_O.BTime.value = Lab_Store_O.BDate.value;
	Lab_Store_O.ETime.value = Lab_Store_O.EDate.value;
	Lab_Store_O.submit();
}

function GoPage(pPage)
{
	/**var days = new Date(Lab_Store_O.EDate.value.replace(/-/g, "/")).getTime() - new Date(Lab_Store_O.BDate.value.replace(/-/g, "/")).getTime();
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
	Lab_Store_O.Cpm_Id.value = Lab_Store_O.Func_Cpm_Id.value;
	Lab_Store_O.BTime.value = Lab_Store_O.BDate.value;
	Lab_Store_O.ETime.value = Lab_Store_O.EDate.value;
	Lab_Store_O.CurrPage.value = pPage;
	Lab_Store_O.submit();
}

function doAdd()
{
	location = "Lab_Store_O_Add.jsp?Sid=<%=Sid%>";
}

function doEdit(pSN, pLab_O_Time)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='110404' ctype='1'/>' == 'none')
	{
		alert('您无权限作废出库记录!');
		return;
	}
	
	var TDay = new Date().format("yyyy-MM-dd");
	if(pLab_O_Time != TDay)
	{
		alert('只可操作当天流水记录!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 400;
	diag.Height = 140;
	diag.Title = "记录作废";
	diag.URL = "Lab_Store_O_Edt.jsp?Sid=<%=Sid%>&SN=" + pSN;
	diag.show();
}

var req = null;
function doExport()
{
	/**var days = new Date(Lab_Store_O.EDate.value.replace(/-/g, "/")).getTime() - new Date(Lab_Store_O.BDate.value.replace(/-/g, "/")).getTime();
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
		var url = "Lab_Store_O_Export.do?Sid=<%=Sid%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
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

function DeSn(pSN)	
{
		if(confirm("是否删除本条记录?"))
	{		
		location="Lab_Store_O.do?Cmd=13&Sid=<%=Sid%>&Func_Cpm_Id="+Lab_Store_O.Func_Cpm_Id.value+"&Func_Corp_Id="+Lab_Store_O.Func_Corp_Id.value+"&BTime="+Lab_Store_O.BDate.value+"&ETime="+Lab_Store_O.EDate.value+"&SN="+pSN+"Func_Type_Id=";
	}		
		
}

function doDAORU()
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 500;
	Pdiag.Height = 120;
	Pdiag.Title = "劳保出库导入";
	Pdiag.URL = 'Lab_Store_O_File.jsp?Sid=<%=Sid%>';
	Pdiag.show();
}
</SCRIPT>
</html>