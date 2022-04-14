package operacionesCRCB.servicio;

import operacionesCRCB.beanWS.request.AbonoBonificacionRequest;
import operacionesCRCB.beanWS.response.AbonoBonificacionResponse;
import operacionesCRCB.dao.AbonoBonificacionDAO;
import general.servicio.BaseServicio;

public class AbonoBonificacionServicio extends BaseServicio{
	AbonoBonificacionDAO abonoBonificacionDAO = null;

	public AbonoBonificacionServicio(){
		super();
	}


	public AbonoBonificacionResponse abonoPorBonificacionWS(AbonoBonificacionRequest abonoBonificacionRequest){
		AbonoBonificacionResponse abonoBonificacionResponse = new AbonoBonificacionResponse();

		abonoBonificacionResponse = abonoBonificacionDAO.abonoPorBonificacion(abonoBonificacionRequest);

		return abonoBonificacionResponse;
	}


	public AbonoBonificacionDAO getAbonoBonificacionDAO() {
		return abonoBonificacionDAO;
	}

	public void setAbonoBonificacionDAO(AbonoBonificacionDAO abonoBonificacionDAO) {
		this.abonoBonificacionDAO = abonoBonificacionDAO;
	}
}