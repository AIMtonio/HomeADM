package tesoreria.servicio;


import tesoreria.bean.CuentasMayorMonBean;
import tesoreria.dao.CuentasMayorMonDAO;
import general.servicio.BaseServicio;

public class CuentasMayorMonServicio extends BaseServicio {
	
	private CuentasMayorMonServicio(){
		super();
	}
	
	CuentasMayorMonDAO cuentasMayorMonDAO = null;
	
	public static interface Enum_Tra_CuentasMayorMon {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_CuentasMayorMon {
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_CuentasMayorMon {
		int principal = 1;
		int foranea = 2;
	}
	
	public CuentasMayorMonBean consulta(int tipoConsulta, CuentasMayorMonBean cuentaMayorMon){
		CuentasMayorMonBean cuentasMayorMonBean = null;
		switch(tipoConsulta){
			case Enum_Con_CuentasMayorMon.principal:
				cuentasMayorMonBean = cuentasMayorMonDAO.consultaPrincipal(cuentaMayorMon, Enum_Con_CuentasMayorMon.principal);
			break;		
		}
		return cuentasMayorMonBean;
	}

	public CuentasMayorMonDAO getCuentasMayorMonDAO() {
		return cuentasMayorMonDAO;
	}

	public void setCuentasMayorMonDAO(CuentasMayorMonDAO cuentasMayorMonDAO) {
		this.cuentasMayorMonDAO = cuentasMayorMonDAO;
	}
	
	


}
