package seguimiento.servicio;

import java.util.List;

import seguimiento.bean.CatTiposGestionBean;
import seguimiento.bean.SegtoRecomendasBean;
import seguimiento.dao.SegtoRecomendasDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SegtoRecomendasServicio extends BaseServicio {

	SegtoRecomendasDAO segtoRecomendasDAO = null;
	
	public SegtoRecomendasServicio(){
		super();
	}
	
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_SegtoRecomendas {
		int principal	= 1;
		int foranea 	= 2;
		int alcance		= 3;	
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_SegtoRecomendas {
		int principal 	= 1;
		int foranea   	= 2;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_SegtoRecomendas {
		int alta 		= 1;
		int modifica 	= 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,SegtoRecomendasBean segtoRecomendasBean){
		MensajeTransaccionBean mensaje=null;
		switch (tipoTransaccion) {
		case Enum_Tra_SegtoRecomendas.alta:
			mensaje=segtoRecomendasDAO.altaSegtoRecomendas(segtoRecomendasBean);	
			break;
		case Enum_Tra_SegtoRecomendas.modifica:
			mensaje=segtoRecomendasDAO.modificaSegtoRecomendas(segtoRecomendasBean);
			break;
		}
		
		return mensaje;
	}
	
	public SegtoRecomendasBean consulta(int tipoConsulta, SegtoRecomendasBean segtoRecomendasBean){
		SegtoRecomendasBean recomendaciones = null;
		switch(tipoConsulta){
			case Enum_Con_SegtoRecomendas.principal:
				recomendaciones = segtoRecomendasDAO.consulta(Enum_Con_SegtoRecomendas.principal, segtoRecomendasBean);
			break;
			case Enum_Con_SegtoRecomendas.alcance:
				recomendaciones= segtoRecomendasDAO.consultaRecomendaAlcance(segtoRecomendasBean, Enum_Con_SegtoRecomendas.alcance);				
			break;
		}
		return recomendaciones;
	}
	
	public List lista(int tipoLista, SegtoRecomendasBean segtoRecomendasBean){
		List listaSegtoRecomendas = null;
		switch (tipoLista) {
	        case  Enum_Lis_SegtoRecomendas.foranea:
	        	listaSegtoRecomendas = segtoRecomendasDAO.listaRecomendacion(segtoRecomendasBean, tipoLista);
	        break;
		}
		return listaSegtoRecomendas;
	}
		// listas para comboBox
	public  Object[] listaCombo(SegtoRecomendasBean segtoRecomendasBean, int tipoLista) {
		List listaComboResultado = null;
		switch(tipoLista){
			case (Enum_Lis_SegtoRecomendas.principal):
				listaComboResultado =  segtoRecomendasDAO.listaPrincipal(segtoRecomendasBean, tipoLista);
				break;
		}
		return listaComboResultado.toArray();
	}

	//---------- Getter y Setters  ----------------------------------------------------------------
	public SegtoRecomendasDAO getSegtoRecomendasDAO() {
		return segtoRecomendasDAO;
	}

	public void setSegtoRecomendasDAO(SegtoRecomendasDAO segtoRecomendasDAO) {
		this.segtoRecomendasDAO = segtoRecomendasDAO;
	}
}