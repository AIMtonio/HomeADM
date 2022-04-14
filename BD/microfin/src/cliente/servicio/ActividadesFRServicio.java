package cliente.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import cliente.bean.ClienteBean;
import cliente.dao.ActividadesFRDAO;


public class ActividadesFRServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	ActividadesFRDAO actividadesFRDAO = null;

	public static interface Enum_Lis_Actividad {
		int principal = 1;
		int filtrada=2;

	}

	
	public ActividadesFRServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	// listas para comboBox
	public  Object[] listaCombo(ClienteBean actividades, int tipoLista ) {
		
		List listaActividadesCombo = null;
		try{
		switch(tipoLista){
			case (Enum_Lis_Actividad.principal): 
				listaActividadesCombo =  actividadesFRDAO.listaActividadesCombo(actividades, Enum_Lis_Actividad.principal);
				break;
			case (Enum_Lis_Actividad.filtrada): 
				listaActividadesCombo =  actividadesFRDAO.listaActividadesFRFiltro(actividades, Enum_Lis_Actividad.filtrada);
				break;
		}
		
		// listaActividadesCombo.toArray();
		 }
		catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error("Error en la lista de actividades" + e);
			
		}
		return listaActividadesCombo.toArray(); }
	


	public ActividadesFRDAO getActividadesFRDAO() {
		return actividadesFRDAO;
	}


	public void setActividadesFRDAO(ActividadesFRDAO actividadesFRDAO) {
		this.actividadesFRDAO = actividadesFRDAO;
	}
	

}
