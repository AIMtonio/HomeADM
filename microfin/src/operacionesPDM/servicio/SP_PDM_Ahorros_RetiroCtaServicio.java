package operacionesPDM.servicio;

import operacionesPDM.beanWS.request.SP_PDM_Ahorros_RetiroCtaRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_RetiroCtaResponse;
import operacionesPDM.dao.SP_PDM_Ahorros_RetiroCtaDAO;
import general.servicio.BaseServicio;

public class SP_PDM_Ahorros_RetiroCtaServicio extends BaseServicio {
	SP_PDM_Ahorros_RetiroCtaDAO sP_PDM_Ahorros_RetiroCtaDAO = null;
	
	private SP_PDM_Ahorros_RetiroCtaServicio(){
		super();
	}
	
	public static interface Enum_Tra_PDM_WS {
		int retiroCtaWSSofi	= 1;
	}
	
	public SP_PDM_Ahorros_RetiroCtaResponse grabaTransaccion(SP_PDM_Ahorros_RetiroCtaRequest requestBean, int tipoTransaccion){
		SP_PDM_Ahorros_RetiroCtaResponse mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_PDM_WS.retiroCtaWSSofi:
				mensaje = sP_PDM_Ahorros_RetiroCtaDAO.retiroCuentaWS(requestBean, tipoTransaccion);
			break;			
		}
		return mensaje;
	}
	
	public SP_PDM_Ahorros_RetiroCtaDAO getSP_PDM_Ahorros_RetiroCtaDAO() {
		return sP_PDM_Ahorros_RetiroCtaDAO;
	}
	public void setSP_PDM_Ahorros_RetiroCtaDAO(SP_PDM_Ahorros_RetiroCtaDAO sP_PDM_Ahorros_RetiroCtaDAO) {
		this.sP_PDM_Ahorros_RetiroCtaDAO = sP_PDM_Ahorros_RetiroCtaDAO;
	}

}
