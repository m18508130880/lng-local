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

public class SatDrillLBean extends RmiBean
{
	public final static long serialVersionUID = RmiBean.RMI_SAT_DRILL_L;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SatDrillLBean()
	{
		super.className = "SatDrillLBean";
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
		    	request.getSession().setAttribute("Sat_Drill_L_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Sat_Drill_L.jsp?Sid=" + Sid);
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
	            Label label = new Label(0, 0, "应急演练统计报表", wff);
	            sheet.addCell(label);
	            label = new Label(1, 0, "");
	            sheet.addCell(label);
	            label = new Label(2, 0, "");
	            sheet.addCell(label);
	            label = new Label(3, 0, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,0,3,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "演练单位", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "演练类型", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "演练次数", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "参演人数", wff2);
	            sheet.addCell(label);
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 1;
				while(iterator.hasNext())
				{
					i++;
					SatDrillLBean Bean = (SatDrillLBean)iterator.next();
					String D_Cpm_Name = Bean.getCpm_Name();
					String D_Drill_Type_Name = Bean.getDrill_Type_Name();
					String D_Drill_Cnt = Bean.getDrill_Cnt();
					String D_Drill_Object = Bean.getDrill_Object();
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,D_Cpm_Name, wff3);        //演练单位
		            sheet.addCell(label);
		            label = new Label(1,i,D_Drill_Type_Name, wff3); //演练类型
		            sheet.addCell(label);
		            label = new Label(2,i,D_Drill_Cnt, wff3);       //演练次数
		            sheet.addCell(label);
		            label = new Label(3,i,D_Drill_Object, wff3);    //参演人数
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
				Sql = " select '' as ctime, t.cpm_id, t.cpm_name, t.drill_type, t.drill_type_name, sum(t.drill_cnt) as drill_cnt, sum(t.drill_object) as drill_object " +
					  " from view_sat_drill_l t " +
					  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
					  "   and t.drill_type like '"+ Func_Corp_Id +"%'" +					  
					  "   and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"'" +
					  "   and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"'" +
					  "   group by t.cpm_id, t.cpm_name, t.drill_type, t.drill_type_name " +
					  "   order by t.cpm_id, t.drill_type asc ";
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
			setDrill_Type(pRs.getString(4));
			setDrill_Type_Name(pRs.getString(5));
			setDrill_Cnt(pRs.getString(6));
			setDrill_Object(pRs.getString(7));
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
			setDrill_Type(CommUtil.StrToGB2312(request.getParameter("Drill_Type")));
			setDrill_Type_Name(CommUtil.StrToGB2312(request.getParameter("Drill_Type_Name")));
			setDrill_Cnt(CommUtil.StrToGB2312(request.getParameter("Drill_Cnt")));
			setDrill_Object(CommUtil.StrToGB2312(request.getParameter("Drill_Object")));
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
	private String Drill_Type;
	private String Drill_Type_Name;
	private String Drill_Cnt;
	private String Drill_Object;
	
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

	public String getDrill_Cnt() {
		return Drill_Cnt;
	}

	public void setDrill_Cnt(String drillCnt) {
		Drill_Cnt = drillCnt;
	}

	public String getDrill_Object() {
		return Drill_Object;
	}

	public void setDrill_Object(String drillObject) {
		Drill_Object = drillObject;
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