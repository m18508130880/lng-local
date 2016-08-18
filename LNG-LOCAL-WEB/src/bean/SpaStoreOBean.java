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

public class SpaStoreOBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SPA_STORE_O;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SpaStoreOBean()
	{
		super.className = "SpaStoreOBean";
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
		
		//类别
		Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
				
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if(null == Func_Type_Id || Func_Type_Id.equals("888"))
		{
			Func_Type_Id = "";
		}
		
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
			case 11://作废
			case 10://添加
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			case 0://查询
		    	request.getSession().setAttribute("Spa_Store_O_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Spa_Store_O.jsp?Sid=" + Sid);
		    	
		    	msgBean = pRmi.RmiExec(1, this, 0);
		    	request.getSession().setAttribute("Spa_Store_Cpm_" + Sid, (Object)msgBean.getMsg());
		    	
		    	msgBean = pRmi.RmiExec(2, this, 0);
		    	request.getSession().setAttribute("Spa_Store_Type_" + Sid, (Object)msgBean.getMsg());
		    	
		    	msgBean = pRmi.RmiExec(3, this, 0);
		    	request.getSession().setAttribute("Spa_Store_Mode_" + Sid, (Object)msgBean.getMsg());
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
			
			//类别
			Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
			if(Func_Sub_Id.equals("9"))
			{
				Func_Sub_Id = "";
			}
			
			//状态
			Func_Sel_Id = currStatus.getFunc_Sel_Id()+"";
			if(Func_Sel_Id.equals("9"))
			{
				Func_Sel_Id = "";
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
	            label = new Label(0, 0, "备品备件出库记录", wff);
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
	            label  = new Label(1, 1, "备品备件", wff2);
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
					//SpaStoreOBean Bean = (SpaStoreOBean)iterator.next();

					//String D_Spa_Mode      = Bean.getSpa_Mode();
					/**String D_Model         = Bean.getModel();
					String D_Spa_Mode_Name = "/";
					if(null != D_Model && D_Model.length() > 0)
					{
						String[] List = D_Model.split(",");
						if(List.length >= Integer.parseInt(D_Spa_Mode))
							D_Spa_Mode_Name = List[Integer.parseInt(D_Spa_Mode)-1];
					}
					**/
					
					
					
					//String str_Status = "";
					
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-1)+"", wff3);
		            sheet.addCell(label);
		           /** label = new Label(1,i,D_Spa_Type_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2,i,D_Spa_Mode_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(3,i,D_Spa_O_Time, wff3);
		            sheet.addCell(label);
		            label = new Label(4,i,D_Spa_O_Stat_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(5,i,D_Spa_O_BCnt, wff3);
		            sheet.addCell(label);
		            label = new Label(6,i,D_Spa_O_MCnt, wff3);
		            sheet.addCell(label);
		            label = new Label(7,i,D_Spa_O_ACnt, wff3);
		            sheet.addCell(label);
		            label = new Label(8,i,D_Spa_O_Man, wff3);
		            sheet.addCell(label);		
		            label = new Label(9,i,D_Spa_O_Memo, wff3);
		            sheet.addCell(label);	            
		            label = new Label(10,i,str_Status, wff3);
		            sheet.addCell(label);
		            label = new Label(11,i,D_Operator_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(12,i,D_Status_OP_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(13,i,D_Status_Memo, wff3);**/
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
	//出库批量导入
	public void DaoSpaOFile(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone, ServletConfig pConfig) 
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
				    for(int i=3; i<rsRows; i++)
				    {
				    	if(null==rs.getCell(1, i).getContents().trim()||"".equals(rs.getCell(1, i).getContents().trim()))
				    	{
				    
				    		break;//当excel文档第一行为空时，退出循环
				    		}
				    	Spa_Type    = rs.getCell(1, i).getContents().trim();	//备件名称				    	
				    	Spa_Mode    = rs.getCell(2, i).getContents().trim();	//规格型号	 
				    	Unit        = rs.getCell(3, i).getContents().trim();
				    	if(null==rs.getCell(4, i).getContents().trim()||"".equals(rs.getCell(4, i).getContents().trim()))
				    	{Spa_Num = "0";}else{Spa_Num     = rs.getCell(4, i).getContents().trim();}				    	
				    	Spa_Price   = rs.getCell(5, i).getContents().trim();
				    	Spa_Amt     = rs.getCell(6, i).getContents().trim();	
				    	CTime       = rs.getCell(7, i).getContents().trim();
				    	Cpm_Id      = rs.getCell(8, i).getContents().trim();
				    	if(null==rs.getCell(9, i).getContents().trim()||"".equals(rs.getCell(9, i).getContents().trim()))
				    	{Spa_O_Oper = "无";}else{Spa_O_Oper  = rs.getCell(9, i).getContents().trim();}
				    	if(null==rs.getCell(10, i).getContents().trim()||"".equals(rs.getCell(10, i).getContents().trim()))
				    	{Operator = "无";}else{Operator    = rs.getCell(10, i).getContents().trim();}
				    	if(null==rs.getCell(11, i).getContents().trim()||"".equals(rs.getCell(11, i).getContents().trim()))
				    	{Spa_Memo = "无备注";}else{Spa_Memo    = rs.getCell(11, i).getContents().trim();}					    	
				    	msgBean = pRmi.RmiExec(10, this, 0);
				    	if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
						{
				    		succCnt ++;
						}
				    }	
				    currStatus.setResult("成功导入[" + String.valueOf(succCnt) + "/" + String.valueOf(rsRows-3) + "]个");
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
			
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id || Func_Type_Id.equals("888"))
			{
				Func_Type_Id = "";
			}
			
			msgBean = pRmi.RmiExec(0, this, 0);			
			request.getSession().setAttribute("Spa_Store_O_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
	    	currStatus.setJsp("Spa_Store_O.jsp?Sid=" + Sid);					
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
				Sql = "select t.sn,t.spa_type,spa_mode,t.unit,t.spa_num,t.spa_price,t.spa_amt,t.ctime,t.spa_memo,t.cpm_id, t.spa_o_oper, t.operator " +
			  	  	  " from spa_store_o t " +
			  	  	  " where t.cpm_id like '"+ Cpm_Id +"%' " +
			  	  	  " and t.spa_type like '"+ Func_Corp_Id +"%' " +
			  	  	  " and t.spa_mode like '"+ Func_Type_Id +"%'" +
			  	  	  " and t.ctime >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
			  	  	  " and t.ctime <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
			  	  	  " order by t.ctime desc ";
				break;
				
			case 1://去向站点
				Sql = "select t.sn,t.spa_type,spa_mode,t.unit,t.spa_num,t.spa_price,t.spa_amt,t.ctime,t.spa_memo,t.cpm_id, t.spa_o_oper, t.operator " +
				  	  " from spa_store_o t " +
				  	  " group by t.cpm_id "+
				  	  "ORDER BY t.cpm_id";
				break;
			case 2://备品查询
				Sql = "select t.sn,t.spa_type,spa_mode,t.unit,t.spa_num,t.spa_price,t.spa_amt,t.ctime,t.spa_memo,t.cpm_id, t.spa_o_oper, t.operator " +
					  " from spa_store_o t " +
					  " group by t.spa_type ";
				break;		
			case 3://类型查询
				Sql = "select t.sn,t.spa_type,spa_mode,t.unit,t.spa_num,t.spa_price,t.spa_amt,t.ctime,t.spa_memo,t.cpm_id, t.spa_o_oper, t.operator " +
					  " from spa_store_o t " +
					  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
					  " group by t.spa_mode ";				
				break;
			case 4://合计站点领用量
				Sql = "select t.sn,t.spa_type,spa_mode,t.unit,sum(t.spa_num),t.spa_price,t.spa_amt,t.ctime,t.spa_memo,t.cpm_id, t.spa_o_oper, t.operator " +
					  " from spa_store_o t " +						
					  " group by t.spa_type,t.spa_mode,t.cpm_id "+
					  "ORDER BY t.cpm_id,t.spa_type,t.spa_memo ";
				break;
				
			case 5 ://报表合计各站用量
				Sql = " select t.sn,t.spa_type,spa_mode,t.unit,sum(t.spa_num),t.spa_price,t.spa_amt,t.ctime,t.spa_memo,t.cpm_id, t.spa_o_oper, t.operator " +
					  " from spa_store_o t " +		
					  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
			  	  	  " and t.spa_mode like '"+ Func_Type_Id +"%'" +
					  " and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"'" +
					  " and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"' " +
					  " group by t.spa_type,t.spa_mode,t.cpm_id "+
					  " ORDER BY t.cpm_id,t.spa_type,t.spa_memo ";				
				break;				
			case 10://添加
				Sql = " insert into spa_store_o(spa_type, spa_mode, unit, spa_num, spa_price, spa_amt, ctime, spa_memo, cpm_id, spa_o_oper, operator)" +
					  " values('"+ Spa_Type +"', '"+ Spa_Mode +"', '"+ Unit +"', '"+ Spa_Num +"', '"+ Spa_Price +"', '"+ Spa_Amt +"', '"+ CTime +"' , '"+ Spa_Memo +"', '"+ Cpm_Id +"', '"+ Spa_O_Oper +"', '"+ Operator +"')";
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
			setSpa_Type(pRs.getString(2));			
			setSpa_Mode(pRs.getString(3));		
			setUnit(pRs.getString(4));
			setSpa_Num(pRs.getString(5));
			setSpa_Price(pRs.getString(6));
			setSpa_Amt(pRs.getString(7));
			setCTime(pRs.getString(8));
			setSpa_Memo(pRs.getString(9));
			setCpm_Id(pRs.getString(10));
			setSpa_O_Oper(pRs.getString(11));
			setOperator(pRs.getString(12));
		
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
			setSpa_Type(CommUtil.StrToGB2312(request.getParameter("Spa_Type")));
			setSpa_Mode(CommUtil.StrToGB2312(request.getParameter("Spa_Mode")));		
			setUnit(CommUtil.StrToGB2312(request.getParameter("Unit")));
			setSpa_Num(CommUtil.StrToGB2312(request.getParameter("Spa_Num")));
			setSpa_Price(CommUtil.StrToGB2312(request.getParameter("Spa_Price")));
			setSpa_Amt(CommUtil.StrToGB2312(request.getParameter("Spa_Amt")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));	
			setSpa_Memo(CommUtil.StrToGB2312(request.getParameter("Spa_Memo")));
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setSpa_O_Oper(CommUtil.StrToGB2312(request.getParameter("Spa_O_Oper")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Spa_Type;
	private String Spa_Mode;
	private String Unit;
	private String Spa_Num;
	private String Spa_Price;
	private String Spa_Amt;
	private String CTime;	
	private String Spa_Memo;
	private String Cpm_Id;
	private String Spa_O_Oper;
	private String Operator;
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sub_Id;
	private String Func_Sel_Id;
	private String Func_Type_Id;
	private String Func_Cpm_Id;
	
	public String getFunc_Cpm_Id() {
		return Func_Cpm_Id;
	}

	public void setFunc_Cpm_Id(String func_Cpm_Id) {
		Func_Cpm_Id = func_Cpm_Id;
	}

	public String getSpa_O_Oper() {
		return Spa_O_Oper;
	}

	public void setSpa_O_Oper(String spa_O_Oper) {
		Spa_O_Oper = spa_O_Oper;
	}

	public String getOperator() {
		return Operator;
	}

	public void setOperator(String operator) {
		Operator = operator;
	}

	public String getSpa_Num() {
		return Spa_Num;
	}

	public void setSpa_Num(String spa_Num) {
		Spa_Num = spa_Num;
	}

	public String getSpa_Price() {
		return Spa_Price;
	}

	public void setSpa_Price(String spa_Price) {
		Spa_Price = spa_Price;
	}

	public String getSpa_Amt() {
		return Spa_Amt;
	}

	public void setSpa_Amt(String spa_Amt) {
		Spa_Amt = spa_Amt;
	}

	public String getSpa_Memo() {
		return Spa_Memo;
	}

	public void setSpa_Memo(String spa_Memo) {
		Spa_Memo = spa_Memo;
	}

	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String func_Type_Id) {
		Func_Type_Id = func_Type_Id;
	}
	
	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
	}

	public String getSpa_Type() {
		return Spa_Type;
	}

	public void setSpa_Type(String spaType) {
		Spa_Type = spaType;
	}



	public String getSpa_Mode() {
		return Spa_Mode;
	}

	public void setSpa_Mode(String spaMode) {
		Spa_Mode = spaMode;
	}

	

	public String getUnit() {
		return Unit;
	}

	public void setUnit(String unit) {
		Unit = unit;
	}

	



	

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

	public String getFunc_Sel_Id() {
		return Func_Sel_Id;
	}

	public void setFunc_Sel_Id(String funcSelId) {
		Func_Sel_Id = funcSelId;
	}
}