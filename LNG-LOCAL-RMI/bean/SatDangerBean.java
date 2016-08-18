package bean;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jspsmart.upload.SmartUpload;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import rmi.Rmi;
import rmi.RmiBean;
import util.*;

public class SatDangerBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SAT_DANGER;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SatDangerBean()
	{
		super.className = "SatDangerBean";
	}
	
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		//类型
		Func_Corp_Id = currStatus.getFunc_Corp_Id();
		if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
		{
			Func_Corp_Id = "";
		}
		
		//级别
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if(null == Func_Type_Id || Func_Type_Id.equals("9999"))
		{
			Func_Type_Id = "";
		}
		
		//状态
		Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
					
			case 0://查询
				request.getSession().setAttribute("Sat_Danger_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_Danger.jsp?Sid=" + Sid);
		    	
		    	//隐患类型
		    	AqscDangerTypeBean DangerType = new AqscDangerTypeBean();
		    	msgBean = pRmi.RmiExec(0, DangerType, 0);
				request.getSession().setAttribute("Sat_Danger_Type_" + Sid, (Object)msgBean.getMsg());
		    	
				
		    	//隐患级别
				AqscDangerLevelBean DangerLevel = new AqscDangerLevelBean();
				msgBean = pRmi.RmiExec(0, DangerLevel, 0);
				request.getSession().setAttribute("Sat_Danger_Level_" + Sid, (Object)msgBean.getMsg());
		    	break;
			case 1://安全检查链接
				request.getSession().setAttribute("Sat_Danger_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_Check_Danger.jsp?Sid=" + Sid);
		    	
		    	AqscDangerTypeBean DangTypeT = new AqscDangerTypeBean();
		    	msgBean = pRmi.RmiExec(0, DangTypeT, 0);
				request.getSession().setAttribute("Sat_Danger_Type_" + Sid, (Object)msgBean.getMsg());		    				
		    	//隐患级别
				AqscDangerLevelBean DangLevelT = new AqscDangerLevelBean();
				msgBean = pRmi.RmiExec(0, DangLevelT, 0);
				request.getSession().setAttribute("Sat_Danger_Level_" + Sid, (Object)msgBean.getMsg());
				break;
				
			case 11://隐患基本信息修改
			case 12://确定方案修改
			case 13://实施整改修改
			case 14://审核验收修改
				//currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(2, this, 0);									
			case 2://查询
				request.getSession().setAttribute("Sat_Danger_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_Danger.jsp?Sid=" + Sid);		    	
		    	//隐患类型
		    	AqscDangerTypeBean DangType = new AqscDangerTypeBean();
		    	msgBean = pRmi.RmiExec(0, DangType, 0);
				request.getSession().setAttribute("Sat_Danger_Type_" + Sid, (Object)msgBean.getMsg());		    				
		    	//隐患级别
				AqscDangerLevelBean DangLevel = new AqscDangerLevelBean();
				msgBean = pRmi.RmiExec(0, DangLevel, 0);
				request.getSession().setAttribute("Sat_Danger_Level_" + Sid, (Object)msgBean.getMsg());
		    	break;
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	public void ToExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		//类型
		Func_Corp_Id = currStatus.getFunc_Corp_Id();
		if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
		{
			Func_Corp_Id = "";
		}
		
		//级别
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if(null == Func_Type_Id || Func_Type_Id.equals("9999"))
		{
			Func_Type_Id = "";
		}
		
		//状态
		Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
		case 0://查询
			request.getSession().setAttribute("Sat_To_Danger_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
	    	currStatus.setJsp("Sat_To_Danger.jsp?Sid=" + Sid);
	    	
	    	//隐患类型
	    	AqscDangerTypeBean DangerType = new AqscDangerTypeBean();
	    	msgBean = pRmi.RmiExec(0, DangerType, 0);
			request.getSession().setAttribute("Sat_To_Danger_Type_" + Sid, (Object)msgBean.getMsg());
				//隐患级别
			AqscDangerLevelBean DangerLevel = new AqscDangerLevelBean();
			msgBean = pRmi.RmiExec(0, DangerLevel, 0);
			request.getSession().setAttribute("Sat_To_Danger_Level_" + Sid, (Object)msgBean.getMsg());
	    	break;
		
		}
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());	
	}
	
	//明细导出
	public void ExportToExcel(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
			
			//类型
			Func_Corp_Id = currStatus.getFunc_Corp_Id();
			if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
			{
				Func_Corp_Id = "";
			}
			
			//级别
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id || Func_Type_Id.equals("9999"))
			{
				Func_Type_Id = "";
			}
			
			//状态
			Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
			if(Func_Sub_Id.equals("9"))
			{
				Func_Sub_Id = "";
			}
			
			//清除历史
			
			//生成当前
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			msgBean = pRmi.RmiExec(0, this, 0);
			ArrayList<?> temp = (ArrayList<?>)msgBean.getMsg();
			if(temp != null)
			{
				//录入人员
				UserInfoBean userInfo = new UserInfoBean();
				userInfo.setFunc_Corp_Id("");
		    	msgBean = pRmi.RmiExec(1, userInfo, 0);
				ArrayList<?> usertemp = (ArrayList<?>)msgBean.getMsg();
				
				//创建文件
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);
	            
	            //字体格式1
	            WritableFont wf = new WritableFont(WritableFont.createFont("normal"), 18, WritableFont.BOLD , false);
				WritableCellFormat wff = new WritableCellFormat(wf);
				wf.setColour(Colour.BLACK);//字体颜色
				wff.setAlignment(Alignment.CENTRE);//设置居中
				wff.setBorder(Border.ALL, BorderLineStyle.THIN);//设置边框线
				wff.setBackground(jxl.format.Colour.TURQUOISE);//设置单元格的背景颜色			
				
				//字体格式2
				WritableFont wf2 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff2 = new WritableCellFormat(wf2);
				wf2.setColour(Colour.BLACK);//字体颜色
				wff2.setAlignment(Alignment.CENTRE);//设置居中
				wff2.setBorder(Border.ALL, BorderLineStyle.THIN);//设置边框线
				
				//字体格式3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);
				wf3.setColour(Colour.BLACK);//字体颜色
				wff3.setAlignment(Alignment.CENTRE);//设置居中
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//设置边框线
				
				sheet.setRowView(0, 600);
	            sheet.setColumnView(0, 20);
	            Label label = new Label(0, 0, "场站隐患跟踪记录", wff);
	            sheet.addCell(label);
	            label = new Label(1, 0, "");
	            sheet.addCell(label);
	            label = new Label(2, 0, "");
	            sheet.addCell(label);
	            label = new Label(3, 0, "");
	            sheet.addCell(label);
	            label = new Label(4, 0, "");
	            sheet.addCell(label);
	            label = new Label(5, 0, "");
	            sheet.addCell(label);
	            label = new Label(6, 0, "");
	            sheet.addCell(label);
	            label = new Label(7, 0, "");
	            sheet.addCell(label);
	            label = new Label(8, 0, "");
	            sheet.addCell(label);
	            label = new Label(9, 0, "");
	            sheet.addCell(label);
	            label = new Label(10, 0, "");
	            sheet.addCell(label);
	            label = new Label(11, 0, "");
	            sheet.addCell(label);
	            label = new Label(12, 0, "");
	            sheet.addCell(label);
	            label = new Label(13, 0, "");
	            sheet.addCell(label);
	            label = new Label(14, 0, "");
	            sheet.addCell(label);
	            label = new Label(15, 0, "");
	            sheet.addCell(label);
	            label = new Label(16, 0, "");
	            sheet.addCell(label);
	            label = new Label(17, 0, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,0,17,0);
	            
	            sheet.setRowView(1, 600);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "隐患基本信息(检查人录入)", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 1, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(0,1,7,1);
	            label  = new Label(8, 1, "确定方案(责任人录入)", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 1, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(8,1,10,1);
	            label  = new Label(11, 1, "实施整改(责任人录入)", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(13, 1, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(11,1,13,1);
	            label  = new Label(14, 1, "审核验收(检查人)", wff2);
	            sheet.addCell(label);
	            label  = new Label(15, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(16, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(17, 1, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(14,1,17,1);
	            
	            sheet.setRowView(2, 400);
	            sheet.setColumnView(2, 20);
	            label  = new Label(0, 2, "序号", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 2, "隐患分类", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 2, "隐患级别", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 2, "隐患描述", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 2, "责任部门", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 2, "发现日期", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 2, "整改期限", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 2, "录入人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(8, 2, "确定方案", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 2, "简要描述", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 2, "录入人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(11, 2, "实施整改", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 2, "简要描述", wff2);
	            sheet.addCell(label);
	            label  = new Label(13, 2, "录入人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(14, 2, "审核验收", wff2);
	            sheet.addCell(label);
	            label  = new Label(15, 2, "简要描述", wff2);
	            sheet.addCell(label);
	            label  = new Label(16, 2, "状态跟踪", wff2);
	            sheet.addCell(label);
	            label  = new Label(17, 2, "录入人员", wff2);
	            sheet.addCell(label);
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 2;
				while(iterator.hasNext())
				{
					i++;
					SatDangerBean Bean = (SatDangerBean)iterator.next();
					String D_Danger_Type_Name = Bean.getDanger_Type_Name();
					String D_Danger_Level_Name = Bean.getDanger_Level_Name();
					String D_Danger_Des = Bean.getDanger_Des();
					String D_Cpm_Name = Bean.getCpm_Name();
					String D_Danger_BTime = Bean.getDanger_BTime();
					String D_Danger_ETime = Bean.getDanger_ETime();
					String D_Operator_Name = Bean.getOperator_Name();
					
					String Desc_2 = "";
					String D_Danger_Plan_Des = Bean.getDanger_Plan_Des();
					String D_Danger_Plan_OP = Bean.getDanger_Plan_OP();
					if(null != D_Danger_Plan_OP && D_Danger_Plan_OP.trim().length() > 0)
						Desc_2 = "已确定";
					else
						Desc_2 = "未确定";
					
					String Desc_3 = "";
					String D_Danger_Act_Des = Bean.getDanger_Act_Des();
					String D_Danger_Act_OP = Bean.getDanger_Act_OP();
					if(null != D_Danger_Act_OP && D_Danger_Act_OP.trim().length() > 0)
						Desc_3 = "已实施";
					else
						Desc_3 = "未实施";
					
					String Desc_4 = "";
					String D_Danger_Check = Bean.getDanger_Check();
					String D_Danger_Check_OP = Bean.getDanger_Check_OP();
					if(null != D_Danger_Check_OP && D_Danger_Check_OP.trim().length() > 0)
						Desc_4 = "已审核";
					else
						Desc_4 = "未审核";
					
					String str_Status = "";
					switch(Integer.parseInt(Bean.getStatus()))
					{
						case 0:
								str_Status = "整改中";
							break;
						case 1:
								str_Status = "已关闭";
							break;
					}
					
					//录入人员
					String D_Danger_Plan_OP_Name = "";
					String D_Danger_Act_OP_Name = "";
					String D_Danger_Check_OP_Name = "";
					if(usertemp != null)
					{
						for(int j=0; j<usertemp.size(); j++)
						{
							UserInfoBean Info = (UserInfoBean)usertemp.get(j);
							if(null != D_Danger_Plan_OP && Info.getId().equals(D_Danger_Plan_OP))
								D_Danger_Plan_OP_Name = Info.getCName();
							if(null != D_Danger_Act_OP && Info.getId().equals(D_Danger_Act_OP))
								D_Danger_Act_OP_Name = Info.getCName();
							if(null != D_Danger_Check_OP && Info.getId().equals(D_Danger_Check_OP))
								D_Danger_Check_OP_Name = Info.getCName();
						}
					}
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-2)+"", wff3);               //序号
		            sheet.addCell(label);
		            label = new Label(1,i,D_Danger_Type_Name, wff3);     //隐患分类
		            sheet.addCell(label);
		            label = new Label(2,i,D_Danger_Level_Name, wff3);    //隐患级别
		            sheet.addCell(label);
		            label = new Label(3,i,D_Danger_Des, wff3);           //隐患描述
		            sheet.addCell(label);
		            label = new Label(4,i,D_Cpm_Name, wff3);             //责任部门
		            sheet.addCell(label);
		            label = new Label(5,i,D_Danger_BTime, wff3);         //发现日期
		            sheet.addCell(label);
		            label = new Label(6,i,D_Danger_ETime, wff3);         //整改期限
		            sheet.addCell(label);
		            label = new Label(7,i,D_Operator_Name, wff3);        //录入人员
		            sheet.addCell(label);
		            label = new Label(8,i,Desc_2, wff3);                 //确定方案
		            sheet.addCell(label);
		            label = new Label(9,i,D_Danger_Plan_Des, wff3);      //简要描述
		            sheet.addCell(label);
		            label = new Label(10,i,D_Danger_Plan_OP_Name, wff3); //录入人员
		            sheet.addCell(label);
		            label = new Label(11,i,Desc_3, wff3);                //实施整改
		            sheet.addCell(label);
		            label = new Label(12,i,D_Danger_Act_Des, wff3);      //简要描述
		            sheet.addCell(label);
		            label = new Label(13,i,D_Danger_Act_OP_Name, wff3);  //录入人员
		            sheet.addCell(label);
		            label = new Label(14,i,Desc_4, wff3);   		     //审核验收
		            sheet.addCell(label);
		            label = new Label(15,i,D_Danger_Check, wff3);        //简要描述
		            sheet.addCell(label);
		            label = new Label(16,i,str_Status, wff3);   	     //状态跟踪
		            sheet.addCell(label);
		            label = new Label(17,i,D_Danger_Check_OP_Name, wff3);//录入人员
		            sheet.addCell(label);
				}
				book.write();
	            book.close();
	            try
	    		{ 
	    			PrintWriter out = response.getWriter();	    			
	    			out.print(UPLOAD_NAME);
	    		}
	    		catch(Exception exp)
	    		{
	    		   exp.printStackTrace();	
	    		}	            
			}	
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	//操作
	public void SatDangerAdd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		//类型
		Func_Corp_Id = currStatus.getFunc_Corp_Id();
		if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
		{
			Func_Corp_Id = "";
		}
		
		//级别
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if(null == Func_Type_Id || Func_Type_Id.equals("9999"))
		{
			Func_Type_Id = "";
		}
		
		//状态
		Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
		{
			Resp = "0000";
			currStatus.setCmd(0);
			msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
			request.getSession().setAttribute("Sat_Danger_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		outprint.write(Resp);
	}
	
	//文档上传
	public void SatDangerFile(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone, ServletConfig pConfig) 
	{
		try
		{
			SmartUpload mySmartUpload = new SmartUpload();
			mySmartUpload.initialize(pConfig, request, response);
			mySmartUpload.setAllowedFilesList("doc,docx,xls,xlsx,pdf,DOC,DOCX,XLS,XLSX,PDF,");
			mySmartUpload.upload();
			
			//获取参数
			Sid = mySmartUpload.getRequest().getParameter("Sid");
			SN = mySmartUpload.getRequest().getParameter("SN");
			Cpm_Id = mySmartUpload.getRequest().getParameter("Cpm_Id");
			Danger_Plan = mySmartUpload.getRequest().getParameter("Danger_Plan");
			Danger_Plan_Des = mySmartUpload.getRequest().getParameter("Danger_Plan_Des");
			Danger_Plan_OP = mySmartUpload.getRequest().getParameter("Danger_Plan_OP");
			Danger_Act = mySmartUpload.getRequest().getParameter("Danger_Act");
			Danger_Act_Des = mySmartUpload.getRequest().getParameter("Danger_Act_Des");
			Danger_Act_OP = mySmartUpload.getRequest().getParameter("Danger_Act_OP");
			
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.setCmd(CommUtil.StrToInt(mySmartUpload.getRequest().getParameter("Cmd")));
			currStatus.setFunc_Corp_Id(mySmartUpload.getRequest().getParameter("Func_Corp_Id"));
			currStatus.setFunc_Type_Id(mySmartUpload.getRequest().getParameter("Func_Type_Id"));
			currStatus.setFunc_Sub_Id(CommUtil.StrToInt(mySmartUpload.getRequest().getParameter("Func_Sub_Id")));
			currStatus.setCurrPage(CommUtil.StrToInt(mySmartUpload.getRequest().getParameter("CurrPage")));
			currStatus.setVecDate(CommUtil.getDate(mySmartUpload.getRequest().getParameter("BTime"), mySmartUpload.getRequest().getParameter("ETime")));
			
			switch(currStatus.getCmd())
			{
				case 12://确定方案修改
					msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
					currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
					if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
					{
						if(mySmartUpload.getFiles().getCount() > 0 && mySmartUpload.getFiles().getFile(0).getFilePathName().trim().length() > 0)
						{
							if(mySmartUpload.getFiles().getFile(0).getSize()/1024 <= 3072)//最大3M
							{
								String FileSaveRoute = "/www/LNG-LOCAL/LNG-LOCAL-WEB/files/upfiles/";
								//删除原有文档
								File delfile = new File(FileSaveRoute + Danger_Plan);
								if(delfile.isFile() && delfile.exists())
								{
									delfile.delete();
							    }
								
								//上传现有文档
								com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
								Danger_Plan = new SimpleDateFormat("yyyyMMdd").format(new Date()) + CommUtil.Randon()+ "." + myFile.getFileExt();
								myFile.saveAs(FileSaveRoute + Danger_Plan);
								
								//更新数据库
								msgBean = pRmi.RmiExec(15, this, currStatus.getCurrPage());
								currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
							}
							else
							{
								currStatus.setResult("文档上传失败！文档过大，必须小于3M!");
							}
						}
					}
					break;
				case 13://实施整改修改
					msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
					currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
					if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
					{
						if(mySmartUpload.getFiles().getCount() > 0 && mySmartUpload.getFiles().getFile(0).getFilePathName().trim().length() > 0)
						{
							if(mySmartUpload.getFiles().getFile(0).getSize()/1024 <= 3072)//最大3M
							{
								String FileSaveRoute = "/www/LNG-LOCAL/LNG-LOCAL-WEB/files/upfiles/";
								//删除原有文档
								File delfile = new File(FileSaveRoute + Danger_Act);
								if(delfile.isFile() && delfile.exists())
								{
									delfile.delete();
							    }
								
								//上传现有文档
								com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
								Danger_Act = new SimpleDateFormat("yyyyMMdd").format(new Date()) + CommUtil.Randon()+ "." + myFile.getFileExt();
								myFile.saveAs(FileSaveRoute + Danger_Act);
								
								//更新数据库
								msgBean = pRmi.RmiExec(16, this, currStatus.getCurrPage());
								currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
							}
							else
							{
								currStatus.setResult("文档上传失败！文档过大，必须小于3M!");
							}
						}
					}
					break;
			}
			
			//类型
			Func_Corp_Id = currStatus.getFunc_Corp_Id();
			if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
			{
				Func_Corp_Id = "";
			}
			
			//级别
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id || Func_Type_Id.equals("9999"))
			{
				Func_Type_Id = "";
			}
			
			//状态
			Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
			if(Func_Sub_Id.equals("9"))
			{
				Func_Sub_Id = "";
			}
			
			//重新查询
			msgBean = pRmi.RmiExec(2, this, currStatus.getCurrPage());
			request.getSession().setAttribute("Sat_Danger_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
	    	currStatus.setJsp("Sat_Danger.jsp?Sid=" + Sid);
		   	
			request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		   	response.sendRedirect(currStatus.getJsp());
		}
		catch(Exception exp)
		{
			exp.printStackTrace();
		}
	}
	
	//链接编辑
	public void SatDangerEdit(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone, ServletConfig pConfig) 
	{
		try
		{
			SmartUpload mySmartUpload = new SmartUpload();
			mySmartUpload.initialize(pConfig, request, response);
			mySmartUpload.setAllowedFilesList("doc,docx,xls,xlsx,pdf,DOC,DOCX,XLS,XLSX,PDF,");
			mySmartUpload.upload();
			
			//获取参数
			Sid = mySmartUpload.getRequest().getParameter("Sid");
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.setCmd(CommUtil.StrToInt(mySmartUpload.getRequest().getParameter("Cmd")));
			currStatus.setFunc_Corp_Id(mySmartUpload.getRequest().getParameter("Func_Corp_Id"));
			currStatus.setCurrPage(CommUtil.StrToInt(mySmartUpload.getRequest().getParameter("CurrPage")));
			currStatus.setVecDate(CommUtil.getDate(mySmartUpload.getRequest().getParameter("BTime"), mySmartUpload.getRequest().getParameter("ETime")));
			
			SN = mySmartUpload.getRequest().getParameter("SN");
			Operator = mySmartUpload.getRequest().getParameter("Operator");
			Danger_Plan_OP = mySmartUpload.getRequest().getParameter("Danger_Plan_OP");
			Danger_Act_OP = mySmartUpload.getRequest().getParameter("Danger_Act_OP");
			Danger_Check_OP = mySmartUpload.getRequest().getParameter("Danger_Check_OP");
			
			//隐患基本信息参数
			Danger_Type = mySmartUpload.getRequest().getParameter("Danger_Type");
			Danger_Level = mySmartUpload.getRequest().getParameter("Danger_Level");
			Cpm_Id = mySmartUpload.getRequest().getParameter("Cpm_Id");
			Danger_BTime = mySmartUpload.getRequest().getParameter("Danger_BTime");
			Danger_ETime = mySmartUpload.getRequest().getParameter("Danger_ETime");
			Danger_Des = mySmartUpload.getRequest().getParameter("Danger_Des");
			
			//确定方案参数
			Danger_Plan = mySmartUpload.getRequest().getParameter("Danger_Plan");
			Danger_Plan_Des = mySmartUpload.getRequest().getParameter("Danger_Plan_Des");
			
			//实施整改参数
			Danger_Act = mySmartUpload.getRequest().getParameter("Danger_Act");
			Danger_Act_Des = mySmartUpload.getRequest().getParameter("Danger_Act_Des");
			
			//审核验收参数
			Danger_Check = mySmartUpload.getRequest().getParameter("Danger_Check");
			Status = mySmartUpload.getRequest().getParameter("Status");
			
			switch(currStatus.getCmd())
			{
				case 11://修改隐患基本信息
					msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
					currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
					break;
				case 12://修改确定方案
					msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
					currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
					if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
					{
						if(mySmartUpload.getFiles().getCount() > 0 && mySmartUpload.getFiles().getFile(0).getFilePathName().trim().length() > 0)
						{
							if(mySmartUpload.getFiles().getFile(0).getSize()/1024 <= 3072)//最大3M
							{
								String FileSaveRoute = "/www/LNG-LOCAL/LNG-LOCAL-WEB/files/upfiles/";
								//删除原有文档
								File delfile = new File(FileSaveRoute + Danger_Plan);
								if(delfile.isFile() && delfile.exists())
								{
									delfile.delete();
							    }
								
								//上传现有文档
								com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
								Danger_Plan = new SimpleDateFormat("yyyyMMdd").format(new Date()) + CommUtil.Randon()+ "." + myFile.getFileExt();
								myFile.saveAs(FileSaveRoute + Danger_Plan);
								
								//更新数据库
								msgBean = pRmi.RmiExec(15, this, 0);
								currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
							}
							else
							{
								currStatus.setResult("文档上传失败！文档过大，必须小于3M!");
							}
						}
					}
					break;
				case 13://修改实施整改
					msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
					currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
					if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
					{
						if(mySmartUpload.getFiles().getCount() > 0 && mySmartUpload.getFiles().getFile(0).getFilePathName().trim().length() > 0)
						{
							if(mySmartUpload.getFiles().getFile(0).getSize()/1024 <= 3072)//最大3M
							{
								String FileSaveRoute = "/www/LNG-LOCAL/LNG-LOCAL-WEB/files/upfiles/";
								//删除原有文档
								File delfile = new File(FileSaveRoute + Danger_Act);
								if(delfile.isFile() && delfile.exists())
								{
									delfile.delete();
							    }
								
								//上传现有文档
								com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
								Danger_Act = new SimpleDateFormat("yyyyMMdd").format(new Date()) + CommUtil.Randon()+ "." + myFile.getFileExt();
								myFile.saveAs(FileSaveRoute + Danger_Act);
								
								//更新数据库
								msgBean = pRmi.RmiExec(16, this, 0);
								currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
							}
							else
							{
								currStatus.setResult("文档上传失败！文档过大，必须小于3M!");
							}
						}
					}
					break;
				case 14://修改审核验收
					msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
					currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
					break;
			}
			
			//类型
			Func_Corp_Id = currStatus.getFunc_Corp_Id();
			if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
			{
				Func_Corp_Id = "";
			}
			
			//重新查询
			SatCheckBean CheckBean = new SatCheckBean();
			CheckBean.setCpm_Id(Cpm_Id);
			CheckBean.setFunc_Corp_Id(Func_Corp_Id);
			CheckBean.currStatus = currStatus;
			msgBean = pRmi.RmiExec(0, CheckBean, currStatus.getCurrPage());
			request.getSession().setAttribute("Sat_Check_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
	    	currStatus.setJsp("Sat_Check.jsp?Sid=" + Sid);
	    	
			request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		   	response.sendRedirect(currStatus.getJsp());
		}
		catch(Exception exp)
		{
			exp.printStackTrace();
		}
	}
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd)
		{
			case 0://查询
				switch(currStatus.getFunc_Sub_Id())
				{
					case 0:
						Sql = " select t.sn, t.cpm_id, t.cpm_name, t.danger_type, t.danger_type_name, t.danger_level, t.danger_level_name, " +
					  	  	  " t.danger_des, t.danger_btime, t.danger_etime, t.danger_plan, t.danger_plan_des, t.danger_plan_op, t.danger_act, t.danger_act_des, t.danger_act_op, " +
					  	  	  " t.danger_check, t.danger_check_op, t.ctime, t.operator, t.operator_name, t.status, t.check_sn " +
					  	  	  " from view_sat_danger t " +
					  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
					  	  	  "   and t.danger_type like '"+ Func_Corp_Id +"%'" +
					  	  	  "   and t.danger_level like '"+ Func_Type_Id +"%'" +
					  	  	  "   and t.status like '"+ Func_Sub_Id +"%'" +
					  	  	  "   order by t.danger_btime desc ";
						break;
					default:
						Sql = " select t.sn, t.cpm_id, t.cpm_name, t.danger_type, t.danger_type_name, t.danger_level, t.danger_level_name, " +
						  	  " t.danger_des, t.danger_btime, t.danger_etime, t.danger_plan, t.danger_plan_des, t.danger_plan_op, t.danger_act, t.danger_act_des, t.danger_act_op, " +
						  	  " t.danger_check, t.danger_check_op, t.ctime, t.operator, t.operator_name, t.status, t.check_sn " +
						  	  " from view_sat_danger t " +
						  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +					  
						  	  "   and t.danger_type like '"+ Func_Corp_Id +"%'" +
						  	  "   and t.danger_level like '"+ Func_Type_Id +"%'" +
						  	  "   and t.status like '"+ Func_Sub_Id +"%'" +					  
						  	  "   and t.danger_btime >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  "   and t.danger_btime <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  "   order by t.danger_btime desc ";
						break;
				}
				break;
			case 1://安全检查链接
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.danger_type, t.danger_type_name, t.danger_level, t.danger_level_name, " +
					  " t.danger_des, t.danger_btime, t.danger_etime, t.danger_plan, t.danger_plan_des, t.danger_plan_op, t.danger_act, t.danger_act_des, t.danger_act_op, " +
					  " t.danger_check, t.danger_check_op, t.ctime, t.operator, t.operator_name, t.status, t.check_sn " +
					  " from view_sat_danger t " +
				  	  " where t.sn = '"+ SN +"'";
				break;			
			case 2://安全检查链接
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.danger_type, t.danger_type_name, t.danger_level, t.danger_level_name, " +
				  	  " t.danger_des, t.danger_btime, t.danger_etime, t.danger_plan, t.danger_plan_des, t.danger_plan_op, t.danger_act, t.danger_act_des, t.danger_act_op, " +
				  	  " t.danger_check, t.danger_check_op, t.ctime, t.operator, t.operator_name, t.status, t.check_sn " +
				  	  " from view_sat_danger t " +
				  	" where t.sn = '"+ SN +"'";
				break;		
				
		
				
			case 10://添加
				Sql = " insert into sat_danger(cpm_id, danger_type, danger_level, danger_des, danger_btime, danger_etime, ctime, operator, check_sn)" +
					  " values('"+ Cpm_Id +"', '"+ Danger_Type +"', '"+ Danger_Level +"', '"+ Danger_Des +"', '"+ Danger_BTime +"', '"+ Danger_ETime +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"', '"+ Check_SN +"')";
				break;
			case 11://隐患基本信息修改
				Sql = " update sat_danger t set t.cpm_id = '"+ Cpm_Id +"', t.danger_type = '"+ Danger_Type +"', t.danger_level = '"+ Danger_Level +"', " +
					  " t.danger_des = '"+ Danger_Des +"', t.danger_btime = '"+ Danger_BTime +"', t.danger_etime = '"+ Danger_ETime +"', t.operator = '"+ Operator +"' " +
					  " where t.sn = '"+ SN +"' ";
				break;
			case 12://确定方案修改
				Sql = " update sat_danger t set t.danger_plan_des = '"+ Danger_Plan_Des +"', t.danger_plan_op = '"+ Danger_Plan_OP +"' where t.sn = '"+ SN +"' ";
				break;
			case 13://实施整改修改
				Sql = " update sat_danger t set t.danger_act_des = '"+ Danger_Act_Des +"', t.danger_act_op = '"+ Danger_Act_OP +"' where t.sn = '"+ SN +"' ";
				break;
			case 14://审核验收修改
				Sql = " update sat_danger t set t.danger_check = '"+ Danger_Check +"', t.danger_check_op = '"+ Danger_Check_OP +"', t.status = '"+ Status +"' where t.sn = '"+ SN +"' ";
				break;
			case 15://确定方案文档
				Sql = " update sat_danger t set t.danger_plan = '"+ Danger_Plan +"' where t.sn = '"+ SN +"' ";
				break;
			case 16://实施整改文档
				Sql = " update sat_danger t set t.danger_act  = '"+ Danger_Act +"'  where t.sn = '"+ SN +"' ";
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs)
	{
		boolean IsOK = true;
		try
		{
			setSN(pRs.getString(1));
			setCpm_Id(pRs.getString(2));
			setCpm_Name(pRs.getString(3));
			setDanger_Type(pRs.getString(4));
			setDanger_Type_Name(pRs.getString(5));
			setDanger_Level(pRs.getString(6));
			setDanger_Level_Name(pRs.getString(7));
			setDanger_Des(pRs.getString(8));
			setDanger_BTime(pRs.getString(9));
			setDanger_ETime(pRs.getString(10));
			setDanger_Plan(pRs.getString(11));
			setDanger_Plan_Des(pRs.getString(12));
			setDanger_Plan_OP(pRs.getString(13));
			setDanger_Act(pRs.getString(14));
			setDanger_Act_Des(pRs.getString(15));
			setDanger_Act_OP(pRs.getString(16));
			setDanger_Check(pRs.getString(17));
			setDanger_Check_OP(pRs.getString(18));
			setCTime(pRs.getString(19));
			setOperator(pRs.getString(20));
			setOperator_Name(pRs.getString(21));
			setStatus(pRs.getString(22));
			setCheck_SN(pRs.getString(23));
		}
		catch (SQLException sqlExp)
		{
			sqlExp.printStackTrace();
		}
		return IsOK;
	}
	
	public boolean getHtmlData(HttpServletRequest request)
	{
		boolean IsOK = true;
		try
		{
			setSN(CommUtil.StrToGB2312(request.getParameter("SN")));
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setCpm_Name(CommUtil.StrToGB2312(request.getParameter("Cpm_Name")));
			setDanger_Type(CommUtil.StrToGB2312(request.getParameter("Danger_Type")));
			setDanger_Type_Name(CommUtil.StrToGB2312(request.getParameter("Danger_Type_Name")));
			setDanger_Level(CommUtil.StrToGB2312(request.getParameter("Danger_Level")));
			setDanger_Level_Name(CommUtil.StrToGB2312(request.getParameter("Danger_Level_Name")));
			setDanger_Des(CommUtil.StrToGB2312(request.getParameter("Danger_Des")));
			setDanger_BTime(CommUtil.StrToGB2312(request.getParameter("Danger_BTime")));
			setDanger_ETime(CommUtil.StrToGB2312(request.getParameter("Danger_ETime")));
			setDanger_Plan(CommUtil.StrToGB2312(request.getParameter("Danger_Plan")));
			setDanger_Plan_Des(CommUtil.StrToGB2312(request.getParameter("Danger_Plan_Des")));
			setDanger_Plan_OP(CommUtil.StrToGB2312(request.getParameter("Danger_Plan_OP")));
			setDanger_Act(CommUtil.StrToGB2312(request.getParameter("Danger_Act")));
			setDanger_Act_Des(CommUtil.StrToGB2312(request.getParameter("Danger_Act_Des")));
			setDanger_Act_OP(CommUtil.StrToGB2312(request.getParameter("Danger_Act_OP")));
			setDanger_Check(CommUtil.StrToGB2312(request.getParameter("Danger_Check")));
			setDanger_Check_OP(CommUtil.StrToGB2312(request.getParameter("Danger_Check_OP")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
			setStatus(CommUtil.StrToGB2312(request.getParameter("Status")));
			setCheck_SN(CommUtil.StrToGB2312(request.getParameter("Check_SN")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Cpm_Id;
	private String Cpm_Name;
	private String Danger_Type;
	private String Danger_Type_Name;
	private String Danger_Level;
	private String Danger_Level_Name;
	private String Danger_Des;
	private String Danger_BTime;
	private String Danger_ETime;
	private String Danger_Plan;
	private String Danger_Plan_Des;
	private String Danger_Plan_OP;
	private String Danger_Act;
	private String Danger_Act_Des;
	private String Danger_Act_OP;
	private String Danger_Check;
	private String Danger_Check_OP;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	private String Status;
	private String Check_SN;
	
	private String Func_Corp_Id;
	private String Func_Type_Id;
	private String Func_Sub_Id;
	private String Sid;
	
	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
	}

	public String getCpm_Id() {
		return Cpm_Id;
	}

	public void setCpm_Id(String cpmId) {
		Cpm_Id = cpmId;
	}

	public String getCpm_Name() {
		return Cpm_Name;
	}

	public void setCpm_Name(String cpmName) {
		Cpm_Name = cpmName;
	}

	public String getDanger_Type() {
		return Danger_Type;
	}

	public void setDanger_Type(String dangerType) {
		Danger_Type = dangerType;
	}

	public String getDanger_Type_Name() {
		return Danger_Type_Name;
	}

	public void setDanger_Type_Name(String dangerTypeName) {
		Danger_Type_Name = dangerTypeName;
	}

	public String getDanger_Level() {
		return Danger_Level;
	}

	public void setDanger_Level(String dangerLevel) {
		Danger_Level = dangerLevel;
	}

	public String getDanger_Level_Name() {
		return Danger_Level_Name;
	}

	public void setDanger_Level_Name(String dangerLevelName) {
		Danger_Level_Name = dangerLevelName;
	}

	public String getDanger_Des() {
		return Danger_Des;
	}

	public void setDanger_Des(String dangerDes) {
		Danger_Des = dangerDes;
	}

	public String getDanger_BTime() {
		return Danger_BTime;
	}

	public void setDanger_BTime(String dangerBTime) {
		Danger_BTime = dangerBTime;
	}

	public String getDanger_ETime() {
		return Danger_ETime;
	}

	public void setDanger_ETime(String dangerETime) {
		Danger_ETime = dangerETime;
	}

	public String getDanger_Plan() {
		return Danger_Plan;
	}

	public void setDanger_Plan(String dangerPlan) {
		Danger_Plan = dangerPlan;
	}
	
	public String getDanger_Plan_Des() {
		return Danger_Plan_Des;
	}

	public void setDanger_Plan_Des(String dangerPlanDes) {
		Danger_Plan_Des = dangerPlanDes;
	}

	public String getDanger_Plan_OP() {
		return Danger_Plan_OP;
	}

	public void setDanger_Plan_OP(String dangerPlanOP) {
		Danger_Plan_OP = dangerPlanOP;
	}

	public String getDanger_Act() {
		return Danger_Act;
	}

	public void setDanger_Act(String dangerAct) {
		Danger_Act = dangerAct;
	}
	
	public String getDanger_Act_Des() {
		return Danger_Act_Des;
	}

	public void setDanger_Act_Des(String dangerActDes) {
		Danger_Act_Des = dangerActDes;
	}

	public String getDanger_Act_OP() {
		return Danger_Act_OP;
	}

	public void setDanger_Act_OP(String dangerActOP) {
		Danger_Act_OP = dangerActOP;
	}

	public String getDanger_Check() {
		return Danger_Check;
	}

	public void setDanger_Check(String dangerCheck) {
		Danger_Check = dangerCheck;
	}

	public String getDanger_Check_OP() {
		return Danger_Check_OP;
	}

	public void setDanger_Check_OP(String dangerCheckOP) {
		Danger_Check_OP = dangerCheckOP;
	}

	public String getCTime() {
		return CTime;
	}

	public void setCTime(String cTime) {
		CTime = cTime;
	}

	public String getOperator() {
		return Operator;
	}

	public void setOperator(String operator) {
		Operator = operator;
	}

	public String getOperator_Name() {
		return Operator_Name;
	}

	public void setOperator_Name(String operatorName) {
		Operator_Name = operatorName;
	}

	public String getStatus() {
		return Status;
	}

	public void setStatus(String status) {
		Status = status;
	}
	
	public String getCheck_SN() {
		return Check_SN;
	}

	public void setCheck_SN(String checkSN) {
		Check_SN = checkSN;
	}

	public String getFunc_Corp_Id() {
		return Func_Corp_Id;
	}

	public void setFunc_Corp_Id(String funcCorpId) {
		Func_Corp_Id = funcCorpId;
	}

	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String funcTypeId) {
		Func_Type_Id = funcTypeId;
	}

	public String getFunc_Sub_Id() {
		return Func_Sub_Id;
	}

	public void setFunc_Sub_Id(String funcSubId) {
		Func_Sub_Id = funcSubId;
	}

	public String getSid() {
		return Sid;
	}

	public void setSid(String sid) {
		Sid = sid;
	}
}