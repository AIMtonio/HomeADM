package cedes.servicio;

import cedes.bean.CuentasMayorCedeBean;
import cedes.dao.CuentasMayorCedeDAO;
import general.servicio.BaseServicio;

public class CuentasMayorCedeServicio extends BaseServicio{
	 
	private CuentasMayorCedeServicio(){
		super();
	}
	
	CuentasMayorCedeDAO cuentasMayorCedeDAO = null;
	
	public static interface Enum_Tra_CuentaMayorCede {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_CuentaMayorCede{
		int principal = 1;
	}
	
	public CuentasMayorCedeBean consulta(int tipoConsulta, CuentasMayorCedeBean cedeMayorCede){
		CuentasMayorCedeBean cuentasMayorCedeBean = null;
		switch(tipoConsulta){
			case Enum_Con_CuentaMayorCede.principal:
				cuentasMayorCedeBean = cuentasMayorCedeDAO.consultaPrincipal(cedeMayorCede, Enum_Con_CuentaMayorCede.principal);
			break;		
		}
		return cuentasMayorCedeBean;
	}

	public CuentasMayorCedeDAO getCuentasMayorCedeDAO() {
		return cuentasMayorCedeDAO;
	}

	public void setCuentasMayorCedeDAO(CuentasMayorCedeDAO cuentasMayorCedeDAO) {
		this.cuentasMayorCedeDAO = cuentasMayorCedeDAO;
	}
	
	

}
