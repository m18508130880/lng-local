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

public class FixLedgerBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_FIX_LEDGER;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public FixLedgerBean()
	{
		super.className = "FixLedgerBean";
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
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			case 0://查询
		    	request.getSession().setAttribute("Fix_Ledger_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Fix_Ledger.jsp?Sid=" + Sid);
		    	
		    	//设备品种
		    	AqscDeviceBreedBean DeviceBreed = new AqscDeviceBreedBean();
		    	msgBean = pRmi.RmiExec(0, DeviceBreed, 0);
				request.getSession().setAttribute("Dev_List_Breed_" + Sid, (Object)msgBean.getMsg());
				//故障耗费材料查询
				FixTraceBean traBean = new FixTraceBean();
				traBean.setCpm_Id(Cpm_Id);
				traBean.setDev_Type(Dev_Type);
				traBean.currStatus = currStatus;
				msgBean = pRmi.RmiExec(3, traBean, 0);
				request.getSession().setAttribute("Fix_Trace_" + Sid, (Object)msgBean.getMsg());
				
				
				switch(currStatus.getFunc_Sel_Id())
				{
			    	case 1://按月
			    		request.getSession().setAttribute("Year_" + Sid, Year);
			    		request.getSession().setAttribute("Month_" + Sid, Month);
			    		break;
			    	case 2://按季度
			    		request.getSession().setAttribute("Year_" + Sid, Year);
			    		request.getSession().setAttribute("Quarter_" + Sid, Quarter);
			    		break;
			    	case 3://按年
			    		request.getSession().setAttribute("Year_" + Sid, Year);
			    		break;
				}
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
			
			switch(currStatus.getFunc_Sel_Id())
			{
		    	case 1://按月
		    		request.getSession().setAttribute("Year_" + Sid, Year);
		    		request.getSession().setAttribute("Month_" + Sid, Month);
		    		break;
		    	case 2://按季度
		    		request.getSession().setAttribute("Year_" + Sid, Year);
		    		request.getSession().setAttribute("Quarter_" + Sid, Quarter);
		    		break;
		    	case 3://按年
		    		request.getSession().setAttribute("Year_" + Sid, Year);
		    		break;
			}
			
			//清除历史		
			
			//生成当前
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(0).toString().substring(5,10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			//库存台帐
			msgBean = pRmi.RmiExec(0, this, 0);
			ArrayList<?> temp0 = (ArrayList<?>)msgBean.getMsg();
			
			if(null != temp0)
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
				wff2.setAlignment(Alignment.RIGHT);//设置居中
				wff2.setBorder(Border.ALL, BorderLineStyle.THIN);//设置边框线
				
				//字体格式3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);
				wf3.setColour(Colour.BLACK);//字体颜色
				wff3.setAlignment(Alignment.CENTRE);//设置居中
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//设置边框线
				
				//字体格式4
				WritableFont wf4 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff4 = new WritableCellFormat(wf4);
				wf4.setColour(Colour.BLACK);//字体颜色
				wff4.setAlignment(Alignment.CENTRE);//设置居中
				wff4.setBorder(Border.ALL, BorderLineStyle.THIN);//设置边框线
				
				String D_Cpm_Chg = "";
				int Chg_cnt      = 0;
				int D_Index      = -1;
				Label label      = null;
				
				D_Index++;
	            sheet.setRowView(D_Index, 600);
	            sheet.setColumnView(D_Index, 20);
	            switch(currStatus.getFunc_Sel_Id())
				{
					case 1:
						label = new Label(0, D_Index, "故障统计月报表", wff);
			            sheet.addCell(label);
						break;
					case 2:
						label = new Label(0, D_Index, "故障统计季度报表", wff);
			            sheet.addCell(label);
						break;
					case 3:
						label = new Label(0, D_Index, "故障统计年报表", wff);
			            sheet.addCell(label);
						break;
				}
	            label = new Label(1, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,3,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            switch(currStatus.getFunc_Sel_Id())
				{
					case 1:
						label = new Label(0, D_Index, Year+"年"+Month+"月", wff2);
			            sheet.addCell(label);
						break;
					case 2:
						switch(Integer.parseInt(Quarter))
						{
							case 1:
								label = new Label(0, D_Index, Year+"年第一季度", wff2);
					            sheet.addCell(label);
								break;
							case 2:
								label = new Label(0, D_Index, Year+"年第二季度", wff2);
					            sheet.addCell(label);
								break;
							case 3:
								label = new Label(0, D_Index, Year+"年第三季度", wff2);
					            sheet.addCell(label);
								break;
							case 4:
								label = new Label(0, D_Index, Year+"年第四季度", wff2);
					            sheet.addCell(label);
								break;
						}
						break;
					case 3:
						label = new Label(0, D_Index, Year+"年", wff2);
			            sheet.addCell(label);
						break;
				}
	            label = new Label(1, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,3,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "序号", wff3);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "场站名称", wff3);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "设备名称", wff3);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "故障次数", wff3);
	            sheet.addCell(label);
	            
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					FixLedgerBean Bean = (FixLedgerBean)iterator.next();
					String D_Cpm_Id   = Bean.getCpm_Id();
					String D_Cpm_Name = Bean.getCpm_Name();
					String D_Dev_Name = Bean.getDev_Name();
					String D_Fix_Cnt  = Bean.getFix_Cnt();
					
					if(2 == D_Index)
					{
						D_Cpm_Chg = D_Cpm_Id;
					}
					
					if(!D_Cpm_Chg.equals(D_Cpm_Id))
					{
						//纵向合并
						sheet.mergeCells(1,(D_Index-Chg_cnt+1),1,D_Index);
						
						Chg_cnt = 1;
						D_Cpm_Chg = D_Cpm_Id;
					}
					else
					{
						Chg_cnt++;
					}
					
					D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, (D_Index-2)+"", wff4);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, D_Cpm_Name, wff4);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, D_Dev_Name, wff4);
		            sheet.addCell(label);
		            label = new Label(3, D_Index, D_Fix_Cnt, wff4);
		            sheet.addCell(label);
				}
	            
				//纵向合并
				sheet.mergeCells(1,(D_Index-Chg_cnt+1),1,D_Index);
				
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
				Sql = " select t.dev_sn, t.cpm_id, t.cpm_name, t.dev_type, t.dev_name, '' as ctime, sum(t.fix_cnt) as fix_cnt " +
					  " from view_fix_ledger t " +
					  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
					  "   and t.dev_type like '"+ Func_Corp_Id +"%'" +
					  "   and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"' " +
					  "   and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"' " +
					  "   group by t.dev_sn, t.cpm_id, t.cpm_name, t.dev_type, t.dev_name " + 
					  "   order by t.cpm_id, t.dev_type asc ";
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs)
	{
		boolean IsOK = true;
		try
		{
			setDev_SN(pRs.getString(1));
			setCpm_Id(pRs.getString(2));
			setCpm_Name(pRs.getString(3));
			setDev_Type(pRs.getString(4));
			setDev_Name(pRs.getString(5));
			setCTime(pRs.getString(6));
			setFix_Cnt(pRs.getString(7));
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
			setDev_SN(CommUtil.StrToGB2312(request.getParameter("Dev_SN")));
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setCpm_Name(CommUtil.StrToGB2312(request.getParameter("Cpm_Name")));			
			setDev_Type(CommUtil.StrToGB2312(request.getParameter("Dev_Type")));
			setDev_Name(CommUtil.StrToGB2312(request.getParameter("Dev_Name")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setFix_Cnt(CommUtil.StrToGB2312(request.getParameter("Fix_Cnt")));
			
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
			setYear(CommUtil.StrToGB2312(request.getParameter("Year")));
			setMonth(CommUtil.StrToGB2312(request.getParameter("Month")));
			setQuarter(CommUtil.StrToGB2312(request.getParameter("Quarter")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String Dev_SN;
	private String Cpm_Id;
	private String Cpm_Name;
	private String Dev_Type;
	private String Dev_Name;
	private String CTime;
	private String Fix_Cnt;
	
	private String Sid;
	private String Func_Corp_Id;
	private String Year;
	private String Month;
	private String Quarter;
	
	public String getDev_SN() {
		return Dev_SN;
	}

	public void setDev_SN(String devSN) {
		Dev_SN = devSN;
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

	public String getDev_Type() {
		return Dev_Type;
	}

	public void setDev_Type(String devType) {
		Dev_Type = devType;
	}

	public String getDev_Name() {
		return Dev_Name;
	}

	public void setDev_Name(String devName) {
		Dev_Name = devName;
	}

	public String getCTime() {
		return CTime;
	}

	public void setCTime(String cTime) {
		CTime = cTime;
	}

	public String getFix_Cnt() {
		return Fix_Cnt;
	}

	public void setFix_Cnt(String fixCnt) {
		Fix_Cnt = fixCnt;
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

	public String getQuarter() {
		return Quarter;
	}

	public void setQuarter(String quarter) {
		Quarter = quarter;
	}
}