package operacionesCRCB.servicio;

import operacionesCRCB.beanWS.request.AltaCuentaAutorizadaRequest;
import operacionesCRCB.beanWS.response.AltaCuentaAutorizadaResponse;
import operacionesCRCB.dao.CuentaAutorizadaDAO;
import general.servicio.BaseServicio;

public class CuentaAutorizadaServicio extends BaseServicio {

	CuentaAutorizadaDAO cuentaAutorizadaDAO = null;
	
	public CuentaAutorizadaServicio(){
		super();
	}
	
	public static interface Enum_Tran_Cuenta{
		int alta= 1;
	}
	
	public AltaCuentaAutorizadaResponse grabaTransaccion(AltaCuentaAutorizadaRequest altaCuentaAutorizadaRequest, int tipoTransaccion){
		AltaCuentaAutorizadaResponse altaCuentaResponse = null;
		switch(tipoTransaccion){
		case Enum_Tran_Cuenta.alta:
			altaCuentaResponse =  cuentaAutorizadaDAO.altaCuentaAhutorizada(altaCuentaAutorizadaRequest);
			break;
		}
		
		return altaCuentaResponse;
		
	}

	public CuentaAutorizadaDAO getCuentaAutorizadaDAO() {
		return cuentaAutorizadaDAO;
	}

	public void setCuentaAutorizadaDAO(CuentaAutorizadaDAO cuentaAutorizadaDAO) {
		this.cuentaAutorizadaDAO = cuentaAutorizadaDAO;
	}
	
	
	
	
}
