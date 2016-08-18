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
 	
  CurrStatus currStatus    = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList Lab_Store_Type = (ArrayList)session.getAttribute("Lab_Store_Type_" + Sid);
  ArrayList Lab_Store      = (ArrayList)session.getAttribute("Lab_Store_" + Sid);
  ArrayList Lab_O_Cpm      = (ArrayList)session.getAttribute("Lab_O_Cpm_" + Sid);
  ArrayList Lab_O_ALL      = (ArrayList)session.getAttribute("Lab_O_ALL_" + Sid);
  ArrayList OperList   = new ArrayList();
  String Lab_Chg = "";
  int cnt = 0;
  int sn  = 0;
  
%>
<body style=" background:#CADFFF">
<form name="Lab_Store"  action="Lab_Store.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				用品类型:
				<select name='Func_Corp_Id' style='width:120px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Lab_Store_Type)
					{
						Iterator typeiter = Lab_Store_Type.iterator();
						while(typeiter.hasNext())
						{
							LabStoreBean typeBean = (LabStoreBean)typeiter.next();
					%>
							<option value='<%=typeBean.getLab_Type()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getLab_Type())?"selected":""%>><%=typeBean.getLab_Type()%></option>
					<%
						}
					}
					%>
				</select>
			</td>
			<td width='30%' align='right'>				
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<!--<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='110102' ctype='1'/>">
				<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()'    style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='090103' ctype='1'/>">-->
				<img id="img1" src="../skin/images/pldr.gif" onClick='doAllAdd()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='110102' ctype='1'/>">	
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='30'>
						<td width='4%'  align='center' rowspan='2'><strong>序号</strong></td>
						<td width='8%' align='center' rowspan='2'><strong>备件名称</strong></td>
						<td width='15%' align='center' rowspan='2'><strong>规格型号</strong></td>
						<td width='5%'  align='center' rowspan='2'><strong>单位</strong></td>
						<td width='18%' align='center' colspan='2'>
							<strong>劳保实时库存</strong>					
						</td>
						<td width='42%' align='center'colspan='7' >
							<strong>各站分配情况(备用数量)</strong>						
						</td>																	
					</tr>
					<tr height='25' valign='middle'>						
						<!--<td width='4%' align='center' >上期结存</td>
						<td width='4%' align='center' >进库数量</td>
						<td width='4%' align='center' >出库数量</td>-->
						<td width='13%' align='center' >结存数量</td>	
						<td width='12%' align='center' >保底存量</td>		
			<%
								if( null != Lab_O_Cpm)
								{
									Iterator oiter = Lab_O_Cpm.iterator();
									while(oiter.hasNext())
									{
										LabStoreOBean statBean = (LabStoreOBean)oiter.next();	
										String Oper_Name = statBean.getOperator();								
				%>													
							<td width='6%' align='center'><strong><%=Oper_Name%></strong></td>														
				<%									
									OperList.add(Oper_Name);
									}
								}
				%>			 				 																					
					</tr>
					<%
					if(Lab_Store != null)
					{
						Iterator iterator = Lab_Store.iterator();
						while(iterator.hasNext())
						{
							LabStoreBean Bean = (LabStoreBean)iterator.next();
							String Lab_Type = Bean.getLab_Type();
							String Lab_Mode = Bean.getLab_Mode();
							String Unit = Bean.getUnit();
							String Lab_I_Cnt = Bean.getLab_I_Cnt();
							String Lab_O_Cnt = Bean.getLab_O_Cnt();
							String Lab_S_Cnt = Bean.getLab_S_Cnt();
							String Lab_A_Cnt = Bean.getLab_A_Cnt();
							int num = Integer.parseInt(Lab_I_Cnt)	+Integer.parseInt(Lab_O_Cnt)-Integer.parseInt(Lab_S_Cnt)	;							
							
							sn++;							
											
					%>
							  <tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
									<td align=center><%=sn%></td>
									<td align=center rowspan='<%=cnt%>'><%=Lab_Type%></td>
							    <td align=center><%=Lab_Mode%></td>
							    <td align=center rowspan='<%=cnt%>'><%=Unit%></td>							    
									<td align=center><%=Lab_I_Cnt%></td>
									<td align=center <%=(Integer.parseInt(Lab_I_Cnt) - Integer.parseInt(Lab_A_Cnt)) < 0?"style='background:red;'":""%>><%=Lab_A_Cnt%></td>									
								<%
											if(null != Lab_O_ALL && null != OperList)
											{
												Iterator operinter = OperList.iterator();
												while(operinter.hasNext())
												{ 
													String oper   = (String)operinter.next();
													String str_num = "0";								
												Iterator statiter = Lab_O_ALL.iterator();
												while(statiter.hasNext())
												{
													LabStoreOBean lanoBean = (LabStoreOBean)statiter.next();		
													String operName	= lanoBean.getOperator();										
													if(oper.equals(operName) && lanoBean.getLab_Type().equals(Lab_Type) && lanoBean.getLab_Mode().equals(Lab_Mode))
													{
															str_num = lanoBean.getLab_O_Scnt();											
													}												
												}
												%>										
															<td  align=center> <%=str_num%></td>						
											<%
												}
											}
											%>
								
								
								</tr>
					<%
																		
							cnt = 0;					
						}
					}					
					%>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd" value="0">
<input type="hidden" name="Sid" value="<%=Sid%>">
<input type="hidden" name="Cpm_Id" value="">
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


function doSelect()
{
	Lab_Store.submit();
}

var req = null;
function doExport()
{
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
		var url = "Lab_Store_Export.do?Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>";
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

//添加
function doAdd()
{
	location = "Lab_Store_Add.jsp?Sid=<%=Sid%>";
}

//报废处理
function doEdt(pLab_Type, pLab_Mode)
{
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 500;
	diag.Height = 332;
	diag.Title = "报废处理";
	diag.URL = "Lab_Store_Edt.jsp?Sid=<%=Sid%>&Lab_Type="+pLab_Type+"&Lab_Mode="+pLab_Mode;
	diag.show();
}

//保底更新
function doAre(pLab_Type, pLab_Mode)
{
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 500;
	diag.Height = 332;
	diag.Title = "保底更新";
	diag.URL = "Lab_Store_Are.jsp?Sid=<%=Sid%>&Lab_Type="+pLab_Type+"&Lab_Mode="+pLab_Mode;
	diag.show();
}
//劳保申购
function doAddLB()
{
	
	location = "Lab_Store_I_Add.jsp?Sid=<%=Sid%>";	
	
}
//出库添加
function doAddCK()
{

	location ="Lab_Store_O_Add.jsp?Sid=<%=Sid%>";
}
//批量导入
function doAllAdd()
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 500;
	Pdiag.Height = 120;
	Pdiag.Title = "库存台账批量导入";
	Pdiag.URL = 'Lab_Store_File.jsp?Sid=<%=Sid%>';
	Pdiag.show();

}
</SCRIPT>
</html>