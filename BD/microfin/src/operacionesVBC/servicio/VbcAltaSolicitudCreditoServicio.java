package operacionesVBC.servicio;

import operacionesVBC.beanWS.request.VbcAltaSolicitudCreditoRequest;
import operacionesVBC.beanWS.response.VbcAltaSolicitudCreditoResponse;
import operacionesVBC.dao.VbcAltaSolicitudCreditoDAO;
import general.servicio.BaseServicio;

public class VbcAltaSolicitudCreditoServicio extends BaseServicio{

	VbcAltaSolicitudCreditoDAO vbcAltaSolicitudCreditoDAO = null;
	public VbcAltaSolicitudCreditoServicio(){
		super();
	}
	
	public VbcAltaSolicitudCreditoResponse altaModificaReferencia(VbcAltaSolicitudCreditoRequest request){
		VbcAltaSolicitudCreditoResponse mensaje=null;
		mensaje= vbcAltaSolicitudCreditoDAO.procesoSolicitud(request);
		return mensaje;
	}

	public VbcAltaSolicitudCreditoDAO getVbcAltaSolicitudCreditoDAO() {
		return vbcAltaSolicitudCreditoDAO;
	}

	public void setVbcAltaSolicitudCreditoDAO(VbcAltaSolicitudCreditoDAO vbcAltaSolicitudCreditoDAO) {
		this.vbcAltaSolicitudCreditoDAO = vbcAltaSolicitudCreditoDAO;
	}
	
	
}