package gestionComecial.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import gestionComecial.bean.PuestosBean;
import gestionComecial.dao.PuestosDAO;

import java.util.List;

import tesoreria.bean.ProveedoresBean;
import tesoreria.servicio.ProveedoresServicio.Enum_Lis_Proveedores;


public class PuestosServicio extends BaseServicio {

	private PuestosServicio(){
		super();
	}

	PuestosDAO puestosDAO = null;

	public static interface Enum_Lis_Puestos{
		int alfanumerica = 1;
		int lisGestores = 3;	
		int ejecutivo = 4;
	}
	
	public static interface Enum_Con_Puestos{
		int principal = 1;
		int foranea = 2;
		int f2 		= 3;
	}
	
	public static interface Enum_Tra_Puestos {
		int alta = 1;
		int baja = 2;
		int modificacion = 3;
		
	}

	
	public PuestosBean consulta(int tipoConsulta, PuestosBean puestos){
		PuestosBean puestosBean = null;
		switch(tipoConsulta){
			case Enum_Con_Puestos.principal:
				puestosBean = puestosDAO.consultaPrincipal(puestos, Enum_Con_Puestos.principal);
			break;
			case Enum_Con_Puestos.foranea:
				puestosBean = puestosDAO.consultaForanea(puestos, Enum_Con_Puestos.foranea);
			break;
			case Enum_Con_Puestos.f2:
				puestosBean = puestosDAO.consultaF2(puestos, Enum_Con_Puestos.f2);
			break;
		}
		return puestosBean;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PuestosBean puestos){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_Puestos.alta:
			mensaje = alta(puestos);
			break;
		case Enum_Tra_Puestos.baja:
			mensaje = baja(puestos);
			break;
		case Enum_Tra_Puestos.modificacion:
			mensaje = modifica(puestos);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean alta(PuestosBean puestos){
		MensajeTransaccionBean mensaje = null;
		mensaje = puestosDAO.alta(puestos);		
		return mensaje;
	}
	
	public MensajeTransaccionBean baja(PuestosBean puestos){
		MensajeTransaccionBean mensaje = null;
		mensaje = puestosDAO.actualizacion(puestos);		
		return mensaje;
	}
	
	public MensajeTransaccionBean modifica(PuestosBean puestos){
		MensajeTransaccionBean mensaje = null;
		mensaje = puestosDAO.modifica(puestos);		
		return mensaje;
	}
	
	
	
	public List lista(int tipoLista, PuestosBean puestos){		
		List listaPuestos = null;
		switch (tipoLista) {
			case Enum_Lis_Puestos.alfanumerica:		
				listaPuestos=  puestosDAO.listaAlfanumerica(puestos, Enum_Lis_Puestos.alfanumerica);				
			break;	
			case Enum_Lis_Puestos.lisGestores:		
				listaPuestos=  puestosDAO.listaAlfanumerica(puestos, tipoLista);				
			break;
		}		
		return listaPuestos;
	}
	
	// lista para la pantalla Definición de Seguimiento
	public  Object[] listaConsulta(int tipoLista, PuestosBean puestos){
		List listEjecutivo = null;
		switch(tipoLista){
			case Enum_Lis_Puestos.ejecutivo:
				listEjecutivo = puestosDAO.listaEjecutivo(puestos, tipoLista);
			break;
		}
		return listEjecutivo.toArray();
	}
		
	public void setPuestosDAO(PuestosDAO puestosDAO ){
		this.puestosDAO = puestosDAO;
	}

	public PuestosDAO getPuestosDAO() {
		return puestosDAO;
	}

}


