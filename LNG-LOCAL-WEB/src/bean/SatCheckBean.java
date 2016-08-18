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

public class SatCheckBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SAT_CHECK;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SatCheckBean()
	{
		super.className = "SatCheckBean";
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
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
			case 0://查询
		    	request.getSession().setAttribute("Sat_Check_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_Check.jsp?Sid=" + Sid);		 
		    	
		    	//检查类型
		    	AqscExamTypeBean ExamType = new AqscExamTypeBean();
		    	msgBean = pRmi.RmiExec(0, ExamType, 0);
				request.getSession().setAttribute("Sat_Check_Type_" + Sid, (Object)msgBean.getMsg());				
				//隐患类型
		    	AqscDangerTypeBean DangerType = new AqscDangerTypeBean();
		    	msgBean = pRmi.RmiExec(0, DangerType, 0);
				request.getSession().setAttribute("Sat_Danger_Type_" + Sid, (Object)msgBean.getMsg());		    	
		    	//隐患级别
				AqscDangerLevelBean DangerLevel = new AqscDangerLevelBean();
				msgBean = pRmi.RmiExec(0, DangerLevel, 0);
				request.getSession().setAttribute("Sat_Danger_Level_" + Sid, (Object)msgBean.getMsg());				
		    	//查询隐患
				SatDangerBean dBean = new SatDangerBean();
				dBean.setCpm_Id(Cpm_Id);
				dBean.setFunc_Corp_Id("");
				dBean.setFunc_Type_Id("");
				dBean.setFunc_Sub_Id("");				
				dBean.currStatus = currStatus;
				msgBean = pRmi.RmiExec(0, dBean, 0);
				request.getSession().setAttribute("Sat_Danger_"+Sid,(Object)msgBean.getMsg());
				
				
				//查询违章
				SatBreakBean bBean = new SatBreakBean();
				bBean.setCpm_Id(Cpm_Id);
				bBean.currStatus = currStatus;
				msgBean = pRmi.RmiExec(0, bBean, 0);
				request.getSession().setAttribute("Sat_Beank_"+Sid,(Object)msgBean.getMsg());
				
				
										
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
	            Label label = new Label(0, 0, "场站安全检查记录", wff);
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
	            sheet.mergeCells(0,0,8,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "序号", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(1, 1, "检查对象", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(2, 1, "检查类型", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(3, 1, "检查时间", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(4, 1, "检查部门", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(5, 1, "隐患", wff2);
	            
	            sheet.addCell(label);	            
	            label  = new Label(6, 1, "违章记录", wff2);
	            sheet.addCell(label);            
	            label  = new Label(7, 1, "问题描述", wff2);
	            sheet.addCell(label);            
	            label  = new Label(8, 1, "录入人员", wff2);
	            sheet.addCell(label);	                    
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 1;
				while(iterator.hasNext())
				{
					i++;
					SatCheckBean Bean = (SatCheckBean)iterator.next();
					String D_Cpm_Name = Bean.getCpm_Name();
					String D_Check_Dept = Bean.getCheck_Dept();
					String D_Check_Type_Name = Bean.getCheck_Type_Name();
					String D_Check_Time = Bean.getCheck_Time();
					String D_Check_Danger = Bean.getCheck_Danger();
					String D_Check_Break = Bean.getCheck_Break();
					String D_Memo = Bean.getMemo();
					String D_Operator_Name = Bean.getOperator_Name();
					
					if(null == D_Memo){D_Memo = "";}
					if(null == D_Check_Danger){D_Check_Danger = "";}
					if(null == D_Check_Break){D_Check_Break = "";}
					
					ArrayList<?> User_Device_Detail = (ArrayList<?>)request.getSession().getAttribute("User_Device_Detail_" + Sid);					
					CorpInfoBean Corp_Info = (CorpInfoBean)request.getSession().getAttribute("User_Corp_Info_" + Sid);					
					String Check_Dept_Name = "无";
					if(null != D_Check_Dept)
				 	{
						switch(D_Check_Dept.length())
				 		{
				 			case 2:
				 				if(null != Corp_Info.getDept()&& Corp_Info.getDept().trim().length() > 0)
							 	{
							 		String[] DeptList = Corp_Info.getDept().split(",");
									for(int j=0; j<DeptList.length; j++)
									{
										if(D_Check_Dept.equals(CommUtil.IntToStringLeftFillZero(j+1, 2)))
											Check_Dept_Name = DeptList[j];
									}
							 	}
				 				break;
				 			case 10:
				 				if(null != User_Device_Detail)
			 					{
			 						Iterator<?> deviter = User_Device_Detail.iterator();
									while(deviter.hasNext())
									{
										DeviceDetailBean devBean = (DeviceDetailBean)deviter.next();
										if(D_Check_Dept.equals(devBean.getId()))
										{
											Check_Dept_Name = devBean.getBrief();
										}
									}
			 					}
				 				break;
				 		}
				 	}
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);				
					label = new Label(0,i,(i-1)+"", wff3);          //序号
		            sheet.addCell(label);
		            label = new Label(1,i,D_Cpm_Name, wff3);        //检查对象
		            sheet.addCell(label);
		            label = new Label(2,i,D_Check_Type_Name, wff3); //检查类型
		            sheet.addCell(label);
		            label = new Label(3,i,D_Check_Time, wff3);      //检查时间
		            sheet.addCell(label);	            
		            label = new Label(4,i,Check_Dept_Name, wff3);   //检查部门
		            sheet.addCell(label);	            
		            label = new Label(5,i,(D_Check_Danger.length()>0?D_Check_Danger.split(",").length:0)+"项", wff3);//隐患跟踪
		            sheet.addCell(label);	            
		            label = new Label(6,i,(D_Check_Break.length()>0?D_Check_Break.split(",").length:0)+"项", wff3);  //违章记录
		            sheet.addCell(label);		            
		            label = new Label(7,i,D_Memo, wff3);            //问题描述
		            sheet.addCell(label);
		            label = new Label(8,i,D_Operator_Name, wff3);   //录入人员
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
	
	//添加
	public void SatCheckAdd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
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
		
		//PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		//隐患表添加
		SatDangerBean dangBean = new SatDangerBean();
		dangBean.setCpm_Id(Cpm_Id);
		dangBean.setDanger_Type(Danger_Type);
		dangBean.setDanger_Level(Danger_Level);
		dangBean.setDanger_Des(Danger_Des);
		dangBean.setDanger_BTime(Danger_BTime);
		dangBean.setDanger_ETime(Danger_ETime);
		dangBean.setOperator(Operator);
		dangBean.setCheck_SN(Check_SN);
		//msgBean = pRmi.RmiExec(10, dangBean, 0);
				
		//违章表添加
		SatBreakBean breakBean = new SatBreakBean();
		breakBean.setCpm_Id(Cpm_Id);
		breakBean.setBreak_Time(Break_Time);
		breakBean.setBreak_OP(Break_OP);
		breakBean.setBreak_Des(Break_Des);
		breakBean.setBreak_Point(Break_Point);
		breakBean.setManag_OP(Manag_OP);
		breakBean.setOperator(Operator);
		breakBean.setCheck_SN(Check_SN);
		//msgBean = pRmi.RmiExec(10, breakBean, 0);
		
		
		switch(currStatus.getFunc_Id())
		{
		case 1:
			Check_Danger = Danger_Level;
			Check_Break  = Break_OP;
			msgBean = pRmi.RmiExec(10, dangBean, 0);
			msgBean = pRmi.RmiExec(10, breakBean, 0);
			break;
			
		case 2:
			Check_Danger = Danger_Level;
			msgBean = pRmi.RmiExec(10, dangBean, 0);
			break;
			
		case 3:
			Check_Break = Break_OP;
			msgBean = pRmi.RmiExec(10, breakBean, 0);			
			break;
			
		}
		
		System.out.println(currStatus.getFunc_Id());
		
		//安全录入表添加		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
		{
			Resp = "0000";
			currStatus.setCmd(0);
			msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
			request.getSession().setAttribute("Sat_Check_" + Sid, ((Object)msgBean.getMsg()));
			currStatus.setJsp("Sat_Check.jsp?Sid=" + Sid);
	    	currStatus.setTotalRecord(msgBean.getCount());
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		response.sendRedirect(currStatus.getJsp());
	}
	
	//删除
	public void SatCheckDel(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		
		//删除隐患、违章
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
		{
			//更新隐患、违章
			switch(currStatus.getCmd())
			{
				case 15://删除隐患
					msgBean = pRmi.RmiExec(13, this, 0);
					if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
						Resp = "0000";
					break;
				case 16://删除违章
					msgBean = pRmi.RmiExec(14, this, 0);
					if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
						Resp = "0000";
					break;
			}
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
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.check_dept, t.check_type, t.check_type_name, t.check_time, t.check_danger, t.check_break, t.memo, t.ctime, t.operator, t.operator_name " +
					  " from view_sat_check t " +
					  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
					  "   and t.check_type like '"+ Func_Corp_Id +"%'" +
					  "   and t.check_time >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
					  "   and t.check_time <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
					  "   order by t.check_time desc ";
				break;
			case 10://添加
				Sql = " insert into sat_check(cpm_id, check_dept, check_type, check_time,check_danger,check_break, memo, ctime, operator)" +
				  	  " values('"+ Cpm_Id +"', '"+ Check_Dept +"', '"+ Check_Type +"', '"+ Check_Time +"','"+ Check_Danger +"','"+ Check_Break +"' , '"+ Memo +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"')";
				break;
			case 13://修改隐患
				Sql = " update sat_check t set t.check_danger = '"+ Check_Danger +"' where t.sn = '"+ SN +"'";
				break;
			case 14://修改违章
				Sql = " update sat_check t set t.check_break = '"+ Check_Break +"' where t.sn = '"+ SN +"'";
				break;
			case 15://删除隐患
				Sql = " delete from sat_danger where sn = '"+ DangerSN +"'";
				break;
			case 16://删除违章
				Sql = " delete from sat_break where sn = '"+ BreakSN +"'";
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
			setCheck_Dept(pRs.getString(4));
			setCheck_Type(pRs.getString(5));
			setCheck_Type_Name(pRs.getString(6));
			setCheck_Time(pRs.getString(7));
			setCheck_Danger(pRs.getString(8));
			setCheck_Break(pRs.getString(9));
			setMemo(pRs.getString(10));
			setCTime(pRs.getString(11));
			setOperator(pRs.getString(12));
			setOperator_Name(pRs.getString(13));
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
			System.out.println("这里设置页面数据0");
			setSN(CommUtil.StrToGB2312(request.getParameter("SN")));
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setCpm_Name(CommUtil.StrToGB2312(request.getParameter("Cpm_Name")));
			setCheck_Dept(CommUtil.StrToGB2312(request.getParameter("Check_Dept")));
			setCheck_Type(CommUtil.StrToGB2312(request.getParameter("Check_Type")));
			setCheck_Type_Name(CommUtil.StrToGB2312(request.getParameter("Check_Type_Name")));
			setCheck_Time(CommUtil.StrToGB2312(request.getParameter("Check_Time")));
			setCheck_Danger(CommUtil.StrToGB2312(request.getParameter("Check_Danger")));
			setCheck_Break(CommUtil.StrToGB2312(request.getParameter("Check_Break")));
			setMemo(CommUtil.StrToGB2312(request.getParameter("Memo")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
			setDangerSN(CommUtil.StrToGB2312(request.getParameter("DangerSN")));
			setBreakSN(CommUtil.StrToGB2312(request.getParameter("BreakSN")));
			System.out.println("这里设置页面数据1");
			setBreak_Time(CommUtil.StrToGB2312(request.getParameter("Break_Time")));
			setBreak_OP(CommUtil.StrToGB2312(request.getParameter("Break_OP")));
			setBreak_Des(CommUtil.StrToGB2312(request.getParameter("Break_Des")));
			setBreak_Point(CommUtil.StrToGB2312(request.getParameter("Break_Point")));
			setManag_OP(CommUtil.StrToGB2312(request.getParameter("Manag_OP")));
			setCheck_SN(CommUtil.StrToGB2312(request.getParameter("Check_SN")));
			setDanger_Level(CommUtil.StrToGB2312(request.getParameter("Danger_Level")));
			setDanger_Des(CommUtil.StrToGB2312(request.getParameter("Danger_Des")));
			setDanger_BTime(CommUtil.StrToGB2312(request.getParameter("Danger_BTime")));
			setDanger_ETime(CommUtil.StrToGB2312(request.getParameter("Danger_ETime")));
			setDanger_Type(CommUtil.StrToGB2312(request.getParameter("Danger_Type")));
			System.out.println(Break_Time+"这里"+Break_OP);
			
			
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
	private String Check_Dept;
	private String Check_Type;
	private String Check_Type_Name;
	private String Check_Time;
	private String Check_Danger;
	private String Check_Break;
	private String Memo;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	
	private String Sid;
	private String Func_Corp_Id;
	private String DangerSN;
	private String BreakSN;
	
	
	//违章表
	private String Break_Time;
	private String Break_OP;
	private String Break_Des;
	private String Break_Point;
	private String Manag_OP;	
	private String Check_SN;
	
	//隐患表
	private String Danger_Level;
	private String Danger_Des;
	private String Danger_BTime;
	private String Danger_ETime;
	private String Danger_Type;
	
	
	public String getBreak_Time() {
		return Break_Time;
	}

	public void setBreak_Time(String break_Time) {
		Break_Time = break_Time;
	}

	public String getBreak_OP() {
		return Break_OP;
	}

	public void setBreak_OP(String break_OP) {
		Break_OP = break_OP;
	}

	public String getBreak_Des() {
		return Break_Des;
	}

	public void setBreak_Des(String break_Des) {
		Break_Des = break_Des;
	}

	public String getBreak_Point() {
		return Break_Point;
	}

	public void setBreak_Point(String break_Point) {
		Break_Point = break_Point;
	}

	public String getManag_OP() {
		return Manag_OP;
	}

	public void setManag_OP(String manag_OP) {
		Manag_OP = manag_OP;
	}

	public String getCheck_SN() {
		return Check_SN;
	}

	public void setCheck_SN(String check_SN) {
		Check_SN = check_SN;
	}

	public String getDanger_Type() {
		return Danger_Type;
	}

	public void setDanger_Type(String danger_Type) {
		Danger_Type = danger_Type;
	}

	public String getDanger_Level() {
		return Danger_Level;
	}

	public void setDanger_Level(String danger_Level) {
		Danger_Level = danger_Level;
	}

	public String getDanger_Des() {
		return Danger_Des;
	}

	public void setDanger_Des(String danger_Des) {
		Danger_Des = danger_Des;
	}

	public String getDanger_BTime() {
		return Danger_BTime;
	}

	public void setDanger_BTime(String danger_BTime) {
		Danger_BTime = danger_BTime;
	}

	public String getDanger_ETime() {
		return Danger_ETime;
	}

	public void setDanger_ETime(String danger_ETime) {
		Danger_ETime = danger_ETime;
	}
	
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

	public String getCheck_Dept() {
		return Check_Dept;
	}

	public void setCheck_Dept(String checkDept) {
		Check_Dept = checkDept;
	}

	public String getCheck_Type() {
		return Check_Type;
	}

	public void setCheck_Type(String checkType) {
		Check_Type = checkType;
	}

	public String getCheck_Type_Name() {
		return Check_Type_Name;
	}

	public void setCheck_Type_Name(String checkTypeName) {
		Check_Type_Name = checkTypeName;
	}

	public String getCheck_Time() {
		return Check_Time;
	}

	public void setCheck_Time(String checkTime) {
		Check_Time = checkTime;
	}

	public String getCheck_Danger() {
		return Check_Danger;
	}

	public void setCheck_Danger(String checkDanger) {
		Check_Danger = checkDanger;
	}

	public String getCheck_Break() {
		return Check_Break;
	}

	public void setCheck_Break(String checkBreak) {
		Check_Break = checkBreak;
	}

	public String getMemo() {
		return Memo;
	}

	public void setMemo(String memo) {
		Memo = memo;
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

	public String getDangerSN() {
		return DangerSN;
	}

	public void setDangerSN(String dangerSN) {
		DangerSN = dangerSN;
	}

	public String getBreakSN() {
		return BreakSN;
	}

	public void setBreakSN(String breakSN) {
		BreakSN = breakSN;
	}
}