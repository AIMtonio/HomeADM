package contabilidad.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import contabilidad.bean.ConceptoContableBean;
import contabilidad.dao.ConceptoContableDAO;


public class ConceptoContableServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ConceptoContableDAO conceptoContableDAO = null;

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_ConceptoConta {
		int principal = 1;
	}

	public static interface Enum_Lis_ConceptoConta {
		int principal = 1;
	}

	public static interface Enum_Tra_ConceptoConta {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	public ConceptoContableServicio() {
		super();
	}
	
	//---------- Transacciones ------------------------------------------------------------------------------
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,
												   ConceptoContableBean conceptoContable){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_ConceptoConta.alta:		
				mensaje = altaConcepto(conceptoContable);
				break;				
			case Enum_Tra_ConceptoConta.modificacion:
				mensaje = modificaConcepto(conceptoContable);
				break;
			case Enum_Tra_ConceptoConta.baja:
				mensaje = bajaConcepto(conceptoContable);	
				break;
			
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaConcepto(ConceptoContableBean conceptoContableBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = conceptoContableDAO.alta(conceptoContableBean);
		return mensaje;
	}

	public MensajeTransaccionBean modificaConcepto(ConceptoContableBean conceptoContableBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = conceptoContableDAO.modifica(conceptoContableBean);		
		return mensaje;
	}	
	public MensajeTransaccionBean bajaConcepto(ConceptoContableBean conceptoContableBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = conceptoContableDAO.baja(conceptoContableBean);
		return mensaje;
	}
	
	public ConceptoContableBean consulta(int tipoConsulta, ConceptoContableBean conceptoContableBean){
		ConceptoContableBean conceptoConta = null;
		switch (tipoConsulta) {
			case Enum_Con_ConceptoConta.principal:		
				conceptoConta = conceptoContableDAO.consultaPrincipal(conceptoContableBean, tipoConsulta);				
				break;				
		}		
		return conceptoConta;
	}
	
	public List lista(int tipoLista, ConceptoContableBean conceptoContable){
		List listaConceptos = null;
		switch (tipoLista) {
			case Enum_Lis_ConceptoConta.principal:
				listaConceptos = conceptoContableDAO.listaPrincipal(conceptoContable, tipoLista);				
				break;				
		}		
		return listaConceptos;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------
	
	public void setConceptoContableDAO(ConceptoContableDAO conceptoContableDAO) {
		this.conceptoContableDAO = conceptoContableDAO;
	}	
	
	
}
