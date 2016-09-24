package bean;

import java.io.File;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import rmi.Rmi;
import rmi.RmiBean;
import util.*;

public class CadStatusBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_CAD_STATUS;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public CadStatusBean()
	{
		super.className = "CadStatusBean";
	}
	
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			case 12://删除			
			case 11://修改
			case 10://添加
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, 0);
			case 0://查询
		    	request.getSession().setAttribute("Cad_Status_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Cad_Status.jsp?Sid=" + Sid+"&UId="+UId);
		    	
		    	//证件类型
		    	AqscCardTypeBean CardType = new AqscCardTypeBean();
		    	msgBean = pRmi.RmiExec(0, CardType, 0);
				request.getSession().setAttribute("Cad_Status_Type_" + Sid, (Object)msgBean.getMsg());
				
				//岗位信息
				UserPositionBean positionBean = new UserPositionBean();
		    	msgBean = pRmi.RmiExec(0, positionBean, 0);
		    	request.getSession().setAttribute("Cad_Status_Position_" + Sid, ((Object)msgBean.getMsg()));
		    	
		    	UserInfoBean uBean = new UserInfoBean();
		    	uBean.setFunc_Type_Id(Func_Type_Id);
		    	uBean.setFunc_Cpm_Id(Func_Cpm_Id);
		    	System.out.println(Func_Type_Id);
		    	if( Func_Type_Id.equals("999"))
		    	{
		    		uBean.setFunc_Type_Id("");
		    		msgBean = pRmi.RmiExec(6, uBean, 0);
		    	}else
		    	{
		    		msgBean = pRmi.RmiExec(5, uBean, 0);  
		    	}		    	
		    	request.getSession().setAttribute("Cad_Status_UserInfo_" + Sid, ((Object)msgBean.getMsg()));
		    	break;
		}		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
		
	//证件图片上传
	public void DaoFile(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{		
		DiskFileItemFactory factory = new DiskFileItemFactory();    	
		ServletFileUpload sfu = new ServletFileUpload(factory); 	
		String Func_Cpm_Id = "";
		SimpleDateFormat df = new SimpleDateFormat("mmss"); //设置日期格式
		String CurrTime = df.format(new Date()).toString();
		try {				
				List<FileItem> items = sfu.parseRequest(request);
				for(int i=0;i<items.size();i++)
				{
					FileItem item = items.get(i);
					if(item.isFormField())
					{	
						String fieldName = item.getFieldName();
						if(fieldName.equals("Func_Cpm_Id"))
						{
							Func_Cpm_Id = item.getString(); 
						}
						if(fieldName.equals("Sid"))
						{
							Sid = item.getString();
							System.out.println("Sid["+Sid+"]");  
						}
						if(fieldName.equals("UId"))
						{
							UId = item.getString();
							System.out.println("Uid["+UId+"]");  
						}
					}
					else 
					{
						ServletContext sctx = request.getSession().getServletContext();
						String   path       = sctx.getRealPath("/skin/images/zhengjian/");					
						String   fileType   = item.getName().split("\\.")[1];	
						String   newName    = Func_Cpm_Id + "_" + CurrTime +"." + fileType;	
						File     file       = new File(path + File.separator + newName);
						item.write(file);				
						
						if(Func_Cpm_Id.length()>0)
						{
							Card_Images     = Func_Cpm_Id + "_" + CurrTime; //存入数据库的字符
							String[] images = Func_Cpm_Id.split("\\_");
							Sys_Id          = images[0];
							Card_Type       = images[1];
							
							msgBean = pRmi.RmiExec(13, this, 0);
						}
					}  
				}
				
				msgBean = pRmi.RmiExec(0, this, 0);
		    	request.getSession().setAttribute("Cad_Status_" + Sid, ((Object)msgBean.getMsg()));
		    	
				currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
				currStatus.setJsp("Cad_Status.jsp?Sid=" + Sid + "&UId=" + UId);
				
				request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);	
			   	response.sendRedirect(currStatus.getJsp());
			} 
			catch (Exception e) 
			{
				e.printStackTrace();
			}		
	}
		
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd)
		{
			case 0://查询
				Sql = " select t.sys_id, t.card_type, t.card_type_name, t.card_id, t.card_btime, t.card_etime, t.card_review, t.card_images, " +
					  " t.train_dept, t.manag_dept, t.lssue_dept, t.review_inteval, t.ctime, t.operator, t.operator_name " +
					  " from view_cad_status t " +
					  " where instr('"+ UId +"', t.sys_id) > 0 " +
					  "   order by t.sys_id, t.card_type asc ";
				break;
			case 10://添加
				Sql = " insert into cad_status(sys_id, card_type, card_id, card_btime, card_etime, card_review, ctime, operator, card_images)" +
					  " values('"+ Sys_Id +"', '"+ Card_Type +"', '"+ Card_Id +"', '"+ Card_BTime +"', '"+ Card_ETime +"', '"+ Card_Review +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"', '"+ Card_Images +"')";
				break;
			case 11://修改
				Sql = " update cad_status t set t.card_id = '"+ Card_Id +"', t.card_btime = '"+ Card_BTime +"', t.card_etime = '"+ Card_ETime +"', t.card_review = '"+ Card_Review +"', t.operator = '"+ Operator +"' "+
					  " where t.sys_id = '"+ Sys_Id +"' and t.card_type = '"+ Card_Type +"' ";
				break;
			case 12://删除
				Sql = " delete from cad_status where sys_id = '"+ Sys_Id +"' and card_type = '"+ Card_Type +"' ";
				break;
			case 13: //修改图片				
				Sql = " update cad_status t set t.card_images = '"+ Card_Images +"' "+
					  " where t.sys_id = '"+ Sys_Id +"' and t.card_type = '"+ Card_Type +"' ";
								
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs)
	{
		boolean IsOK = true;
		try
		{
			setSys_Id(pRs.getString(1));
			setCard_Type(pRs.getString(2));
			setCard_Type_Name(pRs.getString(3));
			setCard_Id(pRs.getString(4));
			setCard_BTime(pRs.getString(5));
			setCard_ETime(pRs.getString(6));
			setCard_Review(pRs.getString(7));
			setCard_Images(pRs.getString(8));
			setTrain_Dept(pRs.getString(9));
			setManag_Dept(pRs.getString(10));
			setLssue_Dept(pRs.getString(11));
			setReview_Inteval(pRs.getString(12));
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
			setSys_Id(CommUtil.StrToGB2312(request.getParameter("Sys_Id")));
			setCard_Type(CommUtil.StrToGB2312(request.getParameter("Card_Type")));
			setCard_Type_Name(CommUtil.StrToGB2312(request.getParameter("Card_Type_Name")));
			setCard_Id(CommUtil.StrToGB2312(request.getParameter("Card_Id")));
			setCard_BTime(CommUtil.StrToGB2312(request.getParameter("Card_BTime")));
			setCard_ETime(CommUtil.StrToGB2312(request.getParameter("Card_ETime")));
			setCard_Review(CommUtil.StrToGB2312(request.getParameter("Card_Review")));
			setCard_Images(CommUtil.StrToGB2312(request.getParameter("Card_Images")));
			setTrain_Dept(CommUtil.StrToGB2312(request.getParameter("Train_Dept")));
			setManag_Dept(CommUtil.StrToGB2312(request.getParameter("Manag_Dept")));
			setLssue_Dept(CommUtil.StrToGB2312(request.getParameter("Lssue_Dept")));
			setReview_Inteval(CommUtil.StrToGB2312(request.getParameter("Review_Inteval")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
			
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
			setUId(CommUtil.StrToGB2312(request.getParameter("UId")));
			setFunc_Type_Id(CommUtil.StrToGB2312(request.getParameter("Func_Type_Id")));
			setFunc_Corp_Id(CommUtil.StrToGB2312(request.getParameter("Func_Corp_Id")));
			setFunc_Cpm_Id(CommUtil.StrToGB2312(request.getParameter("Func_Cpm_Id")));
			
			
			
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String Sys_Id;
	private String Card_Type;
	private String Card_Type_Name;
	private String Card_Id;
	private String Card_BTime;
	private String Card_ETime;
	private String Card_Review;
	private String Card_Images;
	private String Train_Dept;
	private String Manag_Dept;
	private String Lssue_Dept;
	private String Review_Inteval;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	
	private String Sid;
	private String UId;
	private String Func_Type_Id;
	private String Func_Corp_Id;
	private String Func_Cpm_Id;
	
	
	
	
	public String getCard_Images() {
		return Card_Images;
	}

	public void setCard_Images(String card_Images) {
		Card_Images = card_Images;
	}

	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String func_Type_Id) {
		Func_Type_Id = func_Type_Id;
	}

	public String getFunc_Corp_Id() {
		return Func_Corp_Id;
	}

	public void setFunc_Corp_Id(String func_Corp_Id) {
		Func_Corp_Id = func_Corp_Id;
	}

	public String getFunc_Cpm_Id() {
		return Func_Cpm_Id;
	}

	public void setFunc_Cpm_Id(String func_Cpm_Id) {
		Func_Cpm_Id = func_Cpm_Id;
	}

	public String getSys_Id() {
		return Sys_Id;
	}

	public void setSys_Id(String sysId) {
		Sys_Id = sysId;
	}

	public String getCard_Type() {
		return Card_Type;
	}

	public void setCard_Type(String cardType) {
		Card_Type = cardType;
	}

	public String getCard_Type_Name() {
		return Card_Type_Name;
	}

	public void setCard_Type_Name(String cardTypeName) {
		Card_Type_Name = cardTypeName;
	}

	public String getCard_Id() {
		return Card_Id;
	}

	public void setCard_Id(String cardId) {
		Card_Id = cardId;
	}

	public String getCard_BTime() {
		return Card_BTime;
	}

	public void setCard_BTime(String cardBTime) {
		Card_BTime = cardBTime;
	}

	public String getCard_ETime() {
		return Card_ETime;
	}

	public void setCard_ETime(String cardETime) {
		Card_ETime = cardETime;
	}

	public String getCard_Review() {
		return Card_Review;
	}

	public void setCard_Review(String cardReview) {
		Card_Review = cardReview;
	}

	public String getTrain_Dept() {
		return Train_Dept;
	}

	public void setTrain_Dept(String trainDept) {
		Train_Dept = trainDept;
	}

	public String getManag_Dept() {
		return Manag_Dept;
	}

	public void setManag_Dept(String managDept) {
		Manag_Dept = managDept;
	}

	public String getLssue_Dept() {
		return Lssue_Dept;
	}

	public void setLssue_Dept(String lssueDept) {
		Lssue_Dept = lssueDept;
	}

	public String getReview_Inteval() {
		return Review_Inteval;
	}

	public void setReview_Inteval(String reviewInteval) {
		Review_Inteval = reviewInteval;
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

	public String getUId() {
		return UId;
	}

	public void setUId(String uId) {
		UId = uId;
	}
}