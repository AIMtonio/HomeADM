package fondeador.servicio;

import fondeador.bean.CuentasMayorCreditoPasBean;
import fondeador.dao.CuentasMayorCreditoPasDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.bean.CuentasMayorAhoBean;


public class CuentasMayorCreditoPasServicio extends BaseServicio{

	private CuentasMayorCreditoPasServicio(){
		super();
	}

	CuentasMayorCreditoPasDAO cuentasMayorCreditoPasDAO = null;

	public static interface Enum_Tra_CuentaMayorFon {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_CuentaMayorFon{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_CuentaMayorFon{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CuentasMayorCreditoPasBean cuentasMayorCreditoPas){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_CuentaMayorFon.alta:
			mensaje = cuentasMayorCreditoPasDAO.alta(cuentasMayorCreditoPas);
			break;
		case Enum_Tra_CuentaMayorFon.modificacion:
			mensaje = cuentasMayorCreditoPasDAO.modifica(cuentasMayorCreditoPas);
			break;
		case Enum_Tra_CuentaMayorFon.baja:
			mensaje = cuentasMayorCreditoPasDAO.baja(cuentasMayorCreditoPas);
			break;
		}
		return mensaje;
	}

	public CuentasMayorCreditoPasBean consulta(int tipoConsulta, CuentasMayorCreditoPasBean cuentasMayorCreditoPas){
		CuentasMayorCreditoPasBean cuentasMayorCreditoPasBean = null;
		switch(tipoConsulta){
			case Enum_Con_CuentaMayorFon.principal:
				cuentasMayorCreditoPasBean = cuentasMayorCreditoPasDAO.consultaPrincipal(cuentasMayorCreditoPas, Enum_Con_CuentaMayorFon.principal);
			break;		
		}
		return cuentasMayorCreditoPasBean;
	}

	public CuentasMayorCreditoPasDAO getCuentasMayorCreditoPasDAO() {
		return cuentasMayorCreditoPasDAO;
	}

	public void setCuentasMayorCreditoPasDAO(
			CuentasMayorCreditoPasDAO cuentasMayorCreditoPasDAO) {
		this.cuentasMayorCreditoPasDAO = cuentasMayorCreditoPasDAO;
	}

	
}
