package operacionesPDM.servicio;

import operacionesPDM.beanWS.request.SP_PDM_Ahorros_AbonoCtaRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_AbonoCtaResponse;
import operacionesPDM.dao.SP_PDM_Ahorros_AbonoCtaDAO;
import general.servicio.BaseServicio;

public class SP_PDM_Ahorros_AbonoCtaServicio extends BaseServicio {
	
	SP_PDM_Ahorros_AbonoCtaDAO sP_PDM_Ahorros_AbonoCtaDAO = null;
	
	private SP_PDM_Ahorros_AbonoCtaServicio(){
		super();
	}
	
	public static interface Enum_Tra_PDM_WS {
		int abonoCtaWSSofi	= 1;
	}
	
	public SP_PDM_Ahorros_AbonoCtaResponse grabaTransaccion(SP_PDM_Ahorros_AbonoCtaRequest requestBean, int tipoTransaccion){
		SP_PDM_Ahorros_AbonoCtaResponse mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_PDM_WS.abonoCtaWSSofi:
				mensaje = sP_PDM_Ahorros_AbonoCtaDAO.abonoCuentaWS(requestBean, tipoTransaccion);
			break;			
		}
		return mensaje;
	}
	
	public SP_PDM_Ahorros_AbonoCtaDAO getSP_PDM_Ahorros_AbonoCtaDAO() {
		return sP_PDM_Ahorros_AbonoCtaDAO;
	}
	public void setSP_PDM_Ahorros_AbonoCtaDAO(SP_PDM_Ahorros_AbonoCtaDAO sP_PDM_Ahorros_AbonoCtaDAO) {
		this.sP_PDM_Ahorros_AbonoCtaDAO = sP_PDM_Ahorros_AbonoCtaDAO;
	}

}
