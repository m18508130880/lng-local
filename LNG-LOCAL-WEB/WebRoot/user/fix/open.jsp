<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<html style="margin:0;padding:0">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
<script language="javascript" type="text/javascript">
var f=false;
function change()
{
		if(f==false)
		{
				top.document.getElementById('glb_frm').attributes["cols"].value="0,11,*";
				document.getElementById('tg').src="../../skin/images/bar_right.gif";//���������
				f=true;
		}
		else
		{
				top.document.getElementById('glb_frm').attributes["cols"].value="204,11,*";
				document.getElementById('tg').src="../../skin/images/bar_left.gif";//���������
				f=false;
		}
}
</script>
</head>
<body style="background-color:#0B80CC;margin:0;padding:0">
	<img id="tg" style="cursor:hand;" src="../../skin/images/bar_left.gif" id="tog" style="width:11px;height;500px;top:0px;position:absolute" onclick="change()"/>
</body>
</html>
