<%@ page contentType="text/html; charset=gb2312" %>  
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/day.js"></script>
<%

	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	String HP_LoginId = UserInfo.getHP_LoginId();
	String HP_LoginPwd = UserInfo.getHP_LoginPwd();
	String HP_LoginIp = UserInfo.getHP_LoginIp();
	String HP_LoginPort = UserInfo.getHP_LoginPort();
	if(null == HP_LoginId){HP_LoginId = "";}
	if(null == HP_LoginPwd){HP_LoginPwd = "";}
	if(null == HP_LoginIp){HP_LoginIp = "";}
	if(null == HP_LoginPort){HP_LoginPort = "";}
	
	//功能权限
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
	
	//管理权限
	String ManageId = UserInfo.getManage_Role();
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
	
	String p3 = CommUtil.StrToGB2312(request.getParameter("p3"));
	if(null == p3)
	{
		p3 = "1";
	}		
	ArrayList User_User_Info  = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	String SYS_List = "";
								if( null != User_User_Info )
								{
									Iterator iterator = User_User_Info.iterator();
									while(iterator.hasNext())
									{
										UserInfoBean usertBean = (UserInfoBean)iterator.next();		
										String sys = 	usertBean.getSys_Id();							
										SYS_List  = SYS_List+sys;
									
									}
								}
	/**********************************************用品类型查询****************************************************************/							
	 ArrayList Lab_Store_Type = (ArrayList)session.getAttribute("Lab_Store_Type_" + Sid);
	 String typeID  = "";
	 if(null != Lab_Store_Type)
					{
						Iterator typeiter = Lab_Store_Type.iterator();
						while(typeiter.hasNext())
						{
							AqscLabourTypeBean typeBean = (AqscLabourTypeBean)typeiter.next();
							typeID = typeID+typeBean.getId();
							}
						}	
						
	
						
						
						
						
						
%>
</head>
<body style="background:#0B80CC;">
<div id="PARENT" >
	<ul id="nav">
		<li id="li01" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='01' ctype='1'/>"><a href="#" onClick="doGIS()">GIS监控</a></li>
		<li id="li02" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='02' ctype='1'/>"><a href="#" onClick="DoMenu('UserMenu2')">销售统计</a></li>
			 <ul id="UserMenu2" class="collapsed">
				 <li id="Display0201"><a href="#" onClick="doPro_R()"    style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0201' ctype='1'/>" >资源调度</a></li>
	   		 <li id="Display0202"><a href="#" onClick="doPro_I()"    style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0202' ctype='1'/>">卸车记录</a></li>
				 <li id="Display0203"><a href="#" onClick="doPro_O()"    style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0203' ctype='1'/>" >加注记录</a></li>
				 <li id="Display0204"><a href="#" onClick="doGraph()"     >图表分析</a></li>
			 </ul>			
		<li id="li03" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='03' ctype='1'/>"><a href="#" onClick="DoMenu('UserMenu3')">报表统计</a></li>	 
				<ul id="UserMenu3" class="collapsed">
					<li id="Display0301"><a href="#" onClick="doPro_GX()" 	     	style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0301' ctype='1'/>" >购销统计表</a></li>
					<li id="Display0302"><a href="#" onClick="doPro_L_Crm()"		 	style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0302' ctype='1'/>">销量确认表</a></li>
					<li id="Display0303"><a href="#" onClick="doPro_L_Stat()"		 	style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0303' ctype='1'/>" >对账表</a></li>
					<li id="Display0307"><a href="#" onClick="doPro_L_CS()"		  	style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0307' ctype='1'/>">次数对账表</a></li>
				  <li id="Display0304"><a href="#" onClick="doPro_L()"					style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0304' ctype='1'/>">场站报表</a></li>
				  <li id="Display0305"><a href="#" onClick="doPro_L_Crp()"			style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0305' ctype='1'/>">公司报表</a></li>
				  <li id="Display0306"><a href="#" onClick="doPro_CC()"			    style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0306' ctype='1'/>">槽车统计表</a></li>
	   	 	</ul>
			
	  <li id="li04" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='04' ctype='1'/>"><a href="#" onClick="doDVR()">视频监控</a></li>
	  	 <ul id="UserMenu4" class="collapsed">
				 <li id="Display0401"><a href="#" onClick="doDVR()"          	  >珠海上冲站</a></li>
	   		 <li id="Display0402"><a href="#" onClick="doDVR()"             >珠海金鼎站</a></li>
				 <li id="Display0403"><a href="#" onClick="doDVR()"             >珠海上冲扩站</a></li>
				 <li id="Display0404"><a href="#" onClick="doDVR()"          	  >珠海三灶站</a></li>
				 <li id="Display0405"><a href="#" onClick="doDVR()"             >珠海斗门站</a></li>
				 <li id="Display0406"><a href="#" onClick="doDVR()"             >珠海平沙站</a></li>
				 <li id="Display0407"><a href="#" onClick="doDVR()"             >珠海拱北站</a></li>
	   	 </ul>
	  
	  <li id="li05" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='05' ctype='1'/>"><a href="#" onClick="DoMenu('UserMenu5')">生产数据</a></li>
	     <ul id="UserMenu5" class="collapsed">
		 		 <li id="Display0501"><a href="#" onClick="doEnv()"          	style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0501' ctype='1'/>"	>实时数据</a></li>
	   		 <li id="Display0502"><a href="#" onClick="doHis()"           style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0502' ctype='1'/>"  >历史数据</a></li>
				 <!--li id="Display0503"><a href="#" onClick="doGra()"             >数据图表</a></li-->				
	   	 </ul>	  
	  <li id="li06" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='06' ctype='1'/>"><a href="#" onClick="doUserIF()">客户信息</a></li>
	  		    	  
	  <li id="li07" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='07' ctype='1'/>"><a href="#" onClick="doAlarm_Info()">告警管理</a></li>
	    <!-- <ul id="UserMenu7" class="collapsed">
				 <li id="Display0701"><a href="#" onClick="doAlarm_Info()"      style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0701' ctype='1'/>" >告警日志</a></li>
	   		<li id="Display0702"><a href="#" onClick="doAlert_Info()"      style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='0702' ctype='1'/>" >联动日志</a></li> 
	   	</ul>  "DoMenu('UserMenu7')"暂不起用-->
	  
	  <!--<li id="li08" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='08' ctype='1'/>"><a href="#" onClick="doLAY()">站点布局</a></li>-->
	    
	  
	  <li id="li09" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='09' ctype='1'/>"><a href="#" onClick="DoMenu('UserMenu9')">安全生产</a></li>
	    <ul id="UserMenu9" class="collapsed">
				 <li id="Display0901"><a href="#" onClick="doSat_Check()"         >安全检查</a></li>
	   		 <li id="Display0902"><a href="#" onClick="doSat_Danger()"        >全部隐患</a></li>
	   		 <li id="Display0903"><a href="#" onClick="doSat_Break()"         >全部违章</a></li>
	   		 <li id="Display0906"><a href="#" onClick="doCad_Action()"        >行为观察</a></li>
	   		 <li id="Display0904"><a href="#" onClick="doSat_Train()"         >安全培训</a></li>
	   		 <li id="Display0905"><a href="#" onClick="doSat_Drill()"         >应急演练</a></li>
	   	</ul>
	  
	  <li id="li10" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='10' ctype='1'/>"><a href="#" onClick="DoMenu('UserMenu10')">证件管理</a></li>
	     <ul id="UserMenu10" class="collapsed">
				 <li id="Display1001"><a href="#" onClick="doCad_Status()"     style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='1001' ctype='1'/>"   >持证现状</a></li>
	   		 <li id="Display1002"><a href="#" onClick="doCad_Remind()"     style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='1002' ctype='1'/>"  >持证提示</a></li>	   		 
	   	</ul>
	  
	  <li id="li11" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='11' ctype='1'/>"><a href="#" onClick="DoMenu('UserMenu11')">劳保用品</a></li>
	    <ul id="UserMenu11" class="collapsed">
				 <li id="Display1101"><a href="#" onClick="doKC()"          				>库存台账</a></li>
	   		<!-- <li id="Display1102"><a href="#" onClick="doSG()"                  >申购记录</a></li>-->
	   		 <li id="Display1102"><a href="#" onClick="doRK()"          				>入库记录</a></li>
	   		 <li id="Display1103"><a href="#" onClick="doCK()"          				>出库记录</a></li>
	   		 <li id="Display1104"><a href="#" onClick="doTJ()"          				>劳保盘点表</a></li>
	   	</ul>
	  
	  <li id="li12" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='12' ctype='1'/>"><a href="#" onClick="doLBP()">劳保类型</a></li>
	  
	  <li id="li13" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='13' ctype='1'/>"><a href="#" onClick="DoMenu('UserMenu13')">设备管理</a></li>
	    <ul id="UserMenu13" class="collapsed">
				 <li id="Display1301"><a href="#" onClick="doSBGL()"          style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='1301' ctype='1'/>"				>设备明细</a></li>
	   		 <li id="Display1302"><a href="#" onClick="doCZTS()"          style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='1302' ctype='1'/>"      >持证提示</a></li>
	   	</ul>
	  
	  <li id="li14" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='14' ctype='1'/>"><a href="#" onClick="DoMenu('UserMenu14')">备品备件</a></li>
	    <ul id="UserMenu14" class="collapsed">
				 <li id="Display1401"><a href="#" onClick="doBKC()"          				>库存台账</a></li>
	   		 <!--<li id="Display1402"><a href="#" onClick="doBSG()"                  >申购记录</a></li>-->
	   		 <li id="Display1402"><a href="#" onClick="doBRK()"          				>入库记录</a></li>
	   		 <li id="Display1403"><a href="#" onClick="doBCK()"          				>出库记录</a></li>
	   		 <li id="Display1404"><a href="#" onClick="doBTJ()"          				>备品备件盘点表</a></li>
	   	</ul>
	  
	  <li id="li15" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='15' ctype='1'/>"><a href="#" onClick="doBPBJ()">备品修改</a></li>
	   	
	  <li id="li16" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='16' ctype='1'/>"><a href="#" onClick="DoMenu('UserMenu16')">检定维修</a></li>
	    <ul id="UserMenu16" class="collapsed">
				 <li id="Display1601"><a href="#" onClick="doGZGZ()"          			style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='1601' ctype='1'/>"	>故障跟踪</a></li>
	   		 <li id="Display1602"><a href="#" onClick="doGZTJ()"                style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='1602' ctype='1'/>" >故障统计</a></li>
	   	</ul> 
	  <li id="li17" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='17' ctype='1'/>"><a href="#" onClick="doZJR()">站级人员</a></li>
	  	
	  <li id="li18" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='18' ctype='1'/>"><a href="#" onClick="DoMenu('UserMenu18')">设备品种管理</a></li>	
	  	<ul id="UserMenu18" class="collapsed">
				 <li id="Display1801"><a href="#" onClick="doSBPZ()"          			style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='1801' ctype='1'/>"	>设备品种</a></li>
	   		 <li id="Display1802"><a href="#" onClick="doSBZJ()"                style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='1802' ctype='1'/>"  >设备证件</a></li>
	   	</ul> 
	  <li id="li19" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='19' ctype='1'/>"><a href="#" onClick="doZJLX()" >证件类型管理</a></li>
	     <!--<ul id="UserMenu19" class="collapsed">
				 <li id="Display1601"><a href="#" onClick="doZJLX()"          			style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='1901' ctype='1'/>"	>证件类型</a></li>
	   		 <li id="Display1602"><a href="#" onClick="doXWLX()"                style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='1901' ctype='1'/>"  >行为类型</a></li>
	   	</ul> -->
	  <li id="li20" style="display:<Limit:limitValidate userrole='<%=FpList%>' fpid='20' ctype='1'/>"><a href="#" onClick="doXWLX()" >行为类型管理</a></li>
	  
	   	 
	</ul>
</div>
</body>
<script language='javascript'>
//初始化
switch(parseInt('<%=p3%>'))
{
	default:
	case 1:
			if('<Limit:limitValidate userrole='<%=FpList%>' fpid='01' ctype='1'/>' == '')
			{
				window.parent.frames.mFrame.location = 'MapMain_Map.jsp?Sid=<%=Sid%>';
			}
			else
			{
				window.parent.frames.mFrame.location = 'User_Info.jsp?Sid=<%=Sid%>';
			}
		break;
	case 2:
		break;
	case 3:
			if('<Limit:limitValidate userrole='<%=FpList%>' fpid='03' ctype='1'/>' == '')
			{
				window.parent.frames.mFrame.location = 'Device_Detail.do?Cmd=1&Sid=<%=Sid%>';
			}
			else
			{
				window.parent.frames.mFrame.location = 'User_Info.jsp?Sid=<%=Sid%>';
			}
		break;
}
//菜单Menu
var LastLeftID = "";
function DoMenu(emid)
{
	 var obj = document.getElementById(emid); 
	 obj.className = (obj.className.toLowerCase() == "expanded"?"collapsed":"expanded");
	 if((LastLeftID!="")&&(emid!=LastLeftID)) //关闭上一个Menu
	 {
	  	document.getElementById(LastLeftID).className = "collapsed";
	 }
	 LastLeftID = emid;
}
//菜单颜色变化
var LastsubID = "";
function DoDisplay(emid)
{
	 var obj = document.getElementById(emid); 
	 obj.className = (obj.className.toLowerCase() == "expanded"?"collapsed":"expanded");
	 if((LastsubID!="")&&(emid!=LastsubID)) //关闭上一个
	 {
	  	document.getElementById(LastsubID).className = "collapsed";
	 }
	 LastsubID = emid;
}


function doGIS()
{
	window.parent.frames.mFrame.location = 'MapMain_Map.jsp?Sid=<%=Sid%>';
}


/****************************************销售统计*****************************************************************/
//资源调度
function doPro_R()
{
	window.parent.frames.mFrame.location = "Pro_R.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9";
}
//卸车记录
function doPro_I()
{
	window.parent.frames.mFrame.location = "Pro_I.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Sub_Id=0&Func_Corp_Id=9999";
}
//加注记录
function doPro_O()
{
	window.parent.frames.mFrame.location = "Pro_O.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Sub_Id=9&Func_Corp_Id=3002";
}
//---------------------------------------------------报表统计-------------------------------------------------
//购销统计表
function doPro_GX()
{
	var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
  var Year  = BTime.substring(0,4);
  var Month = BTime.substring(5,7);
	window.parent.frames.mFrame.location = "Pro_GX_ZYB.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Cpm_Id=0100000001&Func_Sub_Id=1&Func_Corp_Id=3002&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
}
//销量确认表
function doPro_L_Crm()
{
	window.parent.frames.mFrame.location = "Pro_L_Crm.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Cpm_Id=<%=Manage_List%>&Func_Sub_Id=9&Func_Corp_Id=9999&Crm_Id=";
}
//对账表
function doPro_L_Stat()
{
	window.parent.frames.mFrame.location = "Pro_L_Stat.do?Cmd=1&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Cpm_Id=0100000001&DW_ID=0000000001&Func_Sub_Id=9&Func_Corp_Id=1000";

}
//次数对账
function doPro_L_CS()
{
	window.parent.frames.mFrame.location = "Pro_L_Crm.do?Cmd=1&Sid=<%=Sid%>&Func_Cpm_Id=<%=Manage_List%>&Func_Sub_Id=9&Func_Corp_Id=9999&Cpm_Id=";

}



//场站报表
function doPro_L()
{
  var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
  var Year  = BTime.substring(0,4);
  var Month = BTime.substring(5,7);
  
 
  
  
	window.parent.frames.mFrame.location = "Pro_L.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Cpm_Id=<%=Manage_List%>&Func_Sub_Id=1&Func_Corp_Id=3002&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
}
//公司报表
function doPro_L_Crp()
{
	var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
  var Year  = BTime.substring(0,4);
  var Month = BTime.substring(5,7);
	window.parent.frames.mFrame.location = "Pro_L_Crp.do?Cmd=1&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Cpm_Id=<%=Manage_List%>&Func_Sub_Id=1&Func_Corp_Id=3002&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
}
//槽车统计表
function doPro_CC()
{
	
	window.parent.frames.mFrame.location = "Pro_I_CC.do?Cmd=1&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Sub_Id=0&Func_Sel_Id=3&Func_Corp_Id=9999";
}


/*****************************************************************************视频监控*********************************/
function doDVR()
{
	window.parent.frames.mFrame.location = 'Device_Detail.do?Cmd=1&Sid=<%=Sid%>';  //????
}

/****************************************************生产数据*************************************************************/
//生产实时数据
function doEnv()
{
	window.parent.frames.mFrame.location = 'Env.do?Cmd=0&Id=<%=Manage_List%>&Level=2&Sid=<%=Sid%>&Func_Sub_Id=1';
}
//生产历史数据
function doHis()
{
	window.parent.frames.mFrame.location = 'Env.do?Cmd=2&Id=<%=Manage_List%>&Level=2&Sid=<%=Sid%>';
}
//生产数据图表
function doGra()
{
	var TDay = new Date().format("yyyy-MM-dd");
	window.parent.frames.mFrame.location = "Graph.do?Cmd=20&Id=0100000001&Sid=<%=Sid%>&Level="+'4'+"&BTime="+TDay+"&Func_Sub_Id=1";
}
/**************************************************告警管理*****************************************************************/
//告警日志
function doAlarm_Info()
{
	window.parent.frames.mFrame.location = "Alert_Info.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Id=<%=Manage_List%>&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9";
	
}
//联动日志
function doAlert_Info()
{
	window.parent.frames.mFrame.location = "Alarm_Info.do?Cmd=0&Sid=<%=Sid%>";
}
//站点布局
function doLAY()
{
	window.parent.frames.mFrame.location = 'Station_Lay.jsp?Sid=<%=Sid%>';   //???
}
/*********************************************************************安全生产***********************************************/
//安全检查
function doSat_Check()
{
	window.parent.frames.mFrame.location = "Sat_Check.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9";
}
//全部隐患
function doSat_Danger()
{
	window.parent.frames.mFrame.location = "Sat_To_Danger.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9";
	
}
//全部违章
function doSat_Break()
{
	window.parent.frames.mFrame.location = "Sat_Break.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9";
}
//安全训练
function doSat_Train()
{
	window.parent.frames.mFrame.location = "Sat_Train.do?Cmd=0&Sid=<%=Sid%>&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9";
}
//应急演练
function doSat_Drill()
{
	window.parent.frames.mFrame.location = "Sat_To_Drill.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9";
}

/******************************************************证件管理************************************************************/
//持证现状
function doCad_Status()
{
	window.parent.frames.mFrame.location = "Cad_Status.do?Cmd=0&Sid=<%=Sid%>&UId=<%=SYS_List%>&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9&Func_Cpm_Id=<%=SYS_List%>&Func_Type_Id=999";
}
//持证提示
function doCad_Remind()
{
	window.parent.frames.mFrame.location = "Cad_Remind.do?Cmd=0&Sid=<%=Sid%>&UId=<%=SYS_List%>&Func_Sub_Id=0&Func_Corp_Id=9999&Func_Sel_Id=9&Func_Type_Id=999";
}
//行为观察
function doCad_Action()
{ 
	window.parent.frames.mFrame.location = "Cad_Action.do?Cmd=0&Sid=<%=Sid%>&UId=<%=SYS_List%>&Func_Sub_Id=9&Func_Corp_Id=9999&Func_Sel_Id=9";
}

/**************************************************************劳保用品------------------------------------------**/
//库存台账
function doKC()
{
	window.parent.frames.mFrame.location = "Lab_Store.do?Cmd=0&Sid=<%=Sid%>&Func_Corp_Id=9999";
}
//申购记录
function doSG()
{
	window.parent.frames.mFrame.location = "Lab_Store_I.do?Cmd=0&Sid=<%=Sid%>&Func_Corp_Id=9999&Func_Sub_Id=0&Func_Type_Id=";
}
//入库记录
function doRK()
{
	window.parent.frames.mFrame.location = "Lab_Store_I.do?Cmd=1&Sid=<%=Sid%>&Func_Corp_Id=9999&Func_Sub_Id=0&Func_Type_Id=";
}
//出库记录

function doCK()
{
	window.parent.frames.mFrame.location = "Lab_Store_O.do?Cmd=0&Sid=<%=Sid%>&Func_Corp_Id=9999&Func_Sub_Id=9&Func_Type_Id=&Func_Cpm_Id=";	
}
//劳保盘点表
function doTJ()
{
		var Time = new Date().format("yyyy-MM-dd");
  	var BTime  = Time.substring(0,10);  	
		window.parent.frames.mFrame.location = "Lab_Store_P.do?Cmd=0&Sid=<%=Sid%>&Func_Corp_Id="+BTime+"&Func_Type_Id=6666";	

}
/****************************************************设备管理***********************************************************/

//设备明细
function doSBGL()
{
	window.parent.frames.mFrame.location = "Dev_List.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Corp_Id=9999";
}
//持证提示
function doCZTS()
{
	window.parent.frames.mFrame.location = "Dev_Remind.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Corp_Id=9999";
}
/****************************************************备品备件***************************************************************/
//库存台账
function doBKC()
{
		window.parent.frames.mFrame.location = "Spa_Store.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Corp_Id=9999&Func_Sub_Id=1&Func_Type_Id=888";
}
//申购记录
function doBSG()
{
	window.parent.frames.mFrame.location = "Spa_Store_I.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Corp_Id=9999&Func_Sub_Id=1&Func_Sel_Id=0&Func_Type_Id=";
}
//入库记录
function doBRK()
{
	window.parent.frames.mFrame.location = "Spa_Store_I.do?Cmd=1&Sid=<%=Sid%>&Func_Corp_Id=9999&Func_Sub_Id=1&Func_Sel_Id=0&Func_Type_Id=";
}
//出库记录
function doBCK()
{	
	window.parent.frames.mFrame.location = "Spa_Store_O.do?Cmd=0&Sid=<%=Sid%>&Func_Corp_Id=9999&Func_Sub_Id=1&Func_Sel_Id=9&Cpm_Id=";
}
//备品备件统计
function doBTJ()
{
		/**var Time = showPreviousFirstDay().format("yyyy-MM-dd");
  	var Year  = Time.substring(0,4);
  	var Month = Time.substring(5,7);
  	var BTime = Year+"-"+"05"+"-01";
  	var ETime = Year+"-"+"05"+"-31";
		window.parent.frames.mFrame.location = "Spa_Store_L.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Corp_Id=9999&Func_Sub_Id=1&Func_Sel_Id=1&BTime="+BTime+"&Year="+Year+"&Month="+Month+"&ETime="+ETime+"&Func_Type_Id=";**/
		var Time = new Date().format("yyyy-MM-dd");
  	var BTime  = Time.substring(0,10);  	
		window.parent.frames.mFrame.location = "Spa_Store_P.do?Cmd=0&Sid=<%=Sid%>&Func_Corp_Id="+BTime+"&Func_Type_Id=6666";

}

/***********************************************************************检定维修*************************************/
//故障跟踪
function doGZGZ()
{
	window.parent.frames.mFrame.location = "Fix_To_Trace.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Corp_Id=9999&Func_Sub_Id=0";
}
//故障统计
function doGZTJ()
{
	var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
  var Year  = BTime.substring(0,4);
  var Month = BTime.substring(5,7);
	window.parent.frames.mFrame.location = "Fix_Ledger.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Corp_Id=9999&Func_Sel_Id=1&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;

}

//客户信息
function doUserIF()
{
window.parent.frames.mFrame.location.href = "../admin/Crm_Info.do?Cmd=0&Sid=<%=Sid%>&Func_Sub_Id=9";
}



//劳保类型
function doLBP()
{
window.parent.frames.mFrame.location.href = "../admin/Aqsc_Labour_Type.do?Cmd=0&Sid=<%=Sid%>";
}
//备品备件修改
function doBPBJ()
{
	window.parent.frames.mFrame.location.href = "../admin/Aqsc_Spare_Type.do?Cmd=0&Sid=<%=Sid%>&Func_Sub_Id=9";
}
//站级人员
function doZJR()
{	
	<%
	if(null != Manage_List && Manage_List.length() > 10 )
	{
		Manage_List = "9999999999";
	
	}	
	
	%>
	window.parent.frames.mFrame.location.href = "../admin/User_Info.do?Cmd=3&Func_Corp_Id=<%=Manage_List%>&Sid=<%=Sid%>"
}
//管理设备
function doSBPZ()
{	
	window.parent.frames.mFrame.location.href = "../admin/Aqsc_Device_Breed.do?Cmd=0&Sid=<%=Sid%>"
}
function doSBZJ()
{	
  window.parent.frames.mFrame.location.href = "../admin/Aqsc_Device_Card.do?Cmd=0&Sid=<%=Sid%>"
}

//管理证件
function doZJLX()
{	
	window.parent.frames.mFrame.location.href = "../admin/Aqsc_Card_Type.do?Cmd=0&Sid=<%=Sid%>"
}
function doXWLX()
{	
  window.parent.frames.mFrame.location.href = "../admin/Aqsc_Act_Type.do?Cmd=0&Sid=<%=Sid%>"
}

function doGraph()
{
	//按月分析
	var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var BYear  = BTime.substring(0,4);
  var BMonth = BTime.substring(5,7);
  var EYear  = BTime.substring(0,4);
  var EMonth = BTime.substring(5,7);
  <%
	if("9999999999".equals(Manage_List) )
	{
		Manage_List = "0100000001";
	
	}		
	%>
  window.parent.frames.mFrame.location = "Pro_G.do?Cmd=20&Sid=<%=Sid%>&Cpm_Id=<%=Manage_List%>&Func_Corp_Id=3002&Func_Sub_Id=1&Func_Sel_Id=1&BYear="+BYear+"&BMonth="+BMonth+"&EYear="+EYear+"&EMonth="+EMonth;
}

//安全生产管理




</script>
</html>