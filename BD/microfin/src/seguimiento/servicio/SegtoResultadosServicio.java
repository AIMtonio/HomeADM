package seguimiento.servicio;

import java.util.List;

import seguimiento.bean.SegtoRecomendasBean;
import seguimiento.bean.SegtoResultadosBean;
import seguimiento.dao.SegtoResultadosDAO;
import seguimiento.servicio.SegtoRecomendasServicio.Enum_Con_SegtoRecomendas;
import seguimiento.servicio.SegtoRecomendasServicio.Enum_Lis_SegtoRecomendas;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SegtoResultadosServicio extends BaseServicio {

	SegtoResultadosDAO segtoResultadosDAO = null;
	
	public SegtoResultadosServicio(){
		super();
	}
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_SegtoResultados {
		int principal	= 1;
		int foranea 	= 2;
		int alcance 	= 3;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_SegtoResultados {
		int principal 	= 1;
		int foranea   	= 2;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_SegtoResultados {
		int alta 		= 1;
		int modifica 	= 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,SegtoResultadosBean segtoResultadosBean){
		MensajeTransaccionBean mensaje=null;
		switch (tipoTransaccion) {
		case Enum_Tra_SegtoResultados.alta:
			mensaje=segtoResultadosDAO.altaSegtoResultados(segtoResultadosBean);	
			break;
		case Enum_Tra_SegtoResultados.modifica:
			mensaje=segtoResultadosDAO.modificaSegtoResultados(segtoResultadosBean);
			break;
		}
		
		return mensaje;
	}
	
	
	public SegtoResultadosBean consulta(int tipoConsulta, SegtoResultadosBean segtoResultadosBean){
		SegtoResultadosBean segtoRealizados = null;
		switch (tipoConsulta) {
			case Enum_Con_SegtoResultados.alcance:		
				segtoRealizados = segtoResultadosDAO.consultaAlcance(segtoResultadosBean, tipoConsulta);				
				break;
			case Enum_Con_SegtoResultados.principal:
				segtoRealizados = segtoResultadosDAO.consulta(Enum_Con_SegtoResultados.principal, segtoResultadosBean);
			break;	
		}
		return segtoRealizados;
	}
	
	public List lista(int tipoLista, SegtoResultadosBean segtoResultadosBean){
		List listaSegtoRecomendas = null;
		switch (tipoLista) {
	        case  Enum_Lis_SegtoRecomendas.foranea:
	        	listaSegtoRecomendas = segtoResultadosDAO.listaResultados(segtoResultadosBean, tipoLista);
	        break;
		}
		return listaSegtoRecomendas;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(SegtoResultadosBean segtoResultadosBean, int tipoLista) {
		List listaComboResultado = null;
		switch(tipoLista){
			case (Enum_Lis_SegtoResultados.principal): 
				listaComboResultado =  segtoResultadosDAO.listaPrincipal(segtoResultadosBean, tipoLista);
				break;
		}
		return listaComboResultado.toArray();		
	}

	
	//---------- Getter y Setters  ----------------------------------------------------------------
	public SegtoResultadosDAO getSegtoResultadosDAO() {
		return segtoResultadosDAO;
	}

	public void setSegtoResultadosDAO(SegtoResultadosDAO segtoResultadosDAO) {
		this.segtoResultadosDAO = segtoResultadosDAO;
	}
}