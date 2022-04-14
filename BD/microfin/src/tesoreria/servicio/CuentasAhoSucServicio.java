package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import tesoreria.bean.CuentasAhoSucBean;
import tesoreria.dao.CuentasAhoSucDAO;


public class CuentasAhoSucServicio extends BaseServicio{

	CuentasAhoSucDAO cuentasAhoSucDAO=null;
	
	private CuentasAhoSucServicio(){
		super();
	}
	public static interface Enum_Tra_CuentasSucursal {
		int alta 		 = 1;
		int modificar	 =2;
		
	}
	public static interface Enum_Con_CuentasSucursal {
		int fecha 		 = 3;
		
	}	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,CuentasAhoSucBean cuentasAhoSucBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) { 
			case Enum_Tra_CuentasSucursal.alta:		
				mensaje = 	cuentasAhoSucDAO.altaCuentaSuc(cuentasAhoSucBean);	
				break;				
			case Enum_Tra_CuentasSucursal.modificar:		
				mensaje = 	cuentasAhoSucDAO.modificarCuentaSuc(cuentasAhoSucBean);	
				break;
		}
		return mensaje;
	}
	
	public void setCuentasAhoSucDAO(CuentasAhoSucDAO cuentasAhoSucDAO){
		this.cuentasAhoSucDAO = cuentasAhoSucDAO;
	}
	
	public CuentasAhoSucDAO getcuentasAhoSucDAO(){
		return cuentasAhoSucDAO;
	}
}
