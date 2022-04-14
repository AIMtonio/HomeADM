
package cliente.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import cliente.bean.PuntosConceptoBean;
import cliente.dao.PuntosConceptoDAO;

public class PuntosConceptoServicio  extends BaseServicio{
	
	/* Declaracion de atributos */
	PuntosConceptoDAO puntosConceptoDAO = null;	


	public PuntosConceptoServicio() {
		super();
	}
	
	/*Enumera los tipos de transaccion */
	public static interface Enum_Tra_PuntosConcepto {
		int modifica = 1;
	}
	
	/*Enumera los tipo de listas */
	public static interface Enum_Lis_PuntosConcepto {
		int principal = 1;
	}
	
	/* Controla el tipo de transaccion que se debe ejecutar (alta,modifica,actualiza u otro que regrese datos(numError, MsjError,control y consecutivo))*/
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PuntosConceptoBean puntosConceptoBean){
		ArrayList listaPuntosConcepto= (ArrayList) creaListaDetalle(puntosConceptoBean);
		MensajeTransaccionBean mensaje = null;
		
		switch (tipoTransaccion) {		
			case Enum_Tra_PuntosConcepto.modifica:
				mensaje = puntosConceptoDAO.procesaModificar(puntosConceptoBean, listaPuntosConcepto);					
				break;
		}
		return mensaje;
	}
	
	
	/* Controla el tipo de lista */
	public List lista(int tipoLista, PuntosConceptoBean puntosConceptoBean){
		List listaPuntosConcepto = null;
		switch (tipoLista) {			
			case Enum_Lis_PuntosConcepto.principal:
				listaPuntosConcepto = puntosConceptoDAO.listaPrincipal(tipoLista, puntosConceptoBean);				
			break;	
		}
		return listaPuntosConcepto;	
	}
	
	
	/* Crea la listas de beanes a partir del ben recibido en el controlador */
	public List creaListaDetalle( PuntosConceptoBean puntosConceptoBean) {

		List<String> puntosConcepID	 = puntosConceptoBean.getlPuntosConcepID();
		List<String> rangoInferior	 = puntosConceptoBean.getlRangoInferior();
		List<String> rangoSuperior 	 = puntosConceptoBean.getlRangoSuperior();
		List<String> puntos 		 = puntosConceptoBean.getlPuntos();

		ArrayList listaDetalle = new ArrayList();
		PuntosConceptoBean bean = null;
		
		if(puntosConcepID != null){
			int tamanio = puntosConcepID.size();			
			for (int i = 0; i < tamanio; i++) {
				bean = new PuntosConceptoBean();
				bean.setPuntosConcepID(puntosConcepID.get(i));
				bean.setRangoInferior(rangoInferior.get(i));
				bean.setRangoSuperior(rangoSuperior.get(i));
				bean.setPuntos(puntos.get(i));
				
				listaDetalle.add(bean);
			}
		}
		return listaDetalle;		
	} // fin de creaListaDetalle
	


	/* ===================== GETTER's Y SETTER's ======================= */
	public PuntosConceptoDAO getPuntosConceptoDAO() {
		return puntosConceptoDAO;
	}

	public void setPuntosConceptoDAO(PuntosConceptoDAO puntosConceptoDAO) {
		this.puntosConceptoDAO = puntosConceptoDAO;
	}
	
}
