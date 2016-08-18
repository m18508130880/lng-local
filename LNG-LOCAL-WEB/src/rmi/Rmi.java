package rmi;
import java.rmi.Remote;
import java.rmi.RemoteException;
import util.*;

public interface Rmi extends Remote
{
	
	public int Lock_Pro_Day_Text = 0;
	
	public boolean Test()throws RemoteException;
	public MsgBean RmiExec(int pCmd, RmiBean pBean, int CurrPage) throws RemoteException;
}