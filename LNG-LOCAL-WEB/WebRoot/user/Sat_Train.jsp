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
<script type='text/javascript' src='../skin/js/day.js'></script>
<script type='text/javascript' src='../skin/js/util.js'></script>
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
	
	CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Dept = "";
  if(Corp_Info != null)
	{
		Dept = Corp_Info.getDept();
    if(Dept == null)
    {
    	Dept = "";
    }
 	}
 	
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	
	ArrayList Sat_Train_Type = (ArrayList)session.getAttribute("Sat_Train_Type_" + Sid);
  ArrayList Sat_Train      = (ArrayList)session.getAttribute("Sat_Train_" + Sid);
  int sn = 0; 
%>
<body style=" background:#CADFFF">
<form name="Sat_Train"  action="Sat_Train.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				培训类型:
				<select name='Func_Corp_Id' style='width:120px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Sat_Train_Type)
					{
						Iterator typeiter = Sat_Train_Type.iterator();
						while(typeiter.hasNext())
						{
							AqscTrainTypeBean typeBean = (AqscTrainTypeBean)typeiter.next();
					%>
							<option value='<%=typeBean.getId()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getId())?"selected":""%>><%=typeBean.getCName()%></option>
					<%
						}
					}
					%>
				</select>
				<input name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				至
				<input name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
			<td width='30%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' >
				<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()'    >
				<img id="img4" src="../skin/images/mini_button_ledger.gif" onClick='doLedger()' >						
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='5%'  align='center' class="table_deep_blue">序号</td>
						<td width='10%' align='center' class="table_deep_blue">开始日期</td>
						<td width='10%' align='center' class="table_deep_blue">结束日期</td>
						<td width='10%' align='center' class="table_deep_blue">组织部门</td>
						<td width='20%' align='center' class="table_deep_blue">培训信息</td>
						<td width='10%' align='center' class="table_deep_blue">是否考核</td>
						<td width='10%' align='center' class="table_deep_blue">录入人员</td>
					</tr>
					<%
					if(Sat_Train != null)
					{
						Iterator iterator = Sat_Train.iterator();
						while(iterator.hasNext())
						{
							SatTrainBean Bean = (SatTrainBean)iterator.next();
							String SN = Bean.getSN();
							String Train_BTime = Bean.getTrain_BTime();
							String Train_ETime = Bean.getTrain_ETime();
							String Train_Type  = Bean.getTrain_Type();
							String Train_Dept = Bean.getTrain_Dept();											
							String Train_Type_Name = Bean.getTrain_Type_Name();
							String Train_Title = Bean.getTrain_Title();
							String Train_Corp = Bean.getTrain_Corp();
							String Train_Object = Bean.getTrain_Object();
							String Train_Cnt = Bean.getTrain_Cnt();
							String Train_Hour = Bean.getTrain_Hour();							
							String Train_Assess = Bean.getTrain_Assess();
							String Operator_Name = Bean.getOperator_Name();
																			
							/**String str_Train_Desc = "培训类型: " + Train_Type_Name
																		+ "<br>"
											              + "培训主题: " + Train_Title
											              + "<br>"
											              + "培训单位: " + Train_Corp
											              + "<br>"
											              + "培训对象: " + Train_Object
											              + "<br>"
											              + "培训人数: " + Train_Cnt
											              + "<br>"
											              + "培训课时: " + Train_Hour;**/
							String str_Train_Desc = Train_Type_Name;
							
							String str_Train_Assess = "";
							switch(Integer.parseInt(Train_Assess))
							{
								case 0:
										str_Train_Assess = "否";
									break;
								case 1:
										str_Train_Assess = "是";
									break;
							}
							
							String Train_Dept_Name = "无";
						  if(null != Train_Dept && Dept.trim().length() > 0)
						 	{
						 		String[] DeptList = Dept.split(",");
								for(int i=0; i<DeptList.length; i++)
								{
						    	if(Train_Dept.equals(CommUtil.IntToStringLeftFillZero(i+1, 2)))
						    	{
								  	Train_Dept_Name = DeptList[i];
								  }
								}
						 	}
						 	
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>						  
								<td align=center><%=sn%></td>
								<td align=center><%=Train_BTime%></td>
						    <td align=center><%=Train_ETime%></td>
						    <td align=center><%=Train_Dept_Name%></td>		    
						    <td align=center><a href="#" onClick="ToDing('<%=SN%>')"><font color="red"><%=str_Train_Desc%></font></a></td>
								<td align=center><%=str_Train_Assess%></td>
								<td align=center><%=Operator_Name%></td>
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
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%> 
     		 	<tr>
						<td colspan="7" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Sat_Train")%></td>
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
//ipad禁掉导出
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
{
	document.getElementById('img2').style.display = 'none';
}

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Sat_Train.jsp';

function doSelect()
{
	/**var days = new Date(Sat_Train.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Train.BDate.value.replace(/-/g, "/")).getTime();
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
	}**/
	
	//Sat_Train.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Sat_Train.BTime.value = Sat_Train.BDate.value;
	Sat_Train.ETime.value = Sat_Train.EDate.value;
	Sat_Train.submit();
}

function GoPage(pPage)
{
	/**var days = new Date(Sat_Train.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Train.BDate.value.replace(/-/g, "/")).getTime();
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
	//Sat_Train.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Sat_Train.BTime.value = Sat_Train.BDate.value;
	Sat_Train.ETime.value = Sat_Train.EDate.value;
	Sat_Train.CurrPage.value = pPage;
	Sat_Train.submit();
}

var req = null;
function doExport()
{
	/**var days = new Date(Sat_Train.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Train.BDate.value.replace(/-/g, "/")).getTime();
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
		var url = "Sat_Train_Export.do?Sid=<%=Sid%>&BTime="+Sat_Train.BDate.value+"&ETime="+Sat_Train.EDate.value+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>";
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

function doAdd()
{
	location = "Sat_Train_Add.jsp?Sid=<%=Sid%>";
}

function doLedger()
{
	var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
  var Year  = BTime.substring(0,4);
  var Month = BTime.substring(5,7);
	location = "Sat_Train_L.do?Cmd=0&Sid=<%=Sid%>&Func_Sub_Id=1&Func_Corp_Id=9999&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
}

function ToDing(pSN)
{	
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 700;
	diag.Height = 120;
	diag.Title = "培训详情";
	diag.URL ="Sat_Diag_Train.do?Cmd=1&Sid=<%=Sid%>&SN="+pSN;
	diag.show();		
}



</SCRIPT>
</html>