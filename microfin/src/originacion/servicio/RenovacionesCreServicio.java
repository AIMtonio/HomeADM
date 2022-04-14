package originacion.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import originacion.bean.RepRenovacionesBean;
import originacion.dao.RenovacionesCreDAO;

public class RenovacionesCreServicio extends BaseServicio{
	
	private RenovacionesCreDAO renovacionesCreDAO;
	
	public RenovacionesCreServicio () {
		super();
	}
	

	@SuppressWarnings("rawtypes")
	public List listaRepRenovaciones(RepRenovacionesBean repRenovacionesBean){
		List listaRenovaciones=null;
		listaRenovaciones = renovacionesCreDAO.listaRenovaciones(repRenovacionesBean);
	
		return listaRenovaciones;
	}


	public RenovacionesCreDAO getRenovacionesCreDAO() {
		return renovacionesCreDAO;
	}


	public void setRenovacionesCreDAO(RenovacionesCreDAO renovacionesCreDAO) {
		this.renovacionesCreDAO = renovacionesCreDAO;
	}
	
	

}
