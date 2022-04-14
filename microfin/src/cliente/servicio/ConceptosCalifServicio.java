package cliente.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import cliente.bean.ConceptosCalifBean;
import cliente.dao.ConceptosCalifDAO;

public class ConceptosCalifServicio  extends BaseServicio{
	
	/* Declaracion de atributos */
	ConceptosCalifDAO conceptosCalifDAO = null;	


	public ConceptosCalifServicio() {
		super();
	}
	
	/*Enumera los tipo de transaccion */
	public static interface Enum_Tra_ConceptosCalif {
		int modifica	 = 1;
	}
	
	/*Enumera los tipo de transaccion */
	public static interface Enum_Lis_ConceptosCalif {
		int principal	 = 1;
	}

	
	
	/* Controla el tipo de transaccion que se debe ejecutar (alta,modifica,actualiza u otro que regrese datos(numError, MsjError,control y consecutivo))*/
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConceptosCalifBean conceptosCalifBean){
		ArrayList listaConceptosCalif = (ArrayList) creaListaDetalle(conceptosCalifBean);
				
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {		
			case Enum_Tra_ConceptosCalif.modifica:
				mensaje = conceptosCalifDAO.modificar(conceptosCalifBean, listaConceptosCalif);					
				break;
		}
		return mensaje;
	}
	
	
	/* controla los tipos de listas para conceptos califica */
	public List lista(int tipoLista){		
		List listaConceptos = null;
		switch (tipoLista) {
			case Enum_Lis_ConceptosCalif.principal:		{			
				listaConceptos = conceptosCalifDAO.listaPrincipal(tipoLista);				
				break;		
			}
		}
				
		return listaConceptos;
	}
	
	
	/* Arma la lista de beans */
	public List creaListaDetalle(ConceptosCalifBean conceptosCalifBean) {
		
		List<String> id 		 = conceptosCalifBean.getlConceptoCalifID();
		List<String> concepto	 = conceptosCalifBean.getlConcepto();
		List<String> descripcion = conceptosCalifBean.getlDescripcion();
		List<String> puntos 	 = conceptosCalifBean.getlPuntos();

		ArrayList listaDetalle = new ArrayList();
		ConceptosCalifBean conceptosBean = null;	
		
		if(id != null){
			int tamanio = id.size();			
			for (int i = 0; i < tamanio; i++) {
				conceptosBean = new ConceptosCalifBean();
				conceptosBean.setConceptoCalifID(id.get(i));
				conceptosBean.setConcepto(concepto.get(i));
				conceptosBean.setDescripcion(descripcion.get(i));
				conceptosBean.setPuntos(puntos.get(i));
				
				listaDetalle.add(conceptosBean);
			}
		}
		return listaDetalle;
		
	}

	/* ===================== GETTER's Y SETTER's ======================= */
	
	public ConceptosCalifDAO getConceptosCalifDAO() {
		return conceptosCalifDAO;
	}

	public void setConceptosCalifDAO(ConceptosCalifDAO conceptosCalifDAO) {
		this.conceptosCalifDAO = conceptosCalifDAO;
	}


}
