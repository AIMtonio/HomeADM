package cuentas.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.dao.CuentasMayorAhoDAO;
import cuentas.bean.CuentasMayorAhoBean;

public class CuentasMayorAhoServicio  extends BaseServicio {

	private CuentasMayorAhoServicio(){
		super();
	}

	CuentasMayorAhoDAO cuentasMayorAhoDAO = null;

	public static interface Enum_Tra_CuentaMayorAho {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_CuentaMayorAho{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_CuentaMayorAho{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CuentasMayorAhoBean cuentaMayorAho){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_CuentaMayorAho.alta:
			mensaje = cuentasMayorAhoDAO.alta(cuentaMayorAho);
			break;
		case Enum_Tra_CuentaMayorAho.modificacion:
			mensaje = cuentasMayorAhoDAO.modifica(cuentaMayorAho);
			break;
		case Enum_Tra_CuentaMayorAho.baja:
			mensaje = cuentasMayorAhoDAO.baja(cuentaMayorAho);
			break;
		}
		return mensaje;
	}

	public CuentasMayorAhoBean consulta(int tipoConsulta, CuentasMayorAhoBean cuentaMayorAho){
		CuentasMayorAhoBean cuentasMayorAhoBean = null;
		switch(tipoConsulta){
			case Enum_Con_CuentaMayorAho.principal:
				cuentasMayorAhoBean = cuentasMayorAhoDAO.consultaPrincipal(cuentaMayorAho, Enum_Con_CuentaMayorAho.principal);
			break;		
		}
		return cuentasMayorAhoBean;
	}

	public void setCuentasMayorAhoDAO(CuentasMayorAhoDAO cuentasMayorAhoDAO) {
		this.cuentasMayorAhoDAO = cuentasMayorAhoDAO;
	}
}

