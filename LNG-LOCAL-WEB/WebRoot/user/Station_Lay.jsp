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
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	
	//��ʼ����
	String IdList = "";
	double Longitude = 120.117392;
	double Latitude = 30.340112;
	if(null != User_Device_Detail)
	{
		int sn = 0;
		Iterator deviter = User_Device_Detail.iterator();
		while(deviter.hasNext())
		{
			DeviceDetailBean devBean = (DeviceDetailBean)deviter.next();
			if(devBean.getSign().equals("1"))
			{
				sn++;
				IdList += devBean.getId() + ",";
				if(1 == sn)
				{
					Longitude = Double.parseDouble(devBean.getLongitude());
					Latitude  = Double.parseDouble(devBean.getLatitude());
				}
			}
		}
	}
 	
%>
<body style="background:#CADFFF">
<form name="Map" action="Map.do" method="post" target="mFrame">
	<div id="container"></div>
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
}

//�����ͼ
var map = new BMap.Map("container");                      //������ͼʵ��
//map.setMapType(BMAP_HYBRID_MAP);                        //Ĭ������Ϊ���ǡ�·��һ��
var point = new BMap.Point(<%=Longitude%>, <%=Latitude%>);//�������ĵ����꣬Ĭ��Ϊ��һ����ҵ
//map.centerAndZoom(point, 5);                            //��ʼ����ͼ���������ĵ�����͵�ͼ����
map.centerAndZoom("�й�", 5);
map.addControl(new BMap.NavigationControl());             //���һ��ƽ�����ſؼ���λ�ÿ�ƫ�ơ���״�ɸı�
map.addControl(new BMap.ScaleControl());                  //���һ�������߿ؼ���λ�ÿ�ƫ��[var opts = {offset: new BMap.Size(150, 5)};map.addControl(new BMap.ScaleControl(opts));]
map.addControl(new BMap.OverviewMapControl());            //���һ������ͼ�ؼ���λ�ÿ�ƫ��
//map.addControl(new BMap.MapTypeControl());              //��ӵ�ͼ���ͱ任(��ͼ-����-��ά)��λ�ÿ�ƫ��
map.enableScrollWheelZoom();                              //���ù��ַŴ���С

//1.��Ӷ����עͼ��
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
					map.clearOverlays();
					
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
	 								addMarker(point, sublist[0], sublist[1], '../skin/images/mapcorp_green.gif', '0', '28', '28', '1');										
	      				break;
	      			case 2://�쳣
	      					var point = new BMap.Point(sublist[3], sublist[4]);
	 								addMarker(point, sublist[0], sublist[1], '../skin/images/mapcorp_green.gif', '0', '28', '28', '1');
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
</SCRIPT>
</html>