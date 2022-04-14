package operacionesCRCB.servicio;

import operacionesCRCB.beanWS.request.RompimientoGrupoRequest;
import operacionesCRCB.beanWS.response.RompimientoGrupoResponse;
import operacionesCRCB.dao.RompimientoGrupoWSDAO;
import general.servicio.BaseServicio;

public class RompimientoGrupoWSServicio extends BaseServicio {

	RompimientoGrupoWSDAO rompimientoGrupoWSDAO = null;

	public RompimientoGrupoWSServicio(){
		super();
	}
	
	public RompimientoGrupoResponse rompimientoGrupoWS(RompimientoGrupoRequest rompimientoGrupoRequest){
		RompimientoGrupoResponse rompimientoGrupoResponse = new RompimientoGrupoResponse();

		rompimientoGrupoResponse = rompimientoGrupoWSDAO.procesoRompimientoGrupo(rompimientoGrupoRequest);

		return rompimientoGrupoResponse;
	}

	public RompimientoGrupoWSDAO getRompimientoGrupoWSDAO() {
		return rompimientoGrupoWSDAO;
	}

	public void setRompimientoGrupoWSDAO(RompimientoGrupoWSDAO rompimientoGrupoWSDAO) {
		this.rompimientoGrupoWSDAO = rompimientoGrupoWSDAO;
	}

}
