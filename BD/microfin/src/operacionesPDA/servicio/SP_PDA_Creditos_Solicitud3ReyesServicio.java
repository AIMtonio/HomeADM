package operacionesPDA.servicio;

import general.servicio.BaseServicio;

import org.apache.log4j.Logger;

import operacionesPDA.beanWS.request.SP_PDA_Creditos_Solicitud3ReyesRequest;
import operacionesPDA.beanWS.response.SP_PDA_Creditos_Solicitud3ReyesResponse;
import operacionesPDA.dao.SP_PDA_Creditos_Solicitud3ReyesDAO;

public class SP_PDA_Creditos_Solicitud3ReyesServicio extends BaseServicio{
	SP_PDA_Creditos_Solicitud3ReyesDAO sp_PDA_Creditos_Solicitud3ReyesDAO = null;
	
	private SP_PDA_Creditos_Solicitud3ReyesServicio(){
		super();
	}
	
	public boolean error;
	Logger loggerSolicitudCred = Logger.getLogger("SolicitudCredito");
	
	
	public SP_PDA_Creditos_Solicitud3ReyesResponse solicitud(SP_PDA_Creditos_Solicitud3ReyesRequest requestBean){
		SP_PDA_Creditos_Solicitud3ReyesResponse mensaje = null;
		mensaje = sp_PDA_Creditos_Solicitud3ReyesDAO.solicitudCreditoWS(requestBean);		
		return mensaje;
	}


	public SP_PDA_Creditos_Solicitud3ReyesDAO getSp_PDA_Creditos_Solicitud3ReyesDAO() {
		return sp_PDA_Creditos_Solicitud3ReyesDAO;
	}


	public void setSp_PDA_Creditos_Solicitud3ReyesDAO(
			SP_PDA_Creditos_Solicitud3ReyesDAO sp_PDA_Creditos_Solicitud3ReyesDAO) {
		this.sp_PDA_Creditos_Solicitud3ReyesDAO = sp_PDA_Creditos_Solicitud3ReyesDAO;
	}

}
