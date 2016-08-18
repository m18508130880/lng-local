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
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
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
	
	ArrayList User_User_Info = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	ArrayList Spa_Store_IN   = (ArrayList)session.getAttribute("Spa_Store_IN_" + Sid);
	ArrayList Spa_Store      = (ArrayList)session.getAttribute("Spa_Store_" + Sid);
	ArrayList Spa_Store_MC      = (ArrayList)session.getAttribute("Spa_Store_MC_" + Sid);
	ArrayList Spa_Store_XH      = (ArrayList)session.getAttribute("Spa_Store_XH_" + Sid);
  int sn = 0;
  
%>
<body style=" background:#CADFFF">
<form name="Spa_Store_IN"  action="Spa_Store_I.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='80%' align='left'>
				备品名称:
				<select name='Func_Corp_Id' style='width:150px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Spa_Store_MC)
					{					
						Iterator typeiter = Spa_Store_MC.iterator();
						while(typeiter.hasNext())
						{
							SpaStoreIBean typeBean = (SpaStoreIBean)typeiter.next();							
					%>
								<option value='<%=typeBean.getSpa_Type()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getSpa_Type())?"selected":""%>><%=typeBean.getSpa_Type()%></option>
					<%						
						}
					}
					%>
				</select>
				备品型号:
				<select name='Func_Type_Id' style='width:60px;height:20px' onChange="doSelect()">
					
					<option value='' <%=currStatus.getFunc_Type_Id().equals("")?"selected":""%>>全部</option>
					<%
					if(null != Spa_Store_XH)
					{					
						Iterator peiter = Spa_Store_XH.iterator();
						while(peiter.hasNext())
						{
							SpaStoreIBean peBean = (SpaStoreIBean)peiter.next();							
					%>
								<option value='<%=peBean.getSpa_Mode()%>' <%=currStatus.getFunc_Type_Id().equals(peBean.getSpa_Mode())?"selected":""%>><%=peBean.getSpa_Mode()%></option>
					<%						
						}
					}
					%>					
				</select>			
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>			
			</td>
			<td width='20%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				
				<img id="img1" src="../skin/images/pldr.gif" onClick='doAllAdd()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='140202' ctype='1'/>">	
			</td>
		</tr>
		<tr height='30'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25'>						
						<td width='5%'  align='center' class="table_deep_blue">序号</td>
						<td width='15%' align='center' class="table_deep_blue">物品名称</td>
						<td width='15%' align='center' class="table_deep_blue">规格型号</td>
						<td width='7%' align='center' class="table_deep_blue">单位</td>
						<td width='7%' align='center' class="table_deep_blue">入库数量</td>
						<td width='7%' align='center' class="table_deep_blue">单价</td>
						<td width='7%' align='center' class="table_deep_blue">金额</td>	
						<td width='7%' align='center' class="table_deep_blue">采办人员</td>
						<td width='7%' align='center' class="table_deep_blue">验收人员</td>
						<td width='17%' align='center' class="table_deep_blue">入库时间</td>								
						<td width='18%' align='center' class="table_deep_blue">备注信息</td>
					</tr>
					<%
					if(Spa_Store_IN != null)
					{
						Iterator iterator = Spa_Store_IN.iterator();
						while(iterator.hasNext())
						{
							SpaStoreIBean Bean = (SpaStoreIBean)iterator.next();
							String SN            = Bean.getSN();
							String Spa_Type = Bean.getSpa_Type();
							String Spa_Mode      = Bean.getSpa_Mode();	
							String Spa_Unit      = Bean.getSpa_Unit();					
							String Spa_Num      = Bean.getSpa_Num();
							String Spa_Price      = Bean.getSpa_Price();
							String Spa_Amt      = Bean.getSpa_Amt();
							String Spa_I_Oper      = Bean.getSpa_I_Oper();
							String OperatorL      = Bean.getOperator();
							String CTime      = Bean.getCTime();
							String Spa_Memo      = Bean.getSpa_Memo();										
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
								<td align=center><%=sn%></td>
								<td align=left><%=Spa_Type%>&nbsp;</td>
						    <td align=left><%=Spa_Mode%>&nbsp;</td>
						    <td align=center><%=Spa_Unit%>&nbsp;</td>						    
						    <td align='center' ><%=Spa_Num%>&nbsp;</td>						    
								<td align='center' ><%=Spa_Price%>&nbsp;</td>								
								<td align='center' ><%=Spa_Amt%>&nbsp;</td>			
								<td align='center' ><%=Spa_I_Oper%>&nbsp;</td>
								<td align='center' ><%=OperatorL%>&nbsp;</td>
								<td align='center' ><%=CTime%>&nbsp;</td>
								<td align='center' ><%=Spa_Memo%>&nbsp;</td>														   
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
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%> 
     		 	<tr>
						<td colspan="11" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Spa_Store_IN")%></td>
			    			</tr>			    		
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd"    value="1">
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Spa_Store_IN.jsp';

/**switch(parseInt(<%=currStatus.getFunc_Sel_Id()%>))
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
**/
function doSelect()
{
	var days = new Date(Spa_Store_IN.EDate.value.replace(/-/g, "/")).getTime() - new Date(Spa_Store_IN.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	/**if(dcnt < 0)
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
	//Spa_Store_IN.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Spa_Store_IN.BTime.value = Spa_Store_IN.BDate.value;
	Spa_Store_IN.ETime.value = Spa_Store_IN.EDate.value;
	Spa_Store_IN.submit();
}

function GoPage(pPage)
{
	var days = new Date(Spa_Store_IN.EDate.value.replace(/-/g, "/")).getTime() - new Date(Spa_Store_IN.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	/**if(dcnt < 0)
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
	//Spa_Store_IN.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Spa_Store_IN.BTime.value = Spa_Store_IN.BDate.value;
	Spa_Store_IN.ETime.value = Spa_Store_IN.EDate.value;
	Spa_Store_IN.CurrPage.value = pPage;
	Spa_Store_IN.submit();
}

//入库操作
/**function doIN(pSN, pIN_Status)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='140303' ctype='1'/>' == 'none')
	{
		alert('您无权限进行入库操作!');
		return;
	}
	
	if('0' != pIN_Status)
	{
		alert('当前记录已入库，不可再修改入库信息!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 350;
	diag.Height = 212;
	diag.Title = "入库操作";
	diag.URL = "Spa_Store_IN_Edt.jsp?Sid=<%=Sid%>&SN=" + pSN;
	diag.show();
}
**/
var req = null;
function doExport()
{
	var days = new Date(Spa_Store_IN.EDate.value.replace(/-/g, "/")).getTime() - new Date(Spa_Store_IN.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	/**if(dcnt < 0)
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
		var url = "Spa_Store_IN_Export.do?Sid=<%=Sid%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>";
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
function doAllAdd()
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 500;
	Pdiag.Height = 120;
	Pdiag.Title = "备品备件入库导入";
	Pdiag.URL = 'Spa_Store_IN_File.jsp?Sid=<%=Sid%>&Func_Corp_Id=9999&Func_Sub_Id=9';
	Pdiag.show();

}
</SCRIPT>
</html>