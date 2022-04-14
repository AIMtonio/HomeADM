package cliente.servicio;

import java.util.ArrayList;
import java.util.List;

import cliente.bean.ClasificacionCliBean;
import cliente.dao.ClasificacionCliDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ClasificacionCliServicio extends BaseServicio{
	
	/* Declaracion de atributos */
	ClasificacionCliDAO clasificacionCliDAO = null;	


	public ClasificacionCliServicio() {
		super();
	}
	
	/*Enumera los tipo de transaccion */
	public static interface Enum_Tra_ClasificacionCli {
		int modifica	 = 1;
	}
	
	/*Enumera los tipo de transaccion */
	public static interface Enum_Lis_ClasificacionCli {
		int principal	 = 1;
	}
	
	
	/* Controla el tipo de transaccion que se debe ejecutar (alta,modifica,actualiza u otro que regrese datos(numError, MsjError,control y consecutivo))*/
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ClasificacionCliBean clasificacionCliBean){
		ArrayList listaClasificaciones = (ArrayList) creaListaDetalle(clasificacionCliBean);
				
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {		
			case Enum_Tra_ClasificacionCli.modifica:
				mensaje = clasificacionCliDAO.modificar(clasificacionCliBean, listaClasificaciones);					
				break;
		}
		return mensaje;
	}

	
	/* controla los tipos de listas para conceptos califica */
	public List lista(int tipoLista){		
		List listaClasificaciones = null;
		switch (tipoLista) {
			case Enum_Lis_ClasificacionCli.principal:		{			
				listaClasificaciones = clasificacionCliDAO.listaPrincipal(tipoLista);				
				break;		
			}
		}
				
		return listaClasificaciones;
	}
	
	
	/* Arma la lista de beans */
	public List creaListaDetalle( ClasificacionCliBean clasificacionCliBean) {
		
		List<String> id 			 = clasificacionCliBean.getlClasificaCliID();
		List<String> clasificacion	 = clasificacionCliBean.getlClasificacion();
		List<String> rangoInf 		 = clasificacionCliBean.getlRangoInferior();
		List<String> rangoSup 	 	 = clasificacionCliBean.getlRangoSuperior();

		ArrayList listaDetalle = new ArrayList();
		ClasificacionCliBean clasificacionBean = null;	
		
		if(id != null){
			int tamanio = id.size();			
			for (int i = 0; i < tamanio; i++) {
				clasificacionBean = new ClasificacionCliBean();
				clasificacionBean.setClasificaCliID(id.get(i));
				clasificacionBean.setClasificacion(clasificacion.get(i));
				clasificacionBean.setRangoInferior(rangoInf.get(i));
				clasificacionBean.setRangoSuperior(rangoSup.get(i));
				
				listaDetalle.add(clasificacionBean);
			}
		}
		return listaDetalle;
		
	}
	
	/*========= GET && SET ========*/
	public ClasificacionCliDAO getClasificacionCliDAO() {
		return clasificacionCliDAO;
	}

	public void setClasificacionCliDAO(ClasificacionCliDAO clasificacionCliDAO) {
		this.clasificacionCliDAO = clasificacionCliDAO;
	}


}
