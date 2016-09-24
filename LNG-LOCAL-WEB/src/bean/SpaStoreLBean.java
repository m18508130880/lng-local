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

public class SpaStoreLBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SPA_STORE_L;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SpaStoreLBean()
	{
		super.className = "SpaStoreLBean";
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
		
		//模式
		Func_Sel_Id = currStatus.getFunc_Sel_Id()+"";
		if(Func_Sel_Id.equals("9"))
		{
			Func_Sel_Id = "";
		}
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			case 0://查询
		    	request.getSession().setAttribute("Spa_Store_L_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Spa_Store_L.jsp?Sid=" + Sid);
		    	
		    	//库存台账
		    	SpaStoreBean Store = new SpaStoreBean();
		    	Store.setFunc_Corp_Id("");
		    	Store.setFunc_Sub_Id("");
		    	msgBean = pRmi.RmiExec(0, Store, 0);
				request.getSession().setAttribute("Spa_Store_" + Sid, (Object)msgBean.getMsg());
		    	
		    	//站点库存
		    	SpaStationLBean StationL = new SpaStationLBean();
		    	StationL.setFunc_Corp_Id(Func_Corp_Id);
		    	StationL.setFunc_Sub_Id(Func_Sub_Id);
		    	StationL.setFunc_Sel_Id(Func_Sel_Id);
		    	StationL.currStatus = currStatus;
		    	msgBean = pRmi.RmiExec(0, StationL, 0);
		    	request.getSession().setAttribute("Spa_Station_L_" + Sid, ((Object)msgBean.getMsg()));
		    	
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
		    	break;
			case 1://调整查询
				request.getSession().setAttribute("Spa_Store_L_Log_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Spa_Store_L_Log.jsp?Sid=" + Sid);
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
			
			//模式
			Func_Sel_Id = currStatus.getFunc_Sel_Id()+"";
			if(Func_Sel_Id.equals("9"))
			{
				Func_Sel_Id = "";
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
			
			//站点库存
			SpaStationLBean StationL = new SpaStationLBean();
	    	StationL.setFunc_Corp_Id(Func_Corp_Id);
	    	StationL.setFunc_Sub_Id(Func_Sub_Id);
	    	StationL.setFunc_Sel_Id(Func_Sel_Id);
	    	StationL.currStatus = currStatus;
	    	msgBean = pRmi.RmiExec(0, StationL, 0);
			ArrayList<?> temp1 = (ArrayList<?>)msgBean.getMsg();
			
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
				
				ArrayList<?> User_Manage_Role = (ArrayList<?>)request.getSession().getAttribute("User_Manage_Role_" + Sid);
				UserInfoBean UserInfo         = (UserInfoBean)request.getSession().getAttribute("UserInfo_" + Sid);
				String ManageId  = UserInfo.getManage_Role();
				String D_Spa_Chg = "";
				int Chg_cnt      = 0;
				String Role_List = "";
				if(ManageId.length() > 0 && null != User_Manage_Role)
				{
					Iterator<?> iterator = User_Manage_Role.iterator();
					while(iterator.hasNext())
					{
						UserRoleBean statBean = (UserRoleBean)iterator.next();
						if(statBean.getId().substring(0,4).equals(ManageId) && statBean.getId().length() == 8)
						{
							String R_Point = statBean.getPoint();
							if(null == R_Point){R_Point = "";}
							Role_List += R_Point;
						}
					}
				}
				
				int D_Index = -1;
				Label label = null;
				
				D_Index++;
	            sheet.setRowView(D_Index, 600);
	            sheet.setColumnView(D_Index, 20);
	            switch(currStatus.getFunc_Sel_Id())
				{
					case 1:
						label = new Label(0, D_Index, "备品备件库存月报表", wff);
			            sheet.addCell(label);
						break;
					case 2:
						label = new Label(0, D_Index, "备品备件库存季度报表", wff);
			            sheet.addCell(label);
						break;
					case 3:
						label = new Label(0, D_Index, "备品备件库存年报表", wff);
			            sheet.addCell(label);
						break;
				}
	            label = new Label(1, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(9, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(10, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,10,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            switch(currStatus.getFunc_Sub_Id())
				{
					case 1:
						label = new Label(0, D_Index, "电气类", wff2);
			            sheet.addCell(label);
						break;
					case 2:
						label = new Label(0, D_Index, "工艺类", wff2);
			            sheet.addCell(label);
						break;
				}
	            label = new Label(1, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,2,D_Index);
	            switch(currStatus.getFunc_Sel_Id())
				{
					case 1:
						label = new Label(3, D_Index, Year+"年"+Month+"月", wff2);
			            sheet.addCell(label);
						break;
					case 2:
						switch(Integer.parseInt(Quarter))
						{
							case 1:
								label = new Label(3, D_Index, Year+"年第一季度", wff2);
					            sheet.addCell(label);
								break;
							case 2:
								label = new Label(3, D_Index, Year+"年第二季度", wff2);
					            sheet.addCell(label);
								break;
							case 3:
								label = new Label(3, D_Index, Year+"年第三季度", wff2);
					            sheet.addCell(label);
								break;
							case 4:
								label = new Label(3, D_Index, Year+"年第四季度", wff2);
					            sheet.addCell(label);
								break;
						}
						break;
					case 3:
						label = new Label(3, D_Index, Year+"年", wff2);
			            sheet.addCell(label);
						break;
				}
	            label = new Label(4, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(9, D_Index, "");
		        sheet.addCell(label);
	            label = new Label(10, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(3,D_Index,10,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "序号", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "备件名称", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "规格型号", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "单位", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "维修队结存明细", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(4,D_Index,8,D_Index);
	            label = new Label(9, D_Index, "各站结存明细", wff2);
        		sheet.addCell(label);
	            label = new Label(10, D_Index, "本期结存", wff2);
	            sheet.addCell(label);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "上期结存", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "进库", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "出库", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "结存", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "保底存量", wff2);
	            sheet.addCell(label);
				label = new Label(9, D_Index, "", wff2);
				sheet.addCell(label);
			    label = new Label(10, D_Index, "", wff2);
	            sheet.addCell(label);
			    sheet.mergeCells(0,D_Index-1,0,D_Index);
			    sheet.mergeCells(1,D_Index-1,1,D_Index);
			    sheet.mergeCells(2,D_Index-1,2,D_Index);
			    sheet.mergeCells(3,D_Index-1,3,D_Index);
			    sheet.mergeCells(9,D_Index-1,9,D_Index);
			    sheet.mergeCells(10,D_Index-1,10,D_Index);
			    
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					SpaStoreLBean Bean = (SpaStoreLBean)iterator.next();
					String D_Spa_Type = Bean.getSpa_Type();
					String D_Spa_Type_Name = Bean.getSpa_Type_Name();
					String D_Spa_Mode = Bean.getSpa_Mode();
					String D_Model = Bean.getModel();
					String D_Unit = Bean.getUnit();
					String D_Old_R_Cnt = Bean.getOld_R_Cnt();
					String D_Now_R_Cnt = Bean.getNow_R_Cnt();
					String D_Now_I_Cnt = Bean.getNow_I_Cnt();
					String D_Now_O_Cnt = Bean.getNow_O_Cnt();
					String D_Spa_R_Cnt = Bean.getSpa_R_Cnt();
					String D_Spa_Mode_Name = "/";
					if(null != D_Model && D_Model.length() > 0)
					{
						String[] List = D_Model.split(",");
						if(List.length >= Integer.parseInt(D_Spa_Mode))
							D_Spa_Mode_Name = List[Integer.parseInt(D_Spa_Mode)-1];
					}					
					
					//本期结存
					int D_Now_R_Cnt_All = Integer.parseInt(D_Now_R_Cnt);
					
					//各站结存明细
					String stat_Des = "";
					if(null != temp1)
					{
						Iterator<?> statiter = temp1.iterator();
						while(statiter.hasNext())
						{
							SpaStationLBean stationBean = (SpaStationLBean)statiter.next();
							if(Role_List.contains(stationBean.getCpm_Id()) && stationBean.getSpa_Type().equals(D_Spa_Type) && stationBean.getSpa_Mode().equals(D_Spa_Mode))
							{
								stat_Des += stationBean.getCpm_Name() + ": " + stationBean.getNow_R_Cnt() + "\012";
								D_Now_R_Cnt_All += Integer.parseInt(stationBean.getNow_R_Cnt());
							}
						}
					}
					
					if(3 == D_Index)
					{
						D_Spa_Chg = D_Spa_Type;
					}
					
					if(!D_Spa_Chg.equals(D_Spa_Type))
					{
						//纵向合并
						sheet.mergeCells(1,(D_Index-Chg_cnt+1),1,D_Index);
						sheet.mergeCells(3,(D_Index-Chg_cnt+1),3,D_Index);
						
						Chg_cnt = 1;
						D_Spa_Chg = D_Spa_Type;
					}
					else
					{
						Chg_cnt++;
					}
					
					D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, (D_Index-3)+"", wff3);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, D_Spa_Type_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, D_Spa_Mode_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(3, D_Index, D_Unit, wff3);
		            sheet.addCell(label);            
		            label = new Label(4, D_Index, D_Old_R_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, D_Now_I_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, D_Now_O_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(7, D_Index, (Integer.parseInt(D_Old_R_Cnt) + Integer.parseInt(D_Now_I_Cnt) - Integer.parseInt(D_Now_O_Cnt))+"", wff3);
		            sheet.addCell(label);
		            label = new Label(8, D_Index, D_Spa_R_Cnt, (Integer.parseInt(D_Old_R_Cnt) + Integer.parseInt(D_Now_I_Cnt) - Integer.parseInt(D_Now_O_Cnt) - Integer.parseInt(D_Spa_R_Cnt))<0?wff4:wff3);
		            sheet.addCell(label);
					label = new Label(9, D_Index, stat_Des, wff3);
					sheet.addCell(label);
		            label = new Label(10, D_Index, D_Now_R_Cnt_All+"", wff3);
		            sheet.addCell(label);
				}
	            
				//纵向合并
				sheet.mergeCells(1,(D_Index-Chg_cnt+1),1,D_Index);
				sheet.mergeCells(3,(D_Index-Chg_cnt+1),3,D_Index);
			    
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
	
	/*
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
			
			//模式
			Func_Sel_Id = currStatus.getFunc_Sel_Id()+"";
			if(Func_Sel_Id.equals("9"))
			{
				Func_Sel_Id = "";
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
			
			//站点库存
			SpaStationLBean StationL = new SpaStationLBean();
	    	StationL.setFunc_Corp_Id(Func_Corp_Id);
	    	StationL.setFunc_Sub_Id(Func_Sub_Id);
	    	StationL.setFunc_Sel_Id(Func_Sel_Id);
	    	StationL.currStatus = currStatus;
	    	msgBean = pRmi.RmiExec(0, StationL, 0);
			ArrayList<?> temp1 = (ArrayList<?>)msgBean.getMsg();
			
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
				
				ArrayList<?> User_Manage_Role   = (ArrayList<?>)request.getSession().getAttribute("User_Manage_Role_" + Sid);
				ArrayList<?> User_Device_Detail = (ArrayList<?>)request.getSession().getAttribute("User_Device_Detail_" + Sid);
				UserInfoBean UserInfo           = (UserInfoBean)request.getSession().getAttribute("UserInfo_" + Sid);
				String ManageId  = UserInfo.getManage_Role();			
				String D_Spa_Chg = "";
				int Chg_cnt      = 0;
				int dev_cnt      = 0;
				int dev_dex      = 0;
				String Dev_List  = "";
				String Role_List = "";
				int D_Index      = -1;
				Label label      = null;
				if(ManageId.length() > 0 && null != User_Manage_Role)
				{
					Iterator<?> iterator = User_Manage_Role.iterator();
					while(iterator.hasNext())
					{
						UserRoleBean statBean = (UserRoleBean)iterator.next();
						if(statBean.getId().substring(0,4).equals(ManageId) && statBean.getId().length() == 8)
						{
							String R_Point = statBean.getPoint();
							if(null == R_Point){R_Point = "";}
							Role_List += R_Point;
						}
					}
				}
				if(Role_List.length() > 0 && null != User_Device_Detail)
				{
					Iterator<?> iterator = User_Device_Detail.iterator();
					while(iterator.hasNext())
					{
						DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
						if(Role_List.contains(statBean.getId()))
						{
							dev_cnt++;
							Dev_List += statBean.getId() + ",";
						}
					}
				}
				
				D_Index++;
	            sheet.setRowView(D_Index, 600);
	            sheet.setColumnView(D_Index, 20);	            
	            switch(currStatus.getFunc_Sel_Id())
				{
					case 1:
						label = new Label(0, D_Index, "备品备件库存月报表", wff);
			            sheet.addCell(label);
						break;
					case 2:
						label = new Label(0, D_Index, "备品备件库存季度报表", wff);
			            sheet.addCell(label);
						break;
					case 3:
						label = new Label(0, D_Index, "备品备件库存年报表", wff);
			            sheet.addCell(label);
						break;
				}	            
	            label = new Label(1, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "");
	            sheet.addCell(label);
	            for(int a=1; a<=dev_cnt; a++)
	            {
	            	label = new Label(8+a, D_Index, "");
		            sheet.addCell(label);
	            }
	            label = new Label(9+dev_cnt, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,9+dev_cnt,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            switch(currStatus.getFunc_Sub_Id())
				{
					case 1:
						label = new Label(0, D_Index, "电气类", wff2);
			            sheet.addCell(label);
						break;
					case 2:
						label = new Label(0, D_Index, "工艺类", wff2);
			            sheet.addCell(label);
						break;
				}
	            label = new Label(1, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,2,D_Index);
	            switch(currStatus.getFunc_Sel_Id())
				{
					case 1:
						label = new Label(3, D_Index, Year+"年"+Month+"月", wff2);
			            sheet.addCell(label);
						break;
					case 2:
						switch(Integer.parseInt(Quarter))
						{
							case 1:
								label = new Label(3, D_Index, Year+"年第一季度", wff2);
					            sheet.addCell(label);
								break;
							case 2:
								label = new Label(3, D_Index, Year+"年第二季度", wff2);
					            sheet.addCell(label);
								break;
							case 3:
								label = new Label(3, D_Index, Year+"年第三季度", wff2);
					            sheet.addCell(label);
								break;
							case 4:
								label = new Label(3, D_Index, Year+"年第四季度", wff2);
					            sheet.addCell(label);
								break;
						}
						break;
					case 3:
						label = new Label(3, D_Index, Year+"年", wff2);
			            sheet.addCell(label);
						break;
				}
	            label = new Label(4, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "");
	            sheet.addCell(label);
	            for(int a=1; a<=dev_cnt; a++)
	            {
	            	label = new Label(8+a, D_Index, "");
		            sheet.addCell(label);
	            }
	            label = new Label(9+dev_cnt, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(3,D_Index,9+dev_cnt,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "序号", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "备件名称", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "规格型号", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "单位", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "维修队结存明细", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(4,D_Index,8,D_Index);
	            for(int a=1; a<=dev_cnt; a++)
	            {
	            	if(1 == a)
	            	{
	            		label = new Label(8+a, D_Index, "各站结存明细", wff2);
	            		sheet.addCell(label);
	            	}
	            	else
	            	{
	            		label = new Label(8+a, D_Index, "", wff2);
	            		sheet.addCell(label);
	            	}
	            }
	            if(dev_cnt > 0)
	            {
	            	sheet.mergeCells(9,D_Index,8+dev_cnt,D_Index);
	            }
	            label = new Label(9+dev_cnt, D_Index, "本期结存", wff2);
	            sheet.addCell(label);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "上期结存", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "进库", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "出库", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "结存", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "保底存量", wff2);
	            sheet.addCell(label);
			    if(Role_List.length() > 0 && null != User_Device_Detail)
				{
					Iterator<?> iterator = User_Device_Detail.iterator();
					while(iterator.hasNext())
					{
						DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
						if(Role_List.contains(statBean.getId()))
						{
							dev_dex++;
							label = new Label(8+dev_dex, D_Index, statBean.getBrief(), wff2);
				            sheet.addCell(label);
						}
					}
				}
			    label = new Label(9+dev_cnt, D_Index, "", wff2);
	            sheet.addCell(label);
			    sheet.mergeCells(0,D_Index-1,0,D_Index);
			    sheet.mergeCells(1,D_Index-1,1,D_Index);
			    sheet.mergeCells(2,D_Index-1,2,D_Index);
			    sheet.mergeCells(3,D_Index-1,3,D_Index);
			    sheet.mergeCells(9+dev_cnt,D_Index-1,9+dev_cnt,D_Index);
			    
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					SpaStoreLBean Bean = (SpaStoreLBean)iterator.next();
					String D_Spa_Type = Bean.getSpa_Type();
					String D_Spa_Type_Name = Bean.getSpa_Type_Name();
					String D_Spa_Mode = Bean.getSpa_Mode();
					String D_Model = Bean.getModel();
					String D_Unit = Bean.getUnit();
					String D_Old_R_Cnt = Bean.getOld_R_Cnt();
					String D_Now_R_Cnt = Bean.getNow_R_Cnt();
					String D_Now_I_Cnt = Bean.getNow_I_Cnt();
					String D_Now_O_Cnt = Bean.getNow_O_Cnt();
					String D_Spa_R_Cnt = Bean.getSpa_R_Cnt();
					String D_Spa_Mode_Name = "/";
					if(null != D_Model && D_Model.length() > 0)
					{
						String[] List = D_Model.split(",");
						if(List.length >= Integer.parseInt(D_Spa_Mode))
							D_Spa_Mode_Name = List[Integer.parseInt(D_Spa_Mode)-1];
					}					
					
					//本期结存
					int D_Now_R_Cnt_All = Integer.parseInt(D_Now_R_Cnt);
					
					if(3 == D_Index)
					{
						D_Spa_Chg = D_Spa_Type;
					}
					
					if(!D_Spa_Chg.equals(D_Spa_Type))
					{
						//纵向合并
						sheet.mergeCells(1,(D_Index-Chg_cnt+1),1,D_Index);
						sheet.mergeCells(3,(D_Index-Chg_cnt+1),3,D_Index);
						
						Chg_cnt = 1;
						D_Spa_Chg = D_Spa_Type;
					}
					else
					{
						Chg_cnt++;
					}
					
					D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, (D_Index-3)+"", wff3);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, D_Spa_Type_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, D_Spa_Mode_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(3, D_Index, D_Unit, wff3);
		            sheet.addCell(label);            
		            label = new Label(4, D_Index, D_Old_R_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, D_Now_I_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, D_Now_O_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(7, D_Index, (Integer.parseInt(D_Old_R_Cnt) + Integer.parseInt(D_Now_I_Cnt) - Integer.parseInt(D_Now_O_Cnt))+"", wff3);
		            sheet.addCell(label);
		            label = new Label(8, D_Index, D_Spa_R_Cnt, (Integer.parseInt(D_Old_R_Cnt) + Integer.parseInt(D_Now_I_Cnt) - Integer.parseInt(D_Now_O_Cnt) - Integer.parseInt(D_Spa_R_Cnt))<0?wff4:wff3);
		            sheet.addCell(label);		            
		            for(int a=0; a<dev_cnt; a++)
					{
						String stat_Value = "0";
						if(null != temp1)
						{
							Iterator<?> statiter = temp1.iterator();
							while(statiter.hasNext())
							{
								SpaStationLBean stationBean = (SpaStationLBean)statiter.next();
								if(stationBean.getCpm_Id().equals(Dev_List.split(",")[a]) && stationBean.getSpa_Type().equals(D_Spa_Type) && stationBean.getSpa_Mode().equals(D_Spa_Mode))
								{
									stat_Value = stationBean.getNow_R_Cnt();
									D_Now_R_Cnt_All += Integer.parseInt(stationBean.getNow_R_Cnt());
								}
							}
						}
						label = new Label(9+a, D_Index, stat_Value, wff3);
			            sheet.addCell(label);
					}
		            label = new Label(9+dev_cnt, D_Index, D_Now_R_Cnt_All+"", wff3);
		            sheet.addCell(label);
				}
	            
				//纵向合并
				sheet.mergeCells(1,(D_Index-Chg_cnt+1),1,D_Index);
				sheet.mergeCells(3,(D_Index-Chg_cnt+1),3,D_Index);
			    
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
	*/
	
	//调整
	public void doLFix(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
    	if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
    	{
    		msgBean = pRmi.RmiExec(12, this, 0);
    		if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
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
				Sql = " select t.spa_type, t.spa_type_name, t.spa_mode, t.dev_type, t.model, t.unit, t.brand, t.seller, t.ctype, t.ctime, t.old_r_cnt, t.now_r_cnt, t.now_i_cnt, t.now_o_cnt, t.spa_r_cnt, '' as memo, '' as itime, '' as operator " +
					  " from view_spa_store_l t " +
					  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
					  "   and t.dev_type like '"+ Func_Sub_Id +"%' " +
					  "   and t.ctype like '"+ Func_Sel_Id +"%'" +
					  "   and t.ctime = date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
					  "   order by t.spa_type, t.spa_mode asc ";
				break;
			case 1://调整查询
				Sql = " select t.spa_type, t.spa_type_name, t.spa_mode, t.dev_type, t.model, t.unit, t.brand, t.seller, t.ctype, t.ctime, t.old_r_cnt, t.now_r_cnt, t.now_i_cnt, t.now_o_cnt, t.spa_r_cnt, t.memo, t.itime, t.operator " +
				  	  " from view_spa_store_l_log t " +
				  	  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
				  	  "   and t.dev_type like '"+ Func_Sub_Id +"%' " +
				  	  "   and t.ctype like '"+ Func_Sel_Id +"%'" +
				  	  "   order by t.itime desc ";
				break;
			case 11://调整
				Sql = " update spa_store_l t set t.old_r_cnt = '"+ Old_R_Cnt +"', t.now_i_cnt = '"+ Now_I_Cnt +"', t.now_o_cnt = '"+ Now_O_Cnt +"', t.now_r_cnt = '"+ Now_R_Cnt +"' " +
					  " where t.spa_type = '"+ Spa_Type +"' " +
					  "   and t.spa_mode = '"+ Spa_Mode +"' " +
					  "   and t.ctype = '"+ CType +"' " +
					  "   and t.ctime = '"+ CTime +"' ";
				break;
			case 12://调整日志
				Sql = " insert into spa_store_l_log(spa_type, spa_mode, ctype, ctime, old_r_cnt, now_r_cnt, now_i_cnt, now_o_cnt, memo, itime, operator)" +
					  " values('"+Spa_Type+"', '"+Spa_Mode+"', '"+CType+"', '"+CTime+"', '"+Old_R_Cnt+"', '"+Now_R_Cnt+"', '"+Now_I_Cnt+"', '"+Now_O_Cnt+"', '"+Memo+"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+Operator+"')";
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs)
	{
		boolean IsOK = true;
		try
		{
			setSpa_Type(pRs.getString(1));
			setSpa_Type_Name(pRs.getString(2));
			setSpa_Mode(pRs.getString(3));
			setDev_Type(pRs.getString(4));
			setModel(pRs.getString(5));
			setUnit(pRs.getString(6));
			setBrand(pRs.getString(7));
			setSeller(pRs.getString(8));
			setCType(pRs.getString(9));
			setCTime(pRs.getString(10));
			setOld_R_Cnt(pRs.getString(11));
			setNow_R_Cnt(pRs.getString(12));
			setNow_I_Cnt(pRs.getString(13));
			setNow_O_Cnt(pRs.getString(14));
			setSpa_R_Cnt(pRs.getString(15));
			setMemo(pRs.getString(16));
			setITime(pRs.getString(17));
			setOperator(pRs.getString(18));
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
			setSpa_Type(CommUtil.StrToGB2312(request.getParameter("Spa_Type")));
			setSpa_Type_Name(CommUtil.StrToGB2312(request.getParameter("Spa_Type_Name")));
			setSpa_Mode(CommUtil.StrToGB2312(request.getParameter("Spa_Mode")));
			setDev_Type(CommUtil.StrToGB2312(request.getParameter("Dev_Type")));
			setModel(CommUtil.StrToGB2312(request.getParameter("Model")));
			setUnit(CommUtil.StrToGB2312(request.getParameter("Unit")));
			setBrand(CommUtil.StrToGB2312(request.getParameter("Brand")));
			setSeller(CommUtil.StrToGB2312(request.getParameter("Seller")));
			setCType(CommUtil.StrToGB2312(request.getParameter("CType")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOld_R_Cnt(CommUtil.StrToGB2312(request.getParameter("Old_R_Cnt")));
			setNow_R_Cnt(CommUtil.StrToGB2312(request.getParameter("Now_R_Cnt")));
			setNow_I_Cnt(CommUtil.StrToGB2312(request.getParameter("Now_I_Cnt")));
			setNow_O_Cnt(CommUtil.StrToGB2312(request.getParameter("Now_O_Cnt")));
			setSpa_R_Cnt(CommUtil.StrToGB2312(request.getParameter("Spa_R_Cnt")));
			setMemo(CommUtil.StrToGB2312(request.getParameter("Memo")));
			setITime(CommUtil.StrToGB2312(request.getParameter("ITime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			
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
	
	private String Spa_Type;
	private String Spa_Type_Name;
	private String Spa_Mode;
	private String Dev_Type;
	private String Model;
	private String Unit;
	private String Brand;
	private String Seller;
	private String CType;
	private String CTime;
	private String Old_R_Cnt;
	private String Now_R_Cnt;
	private String Now_I_Cnt;
	private String Now_O_Cnt;
	private String Spa_R_Cnt;
	private String Memo;
	private String ITime;
	private String Operator;
	
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sub_Id;
	private String Func_Sel_Id;
	private String Year;
	private String Month;
	private String Quarter;
	
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

	public String getDev_Type() {
		return Dev_Type;
	}

	public void setDev_Type(String devType) {
		Dev_Type = devType;
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

	public String getCType() {
		return CType;
	}

	public void setCType(String cType) {
		CType = cType;
	}

	public String getCTime() {
		return CTime;
	}

	public void setCTime(String cTime) {
		CTime = cTime;
	}

	public String getOld_R_Cnt() {
		return Old_R_Cnt;
	}

	public void setOld_R_Cnt(String oldRCnt) {
		Old_R_Cnt = oldRCnt;
	}

	public String getNow_R_Cnt() {
		return Now_R_Cnt;
	}

	public void setNow_R_Cnt(String nowRCnt) {
		Now_R_Cnt = nowRCnt;
	}

	public String getNow_I_Cnt() {
		return Now_I_Cnt;
	}

	public void setNow_I_Cnt(String nowICnt) {
		Now_I_Cnt = nowICnt;
	}

	public String getNow_O_Cnt() {
		return Now_O_Cnt;
	}

	public void setNow_O_Cnt(String nowOCnt) {
		Now_O_Cnt = nowOCnt;
	}

	public String getSpa_R_Cnt() {
		return Spa_R_Cnt;
	}

	public void setSpa_R_Cnt(String spaRCnt) {
		Spa_R_Cnt = spaRCnt;
	}

	public String getMemo() {
		return Memo;
	}

	public void setMemo(String memo) {
		Memo = memo;
	}

	public String getITime() {
		return ITime;
	}

	public void setITime(String iTime) {
		ITime = iTime;
	}

	public String getOperator() {
		return Operator;
	}

	public void setOperator(String operator) {
		Operator = operator;
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