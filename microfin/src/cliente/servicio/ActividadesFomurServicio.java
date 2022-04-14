package cliente.servicio;

import java.util.List;
 
import cliente.bean.ClienteBean;
import cliente.dao.ActividadesFomurDAO;
import general.servicio.BaseServicio;

public class ActividadesFomurServicio extends BaseServicio{
	ActividadesFomurDAO actividadesFomurDAO = null;
	
	public static interface Enum_Lis_Actividad {
		int principal = 1;
		int filtrada=2;
	}
	
	public ActividadesFomurServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	// listas para comboBox
	public  Object[] listaCombo(ClienteBean actividades, int tipoLista ) {
		
		List listaActividadesCombo = null;
		try{
			switch(tipoLista){
				case (Enum_Lis_Actividad.principal): 
					listaActividadesCombo =  actividadesFomurDAO.listaActividadesCombo(actividades, Enum_Lis_Actividad.principal);
					break;
				case (Enum_Lis_Actividad.filtrada): 
					listaActividadesCombo =  actividadesFomurDAO.listaActividadesFomurFiltro(actividades, Enum_Lis_Actividad.filtrada);
					break;
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return listaActividadesCombo.toArray(); 
	}

	public ActividadesFomurDAO getActividadesFomurDAO() {
		return actividadesFomurDAO;
	}

	public void setActividadesFomurDAO(ActividadesFomurDAO actividadesFomurDAO) {
		this.actividadesFomurDAO = actividadesFomurDAO;
	}


}
