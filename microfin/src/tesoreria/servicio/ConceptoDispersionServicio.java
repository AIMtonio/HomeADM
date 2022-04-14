package tesoreria.servicio;

import java.util.List;

import soporte.servicio.ParamGeneralesServicio;
import tesoreria.bean.ConceptoDispersionBean;
import tesoreria.dao.ConceptoDispersionDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ConceptoDispersionServicio extends BaseServicio {

	public ConceptoDispersionServicio() {
		super();
	}

	ConceptoDispersionDAO conceptoDispersionDAO = null;
	ParamGeneralesServicio paramGeneralesServicio = null;

	// ---- Tipos de acciones
	public static interface Enum_Tra_ConcDispersion{
		int alta = 1;
		int modificacion =2;
	}
	public static interface Enum_Con_ConcDispersion{
		int principal 	= 1;
	}
	public static interface Enum_Lis_ConcDispersion{
		int alfanumerica = 1;
		int conceptos=2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConceptoDispersionBean conceptoDispersion) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion) {
		case Enum_Tra_ConcDispersion.alta:
			mensaje = altaConceptoDispersion(conceptoDispersion);
			break;
		case Enum_Tra_ConcDispersion.modificacion:
			mensaje = modificaConceptoDispersion(conceptoDispersion);
			break;
		}

		return mensaje;
	}

	public MensajeTransaccionBean altaConceptoDispersion(ConceptoDispersionBean conceptoDispersion) {
		MensajeTransaccionBean mensaje = null;
		mensaje = conceptoDispersionDAO.altaConcepto(conceptoDispersion);
		return mensaje;
	}

	public MensajeTransaccionBean modificaConceptoDispersion(ConceptoDispersionBean conceptoDispersion) {
		MensajeTransaccionBean mensaje = null;
		mensaje = conceptoDispersionDAO.modificaConcepto(conceptoDispersion);
		return mensaje;
	}

	public ConceptoDispersionBean consulta(int tipoConsulta, ConceptoDispersionBean conceptoDispersion){
		ConceptoDispersionBean consultabean = null;

		switch(tipoConsulta){
			case Enum_Con_ConcDispersion.principal:
				consultabean = conceptoDispersionDAO.consultaConceptos(tipoConsulta, conceptoDispersion);
				break;
		}
		return consultabean;

	}

	public List lista(int tipoLista, ConceptoDispersionBean conceptoDispersion){
		List listaTipoGas = null;
		switch (tipoLista) {
			case Enum_Lis_ConcDispersion.alfanumerica:
				listaTipoGas=  conceptoDispersionDAO.listaAlfanumerica(conceptoDispersion,Enum_Lis_ConcDispersion.alfanumerica);
				break;
		}
		return listaTipoGas;
	}
	
	public  Object[] listaCombo(int tipoLista, ConceptoDispersionBean conceptoDispersion){
		List listaConceptos= null;

		switch (tipoLista) {
			case Enum_Lis_ConcDispersion.conceptos:
				listaConceptos = conceptoDispersionDAO.listaConceptos(conceptoDispersion, tipoLista);
			break;
		}
		return listaConceptos.toArray();
	}

	//-----------------getter y setter-------------------------
	public void setConceptoDispersionDAO(ConceptoDispersionDAO conceptoDispersionDAO){
		this.conceptoDispersionDAO = conceptoDispersionDAO;
	}

	public ConceptoDispersionDAO getConceptoDispersionDAO(){
		return conceptoDispersionDAO;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}


}
