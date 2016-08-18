/*
 * 0:查询全部 
 * 1：查询单个 
 * 2：插入Insert 
 * 3：修改update case 
 * 4: 删除 delete
 * 5: 执行函数
 * */
package rmi;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.CallableStatement;//用于执行sql存储过程的接口
import util.*;
import java.util.*;
import bean.*;
import oracle.jdbc.OracleTypes;

public class RmiImpl extends UnicastRemoteObject implements Rmi
{
	public final static long serialVersionUID = 1001;
	
	private DBUtil m_DBUtil = null;	
	
	public RmiImpl() throws RemoteException
	{	 
		
	}
	public void Init(DBUtil pDbUtil)
	{
		m_DBUtil = pDbUtil;
	}
	//RMI测试	
	public boolean Test()throws RemoteException
	{
		return true;
	}
	public MsgBean RmiExec(int pCmd, RmiBean pBean, int CurrPage) throws RemoteException
	{
		MsgBean objBean = null;
		ArrayList<?> aList = null;
		String Sql = pBean.getSql(pCmd);		
		int recordCount = 0;
		System.out.println("ClassId:["+pBean.getClassId()+"]"+" ClassName["+pBean.getClassName()+"]"+" Cmd["+ pCmd + "]");
		System.out.println("BSql["+Sql+"]");
		switch(pCmd/10)
		{
			case 0://查询
				if(0 < CurrPage)
				{
					//总数
					recordCount = Integer.parseInt(doRecordCount("select count(*) as counts from (" + Sql + ")subselect"));
					System.out.println("RecordCount["+recordCount+"]");
					//分页
					Sql = Sql + " LIMIT " + MsgBean.CONST_PAGE_SIZE + " OFFSET " + (CurrPage-1)*MsgBean.CONST_PAGE_SIZE;
					System.out.println("ESql["+Sql+"]");
					System.out.println("条数["+MsgBean.CONST_PAGE_SIZE+"]");
				}				
				aList = doSelect(Sql, pBean.getClassId());
				if(aList != null && aList.size() > 0)
				{
					objBean = new MsgBean(MsgBean.STA_SUCCESS,  aList, recordCount);
				}
				else
				{
					objBean = new MsgBean(MsgBean.STA_FAILED,  null, recordCount);
				}
				break;
			case 1://插入,更新,删除				
				if(doUpdate(Sql))    
				{		
					objBean = new MsgBean(MsgBean.STA_SUCCESS, null, recordCount);
				}
				else
				{
					objBean = new MsgBean(MsgBean.STA_FAILED, CommUtil.IntToStringLeftFillSpace(MsgBean.STA_FAILED, 4), recordCount);
				}	
				break;
			case 2://Function调用
				String rst = doFunction(Sql); 
				CommUtil.PRINT(rst);
				if(rst != null && rst.substring(0, 4).equals("0000"))    
				{		
					objBean = new MsgBean(MsgBean.STA_SUCCESS, rst, recordCount);
				}
				else
				{
					objBean = new MsgBean(Integer.parseInt(rst.substring(0, 4)), rst.substring(0, 4), recordCount);
				}	
				break;
			case 3://Package调用
				aList = Do_Package(Sql, pBean.getClassId());
				if(aList != null && aList.size() > 0)
				{
					objBean = new MsgBean(MsgBean.STA_SUCCESS,  aList, recordCount);
				}
				else
				{
					objBean = new MsgBean(MsgBean.STA_FAILED,  null, recordCount);
				}
				break;
			case 4://Producer调用
				doProducer(Sql); 
				rst = "0000";
				CommUtil.PRINT(rst);
				if(rst != null && rst.substring(0, 4).equals("0000"))    
				{		
					objBean = new MsgBean(MsgBean.STA_SUCCESS, rst, recordCount);
				}
				else
				{
					objBean = new MsgBean(Integer.parseInt(rst.substring(0, 4)), rst.substring(0, 4), recordCount);
				}	
				break;
		}			
		return objBean;
	}
	
//=======================================================================
	public  ArrayList<?> doSelect(String pSql, long pClass) //Bean Type
	{
		ArrayList<Object> alist = new ArrayList<Object>();
		RmiBean rmiBean = null;
		Connection conn = null;
		PreparedStatement pStmt = null;
		ResultSet rs = null;
		try 
		{
			conn = m_DBUtil.objConnPool.getConnection();
			conn.setAutoCommit(false);
			pStmt = conn.prepareStatement(pSql);
			rs = pStmt.executeQuery();
			while(rs.next())
			{
				switch((int)pClass)
				{
				/******************system****************/
				/******************admin*****************/
					case RmiBean.RMI_CORP_INFO:
						rmiBean = new CorpInfoBean();
						break;
					case RmiBean.RMI_USER_INFO:
						rmiBean = new UserInfoBean();
						break;
					case RmiBean.RMI_USER_ROLE:
						rmiBean = new UserRoleBean();
						break;
					case RmiBean.RMI_DEVICE_DETAIL:
				 		rmiBean = new DeviceDetailBean();
				 		break;
					case RmiBean.RMI_AQSC_EXAM_TYPE:
						rmiBean = new AqscExamTypeBean();
						break;
					case RmiBean.RMI_AQSC_DANGER_TYPE:
						rmiBean = new AqscDangerTypeBean();
						break;
					case RmiBean.RMI_AQSC_DANGER_LEVEL:
						rmiBean = new AqscDangerLevelBean();
						break;
					case RmiBean.RMI_USER_POSITION:
						rmiBean = new UserPositionBean();
						break;
					case RmiBean.RMI_AQSC_TRAIN_TYPE:
						rmiBean = new AqscTrainTypeBean();
						break;
					case RmiBean.RMI_AQSC_DRILL_TYPE:
						rmiBean = new AqscDrillTypeBean();
						break;
					case RmiBean.RMI_AQSC_CARD_TYPE:
						rmiBean = new AqscCardTypeBean();
						break;
					case RmiBean.RMI_AQSC_LABOUR_TYPE:
						rmiBean = new AqscLabourTypeBean();
						break;
					case RmiBean.RMI_AQSC_ACT_TYPE:
						rmiBean = new AqscActTypeBean();
						break;
					case RmiBean.RMI_AQSC_DEVICE_TYPE:
						rmiBean = new AqscDeviceTypeBean();
						break;
					case RmiBean.RMI_AQSC_DEVICE_CARD:
						rmiBean = new AqscDeviceCardBean();
						break;
					case RmiBean.RMI_AQSC_SPARE_TYPE:
						rmiBean = new AqscSpareTypeBean();
						break;
					case RmiBean.RMI_CRM_INFO:
						rmiBean = new CrmInfoBean();
						break;
					case RmiBean.RMI_CCM_INFO:
						rmiBean = new CcmInfoBean();
						break;
					case RmiBean.RMI_AQSC_DEVICE_BREED:
						rmiBean = new AqscDeviceBreedBean();
						break;
				/******************user*****************/
					case RmiBean.RMI_DATA:
						rmiBean = new DataBean();
						break;
					case RmiBean.RMI_ALARM:
						rmiBean = new AlarmInfoBean();
						break;
					case RmiBean.RMI_ALERT:
						rmiBean = new AlertInfoBean();
						break;
					case RmiBean.RMI_PRO_I:
						rmiBean = new ProIBean();
						break;
					case RmiBean.RMI_PRO_O:
						rmiBean = new ProOBean();
						break;
					case RmiBean.RMI_PRO_L:
						rmiBean = new ProLBean();
						break;
					case RmiBean.RMI_PRO_R:
						rmiBean = new ProRBean();
						break;
					case RmiBean.RMI_SAT_CHECK:
						rmiBean = new SatCheckBean();
						break;
					case RmiBean.RMI_SAT_DANGER:
						rmiBean = new SatDangerBean();
						break;
					case RmiBean.RMI_SAT_BREAK:
						rmiBean = new SatBreakBean();
						break;
					case RmiBean.RMI_SAT_TRAIN:
						rmiBean = new SatTrainBean();
						break;
					case RmiBean.RMI_SAT_DRILL:
						rmiBean = new SatDrillBean();
						break;
					case RmiBean.RMI_SAT_CHECK_L:
						rmiBean = new SatCheckLBean();
						break;
					case RmiBean.RMI_SAT_TRAIN_L:
						rmiBean = new SatTrainLBean();
						break;
					case RmiBean.RMI_SAT_DRILL_L:
						rmiBean = new SatDrillLBean();
						break;
					case RmiBean.RMI_CAD_STATUS:
						rmiBean = new CadStatusBean();
						break;
					case RmiBean.RMI_CAD_REMIND:
						rmiBean = new CadRemindBean();
						break;
					case RmiBean.RMI_CAD_ACTION:
						rmiBean = new CadActionBean();
						break;						
					case RmiBean.RMI_LAB_STORE:
						rmiBean = new LabStoreBean();
						break;
					case RmiBean.RMI_LAB_STORE_I:
						rmiBean = new LabStoreIBean();
						break;
					case RmiBean.RMI_LAB_STORE_O:
						rmiBean = new LabStoreOBean();
						break;
					case RmiBean.RMI_DEV_LIST:
						rmiBean = new DevListBean();
						break;
					case RmiBean.RMI_DEV_REMIND:
						rmiBean = new DevRemindBean();
						break;
					case RmiBean.RMI_DEV_LIST_CARD:
						rmiBean = new DevListCardBean();
						break;
					case RmiBean.RMI_SPA_STORE:
						rmiBean = new SpaStoreBean();
						break;
					case RmiBean.RMI_SPA_STORE_I:
						rmiBean = new SpaStoreIBean();
						break;
					case RmiBean.RMI_SPA_STORE_O:
						rmiBean = new SpaStoreOBean();
						break;
					case RmiBean.RMI_SPA_STATION:
						rmiBean = new SpaStationBean();
						break;
					case RmiBean.RMI_SPA_STORE_L:
						rmiBean = new SpaStoreLBean();
						break;
					case RmiBean.RMI_SPA_STATION_L:
						rmiBean = new SpaStationLBean();
						break;						
					case RmiBean.RMI_FIX_TRACE:
						rmiBean = new FixTraceBean();
						break;
					case RmiBean.RMI_FIX_LEDGER:
						rmiBean = new FixLedgerBean();
						break;
					case RmiBean.RMI_PRO_L_CRM:
						rmiBean = new ProLCrmBean();
						break;
					case RmiBean.RMI_PRO_L_CRP:
						rmiBean = new ProLCrpBean();
						break;
					case RmiBean.RMI_P_L_CRM:
						rmiBean = new PLCrmBean();
						break;
					case RmiBean.RMI_LAB_STORE_P:
						rmiBean = new LabStorePBean();
						break;
					case RmiBean.RMI_SPA_STORE_P:
						rmiBean = new SpaStorePBean();
						break;
					case RmiBean.RMI_DATE_BAO:
						rmiBean = new DateBaoBean();
						break;
					case RmiBean.RMI_PRO_I_TANK:
						rmiBean = new ProITankBean();
						break;
						
				}
				rmiBean.getData(rs);
				alist.add(rmiBean);
			}
		} catch (SQLException sqlExp)
		{
			sqlExp.printStackTrace();
		}
		finally
		{
			try
			{
				if(rs != null)
				{				
					rs.close();
					rs = null;
				}
				if(pStmt != null)
				{				
					pStmt.close();
					pStmt = null;
				}
				if(conn != null)
				{
					conn.close();	
					conn = null;
				}
			}catch(Exception ex)
			{ex.printStackTrace();}
		}
		return alist;
	}
	
	public  boolean doUpdate(String pSql)
	{
		boolean IsOK = false;
		Connection conn = null;
		PreparedStatement pStmt = null;
		try 
		{
			conn = m_DBUtil.objConnPool.getConnection();
			conn.setAutoCommit(false);
			pStmt = conn.prepareStatement(pSql);
			if (pStmt.executeUpdate() > 0) 
			{
				IsOK = true;
				conn.commit();
			} 
		} 
		catch (SQLException sqlExp) 
		{
			sqlExp.printStackTrace();
		}
		finally
		{
			try
			{
				if(pStmt != null)
				{				
					pStmt.close();
					pStmt = null;
				}
				if(conn != null)
				{
					conn.close();	
					conn = null;
				}
			}catch(Exception ex)
			{ex.printStackTrace();}
		}
		return IsOK;
	}
	
	public  String doFunction(String pSql)
	{
		String rslt = null;
		Connection conn = null;
		CallableStatement cstat = null;
		try 
		{
			conn = m_DBUtil.objConnPool.getConnection();
			conn.setAutoCommit(false);
			cstat = conn.prepareCall(pSql);
			cstat.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstat.execute();
			rslt = cstat.getString(1);
			conn.commit();
			//System.out.println("rslt:" + rslt);
		}
		catch(SQLException sqlExp)
		{
			sqlExp.printStackTrace();
			return  CommUtil.IntToStringLeftFillSpace(MsgBean.STA_FAILED, 4);
		}
		finally
		{
			try
			{
				if(cstat != null)
				{				
					cstat.close();
					cstat = null;
				}
				if(conn != null)
				{
					conn.close();	
					conn = null;
				}
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
		return rslt;
	}
	
	public  String doProducer(String pSql)
	{
		String rslt = null;
		Connection conn = null;
		CallableStatement cstat = null;
		try 
		{
			conn = m_DBUtil.objConnPool.getConnection();
			conn.setAutoCommit(false);
			cstat = conn.prepareCall(pSql);
			cstat.execute();
			conn.commit();
			//System.out.println("rslt:" + rslt);
		}
		catch(SQLException sqlExp)
		{
			sqlExp.printStackTrace();
			return  CommUtil.IntToStringLeftFillSpace(MsgBean.STA_FAILED, 4);
		}
		finally
		{
			try
			{
				if(cstat != null)
				{				
					cstat.close();
					cstat = null;
				}
				if(conn != null)
				{
					conn.close();	
					conn = null;
				}
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
		return rslt;
	}
	public String doRecordCount(String pSql)
	{
		String rslt = null;
		Connection conn = null;
		PreparedStatement pStmt = null;
		ResultSet rs = null;
		try 
		{
			conn = m_DBUtil.objConnPool.getConnection();
			conn.setAutoCommit(false);
			pStmt = conn.prepareStatement(pSql);
			rs = pStmt.executeQuery();		
			while(rs.next())
			{
				rslt = rs.getString("counts");
			}
		} 
		catch (SQLException sqlExp) 
		{
			sqlExp.printStackTrace();
		}
		finally
		{
			try
			{
				if(rs != null)
				{				
					rs.close();
					rs = null;
				}
				if(pStmt != null)
				{				
					pStmt.close();
					pStmt = null;
				}
				if(conn != null)
				{
					conn.close();	
					conn = null;
				}
			}catch(Exception ex)
			{ex.printStackTrace();}
		}
		return rslt;
	}
	
	public ArrayList<?> Do_Package(String pSql, long pClass) 
	{
		ArrayList<Object> alist = new ArrayList<Object>();
		RmiBean rmiBean = null;
		Connection conn = null;
		CallableStatement cstmt = null;
		ResultSet rs = null;
		try 
		{
			conn = m_DBUtil.objConnPool.getConnection();
			cstmt = conn.prepareCall(pSql);
			cstmt.registerOutParameter(1, OracleTypes.CURSOR);
			cstmt.execute();
			rs = (ResultSet) cstmt.getObject(1);
			while(rs.next())
			{
				switch((int)pClass)
				{
					//case RmiBean.RMI_SURROUNDINGS_INFO:
							//rmiBean = new SurroundingsInfoBean();
						//break;
				}
				rmiBean.getData(rs);						
				alist.add(rmiBean);	
			}
		} catch (SQLException sqlExp) 
		{
		sqlExp.printStackTrace();
		}
		finally
		{
			try
			{
				if(rs != null)
				{				
					rs.close();
					rs = null;
				}
				if(cstmt != null)
				{				
					cstmt.close();
					cstmt = null;
				}
				if(conn != null)
				{
					conn.close();	
					conn = null;
				}
			}catch(Exception ex)
			{ex.printStackTrace();}
		}
		return alist;
	}
}
