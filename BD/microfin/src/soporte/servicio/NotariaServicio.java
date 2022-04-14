package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import cliente.bean.DireccionesClienteBean;
import cliente.servicio.DireccionesClienteServicio.Enum_Tra_DireccionesCliente;

import soporte.bean.NotariaBean;
import soporte.dao.NotariaDAO;

public class NotariaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	NotariaDAO notariaDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Notaria {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Notaria {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_Notaria {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	public NotariaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, NotariaBean notaria){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Notaria.alta:		
				mensaje = altaNotaria(notaria);				
				break;				
			case Enum_Tra_Notaria.modificacion:
				mensaje = modificaNotaria(notaria);				
				break;
			case Enum_Tra_Notaria.baja:
				mensaje = bajaNotaria(notaria);				
				break;
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaNotaria(NotariaBean notaria){
		MensajeTransaccionBean mensaje = null;
		mensaje = notariaDAO.alta(notaria);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaNotaria(NotariaBean notaria){
		MensajeTransaccionBean mensaje = null;
		mensaje = notariaDAO.modifica(notaria);		
		return mensaje;
	}
	
	public MensajeTransaccionBean bajaNotaria(NotariaBean notaria){
		MensajeTransaccionBean mensaje = null;
		mensaje = notariaDAO.baja(notaria);		
		return mensaje;
	}
	
	
	
	public NotariaBean consulta(int tipoConsulta, NotariaBean notariaBean){
		NotariaBean notaria = null;
		switch (tipoConsulta) {
			case Enum_Con_Notaria.principal:		
				notaria = notariaDAO.consultaPrincipal(notariaBean, tipoConsulta);				
				break;	
			case Enum_Con_Notaria.foranea:		
				notaria = notariaDAO.consultaForanea(notariaBean, tipoConsulta);				
			break;	
		}
				
		return notaria;
	}
	
	public List lista(int tipoLista, NotariaBean notariaBean){		
		List listaNotarias = null;
		switch (tipoLista) {
			case Enum_Lis_Notaria.principal:		
				listaNotarias = notariaDAO.listaPrincipal(notariaBean, tipoLista);				
				break;				
		}		
		return listaNotarias;
	}	
		
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setNotariaDAO(NotariaDAO notariaDAO) {
		this.notariaDAO = notariaDAO;
	}
		
}

