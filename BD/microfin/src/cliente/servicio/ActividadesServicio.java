package cliente.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.List;

import cliente.bean.ActividadesBMXBean;
import cliente.bean.ActividadesCompletaBean;
import cliente.bean.ClienteBean;
import cliente.dao.ActividadesDAO;
import cliente.servicio.ClienteServicio.Enum_Tra_Cliente;

public class ActividadesServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	ActividadesDAO actividadesDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Actividad {
		int principal = 1;
		int foranea = 2;
		int completa = 3;		
	}

	public static interface Enum_Lis_Actividad {
		int principal = 1;
	}

	
	public ActividadesServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	

	public ActividadesCompletaBean consultaActCompleta(int tipoConsulta, String actividadBMXID){
		ActividadesCompletaBean actividades = null;
		
		actividades = actividadesDAO.consultaActividadCompleta(actividadBMXID, Enum_Con_Actividad.completa);
		
		
		return actividades;
	}
	
	
	
	public List lista(int tipoLista, ActividadesBMXBean actividades){		
		List listaActividades = null;
		switch (tipoLista) {
			case Enum_Lis_Actividad.principal:		
				listaActividades= actividadesDAO.listaActividadesPrincipal(actividades, tipoLista);				
				break;				
		}		
		return listaActividades;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setActividadesDAO(ActividadesDAO actividadesDAO) {
		this.actividadesDAO = actividadesDAO;
	}	
	

}
