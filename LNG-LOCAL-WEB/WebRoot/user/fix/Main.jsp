<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="rmi.*" %>
<%@ page import="util.*" %>
<%@page import="java.awt.*, java.awt.image.*, java.io.*, com.sun.image.codec.jpeg.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../../skin/css/style.css" rel="stylesheet"/>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
<%

	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String p3  = CommUtil.StrToGB2312(request.getParameter("p3"));
	
%>
</head>
<frameset rows="111,*" cols="*" frameborder="NO" border="0" framespacing="0px">
 	 <frame src="main_top.jsp?Sid=<%=Sid%>&p3=<%=p3%>" name="tFrame" scrolling="NO" noresize>
 	 		<frameset id="glb_frm"  rows="*" cols="204,11,*" framespacing="0px" frameborder="NO" border="0">
				<frame src="FixTree.jsp?Sid=<%=Sid%>" name="lFrame"  frameborder="no" scrolling="auto" noResize>
				<frame src="open.jsp"                 id="ctr_frm"   name="ctr_frm"   scrolling="no"   noResize>
				<frame src=""                         name="mFrame"  frameborder="no" scrolling="auto" noResize>
			</frameset> 		
</frameset>
</html>