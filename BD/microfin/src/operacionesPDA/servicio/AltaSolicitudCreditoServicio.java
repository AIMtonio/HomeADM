package operacionesPDA.servicio;

import general.servicio.BaseServicio;

import org.apache.log4j.Logger;

import operacionesPDA.beanWS.request.AltaSolicitudCreditoRequest;
import operacionesPDA.beanWS.request.AltaSolicitudGrupalRequest;
import operacionesPDA.beanWS.response.AltaSolicitudCreditoResponse;
import operacionesPDA.beanWS.response.AltaSolicitudGrupalResponse;
import operacionesPDA.dao.AltaSolicitudCreditoDAO;

public class AltaSolicitudCreditoServicio extends BaseServicio{
	// ALTA DE SOLICITUD DE CREDITO PARA SANA TUS FINANZAS

	public AltaSolicitudCreditoDAO altaSolicitudCreditoDAO = null;
	public boolean error;
	public Logger loggerSolicitudCred = Logger.getLogger("SolicitudCredito");

	public AltaSolicitudCreditoServicio() {
		super();
	}

	public AltaSolicitudCreditoResponse solicitud(AltaSolicitudCreditoRequest requestBean){
		AltaSolicitudCreditoResponse mensaje = null;
		mensaje = altaSolicitudCreditoDAO.altaSolicitudCreditoWS(requestBean);
		return mensaje;
	}
	
	public AltaSolicitudGrupalResponse solicitudGrupal(AltaSolicitudGrupalRequest requestBean){
		AltaSolicitudGrupalResponse mensaje = null;
		mensaje = altaSolicitudCreditoDAO.altaSolicitudGrupalWS(requestBean);
		return mensaje;
	}

	public AltaSolicitudCreditoDAO getAltaSolicitudCreditoDAO() {
		return altaSolicitudCreditoDAO;
	}

	public void setAltaSolicitudCreditoDAO(
			AltaSolicitudCreditoDAO altaSolicitudCreditoDAO) {
		this.altaSolicitudCreditoDAO = altaSolicitudCreditoDAO;
	}
}
