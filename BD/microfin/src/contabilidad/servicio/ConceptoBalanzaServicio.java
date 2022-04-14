package contabilidad.servicio;



import java.util.List;

import contabilidad.bean.ConceptoBalanzaBean;
import contabilidad.dao.ConceptoBalanzaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ConceptoBalanzaServicio extends BaseServicio {

	private ConceptoBalanzaServicio(){
		super();
	}

	ConceptoBalanzaDAO conceptoBalanzaDAO = null;

	public static interface Enum_Lis_ConceptoBalanza{
		int alfanumerica = 1;
	}
	
	public static interface Enum_Con_ConceptoBalanza{
		int foranea = 2;
	}
	
	public static interface Enum_Tra_ConceptoBalanza {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
		
	}
	
	public List lista(int tipoLista, ConceptoBalanzaBean conceptoBalanza){		
		List listaConceptoBalanza = null;
		switch (tipoLista) {
			case Enum_Lis_ConceptoBalanza.alfanumerica:		
				listaConceptoBalanza=  conceptoBalanzaDAO.listaAlfanumerica(conceptoBalanza,Enum_Lis_ConceptoBalanza.alfanumerica);				
				break;	
		}		
		return listaConceptoBalanza;
	}
	
	public ConceptoBalanzaBean consulta(int tipoConsulta, ConceptoBalanzaBean conceptoBalanza){
		ConceptoBalanzaBean conceptoBalanzaBean = null;
		switch(tipoConsulta){
			case Enum_Con_ConceptoBalanza.foranea:
				conceptoBalanzaBean = conceptoBalanzaDAO.consultaForanea(conceptoBalanza, Enum_Con_ConceptoBalanza.foranea);
			break;
		}
		return conceptoBalanzaBean;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConceptoBalanzaBean conceptoBalanza){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_ConceptoBalanza.alta:
			mensaje = alta(conceptoBalanza);
			break;
		case Enum_Tra_ConceptoBalanza.modificacion:
			mensaje = modificacion(conceptoBalanza);
			break;
		case Enum_Tra_ConceptoBalanza.baja:
			mensaje = baja(conceptoBalanza);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean alta(ConceptoBalanzaBean conceptoBalanza){
		MensajeTransaccionBean mensaje = null;
		mensaje = conceptoBalanzaDAO.alta(conceptoBalanza);		
		return mensaje;
	}
	
	public MensajeTransaccionBean modificacion(ConceptoBalanzaBean conceptoBalanza){
		MensajeTransaccionBean mensaje = null;
		mensaje = conceptoBalanzaDAO.modifica(conceptoBalanza);		
		return mensaje;
	}	
	
	public MensajeTransaccionBean baja(ConceptoBalanzaBean conceptoBalanza){
		MensajeTransaccionBean mensaje = null;
		mensaje = conceptoBalanzaDAO.baja(conceptoBalanza);		
		return mensaje;
	}
	

		
	public void setConceptoBalanzaDAO(ConceptoBalanzaDAO conceptoBalanzaDAO ){
		this.conceptoBalanzaDAO = conceptoBalanzaDAO;
	}

	public ConceptoBalanzaDAO getConceptoBalanzaDAO() {
		return conceptoBalanzaDAO;
	}

}


