package fira.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import fira.bean.RepRenovacionesFiraBean;
import fira.dao.RenovacionesCreFiraDAO;

public class RenovacionesCreFiraServicio extends BaseServicio{
	
	private RenovacionesCreFiraDAO renovacionesCreFiraDAO;
	
	public RenovacionesCreFiraServicio () {
		super();
	}
	

	@SuppressWarnings("rawtypes")
	public List listaRepRenovaciones(RepRenovacionesFiraBean repRenovacionesBean){
		List listaRenovaciones=null;
		listaRenovaciones = renovacionesCreFiraDAO.listaRenovaciones(repRenovacionesBean);
	
		return listaRenovaciones;
	}


	public RenovacionesCreFiraDAO getRenovacionesCreFiraDAO() {
		return renovacionesCreFiraDAO;
	}


	public void setRenovacionesCreFiraDAO(
			RenovacionesCreFiraDAO renovacionesCreFiraDAO) {
		this.renovacionesCreFiraDAO = renovacionesCreFiraDAO;
	}

}
