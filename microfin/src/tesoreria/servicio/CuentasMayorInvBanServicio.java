package tesoreria.servicio;

import tesoreria.bean.CuentasMayorInvBanBean;
import tesoreria.dao.CuentasMayorInvBanDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CuentasMayorInvBanServicio extends BaseServicio {

	private CuentasMayorInvBanServicio(){
		super();
	}

	CuentasMayorInvBanDAO cuentasMayorInvBanDAO = null;

	public static interface Enum_Tra_CuentaMayorInv {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_CuentaMayorInv{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_CuentaMayorInv{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CuentasMayorInvBanBean cuentaMayorAho){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_CuentaMayorInv.alta:
			mensaje = cuentasMayorInvBanDAO.alta(cuentaMayorAho);
			break;
		case Enum_Tra_CuentaMayorInv.modificacion:
			mensaje = cuentasMayorInvBanDAO.modifica(cuentaMayorAho);
			break;
		case Enum_Tra_CuentaMayorInv.baja:
			mensaje = cuentasMayorInvBanDAO.baja(cuentaMayorAho);
			break;
		}
		return mensaje;
	}

	public CuentasMayorInvBanBean consulta(int tipoConsulta, CuentasMayorInvBanBean cuentasMayorInvBanBean){
		CuentasMayorInvBanBean cuentasMayorInvBanBea = null;
		switch(tipoConsulta){
			case Enum_Con_CuentaMayorInv.principal:
				cuentasMayorInvBanBea = cuentasMayorInvBanDAO.consulta(cuentasMayorInvBanBean, Enum_Con_CuentaMayorInv.principal);
			break;		
		}
		return cuentasMayorInvBanBea;
	}

	public void setCuentasMayorInvBanDAO(CuentasMayorInvBanDAO cuentasMayorInvBanDAO) {
		this.cuentasMayorInvBanDAO = cuentasMayorInvBanDAO;
	}
}