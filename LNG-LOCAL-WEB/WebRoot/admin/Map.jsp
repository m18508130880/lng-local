<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/util.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script src="http://api.map.baidu.com/api?v=1.2&services=true" type="text/javascript"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
<style>
	html{height:100%}
	body{height:100%; margin:0px; padding:0px}
	#container{height:100%}
  html,body{width:100%; height:100%; margin:0; padding:0;}/*���뽫���������һ���߶�*/
  .mesWindow{border:#C7C5C6 1px solid;background:#CADFFF;}
  .mesWindowTop{background:#3ea3f9;padding:5px;margin:0;font-weight:bold;text-align:left;font-size:12px; clear:both; line-height:1.5em; position:relative; clear:both;}
  .mesWindowTop span{ position:absolute; right:5px; top:3px;}
  .mesWindowContent{margin:4px;font-size:12px; clear:both;}
  .mesWindow .close{height:15px;width:28px; cursor:pointer;text-decoration:underline;background:#fff}
</style>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Device_Detail = (ArrayList)session.getAttribute("Device_Detail_" + Sid);
	double Longitude = 120.117392;
	double Latitude = 30.340112;
	
	int sn = 0;
	if(null != Device_Detail)
	{	
		Iterator iterator = Device_Detail.iterator();
		while(iterator.hasNext())
		{
			DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
			if(statBean.getSign().equals("1") && 0 == sn)
			{
			  sn++;
				Longitude = Double.parseDouble(statBean.getLongitude());
				Latitude  = Double.parseDouble(statBean.getLatitude());
				break;
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
//map.setMapType(BMAP_HYBRID_MAP);                          //Ĭ������Ϊ���ǡ�·��һ��
var point = new BMap.Point(<%=Longitude%>, <%=Latitude%>);//�������ĵ����꣬Ĭ��Ϊ��һ����ҵ
map.centerAndZoom(point, 10);                              //��ʼ����ͼ���������ĵ�����͵�ͼ����
map.addControl(new BMap.NavigationControl());             //���һ��ƽ�����ſؼ���λ�ÿ�ƫ�ơ���״�ɸı�
map.addControl(new BMap.ScaleControl());                  //���һ�������߿ؼ���λ�ÿ�ƫ��[var opts = {offset: new BMap.Size(150, 5)};map.addControl(new BMap.ScaleControl(opts));]
map.addControl(new BMap.OverviewMapControl());            //���һ������ͼ�ؼ���λ�ÿ�ƫ��
//map.addControl(new BMap.MapTypeControl());                //��ӵ�ͼ���ͱ任(��ͼ-����-��ά)��λ�ÿ�ƫ��
map.enableScrollWheelZoom();                              //���ù��ַŴ���С

//1.��ӵ�ͼ�һ���ӱ�ע
map.addEventListener("rightclick", function(e)
{
 	doRightClick(e);
});

//2.��Ӷ����עͼ��
function addMarker(point, pCorp_Id, pCName, pIcon, pX, pY, pType)
{
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
 		doDefence(pCorp_Id, pCName, pType);
	});
	marker.enableDragging();  
	marker.addEventListener("dragend", function(e)
	{  
		doDragging(pCorp_Id, e.point.lng, e.point.lat, pType);  	
	});
}

//��Ӷ����עͼ��
<%
String Device_All = "";
if(Device_Detail != null)
{
	for(int i=0; i<Device_Detail.size(); i++)
	{
		DeviceDetailBean Device = (DeviceDetailBean)Device_Detail.get(i);
		if(Device.getSign().equals("1"))
		{
			Device_All += Device.getId() + ",";
		}
	}
}
%>

//״̬���
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
	 								addMarker(point, sublist[0], sublist[1], '../skin/images/mapcorp_green.gif', '28', '28', '1');
	      				break;
	      			case 1://����
	      					var point = new BMap.Point(sublist[3], sublist[4]);
	 								addMarker(point, sublist[0], sublist[1], '../skin/images/mapcorp_green.gif', '28', '28', '1');
	      				break;
	      			case 2://�쳣
	      					var point = new BMap.Point(sublist[3], sublist[4]);
	 								addMarker(point, sublist[0], sublist[1], '../skin/images/mapcorp_green.gif', '28', '28', '1');
	      				break;
	      		}
	      	}
	      }
	    }
	  }
	};
	var url = 'ToPo.do?Cmd=21&Id=<%=Device_All%>&Sid=<%=Sid%>&currtime='+new Date();
	reqSend.open('POST',url,false);
	reqSend.send(null);
}
setTimeout("RealStatus()", 1000);

//�ҵ���¼�
var reqUnMarke = null;
function doRightClick(e)
{
	//��ȡδ���
	if(window.XMLHttpRequest)
  {
		reqUnMarke = new XMLHttpRequest();
	}
	else if(window.ActiveXObject)
	{
		reqUnMarke = new ActiveXObject("Microsoft.XMLHTTP");
	}
	reqUnMarke.onreadystatechange = function()
	{
	  var state = reqUnMarke.readyState;
	  if(state == 4)
	  {
	    if(reqUnMarke.status == 200)
	    {
	      var Resp = reqUnMarke.responseText;
	      if(null != Resp && Resp.substring(0,4) == '0000')
	      {
	      	//վ��
	      	var list = Resp.substring(4).split(';');
					var content = "<select id='Id' name='Id' style='width:220px;height:20px;'>";
	      	for(var i=0; i<list.length && list[i].length>0; i++)
	      	{
	      		var sublist = list[i].split(',');
	      		content += "<option value='"+ list[i] +"'>"+ sublist[1] +"</option>";
	      	}
					content += "</select>";
					content += "<input type='button' value='��עվ��' onClick=\"doAddMarke('1', "+e.point.lng+", "+e.point.lat+")\">";
					var opts = 
					{
					  width : 350, // ��Ϣ���ڿ��  
					  height: 60, // ��Ϣ���ڸ߶�  
					  title : ""  // ��Ϣ���ڱ���
					}
					var infoWindow = new BMap.InfoWindow(content, opts);//������Ϣ���ڶ���  
					map.openInfoWindow(infoWindow, e.point);            //����Ϣ����
	      }  
	      else
	      {
	    		return;
	      }   
	    }
	    else
	    {
	    	return;
	    }
	  }
	};
	var url = "ToPo.do?Cmd=23&Sid=<%=Sid%>&currtime="+new Date();
	reqUnMarke.open("POST",url,true);
	reqUnMarke.send(null);
	return true;
}

//��ӱ�ע
var reqAdd = null;
function doAddMarke(pType, Lng, Lat)
{
	if(document.getElementById('Id').value.length < 1)
	{
		alert('��ѡ��Ҫ��ע��վ��!');
		return;
	}
	var Id = document.getElementById('Id').value.split(',')[0];
	var CName = document.getElementById('Id').value.split(',')[1];
	if(confirm('ȷ����ӱ�ע?'))
	{
		if(window.XMLHttpRequest)
	  {
			reqAdd = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqAdd = new ActiveXObject("Microsoft.XMLHTTP");
		}
		reqAdd.onreadystatechange = function()
		{
		  var state = reqAdd.readyState;
		  if(state == 4)
		  {
		    if(reqAdd.status == 200)
		    {
		      var Resp = reqAdd.responseText;
		      if(null != Resp && Resp.substring(0,4) == '0000')
		      {
		      	map.closeInfoWindow();
		      	var point = new BMap.Point(Lng, Lat);
						addMarker(point, Id, CName, '../skin/images/mapcorp_green.gif', '28', '28', pType);
		      	alert('��ӱ�ע�ɹ�!');
		    		return;
		      }
		      else
		      {
		      	alert('��ӱ�עʧ��!');
		    		return;
		      }
		    }
		    else
		    {
		    	alert('��ӱ�עʧ��!');
		    	return;
		    }
		  }
		};
		var url = "Device_doDragging.do?Cmd=17&Sid=<%=Sid%>&Id="+Id+"&Longitude="+Lng+"&Latitude="+Lat+"&currtime="+new Date();
		reqAdd.open("POST",url,true);
		reqAdd.send(null);
		return true;
	}
}

//��ק������½ӿ�
var reqDrg = null;
function doDragging(pId, pLng, pLat, pType)
{
	if(confirm('ͬ�����µ�ǰվ������?'))
	{
		if(window.XMLHttpRequest)
	  {
			reqDrg = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqDrg = new ActiveXObject("Microsoft.XMLHTTP");
		}
		reqDrg.onreadystatechange = function()
		{
		  var state = reqDrg.readyState;
		  if(state == 4)
		  {
		    if(reqDrg.status == 200)
		    {
		      var Resp = reqDrg.responseText;
		      if(null != Resp && Resp.substring(0,4) == '0000')
		      {
		      	alert('����ͬ�����³ɹ�!');
		    		return;
		      }  
		      else
		      {
		      	alert('����ͬ������ʧ��!');
		    		return;
		      }   
		    }
		    else
		    {
		    	alert('����ͬ������ʧ��!');
		    	return;
		    }
		  }
		};
		var url = "Device_doDragging.do?Cmd=15&Sid=<%=Sid%>&Id="+pId+"&Longitude="+pLng+"&Latitude="+pLat+"&currtime="+new Date();
		reqDrg.open("POST",url,true);
		reqDrg.send(null);
		return true;
	}
}

//�����鿴�ӿ�
var reqInfo = null;
function doDefence(pId, pCName, pType)
{
	map.closeInfoWindow();
	var messContent = "";
	messContent += "<div style='text-align:center;margin:10px;'>";
	messContent += "  <a href='#' onClick=\"doDel('"+ pId +"', '"+ pType +"')\"><U>ȡ��[<font color=red>"+pCName+"</font>]��ע</U></a>";
	messContent += "</div>";
	showMessageBox('ȡ��վ���ע', messContent , 300, 150);
}

//ɾ����ע�ӿ�
var reqDel = null;
function doDel(pId, pType)
{
	if(confirm('ȷ��ɾ����ǰվ���ע?'))
	{
		if(window.XMLHttpRequest)
	  {
			reqDel = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqDel = new ActiveXObject("Microsoft.XMLHTTP");
		}
		reqDel.onreadystatechange = function()
		{
		  var state = reqDel.readyState;
		  if(state == 4)
		  {
		    if(reqDel.status == 200)
		    {
		      var Resp = reqDel.responseText;
		      if(null != Resp && Resp.substring(0,4) == '0000')
		      {
		      	closeWindow();
		      	map.clearOverlays();
		      	RealStatus();
		      	alert('ɾ����ע�ɹ�!');
		    		return;
		      }  
		      else
		      {
		      	alert('ɾ����עʧ��!');
		    		return;
		      }   
		    }
		    else
		    {
		    	alert('ɾ����עʧ��!');
		    	return;
		    }
		  }
		};
		var url = "Device_doDragging.do?Cmd=16&Sid=<%=Sid%>&Id="+pId+"&currtime="+new Date();
		reqDel.open("POST",url,true);
		reqDel.send(null);
		return true;
	}
}
</SCRIPT>
</html>