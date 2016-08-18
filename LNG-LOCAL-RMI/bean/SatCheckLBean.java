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

public class SatCheckLBean extends RmiBean
{
	public final static long serialVersionUID = RmiBean.RMI_SAT_CHECK_L;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SatCheckLBean()
	{
		super.className = "SatCheckLBean";
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
		
		switch(currStatus.getFunc_Sub_Id())
		{
			case 0://年报表
		    	request.getSession().setAttribute("Year_" + Sid, Year);
				break;
			case 1://月报表
				request.getSession().setAttribute("Month_" + Sid, Month);
		    	request.getSession().setAttribute("Year_" + Sid, Year);
				break;
		}
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			case 0://查询
		    	request.getSession().setAttribute("Sat_Check_L_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Sat_Check_L.jsp?Sid=" + Sid);
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
			
			switch(currStatus.getFunc_Sub_Id())
			{
				case 0://年报表
			    	request.getSession().setAttribute("Year_" + Sid, Year);
					break;
				case 1://月报表
					request.getSession().setAttribute("Month_" + Sid, Month);
			    	request.getSession().setAttribute("Year_" + Sid, Year);
					break;
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
	            Label label = new Label(0, 0, "安全检查统计报表", wff);
	            sheet.addCell(label);
	            label = new Label(1, 0, "");
	            sheet.addCell(label);
	            label = new Label(2, 0, "");
	            sheet.addCell(label);
	            label = new Label(3, 0, "");
	            sheet.addCell(label);
	            label = new Label(4, 0, "");
	            sheet.addCell(label);	                    
	            sheet.mergeCells(0,0,4,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "检查对象", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(1, 1, "检查类型", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(2, 1, "检查次数", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(3, 1, "隐患项数", wff2);
	            sheet.addCell(label);	            
	            label  = new Label(4, 1, "违章项数", wff2);
	            sheet.addCell(label);	                        
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 1;
				while(iterator.hasNext())
				{
					i++;
					SatCheckLBean Bean = (SatCheckLBean)iterator.next();
					String D_Cpm_Name = Bean.getCpm_Name();
					String D_Check_Type_Name = Bean.getCheck_Type_Name();
					String D_Check_Cnt = Bean.getCheck_Cnt();
					String D_Check_Danger = Bean.getCheck_Danger();
					String D_Check_Break = Bean.getCheck_Break();
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,D_Cpm_Name, wff3);        //检查对象
		            sheet.addCell(label);
		            label = new Label(1,i,D_Check_Type_Name, wff3); //检查类型
		            sheet.addCell(label);
		            label = new Label(2,i,D_Check_Cnt, wff3);       //检查次数
		            sheet.addCell(label);
		            label = new Label(3,i,D_Check_Danger, wff3);    //隐患项数
		            sheet.addCell(label);
		            label = new Label(4,i,D_Check_Break, wff3);   	//违章项数
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
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd)
		{
			case 0://查询
				Sql = " select '' as ctime, t.cpm_id, t.cpm_name, t.check_type, t.check_type_name, sum(t.check_cnt) as check_cnt, sum(t.check_danger) as check_danger, sum(t.check_break) as check_break " +
					  " from view_sat_check_l t " +
					  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
					  "   and t.check_type like '"+ Func_Corp_Id +"%'" +					  
					  "   and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"'" +
					  "   and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"'" +
					  "   group by t.cpm_id, t.cpm_name, t.check_type, t.check_type_name " +
					  "   order by t.cpm_id, t.check_type asc ";
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs)
	{
		boolean IsOK = true;
		try
		{
			setCTime(pRs.getString(1));
			setCpm_Id(pRs.getString(2));
			setCpm_Name(pRs.getString(3));
			setCheck_Type(pRs.getString(4));
			setCheck_Type_Name(pRs.getString(5));
			setCheck_Cnt(pRs.getString(6));
			setCheck_Danger(pRs.getString(7));
			setCheck_Break(pRs.getString(8));
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
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setCpm_Name(CommUtil.StrToGB2312(request.getParameter("Cpm_Name")));
			setCheck_Type(CommUtil.StrToGB2312(request.getParameter("Check_Type")));
			setCheck_Type_Name(CommUtil.StrToGB2312(request.getParameter("Check_Type_Name")));
			setCheck_Cnt(CommUtil.StrToGB2312(request.getParameter("Check_Cnt")));
			setCheck_Danger(CommUtil.StrToGB2312(request.getParameter("Check_Danger")));
			setCheck_Break(CommUtil.StrToGB2312(request.getParameter("Check_Break")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
			setYear(CommUtil.StrToGB2312(request.getParameter("Year")));
			setMonth(CommUtil.StrToGB2312(request.getParameter("Month")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String CTime;
	private String Cpm_Id;
	private String Cpm_Name;
	private String Check_Type;
	private String Check_Type_Name;
	private String Check_Cnt;
	private String Check_Danger;
	private String Check_Break;
	
	private String Sid;
	private String Func_Corp_Id;
	private String Year;
	private String Month;
	
	public String getCTime() {
		return CTime;
	}

	public void setCTime(String cTime) {
		CTime = cTime;
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
	
	public String getCheck_Cnt() {
		return Check_Cnt;
	}

	public void setCheck_Cnt(String checkCnt) {
		Check_Cnt = checkCnt;
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

	public String getYear() {
		return Year;
	}

	public void setYear(String year) {
		Year = year;
	}

	public String getMonth() {
		return Month;
	}

	public void setMonth(String month) {
		Month = month;
	}
}