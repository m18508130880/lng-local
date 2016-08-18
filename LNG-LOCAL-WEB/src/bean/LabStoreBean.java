package bean;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
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

import jxl.Sheet;
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

public class LabStoreBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_LAB_STORE;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public LabStoreBean()
	{
		super.className = "LabStoreBean"; 
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
			case 11://阀值
			case 10://添加
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, 0);
			case 0://查询
		    	request.getSession().setAttribute("Lab_Store_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Lab_Store.jsp?Sid=" + Sid);
		    			    	
		    	//用品类型		    
		    	msgBean = pRmi.RmiExec(1, this, 0);
		    	request.getSession().setAttribute("Lab_Store_Type_" + Sid, ((Object)msgBean.getMsg()));
		    	
		    	LabStoreOBean oBean = new LabStoreOBean();
		    	msgBean = pRmi.RmiExec(1, oBean, 0);//查询领用站点
		    	request.getSession().setAttribute("Lab_O_Cpm_" + Sid, ((Object)msgBean.getMsg()));
		    	msgBean = pRmi.RmiExec(4, oBean, 0);//查询领用站点合计领用量
		    	request.getSession().setAttribute("Lab_O_ALL_" + Sid, ((Object)msgBean.getMsg()));
		    	break;
		    	
			case 1://统计报表		
				//用品类型
				request.getSession().setAttribute("Lab_Store_LType_" + Sid, ((Object)msgBean.getMsg()));		
				//台账信息
				msgBean = pRmi.RmiExec(2, this, 0);
				request.getSession().setAttribute("Lab_Store_L_" + Sid, ((Object)msgBean.getMsg()));
				
				//出库信息
				LabStoreOBean obean = new LabStoreOBean();
				obean.setFunc_Corp_Id(Func_Corp_Id);
				obean.setFunc_Type_Id(Func_Type_Id);
				obean.currStatus = currStatus;
				msgBean = pRmi.RmiExec(1, obean, 0);//站点
				request.getSession().setAttribute("Lab_Store_Cpm_" + Sid, ((Object)msgBean.getMsg()));
				msgBean = pRmi.RmiExec(3, obean, 0);//信息
				request.getSession().setAttribute("Lab_Store_LO_" + Sid, ((Object)msgBean.getMsg()));
				currStatus.setJsp("Lab_TJ.jsp?Sid=" + Sid);
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
				
				//字体格式4
				WritableFont wf4 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff4 = new WritableCellFormat(wf4);
				wf4.setColour(Colour.BLACK);//字体颜色
				wff4.setAlignment(Alignment.CENTRE);//设置居中
				wff4.setBorder(Border.ALL, BorderLineStyle.THIN);//设置边框线
				wff4.setBackground(jxl.format.Colour.RED);//设置单元格的背景颜色
				
				sheet.setRowView(0, 600);
	            sheet.setColumnView(0, 20);
	            Label label = new Label(0, 0, "劳保用品库存台账", wff);
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
	            sheet.mergeCells(0,0,10,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "序号", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "用品名称", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "规格型号", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "在库数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 1, "出库数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 1, "报废数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 1, "保底存量", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 1, "单位", wff2);
	            sheet.addCell(label);
	            label  = new Label(8, 1, "品牌信息", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 1, "供货单位", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 1, "录入人员", wff2);
	            sheet.addCell(label);
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
	            String D_Lab_Chg = "";
	            int D_cnt = 0;
				int i = 1;
				while(iterator.hasNext())
				{
					i++;
					LabStoreBean Bean = (LabStoreBean)iterator.next();
					String D_Lab_Type = Bean.getLab_Type();
					String D_Lab_Type_Name = Bean.getLab_Type_Name();
					String D_Lab_Mode = Bean.getLab_Mode();
					String D_Model = Bean.getModel();
					String D_Unit = Bean.getUnit();
					String D_Lab_I_Cnt = Bean.getLab_I_Cnt();
					String D_Lab_O_Cnt = Bean.getLab_O_Cnt();
					String D_Lab_S_Cnt = Bean.getLab_S_Cnt();
					String D_Lab_A_Cnt = Bean.getLab_A_Cnt();
					String D_Brand = Bean.getBrand();
					String D_Seller = Bean.getSeller();
					String D_Operator_Name = Bean.getOperator_Name();
					
					String D_Lab_Mode_Name = "/";
					if(null != D_Model && D_Model.length() > 0)
					{
						String[] List = D_Model.split(",");
						if(List.length >= Integer.parseInt(D_Lab_Mode))
							D_Lab_Mode_Name = List[Integer.parseInt(D_Lab_Mode)-1];
					}
					
					if(2 == i)
					{
						D_Lab_Chg = D_Lab_Type;
					}
					
					if(!D_Lab_Chg.equals(D_Lab_Type))
					{
						//纵向合并
						sheet.mergeCells(1,(i-D_cnt),1,(i-1));
						sheet.mergeCells(7,(i-D_cnt),7,(i-1));
						sheet.mergeCells(8,(i-D_cnt),8,(i-1));
						sheet.mergeCells(9,(i-D_cnt),9,(i-1));
						
						D_cnt = 1;
						D_Lab_Chg = D_Lab_Type;
					}
					else
					{
						D_cnt++;
					}
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-1)+"", wff3);
		            sheet.addCell(label);
		            label = new Label(1,i,D_Lab_Type_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2,i,D_Lab_Mode_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(3,i,D_Lab_I_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(4,i,D_Lab_O_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(5,i,D_Lab_S_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(6,i,D_Lab_A_Cnt, (Integer.parseInt(D_Lab_I_Cnt)-Integer.parseInt(D_Lab_A_Cnt))<0?wff4:wff3);
		            sheet.addCell(label);
		            label = new Label(7,i,D_Unit, wff3);
		            sheet.addCell(label);
		            label = new Label(8,i,D_Brand, wff3);
		            sheet.addCell(label);
		            label = new Label(9,i,D_Seller, wff3);
		            sheet.addCell(label);
		            label = new Label(10,i,D_Operator_Name, wff3);
		            sheet.addCell(label);
				}
				
				//纵向合并
				sheet.mergeCells(1,(i-D_cnt+1),1,i);
				sheet.mergeCells(7,(i-D_cnt+1),7,i);
				sheet.mergeCells(8,(i-D_cnt+1),8,i);
				sheet.mergeCells(9,(i-D_cnt+1),9,i);
				
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
	
	//报废
	public void doScrape(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
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
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		Resp = ((String)msgBean.getMsg());
    	if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
    	{
    		//重新查询
			msgBean = pRmi.RmiExec(0, this, 0);
	    	request.getSession().setAttribute("Lab_Store_" + Sid, ((Object)msgBean.getMsg()));
    	}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		outprint.write(Resp);
	}
	//库存台账批量导入
	public void DaoLabFile(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone, ServletConfig pConfig) 
	{
		try
		{			
			SmartUpload mySmartUpload = new SmartUpload();
			mySmartUpload.initialize(pConfig, request, response);
			mySmartUpload.setAllowedFilesList("xls,xlsx,XLS,XLSX,");
			mySmartUpload.upload();
									
			Sid = mySmartUpload.getRequest().getParameter("Sid");
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);						
			System.out.println("Sid"+Sid+"[]"+"currStatus"+currStatus);
			if(mySmartUpload.getFiles().getCount() > 0 && mySmartUpload.getFiles().getFile(0).getFilePathName().trim().length() > 0)
			{
				if(mySmartUpload.getFiles().getFile(0).getSize()/1024 <= 3072)//最大3M
				{		
					String FileSaveRoute = "/www/LNG-LOCAL/LNG-LOCAL-WEB/files/upfiles/";										
					//上传现有文档			
					com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);		
					String File_Name = new SimpleDateFormat("yyyyMMdd").format(new Date()) + CommUtil.Randon()+ "." + myFile.getFileExt();			
					myFile.saveAs(FileSaveRoute + File_Name);						
					//录入数据库
					InputStream is = new FileInputStream(FileSaveRoute + File_Name);
					Workbook rwb = Workbook.getWorkbook(is);					
					Sheet rs = rwb.getSheet(0);					
				    int rsRows = rs.getRows();		
				    int succCnt = 0;	
				    for(int i=5; i<rsRows; i++)
				    {
				    	if(null==rs.getCell(1, i).getContents().trim()||"".equals(rs.getCell(1, i).getContents().trim()))
				    	{
				    
				    		break;//当excel文档第一行为空时，退出循环
				    		}
				    	Lab_Type    = rs.getCell(1, i).getContents().trim();	//备件名称				    	
				    	Lab_Mode    = rs.getCell(2, i).getContents().trim();	//规格型号	    				  
				    	Unit        = rs.getCell(3, i).getContents().trim();	//单位
				    	if(null==rs.getCell(4, i).getContents().trim()||"".equals(rs.getCell(4, i).getContents().trim()))
				    	{Lab_I_Cnt ="0";}else{Lab_I_Cnt   = rs.getCell(4, i).getContents().trim();}   //上期结存					    	
				    	if(null==rs.getCell(5, i).getContents().trim()||"".equals(rs.getCell(5, i).getContents().trim()))
				    	{Lab_A_Cnt = "0";}else{Lab_A_Cnt   = rs.getCell(5, i).getContents().trim();} //保底存量
				    	Lab_O_Cnt = "0";//进库数量
				    	Lab_S_Cnt = "0";//出库数量
				    	msgBean = pRmi.RmiExec(10, this, 0);
				    	if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
						{
				    		succCnt ++;
						}
				    }	
				    currStatus.setResult("成功导入[" + String.valueOf(succCnt) + "/" + String.valueOf(rsRows-5) + "]个");
				}
				else
				{
					currStatus.setResult("文档上传失败！文档过大，必须小于3M!");
				}				
			}
			
			Func_Corp_Id = currStatus.getFunc_Corp_Id();
			if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
			{
				Func_Corp_Id = "";
			}						
			msgBean = pRmi.RmiExec(0, this, 0);
			request.getSession().setAttribute("Lab_Store_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setJsp("Lab_Store.jsp?Sid=" + Sid);
	    		    	
	    	//用品类型
	    	msgBean = pRmi.RmiExec(1, this, 0);
	    	request.getSession().setAttribute("Lab_Store_Type_" + Sid, ((Object)msgBean.getMsg()));
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
				Sql = " select t.lab_type, t.lab_mode, t.lab_i_cnt, t.lab_o_cnt, t.lab_s_cnt, t.lab_a_cnt,  t.ctime , t.unit" +
					  " from (select a.lab_type, a.lab_mode, a.lab_i_cnt, a.lab_o_cnt, a.lab_s_cnt, a.lab_a_cnt,  a.ctime , a.unit from lab_store a  where a.lab_type like '"+ Func_Corp_Id +"%' order by a.ctime desc) as t " +					
					  " group by t.lab_type, t.lab_mode  ";
				break;
			case 1: //查询所有劳保用品
				Sql = " select t.lab_type, t.lab_mode, t.lab_i_cnt, t.lab_o_cnt, t.lab_s_cnt, t.lab_a_cnt,  t.ctime , t.unit" +
					  " from lab_store t"+
					  " group by t.lab_type";
				break;
			case 2://统计台账查询
				Sql = " select t.lab_type, t.lab_mode, t.lab_i_cnt, t.lab_o_cnt, t.lab_s_cnt, t.lab_a_cnt,  t.ctime , t.unit" +
					  " from (select a.lab_type, a.lab_mode, a.lab_i_cnt, a.lab_o_cnt, a.lab_s_cnt, a.lab_a_cnt,  a.ctime , a.unit " +
					  " from lab_store a  " +
					  " where a.lab_type like '"+ Func_Corp_Id +"%' " +
					  " and a.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"' " +
					  " and a.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"' " +
					  " order by a.ctime desc) as t " +					
					  " group by t.lab_type, t.lab_mode  ";
				break;
																				
			case 10://添加
				Sql = " insert into lab_store(lab_type, lab_mode, lab_i_cnt, lab_o_cnt, lab_s_cnt, lab_a_cnt, ctime ,unit)values('"+ Lab_Type +"', '"+ Lab_Mode +"', '"+ Lab_I_Cnt +"', '"+ Lab_O_Cnt +"', '"+ Lab_S_Cnt +"', '"+ Lab_A_Cnt +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Unit +"')";
				break;
			case 11://阀值
				Sql = " update lab_store t set t.lab_a_cnt = '"+ Lab_A_Cnt +"' where t.lab_type = '"+ Lab_Type +"' and t.lab_mode = '"+ Lab_Mode +"' ";
				break;
			case 20://报废
				Sql = " {? = call Func_Labour(1, '"+ Lab_Type +"', '"+ Lab_Mode +"', '"+ Lab_S_Cnt +"')}";
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs)
	{
		boolean IsOK = true;
		try
		{
			setLab_Type(pRs.getString(1));			
			setLab_Mode(pRs.getString(2));
			setLab_I_Cnt(pRs.getString(3));
			setLab_O_Cnt(pRs.getString(4));
			setLab_S_Cnt(pRs.getString(5));
			setLab_A_Cnt(pRs.getString(6));
			setCTime(pRs.getString(7));
			setUnit(pRs.getString(8));									
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
			setLab_Type(CommUtil.StrToGB2312(request.getParameter("Lab_Type")));
			setLab_Mode(CommUtil.StrToGB2312(request.getParameter("Lab_Mode")));
			setLab_I_Cnt(CommUtil.StrToGB2312(request.getParameter("Lab_I_Cnt")));
			setLab_O_Cnt(CommUtil.StrToGB2312(request.getParameter("Lab_O_Cnt")));
			setLab_S_Cnt(CommUtil.StrToGB2312(request.getParameter("Lab_S_Cnt")));
			setLab_A_Cnt(CommUtil.StrToGB2312(request.getParameter("Lab_A_Cnt")));
			setUnit(CommUtil.StrToGB2312(request.getParameter("Unit")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String Lab_Type;
	private String Lab_Type_Name;
	private String Lab_Mode;
	private String Lab_I_Cnt;
	private String Lab_O_Cnt;
	private String Lab_S_Cnt;
	private String Lab_A_Cnt;
	private String Model;
	private String Unit;
	private String Brand;
	private String Seller;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Type_Id;
	
	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String func_Type_Id) {
		Func_Type_Id = func_Type_Id;
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

	public String getLab_I_Cnt() {
		return Lab_I_Cnt;
	}

	public void setLab_I_Cnt(String labICnt) {
		Lab_I_Cnt = labICnt;
	}

	public String getLab_O_Cnt() {
		return Lab_O_Cnt;
	}

	public void setLab_O_Cnt(String labOCnt) {
		Lab_O_Cnt = labOCnt;
	}

	public String getLab_S_Cnt() {
		return Lab_S_Cnt;
	}

	public void setLab_S_Cnt(String labSCnt) {
		Lab_S_Cnt = labSCnt;
	}
	
	public String getLab_A_Cnt() {
		return Lab_A_Cnt;
	}

	public void setLab_A_Cnt(String labACnt) {
		Lab_A_Cnt = labACnt;
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

	public String getBrand() {
		return Brand;
	}

	public void setBrand(String brand) {
		Brand = brand;
	}

	public String getSeller() {
		return Seller;
	}

	public void setSeller(String seller) {
		Seller = seller;
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
}