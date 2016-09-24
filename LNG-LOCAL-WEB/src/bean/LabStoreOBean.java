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

public class LabStoreOBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_LAB_STORE_O;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public LabStoreOBean()
	{
		super.className = "LabStoreOBean";
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
			case 11://作废
			case 10://添加
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			case 0://查询
		    	request.getSession().setAttribute("Lab_Store_O_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Lab_Store_O.jsp?Sid=" + Sid);
		    	
		    	//库存台账
		    	LabStoreBean Store = new LabStoreBean();
		    	Store.setFunc_Corp_Id("");
		    	msgBean = pRmi.RmiExec(0, Store, 0);
				request.getSession().setAttribute("Lab_Store_" + Sid, (Object)msgBean.getMsg());
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
	            Label label = null;
	            label = new Label(0, 0, "劳保用品出库记录", wff);
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
	            sheet.mergeCells(0,0,13,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "序号", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "产品名称", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "规格型号", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "出库日期", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 1, "去向场站", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 1, "出前数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 1, "出库数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 1, "出后数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(8, 1, "领用人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 1, "出库备注", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 1, "记录状态", wff2);
	            sheet.addCell(label);
	            label  = new Label(11, 1, "录入人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 1, "作废人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(13, 1, "作废原因", wff2);
	            sheet.addCell(label);
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 1;
				while(iterator.hasNext())
				{
					i++;
					LabStoreOBean Bean = (LabStoreOBean)iterator.next();
					String D_Lab_Type_Name = Bean.getLab_Type_Name();
					String D_Lab_Mode      = Bean.getLab_Mode();
					String D_Model         = Bean.getModel();
					String D_Lab_O_Time    = Bean.getLab_O_Time();
					String D_Lab_Mode_Name = "/";
					if(null != D_Model && D_Model.length() > 0)
					{
						String[] List = D_Model.split(",");
						if(List.length >= Integer.parseInt(D_Lab_Mode))
							D_Lab_Mode_Name = List[Integer.parseInt(D_Lab_Mode)-1];
					}
					
					String D_Lab_O_Stat_Name = Bean.getLab_O_Stat_Name();
					String D_Lab_O_BCnt      = Bean.getLab_O_BCnt();
					String D_Lab_O_MCnt      = Bean.getLab_O_MCnt();
					String D_Lab_O_ACnt      = Bean.getLab_O_ACnt();
					String D_Lab_O_Man       = Bean.getLab_O_Man();
					String D_Lab_O_Memo      = Bean.getLab_O_Memo();
					
					String D_Operator_Name = Bean.getOperator_Name();
					String D_Status_OP_Name= Bean.getStatus_OP_Name();
					String D_Status_Memo   = Bean.getStatus_Memo();
					if(null == D_Status_OP_Name){D_Status_OP_Name = "";}
					if(null == D_Status_Memo){D_Status_Memo = "";}
					
					String str_Status = "";
					switch(Integer.parseInt(Bean.getStatus()))
					{
						case 1:
							str_Status = "有效";
							break;
						case 2:
							str_Status = "无效";
							break;
					}
									
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-1)+"", wff3);
		            sheet.addCell(label);
		            label = new Label(1,i,D_Lab_Type_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2,i,D_Lab_Mode_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(3,i,D_Lab_O_Time, wff3);
		            sheet.addCell(label);
		            label = new Label(4,i,D_Lab_O_Stat_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(5,i,D_Lab_O_BCnt, wff3);
		            sheet.addCell(label);
		            label = new Label(6,i,D_Lab_O_MCnt, wff3);
		            sheet.addCell(label);
		            label = new Label(7,i,D_Lab_O_ACnt, wff3);
		            sheet.addCell(label);
		            label = new Label(8,i,D_Lab_O_Man, wff3);
		            sheet.addCell(label);		
		            label = new Label(9,i,D_Lab_O_Memo, wff3);
		            sheet.addCell(label);	            
		            label = new Label(10,i,str_Status, wff3);
		            sheet.addCell(label);
		            label = new Label(11,i,D_Operator_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(12,i,D_Status_OP_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(13,i,D_Status_Memo, wff3);
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
	
	//审核
	public void doStatus(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		Resp = ((String)msgBean.getMsg());
    	
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		outprint.write(Resp);
	}
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd)
		{
			case 0://查询
				Sql = " select t.sn, t.lab_type, t.lab_type_name, t.lab_mode, t.model, t.unit, t.lab_o_time, t.lab_o_stat, t.lab_o_stat_name, t.lab_o_bcnt, t.lab_o_mcnt, t.lab_o_acnt, " +
		  	  	  	  " t.lab_o_man, t.lab_o_memo, t.ctime, t.operator, t.operator_name, t.status, t.status_op, t.status_op_name, t.status_memo " +
		  	  	  	  " from view_lab_store_o t " +
		  	  	  	  " where instr('"+ Cpm_Id +"', t.lab_o_stat) > 0 " +
			  	  	  "   and t.lab_type like '"+ Func_Corp_Id +"%' " +
			  	  	  "   and t.status like '"+ Func_Sub_Id +"%'" +
			  	  	  "   and t.lab_o_time >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
			  	  	  "   and t.lab_o_time <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
			  	  	  "   order by t.lab_o_time desc ";
				break;
			case 10://添加
				Sql = " insert into lab_store_o(lab_type, lab_mode, lab_o_time, lab_o_stat, lab_o_bcnt, lab_o_mcnt, lab_o_acnt, lab_o_man, lab_o_memo, ctime, operator)" +
					  " values('"+ Lab_Type +"', '"+ Lab_Mode +"', '"+ Lab_O_Time +"', '"+ Lab_O_Stat +"', '"+ Lab_O_BCnt +"', '"+ Lab_O_MCnt +"', '"+ Lab_O_ACnt +"', '"+ Lab_O_Man +"', '"+ Lab_O_Memo +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"')";
				break;
			case 11://作废
				Sql = " update lab_store_o t set t.status = '"+ Status +"', t.status_op = '"+ Status_OP +"', t.status_memo = '"+ Status_Memo +"' where t.sn = '"+ SN +"' ";
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
			setLab_Type(pRs.getString(2));
			setLab_Type_Name(pRs.getString(3));
			setLab_Mode(pRs.getString(4));
			setModel(pRs.getString(5));
			setUnit(pRs.getString(6));
			setLab_O_Time(pRs.getString(7));
			setLab_O_Stat(pRs.getString(8));
			setLab_O_Stat_Name(pRs.getString(9));
			setLab_O_BCnt(pRs.getString(10));
			setLab_O_MCnt(pRs.getString(11));
			setLab_O_ACnt(pRs.getString(12));
			setLab_O_Man(pRs.getString(13));
			setLab_O_Memo(pRs.getString(14));
			setCTime(pRs.getString(15));
			setOperator(pRs.getString(16));
			setOperator_Name(pRs.getString(17));
			setStatus(pRs.getString(18));
			setStatus_OP(pRs.getString(19));
			setStatus_OP_Name(pRs.getString(20));
			setStatus_Memo(pRs.getString(21));
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
			setLab_Type(CommUtil.StrToGB2312(request.getParameter("Lab_Type")));
			setLab_Type_Name(CommUtil.StrToGB2312(request.getParameter("Lab_Type_Name")));
			setLab_Mode(CommUtil.StrToGB2312(request.getParameter("Lab_Mode")));
			setModel(CommUtil.StrToGB2312(request.getParameter("Model")));
			setUnit(CommUtil.StrToGB2312(request.getParameter("Unit")));
			setLab_O_Time(CommUtil.StrToGB2312(request.getParameter("Lab_O_Time")));
			setLab_O_Stat(CommUtil.StrToGB2312(request.getParameter("Lab_O_Stat")));
			setLab_O_Stat_Name(CommUtil.StrToGB2312(request.getParameter("Lab_O_Stat_Name")));
			setLab_O_BCnt(CommUtil.StrToGB2312(request.getParameter("Lab_O_BCnt")));
			setLab_O_MCnt(CommUtil.StrToGB2312(request.getParameter("Lab_O_MCnt")));
			setLab_O_ACnt(CommUtil.StrToGB2312(request.getParameter("Lab_O_ACnt")));
			setLab_O_Man(CommUtil.StrToGB2312(request.getParameter("Lab_O_Man")));
			setLab_O_Memo(CommUtil.StrToGB2312(request.getParameter("Lab_O_Memo")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
			setStatus(CommUtil.StrToGB2312(request.getParameter("Status")));
			setStatus_OP(CommUtil.StrToGB2312(request.getParameter("Status_OP")));
			setStatus_OP_Name(CommUtil.StrToGB2312(request.getParameter("Status_OP_Name")));
			setStatus_Memo(CommUtil.StrToGB2312(request.getParameter("Status_Memo")));
			
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Lab_Type;
	private String Lab_Type_Name;
	private String Lab_Mode;
	private String Model;
	private String Unit;
	private String Lab_O_Time;
	private String Lab_O_Stat;
	private String Lab_O_Stat_Name;
	private String Lab_O_BCnt;
	private String Lab_O_MCnt;
	private String Lab_O_ACnt;
	private String Lab_O_Man;
	private String Lab_O_Memo;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	private String Status;
	private String Status_OP;
	private String Status_OP_Name;
	private String Status_Memo;
	
	private String Cpm_Id;
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sub_Id;
	
	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
	}

	public String getLab_Type() {
		return Lab_Type;
	}

	public void setLab_Type(String labType) {
		Lab_Type = labType;
	}

	public String getLab_Type_Name() {
		return Lab_Type_Name;
	}

	public void setLab_Type_Name(String labTypeName) {
		Lab_Type_Name = labTypeName;
	}

	public String getLab_Mode() {
		return Lab_Mode;
	}

	public void setLab_Mode(String labMode) {
		Lab_Mode = labMode;
	}

	public String getModel() {
		return Model;
	}

	public void setModel(String model) {
		Model = model;
	}

	public String getUnit() {
		return Unit;
	}

	public void setUnit(String unit) {
		Unit = unit;
	}

	public String getLab_O_Time() {
		return Lab_O_Time;
	}

	public void setLab_O_Time(String labOTime) {
		Lab_O_Time = labOTime;
	}

	public String getLab_O_Stat() {
		return Lab_O_Stat;
	}

	public void setLab_O_Stat(String labOStat) {
		Lab_O_Stat = labOStat;
	}

	public String getLab_O_Stat_Name() {
		return Lab_O_Stat_Name;
	}

	public void setLab_O_Stat_Name(String labOStatName) {
		Lab_O_Stat_Name = labOStatName;
	}

	public String getLab_O_BCnt() {
		return Lab_O_BCnt;
	}

	public void setLab_O_BCnt(String labOBCnt) {
		Lab_O_BCnt = labOBCnt;
	}

	public String getLab_O_MCnt() {
		return Lab_O_MCnt;
	}

	public void setLab_O_MCnt(String labOMCnt) {
		Lab_O_MCnt = labOMCnt;
	}

	public String getLab_O_ACnt() {
		return Lab_O_ACnt;
	}

	public void setLab_O_ACnt(String labOACnt) {
		Lab_O_ACnt = labOACnt;
	}

	public String getLab_O_Man() {
		return Lab_O_Man;
	}

	public void setLab_O_Man(String labOMan) {
		Lab_O_Man = labOMan;
	}

	public String getLab_O_Memo() {
		return Lab_O_Memo;
	}

	public void setLab_O_Memo(String labOMemo) {
		Lab_O_Memo = labOMemo;
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

	public String getStatus_OP() {
		return Status_OP;
	}

	public void setStatus_OP(String statusOP) {
		Status_OP = statusOP;
	}

	public String getStatus_OP_Name() {
		return Status_OP_Name;
	}

	public void setStatus_OP_Name(String statusOPName) {
		Status_OP_Name = statusOPName;
	}

	public String getStatus_Memo() {
		return Status_Memo;
	}

	public void setStatus_Memo(String statusMemo) {
		Status_Memo = statusMemo;
	}

	public String getCpm_Id() {
		return Cpm_Id;
	}

	public void setCpm_Id(String cpmId) {
		Cpm_Id = cpmId;
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