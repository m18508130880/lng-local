package bean;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
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

public class ProLCrpBean extends RmiBean 
{	
	public final static long serialVersionUID = RmiBean.RMI_PRO_L_CRP;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public ProLCrpBean()
	{
		super.className = "ProLCrpBean";
	}
	
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		//msgBean = pRmi.RmiExec(21, this, 0);
		
		switch(currStatus.getFunc_Sub_Id())
		{
			case 0://�걨��
				msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
				switch(currStatus.getCmd())
				{
					case 0:
				    	request.getSession().setAttribute("Pro_L_Crp_Y_" + Sid, ((Object)msgBean.getMsg()));
				    	currStatus.setJsp("Pro_L_Crp_Y.jsp?Sid=" + Sid);
				    	
				    	//������
				    	//msgBean = pRmi.RmiExec(4, this, 0);
				    	ProOBean poBean =new ProOBean();
				    	poBean.setCpm_Id(Cpm_Id);
				    	poBean.currStatus = currStatus;
				    	msgBean = pRmi.RmiExec(6, poBean, 0);
				    	request.getSession().setAttribute("Pro_L_Crp_Y_C_" + Sid, ((Object)msgBean.getMsg()));
				    	break;
				}
				request.getSession().setAttribute("Year_" + Sid, Year);
				break;
		    case 1://�±���
		    	msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
				switch(currStatus.getCmd())
				{
					case 1:
				    	request.getSession().setAttribute("Pro_L_Crp_M_" + Sid, ((Object)msgBean.getMsg()));
				    	currStatus.setJsp("Pro_L_Crp_M.jsp?Sid=" + Sid);
				    	
				    	//������
				    	//msgBean = pRmi.RmiExec(4, this, 0);
				    	ProOBean poBean =new ProOBean();
				    	poBean.setCpm_Id(Cpm_Id);
				    	poBean.currStatus = currStatus;
				    	msgBean = pRmi.RmiExec(6, poBean, 0);
				    	request.getSession().setAttribute("Pro_L_Crp_M_C_" + Sid, ((Object)msgBean.getMsg()));
				    	
				    	//���ۼ�
				    	msgBean = pRmi.RmiExec(5, this, 0);
				    	request.getSession().setAttribute("Pro_L_Crp_M_Y_" + Sid, ((Object)msgBean.getMsg()));
				    	break;
				}
		    	request.getSession().setAttribute("Month_" + Sid, Month);
		    	request.getSession().setAttribute("Year_" + Sid, Year);
		    	break;
		    case 2://�ܱ���
		    	//�жϵ���1�������ڼ������������죬��Ϊ��һ�ܵ�һ�죬�����������
		    	String pBTime = "";
				String pETime = "";
	    		switch(Integer.parseInt(CommUtil.getWeekDayString(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01")))
	    		{
		    		case 0://������
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 1://����һ
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-07 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-07 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 2://���ڶ�
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-06 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-06 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 3://������
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-05 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-05 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 4://������
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-04 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-04 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 5://������
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-03 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-03 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 6://������
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-02 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-02 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
	    		}
	    		
	    		//�ж�pBTime�Ƿ��ڱ�����
	    		if(Integer.parseInt(pBTime.substring(5,7)) == Integer.parseInt(Month))
	    		{
	    			pBTime = pBTime.substring(0,10);
	    			pETime = pETime.substring(0,10);
	    			currStatus.setVecDate(CommUtil.getDate(pBTime, pETime));
	    		}
	    		else
	    		{
	    			pBTime = "1970-01-01";
	    			pETime = "1970-01-01";
	    			currStatus.setVecDate(CommUtil.getDate(pBTime, pETime));
	    		}
	    		
		    	msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
				switch(currStatus.getCmd())
				{
					case 2:
				    	request.getSession().setAttribute("Pro_L_Crp_W_" + Sid, ((Object)msgBean.getMsg()));
				    	currStatus.setJsp("Pro_L_Crp_W.jsp?Sid=" + Sid);
				    	
				    	//������
				    	//msgBean = pRmi.RmiExec(4, this, 0);
				    	ProOBean poBean =new ProOBean();
				    	poBean.setCpm_Id(Cpm_Id);
				    	poBean.currStatus = currStatus;
				    	msgBean = pRmi.RmiExec(6, poBean, 0);
				    	request.getSession().setAttribute("Pro_L_Crp_W_C_" + Sid, ((Object)msgBean.getMsg()));
				    	
				    	//���ۼ�
				    	msgBean = pRmi.RmiExec(5, this, 0);
				    	request.getSession().setAttribute("Pro_L_Crp_W_Y_" + Sid, ((Object)msgBean.getMsg()));
				    	break;
				}
				request.getSession().setAttribute("Month_" + Sid, Month);
		    	request.getSession().setAttribute("Year_" + Sid, Year);
				request.getSession().setAttribute("Week_" + Sid, Week);
		    	break;
		    case 3://�ձ���		    	
				switch(currStatus.getCmd())
				{
					case 12:
						DateBaoBean bao1 = new DateBaoBean();
						bao1.setCpm_Id(BCpm_Id);
						bao1.setCTime(currStatus.getVecDate().get(0).toString().substring(0,10));
						msgBean = pRmi.RmiExec(12, bao1, 0);
						msgBean = pRmi.RmiExec(11, this, 0);//ɾ����������
						request.getSession().setAttribute("Pro_L_D_" + Sid, ((Object)msgBean.getMsg()));
				    	currStatus.setJsp("Pro_L_D.jsp?Sid=" + Sid);
						break;
					case 11:
						DateBaoBean bao = new DateBaoBean();
						bao.setCpm_Id(BCpm_Id);
						bao.setCTime(currStatus.getVecDate().get(0).toString().substring(0,10));
						msgBean = pRmi.RmiExec(12, bao, 0);
						msgBean = pRmi.RmiExec(11, this, 0);//ɾ����������
					case  3:
						msgBean = pRmi.RmiExec(3, this, 0);
				    	request.getSession().setAttribute("Pro_L_Crp_D_" + Sid, ((Object)msgBean.getMsg()));
				    	currStatus.setJsp("Pro_L_Crp_D.jsp?Sid=" + Sid);
				    	
				    	//�ͻ�ͳ��
				    	PLCrmBean PLCrm = new PLCrmBean();
				    	System.out.println("����PLCrmBean");
				    	PLCrm.setCpm_Id(Cpm_Id);
				    	PLCrm.setFunc_Corp_Id(currStatus.getFunc_Corp_Id());
				    	PLCrm.setVecDa(currStatus.getVecDate());
				    	PLCrm.currStatus = currStatus;
				    	msgBean = pRmi.RmiExec(2, PLCrm, 0);
				    	request.getSession().setAttribute("Pro_L_Crp_D_Crm_" + Sid, ((Object)msgBean.getMsg()));
				    	break;
				}
		    	break;
		}
		
		//����ҵ��
    	ProRBean RBean = new ProRBean();
    	msgBean = pRmi.RmiExec(1, RBean, 0);
    	request.getSession().setAttribute("Pro_R_Buss_" + Sid, ((Object)msgBean.getMsg()));
    	
    	//��������
    	msgBean = pRmi.RmiExec(2, RBean, 0);
    	request.getSession().setAttribute("Pro_R_Type_" + Sid, ((Object)msgBean.getMsg()));
    	
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	//�걨��
	public void ExportToExcel_Y(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
			
			switch(currStatus.getFunc_Sub_Id())
			{
				case 0://�걨��
					request.getSession().setAttribute("Year_" + Sid, Year);
					break;
			    case 1://�±���
			    	break;
			    case 2://�ܱ���
			    	break;
			    case 3://�ձ���
			    	break;
			}
			
			//�����ʷ
			
			//���ɵ�ǰ
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "��˾�걨��";
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			//��˾����
			CorpInfoBean Corp_Info = (CorpInfoBean)request.getSession().getAttribute("User_Corp_Info_" + Sid);
			String D_Corp_Name = "";
			String D_Oil_Info = "";
			String D_Oil_Name = "";
			String D_Station_Info = "";
			String D_Car_Info = "";
			if(null != Corp_Info)
			{
				D_Corp_Name = Corp_Info.getCName();
				D_Oil_Info = Corp_Info.getOil_Info();
				D_Station_Info = Corp_Info.getStation_Info();
				D_Car_Info = Corp_Info.getCar_Info();
				if(null == D_Corp_Name){D_Corp_Name = "";}
				if(null == D_Station_Info){D_Station_Info = "";}
				if(null == D_Car_Info){D_Car_Info = "";}
				if(null == D_Oil_Info){D_Oil_Info = "";}
				if(null != currStatus.getFunc_Corp_Id() && D_Oil_Info.length() > 0)
				{
					String[] List = D_Oil_Info.split(";");
					for(int i=0; i<List.length && List[i].length()>0; i++)
					{
					  	String[] subList = List[i].split(",");
					  	if(currStatus.getFunc_Corp_Id().equals(subList[0]))
					  	{
					  		D_Oil_Name = subList[1];
					  		break;
					  	}
			  		}
				}
			}
			
			//�걨��
			msgBean = pRmi.RmiExec(0, this, 0);
			ArrayList<?> temp0 = (ArrayList<?>)msgBean.getMsg();
			
			//������
			//msgBean = pRmi.RmiExec(4, this, 0);
			ProOBean poBean =new ProOBean();
	    	poBean.setCpm_Id(Cpm_Id);
	    	poBean.currStatus = currStatus;
	    	msgBean = pRmi.RmiExec(6, poBean, 0);
			ArrayList<?> temp1 = (ArrayList<?>)msgBean.getMsg();
			
			//վ��
			String D_T_Cpm_Id = "";
			
			//�ϼ�
			double D_Value_O_01_All = 0.0;
			double D_Value_O_02_All = 0.0;
			double D_Value_O_03_All = 0.0;
			double D_Value_O_04_All = 0.0;
			double D_Value_O_05_All = 0.0;
			double D_Value_O_06_All = 0.0;
			double D_Value_O_07_All = 0.0;
			double D_Value_O_08_All = 0.0;
			double D_Value_O_09_All = 0.0;
			double D_Value_O_10_All = 0.0;
			double D_Value_O_11_All = 0.0;
			double D_Value_O_12_All = 0.0;
			double D_Value_O_Y_All  = 0.0;
			int D_Car_Cnt_All       = 0;
			
			//����
			int D_Index             = -1;
			if(null != temp0)
			{
				//�����ļ�
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);
	            
	            //�����ʽ1
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
				
				//�����ʽ3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);
				wf3.setColour(Colour.BLACK);//������ɫ
				wff3.setAlignment(Alignment.RIGHT);//���þ���
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ4
				WritableFont wf4 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff4 = new WritableCellFormat(wf4);
				wf4.setColour(Colour.BLACK);//������ɫ
				wff4.setAlignment(Alignment.CENTRE);//���þ���
				wff4.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ5
				WritableFont wf5 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff5 = new WritableCellFormat(wf5);
				wf5.setColour(Colour.BLACK);//������ɫ
				wff5.setAlignment(Alignment.LEFT);//���þ���
				wff5.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				wff5.setWrap(true);
				
				D_Index++;
	            sheet.setRowView(D_Index, 600);
	            sheet.setColumnView(D_Index, 20);
	            Label label = new Label(0, D_Index, D_Corp_Name + "������Ӫ�걨���ܱ�[" + D_Oil_Name + "]", wff);
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
	            label = new Label(15, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(16, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(17, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,17,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "��������: "+ Year +"��", wff3);
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
	            label = new Label(15, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(16, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(17, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,17,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);	  
	            label = new Label(0, D_Index, "����վ", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "Ͷ��ʱ��", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "��ע����(L��kg)", wff2);
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
	            sheet.mergeCells(2,D_Index,14,D_Index);
	            label = new Label(15, D_Index, "����Ӫ����", wff2);
	            sheet.addCell(label);            
	            label = new Label(16, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(15,D_Index,16,D_Index);
	            label = new Label(17, D_Index, "��ע", wff2);
	            sheet.addCell(label);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "");
	            sheet.addCell(label);	            
	            sheet.mergeCells(0,D_Index-1,0,D_Index);	            
	            label = new Label(1, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(1,D_Index-1,1,D_Index);	            
	            label = new Label(2, D_Index, "1��", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "2��", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "3��", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "4��", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "5��", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "6��", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "7��", wff2);
	            sheet.addCell(label);
	            label = new Label(9, D_Index, "8��", wff2);
	            sheet.addCell(label);
	            label = new Label(10, D_Index, "9��", wff2);
	            sheet.addCell(label);
	            label = new Label(11, D_Index, "10��", wff2);
	            sheet.addCell(label);
	            label = new Label(12, D_Index, "11��", wff2);
	            sheet.addCell(label);
	            label = new Label(13, D_Index, "12��", wff2);
	            sheet.addCell(label);           
	            label = new Label(14, D_Index, "�����ۼ�", wff2);
	            sheet.addCell(label);            
	            label = new Label(15, D_Index, "����", wff2);
	            sheet.addCell(label);
	            label = new Label(16, D_Index, "��������", wff2);
	            sheet.addCell(label);	            
	            label = new Label(17, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(17,D_Index-1,17,D_Index);
	            
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					ProLCrpBean Bean = (ProLCrpBean)iterator.next();
					String D_T_Cpm_Name  = Bean.getCpm_Name();
					String D_T_Cpm_CTime = Bean.getCpm_CTime();					
					if(!D_T_Cpm_Id.equals(Bean.getCpm_Id()))
					{			
						//��ע����
						String D_Value_O_01 = "0.00";
						String D_Value_O_02 = "0.00";
						String D_Value_O_03 = "0.00";
						String D_Value_O_04 = "0.00";
						String D_Value_O_05 = "0.00";
						String D_Value_O_06 = "0.00";
						String D_Value_O_07 = "0.00";
						String D_Value_O_08 = "0.00";
						String D_Value_O_09 = "0.00";
						String D_Value_O_10 = "0.00";
						String D_Value_O_11 = "0.00";
						String D_Value_O_12 = "0.00";
						double D_Value_O_Y  = 0.0;
						
						Iterator<?> subiter = temp0.iterator();
						while(subiter.hasNext())
						{
							ProLCrpBean subBean = (ProLCrpBean)subiter.next();
							if(subBean.getCpm_Id().equals(Bean.getCpm_Id()))
							{
								if(subBean.getCTime().equals(Year+"01"))
								{
									D_Value_O_01 = subBean.getValue_O();
								}
								if(subBean.getCTime().equals(Year+"02"))
								{
									D_Value_O_02 = subBean.getValue_O();
								}
								if(subBean.getCTime().equals(Year+"03"))
								{
									D_Value_O_03 = subBean.getValue_O();
								}
								if(subBean.getCTime().equals(Year+"04"))
								{
									D_Value_O_04 = subBean.getValue_O();
								}
								if(subBean.getCTime().equals(Year+"05"))
								{
									D_Value_O_05 = subBean.getValue_O();
								}
								if(subBean.getCTime().equals(Year+"06"))
								{
									D_Value_O_06 = subBean.getValue_O();
								}
								if(subBean.getCTime().equals(Year+"07"))
								{
									D_Value_O_07 = subBean.getValue_O();
								}
								if(subBean.getCTime().equals(Year+"08"))
								{
									D_Value_O_08 = subBean.getValue_O();
								}
								if(subBean.getCTime().equals(Year+"09"))
								{
									D_Value_O_09 = subBean.getValue_O();
								}
								if(subBean.getCTime().equals(Year+"10"))
								{
									D_Value_O_10 = subBean.getValue_O();
								}
								if(subBean.getCTime().equals(Year+"11"))
								{
									D_Value_O_11 = subBean.getValue_O();
								}
								if(subBean.getCTime().equals(Year+"12"))
								{
									D_Value_O_12 = subBean.getValue_O();
								}
							}
						}
						D_Value_O_Y = Double.parseDouble(D_Value_O_01)
			 		      		  	+ Double.parseDouble(D_Value_O_02)
			 		      		  	+ Double.parseDouble(D_Value_O_03)
			 		      		  	+ Double.parseDouble(D_Value_O_04)
			 		      		  	+ Double.parseDouble(D_Value_O_05)
			 		      		  	+ Double.parseDouble(D_Value_O_06)
			 		      		  	+ Double.parseDouble(D_Value_O_07)
			 		      		  	+ Double.parseDouble(D_Value_O_08)
			 		      		  	+ Double.parseDouble(D_Value_O_09)
			 		      		  	+ Double.parseDouble(D_Value_O_10)
			 		      		  	+ Double.parseDouble(D_Value_O_11)
			 		      		  	+ Double.parseDouble(D_Value_O_12);
						
						//�����ۼ�
						int D_Car_Cnt = 0;
						String D_Car_CType1    = "";
						String D_Car_CType2    = "";
						int    D_Car_CType_cnt = 0;
						String D_Car_CType_str = "";
						if(null != temp1)
						{
							Iterator<?> cariter = temp1.iterator();
							while(cariter.hasNext())
							{
								ProOBean carBean = (ProOBean)cariter.next();
								if(carBean.getCpm_Id().equals(Bean.getCpm_Id()))
								{
									D_Car_Cnt++;
									D_Car_CType1 += carBean.getCar_CType() + ",";
									if(!D_Car_CType2.contains(carBean.getCar_CType()))
									{
										D_Car_CType2 += carBean.getCar_CType() + ",";
									}
								}
							}
							if(D_Car_CType1.length() > 0 && D_Car_CType2.length() > 0)
							{
								String[] List = D_Car_CType2.split(",");
								for(int i=0; i<List.length; i++)
								{
									//��������
									String str_Car_Name = "";
									if(D_Car_Info.length() > 0)
									{
										String[] CarList = D_Car_Info.split(";");
										for(int k=0; k<CarList.length; k++)
										{
											String[] subCarList = CarList[k].split(",");
											if(List[i].equals(subCarList[0]))
											{
												str_Car_Name = subCarList[1];
											}
										}
									}
							
									D_Car_CType_cnt = 0;
									String[] sub_List = D_Car_CType1.split(",");
									for(int j=0; j<sub_List.length; j++)
									{
										if(List[i].equals(sub_List[j]))
										{
											D_Car_CType_cnt++;
										}
									}
									if(0 == i)
									{
										D_Car_CType_str += str_Car_Name + " " + D_Car_CType_cnt + " ��;";
									}
									else
									{
										D_Car_CType_str += "\012" + str_Car_Name + " " + D_Car_CType_cnt + " ��;";
									}								
								}
							}
						}
						
						//�ϼ�
						D_Value_O_01_All = D_Value_O_01_All + Double.parseDouble(D_Value_O_01);
						D_Value_O_02_All = D_Value_O_02_All + Double.parseDouble(D_Value_O_02);
						D_Value_O_03_All = D_Value_O_03_All + Double.parseDouble(D_Value_O_03);
						D_Value_O_04_All = D_Value_O_04_All + Double.parseDouble(D_Value_O_04);
						D_Value_O_05_All = D_Value_O_05_All + Double.parseDouble(D_Value_O_05);
						D_Value_O_06_All = D_Value_O_06_All + Double.parseDouble(D_Value_O_06);
						D_Value_O_07_All = D_Value_O_07_All + Double.parseDouble(D_Value_O_07);
						D_Value_O_08_All = D_Value_O_08_All + Double.parseDouble(D_Value_O_08);
						D_Value_O_09_All = D_Value_O_09_All + Double.parseDouble(D_Value_O_09);
						D_Value_O_10_All = D_Value_O_10_All + Double.parseDouble(D_Value_O_10);
						D_Value_O_11_All = D_Value_O_11_All + Double.parseDouble(D_Value_O_11);
						D_Value_O_12_All = D_Value_O_12_All + Double.parseDouble(D_Value_O_12);
						D_Value_O_Y_All  = D_Value_O_Y_All + D_Value_O_Y;
						D_Car_Cnt_All    = D_Car_Cnt_All + D_Car_Cnt;
						
					    D_Index++;
			            sheet.setRowView(D_Index, 400*D_Car_CType2.split(",").length);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, D_T_Cpm_Name, wff4);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, D_T_Cpm_CTime, wff4);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, D_Value_O_01, wff4);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, D_Value_O_02, wff4);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, D_Value_O_03, wff4);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, D_Value_O_04, wff4);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, D_Value_O_05, wff4);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, D_Value_O_06, wff4);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, D_Value_O_07, wff4);
			            sheet.addCell(label);
			            label = new Label(9, D_Index, D_Value_O_08, wff4);
			            sheet.addCell(label);
			            label = new Label(10, D_Index, D_Value_O_09, wff4);
			            sheet.addCell(label);
			            label = new Label(11, D_Index, D_Value_O_10, wff4);
			            sheet.addCell(label);
			            label = new Label(12, D_Index, D_Value_O_11, wff4);
			            sheet.addCell(label);
			            label = new Label(13, D_Index, D_Value_O_12, wff4);
			            sheet.addCell(label);
			            label = new Label(14, D_Index, new BigDecimal(D_Value_O_Y).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff4);
			            sheet.addCell(label);
			            label = new Label(15, D_Index, D_Car_Cnt+"", wff4);
			            sheet.addCell(label);
			            label = new Label(16, D_Index, D_Car_CType_str, wff5);
			            sheet.addCell(label);
			            label = new Label(17, D_Index, "", wff4);
			            sheet.addCell(label);
					}
					D_T_Cpm_Id = Bean.getCpm_Id();				
				}
				
				//�ϼ�
				D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "�ϼ�", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,1,D_Index);
	            label = new Label(2, D_Index, new BigDecimal(D_Value_O_01_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, new BigDecimal(D_Value_O_02_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, new BigDecimal(D_Value_O_03_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, new BigDecimal(D_Value_O_04_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, new BigDecimal(D_Value_O_05_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, new BigDecimal(D_Value_O_06_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, new BigDecimal(D_Value_O_07_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(9, D_Index, new BigDecimal(D_Value_O_08_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(10, D_Index, new BigDecimal(D_Value_O_09_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(11, D_Index, new BigDecimal(D_Value_O_10_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(12, D_Index, new BigDecimal(D_Value_O_11_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(13, D_Index, new BigDecimal(D_Value_O_12_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(14, D_Index, new BigDecimal(D_Value_O_Y_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(15, D_Index, D_Car_Cnt_All+"", wff2);
	            sheet.addCell(label);
	            label = new Label(16, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(17, D_Index, "", wff2);
	            sheet.addCell(label);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff2);
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
	            sheet.mergeCells(0,D_Index,5,D_Index);
	            label = new Label(6, D_Index, "���: " + Operator_Name, wff2);
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
	            sheet.mergeCells(6,D_Index,11,D_Index);
	            label = new Label(12, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff2);
	            sheet.addCell(label);
	            label = new Label(13, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(14, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(15, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(16, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(17, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(12,D_Index,17,D_Index);
/***************************************�걨��վ����ϸ*********************************************************************/	  
	            msgBean = pRmi.RmiExec(6, this, 0);
				ArrayList<?> temp6 = (ArrayList<?>)msgBean.getMsg();
	            if(null != temp6)
	            {
	            	Iterator it = temp6.iterator();
	            	while(it.hasNext())
	            	{
	            		ProLCrpBean pcBean = (ProLCrpBean)it.next();
	            		Cpm_Id    = pcBean.getCpm_Id();
	            		Cpm_Name  = pcBean.getCpm_Name();
	            		String psheetName =Cpm_Name+"վ";
						sheet = book.createSheet(psheetName, 1);
						
	            		ProLBean plBean = new ProLBean();
	            		plBean.setCpm_Id(Cpm_Id);
	            		plBean.setYear(Year);
	            		plBean.currStatus  = currStatus;
	            		msgBean = pRmi.RmiExec(5, plBean, 0);
	            		ArrayList<?> temp5 = (ArrayList<?>)msgBean.getMsg();	
	            		String T_Cpm_Id       = "";
	            		String T_Cpm_Name     = "";
	            		String CTime          = "";
	            		String Value_O        = "0";
	            		String Value_O_Gas    = "0";
	            		String Value_I        = "0";
	            		String Value_I_Gas    = "0";
	            		String Value_R        = "0";
	            		String Value_R_Gas    = "0";
	            		String Value_PAL        = "0";
	            		String Value_PAL_Gas    = "0";
	            		
	            		//�����ۼ�
	            		double Value_O_All     = 0.00;
	            		double Value_O_Gas_All = 0.00;
	            		double Value_I_All     = 0.00;
	            		double Value_I_Gas_All = 0.00;
	            		double Value_R_All 	   = 0.00;
	            		double Value_R_Gas_All = 0.00;
	            		double Value_PAL_All 	   = 0.00;
	            		double Value_PAL_Gas_All = 0.00;
	            		
	            		//ͳ������
	            		 D_Index            = -1;
	            		if(null != temp5)
	            		{
   		
	            			Iterator<?> iterato = temp5.iterator();
	            			while(iterato.hasNext())
	            			{
	            				ProLBean pBean = (ProLBean)iterato.next();				
	            				if(null !=pBean.getCpm_Name())
	            				{
	            					T_Cpm_Name      =   pBean.getCpm_Name();				
	            				}
	            			}
	            			D_Index++;
	                        sheet.setRowView(D_Index, 800);
	                        sheet.setColumnView(D_Index, 20);
	                        label = new Label(0, D_Index, "����վ������Ӫ�걨��[" + D_Oil_Name + "]", wff);
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
	                        sheet.mergeCells(0,D_Index,8,D_Index);
	                        
	                        D_Index++;
	                        sheet.setRowView(D_Index, 600);
	                        sheet.setColumnView(D_Index, 20);
	                        label = new Label(0, D_Index, "վ������: " + T_Cpm_Name, wff2);
	                        sheet.addCell(label);
	                        label = new Label(1, D_Index, "");
	                        sheet.addCell(label);
	                        label = new Label(2, D_Index, "");
	                        sheet.addCell(label);
	                        label = new Label(3, D_Index, "");
	                        sheet.addCell(label);
	                        label = new Label(4, D_Index, "");
	                        sheet.addCell(label);
	                        sheet.mergeCells(0,D_Index,4,D_Index);
	                        label = new Label(5, D_Index, "��������: "+ Year +"��", wff2);
	                        sheet.addCell(label);
	                        label = new Label(6, D_Index, "");
	                        sheet.addCell(label);
	                        label = new Label(7, D_Index, "");
	                        sheet.addCell(label);
	                        label = new Label(8, D_Index, "");
	                        sheet.addCell(label);
	                        sheet.mergeCells(5,D_Index,8,D_Index);
	                        		       
	                        D_Index++;
	                        sheet.setRowView(D_Index, 600);
	                        sheet.setColumnView(D_Index, 20);
	                        label = new Label(0, D_Index, "��Ŀ", wff2);
	                        sheet.addCell(label);			            
	                        label = new Label(1, D_Index, "��������", wff2);
	                        sheet.addCell(label);			   
	                        label = new Label(2, D_Index, "");
	                        sheet.addCell(label);
	                        sheet.mergeCells(1,D_Index,2,D_Index);		            
	                        label = new Label(3, D_Index, "��������", wff2);
	                        sheet.addCell(label);
	                        label = new Label(4, D_Index, "");
	                        sheet.addCell(label);
	                        sheet.mergeCells(3,D_Index,4,D_Index);			            
	                        label = new Label(5, D_Index, "�������", wff2);
	                        sheet.addCell(label);
	                        label = new Label(6, D_Index, "");
	                        sheet.addCell(label);
	                        sheet.mergeCells(5,D_Index,6,D_Index);
	                        label = new Label(7, D_Index, "ӯ������", wff2);
	                        sheet.addCell(label);
	                        label = new Label(8, D_Index, "");
	                        sheet.addCell(label);
	                        sheet.mergeCells(7,D_Index,8,D_Index);
	                        D_Index++;
	                        sheet.setRowView(D_Index, 600);
	                        sheet.setColumnView(D_Index, 20);
	                        label = new Label(0, D_Index, "����", wff2);
	                        sheet.addCell(label);
	                        
	                        switch(Integer.parseInt(currStatus.getFunc_Corp_Id()))
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
	            					label = new Label(1, D_Index, "ȼ����(L)", wff2);
	            		            sheet.addCell(label);			   
	            		            label = new Label(2, D_Index, "�ۺ�����(kg)", wff2);
	            		            sheet.addCell(label);    
	            		            label = new Label(3, D_Index, "ȼ����(L)", wff2);
	            		            sheet.addCell(label);
	            		            label = new Label(4, D_Index, "�ۺ�����(kg)", wff2);
	            		            sheet.addCell(label);        
	            		            label = new Label(5, D_Index, "ȼ����(L)", wff2);
	            		            sheet.addCell(label);
	            		            label = new Label(6, D_Index, "�ۺ�����(kg)", wff2);
	            		            sheet.addCell(label);
	            		            label = new Label(7, D_Index, "ȼ����(L)", wff2);
	            		            sheet.addCell(label);
	            		            label = new Label(8, D_Index, "�ۺ�����(kg)", wff2);
	            		            sheet.addCell(label);
	            					break;
	            				case 3001://CNG
	            				case 3002://LNG
	            					label = new Label(1, D_Index, "ȼ����(kg)", wff2);
	            		            sheet.addCell(label);			   
	            		            label = new Label(2, D_Index, "�ۺ���̬(m3)", wff2);
	            		            sheet.addCell(label);    
	            		            label = new Label(3, D_Index, "ȼ����(kg)", wff2);
	            		            sheet.addCell(label);
	            		            label = new Label(4, D_Index, "�ۺ���̬(m3)", wff2);
	            		            sheet.addCell(label);        
	            		            label = new Label(5, D_Index, "ȼ����(kg)", wff2);
	            		            sheet.addCell(label);
	            		            label = new Label(6, D_Index, "�ۺ���̬(m3)", wff2);
	            		            sheet.addCell(label);
	            		            label = new Label(7, D_Index, "ȼ����(kg)", wff2);
	            		            sheet.addCell(label);
	            		            label = new Label(8, D_Index, "�ۺ���̬(m3)", wff2);
	            		            sheet.addCell(label);
	            					break;
	            			}
	                             System.out.println("��ͷ����");    
	                        Iterator<?> iter = temp5.iterator();
	            			while(iter.hasNext())
	            			{	
	            				ProLBean pBean = (ProLBean)iter.next();	
	            				if( !T_Cpm_Id.equals(pBean.getCpm_Id()));
	            				{
	            					CTime 			= 	pBean.getCTime();				
	            					Value_O 		= 	pBean.getValue_O();
	            					Value_O_Gas 	= 	pBean.getValue_O_Gas();
	            					Value_I 		= 	pBean.getValue_I();
	            					Value_I_Gas 	= 	pBean.getValue_I_Gas();
	            					Value_R 		= 	pBean.getValue_R();
	            					Value_R_Gas 	= 	pBean.getValue_R_Gas();
	            					Value_PAL 		= 	pBean.getValue_PAL();
	            					Value_PAL_Gas 	= 	pBean.getValue_PAL_Gas();
	            					if(null !=Value_O)
	            					{
	            						Value_O_All     = 	Value_O_All + Double.parseDouble(Value_O);						
	            					}else{Value_O = "0.00";}
	            					if(null !=Value_O_Gas)
	            					{
	            						Value_O_Gas_All = 	Value_O_Gas_All + Double.parseDouble(Value_O_Gas);
	            					}else{Value_O_Gas = "0.00";}
	            					if(null !=Value_I)
	            					{
	            						Value_I_All     = 	Value_I_All + Double.parseDouble(Value_I);
	            					}else{Value_I = "0.00";}
	            					if(null !=Value_I_Gas)
	            					{
	            						Value_I_Gas_All = 	Value_I_Gas_All + Double.parseDouble(Value_I_Gas);
	            					}else{Value_I_Gas = "0.00";}
	            					if(null !=Value_R)
	            					{
	            						Value_R_All     = 	Value_R_All + Double.parseDouble(Value_R);
	            					}else{Value_R = "0.00";}
	            					if(null !=Value_R_Gas)
	            					{
	            						Value_R_Gas_All = 	Value_R_Gas_All + Double.parseDouble(Value_R_Gas);
	            					}else{Value_R_Gas = "0.00";}
	            					if(null !=Value_PAL)
	            					{
	            						Value_PAL_All     = 	Value_PAL_All + Double.parseDouble(Value_PAL);
	            					}else{Value_PAL = "0.00";}
	            					if(null !=Value_PAL_Gas)
	            					{
	            						Value_PAL_Gas_All = 	Value_PAL_Gas_All + Double.parseDouble(Value_PAL_Gas);
	            					}else{Value_PAL_Gas = "0.00";}
	            					//Value_O_All     = 	Value_O_All + Double.parseDouble(Value_O);
	            					//Value_O_Gas_All = 	Value_O_Gas_All + Double.parseDouble(Value_O_Gas);
	            					//Value_I_All     = 	Value_I_All + Double.parseDouble(Value_I);
	            					//Value_I_Gas_All = 	Value_I_Gas_All + Double.parseDouble(Value_I_Gas);
	            					//Value_R_All     = 	Value_R_All + Double.parseDouble(Value_R);
	            					//Value_R_Gas_All = 	Value_R_Gas_All + Double.parseDouble(Value_R_Gas);
	            					
	            					D_Index++;
	            		            sheet.setRowView(D_Index, 600);
	            		            sheet.setColumnView(D_Index, 20);
	            		            Label labe2 = new Label(0, D_Index, Integer.parseInt(CTime.substring(4,6))+"", wff3);
	            		            sheet.addCell(labe2);
	            		            labe2 = new Label(1, D_Index, Value_O, wff3);
	            		            sheet.addCell(labe2);			   
	            		            labe2 = new Label(2, D_Index, Value_O_Gas, wff3);
	            		            sheet.addCell(labe2);    
	            		            labe2 = new Label(3, D_Index, Value_I, wff3);
	            		            sheet.addCell(labe2);
	            		            labe2 = new Label(4, D_Index, Value_I_Gas, wff3);
	            		            sheet.addCell(labe2);        
	            		            labe2 = new Label(5, D_Index, Value_R, wff3);
	            		            sheet.addCell(labe2);
	            		            labe2 = new Label(6, D_Index, Value_R_Gas, wff3);
	            		            sheet.addCell(labe2);
	            		            labe2 = new Label(7, D_Index, Value_PAL, wff3);
	            		            sheet.addCell(labe2);
	            		            labe2 = new Label(8, D_Index, Value_PAL_Gas, wff3);
	            		            sheet.addCell(labe2);
	            				}
	            			}
	            			D_Index++;
	            			sheet.setRowView(D_Index, 600);
	            			sheet.setColumnView(D_Index, 20);
	            			Label labe3 = new Label(0, D_Index, "�����ۼ�", wff2);
	                        sheet.addCell(labe3);
	                        labe3 = new Label(1, D_Index, (new BigDecimal(Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
	                        sheet.addCell(labe3);
	                        labe3 = new Label(2, D_Index, (new BigDecimal(Value_O_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
	                        sheet.addCell(labe3);
	                        labe3 = new Label(3, D_Index, (new BigDecimal(Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
	                        sheet.addCell(labe3);
	                        labe3 = new Label(4, D_Index, (new BigDecimal(Value_I_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
	                        sheet.addCell(labe3);
	                        labe3 = new Label(5, D_Index, (new BigDecimal(Value_R_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
	                        sheet.addCell(labe3);
	                        labe3 = new Label(6, D_Index, (new BigDecimal(Value_R_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
	                        sheet.addCell(labe3);
	                        labe3 = new Label(7, D_Index, (new BigDecimal(Value_PAL_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
	                        sheet.addCell(labe3);
	                        labe3 = new Label(8, D_Index, (new BigDecimal(Value_PAL_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
	                        sheet.addCell(labe3);	
	            		
	            		}
	            	}	            	
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
	
	//�±���
	public void ExportToExcel_M(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone)
	{
		try
		{
			
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
			
			switch(currStatus.getFunc_Sub_Id())
			{
				case 0://�걨��
					break;
			    case 1://�±���
			    	request.getSession().setAttribute("Month_" + Sid, Month);
			    	request.getSession().setAttribute("Year_" + Sid, Year);
			    	break;
			    case 2://�ܱ���
			    	break;
			    case 3://�ձ���
			    	break;
			}
			
			//�����ʷ
			
			//���ɵ�ǰ
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "��˾�ܱ�";
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			//��˾����
			CorpInfoBean Corp_Info = (CorpInfoBean)request.getSession().getAttribute("User_Corp_Info_" + Sid);
			String D_Corp_Name = "";
			String D_Oil_Info = "";
			String D_Oil_Name = "";
			String D_Station_Info = "";
			String D_Car_Info = "";
			if(null != Corp_Info)
			{	
				D_Corp_Name = Corp_Info.getCName();
				D_Oil_Info = Corp_Info.getOil_Info();
				D_Station_Info = Corp_Info.getStation_Info();
				D_Car_Info = Corp_Info.getCar_Info();
				if(null == D_Corp_Name){D_Corp_Name = "";}
				if(null == D_Oil_Info){D_Oil_Info = "";}
				if(null == D_Station_Info){D_Station_Info = "";}
				if(null == D_Car_Info){D_Car_Info = "";}
				if(null != currStatus.getFunc_Corp_Id() && D_Oil_Info.length() > 0)
				{
					String[] List = D_Oil_Info.split(";");
					for(int i=0; i<List.length && List[i].length()>0; i++)
					{
					  	String[] subList = List[i].split(",");
					  	if(currStatus.getFunc_Corp_Id().equals(subList[0]))
					  	{
					  		D_Oil_Name = subList[1];
					  		break;
					  	}
			  		}
				}
			}
			
			//�±���
			msgBean = pRmi.RmiExec(1, this, 0);
			ArrayList<?> temp0 = (ArrayList<?>)msgBean.getMsg();
			
			//������
			//msgBean = pRmi.RmiExec(4, this, 0);
			ProOBean poBean =new ProOBean();
	    	poBean.setCpm_Id(Cpm_Id);
	    	poBean.currStatus = currStatus;
	    	msgBean = pRmi.RmiExec(6, poBean, 0);
			ArrayList<?> temp1 = (ArrayList<?>)msgBean.getMsg();
			
			//���ۼ�
			msgBean = pRmi.RmiExec(5, this, 0);
			ArrayList<?> temp2 = (ArrayList<?>)msgBean.getMsg();
			double D_Value_O_All   = 0.0;
			double D_Value_O_Y_All = 0.0;
			int D_Car_Cnt_All      = 0;
			int D_cnt              = 0;
			int D_Index            = -1;
			Label label            = null;
			if(null != temp0)
			{
				//�����ļ�
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);
	            
	            //�����ʽ1
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
				
				//�����ʽ3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);
				wf3.setColour(Colour.BLACK);//������ɫ
				wff3.setAlignment(Alignment.RIGHT);//���þ���
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ4
				WritableFont wf4 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff4 = new WritableCellFormat(wf4);
				wf4.setColour(Colour.BLACK);//������ɫ
				wff4.setAlignment(Alignment.CENTRE);//���þ���
				wff4.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ5
				WritableFont wf5 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff5 = new WritableCellFormat(wf5);
				wf5.setColour(Colour.BLACK);//������ɫ
				wff5.setAlignment(Alignment.LEFT);//���þ���
				wff5.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				wff5.setWrap(true);
				
				D_Index++;
	            sheet.setRowView(D_Index, 600);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, D_Corp_Name + "������Ӫ�±����ܱ�[" + D_Oil_Name + "]", wff);
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
	            sheet.mergeCells(0,D_Index,8,D_Index);
				
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "��������: " + Year + "��" + Month + "��", wff3);
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
	            sheet.mergeCells(0,D_Index,8,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "վ��", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "����վ", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(1,D_Index,3,D_Index);
	            label = new Label(4, D_Index, "��������(L��kg)", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(4,D_Index,5,D_Index);
	            label = new Label(6, D_Index, "����Ӫ����", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(6,D_Index,7,D_Index);
	            label = new Label(8, D_Index, "��ע", wff2);
	            sheet.addCell(label);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "վ����", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "Ͷ��ʱ��", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "վ����", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "�����ۼ�", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "�����ۼ�", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "������", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "��������", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index-1,0,D_Index);
	            sheet.mergeCells(8,D_Index-1,8,D_Index);
	            
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					ProLCrpBean Bean = (ProLCrpBean)iterator.next();
					D_cnt++;
					String D_Cpm_Id    = Bean.getCpm_Id();
					String D_Cpm_Name  = Bean.getCpm_Name();
					String D_Cpm_CTime = Bean.getCpm_CTime();
					String D_Cpm_CType = Bean.getCpm_CType();
					String D_Value_O   = Bean.getValue_O();
					String D_str_Cpm_CType = "��";
					if(null != D_Cpm_CType && D_Station_Info.length() > 0)
					{
						String[] StationList = D_Station_Info.split(",");
						for(int i=0; i<StationList.length; i++)
						{
				    	if(D_Cpm_CType.equals(CommUtil.IntToStringLeftFillZero(i+1, 4)))
				    	{
						  	D_str_Cpm_CType = StationList[i];
						  }
						}
					}
					
					//�����ۼ�
					String D_Value_O_Y = "0";
					if(null != temp2)
					{
						Iterator<?> yeariter = temp2.iterator();
						while(yeariter.hasNext())
						{
							ProLCrpBean yearBean = (ProLCrpBean)yeariter.next();
							if(yearBean.getCpm_Id().equals(D_Cpm_Id))
							{
								D_Value_O_Y = yearBean.getValue_O();
							}
						}
					}
					
					//�����ۼ�
					int D_Car_Cnt = 0;
					String D_Car_CType1    = "";
					String D_Car_CType2    = "";
					int    D_Car_CType_cnt = 0;
					String D_Car_CType_str = "";
					if(null != temp1)
					{
						Iterator<?> cariter = temp1.iterator();
						while(cariter.hasNext())
						{
							ProOBean carBean = (ProOBean)cariter.next();
							if(carBean.getCpm_Id().equals(D_Cpm_Id))
							{
								D_Car_Cnt++;
								D_Car_CType1 += carBean.getCar_CType() + ",";
								if(!D_Car_CType2.contains(carBean.getCar_CType()))
								{
									D_Car_CType2 += carBean.getCar_CType() + ",";
								}
							}
						}
						if(D_Car_CType1.length() > 0 && D_Car_CType2.length() > 0)
						{
							String[] List = D_Car_CType2.split(",");
							for(int i=0; i<List.length; i++)
							{
								//��������
								String str_Car_Name = "";
								if(D_Car_Info.length() > 0)
								{
									String[] CarList = D_Car_Info.split(";");
									for(int k=0; k<CarList.length; k++)
									{
										String[] subCarList = CarList[k].split(",");
										if(List[i].equals(subCarList[0]))
										{
											str_Car_Name = subCarList[1];
										}
									}
								}
						
								D_Car_CType_cnt = 0;
								String[] sub_List = D_Car_CType1.split(",");
								for(int j=0; j<sub_List.length; j++)
								{
									if(List[i].equals(sub_List[j]))
									{
										D_Car_CType_cnt++;
									}
								}
								if(0 == i)
								{
									D_Car_CType_str += str_Car_Name + " " + D_Car_CType_cnt + " ��;";
								}
								else
								{
									D_Car_CType_str += "\012" + str_Car_Name + " " + D_Car_CType_cnt + " ��;";
								}								
							}
						}
					}
					
					//�ϼ�
					D_Value_O_All   = D_Value_O_All + Double.parseDouble(D_Value_O);
					D_Value_O_Y_All = D_Value_O_Y_All + Double.parseDouble(D_Value_O_Y);
					D_Car_Cnt_All   = D_Car_Cnt_All + D_Car_Cnt;
					
					D_Index++;
		            sheet.setRowView(D_Index, 400*D_Car_CType2.split(",").length);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, D_Cpm_Id, wff4);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, D_Cpm_Name, wff4);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, D_Cpm_CTime, wff4);
		            sheet.addCell(label);
		            label = new Label(3, D_Index, D_str_Cpm_CType, wff4);
		            sheet.addCell(label);
		            label = new Label(4, D_Index, D_Value_O, wff4);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, D_Value_O_Y, wff4);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, D_Car_Cnt+"", wff4);
		            sheet.addCell(label);
		            label = new Label(7, D_Index, D_Car_CType_str, wff5);
		            sheet.addCell(label);
		            label = new Label(8, D_Index, "", wff4);
		            sheet.addCell(label);
				}
				
				D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "�ϼ�", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, D_cnt+"", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "/", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "/", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, new BigDecimal(D_Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, new BigDecimal(D_Value_O_Y_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, D_Car_Cnt_All+"", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "", wff2);
	            sheet.addCell(label);
				
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,2,D_Index);
	            label = new Label(3, D_Index, "���: " + Operator_Name, wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(3,D_Index,5,D_Index);
	            label = new Label(6, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(6,D_Index,8,D_Index);
	            
	            
/***********************************��վ��ϸ**********************************************************/
	            ProLBean pBean = new ProLBean();
	            if(null != temp0)
	            {
	            	Iterator<?> tit = temp0.iterator();
	            	int  st = 1;
	            	
					while(tit.hasNext())
					{						
						//st++;
						ProLCrpBean pcBean = (ProLCrpBean)tit.next();
						String P_Cpm_Name = pcBean.getCpm_Name();
						String psheetName =P_Cpm_Name+"վ";
						
						ProLBean plBean = new ProLBean();
						plBean.setCpm_Id(pcBean.getCpm_Id());
						plBean.currStatus = currStatus;
						msgBean = pRmi.RmiExec(0, plBean, 0);
						ArrayList<?> tempa = (ArrayList<?>)msgBean.getMsg();

						//���ۼ�
						msgBean = pRmi.RmiExec(1, plBean, 0);
						ArrayList<?> tempb = (ArrayList<?>)msgBean.getMsg();
						sheet = book.createSheet(psheetName, st);
						String D_T_Cpm_Id       = "";
						String D_T_Cpm_Name     = "";
						String D_CTime          = "";
						String D_Value_O        = "0";
						String D_Value_O_Gas    = "0";
						String D_Value_I        = "0";
						String D_Value_I_Gas    = "0";
						String D_Value_R        = "0";
						String D_Value_R_Gas    = "0";
							
						//�����ۼ�
						double P_Value_O_All     = 0.0;
						double P_Value_O_Gas_All = 0.0;
						double P_Value_I_All     = 0.0;
						double P_Value_I_Gas_All = 0.0;
						
						//�����ۼ�
						String D_Value_O_Y     = "0";
						String D_Value_O_Gas_Y = "0";
						String D_Value_I_Y     = "0";
						String D_Value_I_Gas_Y = "0";
						//String D_Value_R_Y     = "0";
						//String D_Value_R_Gas_Y = "0";
						
						//ͳ������
						int P_cnt              = 0;
						
						//����
						 D_Index            = -1;
						
						if(null != tempa)
						{							
							
							Iterator<?> itt = tempa.iterator();
							while(itt.hasNext())
							{
								ProLBean Bean = (ProLBean)itt.next();
								P_cnt++;
								if(!D_T_Cpm_Id.equals(Bean.getCpm_Id()))
								{
									if(D_T_Cpm_Id.length() > 0)
									{
										//�����ۼ�
										if(null != tempb)
										{
											Iterator<?> yeariter = tempb.iterator();
											while(yeariter.hasNext())
											{
												ProLBean yearBean = (ProLBean)yeariter.next();
												if(D_T_Cpm_Id.equals(yearBean.getCpm_Id()))
												{
													D_Value_O_Y = yearBean.getValue_O();
													D_Value_O_Gas_Y = yearBean.getValue_O_Gas();
													D_Value_I_Y = yearBean.getValue_I();
													D_Value_I_Gas_Y = yearBean.getValue_I_Gas();
												}
											}
										}
										
										D_Index++;
										sheet.setRowView(D_Index, 400);
										sheet.setColumnView(D_Index, 12);
										label = new Label(0, D_Index, "�����ۼ�", wff2);
							            sheet.addCell(label);
							            label = new Label(1, D_Index, (new BigDecimal(P_Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
							            sheet.addCell(label);
							            label = new Label(2, D_Index, (new BigDecimal(P_Value_O_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
							            sheet.addCell(label);
							            label = new Label(3, D_Index, (new BigDecimal(P_Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
							            sheet.addCell(label);
							            label = new Label(4, D_Index, (new BigDecimal(P_Value_I_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
							            sheet.addCell(label);
							            label = new Label(5, D_Index, "", wff2);
							            sheet.addCell(label);
							            label = new Label(6, D_Index, "", wff2);
							            sheet.addCell(label);
							            			            
							            D_Index++;
							            sheet.setRowView(D_Index, 400);
							            sheet.setColumnView(D_Index, 12);
							            label = new Label(0, D_Index, "�����ۼ�", wff2);
							            sheet.addCell(label);
							            label = new Label(1, D_Index, D_Value_O_Y, wff2);
							            sheet.addCell(label);
							            label = new Label(2, D_Index, D_Value_O_Gas_Y, wff2);
							            sheet.addCell(label);
							            label = new Label(3, D_Index, D_Value_I_Y, wff2);
							            sheet.addCell(label);
							            label = new Label(4, D_Index, D_Value_I_Gas_Y, wff2);
							            sheet.addCell(label);
							            label = new Label(5, D_Index, "", wff2);
							            sheet.addCell(label);
							            label = new Label(6, D_Index, "", wff2);
							            sheet.addCell(label);
							            
							            D_Index++;
							            sheet.setRowView(D_Index, 400);
							            sheet.setColumnView(D_Index, 12);
							            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff2);
							            sheet.addCell(label);
							            label = new Label(1, D_Index, "", wff4);
							            sheet.addCell(label);
							            sheet.mergeCells(0,D_Index,1,D_Index);
							            label = new Label(2, D_Index, "���: " + Operator_Name, wff2);
							            sheet.addCell(label);
							            label = new Label(3, D_Index, "", wff4);
							            sheet.addCell(label);
							            sheet.mergeCells(2,D_Index,3,D_Index);
							            label = new Label(4, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff2);
							            sheet.addCell(label);
							            label = new Label(5, D_Index, "", wff4);
							            sheet.addCell(label);
							            label = new Label(6, D_Index, "", wff4);
							            sheet.addCell(label);
							            sheet.mergeCells(4,D_Index,6,D_Index);
							            
										P_Value_O_All = 0;
										P_Value_O_Gas_All = 0;
										P_Value_I_All = 0;
										P_Value_I_Gas_All = 0;	
									}
									
									D_T_Cpm_Name = Bean.getCpm_Name();
									D_CTime = Bean.getCTime();
									D_Value_O = Bean.getValue_O();
									D_Value_O_Gas = Bean.getValue_O_Gas();
									D_Value_I = Bean.getValue_I();
									D_Value_I_Gas = Bean.getValue_I_Gas();
									D_Value_R = Bean.getValue_R();
									D_Value_R_Gas = Bean.getValue_R_Gas();
									
									P_Value_O_All     = P_Value_O_All + Double.parseDouble(D_Value_O);
									P_Value_O_Gas_All = P_Value_O_Gas_All + Double.parseDouble(D_Value_O_Gas);
									P_Value_I_All     = P_Value_I_All + Double.parseDouble(D_Value_I);
									P_Value_I_Gas_All = P_Value_I_Gas_All + Double.parseDouble(D_Value_I_Gas);
									
									D_Index++;
						            sheet.setRowView(D_Index, 600);
						            sheet.setColumnView(D_Index, 12);
						            label = new Label(0, D_Index, "LNG��עվ������Ӫ�±���", wff);
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
						            
						            D_Index++;
						            sheet.setRowView(D_Index, 400);
						            sheet.setColumnView(D_Index, 12);
						            label = new Label(0, D_Index, "վ������: " + D_T_Cpm_Name, wff2);
						            sheet.addCell(label);
						            label = new Label(1, D_Index, "");
						            sheet.addCell(label);
						            label = new Label(2, D_Index, "");
						            sheet.addCell(label);
						            label = new Label(3, D_Index, "");
						            sheet.addCell(label);
						            sheet.mergeCells(0,D_Index,3,D_Index);
						            label = new Label(4, D_Index, "��������: "+ Year +"��"+ Month +"��", wff2);
						            sheet.addCell(label);
						            label = new Label(5, D_Index, "");
						            sheet.addCell(label);
						            label = new Label(6, D_Index, "");
						            sheet.addCell(label);
						            sheet.mergeCells(4,D_Index,6,D_Index);
						            		       
						            D_Index++;
						            sheet.setRowView(D_Index, 400);
						            sheet.setColumnView(D_Index, 12);
						            label = new Label(0, D_Index, "����", wff2);
						            sheet.addCell(label);			            
						            label = new Label(1, D_Index, "��������", wff2);
						            sheet.addCell(label);			   
						            label = new Label(2, D_Index, "");
						            sheet.addCell(label);
						            sheet.mergeCells(1,D_Index,2,D_Index);		            
						            label = new Label(3, D_Index, "��������", wff2);
						            sheet.addCell(label);
						            label = new Label(4, D_Index, "");
						            sheet.addCell(label);
						            sheet.mergeCells(3,D_Index,4,D_Index);			            
						            label = new Label(5, D_Index, "�������", wff2);
						            sheet.addCell(label);
						            label = new Label(6, D_Index, "");
						            sheet.addCell(label);
						            sheet.mergeCells(5,D_Index,6,D_Index);
						            
						            D_Index++;
						            sheet.setRowView(D_Index, 400);
						            sheet.setColumnView(D_Index, 12);
						            label = new Label(0, D_Index, " ", wff2);
						            sheet.addCell(label);
						            sheet.mergeCells( 0 , 2 , 0 , 3 );  
						            switch(Integer.parseInt(currStatus.getFunc_Corp_Id()))
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
											label = new Label(1, D_Index, "ȼ����(L)", wff2);
								            sheet.addCell(label);			   
								            label = new Label(2, D_Index, "�ۺ�����(kg)", wff2);
								            sheet.addCell(label);    
								            label = new Label(3, D_Index, "ȼ����(L)", wff2);
								            sheet.addCell(label);
								            label = new Label(4, D_Index, "�ۺ�����(kg)", wff2);
								            sheet.addCell(label);        
								            label = new Label(5, D_Index, "ȼ����(L)", wff2);
								            sheet.addCell(label);
								            label = new Label(6, D_Index, "�ۺ�����(kg)", wff2);
								            sheet.addCell(label);
											break;
										case 3001://CNG
										case 3002://LNG
											label = new Label(1, D_Index, "ȼ����(kg)", wff2);
								            sheet.addCell(label);			   
								            label = new Label(2, D_Index, "�ۺ���̬(m3)", wff2);
								            sheet.addCell(label);    
								            label = new Label(3, D_Index, "ȼ����(kg)", wff2);
								            sheet.addCell(label);
								            label = new Label(4, D_Index, "�ۺ���̬(m3)", wff2);
								            sheet.addCell(label);        
								            label = new Label(5, D_Index, "ȼ����(kg)", wff2);
								            sheet.addCell(label);
								            label = new Label(6, D_Index, "�ۺ���̬(m3)", wff2);
								            sheet.addCell(label);
											break;
									}		            
						            
						            D_Index++;
						            sheet.setRowView(D_Index, 400);
						            sheet.setColumnView(D_Index, 12);
						            label = new Label(0, D_Index, Integer.parseInt(D_CTime.substring(8,10))+"", wff3);
						            sheet.addCell(label);
						            label = new Label(1, D_Index, D_Value_O, wff3);
						            sheet.addCell(label);			   
						            label = new Label(2, D_Index, D_Value_O_Gas, wff3);
						            sheet.addCell(label);    
						            label = new Label(3, D_Index, D_Value_I, wff3);
						            sheet.addCell(label);
						            label = new Label(4, D_Index, D_Value_I_Gas, wff3);
						            sheet.addCell(label);        
						            label = new Label(5, D_Index, D_Value_R, wff3);
						            sheet.addCell(label);
						            label = new Label(6, D_Index, D_Value_R_Gas, wff3);
						            sheet.addCell(label);						
								}
								else
								{
									D_T_Cpm_Name = Bean.getCpm_Name();
									D_CTime = Bean.getCTime();
									D_Value_O = Bean.getValue_O();
									D_Value_O_Gas = Bean.getValue_O_Gas();
									D_Value_I = Bean.getValue_I();
									D_Value_I_Gas = Bean.getValue_I_Gas();
									D_Value_R = Bean.getValue_R();
									D_Value_R_Gas = Bean.getValue_R_Gas();
									
									P_Value_O_All     = P_Value_O_All + Double.parseDouble(D_Value_O);
									P_Value_O_Gas_All = P_Value_O_Gas_All + Double.parseDouble(D_Value_O_Gas);
									P_Value_I_All     = P_Value_I_All + Double.parseDouble(D_Value_I);
									P_Value_I_Gas_All = P_Value_I_Gas_All + Double.parseDouble(D_Value_I_Gas);
									
									D_Index++;
						            sheet.setRowView(D_Index, 400);
						            sheet.setColumnView(D_Index, 12);
						            label = new Label(0, D_Index, Integer.parseInt(D_CTime.substring(8,10))+"", wff3);
						            sheet.addCell(label);
						            label = new Label(1, D_Index, D_Value_O, wff3);
						            sheet.addCell(label);			   
						            label = new Label(2, D_Index, D_Value_O_Gas, wff3);
						            sheet.addCell(label);    
						            label = new Label(3, D_Index, D_Value_I, wff3);
						            sheet.addCell(label);
						            label = new Label(4, D_Index, D_Value_I_Gas, wff3);
						            sheet.addCell(label);        
						            label = new Label(5, D_Index, D_Value_R, wff3);
						            sheet.addCell(label);
						            label = new Label(6, D_Index, D_Value_R_Gas, wff3);
						            sheet.addCell(label);			
								}
								D_T_Cpm_Id = Bean.getCpm_Id();
								if(P_cnt == tempa.size())
								{
									//�����ۼ�
									if(null != tempb)
									{
										Iterator<?> yeariter = tempb.iterator();
										while(yeariter.hasNext())
										{
											ProLBean yearBean = (ProLBean)yeariter.next();
											if(D_T_Cpm_Id.equals(yearBean.getCpm_Id()))
											{
												D_Value_O_Y = yearBean.getValue_O();
												D_Value_O_Gas_Y = yearBean.getValue_O_Gas();
												D_Value_I_Y = yearBean.getValue_I();
												D_Value_I_Gas_Y = yearBean.getValue_I_Gas();
											}
										}
									}
									
									D_Index++;
									sheet.setRowView(D_Index, 400);
									sheet.setColumnView(D_Index, 12);
									label = new Label(0, D_Index, "�����ۼ�", wff2);
						            sheet.addCell(label);
						            label = new Label(1, D_Index, (new BigDecimal(P_Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
						            sheet.addCell(label);
						            label = new Label(2, D_Index, (new BigDecimal(P_Value_O_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
						            sheet.addCell(label);
						            label = new Label(3, D_Index, (new BigDecimal(P_Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
						            sheet.addCell(label);
						            label = new Label(4, D_Index, (new BigDecimal(P_Value_I_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
						            sheet.addCell(label);
						            label = new Label(5, D_Index, "", wff2);
						            sheet.addCell(label);
						            label = new Label(6, D_Index, "", wff2);
						            sheet.addCell(label);
						            			            
						            D_Index++;
						            sheet.setRowView(D_Index, 400);
						            sheet.setColumnView(D_Index, 12);
						            label = new Label(0, D_Index, "�����ۼ�", wff2);
						            sheet.addCell(label);
						            label = new Label(1, D_Index, D_Value_O_Y, wff2);
						            sheet.addCell(label);
						            label = new Label(2, D_Index, D_Value_O_Gas_Y, wff2);
						            sheet.addCell(label);
						            label = new Label(3, D_Index, D_Value_I_Y, wff2);
						            sheet.addCell(label);
						            label = new Label(4, D_Index, D_Value_I_Gas_Y, wff2);
						            sheet.addCell(label);
						            label = new Label(5, D_Index, "", wff2);
						            sheet.addCell(label);
						            label = new Label(6, D_Index, "", wff2);
						            sheet.addCell(label);
						            
						            D_Index++;
						            sheet.setRowView(D_Index, 400);
						            sheet.setColumnView(D_Index, 12);
						            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff2);
						            sheet.addCell(label);
						            label = new Label(1, D_Index, "", wff4);
						            sheet.addCell(label);
						            sheet.mergeCells(0,D_Index,1,D_Index);
						            label = new Label(2, D_Index, "���: " + Operator_Name, wff2);
						            sheet.addCell(label);
						            label = new Label(3, D_Index, "", wff4);
						            sheet.addCell(label);
						            sheet.mergeCells(2,D_Index,3,D_Index);
						            label = new Label(4, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff2);
						            sheet.addCell(label);
						            label = new Label(5, D_Index, "", wff4);
						            sheet.addCell(label);
						            label = new Label(6, D_Index, "", wff4);
						            sheet.addCell(label);
						            sheet.mergeCells(4,D_Index,6,D_Index);
								
							
					
					
								}
								}
							}
						}
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
	
	//�ܱ���
	public void ExportToExcel_W(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
			
			switch(currStatus.getFunc_Sub_Id())
			{
				case 0://�걨��
					break;
			    case 1://�±���
			    	break;
			    case 2://�ܱ���
			    	request.getSession().setAttribute("Week_" + Sid, Week);
			    	request.getSession().setAttribute("Month_" + Sid, Month);
			    	request.getSession().setAttribute("Year_" + Sid, Year);
			    	break;
			    case 3://�ձ���
			    	break;
			}
			
			//�жϵ���1�������ڼ������������죬��Ϊ��һ�ܵ�һ�죬�����������
	    	String pBTime = "";
			String pETime = "";
			switch(Integer.parseInt(CommUtil.getWeekDayString(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01")))
			{
	    		case 0://������
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 1://����һ
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-07 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-07 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 2://���ڶ�
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-06 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-06 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 3://������
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-05 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-05 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 4://������
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-04 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-04 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 5://������
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-03 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-03 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 6://������
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-02 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-02 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
			}
			
			//�ж�pBTime�Ƿ��ڱ�����
			if(Integer.parseInt(pBTime.substring(5,7)) == Integer.parseInt(Month))
			{
				pBTime = pBTime.substring(0,10);
				pETime = pETime.substring(0,10);
				currStatus.setVecDate(CommUtil.getDate(pBTime, pETime));
			}
			else
			{
				pBTime = "1970-01-01";
				pETime = "1970-01-01";
				currStatus.setVecDate(CommUtil.getDate(pBTime, pETime));
			}
			
			//�����ʷ
			
			//���ɵ�ǰ
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "��˾�ܱ���";
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			//��˾����
			CorpInfoBean Corp_Info = (CorpInfoBean)request.getSession().getAttribute("User_Corp_Info_" + Sid);
			String D_Corp_Name = "";
			String D_Oil_Info = "";
			String D_Oil_Name = "";
			String D_Station_Info = "";
			String D_Car_Info = "";
			if(null != Corp_Info)
			{	
				D_Corp_Name = Corp_Info.getCName();
				D_Oil_Info = Corp_Info.getOil_Info();
				D_Station_Info = Corp_Info.getStation_Info();
				D_Car_Info = Corp_Info.getCar_Info();
				if(null == D_Corp_Name){D_Corp_Name = "";}
				if(null == D_Oil_Info){D_Oil_Info = "";}
				if(null == D_Station_Info){D_Station_Info = "";}
				if(null == D_Car_Info){D_Car_Info = "";}
				if(null != currStatus.getFunc_Corp_Id() && D_Oil_Info.length() > 0)
				{
					String[] List = D_Oil_Info.split(";");
					for(int i=0; i<List.length && List[i].length()>0; i++)
					{
					  	String[] subList = List[i].split(",");
					  	if(currStatus.getFunc_Corp_Id().equals(subList[0]))
					  	{
					  		D_Oil_Name = subList[1];
					  		break;
					  	}
			  		}
				}
			}
			
			//�ܱ���
			msgBean = pRmi.RmiExec(2, this, 0);
			ArrayList<?> temp0 = (ArrayList<?>)msgBean.getMsg();
			
			//������
			//msgBean = pRmi.RmiExec(4, this, 0);
			ProOBean poBean =new ProOBean();
	    	poBean.setCpm_Id(Cpm_Id);
	    	poBean.currStatus = currStatus;
	    	msgBean = pRmi.RmiExec(6, poBean, 0);
			ArrayList<?> temp1 = (ArrayList<?>)msgBean.getMsg();
			
			//���ۼ�
			msgBean = pRmi.RmiExec(5, this, 0);
			ArrayList<?> temp2 = (ArrayList<?>)msgBean.getMsg();
			double D_Value_O_All   = 0.0;
			double D_Value_O_Y_All = 0.0;
			int D_Car_Cnt_All      = 0;
			int D_cnt              = 0;
			int D_Index            = -1;
			Label label            = null;
			if(null != temp0)
			{
				//�����ļ�
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);
	            
	            //�����ʽ1
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
				
				//�����ʽ3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);
				wf3.setColour(Colour.BLACK);//������ɫ
				wff3.setAlignment(Alignment.RIGHT);//���þ���
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ4
				WritableFont wf4 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff4 = new WritableCellFormat(wf4);
				wf4.setColour(Colour.BLACK);//������ɫ
				wff4.setAlignment(Alignment.CENTRE);//���þ���
				wff4.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ5
				WritableFont wf5 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff5 = new WritableCellFormat(wf5);
				wf5.setColour(Colour.BLACK);//������ɫ
				wff5.setAlignment(Alignment.LEFT);//���þ���
				wff5.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				wff5.setWrap(true);
				
				D_Index++;
	            sheet.setRowView(D_Index, 600);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, D_Corp_Name + "������Ӫ�ܱ����ܱ�[" + D_Oil_Name + "]", wff);
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
	            sheet.mergeCells(0,D_Index,8,D_Index);
				
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "��������: " + currStatus.getVecDate().get(0).toString().substring(0,10) + " �� " + currStatus.getVecDate().get(1).toString().substring(0,10), wff3);
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
	            sheet.mergeCells(0,D_Index,8,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "վ��", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "����վ", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(1,D_Index,3,D_Index);
	            label = new Label(4, D_Index, "��������(L��kg)", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(4,D_Index,5,D_Index);
	            label = new Label(6, D_Index, "����Ӫ����", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(6,D_Index,7,D_Index);
	            label = new Label(8, D_Index, "��ע", wff2);
	            sheet.addCell(label);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "վ����", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "Ͷ��ʱ��", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "վ����", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "�����ۼ�", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "�����ۼ�", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "������", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "��������", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index-1,0,D_Index);
	            sheet.mergeCells(8,D_Index-1,8,D_Index);
	            
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					ProLCrpBean Bean = (ProLCrpBean)iterator.next();
					D_cnt++;
					String D_Cpm_Id    = Bean.getCpm_Id();
					String D_Cpm_Name  = Bean.getCpm_Name();
					String D_Cpm_CTime = Bean.getCpm_CTime();
					String D_Cpm_CType = Bean.getCpm_CType();
					String D_Value_O   = Bean.getValue_O();
					String D_str_Cpm_CType = "��";
					if(null != D_Cpm_CType && D_Station_Info.length() > 0)
					{
						String[] StationList = D_Station_Info.split(",");
						for(int i=0; i<StationList.length; i++)
						{
				    	if(D_Cpm_CType.equals(CommUtil.IntToStringLeftFillZero(i+1, 4)))
				    	{
						  	D_str_Cpm_CType = StationList[i];
						  }
						}
					}
					
					//�����ۼ�
					String D_Value_O_Y = "0";
					if(null != temp2)
					{
						Iterator<?> yeariter = temp2.iterator();
						while(yeariter.hasNext())
						{
							ProLCrpBean yearBean = (ProLCrpBean)yeariter.next();
							if(yearBean.getCpm_Id().equals(D_Cpm_Id))
							{
								D_Value_O_Y = yearBean.getValue_O();
							}
						}
					}
					
					//�����ۼ�
					int D_Car_Cnt = 0;
					String D_Car_CType1    = "";
					String D_Car_CType2    = "";
					int    D_Car_CType_cnt = 0;
					String D_Car_CType_str = "";
					if(null != temp1)
					{
						Iterator<?> cariter = temp1.iterator();
						while(cariter.hasNext())
						{
							ProOBean carBean = (ProOBean)cariter.next();
							if(carBean.getCpm_Id().equals(D_Cpm_Id))
							{
								D_Car_Cnt++;
								D_Car_CType1 += carBean.getCar_CType() + ",";
								if(!D_Car_CType2.contains(carBean.getCar_CType()))
								{
									D_Car_CType2 += carBean.getCar_CType() + ",";
								}
							}
						}
						if(D_Car_CType1.length() > 0 && D_Car_CType2.length() > 0)
						{
							String[] List = D_Car_CType2.split(",");
							for(int i=0; i<List.length; i++)
							{
								//��������
								String str_Car_Name = "";
								if(D_Car_Info.length() > 0)
								{
									String[] CarList = D_Car_Info.split(";");
									for(int k=0; k<CarList.length; k++)
									{
										String[] subCarList = CarList[k].split(",");
										if(List[i].equals(subCarList[0]))
										{
											str_Car_Name = subCarList[1];
										}
									}
								}
						
								D_Car_CType_cnt = 0;
								String[] sub_List = D_Car_CType1.split(",");
								for(int j=0; j<sub_List.length; j++)
								{
									if(List[i].equals(sub_List[j]))
									{
										D_Car_CType_cnt++;
									}
								}
								if(0 == i)
								{
									D_Car_CType_str += str_Car_Name + " " + D_Car_CType_cnt + " ��;";
								}
								else
								{
									D_Car_CType_str += "\012" + str_Car_Name + " " + D_Car_CType_cnt + " ��;";
								}								
							}
						}
					}
					
					//�ϼ�
					D_Value_O_All   = D_Value_O_All + Double.parseDouble(D_Value_O);
					D_Value_O_Y_All = D_Value_O_Y_All + Double.parseDouble(D_Value_O_Y);
					D_Car_Cnt_All   = D_Car_Cnt_All + D_Car_Cnt;
					
					D_Index++;
		            sheet.setRowView(D_Index, 400*D_Car_CType2.split(",").length);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, D_Cpm_Id, wff4);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, D_Cpm_Name, wff4);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, D_Cpm_CTime, wff4);
		            sheet.addCell(label);
		            label = new Label(3, D_Index, D_str_Cpm_CType, wff4);
		            sheet.addCell(label);
		            label = new Label(4, D_Index, D_Value_O, wff4);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, D_Value_O_Y, wff4);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, D_Car_Cnt+"", wff4);
		            sheet.addCell(label);
		            label = new Label(7, D_Index, D_Car_CType_str, wff5);
		            sheet.addCell(label);
		            label = new Label(8, D_Index, "", wff4);
		            sheet.addCell(label);
				}
				
				D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "�ϼ�", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, D_cnt+"", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "/", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "/", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, new BigDecimal(D_Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, new BigDecimal(D_Value_O_Y_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, D_Car_Cnt_All+"", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "", wff2);
	            sheet.addCell(label);
				
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,2,D_Index);
	            label = new Label(3, D_Index, "���: " + Operator_Name, wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(3,D_Index,5,D_Index);
	            label = new Label(6, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(6,D_Index,8,D_Index);
/**********************************************�ܱ���վ����ϸ***************************************************************/ 
	            if(null != temp0)
	            {
	            	Iterator ite = temp0.iterator();
	            	while (ite.hasNext())
	            	{
	            		ProLCrpBean plBean = (ProLCrpBean)ite.next();
	            		Cpm_Id    = plBean.getCpm_Id();
	            		Cpm_Name  = plBean.getCpm_Name();
	            		String psheetName =Cpm_Name+"վ";
						sheet = book.createSheet(psheetName, 1);
						
	            		ProLBean  pBean = new ProLBean();
	            		pBean.setCpm_Id(Cpm_Id);
	            		pBean.currStatus = currStatus;	            		
	            		
	            		msgBean = pRmi.RmiExec(3, pBean, 0);
	        			ArrayList<?> temp6 = (ArrayList<?>)msgBean.getMsg();
	        			
	        			//���ۼ�
	        			msgBean = pRmi.RmiExec(1, pBean, 0);
	        			ArrayList<?> temp7 = (ArrayList<?>)msgBean.getMsg();
	        			
	        			//������
	        			msgBean = pRmi.RmiExec(2, pBean, 0);
	        			ArrayList<?> temp8 = (ArrayList<?>)msgBean.getMsg();
	        			String D_T_Cpm_Id   = "";
	        			String D_T_Cpm_Name = "";
	        			D_cnt           = 0;
	        			D_Index         = -1;
	        			label         = null;	        									
	        			if(null != temp6)
	        			{
	        				
	        				
	        				Iterator<?> iterato = temp6.iterator();
	        				while(iterato.hasNext())
	        				{
	        					ProLBean Bean = (ProLBean)iterato.next();
	        					D_cnt++;
	        					if(!D_T_Cpm_Id.equals(Bean.getCpm_Id()))
	        					{
	        						if(D_T_Cpm_Id.length() > 0)
	        						{
	        							//�����������С��
	        							int D_Car_Cnt = 0;
	        							if(null != temp2)
	        							{
	        								Iterator<?> cariter = temp2.iterator();
	        								while(cariter.hasNext())
	        								{
	        									ProLBean carBean = (ProLBean)cariter.next();
	        									if(carBean.getCpm_Id().equals(D_T_Cpm_Id))
	        									{
	        										D_Car_Cnt++;
	        									}
	        								}
	        							}
	        							String Summary = "1����վ����Ӫ������"+ D_Car_Cnt +"̨;";
	        							
	        							D_Index++;
	        				            sheet.setRowView(D_Index, 1200);
	        				            sheet.setColumnView(D_Index, 20);
	        				            label = new Label(0, D_Index, "�����������С��", wff2);
	        				            sheet.addCell(label);
	        				            label = new Label(1, D_Index, "");
	        				            sheet.addCell(label);
	        				            sheet.mergeCells(0,D_Index,1,D_Index);
	        				            label = new Label(2, D_Index, Summary, wff4);
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
	        				            sheet.mergeCells(2,D_Index,10,D_Index);
	        				            
	        				            D_Index++;
	        				            sheet.setRowView(D_Index, 400);
	        				            sheet.setColumnView(D_Index, 20);
	        				            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff3);
	        				            sheet.addCell(label);
	        				            label = new Label(1, D_Index, "");
	        				            sheet.addCell(label);
	        				            label = new Label(2, D_Index, "");
	        				            sheet.addCell(label);
	        				            sheet.mergeCells(0,D_Index,2,D_Index);
	        				            label = new Label(3, D_Index, "���: " + Operator_Name, wff3);
	        				            sheet.addCell(label);
	        				            label = new Label(4, D_Index, "");
	        				            sheet.addCell(label);
	        				            label = new Label(5, D_Index, "");
	        				            sheet.addCell(label);
	        				            sheet.mergeCells(3,D_Index,5,D_Index);
	        				            label = new Label(6, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff3);
	        				            sheet.addCell(label);
	        				            label = new Label(7, D_Index, "");
	        				            sheet.addCell(label);
	        				            label = new Label(8, D_Index, "");
	        				            sheet.addCell(label);
	        				            label = new Label(9, D_Index, "");
	        				            sheet.addCell(label);
	        				            label = new Label(10, D_Index, "");
	        				            sheet.addCell(label);
	        				            sheet.mergeCells(6,D_Index,10,D_Index);
	        						}
	        						
	        						D_T_Cpm_Name = Bean.getCpm_Name();
	        						
	        						D_Index++;
	        			            sheet.setRowView(D_Index, 600);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "����վ������Ӫ�ܱ���[" + D_Oil_Name + "]", wff);
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
	        			            sheet.mergeCells(0,D_Index,10,D_Index);
	        			            
	        			            D_Index++;
	        			            sheet.setRowView(D_Index, 400);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "վ������: " + D_T_Cpm_Name, wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(1, D_Index, "");
	        			            sheet.addCell(label);
	        			            label = new Label(2, D_Index, "");
	        			            sheet.addCell(label);
	        			            label = new Label(3, D_Index, "");
	        			            sheet.addCell(label);
	        			            sheet.mergeCells(0,D_Index,3,D_Index);
	        			            label = new Label(4, D_Index, "��������: "+ currStatus.getVecDate().get(0).toString().substring(0,10) +" �� "+ currStatus.getVecDate().get(1).toString().substring(0,10), wff2);
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
	        			            sheet.mergeCells(4,D_Index,10,D_Index);
	        			            
	        			            D_Index++;
	        			            sheet.setRowView(D_Index, 400);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "����", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(1, D_Index, "");
	        			            sheet.addCell(label);
	        			            sheet.mergeCells(0,D_Index,1,D_Index);
	        			            label = new Label(2, D_Index, "������", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(3, D_Index, "����һ", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(4, D_Index, "���ڶ�", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(5, D_Index, "������", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(6, D_Index, "������", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(7, D_Index, "������", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(8, D_Index, "������", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(9, D_Index, "�����ۼ�", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(10, D_Index, "�����ۼ�", wff2);
	        			            sheet.addCell(label);
	        			            
	        						String Name1 = "";
	        						String Name2 = "";
	        					  	switch(Integer.parseInt(currStatus.getFunc_Corp_Id()))
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
	        								Name1 = "ȼ����(L)";
	        							    Name2 = "�ۺ�����(kg)";
	        								break;
	        							case 3001://CNG
	        							case 3002://LNG
	        								Name1 = "ȼ����(kg)";
	        							    Name2 = "�ۺ���̬(m3)";
	        								break;
	        						}
	        					  	
	        					  	//���� - ����
	        					  	String a_Value_O     = "0";
	        					  	String a_Value_O_Gas = "0";
	        					  	String a_Value_I     = "0";
	        					  	String a_Value_I_Gas = "0";
	        					  	String a_Value_R     = "0";
	        					  	String a_Value_R_Gas = "0";
	        					  
	        					  	String b_Value_O     = "0";
	        					  	String b_Value_O_Gas = "0";
	        					  	String b_Value_I     = "0";
	        					  	String b_Value_I_Gas = "0";
	        					  	String b_Value_R     = "0";
	        					  	String b_Value_R_Gas = "0";
	        					  
	        					  	String c_Value_O     = "0";
	        					  	String c_Value_O_Gas = "0";
	        					  	String c_Value_I     = "0";
	        					  	String c_Value_I_Gas = "0";
	        					  	String c_Value_R     = "0";
	        					  	String c_Value_R_Gas = "0";
	        					  
	        					  	String d_Value_O     = "0";
	        					  	String d_Value_O_Gas = "0";
	        					  	String d_Value_I     = "0";
	        					  	String d_Value_I_Gas = "0";
	        					  	String d_Value_R     = "0";
	        					  	String d_Value_R_Gas = "0";
	        					  
	        					  	String e_Value_O     = "0";
	        					  	String e_Value_O_Gas = "0";
	        					  	String e_Value_I     = "0";
	        					  	String e_Value_I_Gas = "0";
	        					  	String e_Value_R     = "0";
	        					  	String e_Value_R_Gas = "0";
	        					  
	        					  	String f_Value_O     = "0";
	        					  	String f_Value_O_Gas = "0";
	        					  	String f_Value_I     = "0";
	        					  	String f_Value_I_Gas = "0";
	        					  	String f_Value_R     = "0";
	        					  	String f_Value_R_Gas = "0";
	        					  
	        					  	String g_Value_O     = "0";
	        					  	String g_Value_O_Gas = "0";
	        					  	String g_Value_I     = "0";
	        					  	String g_Value_I_Gas = "0";
	        					  	String g_Value_R     = "0";
	        					  	String g_Value_R_Gas = "0";
	        					  	
	        					  	if(null != temp6)
	        						{
	        							Iterator<?> dataiter = temp6.iterator();
	        							while(dataiter.hasNext())
	        							{
	        								ProLBean dataBean = (ProLBean)dataiter.next();
	        								if(dataBean.getCpm_Id().equals(Bean.getCpm_Id()))
	        								{
	        									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), currStatus.getVecDate().get(0).toString().substring(0,10)))
	        									{
	        										a_Value_O     = dataBean.getValue_O();
	        										a_Value_O_Gas = dataBean.getValue_O_Gas();
	        										a_Value_I     = dataBean.getValue_I();
	        										a_Value_I_Gas = dataBean.getValue_I_Gas();
	        										a_Value_R     = dataBean.getValue_R();
	        										a_Value_R_Gas = dataBean.getValue_R_Gas();
	        									}
	        									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 1).substring(0,10)))
	        									{
	        										b_Value_O     = dataBean.getValue_O();
	        										b_Value_O_Gas = dataBean.getValue_O_Gas();
	        										b_Value_I     = dataBean.getValue_I();
	        										b_Value_I_Gas = dataBean.getValue_I_Gas();
	        										b_Value_R     = dataBean.getValue_R();
	        										b_Value_R_Gas = dataBean.getValue_R_Gas();
	        									}
	        									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 2).substring(0,10)))
	        									{
	        										c_Value_O     = dataBean.getValue_O();
	        										c_Value_O_Gas = dataBean.getValue_O_Gas();
	        										c_Value_I     = dataBean.getValue_I();
	        										c_Value_I_Gas = dataBean.getValue_I_Gas();
	        										c_Value_R     = dataBean.getValue_R();
	        										c_Value_R_Gas = dataBean.getValue_R_Gas();
	        									}
	        									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 3).substring(0,10)))
	        									{
	        										d_Value_O     = dataBean.getValue_O();
	        										d_Value_O_Gas = dataBean.getValue_O_Gas();
	        										d_Value_I     = dataBean.getValue_I();
	        										d_Value_I_Gas = dataBean.getValue_I_Gas();
	        										d_Value_R     = dataBean.getValue_R();
	        										d_Value_R_Gas = dataBean.getValue_R_Gas();
	        									}
	        									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 4).substring(0,10)))
	        									{
	        										e_Value_O     = dataBean.getValue_O();
	        										e_Value_O_Gas = dataBean.getValue_O_Gas();
	        										e_Value_I     = dataBean.getValue_I();
	        										e_Value_I_Gas = dataBean.getValue_I_Gas();
	        										e_Value_R     = dataBean.getValue_R();
	        										e_Value_R_Gas = dataBean.getValue_R_Gas();
	        									}
	        									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 5).substring(0,10)))
	        									{
	        										f_Value_O     = dataBean.getValue_O();
	        										f_Value_O_Gas = dataBean.getValue_O_Gas();
	        										f_Value_I     = dataBean.getValue_I();
	        										f_Value_I_Gas = dataBean.getValue_I_Gas();
	        										f_Value_R     = dataBean.getValue_R();
	        										f_Value_R_Gas = dataBean.getValue_R_Gas();
	        									}
	        									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), currStatus.getVecDate().get(1).toString().substring(0,10)))
	        									{
	        										g_Value_O     = dataBean.getValue_O();
	        										g_Value_O_Gas = dataBean.getValue_O_Gas();
	        										g_Value_I     = dataBean.getValue_I();
	        										g_Value_I_Gas = dataBean.getValue_I_Gas();
	        										g_Value_R     = dataBean.getValue_R();
	        										g_Value_R_Gas = dataBean.getValue_R_Gas();
	        									}
	        								}
	        							}
	        						}
	        					  	
	        					  	//�����ۼ�
	        					  	double Value_O_All     = 0.0;
	        					  	double Value_O_Gas_All = 0.0;
	        					  	double Value_I_All     = 0.0;
	        					  	double Value_I_Gas_All = 0.0;
	        					  	double Value_R_All     = 0.0;
	        					  	double Value_R_Gas_All = 0.0;
	        						  
	        					  	Value_O_All = Double.parseDouble(a_Value_O) 
	        						          	+ Double.parseDouble(b_Value_O) 
	        						          	+ Double.parseDouble(c_Value_O) 
	        						          	+ Double.parseDouble(d_Value_O) 
	        						          	+ Double.parseDouble(e_Value_O) 
	        						          	+ Double.parseDouble(f_Value_O) 
	        						          	+ Double.parseDouble(g_Value_O);
	        						              
	        					  	Value_O_Gas_All = Double.parseDouble(a_Value_O_Gas) 
	        						             	+ Double.parseDouble(b_Value_O_Gas) 
	        						             	+ Double.parseDouble(c_Value_O_Gas) 
	        						             	+ Double.parseDouble(d_Value_O_Gas) 
	        						             	+ Double.parseDouble(e_Value_O_Gas) 
	        						             	+ Double.parseDouble(f_Value_O_Gas) 
	        						             	+ Double.parseDouble(g_Value_O_Gas);
	        						  
	        					  	Value_I_All = Double.parseDouble(a_Value_I) 
	        						           	+ Double.parseDouble(b_Value_I) 
	        						           	+ Double.parseDouble(c_Value_I) 
	        						           	+ Double.parseDouble(d_Value_I) 
	        						           	+ Double.parseDouble(e_Value_I) 
	        						           	+ Double.parseDouble(f_Value_I) 
	        						           	+ Double.parseDouble(g_Value_I);
	        						              
	        					  	Value_I_Gas_All = Double.parseDouble(a_Value_I_Gas) 
	        						             	+ Double.parseDouble(b_Value_I_Gas) 
	        						             	+ Double.parseDouble(c_Value_I_Gas) 
	        						             	+ Double.parseDouble(d_Value_I_Gas) 
	        						             	+ Double.parseDouble(e_Value_I_Gas) 
	        						             	+ Double.parseDouble(f_Value_I_Gas) 
	        						             	+ Double.parseDouble(g_Value_I_Gas);
	        						              		
	        					  	Value_R_All = Double.parseDouble(a_Value_R) 
	        						           	+ Double.parseDouble(b_Value_R) 
	        						           	+ Double.parseDouble(c_Value_R) 
	        						           	+ Double.parseDouble(d_Value_R) 
	        						           	+ Double.parseDouble(e_Value_R) 
	        						           	+ Double.parseDouble(f_Value_R) 
	        						           	+ Double.parseDouble(g_Value_R);
	        						              
	        					  	Value_R_Gas_All = Double.parseDouble(a_Value_R_Gas) 
	        						             	+ Double.parseDouble(b_Value_R_Gas) 
	        						             	+ Double.parseDouble(c_Value_R_Gas) 
	        						             	+ Double.parseDouble(d_Value_R_Gas) 
	        						             	+ Double.parseDouble(e_Value_R_Gas) 
	        						             	+ Double.parseDouble(f_Value_R_Gas) 
	        						             	+ Double.parseDouble(g_Value_R_Gas);
	        					  	
	        					  	//�����ۼ�
	        					  	String Value_O_Y     = "0";
	        					  	String Value_O_Gas_Y = "0";
	        					  	String Value_I_Y     = "0";
	        					  	String Value_I_Gas_Y = "0";
	        					  	String Value_R_Y     = "0";
	        					  	String Value_R_Gas_Y = "0";
	        						if(null != temp7)
	        						{
	        							Iterator<?> yeariter = temp7.iterator();
	        							while(yeariter.hasNext())
	        							{
	        								ProLBean yearBean = (ProLBean)yeariter.next();
	        								if(yearBean.getCpm_Id().equals(Bean.getCpm_Id()))
	        								{
	        									Value_O_Y     = yearBean.getValue_O();
	        									Value_O_Gas_Y = yearBean.getValue_O_Gas();
	        									Value_I_Y     = yearBean.getValue_I();
	        									Value_I_Gas_Y = yearBean.getValue_I_Gas();
	        									Value_R_Y     = yearBean.getValue_R();
	        									Value_R_Gas_Y = yearBean.getValue_R_Gas();
	        								}
	        							}
	        						}
	        						
	        						D_Index++;
	        			            sheet.setRowView(D_Index, 400);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "��Ŀ", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(1, D_Index, "");
	        			            sheet.addCell(label);
	        			            sheet.mergeCells(0,D_Index,1,D_Index);
	        			            label = new Label(2, D_Index, "("+ currStatus.getVecDate().get(0).toString().substring(5,10) +")", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(3, D_Index, "("+ CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 1).substring(5,10) +")", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(4, D_Index, "("+ CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 2).substring(5,10) +")", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(5, D_Index, "("+ CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 3).substring(5,10) +")", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(6, D_Index, "("+ CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 4).substring(5,10) +")", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(7, D_Index, "("+ CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 5).substring(5,10) +")", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(8, D_Index, "("+ currStatus.getVecDate().get(1).toString().substring(5,10) +")", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(9, D_Index, "");
	        			            sheet.addCell(label);
	        			            label = new Label(10, D_Index, "");
	        			            sheet.mergeCells(9,D_Index-1,9,D_Index);
	        			            sheet.mergeCells(10,D_Index-1,10,D_Index);
	        			            
	        			            D_Index++;
	        			            sheet.setRowView(D_Index, 400);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "��������", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(1, D_Index, Name1, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(2, D_Index, a_Value_O, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(3, D_Index, b_Value_O, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(4, D_Index, c_Value_O, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(5, D_Index, d_Value_O, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(6, D_Index, e_Value_O, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(7, D_Index, f_Value_O, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(8, D_Index, g_Value_O, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(9, D_Index, new BigDecimal(Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(10, D_Index, Value_O_Y, wff3);
	        			            sheet.addCell(label);
	        			            
	        			            D_Index++;
	        			            sheet.setRowView(D_Index, 400);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(1, D_Index, Name2, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(2, D_Index, a_Value_O_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(3, D_Index, b_Value_O_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(4, D_Index, c_Value_O_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(5, D_Index, d_Value_O_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(6, D_Index, e_Value_O_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(7, D_Index, f_Value_O_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(8, D_Index, g_Value_O_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(9, D_Index, new BigDecimal(Value_O_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(10, D_Index, Value_O_Gas_Y, wff3);
	        			            sheet.addCell(label);
	        			            sheet.mergeCells(0,D_Index-1,0,D_Index);
	        			            
	        			            D_Index++;
	        			            sheet.setRowView(D_Index, 400);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "��������", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(1, D_Index, Name1, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(2, D_Index, a_Value_I, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(3, D_Index, b_Value_I, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(4, D_Index, c_Value_I, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(5, D_Index, d_Value_I, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(6, D_Index, e_Value_I, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(7, D_Index, f_Value_I, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(8, D_Index, g_Value_I, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(9, D_Index, new BigDecimal(Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(10, D_Index, Value_I_Y, wff3);
	        			            sheet.addCell(label);
	        			            
	        			            D_Index++;
	        			            sheet.setRowView(D_Index, 400);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(1, D_Index, Name2, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(2, D_Index, a_Value_I_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(3, D_Index, b_Value_I_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(4, D_Index, c_Value_I_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(5, D_Index, d_Value_I_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(6, D_Index, e_Value_I_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(7, D_Index, f_Value_I_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(8, D_Index, g_Value_I_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(9, D_Index, new BigDecimal(Value_I_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(10, D_Index, Value_I_Gas_Y, wff3);
	        			            sheet.addCell(label);
	        			            sheet.mergeCells(0,D_Index-1,0,D_Index);
	        			            
	        			            D_Index++;
	        			            sheet.setRowView(D_Index, 400);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "�������", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(1, D_Index, Name1, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(2, D_Index, a_Value_R, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(3, D_Index, b_Value_R, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(4, D_Index, c_Value_R, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(5, D_Index, d_Value_R, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(6, D_Index, e_Value_R, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(7, D_Index, f_Value_R, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(8, D_Index, g_Value_R, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(9, D_Index, new BigDecimal(Value_R_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(10, D_Index, Value_R_Y, wff3);
	        			            sheet.addCell(label);
	        			            
	        			            D_Index++;
	        			            sheet.setRowView(D_Index, 400);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(1, D_Index, Name2, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(2, D_Index, a_Value_R_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(3, D_Index, b_Value_R_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(4, D_Index, c_Value_R_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(5, D_Index, d_Value_R_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(6, D_Index, e_Value_R_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(7, D_Index, f_Value_R_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(8, D_Index, g_Value_R_Gas, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(9, D_Index, new BigDecimal(Value_R_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(10, D_Index, Value_R_Gas_Y, wff3);
	        			            sheet.addCell(label);
	        			            sheet.mergeCells(0,D_Index-1,0,D_Index);
	        					}
	        					
	        					D_T_Cpm_Id = Bean.getCpm_Id();
	        					if(D_cnt == temp6.size())
	        					{
	        						//�����������С��
	        						int D_Car_Cnt = 0;
	        						if(null != temp8)
	        						{
	        							Iterator<?> cariter = temp8.iterator();
	        							while(cariter.hasNext())
	        							{
	        								ProLBean carBean = (ProLBean)cariter.next();
	        								if(carBean.getCpm_Id().equals(D_T_Cpm_Id))
	        								{
	        									D_Car_Cnt++;
	        								}
	        							}
	        						}
	        						String Summary = "1����վ����Ӫ������"+ D_Car_Cnt +"̨;";
	        						
	        						D_Index++;
	        			            sheet.setRowView(D_Index, 1200);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "�����������С��", wff2);
	        			            sheet.addCell(label);
	        			            label = new Label(1, D_Index, "");
	        			            sheet.addCell(label);
	        			            sheet.mergeCells(0,D_Index,1,D_Index);
	        			            label = new Label(2, D_Index, Summary, wff4);
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
	        			            sheet.mergeCells(2,D_Index,10,D_Index);
	        			            
	        			            D_Index++;
	        			            sheet.setRowView(D_Index, 400);
	        			            sheet.setColumnView(D_Index, 20);
	        			            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(1, D_Index, "");
	        			            sheet.addCell(label);
	        			            label = new Label(2, D_Index, "");
	        			            sheet.addCell(label);
	        			            sheet.mergeCells(0,D_Index,2,D_Index);
	        			            label = new Label(3, D_Index, "���: " + Operator_Name, wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(4, D_Index, "");
	        			            sheet.addCell(label);
	        			            label = new Label(5, D_Index, "");
	        			            sheet.addCell(label);
	        			            sheet.mergeCells(3,D_Index,5,D_Index);
	        			            label = new Label(6, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff3);
	        			            sheet.addCell(label);
	        			            label = new Label(7, D_Index, "");
	        			            sheet.addCell(label);
	        			            label = new Label(8, D_Index, "");
	        			            sheet.addCell(label);
	        			            label = new Label(9, D_Index, "");
	        			            sheet.addCell(label);
	        			            label = new Label(10, D_Index, "");
	        			            sheet.addCell(label);
	        			            sheet.mergeCells(6,D_Index,10,D_Index);
	        					}
	        				}
	        				
	        			}
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            		
	            	}
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
	
	//�ձ���
	public void ExportToExcel_D(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);		
			
			switch(currStatus.getFunc_Sub_Id())
			{
				case 0://�걨��
					break;
			    case 1://�±���
			    	break;
			    case 2://�ܱ���
			    	break;
			    case 3://�ձ���
			    	break;
			}
			
			//�����ʷ		
			
			//���ɵ�ǰ
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(0).toString().substring(5,10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			//��˾����
			CorpInfoBean Corp_Info = (CorpInfoBean)request.getSession().getAttribute("User_Corp_Info_" + Sid);
			String D_Corp_Name = "";
			String D_Oil_Info = "";
			String D_Oil_Name = "";
			if(null != Corp_Info)
			{
				D_Corp_Name = Corp_Info.getCName();
				D_Oil_Info = Corp_Info.getOil_Info();				
				if(null == D_Corp_Name){D_Corp_Name = "";}
				if(null == D_Oil_Info){D_Oil_Info = "";}
				if(null != currStatus.getFunc_Corp_Id() && D_Oil_Info.length() > 0)
				{
					String[] List = D_Oil_Info.split(";");
					for(int i=0; i<List.length && List[i].length()>0; i++)
					{
					  	String[] subList = List[i].split(",");
					  	if(currStatus.getFunc_Corp_Id().equals(subList[0]))
					  	{
					  		D_Oil_Name = subList[1];
					  		break;
					  	}
			  		}
				}
			}
			
			//�ձ���
			msgBean = pRmi.RmiExec(3, this, 0);
			ArrayList<?> temp0 = (ArrayList<?>)msgBean.getMsg();
			
			//��ע��
			PLCrmBean PLCrm = new PLCrmBean();	    
	    	PLCrm.setCpm_Id(Cpm_Id);
	    	PLCrm.setFunc_Corp_Id(currStatus.getFunc_Corp_Id());
	    	PLCrm.setVecDa(currStatus.getVecDate());
	    	PLCrm.currStatus = currStatus;
	    	msgBean = pRmi.RmiExec(2, PLCrm, 0);
			ArrayList<?> temp1 = (ArrayList<?>)msgBean.getMsg();
			
			//�ϼ�
			double D_Value_O_All     = 0.0;
			double D_Value_O_Gas_All = 0.0;
			double D_Value_I_All     = 0.0;
			double D_Value_I_Gas_All = 0.0;
			double D_Value_R_All     = 0.0;
			double D_Value_R_Gas_All = 0.0;
			double D_Value_P_All     = 0.0;
			double D_Value_P_Gas_All = 0.0;
			int D_Car_Cnt_All        = 0;
			String D_Car_Cnt_Str     = "";
			int D_cnt                = 0;
			int    D_Index           = -1;
			Label label              = null;
			if(null != temp0)
			{
				//�����ļ�
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);
	            
	            //�����ʽ1
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
				
				//�����ʽ3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);
				wf3.setColour(Colour.BLACK);//������ɫ
				wff3.setAlignment(Alignment.RIGHT);//���þ���
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ4
				WritableFont wf4 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff4 = new WritableCellFormat(wf4);
				wf4.setColour(Colour.BLACK);//������ɫ
				wff4.setAlignment(Alignment.CENTRE);//���þ���
				wff4.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ5
				WritableFont wf5 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff5 = new WritableCellFormat(wf5);
				wf5.setColour(Colour.BLACK);//������ɫ
				wff5.setAlignment(Alignment.LEFT);//���þ���
				wff5.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				wff5.setWrap(true);
				
				D_Index++;
	            sheet.setRowView(D_Index, 600);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, D_Corp_Name + "������Ӫ�ձ����ܱ�[" + D_Oil_Name + "]", wff);
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
	            sheet.mergeCells(0,D_Index,8,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "��������: "+ currStatus.getVecDate().get(0).toString().substring(0,10), wff3);
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
	            sheet.mergeCells(0,D_Index,8,D_Index);
				
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "��Ŀ", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "��������", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(1,D_Index,2,D_Index);
	            label = new Label(3, D_Index, "��������", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(3,D_Index,4,D_Index);
	            label = new Label(5, D_Index, "�������", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(5,D_Index,6,D_Index);
	            label = new Label(7, D_Index, "ӯ������", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(7,D_Index,8,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "վ����", wff2);
	            sheet.addCell(label);
	            switch(Integer.parseInt(currStatus.getFunc_Corp_Id()))
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
						label = new Label(1, D_Index, "ȼ����(L)", wff2);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, "�ۺ�����(kg)", wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "ȼ����(L)", wff2);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "�ۺ�����(kg)", wff2);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "ȼ����(L)", wff2);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "�ۺ�����(kg)", wff2);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "ȼ����(L)", wff2);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "�ۺ�����(kg)", wff2);
			            sheet.addCell(label);
						break;
					case 3001://CNG
					case 3002://LNG
						label = new Label(1, D_Index, "ȼ����(kg)", wff2);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, "�ۺ���̬(m3)", wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "ȼ����(kg)", wff2);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "�ۺ���̬(m3)", wff2);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "ȼ����(kg)", wff2);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "�ۺ���̬(m3)", wff2);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "ȼ����(kg)", wff2);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "�ۺ���̬(m3)", wff2);
			            sheet.addCell(label);
						break;
				}
	            
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					ProLCrpBean Bean = (ProLCrpBean)iterator.next();
					String D_T_Cpm_Name = Bean.getCpm_Name();
					String D_Value_O = Bean.getValue_O();
					String D_Value_O_Gas = Bean.getValue_O_Gas();
					String D_Value_I = Bean.getValue_I();
					String D_Value_I_Gas = Bean.getValue_I_Gas();
					String D_Value_R = Bean.getValue_R();
					String D_Value_R_Gas = Bean.getValue_R_Gas();					  
					double D_Value_P = Double.parseDouble(D_Value_O) - Double.parseDouble(D_Value_I) - Double.parseDouble(D_Value_R);
					double D_Value_P_Gas = Double.parseDouble(D_Value_O_Gas) - Double.parseDouble(D_Value_I_Gas) - Double.parseDouble(D_Value_R_Gas);
				  
					//��ע
					int D_Value_I_Cnt = 0;
					if(null != temp1)
					{
						Iterator<?> crmiter = temp1.iterator();
						while(crmiter.hasNext())
						{
							PLCrmBean crmBean = (PLCrmBean)crmiter.next();
							if(null!=crmBean.getCpm_Id() && crmBean.getCpm_Id().equals(Bean.getCpm_Id()))
							{
								D_Value_I_Cnt = D_Value_I_Cnt + Integer.parseInt(crmBean.getValue_I_Cnt());
								D_Car_Cnt_Str = D_Car_Cnt_Str + crmBean.getCrm_Name() + "��[" + crmBean.getCpm_Name() + "]��ע" + crmBean.getValue_I_Cnt() + "��; ";
							}
						}
					}
					
					//�ϼ�
					D_Value_O_All     = D_Value_O_All + Double.parseDouble(D_Value_O);
					D_Value_O_Gas_All = D_Value_O_Gas_All + Double.parseDouble(D_Value_O_Gas);
					D_Value_I_All     = D_Value_I_All + Double.parseDouble(D_Value_I);
					D_Value_I_Gas_All = D_Value_I_Gas_All + Double.parseDouble(D_Value_I_Gas);
					D_Value_R_All     = D_Value_R_All + Double.parseDouble(D_Value_R);
					D_Value_R_Gas_All = D_Value_R_Gas_All + Double.parseDouble(D_Value_R_Gas);
					D_Value_P_All     = D_Value_P_All + D_Value_P;
					D_Value_P_Gas_All = D_Value_P_Gas_All + D_Value_P_Gas;
					D_Car_Cnt_All     = D_Car_Cnt_All + D_Value_I_Cnt;
					D_cnt++;
					
					D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, D_T_Cpm_Name, wff4);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, D_Value_O, wff4);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, D_Value_O_Gas, wff4);
		            sheet.addCell(label);
		            label = new Label(3, D_Index, D_Value_I, wff4);
		            sheet.addCell(label);
		            label = new Label(4, D_Index, D_Value_I_Gas, wff4);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, D_Value_R, wff4);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, D_Value_R_Gas, wff4);
		            sheet.addCell(label);
		            label = new Label(7, D_Index, new BigDecimal(D_Value_P).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff4);
		            sheet.addCell(label);
		            label = new Label(8, D_Index, new BigDecimal(D_Value_P_Gas).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff4);
		            sheet.addCell(label);
				}
				
			  	D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "�ϼ�", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, new BigDecimal(D_Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, new BigDecimal(D_Value_O_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, new BigDecimal(D_Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, new BigDecimal(D_Value_I_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, new BigDecimal(D_Value_R_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, new BigDecimal(D_Value_R_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, new BigDecimal(D_Value_P_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, new BigDecimal(D_Value_P_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
	            sheet.addCell(label);
	            
	            D_Index++;
	            String str_Value = "1�������ۼƼ�ע���Σ�" + D_Car_Cnt_All + "�Ρ�" + D_Car_Cnt_Str
		           				 + "\012"
		           				 + "2�������̿���" + new BigDecimal(D_Value_P_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP) + "(kg��L)��"
		           				 + "\012"
		           				 + "3��������Դ��" + new BigDecimal(D_Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP) + "(kg��L)��";
	            sheet.setRowView(D_Index, 1200);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "��ע", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, str_Value, wff5);
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
	            sheet.mergeCells(1,D_Index,8,D_Index);
	                        
	            D_Index++;           
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);	            
	            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff5);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "", wff5);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "", wff5);
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,2,D_Index);            
	            label = new Label(3, D_Index, "���: " + Operator_Name, wff5);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "", wff5);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "", wff5);
	            sheet.addCell(label);
	            sheet.mergeCells(3,D_Index,5,D_Index);	            
	            label = new Label(6, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff5);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "", wff5);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "", wff5);
	            sheet.addCell(label);
	            sheet.mergeCells(6,D_Index,8,D_Index);
	            
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
	
	//ͼ�����
	public void Pro_Crp_G(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
			
			switch(currStatus.getFunc_Sel_Id())
			{
				case 0://�������
					request.getSession().setAttribute("BYear_" + Sid, BYear);
					currStatus.setVecDate(CommUtil.getDate(BYear + "-01-01", BYear + "-12-31"));
					break;
			    case 1://���·���
			    	request.getSession().setAttribute("BYear_" + Sid, BYear);
			    	request.getSession().setAttribute("BMonth_" + Sid, BMonth);
			    	currStatus.setVecDate(CommUtil.getDate(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-01", BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-31"));
			    	break;
			    case 2://���ܷ���
			    	request.getSession().setAttribute("BYear_" + Sid, BYear);
			    	request.getSession().setAttribute("BMonth_" + Sid, BMonth);
			    	request.getSession().setAttribute("BWeek_" + Sid, BWeek);
			    	//�жϵ���1�������ڼ������������죬��Ϊ��һ�ܵ�һ�죬�����������
			    	String pBTime = "";
					String pETime = "";
					switch(Integer.parseInt(CommUtil.getWeekDayString(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-01")))
					{
			    		case 0://������
			    			pBTime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-01 00:00:00", (Integer.parseInt(BWeek)-1)*7);
					    	pETime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-01 00:00:00", (Integer.parseInt(BWeek))*7-1);
			    			break;
			    		case 1://����һ
			    			pBTime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-07 00:00:00", (Integer.parseInt(BWeek)-1)*7);
					    	pETime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-07 00:00:00", (Integer.parseInt(BWeek))*7-1);
			    			break;
			    		case 2://���ڶ�
			    			pBTime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-06 00:00:00", (Integer.parseInt(BWeek)-1)*7);
					    	pETime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-06 00:00:00", (Integer.parseInt(BWeek))*7-1);
			    			break;
			    		case 3://������
			    			pBTime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-05 00:00:00", (Integer.parseInt(BWeek)-1)*7);
					    	pETime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-05 00:00:00", (Integer.parseInt(BWeek))*7-1);
			    			break;
			    		case 4://������
			    			pBTime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-04 00:00:00", (Integer.parseInt(BWeek)-1)*7);
					    	pETime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-04 00:00:00", (Integer.parseInt(BWeek))*7-1);
			    			break;
			    		case 5://������
			    			pBTime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-03 00:00:00", (Integer.parseInt(BWeek)-1)*7);
					    	pETime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-03 00:00:00", (Integer.parseInt(BWeek))*7-1);
			    			break;
			    		case 6://������
			    			pBTime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-02 00:00:00", (Integer.parseInt(BWeek)-1)*7);
					    	pETime = CommUtil.getDateAfter(BYear + "-" + CommUtil.StrLeftFillZero(BMonth, 2) + "-02 00:00:00", (Integer.parseInt(BWeek))*7-1);
			    			break;
					}
					//�ж�pBTime�Ƿ��ڱ�����
					if(Integer.parseInt(pBTime.substring(5,7)) == Integer.parseInt(BMonth))
					{
						pBTime = pBTime.substring(0,10);
						pETime = pETime.substring(0,10);
						currStatus.setVecDate(CommUtil.getDate(pBTime, pETime));
					}
					else
					{
						pBTime = "1970-01-01";
						pETime = "1970-01-01";
						currStatus.setVecDate(CommUtil.getDate(pBTime, pETime));
					}
			    	break;
			    case 3://���շ���
			    	request.getSession().setAttribute("BDate_" + Sid, BDate);
			    	currStatus.setVecDate(CommUtil.getDate(BDate, BDate));
			    	break;
			}
			
			msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
			switch(currStatus.getCmd())
			{
				case 20://ͼ�����
			    	request.getSession().setAttribute("Pro_Crp_G_" + Sid, (Object)msgBean.getMsg());
					currStatus.setJsp("Pro_Crp_G.jsp?Sid=" + Sid);
					
					//����ҵ��
			    	ProRBean RBean = new ProRBean();
			    	msgBean = pRmi.RmiExec(2, RBean, 0);
			    	request.getSession().setAttribute("Pro_R_Type_" + Sid, ((Object)msgBean.getMsg()));
					break;
			}
			
			request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		   	response.sendRedirect(currStatus.getJsp());
		}
		catch(Exception Ex)
		{
			Ex.printStackTrace();
		}
	}
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd) 
		{
			case 0://�걨��
				Sql = " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"01' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-01-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-01-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	  " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"02' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-02-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-02-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	  " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"03' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-03-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-03-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	  " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"04' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-04-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-04-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	  " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"05' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-05-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-05-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	  " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"06' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-06-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-06-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	  " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"07' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-07-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-07-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	  " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"08' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-08-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-08-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	  " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"09' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-09-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-09-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	  " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"10' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-10-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-10-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	  " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"11' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-11-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-11-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	  " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, '"+ Year +"12' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime >= '"+Year+"-12-01' " +
			  	  	  "   and t.ctime <= '"+Year+"-12-31' " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "order by cpm_id";
				break;
			case 1://�±���
				Sql = " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, t.ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
					  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
					  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
					  "   and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0,10)+"' " +
					  "   and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0,10)+"' " +
					  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
					  "   order by t.cpm_id ";
				break;
			case 2://�ܱ���
				Sql = " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, t.ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
		  	  	  	  " from view_pro_l t " +
		  	  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
		  	  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
		  	  	  	  "   and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0,10)+"' " +
		  	  	  	  "   and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0,10)+"' " +
		  	  	  	  "   group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
		  	  	  	  "   order by t.cpm_id ";
				break;
			case 3://�ձ���
				Sql = " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, t.ctime, t.value_i, t.value_i_gas, t.value_i_cnt, t.value_o, t.value_o_gas, t.value_r, t.value_r_gas, t.value_pal, t.value_pal_gas" +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.ctime = '"+currStatus.getVecDate().get(0).toString().substring(0,10)+"' " +
			  	  	  "   order by t.cpm_id ";
				break;
			case 4://������
				Sql = " select t.cpm_id, t.cpm_name, '' as cpm_ctime, '' as cpm_ctype, '' as ctime, '' as value_i, '' as value_i_gas, '' as value_i_cnt, '' as value_o, t.unq_flag as value_o_gas, t.unq_str AS value_r, t.car_more AS value_r_gas, '' as value_pal, '' as value_pal_gas  " +
			  	  	  " from view_pro_o t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and t.status = '0' " +
			  	  	  "   and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0,10) + " 08:30:00" +"' " +
			  	  	  "   and t.ctime <= '"+CommUtil.getNextStrDate(currStatus.getVecDate().get(1).toString().substring(0,10)) + " 08:30:00" +"' " +
			  	  	  "   and instr(t.car_more, 'δ֪[ϵͳ�޴˿ͻ�]') <= 0 " +
			  	  	  "   and instr(t.car_more, 'δ֪[ɢ��]') <= 0 " +
			  	  	  "   group by t.cpm_id, t.cpm_name, t.unq_flag, t.unq_str, t.car_more " +
			  	  	  "   order by t.cpm_id ";
				break;
			case 5://���ۼ�
				Sql = " select t.cpm_id, t.cpm_name, '' as cpm_ctime, '' as cpm_ctype, '' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas  " +
			  	  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
			  	  	  "   and substr(t.ctime, 1, 4) = '"+ currStatus.getVecDate().get(0).toString().substring(0,4) +"' " +
			  	  	  "   and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0,10)+"' " +
			  	  	  "   group by t.cpm_id, t.cpm_name " +
			  	  	  "   order by t.cpm_id ";
				break;
			case 6://�걨��ѯվ��
				Sql = " select t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype, t.ctime, t.value_i, t.value_i_gas, t.value_i_cnt, t.value_o, t.value_o_gas, t.value_r, t.value_r_gas, t.value_pal, t.value_pal_gas " +
				  	  " from view_pro_l t " +
				  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
				  	  " and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
				  	  " and t.ctime >= '"+Year+"-01-01' " +
				  	  " and t.ctime <= '"+Year+"-12-31' " +
				  	  " group by t.cpm_id, t.cpm_name " +
			  	  	  " order by t.cpm_id ";		  	  
				break;
			case 11:
				Sql = "delete from pro_l where cpm_id= '"+ BCpm_Id +"' and CTime = '"+currStatus.getVecDate().get(0).toString().substring(0,10)+"'";
				break;
			case 20://ͼ�����
				Sql = " {? = call rmi_pro_crp_graph('"+ currStatus.getFunc_Corp_Id() +"', '"+ currStatus.getFunc_Sub_Id() +"', '"+ currStatus.getFunc_Sel_Id() +"', '"+ Cpm_Id +"', '"+ currStatus.getVecDate().get(0).toString().substring(0,10) +"', '"+ currStatus.getVecDate().get(1).toString().substring(0,10) +"')}";
				break;

			case 21://ͳ�Ƶ�������
				Sql = " {? = call Func_Pro_Today()}";
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs) 
	{
		boolean IsOK = true;
		try
		{
			setCpm_Id(pRs.getString(1));
			setCpm_Name(pRs.getString(2));
			setCpm_CTime(pRs.getString(3));
			setCpm_CType(pRs.getString(4));
			setCTime(pRs.getString(5));
			setValue_I(pRs.getString(6));
			setValue_I_Gas(pRs.getString(7));
			setValue_I_Cnt(pRs.getString(8));
			setValue_O(pRs.getString(9));
			setValue_O_Gas(pRs.getString(10));
			setValue_R(pRs.getString(11));
			setValue_R_Gas(pRs.getString(12));
			setValue_PAL(pRs.getString(13));
			setValue_PAL_Gas(pRs.getString(14));
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
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setCpm_Name(CommUtil.StrToGB2312(request.getParameter("Cpm_Name")));
			setCpm_CTime(CommUtil.StrToGB2312(request.getParameter("Cpm_CTime")));
			setCpm_CType(CommUtil.StrToGB2312(request.getParameter("Cpm_CType")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setValue_I(CommUtil.StrToGB2312(request.getParameter("Value_I")));
			setValue_I_Gas(CommUtil.StrToGB2312(request.getParameter("Value_I_Gas")));
			setValue_I_Cnt(CommUtil.StrToGB2312(request.getParameter("Value_I_Cnt")));
			setValue_O(CommUtil.StrToGB2312(request.getParameter("Value_O")));
			setValue_O_Gas(CommUtil.StrToGB2312(request.getParameter("Value_O_Gas")));
			setValue_R(CommUtil.StrToGB2312(request.getParameter("Value_R")));
			setValue_R_Gas(CommUtil.StrToGB2312(request.getParameter("Value_R_Gas")));
			setValue_PAL(CommUtil.StrToGB2312(request.getParameter("Value_PAL")));
			setValue_PAL_Gas(CommUtil.StrToGB2312(request.getParameter("Value_PAL_Gas")));
			setYear(CommUtil.StrToGB2312(request.getParameter("Year")));
			setMonth(CommUtil.StrToGB2312(request.getParameter("Month")));
			setWeek(CommUtil.StrToGB2312(request.getParameter("Week")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
			
			setBYear(CommUtil.StrToGB2312(request.getParameter("BYear")));
			setBMonth(CommUtil.StrToGB2312(request.getParameter("BMonth")));
			setBWeek(CommUtil.StrToGB2312(request.getParameter("BWeek")));
			setBDate(CommUtil.StrToGB2312(request.getParameter("BDate")));
			setBCpm_Id(CommUtil.StrToGB2312(request.getParameter("BCpm_Id")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String Cpm_Id;
	private String Cpm_Name;
	private String Cpm_CTime;
	private String Cpm_CType;
	private String CTime;
	private String Value_I;
	private String Value_I_Gas;
	private String Value_I_Cnt;
	private String Value_O;
	private String Value_O_Gas;
	private String Value_R;
	private String Value_R_Gas;
	private String Value_PAL;
	private String Value_PAL_Gas;
	
	private String Year;
	private String Month;
	private String Week;
	private String Operator_Name;
	private String Sid;
	
	//ͼ�����
	String BYear   = "";
	String BMonth  = "";
	String BWeek   = "";
	String BDate   = "";
	String BCpm_Id = "";
	
	
	
	
	public String getBCpm_Id() {
		return BCpm_Id;
	}

	public void setBCpm_Id(String bCpm_Id) {
		BCpm_Id = bCpm_Id;
	}

	public String getValue_PAL() {
		return Value_PAL;
	}

	public void setValue_PAL(String value_PAL) {
		Value_PAL = value_PAL;
	}

	public String getValue_PAL_Gas() {
		return Value_PAL_Gas;
	}

	public void setValue_PAL_Gas(String value_PAL_Gas) {
		Value_PAL_Gas = value_PAL_Gas;
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

	public String getValue_I() {
		return Value_I;
	}

	public void setValue_I(String valueI) {
		Value_I = valueI;
	}

	public String getValue_I_Gas() {
		return Value_I_Gas;
	}

	public void setValue_I_Gas(String valueIGas) {
		Value_I_Gas = valueIGas;
	}
	
	public String getValue_I_Cnt() {
		return Value_I_Cnt;
	}

	public void setValue_I_Cnt(String valueICnt) {
		Value_I_Cnt = valueICnt;
	}

	public String getValue_O() {
		return Value_O;
	}

	public void setValue_O(String valueO) {
		Value_O = valueO;
	}

	public String getValue_O_Gas() {
		return Value_O_Gas;
	}

	public void setValue_O_Gas(String valueOGas) {
		Value_O_Gas = valueOGas;
	}

	public String getValue_R() {
		return Value_R;
	}

	public void setValue_R(String valueR) {
		Value_R = valueR;
	}

	public String getValue_R_Gas() {
		return Value_R_Gas;
	}

	public void setValue_R_Gas(String valueRGas) {
		Value_R_Gas = valueRGas;
	}
	
	public String getCpm_CTime() {
		return Cpm_CTime;
	}

	public void setCpm_CTime(String cpmCTime) {
		Cpm_CTime = cpmCTime;
	}

	public String getCpm_CType() {
		return Cpm_CType;
	}

	public void setCpm_CType(String cpmCType) {
		Cpm_CType = cpmCType;
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

	public String getWeek() {
		return Week;
	}

	public void setWeek(String week) {
		Week = week;
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

	public String getBYear() {
		return BYear;
	}

	public void setBYear(String bYear) {
		BYear = bYear;
	}

	public String getBMonth() {
		return BMonth;
	}

	public void setBMonth(String bMonth) {
		BMonth = bMonth;
	}

	public String getBWeek() {
		return BWeek;
	}

	public void setBWeek(String bWeek) {
		BWeek = bWeek;
	}

	public String getBDate() {
		return BDate;
	}

	public void setBDate(String bDate) {
		BDate = bDate;
	}
}