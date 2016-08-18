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
	
	ArrayList User_User_Info = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	ArrayList Lab_Store_IN   = (ArrayList)session.getAttribute("Lab_Store_IN_" + Sid);
	ArrayList Lab_Store      = (ArrayList)session.getAttribute("Lab_Store_" + Sid);
  int sn = 0;
  
%>
<body style=" background:#CADFFF">
<form name="Lab_Store_IN"  action="Lab_Store_I.do" method="post" target="mFrame">
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
						
						Iterator typeiter = Lab_Store.iterator();
						while(typeiter.hasNext())
						{
							LabStoreIBean typeBean = (LabStoreIBean)typeiter.next();						
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
			<td width='20%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<!--<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='110302' ctype='1'/>">-->
				<img src="../skin/images/pldr.gif" style='cursor:hand;' onClick='doDAORU()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='110202' ctype='1'/>">	
			</td>
		</tr>
		<tr height='30'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25'>
						<td width='5%'  align='center' class="table_deep_blue">序号</td>
						<td width='17%' align='center' class="table_deep_blue">产品名称</td>
						<td width='18%' align='center' class="table_deep_blue">规格型号</td>
						<td width='10%' align='center' class="table_deep_blue">单位</td>
						<td width='10%' align='center' class="table_deep_blue">入库数量</td>
						<td width='10%' align='center' class="table_deep_blue">经办人</td>
						<td width='10%' align='center' class="table_deep_blue">入库日期</td>
						<td width='10%' align='center' class="table_deep_blue">验收人</td>
						<td width='10%' align='center' class="table_deep_blue">备注</td>						
					</tr>
					<%
					if(Lab_Store_IN != null)
					{
						Iterator iterator = Lab_Store_IN.iterator();
						while(iterator.hasNext())
						{
							LabStoreIBean Bean = (LabStoreIBean)iterator.next();
							String SN            = Bean.getSN();
							String Lab_Type      = Bean.getLab_Type();
							String Lab_Mode      = Bean.getLab_Mode();					
							String Unit          = Bean.getUnit();								
							String IN_Cnt    = Bean.getIN_Cnt();	
							String IN_Oper    = Bean.getIN_Oper();
							String IN_Date    = Bean.getIN_Date();
							String OperatorL    = Bean.getOperator();	
							String IN_Memo    = Bean.getIN_Memo();														
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
								<td  align='center' ><a href="#" onclick="DeSn('<%=SN%>')"><U><%=sn%></U></a></td>
								<td  align='center' ><%=Lab_Type%></td>
								<td  align='center' ><%=Lab_Mode%></td>
								<td  align='center' ><%=Unit%></td>
								<td  align='center' ><%=IN_Cnt%></td>
								<td  align='center' ><%=IN_Oper%></td>
								<td  align='center' ><%=IN_Date%></td>
								<td  align='center' ><%=OperatorL%></td>
								<td  align='center' ><%=IN_Memo%></td>
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
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%> 
     		 	<tr>
						<td colspan="11" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Lab_Store_IN")%></td>
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Lab_Store_IN.jsp';



function doSelect()
{
	/**var days = new Date(Lab_Store_IN.EDate.value.replace(/-/g, "/")).getTime() - new Date(Lab_Store_IN.BDate.value.replace(/-/g, "/")).getTime();
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
	//Lab_Store_IN.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Lab_Store_IN.BTime.value = Lab_Store_IN.BDate.value;
	Lab_Store_IN.ETime.value = Lab_Store_IN.EDate.value;
	Lab_Store_IN.submit();
}

function GoPage(pPage)
{
	/**var days = new Date(Lab_Store_IN.EDate.value.replace(/-/g, "/")).getTime() - new Date(Lab_Store_IN.BDate.value.replace(/-/g, "/")).getTime();
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
	//Lab_Store_IN.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Lab_Store_IN.BTime.value = Lab_Store_IN.BDate.value;
	Lab_Store_IN.ETime.value = Lab_Store_IN.EDate.value;
	Lab_Store_IN.CurrPage.value = pPage;
	Lab_Store_IN.submit();
}

//入库操作
function doIN(pSN, pIN_Status)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='110303' ctype='1'/>' == 'none')
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
	diag.URL = "Lab_Store_I.do?Cmd=2&Sid=<%=Sid%>&SN=" + pSN;
	diag.show();
}

var req = null;
function doExport()
{
	/**var days = new Date(Lab_Store_IN.EDate.value.replace(/-/g, "/")).getTime() - new Date(Lab_Store_IN.BDate.value.replace(/-/g, "/")).getTime();
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
		var url = "Lab_Store_IN_Export.do?Sid=<%=Sid%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>";
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
		location="Lab_Store_I.do?Cmd=13&Sid=<%=Sid%>&Func_Corp_Id="+Lab_Store_IN.Func_Corp_Id.value+"&BTime="+Lab_Store_IN.BDate.value+"&ETime="+Lab_Store_IN.EDate.value+"&SN="+pSN+"&Func_Type_Id=";
	}		
		
}



function doDAORU()
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 500;
	Pdiag.Height = 120;
	Pdiag.Title = "劳保入库导入";
	Pdiag.URL = 'Lab_Store_IN_File.jsp?Sid=<%=Sid%>';
	Pdiag.show();
}

</SCRIPT>
</html>