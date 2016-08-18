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

public class SatTrainLBean extends RmiBean
{
	public final static long serialVersionUID = RmiBean.RMI_SAT_TRAIN_L;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SatTrainLBean() 
	{
		super.className = "SatTrainLBean";
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
		    	request.getSession().setAttribute("Sat_Train_L_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Sat_Train_L.jsp?Sid=" + Sid);
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
	            Label label = new Label(0, 0, "安全培训统计报表", wff);
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
	            label  = new Label(0, 1, "培训类型", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "培训次数", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "培训人数", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "培训课时", wff2);
	            sheet.addCell(label);
	            
	            //累计
	            int D_Train_Cnt_All    = 0;
	            int D_Train_Object_All = 0;
	            int D_Train_Hour_All   = 0;
				int i = 1;
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				while(iterator.hasNext())
				{
					i++;
					SatTrainLBean Bean = (SatTrainLBean)iterator.next();
					String D_Train_Type_Name = Bean.getTrain_Type_Name();
					String D_Train_Cnt = Bean.getTrain_Cnt();
					String D_Train_Object = Bean.getTrain_Object();
					String D_Train_Hour = Bean.getTrain_Hour();
					
					D_Train_Cnt_All += Integer.parseInt(D_Train_Cnt);
					D_Train_Object_All += Integer.parseInt(D_Train_Object);
					D_Train_Hour_All += Integer.parseInt(D_Train_Hour);
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,D_Train_Type_Name, wff3); //培训类型
		            sheet.addCell(label);
		            label = new Label(1,i,D_Train_Cnt, wff3);       //培训次数
		            sheet.addCell(label);
		            label = new Label(2,i,D_Train_Object, wff3);    //培训人数
		            sheet.addCell(label);
		            label = new Label(3,i,D_Train_Hour, wff3);      //培训课时
		            sheet.addCell(label);
				}
				
				//累计
				sheet.setRowView(i, 400);
				sheet.setColumnView(i, 20);
				label = new Label(0,i,"累计", wff2);
	            sheet.addCell(label);
	            label = new Label(1,i,D_Train_Cnt_All+"", wff2);
	            sheet.addCell(label);
	            label = new Label(2,i,D_Train_Object_All+"", wff2);
	            sheet.addCell(label);
	            label = new Label(3,i,D_Train_Hour_All+"", wff2);
	            sheet.addCell(label);
				
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
				Sql = " select '' as ctime, t.train_type, t.train_type_name, sum(t.train_cnt) as train_cnt, sum(t.train_object) as train_object, sum(t.train_hour) as train_hour " +
					  " from view_sat_train_l t " +
					  " where t.train_type like '"+ Func_Corp_Id +"%'" +					  
					  "   and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"'" +
					  "   and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"'" +
					  "   group by t.train_type, t.train_type_name " +
					  "   order by t.train_type asc ";
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
			setTrain_Type(pRs.getString(2));
			setTrain_Type_Name(pRs.getString(3));
			setTrain_Cnt(pRs.getString(4));
			setTrain_Object(pRs.getString(5));
			setTrain_Hour(pRs.getString(6));
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
			setTrain_Type(CommUtil.StrToGB2312(request.getParameter("Train_Type")));
			setTrain_Type_Name(CommUtil.StrToGB2312(request.getParameter("Train_Type_Name")));
			setTrain_Cnt(CommUtil.StrToGB2312(request.getParameter("Train_Cnt")));
			setTrain_Object(CommUtil.StrToGB2312(request.getParameter("Train_Object")));
			setTrain_Hour(CommUtil.StrToGB2312(request.getParameter("Train_Hour")));
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
	private String Train_Type;
	private String Train_Type_Name;
	private String Train_Cnt;
	private String Train_Object;
	private String Train_Hour;
	
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

	public String getTrain_Type() {
		return Train_Type;
	}

	public void setTrain_Type(String trainType) {
		Train_Type = trainType;
	}

	public String getTrain_Type_Name() {
		return Train_Type_Name;
	}

	public void setTrain_Type_Name(String trainTypeName) {
		Train_Type_Name = trainTypeName;
	}

	public String getTrain_Cnt() {
		return Train_Cnt;
	}

	public void setTrain_Cnt(String trainCnt) {
		Train_Cnt = trainCnt;
	}

	public String getTrain_Object() {
		return Train_Object;
	}

	public void setTrain_Object(String trainObject) {
		Train_Object = trainObject;
	}

	public String getTrain_Hour() {
		return Train_Hour;
	}

	public void setTrain_Hour(String trainHour) {
		Train_Hour = trainHour;
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