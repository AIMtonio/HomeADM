package operacionesCRCB.servicio;

import operacionesCRCB.beanWS.request.AltaCreditoRequest;
import operacionesCRCB.beanWS.response.AltaCreditoResponse;
import operacionesCRCB.dao.AltaCreditoDAO;
import general.servicio.BaseServicio;

public class AltaCreditoServicio extends BaseServicio{
	
	AltaCreditoDAO altaCreditoDAO = null;
	
	public AltaCreditoServicio (){
		super();
	}
	
	public AltaCreditoResponse altaCredito (AltaCreditoRequest requestBean){
		AltaCreditoResponse response = null;
		
		response = altaCreditoDAO.altaCreditoWS(requestBean);
		
		return response;
		
	}
	// ========== GETTER & SETTER ============
	
	public AltaCreditoDAO getAltaCreditoDAO() {
		return altaCreditoDAO;
	}

	public void setAltaCreditoDAO(AltaCreditoDAO altaCreditoDAO) {
		this.altaCreditoDAO = altaCreditoDAO;
	}
}
