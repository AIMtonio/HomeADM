package operacionesPDA.servicio;

import general.servicio.BaseServicio;

import org.apache.log4j.Logger;

import operacionesPDA.beanWS.request.SP_PDA_Socio_Alta3ReyesRequest;
import operacionesPDA.beanWS.response.SP_PDA_Socios_Alta3ReyesResponse;
import operacionesPDA.dao.SP_PDA_Socio_Alta3ReyesDAO;



public class SP_PDA_Socio_Alta3ReyesServicio extends BaseServicio {
	SP_PDA_Socio_Alta3ReyesDAO sp_PDA_Socio_Alta3ReyesDAO = null;
	
	private SP_PDA_Socio_Alta3ReyesServicio(){
		super();
	}
	
	public boolean error;
	Logger loggerSocioAlta = Logger.getLogger("SocioAlta");
	

	
	public SP_PDA_Socios_Alta3ReyesResponse alta(SP_PDA_Socio_Alta3ReyesRequest requestBean){
		SP_PDA_Socios_Alta3ReyesResponse mensaje = null;
		mensaje = sp_PDA_Socio_Alta3ReyesDAO.socioAltaWS(requestBean);		
		return mensaje;
	}


	public SP_PDA_Socio_Alta3ReyesDAO getSp_PDA_Socio_Alta3ReyesDAO() {
		return sp_PDA_Socio_Alta3ReyesDAO;
	}


	public void setSp_PDA_Socio_Alta3ReyesDAO(
			SP_PDA_Socio_Alta3ReyesDAO sp_PDA_Socio_Alta3ReyesDAO) {
		this.sp_PDA_Socio_Alta3ReyesDAO = sp_PDA_Socio_Alta3ReyesDAO;
	}
}
