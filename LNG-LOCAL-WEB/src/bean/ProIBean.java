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

public class ProIBean extends RmiBean 
{	
	public final static long serialVersionUID = RmiBean.RMI_PRO_I;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public ProIBean()
	{
		super.className = "ProIBean";  
	}
	
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		//����
		Func_Corp_Id = currStatus.getFunc_Corp_Id();
		if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
		{
			Func_Corp_Id = "";
		}
		
		//״̬
		Func_Sub_Id = currStatus.getFunc_Sub_Id() + "";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		
		//�������
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if(null == Func_Type_Id|| Func_Type_Id.equals("8888"))
		{
			Func_Type_Id = "";
		}
		Func_Cpm_Id = currStatus.getFunc_Cpm_Id();
		if(null == Func_Cpm_Id|| Func_Cpm_Id.equals("6666"))
		{
			Func_Cpm_Id = "";
		}
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{					
			case 12: //�޸�	
				ProITankBean tBean = new ProITankBean();
				if(null != SNO)
				{
					tBean.setSN(SNO);
					tBean.setPre_Tank_V(Pre_Tank_V);
					tBean.setLat_Tank_V(Lat_Tank_V);
					tBean.setUnload(Unload);
					tBean.setPre_Temper(Pre_Temper);
					tBean.setLat_Temper(Lat_Temper);
					tBean.setPre_Press(Pre_Press);
					tBean.setLat_Press(Lat_Press);
					msgBean = pRmi.RmiExec(12, tBean, 0);
				}
				if(null != SNT)
				{
					tBean.setSN(SNT);
					tBean.setPre_Tank_V(Pre_Tank_VT);
					tBean.setLat_Tank_V(Lat_Tank_VT);
					tBean.setUnload(UnloadT);
					tBean.setPre_Temper(Pre_TemperT);
					tBean.setLat_Temper(Lat_TemperT);
					tBean.setPre_Press(Pre_PressT);
					tBean.setLat_Press(Lat_PressT);
					msgBean = pRmi.RmiExec(12, tBean, 0);					
				}
				msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());	
				currStatus.setTotalRecord(msgBean.getCount());
				
		    	currStatus.setJsp("Pro_I.jsp?Sid=" + Sid);
		    	
		    	//����ҵ��
		    	ProRBean pRBean = new ProRBean();
		    	msgBean = pRmi.RmiExec(1, pRBean, 0);
		    	request.getSession().setAttribute("Pro_R_Buss_" + Sid, ((Object)msgBean.getMsg()));
		    	//��������
		    	msgBean = pRmi.RmiExec(2, pRBean, 0);
		    	request.getSession().setAttribute("Pro_R_Type_" + Sid, ((Object)msgBean.getMsg()));
				
				break;
			case 13://ɾ��
			case 11://�༭
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());						
		    case 0://��ѯ
		    	request.getSession().setAttribute("Pro_I_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    					
		    	currStatus.setJsp("Pro_I.jsp?Sid=" + Sid);
		    	
		    	//����ҵ��
		    	ProRBean RBean = new ProRBean();
		    	msgBean = pRmi.RmiExec(1, RBean, 0);
		    	request.getSession().setAttribute("Pro_R_Buss_" + Sid, ((Object)msgBean.getMsg()));
		    	//��������
		    	msgBean = pRmi.RmiExec(2, RBean, 0);
		    	request.getSession().setAttribute("Pro_R_Type_" + Sid, ((Object)msgBean.getMsg()));
		    	break;
		    	
		    case 1://2015-04-11�۳�ͳ��		    	
		    	request.getSession().setAttribute("Pro_I_CC_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());		   
		    	currStatus.setJsp("Pro_I_CC.jsp?Sid=" + Sid);
		    	
		    	msgBean = pRmi.RmiExec(2, this, 0);//װ��վ��
		    	request.getSession().setAttribute("Pro_CC_FU_" + Sid, ((Object)msgBean.getMsg()));
		    	
		    	msgBean = pRmi.RmiExec(3, this, 0);//������
		    	request.getSession().setAttribute("Pro_CC_CA_" + Sid, ((Object)msgBean.getMsg()));
		    	
		    	ProRBean prBean = new ProRBean();		   
		    	msgBean = pRmi.RmiExec(2, prBean, 0);
		    	request.getSession().setAttribute("Pro_R_Type_" + Sid, ((Object)msgBean.getMsg()));
		    	break;
		    case 5:		    	
		    	request.getSession().setAttribute("Pro_I_MX_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Pro_I_Tank.jsp?Sid=" + Sid);
		    	
		    	ProITankBean tankBean = new ProITankBean();
		    	tankBean.setFunc_Type_Id(Func_Type_Id);
		    	tankBean.setCpm_Id(Cpm_Id);
		    	tankBean.setCTime(CTime);
		    	msgBean = pRmi.RmiExec(0, tankBean, 0);
		    	request.getSession().setAttribute("Pro_I_Tank_" + Sid, ((Object)msgBean.getMsg()));
		    	break;
		    
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	//��¼����
	public void ExportToExcel(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
			
			//����
			Func_Corp_Id = currStatus.getFunc_Corp_Id();
			if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
			{
				Func_Corp_Id = "";
			}
			
			//״̬
			Func_Sub_Id = currStatus.getFunc_Sub_Id() + "";
			if(Func_Sub_Id.equals("9"))
			{
				Func_Sub_Id = "";
			}
			
			//�������
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id)
			{
				Func_Type_Id = "";
			}
			
			//�����ʷ
			
			//���ɵ�ǰ
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			msgBean = pRmi.RmiExec(0, this, 0);
			ArrayList<?> temp = (ArrayList<?>)msgBean.getMsg();
			if(temp != null)
			{
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);
	            WritableFont wf = new WritableFont(WritableFont.createFont("normal"), 18, WritableFont.BOLD , false);
				WritableCellFormat wff = new WritableCellFormat(wf);
				wf.setColour(Colour.BLACK);//������ɫ
				wff.setAlignment(Alignment.CENTRE);//���þ���
				wff.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				wff.setBackground(jxl.format.Colour.TURQUOISE);//���õ�Ԫ��ı�����ɫ			
				
				//�����ʽ2
				WritableFont wf2 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff2 = new WritableCellFormat(wf2);
				wf2.setColour(Colour.BLACK);//������ɫ
				wff2.setAlignment(Alignment.CENTRE);//���þ���
				wff2.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				int D_Index            = -1;
				Label label       = null;
				
				D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 12);
	            label = new Label(0, D_Index, "�к����麣����Դ���޹�˾ж����¼��", wff);
	            sheet.addCell(label);
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
	            label = new Label(11, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(12, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(13, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(14, D_Index, "");
	            sheet.addCell(label);	          
	            sheet.mergeCells(0,D_Index,14,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 12);
	            Label label1  = new Label(0, D_Index, "ж��վ��",wff2);
	            Label label2  = new Label(1, D_Index, "ȼ������",wff2);
	            Label label3  = new Label(2, D_Index, "ж��ʱ��",wff2);
	            Label label4  = new Label(3, D_Index, "�������",wff2);
	            Label label5  = new Label(4, D_Index, "��������",wff2);
	            Label label6  = new Label(5, D_Index, "ж������",wff2);
	            Label label7  = new Label(6, D_Index, "�ۺ�����/��̬",wff2);
	            Label label8  = new Label(7, D_Index, "��ҵ��Ա",wff2);
	            Label label9  = new Label(8, D_Index, "���䳵��",wff2);
	            Label label10 = new Label(9, D_Index, "Ѻ����Ա",wff2);
	            Label label11 = new Label(10, D_Index, "���˵�λ",wff2);
	            Label label12 = new Label(11, D_Index, "¼����Ա",wff2);
	            Label label13 = new Label(12, D_Index, "�����Ա",wff2);
	            Label label14 = new Label(13, D_Index, "��¼״̬",wff2);
	            Label label15 = new Label(14, D_Index, "��ע",wff2);
	            
	            sheet.addCell(label1);
	            sheet.addCell(label2);
	            sheet.addCell(label3);
	            sheet.addCell(label4);
	            sheet.addCell(label5);
	            sheet.addCell(label6);
	            sheet.addCell(label7);
	            sheet.addCell(label8);
	            sheet.addCell(label9);
	            sheet.addCell(label10);
	            sheet.addCell(label11);
	            sheet.addCell(label12);
	            sheet.addCell(label13);
	            sheet.addCell(label14);
	            sheet.addCell(label15);
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				//int i = 0;
				while(iterator.hasNext())
				{
					//i++;
					ProIBean Bean = (ProIBean)iterator.next();
					String D_Cpm_Name = Bean.getCpm_Name();
					String D_CTime = Bean.getCTime();
					String D_Value = Bean.getValue();
					String D_Value_Gas = Bean.getValue_Gas();
					String D_Memo = Bean.getMemo();
					String D_Status = Bean.getStatus();
					String D_Car_Id = Bean.getCar_Id();
					String D_Car_Owner = Bean.getCar_Owner();
					String D_Oil_CType = Bean.getOil_CType();
					String D_Worker = Bean.getWorker();
					String D_Order_Id = Bean.getOrder_Id();
					String D_Order_Value = Bean.getOrder_Value();
					String D_Car_Corp = Bean.getCar_Corp();
					String D_Checker_Name = Bean.getChecker_Name();
					String D_Operator_Name = Bean.getOperator_Name();
					//String D_Unload         = Bean.getUnload();
					String D_Oil_CName = "��";
					
					CorpInfoBean Corp_Info = (CorpInfoBean)request.getSession().getAttribute("User_Corp_Info_" + Sid);
					String D_Oil_Info = "";
					if(null != Corp_Info)
					{
						D_Oil_Info = Corp_Info.getOil_Info();
						if(null == D_Oil_Info)
						{
							D_Oil_Info = "";
						}
					}
					
					if(D_Oil_Info.trim().length() > 0)
					{
					  String[] List = D_Oil_Info.split(";");
					  for(int j=0; j<List.length && List[j].length()>0; j++)
					  {
					  	String[] subList = List[j].split(",");
					  	if(subList[0].equals(D_Oil_CType))
					  	{
					  		D_Oil_CName = subList[1];
					  		break;
					  	}
					  }
					}
					
					if(null == D_Order_Id){D_Order_Id = "";}
					if(null == D_Order_Value){D_Order_Value = "";}
					if(null == D_Value){D_Value = "";}
					if(null == D_Value_Gas){D_Value_Gas = "";}							
					if(null == D_Car_Id){D_Car_Id = "";}
					if(null == D_Car_Owner){D_Car_Owner = "";}
					if(null == D_Oil_CType){D_Oil_CType = "1000";}
					if(null == D_Worker){D_Worker = "";}
					if(null == D_Memo){D_Memo = "";}
					if(null == D_Car_Corp){D_Car_Corp = "";}
					if(null == D_Checker_Name){D_Checker_Name = "";}
					
					String str_Status = "";
					switch(Integer.parseInt(D_Status))
					{
						case 0:
							str_Status = "��Ч";
							break;
						case 1:
							str_Status = "��Ч";
							break;
						case 2:
							str_Status = "�����";
							break;
					}
					
					String D_Order_Value_Unit = "";
					String D_Value_Unit = "";
					String D_Value_Gas_Unit = "";
					try
					{
						switch(Integer.parseInt(D_Oil_CType))
						{
							default:
							case 1000://����
							case 1010://90#����
							case 1011://90#��Ǧ����
							case 1012://90#�������
							case 1020://92#����
							case 1021://92#��Ǧ����
							case 1022://92#�������
							case 1030://93#����
							case 1031://93����Ǧ����
							case 1032://93#�������
							case 1040://95#����
							case 1041://95#��Ǧ����
							case 1042://95#�������
							case 1050://97#����
							case 1051://97#��Ǧ����
							case 1052://97#�������
							case 1060://120������
							case 1080://������������
							case 1090://98#����
							case 1091://98#��Ǧ����
							case 1092://98���������
							case 1100://��������
							case 1200://��������
							case 1201://75#��������
							case 1202://95#��������
							case 1203://100#��������
							case 1204://������������
							case 1300://��������
							case 2000://����
							case 2001://0#����
							case 2002://+5#����
							case 2003://+10#����
							case 2004://+15#����
							case 2005://+20#����
							case 2006://-5#����
							case 2007://-10#����
							case 2008://-15#����
							case 2009://-20#����
							case 2010://-30#����
							case 2011://-35#����
							case 2015://-50#����
							case 2100://�����
							case 2016://���������
							case 2200://�ز���
							case 2012://10#�ز���
							case 2013://20#�ز���
							case 2014://�����ز���
							case 2300://���ò���
							case 2301://-10#���ò���
							case 2900://��������
								 	D_Order_Value_Unit = "L";
								 	D_Value_Unit = "L";
								 	D_Value_Gas_Unit = "kg";
								break;
							case 3001://CNG
							case 3002://LNG
									D_Order_Value_Unit = "kg";
									D_Value_Unit = "kg";
									D_Value_Gas_Unit = "m3";
								break;
						}
					}
					catch(Exception Exp)
					{
						D_Order_Value_Unit = "kg";
						D_Value_Unit = "kg";
						D_Value_Gas_Unit = "m3";
						Exp.printStackTrace();
					}
					
					D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 12);
		            label = new Label(0,D_Index,D_Cpm_Name,wff2);
		            sheet.addCell(label);
		            label = new Label(1,D_Index,D_Oil_CName,wff2);
		            sheet.addCell(label);
		            label = new Label(2,D_Index,D_CTime,wff2);
		            sheet.addCell(label);
		            label = new Label(3,D_Index,D_Order_Id,wff2);
		            sheet.addCell(label);	                     
		            label = new Label(4,D_Index,D_Order_Value + D_Order_Value_Unit,wff2);
		            sheet.addCell(label);
		            label = new Label(5,D_Index,D_Value + D_Value_Unit,wff2);
		            sheet.addCell(label);
		            label = new Label(6,D_Index,D_Value_Gas + D_Value_Gas_Unit,wff2);
		            sheet.addCell(label);
		            label = new Label(7,D_Index,D_Worker,wff2);
		            sheet.addCell(label);
		            label = new Label(8,D_Index,D_Car_Id,wff2);
		            sheet.addCell(label);
		            label = new Label(9,D_Index,D_Car_Owner,wff2);
		            sheet.addCell(label);
		            label = new Label(10,D_Index,D_Car_Corp,wff2);
		            sheet.addCell(label);
		            label = new Label(11,D_Index,D_Operator_Name,wff2);
		            sheet.addCell(label);
		            label = new Label(12,D_Index,D_Checker_Name,wff2);
		            sheet.addCell(label);
		            label = new Label(13,D_Index,str_Status,wff2);
		            sheet.addCell(label);
		            label = new Label(14,D_Index,D_Memo,wff2);
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
	
	//��Ӳ���
	public void ProIAdd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		//����
		Func_Corp_Id = currStatus.getFunc_Corp_Id();
		if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
		{
			Func_Corp_Id = "";
		}
		
		//״̬
		Func_Sub_Id = currStatus.getFunc_Sub_Id() + "";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		
		//�������
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if(null == Func_Type_Id)
		{
			Func_Type_Id = "";
		}
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";						
		System.out.print("Func_Id["+Func_Id+"]");
		Tank_No = "1��2";
		ProITankBean tankBean = new ProITankBean();
		switch(Integer.parseInt(Func_Id))
		{
			case 0:
				Tank_No = "1";
				tankBean.setCpm_Id(Cpm_Id);	
				tankBean.setOrder_Id(Order_Id);
				tankBean.setTank_No(Tank_No);
				tankBean.setCTime(CTime);
				tankBean.setPre_Tank_V(Pre_Tank_V);
				tankBean.setLat_Tank_V(Lat_Tank_V);
				tankBean.setUnload(Unload);
				tankBean.setPre_Temper(Pre_Temper);
				tankBean.setLat_Temper(Lat_Temper);
				tankBean.setPre_Press(Pre_Press);
				tankBean.setLat_Press(Lat_Press);
				msgBean = pRmi.RmiExec(10, tankBean, 0);
				Tank_No = "2";
				tankBean.setCpm_Id(Cpm_Id);	
				tankBean.setOrder_Id(Order_Id);
				tankBean.setTank_No(Tank_No);
				tankBean.setCTime(CTime);
				tankBean.setPre_Tank_V(Pre_Tank_VT);
				tankBean.setLat_Tank_V(Lat_Tank_VT);
				tankBean.setUnload(UnloadT);
				tankBean.setPre_Temper(Pre_TemperT);
				tankBean.setLat_Temper(Lat_TemperT);
				tankBean.setPre_Press(Pre_PressT);
				tankBean.setLat_Press(Lat_PressT);
				msgBean = pRmi.RmiExec(10, tankBean, 0);
				Tank_No = "1��2";
				break;
		
			case 1:
				Tank_No = "1";
				tankBean.setCpm_Id(Cpm_Id);	
				tankBean.setOrder_Id(Order_Id);
				tankBean.setTank_No(Tank_No);
				tankBean.setCTime(CTime);
				tankBean.setPre_Tank_V(Pre_Tank_V);
				tankBean.setLat_Tank_V(Lat_Tank_V);
				tankBean.setUnload(Unload);
				tankBean.setPre_Temper(Pre_Temper);
				tankBean.setLat_Temper(Lat_Temper);
				tankBean.setPre_Press(Pre_Press);
				tankBean.setLat_Press(Lat_Press);
				msgBean = pRmi.RmiExec(10, tankBean, 0);				
				break;
			case 2:
				Tank_No = "2";
				tankBean.setCpm_Id(Cpm_Id);	
				tankBean.setOrder_Id(Order_Id);
				tankBean.setTank_No(Tank_No);
				tankBean.setCTime(CTime);
				tankBean.setPre_Tank_V(Pre_Tank_VT);
				tankBean.setLat_Tank_V(Lat_Tank_VT);
				tankBean.setUnload(UnloadT);
				tankBean.setPre_Temper(Pre_TemperT);
				tankBean.setLat_Temper(Lat_TemperT);
				tankBean.setPre_Press(Pre_PressT);
				tankBean.setLat_Press(Lat_PressT);
				msgBean = pRmi.RmiExec(10, tankBean, 0);
				break;
		}				
		Pre_Tank_V  = "0";
		Lat_Tank_V  = "0";
		Unload      = "0";
		Pre_Temper  = "0";
		Lat_Temper  = "0";
		Pre_Press   = "0";
		Lat_Press   = "0";
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
		{
			//msgBean = pRmi.RmiExec(40, this, 0);
			
			Resp = "0000";
			currStatus.setCmd(0);
			msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
			request.getSession().setAttribute("Pro_I_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		outprint.write(Resp);
	}
	
	//������ϸ����
	public void MxToExcel(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
			
			//����
			Func_Corp_Id = currStatus.getFunc_Corp_Id();
			if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
			{
				Func_Corp_Id = "";
			}
			
			//״̬
			Func_Sub_Id = currStatus.getFunc_Sub_Id() + "";
			if(Func_Sub_Id.equals("9"))
			{
				Func_Sub_Id = "";
			}
			
			//�������
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id)
			{
				Func_Type_Id = "";
			}
			
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			msgBean = pRmi.RmiExec(5, this, 0);
			ArrayList<?> temp = (ArrayList<?>)msgBean.getMsg();
			ProITankBean tBean   = new ProITankBean();
			tBean.setCpm_Id(Cpm_Id);
			tBean.setFunc_Type_Id(Func_Type_Id);
			msgBean = pRmi.RmiExec(0, tBean, 0);
			ArrayList<?> temp1= (ArrayList<?>)msgBean.getMsg();
			
			Label label       = null;
			int D_Index       = -1;
			int i             = 0;
			if(null != temp)
			{
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);	   
	            WritableFont wf = new WritableFont(WritableFont.createFont("normal"), 18, WritableFont.BOLD , false);
				WritableCellFormat wff = new WritableCellFormat(wf);
				wf.setColour(Colour.BLACK);//������ɫ
				wff.setAlignment(Alignment.CENTRE);//���þ���
				wff.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���				
				
				//�����ʽ2
				WritableFont wf2 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff2 = new WritableCellFormat(wf2);
				wf2.setColour(Colour.BLACK);//������ɫ	
				wff2.setAlignment(Alignment.CENTRE);//���þ���
				wff2.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				//�����ʽ3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);				
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
		
	            D_Index++;
				sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "ж����¼��",wff);
	            sheet.addCell(label);
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
	            sheet.mergeCells(0,D_Index,6,D_Index);
	            
	            
	            Iterator<?> priter = temp.iterator();
				while(priter.hasNext())
				{
					ProIBean bean = (ProIBean)priter.next();
					Cpm_Name  = bean.getCpm_Name();//վ��					
					Order_Id  = bean.getOrder_Id();//ж������
					Temper_Report = bean.getTemper_Report();//���ʱ��浥
					Car_Id    = bean.getCar_Id();//����
					Trailer_No = bean.getTrailer_No();//�ҳ�����
					Pre_Weight = bean.getPre_Weight();//ж��ǰ����
					Lat_Weight = bean.getLat_Weight();//ж��������
					Unload     = bean.getUnload();//ж������
					Arrive_Time = bean.getArrive_Time();//��վʱ��
					CTime     = bean.getCTime();//��ʼж��ʱ��
					Depart_Time = bean.getDepart_Time();//�뿪ʱ��
					Pre_Check   = bean.getPre_Check();//ж��ǰ���
					Pro_Check   = bean.getPro_Check();//ж�����̼��
					Lat_Check   = bean.getLat_Check();//ж������					
					Value       = bean.getValue();//ж����					
					Memo        = bean.getMemo();//��ע
					Tank_No     = bean.getTank_No();//�޺�
					
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, "վ������: " + Cpm_Name,wff2);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(3, D_Index, "");
		            sheet.addCell(label);
		            sheet.mergeCells(0,D_Index,3,D_Index);
		            label = new Label(4, D_Index, "����: "+CTime ,wff2);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		         	            
		            sheet.mergeCells(4,D_Index,6,D_Index);
		            
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, "ж������: " + Order_Id,wff3);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(3, D_Index, "");
		            sheet.addCell(label);
		            sheet.mergeCells(0,D_Index,3,D_Index);
		            label = new Label(4, D_Index, "���ʱ��浥: "+Temper_Report ,wff3);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		         	            
		            sheet.mergeCells(4,D_Index,6,D_Index);
		            
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, "�۳�",wff2);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, "����:"+Car_Id,wff3);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(3, D_Index, "");
		            sheet.addCell(label);
		            sheet.mergeCells(1,D_Index,3,D_Index);
		            label = new Label(4, D_Index, "�ҳ�����:"+Trailer_No ,wff3);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		         	            
		            sheet.mergeCells(4,D_Index,6,D_Index);
		            
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(1, D_Index, "ж��ǰ����:"+Pre_Weight+"Kg",wff3);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            sheet.mergeCells(1,D_Index,2,D_Index);
		            label = new Label(3, D_Index, "ж��������:"+Lat_Weight+"Kg",wff3);
		            sheet.addCell(label);		           
		            label = new Label(4, D_Index, "" );
		            sheet.addCell(label);
		            sheet.mergeCells(3,D_Index,4,D_Index);
		            label = new Label(5, D_Index, "ж����:"+Value+"Kg",wff3);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		        	            
		            sheet.mergeCells(5,D_Index,6,D_Index);
		            
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(1, D_Index, "��վʱ��:"+Arrive_Time,wff3);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            sheet.mergeCells(1,D_Index,2,D_Index);
		            label = new Label(3, D_Index, "��ʼж��ʱ��:"+CTime,wff3);
		            sheet.addCell(label);		           
		            label = new Label(4, D_Index, "" );
		            sheet.addCell(label);
		            sheet.mergeCells(3,D_Index,4,D_Index);
		            label = new Label(5, D_Index, "��վʱ��:"+Depart_Time,wff3);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		        	            
		            sheet.mergeCells(5,D_Index,6,D_Index);
		            
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(1, D_Index, "ж��ǰ���:"+Pre_Check,wff3);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            sheet.mergeCells(1,D_Index,2,D_Index);
		            label = new Label(3, D_Index, "ж�����̼��:"+Pro_Check,wff3);
		            sheet.addCell(label);		           
		            label = new Label(4, D_Index, "" );
		            sheet.addCell(label);
		            sheet.mergeCells(3,D_Index,4,D_Index);
		            label = new Label(5, D_Index, "ж������:"+Lat_Check,wff3);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		        	            
		            sheet.mergeCells(5,D_Index,6,D_Index);
		            sheet.mergeCells(0,3,0,6); 
		            		            		    
		        if(null != temp1)
		          {		        	
		            Iterator<?> it = temp1.iterator();
		            
					while(it.hasNext())
					{
						i++;
						ProITankBean tkBean = (ProITankBean)it.next();
						Tank_No    = tkBean.getTank_No();
						Pre_Tank_V = tkBean.getPre_Tank_V();
						Lat_Tank_V = tkBean.getLat_Tank_V();
						Pre_Press  = tkBean.getPre_Press();
						Lat_Press  = tkBean.getLat_Press();
						Pre_Temper = tkBean.getPre_Temper();
						Lat_Temper = tkBean.getLat_Temper();						
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index,Tank_No+"�Ź�" ,wff2);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, "ж��ǰҺλ:"+Pre_Tank_V+"L",wff3);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(3, D_Index, "");
		            sheet.addCell(label);
		            sheet.mergeCells(1,D_Index,3,D_Index);
		            label = new Label(4, D_Index, "ж����Һλ:"+Lat_Tank_V +"L",wff3);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		        		            
		            sheet.mergeCells(4,D_Index,6,D_Index);
		            
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index,"" );
		            sheet.addCell(label);
		            label = new Label(1, D_Index, "ж��ǰѹ��:"+Pre_Press+"MPa",wff3);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(3, D_Index, "");
		            sheet.addCell(label);
		            sheet.mergeCells(1,D_Index,3,D_Index);
		            label = new Label(4, D_Index, "ж����ѹ��:"+Lat_Press +"MPa",wff3);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		        		            
		            sheet.mergeCells(4,D_Index,6,D_Index);
		            
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index,"" );
		            sheet.addCell(label);
		            label = new Label(1, D_Index, "ж��ǰ�¶�:"+Pre_Temper+"��",wff3);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(3, D_Index, "");
		            sheet.addCell(label);
		            sheet.mergeCells(1,D_Index,3,D_Index);
		            label = new Label(4, D_Index, "ж�����¶�:"+Lat_Temper+"��" ,wff3);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		        		            
		            sheet.mergeCells(4,D_Index,6,D_Index);
		            sheet.mergeCells(0,7,0,9); 

						}
		            }
		        if( i == 2)
		        {
		        	sheet.mergeCells(0,10,0,12);
		            
		        }
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index,"��ע",wff2);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, Memo,wff3);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(3, D_Index, "");
		            sheet.addCell(label);		         
		            label = new Label(4, D_Index, "" );
		            sheet.addCell(label);
		            label = new Label(5, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		        		            
		            sheet.mergeCells(1,D_Index,6,D_Index);
            
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, "�Ӱ�ְԱǩ��:");
		            sheet.addCell(label);
		            label = new Label(1, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(3, D_Index, "");
		            sheet.addCell(label);
		            sheet.mergeCells(0,D_Index,3,D_Index);
		            label = new Label(4, D_Index, " �۳�˾��ǩ��:" );
		            sheet.addCell(label);
		            label = new Label(5, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		          	            
		            sheet.mergeCells(4,D_Index,6,D_Index);
		            
		            
		            D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, "������λ:");
		            sheet.addCell(label);
		            label = new Label(1, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(2, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(3, D_Index, "");
		            sheet.addCell(label);
		            sheet.mergeCells(0,D_Index,3,D_Index);
		            label = new Label(4, D_Index, " ���˵�λ:" );
		            sheet.addCell(label);
		            label = new Label(5, D_Index, "");
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "");
		            sheet.addCell(label);		          	            
		            sheet.mergeCells(4,D_Index,6,D_Index);	  				            		            		            
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
		}catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	//�۳�ͳ�Ƶ���
	
	public void CaocheExcel(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
	try {			
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
		
			//����
			Func_Corp_Id = currStatus.getFunc_Corp_Id();
			if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
			{
				Func_Corp_Id = "";
			}
			
			//״̬
			Func_Sub_Id = currStatus.getFunc_Sub_Id() + "";
			if(Func_Sub_Id.equals("9"))
			{
				Func_Sub_Id = "";
			}
		
			//�������
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id|| Func_Type_Id.equals("8888"))
			{
				Func_Type_Id = "";
			}
		
			Func_Cpm_Id = currStatus.getFunc_Cpm_Id();
			if(null == Func_Cpm_Id|| Func_Cpm_Id.equals("6666"))
			{
				Func_Cpm_Id = "";
			}
		
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
	
			msgBean = pRmi.RmiExec(1, this, 0);
			ArrayList<?> temp0 = (ArrayList<?>)msgBean.getMsg();
		
			int D_Index       = -1;
			Label label       = null;
			double Value_All       = 0.0;
			String Unit = "";
			int count = 0;
					
			if(null != temp0)
			{
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);	   
	            WritableFont wf = new WritableFont(WritableFont.createFont("normal"), 18, WritableFont.BOLD , false);
				WritableCellFormat wff = new WritableCellFormat(wf);
				//wf.setColour(Colour.BLACK);//������ɫ
				wff.setAlignment(Alignment.CENTRE);//���þ���
				wff.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���				
				//�����ʽ2
				WritableFont wf2 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff2 = new WritableCellFormat(wf2);
				//wf2.setColour(Colour.BLACK);//������ɫ	
				wff2.setAlignment(Alignment.CENTRE);//���þ���
				wff2.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				//�����ʽ3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);				
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				System.out.println("�����Ʊ�");
				
				D_Index++;
	            sheet.setRowView(D_Index, 600);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "�к����麣����Դ�۳�ͳ�Ʊ�",wff);
	            sheet.addCell(label);
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
	            label = new Label(11, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,11,D_Index);
				
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 15);
	            label = new Label(0, D_Index, "���",wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "���",wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "װ����",wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "ж����",wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "˾��",wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "�ҳ���",wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "���ƺ�",wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "������",wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "����",wff2);
	            sheet.addCell(label);
	            label = new Label(9, D_Index, "ë��",wff2);
	            sheet.addCell(label);
	            label = new Label(10, D_Index, "Ƥ��",wff2);
	            sheet.addCell(label);
	            label = new Label(11, D_Index, "����",wff2);
	            sheet.addCell(label);	           
	            
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					ProIBean Bean = (ProIBean)iterator.next();		
					Cpm_Name       = Bean.getCpm_Name();
					System.out.println(Cpm_Name);
					String SQLtime = Bean.getCTime();
					CTime          = SQLtime.substring(0,10);	
					Order_Id       = Bean.getOrder_Id();											
					Memo           = Bean.getMemo();
					Status         = Bean.getStatus();
					Car_Id         = Bean.getCar_Id();
					Car_Owner      = Bean.getCar_Owner();
					Car_Corp       = Bean.getCar_Corp();
					Oil_CType      = Bean.getOil_CType();
					Checker_Name   = Bean.getChecker_Name();
					Operator_Name  = Bean.getOperator_Name();
					Trailer_No     = Bean.getTrailer_No();
					Forward_Unit   = Bean.getForward_Unit();
					Gross_Weight   = Bean.getGross_Weight();
					Tear_Weight    = Bean.getTear_Weight();
					Ture_Weight    = Bean.getTure_Weight();
					Value_All     = Value_All + Double.parseDouble(Ture_Weight);		
					switch(Integer.parseInt(Oil_CType))
					{
						default:
						case 1000://����
						case 1010://90#����
						case 1011://90#��Ǧ����
						case 1012://90#�������
						case 1020://92#����
						case 1021://92#��Ǧ����
						case 1022://92#�������
						case 1030://93#����
						case 1031://93����Ǧ����
						case 1032://93#�������
						case 1040://95#����
						case 1041://95#��Ǧ����
						case 1042://95#�������
						case 1050://97#����
						case 1051://97#��Ǧ����
						case 1052://97#�������
						case 1060://120������
						case 1080://������������
						case 1090://98#����
						case 1091://98#��Ǧ����
						case 1092://98���������
						case 1100://��������
						case 1200://��������
						case 1201://75#��������
						case 1202://95#��������
						case 1203://100#��������
						case 1204://������������
						case 1300://��������
						case 2000://����
						case 2001://0#����
						case 2002://+5#����
						case 2003://+10#����
						case 2004://+15#����
						case 2005://+20#����
						case 2006://-5#����
						case 2007://-10#����
						case 2008://-15#����
						case 2009://-20#����
						case 2010://-30#����
						case 2011://-35#����
						case 2015://-50#����
						case 2100://�����
						case 2016://���������
						case 2200://�ز���
						case 2012://10#�ز���
						case 2013://20#�ز���
						case 2014://�����ز���
						case 2300://���ò���
						case 2301://-10#���ò���
						case 2900://��������
								Unit = "L";
							break;
						case 3001://CNG
						case 3002://LNG
								Unit = "kg";
							break;
					}
					
					count++;
					D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 15);
		            //String.valueOf(count)
		            label = new Label(0, D_Index,String.valueOf(count),wff2);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, Order_Id,wff2);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, Forward_Unit,wff2);
		            sheet.addCell(label);
		            label = new Label(3, D_Index, Cpm_Name,wff2);
		            sheet.addCell(label);
		            label = new Label(4, D_Index, Car_Owner,wff2);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, Trailer_No,wff2);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, Car_Id,wff2);
		            sheet.addCell(label);
		            label = new Label(7, D_Index, Car_Corp,wff2);
		            sheet.addCell(label);
		            label = new Label(8, D_Index, CTime,wff2);
		            sheet.addCell(label);
		            label = new Label(9, D_Index, Gross_Weight+Unit,wff2);
		            sheet.addCell(label);
		            label = new Label(10, D_Index, Tear_Weight+Unit,wff2);
		            sheet.addCell(label);
		            label = new Label(11, D_Index, Ture_Weight+Unit,wff2);
		            sheet.addCell(label);

		            System.out.println("���ݽ���");
				
				}	
				
				D_Index++;
	            sheet.setRowView(D_Index, 600);
	            sheet.setColumnView(D_Index,15);
	            //+Double.toString(Value_All)
	            label = new Label(0, D_Index, "ж���������ϼ�Ϊ:",wff2);
	            sheet.addCell(label);
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
	            label = new Label(11, D_Index, Double.toString(Value_All)+Unit,wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,10,D_Index);
	            System.out.println("�ϼƽ���");
	            
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
			
		} catch (Exception e) 
		{
	

		}


	}
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd) 
		{
			case 0://��ѯ
				switch(currStatus.getFunc_Sub_Id())
				{
					case 2:
						Sql = " select t.sn, t.cpm_id, t.cpm_name, t.Pre_Check, t.Pro_Check, t.Lat_Check, t.Pre_Tank_V, t.Lat_Tank_V, t.Pre_Temper, t.Lat_Temper, t.Pre_Press, t.Lat_Press, t.Pre_Weight, t.Lat_Weight, t.Unload, t.Gross_Weight, t.Tear_Weight, t.Ture_Weight, t.Trailer_No, t.Forward_Unit, t.Temper_Report, t.Arrive_Time, t.Depart_Time, t.ctime, t.order_id, t.order_value, t.value, t.value_gas, t.car_id, t.car_owner, t.operator, t.operator_name, t.memo, t.status, t.oil_ctype, t.worker, t.checker, t.checker_name, t.car_corp ,t.tank_no" +
						  	  " from view_pro_i t " +
						  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
						  	  "   and t.oil_ctype like '"+ Func_Corp_Id +"%'" +
						  	  "   and t.status like '"+ Func_Sub_Id +"%'" +
						  	  "   and t.order_id like '%"+ Func_Type_Id +"%'" +
						  	  "   order by t.ctime desc ";
						break;
					default:
						Sql = " select t.sn, t.cpm_id, t.cpm_name, t.Pre_Check, t.Pro_Check, t.Lat_Check, t.Pre_Tank_V, t.Lat_Tank_V, t.Pre_Temper, t.Lat_Temper, t.Pre_Press, t.Lat_Press, t.Pre_Weight, t.Lat_Weight, t.Unload, t.Gross_Weight, t.Tear_Weight, t.Ture_Weight, t.Trailer_No, t.Forward_Unit, t.Temper_Report, t.Arrive_Time, t.Depart_Time, t.ctime, t.order_id, t.order_value, t.value, t.value_gas, t.car_id, t.car_owner, t.operator, t.operator_name, t.memo, t.status, t.oil_ctype, t.worker, t.checker, t.checker_name, t.car_corp,t.tank_no " +
						  	  " from view_pro_i t " +
						  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
						  	  "   and t.oil_ctype like '"+ Func_Corp_Id +"%'" +
						  	  "   and t.status like '"+ Func_Sub_Id +"%'" +
						  	  "   and t.order_id like '%"+ Func_Type_Id +"%'" +
						  	  "   and t.ctime >= date_format('"+currStatus.getVecDate().get(0).toString()+"', '%Y-%m-%d %H-%i-%S')" +
						  	  "   and t.ctime <= date_format('"+currStatus.getVecDate().get(1).toString()+"', '%Y-%m-%d %H-%i-%S')" +
						  	  "   order by t.ctime desc ";
						break;
				}
				break;
				
			case 1:	//�۳���ѯ		
						Sql = " select t.sn, t.cpm_id, t.cpm_name, t.Pre_Check, t.Pro_Check, t.Lat_Check, t.Pre_Tank_V, t.Lat_Tank_V, t.Pre_Temper, t.Lat_Temper, t.Pre_Press, t.Lat_Press, t.Pre_Weight, t.Lat_Weight, t.Unload, t.Gross_Weight, t.Tear_Weight, t.Ture_Weight, t.Trailer_No, t.Forward_Unit, t.Temper_Report, t.Arrive_Time, t.Depart_Time, t.ctime, t.order_id, t.order_value, t.value, t.value_gas, t.car_id, t.car_owner, t.operator, t.operator_name, t.memo, t.status, t.oil_ctype, t.worker, t.checker, t.checker_name, t.car_corp,t.tank_no " +
						  	  " from view_pro_i t " +
						  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
						  	  " and t.oil_ctype like '"+ Func_Corp_Id +"%'" +						  	 
						  	  " and t.car_corp like '"+ Func_Type_Id +"%'" +
						  	  " and t.Forward_Unit like '"+ Func_Cpm_Id +"%'" +
						  	  " and t.ctime >= date_format('"+currStatus.getVecDate().get(0).toString()+"', '%Y-%m-%d %H-%i-%S')" +
						  	  " and t.ctime <= date_format('"+currStatus.getVecDate().get(1).toString()+"', '%Y-%m-%d %H-%i-%S')" +
						  	  " order by t.ctime desc ";					
				break;
				
			case 2://��ѯ������λ
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.Pre_Check, t.Pro_Check, t.Lat_Check, t.Pre_Tank_V, t.Lat_Tank_V, t.Pre_Temper, t.Lat_Temper, t.Pre_Press, t.Lat_Press, t.Pre_Weight, t.Lat_Weight, t.Unload, t.Gross_Weight, t.Tear_Weight, t.Ture_Weight, t.Trailer_No, t.Forward_Unit, t.Temper_Report, t.Arrive_Time, t.Depart_Time, t.ctime, t.order_id, t.order_value, t.value, t.value_gas, t.car_id, t.car_owner, t.operator, t.operator_name, t.memo, t.status, t.oil_ctype, t.worker, t.checker, t.checker_name, t.car_corp,t.tank_no " +
					  " from view_pro_i t " +
					  " GROUP BY t.Forward_Unit "+
					  " ORDER BY t.Forward_Unit DESC ";
				break;
			case 3://��ѯ������
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.Pre_Check, t.Pro_Check, t.Lat_Check, t.Pre_Tank_V, t.Lat_Tank_V, t.Pre_Temper, t.Lat_Temper, t.Pre_Press, t.Lat_Press, t.Pre_Weight, t.Lat_Weight, t.Unload, t.Gross_Weight, t.Tear_Weight, t.Ture_Weight, t.Trailer_No, t.Forward_Unit, t.Temper_Report, t.Arrive_Time, t.Depart_Time, t.ctime, t.order_id, t.order_value, t.value, t.value_gas, t.car_id, t.car_owner, t.operator, t.operator_name, t.memo, t.status, t.oil_ctype, t.worker, t.checker, t.checker_name, t.car_corp,t.tank_no " +
					  " from view_pro_i t " +
					  " GROUP BY t.car_corp   "+
					  " ORDER BY t.car_corp DESC  ";
				break;
				
			case 5:
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.Pre_Check, t.Pro_Check, t.Lat_Check, t.Pre_Tank_V, t.Lat_Tank_V, t.Pre_Temper, t.Lat_Temper, t.Pre_Press, t.Lat_Press, t.Pre_Weight, t.Lat_Weight, t.Unload, t.Gross_Weight, t.Tear_Weight, t.Ture_Weight, t.Trailer_No, t.Forward_Unit, t.Temper_Report, t.Arrive_Time, t.Depart_Time, t.ctime, t.order_id, t.order_value, t.value, t.value_gas, t.car_id, t.car_owner, t.operator, t.operator_name, t.memo, t.status, t.oil_ctype, t.worker, t.checker, t.checker_name, t.car_corp,t.tank_no " +
					  	  " from view_pro_i t " +
					  	  " where t.sn ='"+SN+"' " ;				
				break;
			
			case 10://���
				Sql = " insert into pro_i(cpm_id, Pre_Check, Pro_Check, Lat_Check, Pre_Tank_V, Lat_Tank_V, Pre_Temper, Lat_Temper, Pre_Press, Lat_Press, Pre_Weight, Lat_Weight, Unload, Gross_Weight, Tear_Weight, Ture_Weight, Trailer_No, Forward_Unit, Temper_Report, Arrive_Time, Depart_Time, ctime, order_id, order_value, value, car_id, car_owner, operator, memo, oil_ctype, worker, car_corp,tank_no)" +
					  " values('"+ Cpm_Id +"', '"+ Pre_Check +"', '"+ Pro_Check +"', '"+ Lat_Check +"', '"+ Pre_Tank_V +"', '"+ Lat_Tank_V +"', '"+ Pre_Temper +"', '"+ Lat_Temper +"','"+ Pre_Press +"', '"+ Lat_Press +"', '"+ Pre_Weight +"', '"+ Lat_Weight +"', '"+ Unload +"','"+ Gross_Weight +"', '"+ Tear_Weight +"', '"+ Ture_Weight +"', '"+ Trailer_No +"', '"+ Forward_Unit +"','"+ Temper_Report +"', '"+ Arrive_Time +"', '"+ Depart_Time +"', '"+ CTime +"', '"+ Order_Id +"', '"+ Order_Value +"', '"+ Value +"', '"+ Car_Id +"', '"+ Car_Owner +"', '"+ Operator +"', '"+ Memo +"', '"+ Oil_CType +"', '"+ Worker +"', '"+ Car_Corp +"','"+ Tank_No +"')";
				break;
			case 11://�༭
				Sql = " update pro_i t set t.status = '"+ Status +"', t.checker = '"+ Checker +"' where t.sn = '"+ SN +"' ";
				break;				
			case 12://�޸�
				Sql = " update pro_i t  set t.Arrive_Time='"+ Arrive_Time +"', t.Depart_Time='"+ Depart_Time +"', t.ctime='"+ CTime +"', t.Car_Id='"+ Car_Id +"', t.Pre_Check='"+ Pre_Check +"', t.Trailer_No='"+ Trailer_No +"', t.Pro_Check='"+ Pro_Check +"',t.Car_Owner= '"+ Car_Owner +"', t.Lat_Check='"+ Lat_Check +"', t.Pre_Weight='"+ Pre_Weight +"',t.Gross_Weight='"+ Gross_Weight +"', t.Lat_Weight='"+ Lat_Weight +"', t.Tear_Weight='"+ Tear_Weight +"', t.Value='"+ Value +"',t.Ture_Weight= '"+ Ture_Weight +"',t.Forward_Unit='"+ Forward_Unit +"', t.Car_Corp='"+ Car_Corp +"'  where t.sn = '"+ SN +"' ";				
				break;
				
			case 13://ɾ��
				Sql = " delete from pro_i where sn = '"+ SN +"' ";
				break;
				
			case 40://���ô洢����
				Sql = "{call pro_ledger_Day('" + CTime.substring(0, 10) + "')}";
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
			//2015-03-17
			setPre_Check(pRs.getString(4));
			setPro_Check(pRs.getString(5));
			setLat_Check(pRs.getString(6));
			setPre_Tank_V(pRs.getString(7));
			setLat_Tank_V(pRs.getString(8));
			setPre_Temper(pRs.getString(9));
			setLat_Temper(pRs.getString(10));
			setPre_Press(pRs.getString(11));
			setLat_Press(pRs.getString(12));
			setPre_Weight(pRs.getString(13));
			setLat_Weight(pRs.getString(14));
			setUnload(pRs.getString(15));
			setGross_Weight(pRs.getString(16));
			setTear_Weight(pRs.getString(17));
			setTure_Weight(pRs.getString(18));
			setTrailer_No(pRs.getString(19));
			setForward_Unit(pRs.getString(20));
			setTemper_Report(pRs.getString(21));
			setArrive_Time(pRs.getString(22));
			setDepart_Time(pRs.getString(23));						
			setCTime(pRs.getString(24));
			setOrder_Id(pRs.getString(25));
			setOrder_Value(pRs.getString(26));
			setValue(pRs.getString(27));
			setValue_Gas(pRs.getString(28));
			setCar_Id(pRs.getString(29));
			setCar_Owner(pRs.getString(30));
			setOperator(pRs.getString(31));
			setOperator_Name(pRs.getString(32));
			setMemo(pRs.getString(33));
			setStatus(pRs.getString(34));
			setOil_CType(pRs.getString(35));
			setWorker(pRs.getString(36));
			setChecker(pRs.getString(37));
			setChecker_Name(pRs.getString(38));
			setCar_Corp(pRs.getString(39));
			setTank_No(pRs.getString(40));
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
			setSNO(CommUtil.StrToGB2312(request.getParameter("SNO")));
			setSNT(CommUtil.StrToGB2312(request.getParameter("SNT")));
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setCpm_Name(CommUtil.StrToGB2312(request.getParameter("Cpm_Name")));
			//2015-03-17
			setPre_Check(CommUtil.StrToGB2312(request.getParameter("Pre_Check")));
			setPro_Check(CommUtil.StrToGB2312(request.getParameter("Pro_Check")));
			setLat_Check(CommUtil.StrToGB2312(request.getParameter("Lat_Check")));
			setPre_Tank_V(CommUtil.StrToGB2312(request.getParameter("Pre_Tank_V")));
			setLat_Tank_V(CommUtil.StrToGB2312(request.getParameter("Lat_Tank_V")));
			setPre_Temper(CommUtil.StrToGB2312(request.getParameter("Pre_Temper")));
			setLat_Temper(CommUtil.StrToGB2312(request.getParameter("Lat_Temper")));
			setPre_Press(CommUtil.StrToGB2312(request.getParameter("Pre_Press")));
			setLat_Press(CommUtil.StrToGB2312(request.getParameter("Lat_Press")));
			setPre_Weight(CommUtil.StrToGB2312(request.getParameter("Pre_Weight")));
			setLat_Weight(CommUtil.StrToGB2312(request.getParameter("Lat_Weight")));
			setUnload(CommUtil.StrToGB2312(request.getParameter("Unload")));
			setGross_Weight(CommUtil.StrToGB2312(request.getParameter("Gross_Weight")));
			setTear_Weight(CommUtil.StrToGB2312(request.getParameter("Tear_Weight")));
			setTure_Weight(CommUtil.StrToGB2312(request.getParameter("Ture_Weight")));
			setTrailer_No(CommUtil.StrToGB2312(request.getParameter("Trailer_No")));
			setForward_Unit(CommUtil.StrToGB2312(request.getParameter("Forward_Unit")));
			setTemper_Report(CommUtil.StrToGB2312(request.getParameter("Temper_Report")));
			setArrive_Time(CommUtil.StrToGB2312(request.getParameter("Arrive_Time")));
			setDepart_Time(CommUtil.StrToGB2312(request.getParameter("Depart_Time")));			
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOrder_Id(CommUtil.StrToGB2312(request.getParameter("Order_Id")));
			setOrder_Value(CommUtil.StrToGB2312(request.getParameter("Order_Value")));
			setValue(CommUtil.StrToGB2312(request.getParameter("Value")));
			setValue_Gas(CommUtil.StrToGB2312(request.getParameter("Value_Gas")));
			setCar_Id(CommUtil.StrToGB2312(request.getParameter("Car_Id")));
			setCar_Owner(CommUtil.StrToGB2312(request.getParameter("Car_Owner")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
			setMemo(CommUtil.StrToGB2312(request.getParameter("Memo")));
			setStatus(CommUtil.StrToGB2312(request.getParameter("Status")));
			setOil_CType(CommUtil.StrToGB2312(request.getParameter("Oil_CType")));
			setWorker(CommUtil.StrToGB2312(request.getParameter("Worker")));
			setChecker(CommUtil.StrToGB2312(request.getParameter("Checker")));
			setChecker_Name(CommUtil.StrToGB2312(request.getParameter("Checker_Name")));
			setCar_Corp(CommUtil.StrToGB2312(request.getParameter("Car_Corp")));
			setTank_No(CommUtil.StrToGB2312(request.getParameter("Tank_No")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
			
			setPre_Tank_VT(CommUtil.StrToGB2312(request.getParameter("Pre_Tank_VT")));
			setLat_Tank_VT(CommUtil.StrToGB2312(request.getParameter("Lat_Tank_VT")));
			setPre_TemperT(CommUtil.StrToGB2312(request.getParameter("Pre_TemperT")));
			setLat_TemperT(CommUtil.StrToGB2312(request.getParameter("Lat_TemperT")));
			setPre_PressT(CommUtil.StrToGB2312(request.getParameter("Pre_PressT")));
			setLat_PressT(CommUtil.StrToGB2312(request.getParameter("Lat_PressT")));
			setUnloadT(CommUtil.StrToGB2312(request.getParameter("UnloadT")));
			setFunc_Id(CommUtil.StrToGB2312(request.getParameter("Func_Id")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String SNO;
	private String SNT;
	private String Cpm_Id;
	private String Cpm_Name;
	private String CTime;
	private String Order_Id;
	private String Order_Value;
	private String Value;//
	private String Value_Gas;
	private String Car_Id;
	private String Car_Owner;
	private String Operator;
	private String Operator_Name;
	private String Memo;
	private String Status;
	private String Oil_CType;
	private String Worker;
	private String Checker;
	private String Checker_Name;
	private String Car_Corp;
	public String getTank_No() {
		return Tank_No;
	}

	public void setTank_No(String tank_No) {
		Tank_No = tank_No;
	}

	private String Tank_No;         //���޹޺�
	private String Pre_Check;   	//ж��ǰ���
	private String Pro_Check;   	//ж�����̼��
	private String Lat_Check; 		//ж������		
	private String Pre_Weight;		//ж��ǰ����
	private String Lat_Weight;		//ж��������	
	private String Gross_Weight;	//װ��ë��
	private String Tear_Weight; 	//װ��Ƥ��
	private String Ture_Weight; 	//װ������
	private String Trailer_No;  	//�ҳ�����
	private String Forward_Unit;	//������λ
	private String Temper_Report;   //���ʱ��浥��
	private String Arrive_Time;     //��վʱ��
	private String Depart_Time;     //��վʱ��
	
	
	private String Pre_Tank_V;		//1ж��ǰ����
	private String Lat_Tank_V;		//1ж�������
	private String Unload;      	//1ж���ݻ�
	private String Pre_Press; 		//1ж��ǰѹ��
	private String Lat_Press; 		//1ж����ѹ��
	private String Pre_Temper;		//1ж��ǰ�¶�
	private String Lat_Temper;		//1ж�����¶�	
	
	private String Pre_Tank_VT;		//2ж��ǰ����
	private String Lat_Tank_VT;		//2ж�������
	private String UnloadT;      	//2ж���ݻ�
	private String Pre_PressT; 		//2ж��ǰѹ��
	private String Lat_PressT; 		//2ж����ѹ��
	private String Pre_TemperT;		//2ж��ǰ�¶�
	private String Lat_TemperT;		//2ж�����¶�	
	
	
	
	
	private String Sid;
	private String Func_Sub_Id;
	private String Func_Corp_Id;
	private String Func_Type_Id;
	private String Func_Cpm_Id;
	private String  Func_Id;
	
	
	public String getSNO() {
		return SNO;
	}

	public void setSNO(String sNO) {
		SNO = sNO;
	}

	public String getSNT() {
		return SNT;
	}

	public void setSNT(String sNT) {
		SNT = sNT;
	}

	public String getFunc_Id() {
		return Func_Id;
	}

	public void setFunc_Id(String func_Id) {
		Func_Id = func_Id;
	}

	public String getPre_Tank_VT() {
		return Pre_Tank_VT;
	}

	public void setPre_Tank_VT(String pre_Tank_VT) {
		Pre_Tank_VT = pre_Tank_VT;
	}

	public String getLat_Tank_VT() {
		return Lat_Tank_VT;
	}

	public void setLat_Tank_VT(String lat_Tank_VT) {
		Lat_Tank_VT = lat_Tank_VT;
	}

	public String getUnloadT() {
		return UnloadT;
	}

	public void setUnloadT(String unloadT) {
		UnloadT = unloadT;
	}

	public String getPre_PressT() {
		return Pre_PressT;
	}

	public void setPre_PressT(String pre_PressT) {
		Pre_PressT = pre_PressT;
	}

	public String getLat_PressT() {
		return Lat_PressT;
	}

	public void setLat_PressT(String lat_PressT) {
		Lat_PressT = lat_PressT;
	}

	public String getPre_TemperT() {
		return Pre_TemperT;
	}

	public void setPre_TemperT(String pre_TemperT) {
		Pre_TemperT = pre_TemperT;
	}

	public String getLat_TemperT() {
		return Lat_TemperT;
	}

	public void setLat_TemperT(String lat_TemperT) {
		Lat_TemperT = lat_TemperT;
	}
	
	public String getFunc_Cpm_Id() {
		return Func_Cpm_Id;
	}

	public void setFunc_Cpm_Id(String func_Cpm_Id) {
		Func_Cpm_Id = func_Cpm_Id;
	}

	public String getPre_Check() {
		return Pre_Check;
	}

	public void setPre_Check(String pre_Check) {
		Pre_Check = pre_Check;
	}

	public String getPro_Check() {
		return Pro_Check;
	}

	public void setPro_Check(String pro_Check) {
		Pro_Check = pro_Check;
	}

	public String getLat_Check() {
		return Lat_Check;
	}

	public void setLat_Check(String lat_Check) {
		Lat_Check = lat_Check;
	}

	public String getPre_Tank_V() {
		return Pre_Tank_V;
	}

	public void setPre_Tank_V(String pre_Tank_V) {
		Pre_Tank_V = pre_Tank_V;
	}

	public String getLat_Tank_V() {
		return Lat_Tank_V;
	}

	public void setLat_Tank_V(String lat_Tank_V) {
		Lat_Tank_V = lat_Tank_V;
	}

	public String getPre_Temper() {
		return Pre_Temper;
	}

	public void setPre_Temper(String pre_Temper) {
		Pre_Temper = pre_Temper;
	}

	public String getLat_Temper() {
		return Lat_Temper;
	}

	public void setLat_Temper(String lat_Temper) {
		Lat_Temper = lat_Temper;
	}

	public String getPre_Press() {
		return Pre_Press;
	}

	public void setPre_Press(String pre_Press) {
		Pre_Press = pre_Press;
	}

	public String getLat_Press() {
		return Lat_Press;
	}

	public void setLat_Press(String lat_Press) {
		Lat_Press = lat_Press;
	}

	public String getPre_Weight() {
		return Pre_Weight;
	}

	public void setPre_Weight(String pre_Weight) {
		Pre_Weight = pre_Weight;
	}

	public String getLat_Weight() {
		return Lat_Weight;
	}

	public void setLat_Weight(String lat_Weight) {
		Lat_Weight = lat_Weight;
	}

	public String getUnload() {
		return Unload;
	}

	public void setUnload(String unload) {
		Unload = unload;
	}

	public String getGross_Weight() {
		return Gross_Weight;
	}

	public void setGross_Weight(String gross_Weight) {
		Gross_Weight = gross_Weight;
	}

	public String getTear_Weight() {
		return Tear_Weight;
	}

	public void setTear_Weight(String tear_Weight) {
		Tear_Weight = tear_Weight;
	}

	public String getTure_Weight() {
		return Ture_Weight;
	}

	public void setTure_Weight(String ture_Weight) {
		Ture_Weight = ture_Weight;
	}

	public String getTrailer_No() {
		return Trailer_No;
	}

	public void setTrailer_No(String trailer_No) {
		Trailer_No = trailer_No;
	}

	public String getForward_Unit() {
		return Forward_Unit;
	}

	public void setForward_Unit(String forward_Unit) {
		Forward_Unit = forward_Unit;
	}

	public String getTemper_Report() {
		return Temper_Report;
	}

	public void setTemper_Report(String temper_Report) {
		Temper_Report = temper_Report;
	}

	public String getArrive_Time() {
		return Arrive_Time;
	}

	public void setArrive_Time(String arrive_Time) {
		Arrive_Time = arrive_Time;
	}

	public String getDepart_Time() {
		return Depart_Time;
	}

	public void setDepart_Time(String depart_Time) {
		Depart_Time = depart_Time;
	}

	
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

	public String getCTime() {
		return CTime;
	}

	public void setCTime(String cTime) {
		CTime = cTime;
	}

	public String getValue() {
		return Value;
	}

	public void setValue(String value) {
		Value = value;
	}
	
	public String getValue_Gas() {
		return Value_Gas;
	}

	public void setValue_Gas(String valueGas) {
		Value_Gas = valueGas;
	}

	public String getCar_Id() {
		return Car_Id;
	}

	public void setCar_Id(String carId) {
		Car_Id = carId;
	}

	public String getCar_Owner() {
		return Car_Owner;
	}

	public void setCar_Owner(String carOwner) {
		Car_Owner = carOwner;
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

	public String getMemo() {
		return Memo;
	}

	public void setMemo(String memo) {
		Memo = memo;
	}

	public String getStatus() {
		return Status;
	}

	public void setStatus(String status) {
		Status = status;
	}
	
	public String getOil_CType() {
		return Oil_CType;
	}

	public void setOil_CType(String oilCType) {
		Oil_CType = oilCType;
	}
	
	public String getOrder_Id() {
		return Order_Id;
	}

	public void setOrder_Id(String orderId) {
		Order_Id = orderId;
	}

	public String getOrder_Value() {
		return Order_Value;
	}

	public void setOrder_Value(String orderValue) {
		Order_Value = orderValue;
	}

	public String getWorker() {
		return Worker;
	}

	public void setWorker(String worker) {
		Worker = worker;
	}

	public String getChecker() {
		return Checker;
	}

	public void setChecker(String checker) {
		Checker = checker;
	}

	public String getChecker_Name() {
		return Checker_Name;
	}

	public void setChecker_Name(String checkerName) {
		Checker_Name = checkerName;
	}

	public String getCar_Corp() {
		return Car_Corp;
	}

	public void setCar_Corp(String carCorp) {
		Car_Corp = carCorp;
	}

	public String getSid() {
		return Sid;
	}

	public void setSid(String sid) {
		Sid = sid;
	}

	public String getFunc_Sub_Id() {
		return Func_Sub_Id;
	}

	public void setFunc_Sub_Id(String funcSubId) {
		Func_Sub_Id = funcSubId;
	}

	public String getFunc_Corp_Id() {
		return Func_Corp_Id;
	}

	public void setFunc_Corp_Id(String funcCorpId) {
		Func_Corp_Id = funcCorpId;
	}

	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String funcTypeId) {
		Func_Type_Id = funcTypeId;
	}
}