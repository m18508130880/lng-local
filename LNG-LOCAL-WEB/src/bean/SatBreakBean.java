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

public class SatBreakBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SAT_BREAK;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SatBreakBean()
	{
		super.className = "SatBreakBean"; 
	}
	
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
			case 0://查询
		    	request.getSession().setAttribute("Sat_Break_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_Break.jsp?Sid=" + Sid);
		    	break;
		    	
			case 1://安全检查链接
				request.getSession().setAttribute("Sat_Break_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_Check_Break.jsp?Sid=" + Sid);
				break;
			case 2:
				request.getSession().setAttribute("Sat_Break_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_Break.jsp?Sid=" + Sid);
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
	            Label label = new Label(0, 0, "员工违章行为记录", wff);
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
	            label  = new Label(1, 1, "所属场站", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(2, 1, "违章时间", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(3, 1, "违章行为及违反条款", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(4, 1, "违章人", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(5, 1, "岗位", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(6, 1, "直接管理人", wff2);
	            sheet.addCell(label);            
	            label  = new Label(7, 1, "绩效挂钩", wff2);
	            sheet.addCell(label);            
	            label  = new Label(8, 1, "录入人员", wff2);
	            sheet.addCell(label);	                    
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 1;
				while(iterator.hasNext())
				{
					i++;
					SatBreakBean Bean = (SatBreakBean)iterator.next();
					String D_Cpm_Name = Bean.getCpm_Name();
					String D_Break_Time = Bean.getBreak_Time();
					String D_Break_Des = Bean.getBreak_Des();
					String D_Break_OP_Name = Bean.getBreak_OP_Name();
					String D_Break_OP_Pos = Bean.getBreak_OP_Pos();
					String D_Break_Point = Bean.getBreak_Point();
					String D_Manag_OP_Name = Bean.getManag_OP_Name();
					String D_Operator_Name = Bean.getOperator_Name();
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);				
					label = new Label(0,i,(i-1)+"", wff3);          //序号
		            sheet.addCell(label);
		            label = new Label(1,i,D_Cpm_Name, wff3);        //所属场站
		            sheet.addCell(label);
		            label = new Label(2,i,D_Break_Time, wff3);      //违章时间
		            sheet.addCell(label);
		            label = new Label(3,i,D_Break_Des, wff3);       //违章行为及违反条款
		            sheet.addCell(label);	            
		            label = new Label(4,i,D_Break_OP_Name, wff3);   //违章人
		            sheet.addCell(label);	            
		            label = new Label(5,i,D_Break_OP_Pos, wff3);    //岗位
		            sheet.addCell(label);	            
		            label = new Label(6,i,D_Manag_OP_Name, wff3);   //直接管理人
		            sheet.addCell(label);		            
		            label = new Label(7,i,D_Break_Point, wff3);     //绩效挂钩
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
	
	//操作
	public void SatBreakAdd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
		{
			Resp = "0000";
			currStatus.setCmd(0);
			msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
			request.getSession().setAttribute("Sat_Break_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		outprint.write(Resp);
	}
	
	//安全检查链接编辑
	public void SatBreakEdit(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
		{
			Resp = "0000";
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
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.break_time, t.break_op, t.break_op_name, t.break_op_pos, t.break_des, t.break_point, t.manag_op, t.manag_op_name, t.ctime, t.operator, t.operator_name, t.check_sn " +
					  " from view_sat_break t " +
					  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
					  "   and t.break_time >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
					  "   and t.break_time <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
					  "   order by t.break_time desc ";
				break;
			case 1://安全检查链接
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.break_time, t.break_op, t.break_op_name, t.break_op_pos, t.break_des, t.break_point, t.manag_op, t.manag_op_name, t.ctime, t.operator, t.operator_name, t.check_sn " +
				  	  " from view_sat_break t " +
				  	  " where t.sn = '"+ SN +"'";
				break;	
			case 2://安全检查链接
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.break_time, t.break_op, t.break_op_name, t.break_op_pos, t.break_des, t.break_point, t.manag_op, t.manag_op_name, t.ctime, t.operator, t.operator_name, t.check_sn " +
				  	  " from view_sat_break t " +				  
				  	  " where t.sn = '"+ SN +"'";
				break;			
			case 10://添加
				Sql = " insert into sat_break(cpm_id, break_time, break_op, break_des, break_point, manag_op, ctime, operator, check_sn)" +
					  " values('"+ Cpm_Id +"', '"+ Break_Time +"', '"+ Break_OP +"', '"+ Break_Des +"', '"+ Break_Point +"', '"+ Manag_OP +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"', '"+ Check_SN +"')";
				break;
			case 11://安全检查链接编辑
				Sql = " update sat_break t set t.cpm_id = '"+ Cpm_Id +"', t.break_time = '"+ Break_Time +"', t.break_op = '"+ Break_OP +"', t.manag_op = '"+ Manag_OP +"', t.break_point = '"+ Break_Point +"', t.break_des = '"+ Break_Des +"', t.operator = '"+ Operator +"' " +
					  " where t.sn = '"+ SN +"' ";
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
			setBreak_Time(pRs.getString(4));
			setBreak_OP(pRs.getString(5));
			setBreak_OP_Name(pRs.getString(6));
			setBreak_OP_Pos(pRs.getString(7));
			setBreak_Des(pRs.getString(8));
			setBreak_Point(pRs.getString(9));
			setManag_OP(pRs.getString(10));
			setManag_OP_Name(pRs.getString(11));
			setCTime(pRs.getString(12));
			setOperator(pRs.getString(13));
			setOperator_Name(pRs.getString(14));
			setCheck_SN(pRs.getString(15));
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
			setBreak_Time(CommUtil.StrToGB2312(request.getParameter("Break_Time")));
			setBreak_OP(CommUtil.StrToGB2312(request.getParameter("Break_OP")));
			setBreak_OP_Name(CommUtil.StrToGB2312(request.getParameter("Break_OP_Name")));
			setBreak_OP_Pos(CommUtil.StrToGB2312(request.getParameter("Break_OP_Pos")));
			setBreak_Des(CommUtil.StrToGB2312(request.getParameter("Break_Des")));
			setBreak_Point(CommUtil.StrToGB2312(request.getParameter("Break_Point")));
			setManag_OP(CommUtil.StrToGB2312(request.getParameter("Manag_OP")));
			setManag_OP_Name(CommUtil.StrToGB2312(request.getParameter("Manag_OP_Name")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
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
	private String Break_Time;
	private String Break_OP;
	private String Break_OP_Name;
	private String Break_OP_Pos;
	private String Break_Des;
	private String Break_Point;
	private String Manag_OP;
	private String Manag_OP_Name;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	private String Check_SN;
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

	public String getBreak_Time() {
		return Break_Time;
	}

	public void setBreak_Time(String breakTime) {
		Break_Time = breakTime;
	}

	public String getBreak_OP() {
		return Break_OP;
	}

	public void setBreak_OP(String breakOP) {
		Break_OP = breakOP;
	}

	public String getBreak_OP_Name() {
		return Break_OP_Name;
	}

	public void setBreak_OP_Name(String breakOPName) {
		Break_OP_Name = breakOPName;
	}

	public String getBreak_OP_Pos() {
		return Break_OP_Pos;
	}

	public void setBreak_OP_Pos(String breakOPPos) {
		Break_OP_Pos = breakOPPos;
	}

	public String getBreak_Des() {
		return Break_Des;
	}

	public void setBreak_Des(String breakDes) {
		Break_Des = breakDes;
	}

	public String getBreak_Point() {
		return Break_Point;
	}

	public void setBreak_Point(String breakPoint) {
		Break_Point = breakPoint;
	}

	public String getManag_OP() {
		return Manag_OP;
	}

	public void setManag_OP(String managOP) {
		Manag_OP = managOP;
	}

	public String getManag_OP_Name() {
		return Manag_OP_Name;
	}

	public void setManag_OP_Name(String managOPName) {
		Manag_OP_Name = managOPName;
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
	
	public String getCheck_SN() {
		return Check_SN;
	}

	public void setCheck_SN(String checkSN) {
		Check_SN = checkSN;
	}

	public String getSid() {
		return Sid;
	}

	public void setSid(String sid) {
		Sid = sid;
	}
}