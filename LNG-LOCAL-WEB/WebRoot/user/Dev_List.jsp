<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type='text/css' href='../skin/css/style.css' rel='stylesheet'/>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
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
	
  CurrStatus currStatus        = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList Dev_List           = (ArrayList)session.getAttribute("Dev_List_" + Sid);
  ArrayList Dev_List_Breed     = (ArrayList)session.getAttribute("Dev_List_Breed_" + Sid);
  ArrayList Dev_List_Card      = (ArrayList)session.getAttribute("Dev_List_Card_" + Sid);
  ArrayList Dev_List_Card_List = (ArrayList)session.getAttribute("Dev_List_Card_List_" + Sid);
  
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
								String Dept_Id = UserInfo.getDept_Id();
								if(Dept_Id.length()>3){Manage_List = Dept_Id; }
  
%>
<body style="background:#CADFFF">
<form name="Dev_List"  action="Dev_List.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				加气站点:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >					
						<%								
								if(Manage_List.length() > 0 && null != User_Device_Detail)
								{
									Iterator iterator = User_Device_Detail.iterator();
									while(iterator.hasNext())
									{
										DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
										if(Manage_List.contains(statBean.getId()))
										{
								%>
											<option value='<%=statBean.getId()%>' <%=currStatus.getFunc_Cpm_Id().equals(statBean.getId())?"selected":""%>><%=statBean.getBrief()%></option>
								<%
										}
									}
								}
								%>
				</select>
				设备品种:
				<select name='Func_Corp_Id' style='width:120px;height:20px;' onchange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Dev_List_Breed)
					{
						Iterator breediter = Dev_List_Breed.iterator();
						while(breediter.hasNext())
						{
							AqscDeviceBreedBean breedBean = (AqscDeviceBreedBean)breediter.next();
					%>
							<option value='<%=breedBean.getId()%>' <%=currStatus.getFunc_Corp_Id().equals(breedBean.getId())?"selected":""%>><%=breedBean.getCName()%></option>
					<%
						}
					}
					%>
				</select>
				记录状态:
				<select name='Func_Sel_Id' style='width:90px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sel_Id() == 9 ? "selected":""%>>全部</option>
					<option value='0' <%=currStatus.getFunc_Sel_Id() == 0 ? "selected":""%>>缺证</option>
					<option value='1' <%=currStatus.getFunc_Sel_Id() == 1 ? "selected":""%>>正常</option>
				</select>
			</td>
			<td width='30%' align='right'>
				<img src="../skin/images/mini_button_add.gif" onClick='doAdd()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='130107' ctype='1'/>">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' >
			</td>
		</tr>
		<tr height='30'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=2 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25'>
						<td width='4%'  align='center' class="table_deep_blue">序号</td>
						<td width='8%' align='center' class="table_deep_blue">场站名称</td>
						<td width='8%' align='center' class="table_deep_blue">设备品种</td>
						<td width='8%' align='center' class="table_deep_blue">设备类型</td>
						<td width='8%' align='center' class="table_deep_blue">设备名称</td>						
						<td width='8%' align='center' class="table_deep_blue">技术文档</td>										
						<td width='24%' align='center' class="table_deep_blue">必备证件</td>
						<td width='8%' align='center' class="table_deep_blue">是否缺证</td>
						<td width='8%' align='center' class="table_deep_blue">设备详细</td>		
						<td width='8%' align='center' class="table_deep_blue">设备状态</td>				
						<td width='8%' align='center' class="table_deep_blue">维修资料</td>
					</tr>
					<%
					if(Dev_List != null)
					{
						Iterator iterator = Dev_List.iterator();
						while(iterator.hasNext())
						{
							DevListBean Bean = (DevListBean)iterator.next();
							String SN            = Bean.getSN();
							String Cpm_Id      = Bean.getCpm_Id();
					  	String Cpm_Name      = Bean.getCpm_Name();
					  	String CType_Name    = Bean.getCType_Name();
					  	String CType         = Bean.getCType();
					  	String Dev_Type      = Bean.getDev_Type();
					  	String Dev_Name      = Bean.getDev_Name();
					  	String Dev_Type_Name = Bean.getDev_Type_Name();
						  String Dev_Id        = Bean.getDev_Id();
						  String Dev_Date      = Bean.getDev_Date();
						  String Dev_Canshu      = Bean.getCraft();
						  String Dev_Wendang      = Bean.getDev_Wendang();
						  String Dev_Zhuangtai      = Bean.getDev_Zhuangtai();
						  String str           = "";
							if(Dev_Wendang.length()>1){str = "文档下载";}else{str ="尚无文档";} 						  
						  String Dev_Jishu      = Bean.getTechnology();
							
							//必备证件
							String Card_List_Y = Bean.getCard_List();
							if(null == Card_List_Y)
							{
								Card_List_Y = "";
							}
							
							//已备证件
			  			String Card_List_N = "";
			  			if(null != Dev_List_Card_List)
				    	{
				    		Iterator caditer = Dev_List_Card_List.iterator();
								while(caditer.hasNext())
								{
									DevListCardBean cadBean = (DevListCardBean)caditer.next();
									if(cadBean.getSN().equals(SN))
									{
										Card_List_N += cadBean.getCard_Type() + ",";
									}
								}
				    	}
			  			
			  			//是否缺证
							String str_Card = "";
							int isCard = 1;
				    	if(Card_List_Y.length() > 0)
				    	{
				    		String[] Card_YList = Card_List_Y.split(",");
				    		for(int i=0; i<Card_YList.length && Card_YList[i].length()>0; i++)
				    		{
				    			if(!Card_List_N.contains(Card_YList[i]))
				    			{
				    				isCard = 0;
				    				break;
				    			}
				    		}
				    	}
				    	
							switch(isCard)
							{
								case 0:
									str_Card = "<font color=red>是</font>";
									break;
								case 1:
									str_Card = "<font color=green>否</font>";										
									break;
							}
							
			  			switch(currStatus.getFunc_Sel_Id())
							{
								case 9:
									{
											sn++;
											%>
											<tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%> title='[出厂编号:<%=Dev_Id%>]&#10;[出厂日期<%=Dev_Date%>]&#10;[工艺参数:<%=Bean.getCraft()%>]&#10;[技术参数:<%=Bean.getTechnology()%>]&#10;[其他属性:<%=Bean.getDev_ShuXing()%>]'>
									  		<td align=center><%=sn%></td>
									  		<td align=left><%=Cpm_Name%></td>
									  		<td align=left><%=CType_Name%></td>
									  		<td align=left><%=Dev_Type_Name%></td>
									  		<td align=left><%=Dev_Name%></td>									  		
									  		<td align=left onClick="doFile('<%=SN%>','<%=Dev_Wendang%>')"><font color="red"><%=str%></font></td>									  		
									    	<td align=left valign=top>
									    		<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
									    		<%
													int type_cnt = 0;
													if(null != Dev_List_Card)
													{
														Iterator typeiter = Dev_List_Card.iterator();
														while(typeiter.hasNext())
														{
															AqscDeviceCardBean typeBean = (AqscDeviceCardBean)typeiter.next();
															if(Card_List_Y.contains(typeBean.getId()))
															{
																type_cnt++;
																if(Card_List_N.contains(typeBean.getId()))
																{
													%>
																	<tr height='30px'>
																		<td width='80%' align=left>
																			&nbsp;<img src='../skin/images/02_y.png'>
																			<%=type_cnt%>、<%=typeBean.getCName()%>
																		</td>
																		<td width='20%' align=left>
																			<img src='../skin/images/sat_danger_01.png' title='证件编辑' onclick="doCardEdt('<%=SN%>', '<%=typeBean.getId()%>', '<%=Cpm_Name%>', '<%=Dev_Name%>')">
																			&nbsp;
																			<img src='../skin/images/cmddel.gif'        title='证件删除' onclick="doCardDel('<%=SN%>', '<%=typeBean.getId()%>')">
																		</td>
																	</tr>
													<%
																}
																else
																{
													%>
																	<tr height='30px'>
																		<td width='80%' align=left>
																			&nbsp;<img src='../skin/images/02_n.png'>
																			<%=type_cnt%>、<%=typeBean.getCName()%>
																		</td>
																		<td width='20%' align=left>
																			<img src='../skin/images/device_cmdadd.png'  title='证件添加' onclick="doCardAdd('<%=SN%>', '<%=typeBean.getId()%>', '<%=Cpm_Name%>', '<%=Dev_Name%>')">
																		</td>
																	</tr>
													<%
																}
															}
														}
													}
													if(0 == type_cnt)
													{
													%>
														<tr height='30px'>
															<td width='100%' align=left colspan=2>
																&nbsp;无需相关证件!
															</td>
														</tr>
													<%
													}
													%>
									    		</table>
									    	</td>
									    	<td align=center><%=str_Card%></td>
									    	<td align=center >
									    		<img src='../skin/images/sat_danger_01.png'  title='编辑设备' onclick="doEdit('<%=SN%>')">
									    		&nbsp;
									    		<img src='../skin/images/cmddel.gif'        title='删除设备' onclick="doDel('<%=SN%>')">
									    	</td>
									    	<td align=center>&nbsp;<a href="#" onClick="doZhuangtai('<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Dev_Type%>', '<%=Dev_Type_Name%>', '<%=Dev_Name%>', '<%=Dev_Zhuangtai%>', '<%=CType%>' )" title="修改状态"><%=Dev_Zhuangtai%></a></td>
									    	<td align=center onClick="doWX('<%=Dev_Type%>')"><font color="red">维修资料</font></td>
											</tr>										
											<%
									}
									break;
								case 0:
								case 1:
									{
										if(isCard == currStatus.getFunc_Sel_Id())
										{
											sn++;
											%>
											<tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%> 
												title='[出厂编号:<%=Dev_Id%>]&#10;[出厂日期:<%=Dev_Date%>]&#10;[工艺参数:<%=Bean.getCraft()%>]&#10;[技术参数:<%=Bean.getTechnology()%>]&#10;[其他属性:<%=Bean.getDev_ShuXing()%>]'>
										  	<td align=center><%=sn%></td>
										  	<td align=left><%=Cpm_Name%></td>
										  	<td align=left><%=CType_Name%></td>
										  	<td align=left><%=Dev_Type_Name%></td>
										  	<td align=left><%=Dev_Name%></td>										  
									  		<td align=left onClick="doFile('<%=SN%>','<%=Dev_Wendang%>')"><font color="red"><%=str%></font></td>									  		
										    <td align=left valign=top>
										    	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
									    		<%
													int type_cnt = 0;
													if(null != Dev_List_Card)
													{
														Iterator typeiter = Dev_List_Card.iterator();
														while(typeiter.hasNext())
														{
															AqscDeviceCardBean typeBean = (AqscDeviceCardBean)typeiter.next();
															if(Card_List_Y.contains(typeBean.getId()))
															{
																type_cnt++;
																if(Card_List_N.contains(typeBean.getId()))
																{
													%>
																	<tr height='30px'>
																		<td width='80%' align=left>
																			&nbsp;<img src='../skin/images/02_y.png'>
																			<%=type_cnt%>、<%=typeBean.getCName()%>
																		</td>
																		<td width='20%' align=left>
																			<img src='../skin/images/sat_danger_01.png'  title='证件编辑' onclick="doCardEdt('<%=SN%>', '<%=typeBean.getId()%>', '<%=Cpm_Name%>', '<%=Dev_Name%>')">
																			&nbsp;
																			<img src='../skin/images/cmddel.gif'         title='证件删除' onclick="doCardDel('<%=SN%>', '<%=typeBean.getId()%>')">
																		</td>
																
									    						
																	</tr>
													<%
																}
																else
																{
													%>
																	<tr height='30px'>
																		<td width='80%' align=left>
																			&nbsp;<img src='../skin/images/02_n.png'>
																			<%=type_cnt%>、<%=typeBean.getCName()%>
																		</td>
																		<td width='20%' align=left>
																			<img src='../skin/images/device_cmdadd.png'  title='证件添加' onclick="doCardAdd('<%=SN%>', '<%=typeBean.getId()%>', '<%=Cpm_Name%>', '<%=Dev_Name%>')">
																		</td>
																	</tr>
													<%
																}
															}
														}
													}
													if(0 == type_cnt)
													{
													%>
														<tr height='30px'>
															<td width='100%' align=left colspan=2>
																&nbsp;无需相关证件!
															</td>
														</tr>
													<%
													}
													%>
									    		</table>
										    </td>
										    <td align=center><%=str_Card%></td>
										    <td align=center >
									    		<img src='../skin/images/sat_danger_01.png'  title='编辑设备' onclick="doEdit('<%=SN%>')">
									    		&nbsp;
									    		<img src='../skin/images/cmddel.gif'         title='删除设备' onclick="doDel('<%=SN%>')">
									    	</td>		
									    	<td align=center>&nbsp;<a href="#" onClick="doZhuangtai('<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Dev_Type%>', '<%=Dev_Type_Name%>', '<%=Dev_Name%>', '<%=Dev_Zhuangtai%>', '<%=CType%>')" title="修改状态"><%=Dev_Zhuangtai%></a></td>
									    	<td align=center onClick="doWX('<%=Dev_Type%>')"><font color="red">维修资料</font></td>						  
											</tr>											
											<%
										}
									}
									break;
							}
						}
					}
					if(0 == sn)
					{
					%>
						<tr height=30>
							<td width='100%' align=center colspan=13>无!</td>
						</tr>
					<%
					}
					%>
					<tr><td colspan=11></td></tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd"    value="0">
<input type="hidden" name="Sid"    value="<%=Sid%>">
<input type="hidden" name="SN"     value="">
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Dev_List.jsp';

function doSelect()
{
	Dev_List.Cpm_Id.value = Dev_List.Func_Cpm_Id.value;
	Dev_List.submit();
}

function doAdd()
{
	
	location = "Dev_List_Add.jsp?Sid=<%=Sid%>";
}

function doEdit(pSN)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130108' ctype='1'/>' == 'none')
	{
		alert('您无权编辑该设备!');
		return;
	}
	location = "Dev_List_Edit.jsp?Sid=<%=Sid%>&SN="+pSN;
}

function doDel(pSN)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130105' ctype='1'/>' == 'none')
	{
		alert('您无权删除该设备!');
		return;
	}
	if(confirm('确定删除?'))
	{
		Dev_List.Cmd.value = 12;
		Dev_List.SN.value  = pSN;
		Dev_List.Cpm_Id.value = Dev_List.Func_Cpm_Id.value;
		Dev_List.submit();
	}
}

//证件添加
function doCardAdd(pSN, pCard_Type, pCpm_Name, pDev_Name)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130102' ctype='1'/>' == 'none')
	{
		alert('您无权添加该证件!');
		return;
	}
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 254;
	diag.Title = "证件添加";
	diag.URL = 'Dev_List_Card_Add.jsp?Sid=<%=Sid%>&SN='+pSN+'&Card_Type='+pCard_Type+'&Cpm_Name='+pCpm_Name+'&Dev_Name='+pDev_Name;
	diag.show();
}

//证件编辑
function doCardEdt(pSN, pCard_Type, pCpm_Name, pDev_Name)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130104' ctype='1'/>' == 'none')
	{
		alert('您无权编辑该证件!');
		return;
	}
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 254;
	diag.Title = "证件编辑";
	diag.URL = 'Dev_List_Card_Edt.jsp?Sid=<%=Sid%>&SN='+pSN+'&Card_Type='+pCard_Type+'&Cpm_Name='+pCpm_Name+'&Dev_Name='+pDev_Name;
	diag.show();
}

//证件删除
function doCardDel(pSN, pCard_Type)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130103' ctype='1'/>' == 'none')
	{
		alert('您无权删除该证件!');
		return;
	}
	
	if(confirm("确定删除当前证件?"))
	{
		if(window.XMLHttpRequest)
	  {
			reqAdd = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqAdd = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//设置回调函数
		reqAdd.onreadystatechange = function()
		{
			var state = reqAdd.readyState;
			if(state == 4)
			{
				if(reqAdd.status == 200)
				{
					var resp = reqAdd.responseText;			
					if(resp != null && resp.substring(0,4) == '0000')
					{
						alert('成功');
						doSelect();
						return;
					}
					else
					{
						alert('失败，请重新操作');
						return;
					}
				}
				else
				{
					alert("失败，请重新操作");
					return;
				}
			}
		};
		var url = 'Dev_List_Card.do?Cmd=12&Sid=<%=Sid%>&SN='+pSN+'&Card_Type='+pCard_Type+'&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&currtime='+new Date();
		reqAdd.open("post",url,true);
		reqAdd.send(null);
		return true;
	}
}


//文档上传
function doFile(pSN,pDev_Wendang)
{	
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='130106' ctype='1'/>' == 'none')
	{
		alert('您无权上传文档!');
		return;
	}
	var Cpm_Id = Dev_List.Func_Cpm_Id.value;
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 400;
	diag.Height = 200;
	diag.Title = "文档操作";
	diag.URL = 'Dev_List_File.jsp?Sid=<%=Sid%>&Dev_Wendang='+pDev_Wendang+"&SN="+pSN+"&Cpm_Id="+Cpm_Id;
	diag.show();
}

//维修资料查询
function doWX(pDev_Type)
{		
	window.parent.frames.mFrame.location = "Fix_To_Trace.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+Dev_List.Func_Cpm_Id.value+"&Func_Sub_Id=0&Func_Corp_Id="+pDev_Type;
}

//导出Excel
var req = null;
function doExport()
{
	
	if(0 == <%=sn%>)
	{
		alert('当前无记录!');
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
		var url = "Dev_List_Export.do?Sid=<%=Sid%>&Cpm_Id="+Dev_List.Func_Cpm_Id.value+"&Func_Corp_Id="+Dev_List.Func_Corp_Id.value;
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

function doZhuangtai(pCpm_Id, pCpm_Name, pDev_Type, pDev_Type_Name, pDev_Name, pDev_Zhuangtai, pCType)
{
	
	var Cpm_Id = Dev_List.Func_Cpm_Id.value;
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 400;
	diag.Height = 180;
	diag.Title = "设备状态";
	diag.URL = "Dev_List_ZT.jsp?Sid=<%=Sid%>&Cpm_Id="+pCpm_Id+"&Cpm_Name="+pCpm_Name+"&Dev_Type="+pDev_Type+"&Dev_Type_Name="+pDev_Type_Name+"&Dev_Name="+pDev_Name+"&Dev_Zhuangtai="+pDev_Zhuangtai+"&CType="+pCType;
	diag.show();		
}

</SCRIPT>
</html>