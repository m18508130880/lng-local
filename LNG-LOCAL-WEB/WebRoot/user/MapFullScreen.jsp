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
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv='x-ua-compatible' content='ie=7'/>
<link type='text/css' href='../skin/css/style.css' rel='stylesheet'/>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/util.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/des.js'></script>
<script type='text/javascript' src='http://api.map.baidu.com/api?v=1.2&services=true'></script>
<script type='text/javascript' src='../skin/js/changeMore.js'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
<style type='text/css'>
html,body{width:100%; height:100%; margin:0; padding:0;}
#container{height:100%;}
.box{height:100%; background:#0B80CC; position:absolute; width:100%;}
.mesWindow{border:#C7C5C6 1px solid;background:#CADFFF;}
.mesWindowTop{background:#3ea3f9;padding:5px;margin:0;font-weight:bold;text-align:left;font-size:12px; clear:both; line-height:1.5em; position:relative; clear:both;}
.mesWindowTop span{ position:absolute; right:5px; top:3px;}
.mesWindowContent{margin:4px;font-size:12px; clear:both;}
.mesWindow .close{height:15px;width:28px; cursor:pointer;text-decoration:underline;background:#fff}
</style>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  ArrayList User_FP_Role       = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	
	//Ȩ������
	String FpId = UserInfo.getFp_Role();
	String ManageId = UserInfo.getManage_Role();
	String FpList = "";
	String IdList = "";
	
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
	
	if(null != ManageId && ManageId.length() > 0 && null != User_Manage_Role)
	{
		Iterator roleiter = User_Manage_Role.iterator();
		while(roleiter.hasNext())
		{
			UserRoleBean roleBean = (UserRoleBean)roleiter.next();
			if(roleBean.getId().substring(0,4).equals(ManageId) && roleBean.getId().length() == 8 && roleBean.getPoint() != null)
			{
				IdList += roleBean.getPoint();
			}
		}
	}
	
	//��ʼ����
	double Longitude = 120.117392;
	double Latitude = 30.340112;
	if(IdList.length() > 0 && null != User_Device_Detail)
	{
		int sn = 0;
		Iterator deviter = User_Device_Detail.iterator();
		while(deviter.hasNext())
		{
			DeviceDetailBean devBean = (DeviceDetailBean)deviter.next();
			if(IdList.contains(devBean.getId()))
			{
				sn++;
				if(1 == sn)
				{
					Longitude = Double.parseDouble(devBean.getLongitude());
					Latitude  = Double.parseDouble(devBean.getLatitude());
					break;
				}
			}
		}
	}
 	
%>
<body style='background:#bbbdbb' scroll='NO'>
<form name='Map' action='Map.do' method='post' target='mFrame'>
	<div id='container'></div>
	<div id='news_info' style='position:absolute;width:284px;height:100%;right:16px;top:0px;filter:alpha(Opacity=80);-moz-opacity:0.5;opacity:0.5;background-color:#bbbdbb;'>
		&nbsp;
	</div>
	<div id='menu_info' style='position:absolute;width:16px;height:100%;right:0px;top:0px;filter:alpha(Opacity=80);-moz-opacity:0.5;opacity:0.5;background-color:#bbbdbb;'>
		<img id='news_img' src='../skin/images/map2close.gif' style='width:16px;height:16px;cursor:hand;' title='����' onclick='doOpen()'>
	</div>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//������
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
{
	window.addEventListener('onorientationchange' in window ? 'orientationchange' : 'resize', setHeight, false);
	setHeight();
}
function setHeight()
{
	document.getElementById('container').style.height = document.body.offsetHeight + 'px';
	if(document.getElementById('news_info').style.display == '')
		document.getElementById('container').style.width = document.body.offsetWidth - 300 + 'px';
	else
		document.getElementById('container').style.width = document.body.offsetWidth - 16  + 'px';
}
setHeight();

function doOpen()
{
	if(document.getElementById('news_info').style.display == '')
	{
		document.getElementById('news_info').style.display = 'none';
		document.getElementById('news_img').src = '../skin/images/map2open.gif';
		document.getElementById('news_img').title = 'չ��';
	}
	else
	{
		document.getElementById('news_info').style.display = '';
		document.getElementById('news_img').src = '../skin/images/map2close.gif';
		document.getElementById('news_img').title = '����';
	}
	setHeight();
}

function doNews()
{
	if(window.XMLHttpRequest)
  {
    reqNews = new XMLHttpRequest();
  }
	else if(window.ActiveXObject)
	{
    reqNews = new ActiveXObject('Microsoft.XMLHTTP');
  }
	reqNews.onreadystatechange = function()
	{
	  var state = reqNews.readyState;
	  if(state == 4)
	  {
	    if(reqNews.status == 200)
	    {
	      var Resp = reqNews.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
	      	if(Resp.length > 4)
	      	{
	      		var objHTML = '<table width=100% border=0>';
	      		var list = Resp.substring(4).split(',');
	      		for(var i=0; i<list.length && list[i].length>0; i++)
	      		{
	      			switch(parseInt(list[i]))
	      			{
	      				case 0101:
	      					break;
	      				case 0102:
	      						objHTML += "<tr height='25px'>";
	      						objHTML += "  <td width=100% align=left>";
	      						objHTML +=     (i+1) + '��[��ȫ����]-[ȫ������]��δ�����¼!' + "&nbsp;&nbsp;<img src='../skin/images/redo.png' style='cursor:hand;' onclick='doSAT()' title='����[��ȫ����]'>";
	      						objHTML += "  </td>";
	      						objHTML += "</tr>";
	      					break;
	      				case 0103:
	      					break;
	      				case 0104:
	      					break;
	      				case 0105:
	      						objHTML += "<tr height='25px'>";
	      						objHTML += "  <td width=100% align=left>";
	      						objHTML +=     (i+1) + '��[��ȫ����]-[Ӧ������]��δ�����¼!' + "&nbsp;&nbsp;<img src='../skin/images/redo.png' style='cursor:hand;' onclick='doSAT()' title='����[��ȫ����]'>";
	      						objHTML += "  </td>";
	      						objHTML += "</tr>";
	      					break;
	      				case 0201:
	      					break;
	      				case 0202:
	      						objHTML += "<tr height='25px'>";
	      						objHTML += "  <td width=100% align=left>";
	      						objHTML +=     (i+1) + '��[֤������]-[��֤��ʾ]��δ�����¼!' + "&nbsp;&nbsp;<img src='../skin/images/redo.png' style='cursor:hand;' onclick='doCAD()' title='����[֤������]'>";
	      						objHTML += "  </td>";
	      						objHTML += "</tr>";
	      					break;
	      				case 0203:
	      					break;
	      				case 0301:
	      					break;
	      				case 0302:
	      						objHTML += "<tr height='25px'>";
	      						objHTML += "  <td width=100% align=left>";
	      						objHTML +=     (i+1) + '��[�ͱ���Ʒ]-[�깺��¼]��δ�����¼!' + "&nbsp;&nbsp;<img src='../skin/images/redo.png' style='cursor:hand;' onclick='doLAB()' title='����[�ͱ���Ʒ]'>";
	      						objHTML += "  </td>";
	      						objHTML += "</tr>";
	      					break;
	      				case 0303:
	      						objHTML += "<tr height='25px'>";
	      						objHTML += "  <td width=100% align=left>";
	      						objHTML +=     (i+1) + '��[�ͱ���Ʒ]-[����¼]��δ�����¼!' + "&nbsp;&nbsp;<img src='../skin/images/redo.png' style='cursor:hand;' onclick='doLAB()' title='����[�ͱ���Ʒ]'>";
	      						objHTML += "  </td>";
	      						objHTML += "</tr>";
	      					break;
	      				case 0304:
	      					break;
	      				case 0401:
	      					break;
	      				case 0402:
	      						objHTML += "<tr height='25px'>";
	      						objHTML += "  <td width=100% align=left>";
	      						objHTML +=     (i+1) + '��[�豸����]-[��֤��ʾ]��δ�����¼!' + "&nbsp;&nbsp;<img src='../skin/images/redo.png' style='cursor:hand;' onclick='doDEV()' title='����[�豸����]'>";
	      						objHTML += "  </td>";
	      						objHTML += "</tr>";
	      					break;
	      				case 0501:
	      					break;
	      				case 0502:
	      						objHTML += "<tr height='25px'>";
	      						objHTML += "  <td width=100% align=left>";
	      						objHTML +=     (i+1) + '��[��Ʒ����]-[�깺��¼]��δ�����¼!' + "&nbsp;&nbsp;<img src='../skin/images/redo.png' style='cursor:hand;' onclick='doSPA()' title='����[��Ʒ����]'>";
	      						objHTML += "  </td>";
	      						objHTML += "</tr>";
	      					break;
	      				case 0503:
	      						objHTML += "<tr height='25px'>";
	      						objHTML += "  <td width=100% align=left>";
	      						objHTML +=     (i+1) + '��[��Ʒ����]-[����¼]��δ�����¼!' + "&nbsp;&nbsp;<img src='../skin/images/redo.png' style='cursor:hand;' onclick='doSPA()' title='����[��Ʒ����]'>";
	      						objHTML += "  </td>";
	      						objHTML += "</tr>";
	      					break;
	      				case 0504:
	      					break;
	      				case 0505:
	      					break;
	      				case 0601:
	      						objHTML += "<tr height='25px'>";
	      						objHTML += "  <td width=100% align=left>";
	      						objHTML +=     (i+1) + '��[�춨ά��]-[���ϸ���]��δ�����¼!' + "&nbsp;&nbsp;<img src='../skin/images/redo.png' style='cursor:hand;' onclick='doFIX()' title='����[�춨ά��]'>";
	      						objHTML += "  </td>";
	      						objHTML += "</tr>";
	      					break;
	      				case 0602:
	      					break;
	      			}
	      		}
	      		objHTML += '</table>';
	      		document.getElementById('news_info').innerHTML = objHTML;
	      	}
	      	else
	      	{
	      		document.getElementById('news_info').innerHTML = '&nbsp;';
	      	}
	      }     
	    }
	  }
	};
	var url = 'ToPo.do?Cmd=24&Sid=<%=Sid%>&Id=<%=IdList%>&currtime='+new Date();
	reqNews.open('post',url,false);
	reqNews.send(null);
}
setTimeout("doNews()", 1000);
setInterval("doNews()", 15*1000);

function doSAT()
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='07' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�޲鿴��ȫ����!');
		return;
	}
	parent.location = 'sat/Main.jsp?Sid=<%=Sid%>&p3=2';
}

function doCAD()
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='08' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�޲鿴֤������!');
		return;
	}
	parent.location = 'cad/Main.jsp?Sid=<%=Sid%>&p3=2';
}

function doLAB()
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='09' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�޲鿴�ͱ���Ʒ!');
		return;
	}
	parent.location = 'lab/Main.jsp?Sid=<%=Sid%>&p3=2';
}

function doDEV()
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='10' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�޲鿴�豸����!');
		return;
	}
	parent.location = 'dev/Main.jsp?Sid=<%=Sid%>&p3=2';
}

function doSPA()
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='11' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�޲鿴��Ʒ����!');
		return;
	}
	parent.location = 'spa/Main.jsp?Sid=<%=Sid%>&p3=2';
}

function doFIX()
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='12' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�޲鿴�춨ά��!');
		return;
	}
	parent.location = 'fix/Main.jsp?Sid=<%=Sid%>&p3=2';
}

//�����ͼ
var map = new BMap.Map("container");                      //������ͼʵ��
//map.setMapType(BMAP_HYBRID_MAP);                          //Ĭ������Ϊ���ǡ�·��һ��
var point = new BMap.Point(<%=Longitude%>, <%=Latitude%>);//�������ĵ����꣬Ĭ��Ϊ��һ����ҵ
map.centerAndZoom(point, 10);                             //��ʼ����ͼ���������ĵ�����͵�ͼ����
map.addControl(new BMap.NavigationControl());             //���һ��ƽ�����ſؼ���λ�ÿ�ƫ�ơ���״�ɸı�
map.addControl(new BMap.ScaleControl());                  //���һ�������߿ؼ���λ�ÿ�ƫ��[var opts = {offset: new BMap.Size(150, 5)};map.addControl(new BMap.ScaleControl(opts));]
map.addControl(new BMap.OverviewMapControl());            //���һ������ͼ�ؼ���λ�ÿ�ƫ��
//map.addControl(new BMap.MapTypeControl());                //��ӵ�ͼ���ͱ任(��ͼ-����-��ά)��λ�ÿ�ƫ��
map.enableScrollWheelZoom();                              //���ù��ַŴ���С
map.disableDoubleClickZoom();                             //��ֹ��ͼ˫��
var mkrs = new Array();

//1.���ȫ���ؼ�
function ZoomControl()
{  
  this.defaultAnchor = BMAP_ANCHOR_BOTTOM_RIGHT;
 	this.defaultOffset = new BMap.Size(16, 1);
}  
ZoomControl.prototype = new BMap.Control();
ZoomControl.prototype.initialize = function(map)
{
	var div = document.createElement("div");
  div.id = 'OutFullScreen';
  img = document.createElement("img");
	img.src = '../skin/images/map_zoomscreen.gif';
	div.appendChild(img);
  div.style.cursor = "pointer";
  div.style.height = 14;
  div.style.width = 16;
  div.onclick = function(e)
  {
  	window.parent.location = 'MapMain.jsp?Sid=<%=Sid%>';
  }  
  map.getContainer().appendChild(div);
  return div;
}
var myZoomCtrl = new ZoomControl(); 
map.addControl(myZoomCtrl);

//2.��Ӷ����עͼ��
function addMarker(point, pId, pCName, pIcon, pStatus, pX, pY, pType)
{
	switch(parseInt(pType))
	{
		case 1://վ��
				var myIcon = new BMap.Icon(pIcon, new BMap.Size(pX, pY));
			 	var marker = new BMap.Marker(point, {icon: myIcon});
			 	var myLabel= new BMap.Label(pCName, {offset:new BMap.Size(0, pY)});
			 	myLabel.setStyle
			 	({    
			 		fontSize:"11px",
			 		font:"bold 10pt/12pt",
			 		border:"0",
			 		color:"#ffffff",
			 		textAlign:"center",
			 		background:"#1f76f8",
			 		cursor:"pointer"
			 	});
			 	marker.setLabel(myLabel);	 	
			 	map.addOverlay(marker);		 	
			 	marker.addEventListener("click", function()
			 	{
			 		switch(parseInt(pStatus))
			 		{
			 			case 0:
			 					doPro();
			 					//doDefence(pId, pCName, pStatus);
			 				break;
			 			case 1:
			 					doCpmOnOff(pId, pCName, pStatus);
			 				break;
			 			case 2:
			 					doDefence(pId, pCName, pStatus);
			 				break;
			 		}
				});
				mkrs.push(marker);
				if('2' == pStatus)
				{
					marker.setAnimation(BMAP_ANIMATION_BOUNCE);
				}
			break;
	}
}

//״̬����
var reqSend = null;
function RealStatus()
{
	if(window.XMLHttpRequest)
  {
    reqSend = new XMLHttpRequest();
  }
	else if(window.ActiveXObject)
	{
    reqSend = new ActiveXObject('Microsoft.XMLHTTP');
  }
	reqSend.onreadystatechange = function()
	{
	  var state = reqSend.readyState;
	  if(state == 4)
	  {
	    if(reqSend.status == 200)
	    {
	      var Resp = reqSend.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
	      	//1.ɾ��
	      	for(var i=0; i<mkrs.length; i++)
	      	{
	      		map.removeOverlay(mkrs[i]);
	      	}
	      	mkrs.length = 0;
	      	
	      	//2.���
	      	var list = Resp.substring(4).split(";");
	      	for(var i=0; i<list.length && list[i].length>0; i++)
	      	{
	      		var sublist = list[i].split(",");
	      		switch(parseInt(sublist[2]))
	      		{
	      			case 0://����
	      					var point = new BMap.Point(sublist[3], sublist[4]);
	 								addMarker(point, sublist[0], sublist[1], '../skin/images/mapcorp_green.gif', '0', '28', '28', '1');
	      				break;
	      			case 1://����
	      					var point = new BMap.Point(sublist[3], sublist[4]);      					
	 								addMarker(point, sublist[0], sublist[1], '../skin/images/mapcorp_gray.gif',  '1', '28', '28', '1'); 														
	      				break;
	      			case 2://�쳣
	      					if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0101' ctype='1'/>' == '')
	      					{//�쵼ģʽ
	      						var point = new BMap.Point(sublist[3], sublist[4]);
	      						addMarker(point, sublist[0], sublist[1], '../skin/images/mapcorp_green.gif', '0', '28', '28', '1');
	      					}
	      					else
	      					{//��ͨģʽ
	      						var point = new BMap.Point(sublist[3], sublist[4]);
	      						addMarker(point, sublist[0], sublist[1], '../skin/images/mapcorp_red.gif',   '2', '28', '28', '1');
	      					}
	      				break;
	      		}
	      	}
	      }     
	    }
	  }
	};
	var url = 'ToPo.do?Cmd=21&Sid=<%=Sid%>&Id=<%=IdList%>&currtime='+new Date();
	reqSend.open('post',url,false);
	reqSend.send(null);
}
setTimeout("RealStatus()", 1000);
setInterval("RealStatus()", 3*1000);

//CPM����
function doCpmOnOff(pId, pCName, pStatus)
{
	var messContent = "<div style='width:100%;height:403px;text-align:center;border:1px solid #0068a6;overflow-x:no;overflow-y:auto;'>";
	if(window.XMLHttpRequest)
	{
	  reqInfo = new XMLHttpRequest();
	}
	else if(window.ActiveXObject)
	{
	  reqInfo = new ActiveXObject('Microsoft.XMLHTTP');
	}
	reqInfo.onreadystatechange = function()
	{
	  var state = reqInfo.readyState;
	  if(state == 4)
	  {
	    if(reqInfo.status == 200)
	    {
	      var Resp = reqInfo.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
	      	var list = Resp.substring(4).split('^');
  				messContent += "<table align='center' style='margin:auto' cellpadding='0' cellspacing='0' border='0' width='97%'>";
  				messContent += "  <tr height='25px'>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>վ��</td>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>����</td>";
  				messContent += "    <td width='15%' align='center' style='background:#a1d1fa;'>ʱ��</td>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>����</td>";
  				messContent += "    <td width='15%' align='center' style='background:#a1d1fa;'>����</td>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>";
  				messContent += "      <img src='../skin/images/cmddel.gif'>";
  				messContent += "    </td>";
  				messContent += "  </tr>";
  				for(var i=0; i<list.length && list[i].length>0; i++)
					{
						var sublist = list[i].split('~');
						var str_CType = '';
						switch(parseInt(sublist[7]))
						{
							case 1:
									str_CType = 'ϵͳ�澯';
								break;
							case 2:
									str_CType = '���ݸ澯';
								break;
						}
						messContent += "<tr height='25px'>";
    				messContent += "  <td width='10%' align='center'>"+ sublist[2] +"</td>";
    				messContent += "  <td width='10%' align='center'>"+ str_CType  +"</td>";
    				messContent += "  <td width='15%' align='center'>"+ sublist[8] +"</td>";
    				messContent += "  <td width='10%' align='center'>"+ sublist[10]+"</td>";
    				messContent += "  <td width='15%' align='center'>"+ sublist[9] +"</td>";
    				messContent += "  <td width='10%' align='center'>";
    				messContent += "    <img src='../skin/images/cmddel.gif' title='�˹�����' style='cursor:hand' onClick=\"doIgnored('"+pId+"', '"+pCName+"', '"+pStatus+"', '"+sublist[0]+"', '<%=UserInfo.getId()%>', '"+pId+"', '', '')\">";
    				messContent += "  </td>";
    				messContent += "</tr>";
					}
					messContent += "</table>";			
	      }  
	      else
	      {
	      	messContent += "��ѯʧ��...";
	      }   
	    }
	    else
	    {
	    	messContent += "��ѯʧ��...";
	    }
	  }
	};
	var url = 'ToPo.do?Cmd=22&Sid=<%=Sid%>&Id='+pId+'&CType=0&currtime='+new Date();
	reqInfo.open('post',url,false);
	reqInfo.send(null);
	
	messContent += "</div>";
	messContent += "<div style='width:100%;height:60px;text-align:center;border:1px solid #0068a6;overflow-x:no;overflow-y:auto;'>";
	messContent += "  <img src='../skin/images/alarm_low.gif' style='cursor:hand' onClick='doAla()'>";
	messContent += "</div>";
	var pHead = "<font color='red'>["+pCName+"]</font>";
	showMessageBox(pHead, messContent , 600, 500);
}

//���Ӹ澯����
function doAla()
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='05' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�޲鿴�澯����!');
		return;
	}
	parent.location = 'log/Main.jsp?Sid=<%=Sid%>&p3=2';
}

//��������ͳ��
/**function doPro()
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='02' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�޲鿴����ͳ��!');
		return;
	}
	parent.location = 'pro/Main.jsp?Sid=<%=Sid%>&p3=2';
}
**/
//������������
function doDat()
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='04' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�޲鿴��������!');
		return;
	}
	parent.location = 'env/Main.jsp?Sid=<%=Sid%>&p3=2';
}

//�˹�����
var reqIgnore = null;
function doIgnored(pId, pCName, pStatus, pSN, pOperator, pCpm_Id, pDId, pAttr_Id)
{
	if(confirm("ȷ�����˹�����ǰ�澯?"))
	{
		if(window.XMLHttpRequest)
	  {
			reqIgnore = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqIgnore = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//���ûص�����
		reqIgnore.onreadystatechange = function()
		{
			var state = reqIgnore.readyState;
			if(state == 4)
			{
				if(reqIgnore.status == 200)
				{
					var resp = reqIgnore.responseText;			
					if(resp != null && resp.substring(0,4) == '0000')
					{
						alert('�ɹ�');
						//doDefence(pId, pCName, pStatus);
						closeWindow();
						return;
					}
					else
					{
						alert('ʧ�ܣ������²���');
						return;
					}
				}
				else
				{
					alert("ʧ�ܣ������²���");
					return;
				}
			}
		};
		var url = "GIS_Deal.do?Sid=<%=Sid%>&SN="+pSN+"&Operator="+pOperator+"&Cpm_Id="+pCpm_Id+"&Id="+pDId+"&Attr_Id="+pAttr_Id+"&currtime="+new Date();
		reqIgnore.open("post",url,true);
		reqIgnore.send(null);
		return true;
	}
}

//ʵʱ�澯
var reqInfo = null;
function doDefence(pId, pCName, pStatus)
{	
	var messContent = "<div style='width:100%;height:403px;text-align:center;border:1px solid #0068a6;overflow-x:no;overflow-y:auto;'>";
	if(window.XMLHttpRequest)
	{
	  reqInfo = new XMLHttpRequest();
	}
	else if(window.ActiveXObject)
	{
	  reqInfo = new ActiveXObject('Microsoft.XMLHTTP');
	}
	reqInfo.onreadystatechange = function()
	{
	  var state = reqInfo.readyState;
	  if(state == 4)
	  {
	    if(reqInfo.status == 200)
	    {
	      var Resp = reqInfo.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
	      	var list = Resp.substring(4).split('^');
  				messContent += "<table align='center' style='margin:auto' cellpadding='0' cellspacing='0' border='0' width='97%'>";
  				messContent += "  <tr height='25px'>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>վ��</td>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>�豸</td>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>����</td>";
  				messContent += "    <td width='15%' align='center' style='background:#a1d1fa;'>ʱ��</td>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>����</td>";
  				messContent += "    <td width='15%' align='center' style='background:#a1d1fa;'>����</td>";
  				messContent += "    <td width='5%'  align='center' style='background:#a1d1fa;'>";
  				messContent += "      <img src='../skin/images/cmddel.gif'>";
  				messContent += "    </td>";
  				messContent += "  </tr>";
  				for(var i=0; i<list.length && list[i].length>0; i++)
					{
						var sublist = list[i].split('~');
						var str_CType = '';
						switch(parseInt(sublist[7]))
						{
							case 1:
									str_CType = 'ϵͳ�澯';
								break;
							case 2:
									str_CType = '���ݸ澯';
								break;
						}
						messContent += "<tr height='25px'>";
    				messContent += "  <td width='10%' align='center'>"+ sublist[2] +"</td>";
    				messContent += "  <td width='10%' align='center'>"+ sublist[4] +"</td>";
    				messContent += "  <td width='10%' align='center'>"+ str_CType  +"</td>";
    				messContent += "  <td width='15%' align='center'>"+ sublist[8] +"</td>";
    				messContent += "  <td width='10%' align='center'>"+ sublist[10]+"</td>";
    				messContent += "  <td width='15%' align='center'>"+ sublist[9] +"</td>";
    				messContent += "  <td width='5%'  align='center'>";
    				messContent += "    <img src='../skin/images/cmddel.gif' title='�˹�����' style='cursor:hand' onClick=\"doIgnored('"+pId+"', '"+pCName+"', '"+pStatus+"', '"+sublist[0]+"', '<%=UserInfo.getId()%>', '"+pId+"', '"+sublist[3]+"', '"+sublist[5]+"')\">";
    				messContent += "  </td>";
    				messContent += "</tr>";
					}
					messContent += "</table>";
	      }
	      else
	      {
	      	messContent += "��ѯʧ��...";
	      }
	    }
	    else
	    {
	    	messContent += "��ѯʧ��...";
	    }
	  }
	};
	var url = 'ToPo.do?Cmd=22&Sid=<%=Sid%>&Id='+pId+'&CType=1&currtime='+new Date();
	reqInfo.open('post',url,false);
	reqInfo.send(null);
	
	messContent += "</div>";
	messContent += "<div style='width:100%;height:60px;text-align:center;border:1px solid #0068a6;overflow-x:no;overflow-y:auto;'>";
	messContent += "  <img src='../skin/images/alarm_low.gif' style='cursor:hand' onClick='doAla()'>";
	messContent += "</div>";
	
	//ipad����ʵʱ��Ƶ
	var pHead = '';
	if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
	{
		pHead = "<font color='red'>["+pCName+"]</font>&nbsp;&nbsp;&nbsp;" + "<a href='#' onClick=\"doDefence('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><font color=blue><U>ʵʱ�澯</U></font></a>&nbsp;&nbsp;&nbsp;<a href='#' onClick=\"doEnv('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><U>ʵʱ����</U></a>&nbsp;&nbsp;&nbsp;<a href='#' onClick=\"doNet('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><U>ʵʱ״̬</U></a>";
	}
	else
	{
		pHead = "<font color='red'>["+pCName+"]</font>&nbsp;&nbsp;&nbsp;" + "<a href='#' onClick=\"doDefence('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><font color=blue><U>ʵʱ�澯</U></font></a>&nbsp;&nbsp;&nbsp;<a href='#' onClick=\"doEnv('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><U>ʵʱ����</U></a>&nbsp;&nbsp;&nbsp;<a href='#' onClick=\"doNet('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><U>ʵʱ״̬</U></a>&nbsp;&nbsp;&nbsp;<a href='#' onClick=\"doDvr('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><U>ʵʱ��Ƶ</U></a>";
	}
	showMessageBox(pHead, messContent , 600, 500);
}

//ʵʱ����
function doEnv(pId, pCName, pStatus)
{
	var messContent = "<div style='width:100%;height:403px;text-align:center;border:1px solid #0068a6;overflow-x:no;overflow-y:auto;'>";
	if(window.XMLHttpRequest)
	{
	  reqInfo = new XMLHttpRequest();
	}
	else if(window.ActiveXObject)
	{
	  reqInfo = new ActiveXObject('Microsoft.XMLHTTP');
	}
	reqInfo.onreadystatechange = function()
	{
	  var state = reqInfo.readyState;
	  if(state == 4)
	  {
	    if(reqInfo.status == 200)
	    {
	      var Resp = reqInfo.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
	      	var list = Resp.substring(4).split('^');
  				messContent += "<table align='center' style='margin:auto' cellpadding='0' cellspacing='0' border='0' width='97%'>";
  				messContent += "  <tr height='25px'>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>վ��</td>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>�豸</td>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>����</td>";
  				messContent += "    <td width='15%' align='center' style='background:#a1d1fa;'>ʱ��</td>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>��ֵ</td>";
  				messContent += "    <td width='10%' align='center' style='background:#a1d1fa;'>����</td>";
  				messContent += "    <td width='15%' align='center' style='background:#a1d1fa;'>����</td>";
  				messContent += "  </tr>";
  				for(var i=0; i<list.length && list[i].length>0; i++)
					{
						var sublist = list[i].split('~');
						messContent += "<tr height='25px'>";
    				messContent += "  <td width='10%' align='center'>"+ sublist[0] +"</td>";
    				messContent += "  <td width='10%' align='center'>"+ sublist[1] +"</td>";
    				messContent += "  <td width='10%' align='center'>"+ sublist[2] +"</td>";
    				messContent += "  <td width='15%' align='center'>"+ sublist[3] +"</td>";
    				messContent += "  <td width='10%' align='center'>"+ sublist[4] + sublist[5] +"</td>";
    				messContent += "  <td width='10%' align='center'>"+ sublist[6] +"</td>";
    				messContent += "  <td width='15%' align='center'>"+ sublist[7] +"</td>";
    				messContent += "</tr>";
					}
					messContent += "</table>";
	      }
	      else
	      {
	      	messContent += "��ѯʧ��...";
	      }
	    }
	    else
	    {
	    	messContent += "��ѯʧ��...";
	    }
	  }
	};
	var url = 'ToPo.do?Cmd=22&Sid=<%=Sid%>&Id='+pId+'&CType=2&currtime='+new Date();
	reqInfo.open('post',url,false);
	reqInfo.send(null);
	
	messContent += "</div>";
	messContent += "<div style='width:100%;height:60px;text-align:center;border:1px solid #0068a6;overflow-x:no;overflow-y:auto;'>";
	messContent += "  <img src='../skin/images/data_low.gif' style='cursor:hand' onClick='doDat()'>";
	messContent += "</div>";
	
	//ipad����ʵʱ��Ƶ
	var pHead = '';
	if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
	{
		pHead = "<font color='red'>["+pCName+"]</font>&nbsp;&nbsp;&nbsp;" + "<a href='#' onClick=\"doDefence('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><U>ʵʱ�澯</U></a>&nbsp;&nbsp;&nbsp;<a href='#' onClick=\"doEnv('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><font color=blue><U>ʵʱ����</U></font></a>&nbsp;&nbsp;&nbsp;<a href='#' onClick=\"doNet('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><U>ʵʱ״̬</U></a>";
	}
	else
	{
		pHead = "<font color='red'>["+pCName+"]</font>&nbsp;&nbsp;&nbsp;" + "<a href='#' onClick=\"doDefence('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><U>ʵʱ�澯</U></a>&nbsp;&nbsp;&nbsp;<a href='#' onClick=\"doEnv('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><font color=blue><U>ʵʱ����</U></font></a>&nbsp;&nbsp;&nbsp;<a href='#' onClick=\"doNet('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><U>ʵʱ״̬</U></a>&nbsp;&nbsp;&nbsp;<a href='#' onClick=\"doDvr('"+pId+"', '"+pCName+"', '"+pStatus+"')\"><U>ʵʱ��Ƶ</U></a>";
	}
	showMessageBox(pHead, messContent , 600, 500);
}

//ʵʱ״̬
function doNet(pId, pCName, pStatus)
{
	if(window.XMLHttpRequest)
	{
	  reqInfo = new XMLHttpRequest();
	}
	else if(window.ActiveXObject)
	{
	  reqInfo = new ActiveXObject('Microsoft.XMLHTTP');
	}
	reqInfo.onreadystatechange = function()
	{
	  var state = reqInfo.readyState;
	  if(state == 4)
	  {
	    if(reqInfo.status == 200)
	    {
	      var Resp = reqInfo.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
	      	var list = Resp.substring(4).split('~');
	      	var pLink_Url = list[0];
	      	var pLink_Port= list[1];
	      	var pLink_Id  = list[2];
	      	var pLink_Pwd = list[3];
	      	
					if(pLink_Url.Trim().length < 1 || pLink_Id.Trim().length < 1 || pLink_Pwd.Trim().length < 1)
					{
						alert('��ǰվ�����ô����޷�Զ�̲鿴!');
						return;
					}
					
					//����
					var D_LinkStr = '';
					if(pLink_Port.Trim().length < 1)
						D_LinkStr = 'http://' + pLink_Url + '/cgi-bin/login.cgi?username=' + pLink_Id + '&password=' + pLink_Pwd + '&link=01';
					else
						D_LinkStr = 'http://' + pLink_Url + ':' + pLink_Port + '/cgi-bin/login.cgi?username=' + pLink_Id + '&password=' + pLink_Pwd + '&link=01';
					
					DES.init(DesKey, D_LinkStr);
					var E_LinkStr  = DES.Encrypt();
					parent.location = "L_Main.jsp?Sid=<%=Sid%>&p1="+E_LinkStr+"&p2="+pCName+"&p3=2";
	      }
	      else
	      {
	      	alert('ʧ��,�����²���');
	      	return;
	      }
	    }
	    else
	    {
	    	alert('ʧ��,�����²���');
	    	return;
	    }
	  }
	};
	var url = 'ToPo.do?Cmd=22&Sid=<%=Sid%>&Id='+pId+'&CType=3&currtime='+new Date();
	reqInfo.open('post',url,false);
	reqInfo.send(null);
}

//ʵʱ��Ƶ
function doDvr(pId, pCName, pStatus)
{
	if(window.XMLHttpRequest)
	{
	  reqInfo = new XMLHttpRequest();
	}
	else if(window.ActiveXObject)
	{
	  reqInfo = new ActiveXObject('Microsoft.XMLHTTP');
	}
	reqInfo.onreadystatechange = function()
	{
	  var state = reqInfo.readyState;
	  if(state == 4)
	  {
	    if(reqInfo.status == 200)
	    {
	      var Resp = reqInfo.responseText;
	      if(null != Resp && Resp.length >= 4 && Resp.substring(0,4) == '0000')
	      {
	      	var list = Resp.substring(4).split('~');
	      	var pLink_Url = list[0];
	      	var pLink_Port= list[1];
	      	var pLink_Id  = list[2];
	      	var pLink_Pwd = list[3];
	      	
					if(pLink_Url.Trim().length < 1 || pLink_Id.Trim().length < 1 || pLink_Pwd.Trim().length < 1)
					{
						alert('��ǰվ�����ô����޷�Զ�̲鿴!');
						return;
					}
					
					//����
					var D_LinkStr = '';
					if(pLink_Port.Trim().length < 1)
						D_LinkStr = 'http://' + pLink_Url + '/cgi-bin/login.cgi?username=' + pLink_Id + '&password=' + pLink_Pwd + '&link=04';
					else
						D_LinkStr = 'http://' + pLink_Url + ':' + pLink_Port + '/cgi-bin/login.cgi?username=' + pLink_Id + '&password=' + pLink_Pwd + '&link=04';
						
					DES.init(DesKey, D_LinkStr);
					var E_LinkStr  = DES.Encrypt();
					parent.location = "L_Main.jsp?Sid=<%=Sid%>&p1="+E_LinkStr+"&p2="+pCName+"&p3=2";
	      }
	      else
	      {
	      	alert('ʧ��,�����²���');
	      	return;
	      }
	    }
	    else
	    {
	    	alert('ʧ��,�����²���');
	    	return;
	    }
	  }
	};
	var url = 'ToPo.do?Cmd=22&Sid=<%=Sid%>&Id='+pId+'&CType=3&currtime='+new Date();
	reqInfo.open('post',url,false);
	reqInfo.send(null);
}
</SCRIPT>
</html>