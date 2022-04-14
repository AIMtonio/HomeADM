package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;
import soporte.bean.PlazasBean;
import soporte.dao.PlazasDAO;


public class PlazasServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	PlazasDAO plazasDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Plaza {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Plaza {
		int principal = 1;
		int foranea   = 2;
		int plazas    = 3;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_Plaza {
		int alta = 1;
		int modificacion = 2;
	}
	
	public PlazasServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PlazasBean plazas){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Plaza.alta:		
				mensaje = altaPlaza(plazas);				
				break;				
			case Enum_Tra_Plaza.modificacion:
				mensaje = modificaPlaza(plazas);				
				break;
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaPlaza(PlazasBean plazas){
		MensajeTransaccionBean mensaje = null;
		mensaje = plazasDAO.alta(plazas);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaPlaza(PlazasBean plazas){
		MensajeTransaccionBean mensaje = null;
		mensaje = plazasDAO.modifica(plazas);		
		return mensaje;
	}
	
	
	public PlazasBean consulta(int tipoConsulta, PlazasBean plazasBean){
		PlazasBean plazas = null;
		switch (tipoConsulta) {
			case Enum_Con_Plaza.principal:		
				plazas = plazasDAO.consultaPrincipal(plazasBean, tipoConsulta);				
				break;	
			case Enum_Con_Plaza.foranea:		
				plazas = plazasDAO.consultaForanea(plazasBean, tipoConsulta);				
			break;	
		}
				
		return plazas;
	}
	
	public List lista(int tipoLista, PlazasBean plazasBean){		
		List listaNotarias = null;
		switch (tipoLista) {
			case Enum_Lis_Plaza.principal:
				listaNotarias = plazasDAO.listaPrincipal(plazasBean, tipoLista);
				break;
		}
		return listaNotarias;
	}

	// lista para la pantalla Definición de Seguimiento
	public  Object[] listaConsulta(int tipoConsulta, PlazasBean plazasBean){
		List listPlazas= null;
		switch(tipoConsulta){
			case Enum_Lis_Plaza.plazas:
				listPlazas= plazasDAO.listaPlazas(plazasBean, tipoConsulta);
			break;
		}
		return listPlazas.toArray();
	}
	
		
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setPlazasDAO(PlazasDAO plazasDAO) {
		this.plazasDAO = plazasDAO;
	}	
		
}

