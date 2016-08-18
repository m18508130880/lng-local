<%@ page contentType="text/html; charset=gb2312" %>  
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<link type="text/css" href="../../skin/css/style.css" rel="stylesheet"/>
<link rel="stylesheet" href="../../skin/css/zTreeStyle2.css" type="text/css">
<script type="text/javascript" src="../../skin/js/util.js"></script>
<script type="text/javascript" src="../../skin/js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="../../skin/js/jquery.ztree.core-3.4.js"></script>
<script type="text/javascript" src="../../skin/js/jquery.ztree.excheck-3.4.js"></script>
<script type="text/javascript" src="../../skin/js/jquery.ztree.exedit-3.4.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
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
  
  ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  ArrayList User_User_Info = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
  CorpInfoBean Corp_Info   = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Dept = "";
  if(Corp_Info != null)
	{
		Dept = Corp_Info.getDept();
    if(Dept == null)
    {
    	Dept = "";
    }
 	}
 	
%>
<body style="background:#0B80CC;">
	<div><ul id="cadTree" class="ztree"></ul></div>
	<div id='CurrJsp' style='display:none'>Cad_Status.jsp</div>
	<input type='hidden' id='id' name='id' value=''>
	<input type='hidden' id='level' name='level' value=''>
</body>
<SCRIPT LANGUAGE=javascript>
//树操作
var rootValue = '';
var Nodes1 = [];
var setting = 
{
  edit: 
  {
    enable: false
  },
  data: 
  {
    simpleData:{enable: true}
  },
  callback: 
  {
    onClick: zTreeOnClick
  }
};

//公司
var node = {id:'-1', name:'<%=Corp_Info.getBrief()%>', value:'-1', pId:'-2', isParent:true, open:true};
Nodes1.push(node);

//公司部门
<%
if(Dept.length() > 0)
{
	String[] DeptList = Dept.split(",");
	String pDept_Id = "";
	String pDept_Name = "";
	for(int i=0; i<DeptList.length; i++)
  {
		pDept_Id   = CommUtil.IntToStringLeftFillZero(i+1, 2);
		pDept_Name = DeptList[i];
%>
		var node = {id:'<%=pDept_Id%>', name:'<%=pDept_Name%>', value:'<%=pDept_Id%>', pId:'-1', isParent:true, open:false};
		Nodes1.push(node);
<%
	}
}
%>

//站级部门
<%
String Role_List = "";
String Devi_List = "";
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
			Role_List += R_Point;
		}
	}
}
if(Role_List.length() > 0 && null != User_Device_Detail)
{
	Iterator iterator = User_Device_Detail.iterator();
	while(iterator.hasNext())
	{
		DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
		if(Role_List.contains(statBean.getId()))
		{
			Devi_List += statBean.getId() + ",";
%>
			var node = {id:'<%=statBean.getId()%>', name:'<%=statBean.getBrief()%>', value:'<%=statBean.getId()%>', pId:'-1', isParent:true, open:false};
			Nodes1.push(node);
<%
		}
	}
}
%>

//人员
<%
if(null != User_User_Info)
{
	Iterator iterator = User_User_Info.iterator();
	while(iterator.hasNext())
	{
		UserInfoBean statBean = (UserInfoBean)iterator.next();
		if(statBean.getStatus().equals("0"))
		{
			switch(statBean.getDept_Id().length())
			{
				case 2:
%>
					rootValue += '<%=statBean.getSys_Id()%>' + ',';
					var node = {id:'<%=statBean.getSys_Id()%>', name:'<%=statBean.getCName()%>', value:'<%=statBean.getSys_Id()%>', pId:'<%=statBean.getDept_Id()%>', open:false, icon:'../../skin/images/root.png'};
					Nodes1.push(node);
<%
					break;
				case 10:
					if(Devi_List.contains(statBean.getDept_Id()))
					{
%>
						rootValue += '<%=statBean.getSys_Id()%>' + ',';
						var node = {id:'<%=statBean.getSys_Id()%>', name:'<%=statBean.getCName()%>', value:'<%=statBean.getSys_Id()%>', pId:'<%=statBean.getDept_Id()%>', open:false, icon:'../../skin/images/root.png'};
						Nodes1.push(node);
<%						
					}
					break;
			}
		}
	}
}
%>

/*-----------------------------生成树----------------------------------*/
$('#cadTree').empty();
$.fn.zTree.init($('#cadTree'), setting, Nodes1);

/*-----------------------------点击树----------------------------------*/
function zTreeOnClick(event, treeId, treeNode)
{
	if(document.getElementById('CurrJsp').innerText != 'Cad_Status.jsp' 
	&& document.getElementById('CurrJsp').innerText != 'Cad_Remind.jsp' 
	&& document.getElementById('CurrJsp').innerText != 'Cad_Action.jsp')
	{
		return;
	}
	
	document.getElementById('level').value = treeNode.level;
	switch(parseInt(treeNode.level))
	{
		case 0:
				document.getElementById('id').value = rootValue;
			break;
		case 1:
				var idlist = '';
				var zTree_Dev = $.fn.zTree.getZTreeObj('cadTree');
				var node = zTree_Dev.getNodesByParam('pId', treeNode.value, null);
				for(var j in node)
				{
					idlist += node[j].value + ',';
				}
				document.getElementById('id').value = idlist;
			break;
		case 2:
				document.getElementById('id').value = treeNode.value;
			break;
	}
	
	window.parent.frames.mFrame.document.getElementById('CurrButton').click();
}

/*-----------------------------初始化----------------------------------*/
function afterLoad()
{
	document.getElementById('id').value = rootValue;
	document.getElementById('level').value = '0';
	
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0801' ctype='1'/>' == '')
	{//持证现状
		window.parent.frames.mFrame.location = "Cad_Status.do?Cmd=0&Sid=<%=Sid%>&UId="+document.getElementById('id').value+"&Func_Sub_Id=9";
	}
	else
	{
		if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0802' ctype='1'/>' == '')
		{//持证提示
			window.parent.frames.mFrame.location = "Cad_Remind.do?Cmd=0&Sid=<%=Sid%>&UId="+document.getElementById('id').value+"&Func_Sub_Id=0";
		}
		else
		{
			if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0803' ctype='1'/>' == '')
			{//行为观察
				window.parent.frames.mFrame.location = "Cad_Action.do?Cmd=0&Sid=<%=Sid%>&UId="+document.getElementById('id').value+"&Func_Sub_Id=0";
			}
		}
	}
}
afterLoad();
</SCRIPT>
</html>