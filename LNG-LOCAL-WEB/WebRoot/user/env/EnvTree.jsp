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
	ArrayList User_FP_Role       = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	ArrayList User_Data_Device   = (ArrayList)session.getAttribute("User_Data_Device_" + Sid);
	ArrayList User_Data_Attr     = (ArrayList)session.getAttribute("User_Data_Attr_" + Sid);
	UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	
	String FpId = UserInfo.getFp_Role();
	String ManageId = UserInfo.getManage_Role();
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
  
%>
<body style="background:#0B80CC;">
	<div><ul id="envTree" class="ztree"></ul></div>
	<input type='hidden' id='id' name='id' value=''>
	<input type='hidden' id='level' name='level' value=''>
</body>
<SCRIPT LANGUAGE=javascript>
//树操作
var rootValue = '';
var subrootValue = '';
var rootseq = 0;
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

<%
if(null != ManageId && ManageId.length() > 0 && null != User_Manage_Role)
{
	Iterator iterator = User_Manage_Role.iterator();
	while(iterator.hasNext())
	{
		UserRoleBean statBean = (UserRoleBean)iterator.next();
		if(statBean.getId().substring(0,4).equals(ManageId))
		{
			String R_Id = statBean.getId();
			String R_CName = statBean.getCName();
			String R_Point = statBean.getPoint();
			if(null == R_CName){R_CName = "";}
			if(null == R_Point){R_Point = "";}
			
			switch(R_Id.length())
			{
				case 4:
%>
						/*
						var node = {id:'<%=R_Id%>', name:'<%=R_CName%>', value:'<%=R_Point%>', pId:'<%=R_Id%>', isParent:true, open:true, icon:'../../skin/images/root.png'};
						Nodes1.push(node);
						*/
<%
					break;
				case 6:
%>
						rootseq++;
						if(1 == rootseq)
						{
							rootValue = '<%=R_Id%>';
						}					
						var node = {id:'<%=R_Id%>', name:'<%=R_CName%>', value:'<%=R_Point%>', pId:'<%=R_Id.substring(0,4)%>', isParent:true, open:true};
						Nodes1.push(node);
<%
					break;
				case 8:
%>
						subrootValue += '<%=R_Id%>' + ',';
						var node = {id:'<%=R_Id%>', name:'<%=R_CName%>', value:'<%=R_Point%>', pId:'<%=R_Id.substring(0,6)%>', isParent:true, open:true};
						Nodes1.push(node);
<%
					break;
			}
			if(R_Point.trim().length() > 0)
			{
				String[] list = R_Point.split(",");
				for(int i=0; i<list.length && list[i].trim().length() > 0; i++)
				{
					if(User_Device_Detail != null)
					{
						Iterator iterator2 = User_Device_Detail.iterator();
						while(iterator2.hasNext())
						{
							DeviceDetailBean Bean = (DeviceDetailBean)iterator2.next();
							if(Bean.getId().equals(list[i]))
							{
								String Id = Bean.getId();
								String Brief = Bean.getBrief();
%>
								var node = {id:'<%=Id%>', name:'<%=Brief%>', value:'<%=Id%>', pId:'<%=R_Id%>', isParent:false, open:false};
								Nodes1.push(node);
<%
								//站点设备
								if(null != User_Data_Device)
								{
									Iterator dev_iter = User_Data_Device.iterator();
									while(dev_iter.hasNext())
									{
										DataBean devBean = (DataBean)dev_iter.next();
										if(devBean.getCpm_Id().equals(Id))
										{
%>
											var node = {id:'<%=devBean.getCpm_Id()+devBean.getId()%>', name:'<%=devBean.getCName()%>', value:'<%=devBean.getCpm_Id()+devBean.getId()%>', pId:'<%=devBean.getCpm_Id()%>', isParent:false, open:false};
											Nodes1.push(node);
<%										
										}
									}
								}							
								//站点参数
								if(null != User_Data_Attr)
								{
									Iterator attr_iter = User_Data_Attr.iterator();
									while(attr_iter.hasNext())
									{
										DataBean attrBean = (DataBean)attr_iter.next();
										if(attrBean.getCpm_Id().equals(Id))
										{
%>
											var node = {id:'<%=attrBean.getCpm_Id()+attrBean.getId()+attrBean.getAttr_Id()%>', name:'<%=attrBean.getAttr_Name()%>', value:'<%=attrBean.getCpm_Id()+attrBean.getId()+attrBean.getAttr_Id()%>', pId:'<%=attrBean.getCpm_Id()+attrBean.getId()%>', isParent:false, open:false};
											Nodes1.push(node);
<%										
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
%>

/*-----------------------------生成树----------------------------------*/
$('#envTree').empty();
$.fn.zTree.init($('#envTree'), setting, Nodes1);

/*-----------------------------点击树----------------------------------*/
function zTreeOnClick(event, treeId, treeNode)
{
	if(0 == treeNode.level)
	{
		var idlist = '';
		if(subrootValue.length > 0)
		{
			var list = subrootValue.split(',');
			for(var i=0; i<list.length; i++)
			{
				if(list[i].indexOf(treeNode.id) >= 0)
				{
					var zTree_Dev = $.fn.zTree.getZTreeObj('envTree');
					var node = zTree_Dev.getNodesByParam('id', list[i]);
					for(var j in node)
					{
						idlist += node[j].value;
					}				
				}
			}
		}
		document.getElementById('id').value = idlist;
	}
	else
	{
		document.getElementById('id').value = treeNode.value;
	}
	document.getElementById('level').value = treeNode.level;
	window.parent.frames.mFrame.document.getElementById('CurrButton').click();
}

/*-----------------------------初始化----------------------------------*/
function afterLoad()
{
	var idlist = '';
	var zTree_Dev = $.fn.zTree.getZTreeObj('envTree');
	var node = zTree_Dev.getNodesByParam('pId', rootValue, null);
	for(var j in node)
	{
		idlist += node[j].value;
	}
	document.getElementById('id').value = idlist;
	document.getElementById('level').value = '0';
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0401' ctype='1'/>' == '')
	{//实时数据
		window.parent.frames.mFrame.location = "Env.do?Cmd=0&Sid=<%=Sid%>&Id="+document.getElementById('id').value+"&Level="+document.getElementById('level').value+"&Func_Sub_Id=1";
	}
	else
	{
		if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0402' ctype='1'/>' == '')
		{//历史数据
			window.parent.frames.mFrame.location = "Env.do?Cmd=2&Sid=<%=Sid%>&Id="+document.getElementById('id').value+"&Level="+document.getElementById('level').value;
		}
		else
		{
			if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0403' ctype='1'/>' == '')
			{//数据图表
				var TDay = new Date().format("yyyy-MM-dd");
				var Id = document.getElementById('id').value;
				var Level = document.getElementById('level').value;
				if('4' != Level)
				{
					Id = '';
				}
				window.parent.frames.mFrame.location = "Graph.do?Cmd=20&Sid=<%=Sid%>&Id="+Id+"&Level="+Level+"&BTime="+TDay+"&Func_Sub_Id=1";
			}
		}
	}
}
afterLoad();
</SCRIPT>
</html>