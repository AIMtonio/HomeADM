package aportaciones.servicio;

import aportaciones.bean.CuentasMayorAportacionBean;
import aportaciones.dao.CuentasMayorAportacionDAO;
import general.servicio.BaseServicio;

public class CuentasMayorAportacionServicio extends BaseServicio {
	
	private CuentasMayorAportacionServicio(){
		super();
	}
	
	CuentasMayorAportacionDAO cuentasMayorAportacionDAO = null;
	
	public static interface Enum_Tra_CuentaMayorAportacion {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_CuentaMayorAportacion{
		int principal = 1;
	}
	
	public CuentasMayorAportacionBean consulta(int tipoConsulta, CuentasMayorAportacionBean cuentaMayorAportacion){
		CuentasMayorAportacionBean cuentasMayorAportacionBean = null;
		switch(tipoConsulta){
			case Enum_Con_CuentaMayorAportacion.principal:
				cuentasMayorAportacionBean = cuentasMayorAportacionDAO.consultaPrincipal(cuentaMayorAportacion, Enum_Con_CuentaMayorAportacion.principal);
			break;		
		}
		return cuentasMayorAportacionBean;
	}

	public CuentasMayorAportacionDAO getCuentasMayorAportacionDAO() {
		return cuentasMayorAportacionDAO;
	}

	public void setCuentasMayorAportacionDAO(
			CuentasMayorAportacionDAO cuentasMayorAportacionDAO) {
		this.cuentasMayorAportacionDAO = cuentasMayorAportacionDAO;
	}

}
