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

public class SpaStoreIBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SPA_STORE_I;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SpaStoreIBean()
	{
		super.className = "SpaStoreIBean";
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
		
		//状态
		Func_Sel_Id = currStatus.getFunc_Sel_Id()+"";
		if(Func_Sel_Id.equals("9"))
		{
			Func_Sel_Id = "";
		}
		
		//申购单号
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if(null == Func_Type_Id)
		{
			Func_Type_Id = "";
		}
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
			case 13://一键审核
			case 12://审核
			case 11://修改
			case 10://添加
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			case 0://查询
		    	request.getSession().setAttribute("Spa_Store_I_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Spa_Store_I.jsp?Sid=" + Sid);
		    	
		    	//库存台账
		    	SpaStoreBean Store = new SpaStoreBean();
		    	Store.setFunc_Corp_Id("");
		    	Store.setFunc_Sub_Id("");
		    	msgBean = pRmi.RmiExec(0, Store, 0);
				request.getSession().setAttribute("Spa_Store_" + Sid, (Object)msgBean.getMsg());
		    	break;
			case 14://入库操作
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(1, this, currStatus.getCurrPage());
			case 1://入库查询
				request.getSession().setAttribute("Spa_Store_IN_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Spa_Store_IN.jsp?Sid=" + Sid);
		    	
		    	//库存台账
		    	SpaStoreBean Store2 = new SpaStoreBean();
		    	Store2.setFunc_Corp_Id("");
		    	Store2.setFunc_Sub_Id("");
		    	msgBean = pRmi.RmiExec(0, Store2, 0);
				request.getSession().setAttribute("Spa_Store_" + Sid, (Object)msgBean.getMsg());
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
			
			//申购单号
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id)
			{
				Func_Type_Id = "";
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
	            Label label = new Label(0, 0, "备品备件申购记录", wff);
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
	            sheet.mergeCells(0,0,12,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "序号", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "备品备件", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "规格型号", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "申购时间", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 1, "申购单号", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 1, "申购数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 1, "申购单价", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 1, "申购金额", wff2);
	            sheet.addCell(label);
	            label  = new Label(8, 1, "申购备注", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 1, "申购人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 1, "记录状态", wff2);
	            sheet.addCell(label);
	            label  = new Label(11, 1, "审核人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 1, "审核备注", wff2);
	            sheet.addCell(label);
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 1;
				while(iterator.hasNext())
				{
					i++;
					SpaStoreIBean Bean = (SpaStoreIBean)iterator.next();
					String D_Spa_Type_Name = Bean.getSpa_Type_Name();
					String D_Spa_Mode      = Bean.getSpa_Mode();
					String D_Model         = Bean.getModel();
					String D_Spa_I_Time    = Bean.getSpa_I_Time();
					String Spa_Mode_Name   = "/";
					if(null != D_Model && D_Model.length() > 0)
					{
						String[] List = D_Model.split(",");
						if(List.length >= Integer.parseInt(D_Spa_Mode))
							Spa_Mode_Name = List[Integer.parseInt(D_Spa_Mode)-1];
					}
					
					//申购信息
					String D_Spa_I_Numb    = Bean.getSpa_I_Numb();
					String D_Spa_I_Cnt     = Bean.getSpa_I_Cnt();
					String D_Spa_I_Price   = Bean.getSpa_I_Price();
					String D_Spa_I_Amt     = Bean.getSpa_I_Amt();
					String D_Spa_I_Memo    = Bean.getSpa_I_Memo(); 
					String D_Operator_Name = Bean.getOperator_Name();
					
					//审核信息
					String D_Status_OP_Name = Bean.getStatus_OP_Name();
					String D_Status_Memo    = Bean.getStatus_Memo();
					if(null == D_Status_OP_Name){D_Status_OP_Name = "";}
					if(null == D_Status_Memo){D_Status_Memo = "";}
					
					String str_Status = "";
					switch(Integer.parseInt(Bean.getStatus()))
					{
						case 0:
							str_Status = "未审核";
							break;
						case 1:
							str_Status = "审核有效";
							break;
						case 2:
							str_Status = "审核无效";
							break;
					}
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-1)+"", wff3);
		            sheet.addCell(label);
		            label = new Label(1,i,D_Spa_Type_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2,i,Spa_Mode_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(3,i,D_Spa_I_Time, wff3);
		            sheet.addCell(label);
		            label = new Label(4,i,D_Spa_I_Numb, wff3);
		            sheet.addCell(label);
		            label = new Label(5,i,D_Spa_I_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(6,i,D_Spa_I_Price, wff3);
		            sheet.addCell(label);
		            label = new Label(7,i,D_Spa_I_Amt, wff3);
		            sheet.addCell(label);
		            label = new Label(8,i,D_Spa_I_Memo, wff3);
		            sheet.addCell(label);
		            label = new Label(9,i,D_Operator_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(10,i,str_Status, wff3);
		            sheet.addCell(label);
		            label = new Label(11,i,D_Status_OP_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(12,i,D_Status_Memo, wff3);
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
	
	//明细导出
	public void IN_ExportToExcel(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
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
			
			//申购单号
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id)
			{
				Func_Type_Id = "";
			}
			
			//清除历史
			
			//生成当前
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			msgBean = pRmi.RmiExec(1, this, 0);
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
	            Label label = new Label(0, 0, "备品备件入库记录", wff);
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
	            label = new Label(15, 0, "");
	            sheet.addCell(label);
	            label = new Label(16, 0, "");
	            sheet.addCell(label);
	            label = new Label(17, 0, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,0,17,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "序号", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "备品备件", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "规格型号", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "申购时间", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 1, "申购单号", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 1, "申购数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 1, "申购单价", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 1, "申购金额", wff2);
	            sheet.addCell(label);
	            label  = new Label(8, 1, "申购备注", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 1, "申购人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 1, "记录状态", wff2);
	            sheet.addCell(label);
	            label  = new Label(11, 1, "审核人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 1, "审核备注", wff2);
	            sheet.addCell(label);
	            label  = new Label(13, 1, "入库状态", wff2);
	            sheet.addCell(label);
	            label  = new Label(14, 1, "交货单号", wff2);
	            sheet.addCell(label);
	            label  = new Label(15, 1, "交货数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(16, 1, "交货日期", wff2);
	            sheet.addCell(label);
	            label  = new Label(17, 1, "经办人员", wff2);
	            sheet.addCell(label);
	            
	            ArrayList<?> User_User_Info = (ArrayList<?>)request.getSession().getAttribute("User_User_Info_" + Sid);
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 1;
				while(iterator.hasNext())
				{
					i++;
					SpaStoreIBean Bean = (SpaStoreIBean)iterator.next();
					String D_Spa_Type_Name = Bean.getSpa_Type_Name();
					String D_Spa_Mode      = Bean.getSpa_Mode();
					String D_Model         = Bean.getModel();
					String D_Spa_I_Time    = Bean.getSpa_I_Time();
					String Spa_Mode_Name   = "/";
					if(null != D_Model && D_Model.length() > 0)
					{
						String[] List = D_Model.split(",");
						if(List.length >= Integer.parseInt(D_Spa_Mode))
							Spa_Mode_Name = List[Integer.parseInt(D_Spa_Mode)-1];
					}
					
					//申购信息
					String D_Spa_I_Numb    = Bean.getSpa_I_Numb();
					String D_Spa_I_Cnt     = Bean.getSpa_I_Cnt();
					String D_Spa_I_Price   = Bean.getSpa_I_Price();
					String D_Spa_I_Amt     = Bean.getSpa_I_Amt();
					String D_Spa_I_Memo    = Bean.getSpa_I_Memo(); 
					String D_Operator_Name = Bean.getOperator_Name();
					
					//审核信息
					String D_Status_OP_Name = Bean.getStatus_OP_Name();
					String D_Status_Memo    = Bean.getStatus_Memo();
					if(null == D_Status_OP_Name){D_Status_OP_Name = "";}
					if(null == D_Status_Memo){D_Status_Memo = "";}
					
					String str_Status = "";
					switch(Integer.parseInt(Bean.getStatus()))
					{
						case 0:
							str_Status = "未审核";
							break;
						case 1:
							str_Status = "审核有效";
							break;
						case 2:
							str_Status = "审核无效";
							break;
					}
					
					//入库信息
					String D_IN_Numb   = Bean.getIN_Numb();
					String D_IN_Cnt    = Bean.getIN_Cnt();
					String D_IN_Date   = Bean.getIN_Date();
					String D_IN_Oper   = Bean.getIN_Oper();
					String D_IN_Oper_N = "";
					if(null == D_IN_Numb){D_IN_Numb = "";}
					if(null == D_IN_Cnt){D_IN_Cnt = "";}
					if(null == D_IN_Date){D_IN_Date = "";}
					if(null == D_IN_Oper){D_IN_Oper = "";}
					if(D_IN_Oper.length() > 0 && User_User_Info != null)
					{
						for(int a=0; a<User_User_Info.size(); a++)
						{
							UserInfoBean Info = (UserInfoBean)User_User_Info.get(a);
							if(Info.getId().equals(D_IN_Oper))
							{
								D_IN_Oper_N = Info.getCName();
								break;
							}
						}
					}
					
					String str_IN_Status = "";
					switch(Integer.parseInt(Bean.getIN_Status()))
					{
						case 0:
							str_IN_Status = "待入库";
							break;
						case 1:
							str_IN_Status = "已入库";
							break;
					}
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-1)+"", wff3);
		            sheet.addCell(label);
		            label = new Label(1,i,D_Spa_Type_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2,i,Spa_Mode_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(3,i,D_Spa_I_Time, wff3);
		            sheet.addCell(label);
		            label = new Label(4,i,D_Spa_I_Numb, wff3);
		            sheet.addCell(label);
		            label = new Label(5,i,D_Spa_I_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(6,i,D_Spa_I_Price, wff3);
		            sheet.addCell(label);
		            label = new Label(7,i,D_Spa_I_Amt, wff3);
		            sheet.addCell(label);
		            label = new Label(8,i,D_Spa_I_Memo, wff3);
		            sheet.addCell(label);
		            label = new Label(9,i,D_Operator_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(10,i,str_Status, wff3);
		            sheet.addCell(label);
		            label = new Label(11,i,D_Status_OP_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(12,i,D_Status_Memo, wff3);
		            sheet.addCell(label);
		            label = new Label(13,i,str_IN_Status, wff3);
		            sheet.addCell(label);
		            label = new Label(14,i,D_IN_Numb, wff3);
		            sheet.addCell(label);
		            label = new Label(15,i,D_IN_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(16,i,D_IN_Date, wff3);
		            sheet.addCell(label);
		            label = new Label(17,i,D_IN_Oper_N, wff3);
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
				switch(currStatus.getFunc_Sel_Id())
				{
					case 0:
					case 9:
						Sql = " select t.sn, t.spa_type, t.spa_type_name, t.spa_mode, t.ctype, t.model, t.spa_i_time, t.spa_i_numb, " +
						  	  " t.spa_i_cnt, t.spa_i_price, t.spa_i_amt, t.spa_i_memo, t.status, t.status_op, t.status_op_name, t.status_memo, " +
						  	  " t.ctime, t.operator, t.operator_name, t.in_status, t.in_numb, t.in_cnt, t.in_date, t.in_oper " +
						  	  " from view_spa_store_i t " +
						  	  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
						  	  "   and t.ctype like '"+ Func_Sub_Id +"%'" +
						  	  "   and t.status like '"+ Func_Sel_Id +"%'" +
						  	  "   and t.spa_i_numb like '%"+ Func_Type_Id +"%'" +
						  	  "   order by t.spa_i_time desc ";
						break;
					default:
						Sql = " select t.sn, t.spa_type, t.spa_type_name, t.spa_mode, t.ctype, t.model, t.spa_i_time, t.spa_i_numb, " +
							  " t.spa_i_cnt, t.spa_i_price, t.spa_i_amt, t.spa_i_memo, t.status, t.status_op, t.status_op_name, t.status_memo, " +
							  " t.ctime, t.operator, t.operator_name, t.in_status, t.in_numb, t.in_cnt, t.in_date, t.in_oper " +
						  	  " from view_spa_store_i t " +
						  	  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
						  	  "   and t.ctype like '"+ Func_Sub_Id +"%'" +
						  	  "   and t.status like '"+ Func_Sel_Id +"%'" +
						  	  "   and t.spa_i_numb like '%"+ Func_Type_Id +"%'" +
						  	  "   and t.spa_i_time >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  "   and t.spa_i_time <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  "   order by t.spa_i_time desc ";
						break;
				}
				break;
			case 1://入库查询
				switch(currStatus.getFunc_Sel_Id())
				{
					case 0:
					case 9:
						Sql = " select t.sn, t.spa_type, t.spa_type_name, t.spa_mode, t.ctype, t.model, t.spa_i_time, t.spa_i_numb, " +
						  	  " t.spa_i_cnt, t.spa_i_price, t.spa_i_amt, t.spa_i_memo, t.status, t.status_op, t.status_op_name, t.status_memo, " +
						  	  " t.ctime, t.operator, t.operator_name, t.in_status, t.in_numb, t.in_cnt, t.in_date, t.in_oper " +
						  	  " from view_spa_store_i t " +
						  	  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
						  	  "   and t.ctype like '"+ Func_Sub_Id +"%'" +
						  	  "   and t.status = '1' " +
						  	  "   and t.in_status like '"+ Func_Sel_Id +"%'" +
						  	  "   and t.spa_i_numb like '%"+ Func_Type_Id +"%'" +
						  	  "   order by t.spa_i_time desc ";
						break;
					default:
						Sql = " select t.sn, t.spa_type, t.spa_type_name, t.spa_mode, t.ctype, t.model, t.spa_i_time, t.spa_i_numb, " +
							  " t.spa_i_cnt, t.spa_i_price, t.spa_i_amt, t.spa_i_memo, t.status, t.status_op, t.status_op_name, t.status_memo, " +
							  " t.ctime, t.operator, t.operator_name, t.in_status, t.in_numb, t.in_cnt, t.in_date, t.in_oper " +
						  	  " from view_spa_store_i t " +
						  	  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
						  	  "   and t.ctype like '"+ Func_Sub_Id +"%'" +
						  	  "   and t.status = '1' " +
						  	  "   and t.in_status like '"+ Func_Sel_Id +"%'" +
						  	  "   and t.spa_i_numb like '%"+ Func_Type_Id +"%'" +
						  	  "   and t.spa_i_time >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  "   and t.spa_i_time <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  "   order by t.spa_i_time desc ";
						break;
				}
				break;
			case 10://添加
				Sql = " insert into spa_store_i(spa_type, spa_mode, spa_i_time, spa_i_numb, spa_i_cnt, spa_i_price, spa_i_amt, spa_i_memo, ctime, operator)" +
					  " values('"+ Spa_Type +"', '"+ Spa_Mode +"', '"+ Spa_I_Time +"', '"+ Spa_I_Numb +"', '"+ Spa_I_Cnt +"', '"+ Spa_I_Price +"', '"+ Spa_I_Amt +"', '"+ Spa_I_Memo +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"')";
				break;
			case 11://修改
				Sql = " update spa_store_i t set t.spa_type = '"+ Spa_Type +"', t.spa_mode = '"+ Spa_Mode +"',  t.spa_i_time = '"+ Spa_I_Time +"', t.spa_i_numb = '"+ Spa_I_Numb +"', " +
					  " t.spa_i_cnt = '"+ Spa_I_Cnt +"', t.spa_i_price = '"+ Spa_I_Price +"', t.spa_i_amt = '"+ Spa_I_Amt +"', t.spa_i_memo = '"+ Spa_I_Memo +"', t.operator = '"+ Operator +"' " +
					  " where t.sn = '"+ SN +"'";
				break;
			case 12://审核
				Sql = " update spa_store_i t set t.status = '"+ Status +"', t.status_op = '"+ Status_OP +"', t.status_memo = '"+ Status_Memo +"' " +
					  " where t.sn = '"+ SN +"'";
				break;
			case 13://一键审核
				Sql = " update spa_store_i t set t.status = '"+ Status +"', t.status_op = '"+ Status_OP +"', t.status_memo = '"+ Status_Memo +"' " +
				      " where t.spa_i_numb = '"+ Spa_I_Numb +"' " +
				      "   and t.status = '0' ";
				break;
			case 14://入库
				Sql = " update spa_store_i t set t.in_status = '"+ IN_Status +"', t.in_numb = '"+ IN_Numb +"', t.in_cnt = '"+ IN_Cnt +"', t.in_date = '"+ IN_Date +"', t.in_oper = '"+ IN_Oper +"' " +
				  	  " where t.sn = '"+ SN +"'";
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
			setSpa_Type_Name(pRs.getString(3));
			setSpa_Mode(pRs.getString(4));
			setCType(pRs.getString(5));
			setModel(pRs.getString(6));
			setSpa_I_Time(pRs.getString(7));
			setSpa_I_Numb(pRs.getString(8));
			setSpa_I_Cnt(pRs.getString(9));
			setSpa_I_Price(pRs.getString(10));
			setSpa_I_Amt(pRs.getString(11));
			setSpa_I_Memo(pRs.getString(12));
			setStatus(pRs.getString(13));
			setStatus_OP(pRs.getString(14));
			setStatus_OP_Name(pRs.getString(15));
			setStatus_Memo(pRs.getString(16));
			setCTime(pRs.getString(17));
			setOperator(pRs.getString(18));
			setOperator_Name(pRs.getString(19));
			setIN_Status(pRs.getString(20));
			setIN_Numb(pRs.getString(21));
			setIN_Cnt(pRs.getString(22));
			setIN_Date(pRs.getString(23));
			setIN_Oper(pRs.getString(24));
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
			setSpa_Type_Name(CommUtil.StrToGB2312(request.getParameter("Spa_Type_Name")));
			setSpa_Mode(CommUtil.StrToGB2312(request.getParameter("Spa_Mode")));
			setCType(CommUtil.StrToGB2312(request.getParameter("CType")));
			setModel(CommUtil.StrToGB2312(request.getParameter("Model")));
			setSpa_I_Time(CommUtil.StrToGB2312(request.getParameter("Spa_I_Time")));
			setSpa_I_Numb(CommUtil.StrToGB2312(request.getParameter("Spa_I_Numb")));
			setSpa_I_Cnt(CommUtil.StrToGB2312(request.getParameter("Spa_I_Cnt")));
			setSpa_I_Price(CommUtil.StrToGB2312(request.getParameter("Spa_I_Price")));
			setSpa_I_Amt(CommUtil.StrToGB2312(request.getParameter("Spa_I_Amt")));
			setSpa_I_Memo(CommUtil.StrToGB2312(request.getParameter("Spa_I_Memo")));
			setStatus(CommUtil.StrToGB2312(request.getParameter("Status")));
			setStatus_OP(CommUtil.StrToGB2312(request.getParameter("Status_OP")));
			setStatus_OP_Name(CommUtil.StrToGB2312(request.getParameter("Status_OP_Name")));
			setStatus_Memo(CommUtil.StrToGB2312(request.getParameter("Status_Memo")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
			setIN_Status(CommUtil.StrToGB2312(request.getParameter("IN_Status")));
			setIN_Numb(CommUtil.StrToGB2312(request.getParameter("IN_Numb")));
			setIN_Cnt(CommUtil.StrToGB2312(request.getParameter("IN_Cnt")));
			setIN_Date(CommUtil.StrToGB2312(request.getParameter("IN_Date")));
			setIN_Oper(CommUtil.StrToGB2312(request.getParameter("IN_Oper")));
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
	private String Spa_Type_Name;
	private String Spa_Mode;
	private String CType;
	private String Model;
	private String Spa_I_Time;
	private String Spa_I_Numb;
	private String Spa_I_Cnt;
	private String Spa_I_Price;
	private String Spa_I_Amt;
	private String Spa_I_Memo;
	private String Status;
	private String Status_OP;
	private String Status_OP_Name;
	private String Status_Memo;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	private String IN_Status;
	private String IN_Numb;
	private String IN_Cnt;
	private String IN_Date;
	private String IN_Oper;
	
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sub_Id;
	private String Func_Sel_Id;
	private String Func_Type_Id;
	
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

	public String getSpa_Type_Name() {
		return Spa_Type_Name;
	}

	public void setSpa_Type_Name(String spaTypeName) {
		Spa_Type_Name = spaTypeName;
	}

	public String getSpa_Mode() {
		return Spa_Mode;
	}

	public void setSpa_Mode(String spaMode) {
		Spa_Mode = spaMode;
	}

	public String getCType() {
		return CType;
	}

	public void setCType(String cType) {
		CType = cType;
	}

	public String getModel() {
		return Model;
	}

	public void setModel(String model) {
		Model = model;
	}

	public String getSpa_I_Time() {
		return Spa_I_Time;
	}

	public void setSpa_I_Time(String spaITime) {
		Spa_I_Time = spaITime;
	}

	public String getSpa_I_Numb() {
		return Spa_I_Numb;
	}

	public void setSpa_I_Numb(String spaINumb) {
		Spa_I_Numb = spaINumb;
	}

	public String getSpa_I_Cnt() {
		return Spa_I_Cnt;
	}

	public void setSpa_I_Cnt(String spaICnt) {
		Spa_I_Cnt = spaICnt;
	}

	public String getSpa_I_Price() {
		return Spa_I_Price;
	}

	public void setSpa_I_Price(String spaIPrice) {
		Spa_I_Price = spaIPrice;
	}

	public String getSpa_I_Amt() {
		return Spa_I_Amt;
	}

	public void setSpa_I_Amt(String spaIAmt) {
		Spa_I_Amt = spaIAmt;
	}

	public String getSpa_I_Memo() {
		return Spa_I_Memo;
	}

	public void setSpa_I_Memo(String spaIMemo) {
		Spa_I_Memo = spaIMemo;
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
	
	public String getIN_Status() {
		return IN_Status;
	}

	public void setIN_Status(String iNStatus) {
		IN_Status = iNStatus;
	}

	public String getIN_Numb() {
		return IN_Numb;
	}

	public void setIN_Numb(String iNNumb) {
		IN_Numb = iNNumb;
	}

	public String getIN_Cnt() {
		return IN_Cnt;
	}

	public void setIN_Cnt(String iNCnt) {
		IN_Cnt = iNCnt;
	}

	public String getIN_Date() {
		return IN_Date;
	}

	public void setIN_Date(String iNDate) {
		IN_Date = iNDate;
	}

	public String getIN_Oper() {
		return IN_Oper;
	}

	public void setIN_Oper(String iNOper) {
		IN_Oper = iNOper;
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

	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String funcTypeId) {
		Func_Type_Id = funcTypeId;
	}
}