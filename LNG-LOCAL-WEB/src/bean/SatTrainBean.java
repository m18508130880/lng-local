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

public class SatTrainBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SAT_TRAIN;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SatTrainBean()
	{
		super.className = "SatTrainBean";
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
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
			case 0://��ѯ
		    	request.getSession().setAttribute("Sat_Train_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_Train.jsp?Sid=" + Sid);
		    	
		    	//��ѵ����
		    	AqscTrainTypeBean TrainType = new AqscTrainTypeBean();
		    	msgBean = pRmi.RmiExec(0, TrainType, 0);
				request.getSession().setAttribute("Sat_Train_Type_" + Sid, (Object)msgBean.getMsg());
		    	break;
		}		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	public void DiagCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
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
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{			
			case 1://��ѯ
		    	request.getSession().setAttribute("Sat_Diag_Train_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Sat_Diag_Train.jsp?Sid=" + Sid);		    	
		    	//��ѵ����
		    	AqscTrainTypeBean TrType = new AqscTrainTypeBean();
		    	msgBean = pRmi.RmiExec(0, TrType, 0);
				request.getSession().setAttribute("Sat_Train_Type_" + Sid, (Object)msgBean.getMsg());
		    	break;
		    	
		}		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	
	
	
	
	//��ϸ����
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
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);
				wf3.setColour(Colour.BLACK);//������ɫ
				wff3.setAlignment(Alignment.CENTRE);//���þ���
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				sheet.setRowView(0, 600);
	            sheet.setColumnView(0, 20);
	            Label label = new Label(0, 0, "��˾��ȫ��ѵ��¼", wff);
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
	            sheet.mergeCells(0,0,11,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "���", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "��ʼ����", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "��������", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "��֯����", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 1, "��ѵ����", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 1, "��ѵ����", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 1, "��ѵ��λ", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 1, "��ѵ����", wff2);
	            sheet.addCell(label);
	            label  = new Label(8, 1, "��ѵ����", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 1, "��ѵ��ʱ", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 1, "�Ƿ񿼺�", wff2);
	            sheet.addCell(label);
	            label  = new Label(11, 1, "¼����Ա", wff2);
	            sheet.addCell(label);
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 1;
				while(iterator.hasNext())
				{
					i++;
					SatTrainBean Bean = (SatTrainBean)iterator.next();
					String D_Train_BTime = Bean.getTrain_BTime();
					String D_Train_ETime = Bean.getTrain_ETime();
					String D_Train_Dept = Bean.getTrain_Dept();						
					String D_Train_Type_Name = Bean.getTrain_Type_Name();
					String D_Train_Title = Bean.getTrain_Title();
					String D_Train_Corp = Bean.getTrain_Corp();
					String D_Train_Object = Bean.getTrain_Object();
					String D_Train_Cnt = Bean.getTrain_Cnt();
					String D_Train_Hour = Bean.getTrain_Hour();							
					String D_Train_Assess = Bean.getTrain_Assess();
					String D_Operator_Name = Bean.getOperator_Name();
					
					CorpInfoBean Corp_Info = (CorpInfoBean)request.getSession().getAttribute("User_Corp_Info_" + Sid);					
					String Train_Dept_Name = "��";
					if(null != D_Train_Dept && null != Corp_Info.getDept()&& Corp_Info.getDept().trim().length() > 0)
				 	{
				 		String[] DeptList = Corp_Info.getDept().split(",");
						for(int j=0; j<DeptList.length; j++)
						{
							if(D_Train_Dept.equals(CommUtil.IntToStringLeftFillZero(j+1, 2)))
								Train_Dept_Name = DeptList[j];
						}
				 	}
					
					String str_Train_Assess = "";
					switch(Integer.parseInt(D_Train_Assess))
					{
						case 0:
								str_Train_Assess = "��";
							break;
						case 1:
								str_Train_Assess = "��";
							break;
					}
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-1)+"", wff3);          //���
		            sheet.addCell(label);
		            label = new Label(1,i,D_Train_BTime, wff3);     //��ʼ����
		            sheet.addCell(label);
		            label = new Label(2,i,D_Train_ETime, wff3);     //��������
		            sheet.addCell(label);
		            label = new Label(3,i,Train_Dept_Name, wff3);   //��֯����
		            sheet.addCell(label);
		            label = new Label(4,i,D_Train_Type_Name, wff3); //��ѵ����
		            sheet.addCell(label);
		            label = new Label(5,i,D_Train_Title, wff3);    	//��ѵ����
		            sheet.addCell(label);
		            label = new Label(6,i,D_Train_Corp, wff3);  	//��ѵ��λ
		            sheet.addCell(label);
		            label = new Label(7,i,D_Train_Object, wff3);    //��ѵ����
		            sheet.addCell(label);
		            label = new Label(8,i,D_Train_Cnt, wff3);   	//��ѵ����
		            sheet.addCell(label);
		            label = new Label(9,i,D_Train_Hour, wff3);   	//��ѵ��ʱ
		            sheet.addCell(label);
		            label = new Label(10,i,str_Train_Assess, wff3); //�Ƿ񿼺�
		            sheet.addCell(label);
		            label = new Label(11,i,D_Operator_Name, wff3);  //¼����Ա
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
	
	//����
	public void SatTrainAdd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
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
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
		{
			Resp = "0000";
			currStatus.setCmd(0);
			msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
			request.getSession().setAttribute("Sat_Train_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		outprint.write(Resp);
	}
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd)
		{
			case 0://��ѯ
				Sql = " select t.sn, t.train_btime, t.train_etime, t.train_type, t.train_type_name, t.train_dept, t.train_title, t.train_corp, " +
					  " t.train_object, t.train_cnt, t.train_hour, t.train_assess, t.ctime, t.operator, t.operator_name " +
					  " from view_sat_train t " +
					  " where t.train_type like '"+ Func_Corp_Id +"%'" +
					  "   and t.train_btime >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
					  "   and t.train_btime <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
					  "   order by t.train_btime desc ";
				break;
			case 1://��ѯ
				Sql = " select t.sn, t.train_btime, t.train_etime, t.train_type, t.train_type_name, t.train_dept, t.train_title, t.train_corp, " +
					  " t.train_object, t.train_cnt, t.train_hour, t.train_assess, t.ctime, t.operator, t.operator_name " +
					  " from view_sat_train t " +
					  " where t.sn=  '"+ SN +"' ";								  
				break;
			case 10://���
				Sql = " insert into sat_train(train_btime, train_etime, train_type, train_dept, train_title, train_corp, train_object, train_cnt, train_hour, train_assess, ctime, operator)" +
					  " values('"+ Train_BTime +"', '"+ Train_ETime +"', '"+ Train_Type +"', '"+ Train_Dept +"', '"+ Train_Title +"', '"+ Train_Corp +"', '"+ Train_Object +"', '"+ Train_Cnt +"', '"+ Train_Hour +"', '"+ Train_Assess +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"')";
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
			setTrain_BTime(pRs.getString(2));
			setTrain_ETime(pRs.getString(3));
			setTrain_Type(pRs.getString(4));
			setTrain_Type_Name(pRs.getString(5));			
			setTrain_Dept(pRs.getString(6));
			setTrain_Title(pRs.getString(7));
			setTrain_Corp(pRs.getString(8));
			setTrain_Object(pRs.getString(9));
			setTrain_Cnt(pRs.getString(10));
			setTrain_Hour(pRs.getString(11));
			setTrain_Assess(pRs.getString(12));
			setCTime(pRs.getString(13));
			setOperator(pRs.getString(14));
			setOperator_Name(pRs.getString(15));
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
			setTrain_BTime(CommUtil.StrToGB2312(request.getParameter("Train_BTime")));
			setTrain_ETime(CommUtil.StrToGB2312(request.getParameter("Train_ETime")));
			setTrain_Type(CommUtil.StrToGB2312(request.getParameter("Train_Type")));
			setTrain_Type_Name(CommUtil.StrToGB2312(request.getParameter("Train_Type_Name")));			
			setTrain_Dept(CommUtil.StrToGB2312(request.getParameter("Train_Dept")));
			setTrain_Title(CommUtil.StrToGB2312(request.getParameter("Train_Title")));
			setTrain_Corp(CommUtil.StrToGB2312(request.getParameter("Train_Corp")));
			setTrain_Object(CommUtil.StrToGB2312(request.getParameter("Train_Object")));
			setTrain_Cnt(CommUtil.StrToGB2312(request.getParameter("Train_Cnt")));
			setTrain_Hour(CommUtil.StrToGB2312(request.getParameter("Train_Hour")));
			setTrain_Assess(CommUtil.StrToGB2312(request.getParameter("Train_Assess")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));		
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Train_BTime;
	private String Train_ETime;
	private String Train_Type;
	private String Train_Type_Name;
	private String Train_Dept;
	private String Train_Title;
	private String Train_Corp;
	private String Train_Object;
	private String Train_Cnt;
	private String Train_Hour;
	private String Train_Assess;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	
	private String Sid;
	private String Func_Corp_Id;
	
	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
	}

	public String getTrain_BTime() {
		return Train_BTime;
	}

	public void setTrain_BTime(String trainBTime) {
		Train_BTime = trainBTime;
	}

	public String getTrain_ETime() {
		return Train_ETime;
	}

	public void setTrain_ETime(String trainETime) {
		Train_ETime = trainETime;
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

	public String getTrain_Dept() {
		return Train_Dept;
	}

	public void setTrain_Dept(String trainDept) {
		Train_Dept = trainDept;
	}

	public String getTrain_Title() {
		return Train_Title;
	}

	public void setTrain_Title(String trainTitle) {
		Train_Title = trainTitle;
	}

	public String getTrain_Corp() {
		return Train_Corp;
	}

	public void setTrain_Corp(String trainCorp) {
		Train_Corp = trainCorp;
	}

	public String getTrain_Object() {
		return Train_Object;
	}

	public void setTrain_Object(String trainObject) {
		Train_Object = trainObject;
	}

	public String getTrain_Cnt() {
		return Train_Cnt;
	}

	public void setTrain_Cnt(String trainCnt) {
		Train_Cnt = trainCnt;
	}

	public String getTrain_Hour() {
		return Train_Hour;
	}

	public void setTrain_Hour(String trainHour) {
		Train_Hour = trainHour;
	}

	public String getTrain_Assess() {
		return Train_Assess;
	}

	public void setTrain_Assess(String trainAssess) {
		Train_Assess = trainAssess;
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