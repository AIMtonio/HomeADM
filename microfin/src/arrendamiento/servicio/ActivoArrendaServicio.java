package arrendamiento.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import arrendamiento.bean.ActivoArrendaBean;
import arrendamiento.dao.ActivoArrendaDAO;
import arrendamiento.servicio.ArrendamientosServicio.Enum_Tra_Arrenda;

public class ActivoArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ActivoArrendaDAO activoArrendaDAO = null;
	
	//---------- Tipo de Transacciones ----------------------------------------------------------------	
	public static interface Enum_Tra_ActivoArrenda {
		int alta = 1;
		int modificacion = 2;
		int eliminacion = 3;
	}
		
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_ActivoArrenda {
		int principalActivos = 1;
		int activosVinculacion = 2;
	}
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_ActivoArrenda {
		int principal = 1;
		int activosVinculacion = 2;
	}
	
	public ActivoArrendaServicio (){
		super();
	}
	
	
	/**
	 * Metodo de transacciones
	 * @param tipoTransaccion
	 * @param activoArrendaBean
	 * @return mensajeTransaccionBean
	 * @author vsanmiguel
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,  ActivoArrendaBean activoArrendaBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Arrenda.alta:		
				mensaje = activoArrendaDAO.altaActivos(activoArrendaBean);			
				break;		
			case Enum_Tra_Arrenda.modificacion:		
				mensaje = activoArrendaDAO.modificacionActivos(activoArrendaBean);				
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean grabaTransaccionVinculacionActivos(int tipoTransaccion,  ActivoArrendaBean activoArrendaBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Arrenda.alta:
				ArrayList listaDetalleGrid = (ArrayList) detalleGrid(activoArrendaBean);
				mensaje = activoArrendaDAO.altaVinculacionActivos(activoArrendaBean, listaDetalleGrid);
				break;
		}
		return mensaje;
	}
	
	private List detalleGrid(ActivoArrendaBean activoArrendaBean){
		// Separa las listas del grid en beans individuales
	
		List<String> listaActivos = activoArrendaBean.getActivoIDVin();
		
		ArrayList listaDetalle = new ArrayList();
		
		ActivoArrendaBean iterActivoArrendaBean  = null; 
		
		int tamanio = 0;
		
		if(listaActivos != null){
			tamanio = listaActivos.size();
		}

		for(int i = 0; i < tamanio; i++){
			iterActivoArrendaBean = new ActivoArrendaBean();
			iterActivoArrendaBean.setArrendaID(activoArrendaBean.getArrendaID());
			iterActivoArrendaBean.setActivoID(listaActivos.get(i));
			
			listaDetalle.add(iterActivoArrendaBean);
		}
		 
		return listaDetalle;
	}
	
	/**
	 * Metodo de Consulta 
	 * @param tipoConsulta
	 * @param activoArrendaBean
	 * @return activoArrendaBean
	 * @author vsanmiguel
	 */
	public ActivoArrendaBean consulta(int tipoConsulta,  ActivoArrendaBean activoArrendaBean){
		ActivoArrendaBean activo = null;
		switch (tipoConsulta) {
			case Enum_Con_ActivoArrenda.principalActivos:	
				activo = activoArrendaDAO.consultaPrincipalActivos(activoArrendaBean, tipoConsulta);
				break;
			case Enum_Con_ActivoArrenda.activosVinculacion:
				activo = activoArrendaDAO.consultaActivosVinculacion(activoArrendaBean, tipoConsulta);
				break;
		}
		return activo;
	}
	
	
	/**
	 * Lista de activos 
	 * @param tipoLista
	 * @param activoArrendaBean
	 * @return list
	 * @author vsanmiguel
	 */
	public List lista(int tipoLista, ActivoArrendaBean activoArrendaBean){
		List activos = null;
		switch (tipoLista) {
			case Enum_Lis_ActivoArrenda.principal:		
				activos = activoArrendaDAO.listaActivosInactivosLigados(activoArrendaBean, tipoLista);
				break;
			case Enum_Lis_ActivoArrenda.activosVinculacion:
				activos = activoArrendaDAO.listaActivosVinculacion(tipoLista, activoArrendaBean);
				break;
		}		
		return activos;
	}
	
	public List listaActivosArrendamiento(int tipoLista, ActivoArrendaBean activoArrendaBean){
		List activos = null;
		switch (tipoLista) {
			case Enum_Lis_ActivoArrenda.principal:		
				activos = activoArrendaDAO.listaActivosArrendamiento(tipoLista, activoArrendaBean);
				break;
		}		
		return activos;
	}

	//---------- Getter y Setters ------------------------------------------------------------------------
	public ActivoArrendaDAO getActivoArrendaDAO() {
		return activoArrendaDAO;
	}


	public void setActivoArrendaDAO(ActivoArrendaDAO activoArrendaDAO) {
		this.activoArrendaDAO = activoArrendaDAO;
	}	
}
