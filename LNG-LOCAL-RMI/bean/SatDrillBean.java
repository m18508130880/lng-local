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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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

public class SatDrillBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SAT_DRILL;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SatDrillBean()
	{
		super.className = "SatDrillBean";
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
		
		//状态
		Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
			case 11://演练基本信息修改
			case 12://演练效果评估修改
			case 13://观摩效果评估修改
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			case 0://查询
		    	request.getSession().setAttribute("Sat_Drill_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_Drill.jsp?Sid=" + Sid);
		    	
		    	//演练类型
		    	AqscDrillTypeBean DrillType = new AqscDrillTypeBean();
		    	msgBean = pRmi.RmiExec(0, DrillType, 0);
				request.getSession().setAttribute("Sat_Drill_Type_" + Sid, (Object)msgBean.getMsg());
		    	break;
			case 1:
				request.getSession().setAttribute("Sat_Drill_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_Drill.jsp?Sid=" + Sid);
		    	
		    	//演练类型
		    	AqscDrillTypeBean DrilType = new AqscDrillTypeBean();
		    	msgBean = pRmi.RmiExec(0, DrilType, 0);
				request.getSession().setAttribute("Sat_Drill_Type_" + Sid, (Object)msgBean.getMsg());
		    	break;
		}		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	public void ToCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
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
		    	request.getSession().setAttribute("Sat_To_Drill_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_To_Drill.jsp?Sid=" + Sid);
		    	
		    	//演练类型
		    	AqscDrillTypeBean DrillType = new AqscDrillTypeBean();
		    	msgBean = pRmi.RmiExec(0, DrillType, 0);
				request.getSession().setAttribute("Sat_Drill_Type_" + Sid, (Object)msgBean.getMsg());
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
				ArrayList<?> usertemp = (ArrayList<?>)request.getSession().getAttribute("User_User_Info_" + Sid);
				
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
	            Label label = new Label(0, 0, "公司应急演练记录", wff);
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
	            sheet.mergeCells(0,0,14,0);
	            
	            sheet.setRowView(1, 600);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "演练基本信息", wff2);
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
	            label  = new Label(8, 1, "演练效果评估", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 1, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(8,1,10,1);
	            label  = new Label(11, 1, "观摩效果评估", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(13, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(14, 1, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(11,1,14,1);
	            
	            sheet.setRowView(2, 400);
	            sheet.setColumnView(2, 20);
	            label  = new Label(0, 2, "序号", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 2, "演练单位", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 2, "演练类型", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 2, "演练名称", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 2, "演练时间", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 2, "参演人数", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 2, "演练备注", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 2, "录入人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(8, 2, "演练评估", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 2, "简要描述", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 2, "评估人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(11, 2, "观摩评估", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 2, "简要描述", wff2);
	            sheet.addCell(label);
	            label  = new Label(13, 2, "状态跟踪", wff2);
	            sheet.addCell(label);
	            label  = new Label(14, 2, "评估人员", wff2);
	            sheet.addCell(label);
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 2;
				while(iterator.hasNext())
				{
					i++;
					SatDrillBean Bean = (SatDrillBean)iterator.next();
					String D_Cpm_Name = Bean.getCpm_Name();
					String D_Drill_Type_Name = Bean.getDrill_Type_Name();
					String D_Drill_Title = Bean.getDrill_Title();
					String D_Drill_Time = Bean.getDrill_Time();
					String D_Drill_Cnt = Bean.getDrill_Cnt();
					String D_Drill_Memo = Bean.getDrill_Memo();
					String D_Operator_Name = Bean.getOperator_Name();
					if(null == D_Drill_Memo){D_Drill_Memo = "";}
					
					String Desc_2 = "";
					String D_Drill_Assess_Des = Bean.getDrill_Assess_Des();
					String D_Drill_Assess_OP  = Bean.getDrill_Assess_OP();
					if(null != D_Drill_Assess_OP && D_Drill_Assess_OP.trim().length() > 0)
						Desc_2 = "已评估";
					else
						Desc_2 = "未评估";
					
					String Desc_3 = "";
					String D_View_Assess_Des = Bean.getView_Assess_Des();
					String D_View_Assess_OP  = Bean.getView_Assess_OP();
					if(null != D_View_Assess_OP && D_View_Assess_OP.trim().length() > 0)
						Desc_3 = "已评估";
					else
						Desc_3 = "未评估";
					
					String str_Status = "";
					switch(Integer.parseInt(Bean.getStatus()))
					{
						case 0:
							str_Status = "计划中";
							break;
						case 1:
							str_Status = "已关闭";
							break;
					}
					
					//录入人员
					String D_Drill_Assess_OP_Name = "";
					String D_View_Assess_OP_Name  = "";
					if(usertemp != null)
					{
						for(int j=0; j<usertemp.size(); j++)
						{
							UserInfoBean Info = (UserInfoBean)usertemp.get(j);
							if(null != D_Drill_Assess_OP && Info.getId().equals(D_Drill_Assess_OP))
								D_Drill_Assess_OP_Name = Info.getCName();
							if(null != D_View_Assess_OP && Info.getId().equals(D_View_Assess_OP))
								D_View_Assess_OP_Name = Info.getCName();
						}
					}
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-2)+"", wff3);               //序号
		            sheet.addCell(label);
		            label = new Label(1,i,D_Cpm_Name, wff3);             //演练单位
		            sheet.addCell(label);
		            label = new Label(2,i,D_Drill_Type_Name, wff3);      //演练类型
		            sheet.addCell(label);
		            label = new Label(3,i,D_Drill_Title, wff3);          //演练名称
		            sheet.addCell(label);
		            label = new Label(4,i,D_Drill_Time, wff3);           //演练时间
		            sheet.addCell(label);
		            label = new Label(5,i,D_Drill_Cnt, wff3);    	     //参演人数
		            sheet.addCell(label);
		            label = new Label(6,i,D_Drill_Memo, wff3);  	     //演练备注
		            sheet.addCell(label);
		            label = new Label(7,i,D_Operator_Name, wff3);        //录入人员
		            sheet.addCell(label);
		            label = new Label(8,i,Desc_2, wff3);                 //演练评估
		            sheet.addCell(label);
		            label = new Label(9,i,D_Drill_Assess_Des, wff3);     //简要描述
		            sheet.addCell(label);
		            label = new Label(10,i,D_Drill_Assess_OP_Name, wff3);//评估人员
		            sheet.addCell(label);
		            label = new Label(11,i,Desc_3, wff3);                //观摩评估
		            sheet.addCell(label);
		            label = new Label(12,i,D_View_Assess_Des, wff3);     //简要描述
		            sheet.addCell(label);
		            label = new Label(13,i,str_Status, wff3);            //状态跟踪
		            sheet.addCell(label);
		            label = new Label(14,i,D_View_Assess_OP_Name, wff3); //评估人员
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
	public void SatDrillAdd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
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
			request.getSession().setAttribute("Sat_Drill_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		outprint.write(Resp);
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
						Sql = " select t.sn, t.cpm_id, t.cpm_name, t.drill_type, t.drill_type_name, t.drill_title, t.drill_time, t.drill_cnt, t.drill_memo, t.drill_assess, t.drill_assess_des, t.drill_assess_op, t.view_assess, t.view_assess_des, t.view_assess_op, t.status, t.ctime, t.operator, t.operator_name " +
					  	  	  " from view_sat_drill t " +
					  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
					  	  	  "   and t.drill_type like '"+ Func_Corp_Id +"%'" +
					  	  	  "   and t.status like '"+ Func_Sub_Id +"%'" +
					  	  	  "   order by t.drill_time desc ";
						break;
					default:
						Sql = " select t.sn, t.cpm_id, t.cpm_name, t.drill_type, t.drill_type_name, t.drill_title, t.drill_time, t.drill_cnt, t.drill_memo, t.drill_assess, t.drill_assess_des, t.drill_assess_op, t.view_assess, t.view_assess_des, t.view_assess_op, t.status, t.ctime, t.operator, t.operator_name " +
						  	  " from view_sat_drill t " +
						  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
						  	  "   and t.drill_type like '"+ Func_Corp_Id +"%'" +
						  	  "   and t.status like '"+ Func_Sub_Id +"%'" +
						  	  "   and t.drill_time >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  "   and t.drill_time <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  "   order by t.drill_time desc ";
						break;
				}
				break;
				
			case 1:  //详细点击查询				
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.drill_type, t.drill_type_name, t.drill_title, t.drill_time, t.drill_cnt, t.drill_memo, t.drill_assess, t.drill_assess_des, t.drill_assess_op, t.view_assess, t.view_assess_des, t.view_assess_op, t.status, t.ctime, t.operator, t.operator_name " +
					  	  " from view_sat_drill t " +
					  	  " where t.sn=  '"+ SN +"' ";					  	 
					break;					
			case 10://添加
				Sql = " insert into sat_drill(cpm_id, drill_type, drill_title, drill_time, drill_cnt, drill_memo, ctime, operator)" +
					  " values('"+ Cpm_Id +"', '"+ Drill_Type +"', '"+ Drill_Title +"', '"+ Drill_Time +"', '"+ Drill_Cnt +"', '"+ Drill_Memo +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"')";
				break;
			case 11://演练基本信息修改
				Sql = " update sat_drill t set t.cpm_id = '"+ Cpm_Id +"', t.drill_type = '"+ Drill_Type +"', t.drill_title = '"+ Drill_Title +"', " +
					  " t.drill_time = '"+ Drill_Time +"', t.drill_cnt = '"+ Drill_Cnt +"', t.drill_memo = '"+ Drill_Memo +"', t.operator = '"+ Operator +"' " +
					  " where t.sn = '"+ SN +"' ";
				break;
			case 12://演练效果评估修改
				Sql = " update sat_drill t set t.drill_assess_des = '"+ Drill_Assess_Des +"', t.drill_assess_op = '"+ Drill_Assess_OP +"' where t.sn = '"+ SN +"' ";
				break;
			case 13://观摩效果评估修改
				Sql = " update sat_drill t set t.view_assess_des = '"+ View_Assess_Des +"', t.view_assess_op = '"+ View_Assess_OP +"', t.status = '"+ Status +"' where t.sn = '"+ SN +"' ";
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
			setDrill_Type(pRs.getString(4));
			setDrill_Type_Name(pRs.getString(5));
			setDrill_Title(pRs.getString(6));
			setDrill_Time(pRs.getString(7));
			setDrill_Cnt(pRs.getString(8));
			setDrill_Memo(pRs.getString(9));
			setDrill_Assess(pRs.getString(10));
			setDrill_Assess_Des(pRs.getString(11));
			setDrill_Assess_OP(pRs.getString(12));
			setView_Assess(pRs.getString(13));
			setView_Assess_Des(pRs.getString(14));
			setView_Assess_OP(pRs.getString(15));
			setStatus(pRs.getString(16));
			setCTime(pRs.getString(17));
			setOperator(pRs.getString(18));
			setOperator_Name(pRs.getString(19));
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
			setDrill_Type(CommUtil.StrToGB2312(request.getParameter("Drill_Type")));
			setDrill_Type_Name(CommUtil.StrToGB2312(request.getParameter("Drill_Type_Name")));			
			setDrill_Title(CommUtil.StrToGB2312(request.getParameter("Drill_Title")));
			setDrill_Time(CommUtil.StrToGB2312(request.getParameter("Drill_Time")));
			setDrill_Cnt(CommUtil.StrToGB2312(request.getParameter("Drill_Cnt")));
			setDrill_Memo(CommUtil.StrToGB2312(request.getParameter("Drill_Memo")));
			setDrill_Assess(CommUtil.StrToGB2312(request.getParameter("Drill_Assess")));
			setDrill_Assess_Des(CommUtil.StrToGB2312(request.getParameter("Drill_Assess_Des")));
			setDrill_Assess_OP(CommUtil.StrToGB2312(request.getParameter("Drill_Assess_OP")));
			setView_Assess(CommUtil.StrToGB2312(request.getParameter("View_Assess")));
			setView_Assess_Des(CommUtil.StrToGB2312(request.getParameter("View_Assess_Des")));
			setView_Assess_OP(CommUtil.StrToGB2312(request.getParameter("View_Assess_OP")));
			setStatus(CommUtil.StrToGB2312(request.getParameter("Status")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
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
	private String Drill_Type;
	private String Drill_Type_Name;
	private String Drill_Title;
	private String Drill_Time;
	private String Drill_Cnt;
	private String Drill_Memo;
	private String Drill_Assess;
	private String Drill_Assess_Des;
	private String Drill_Assess_OP;
	private String View_Assess;
	private String View_Assess_Des;
	private String View_Assess_OP;
	private String Status;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sub_Id;
	
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

	public String getDrill_Type() {
		return Drill_Type;
	}

	public void setDrill_Type(String drillType) {
		Drill_Type = drillType;
	}

	public String getDrill_Type_Name() {
		return Drill_Type_Name;
	}

	public void setDrill_Type_Name(String drillTypeName) {
		Drill_Type_Name = drillTypeName;
	}

	public String getDrill_Title() {
		return Drill_Title;
	}

	public void setDrill_Title(String drillTitle) {
		Drill_Title = drillTitle;
	}

	public String getDrill_Time() {
		return Drill_Time;
	}

	public void setDrill_Time(String drillTime) {
		Drill_Time = drillTime;
	}

	public String getDrill_Cnt() {
		return Drill_Cnt;
	}

	public void setDrill_Cnt(String drillCnt) {
		Drill_Cnt = drillCnt;
	}

	public String getDrill_Memo() {
		return Drill_Memo;
	}

	public void setDrill_Memo(String drillMemo) {
		Drill_Memo = drillMemo;
	}
	
	public String getDrill_Assess() {
		return Drill_Assess;
	}

	public void setDrill_Assess(String drillAssess) {
		Drill_Assess = drillAssess;
	}
	
	public String getDrill_Assess_Des() {
		return Drill_Assess_Des;
	}

	public void setDrill_Assess_Des(String drillAssessDes) {
		Drill_Assess_Des = drillAssessDes;
	}

	public String getDrill_Assess_OP() {
		return Drill_Assess_OP;
	}

	public void setDrill_Assess_OP(String drillAssessOP) {
		Drill_Assess_OP = drillAssessOP;
	}

	public String getView_Assess() {
		return View_Assess;
	}

	public void setView_Assess(String viewAssess) {
		View_Assess = viewAssess;
	}
	
	public String getView_Assess_Des() {
		return View_Assess_Des;
	}

	public void setView_Assess_Des(String viewAssessDes) {
		View_Assess_Des = viewAssessDes;
	}

	public String getView_Assess_OP() {
		return View_Assess_OP;
	}

	public void setView_Assess_OP(String viewAssessOP) {
		View_Assess_OP = viewAssessOP;
	}

	public String getStatus() {
		return Status;
	}

	public void setStatus(String status) {
		Status = status;
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

	public String getSid() {
		return Sid;
	}

	public void setSid(String sid) {
		Sid = sid;
	}

	public String getFunc_Corp_Id() {
		return Func_Corp_Id;
	}

	public void setFunc_Corp_Id(String funcCorpId) {
		Func_Corp_Id = funcCorpId;
	}

	public String getFunc_Sub_Id() {
		return Func_Sub_Id;
	}

	public void setFunc_Sub_Id(String funcSubId) {
		Func_Sub_Id = funcSubId;
	}
}