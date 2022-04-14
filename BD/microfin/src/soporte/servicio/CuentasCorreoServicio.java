package soporte.servicio;

import general.servicio.BaseServicio;
import soporte.bean.CuentasCorreoBean;
import soporte.bean.NotariaBean;
import soporte.dao.CuentaCorreoDAO;
import soporte.dao.NotariaDAO;
import soporte.servicio.NotariaServicio.Enum_Con_Notaria;

public class CuentasCorreoServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CuentaCorreoDAO cuentaCorreoDAO = null;			   

	public CuentasCorreoServicio() {
		super();
	}	
	
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_CuentaCorreo {
		int principal = 1;		
	}
	
	public CuentasCorreoBean consulta(int tipoConsulta, CuentasCorreoBean correoBean){
		CuentasCorreoBean cuentasCorreoBean = null;
		switch (tipoConsulta) {
			case Enum_Con_CuentaCorreo.principal:		
				cuentasCorreoBean = cuentaCorreoDAO.consultaPrincipal(correoBean, tipoConsulta);				
				break;
		}
				
		return cuentasCorreoBean;
	}
	
	
	public void setCuentaCorreoDAO(CuentaCorreoDAO cuentaCorreoDAO) {
		this.cuentaCorreoDAO = cuentaCorreoDAO;
	}
	
	
	
}
