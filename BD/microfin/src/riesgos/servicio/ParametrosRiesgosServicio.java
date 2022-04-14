package riesgos.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.ParametrosRiesgosDAO;

public class ParametrosRiesgosServicio extends BaseServicio{

	public ParametrosRiesgosServicio() {
		super();
	}
	ParametrosRiesgosDAO parametrosRiesgosDAO = null;
	
	/* Transacciones para Parámetros de Riesgos */
	public static interface Enum_Tra_Params {
		int graba = 1;
	}
	
	/* Lista para el grid de la pantalla de Parámetros de Riesgos */
	public static interface Enum_Lis_Params {
		int comboParametros = 1;
		int gridParametros = 2;
		int gridClasifCredito = 3;
		int gridTipoAhorro = 4;
		int gridSectorEco = 5;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, UACIRiesgosBean riesgosBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) creaListaDetalle(riesgosBean);
		switch (tipoTransaccion) {
			case Enum_Tra_Params.graba:
				mensaje = parametrosRiesgosDAO.grabaParametrosRiesgos(listaBean);
				break;
		}
		return mensaje;
	}	
	
	/* Arma la lista de beans */
	public List creaListaDetalle(UACIRiesgosBean bean) {		
		List<String> porcentaje = bean.getLporcentaje();
		List<String> descripcion = bean.getLdescripcion();
		List<String> referencia = bean.getLreferencia();
		ArrayList listaDetalle = new ArrayList();
		UACIRiesgosBean beanAux = null;	
		
		if(porcentaje != null){
			int tamanio = porcentaje.size();			
			for (int i = 0; i < tamanio; i++) {
				beanAux = new UACIRiesgosBean();
				
				beanAux.setParamRiesgosID(bean.getParamRiesgosID());
				beanAux.setPorcentaje(porcentaje.get(i));
				beanAux.setDescripcion(descripcion.get(i));
				beanAux.setReferenciaID(referencia.get(i));

				listaDetalle.add(beanAux);
			}
		}
		return listaDetalle;
	}

	//lista para el grid de la pantalla de Parámetros de Riesgos				
	public List listaParametrosRiesgos(int tipoLista, UACIRiesgosBean riesgosBean){		
		List listaParametros= null;
		switch (tipoLista) {
			case Enum_Lis_Params.gridParametros:		
				listaParametros = parametrosRiesgosDAO.listaGridParametrosRiesgos(riesgosBean, tipoLista);				
				break;	
			case Enum_Lis_Params.gridClasifCredito:		
				listaParametros = parametrosRiesgosDAO.listaGridParametrosRiesgos(riesgosBean, tipoLista);				
				break;	
			case Enum_Lis_Params.gridTipoAhorro:		
				listaParametros = parametrosRiesgosDAO.listaGridParametrosRiesgos(riesgosBean, tipoLista);				
				break;
			case Enum_Lis_Params.gridSectorEco:		
				listaParametros = parametrosRiesgosDAO.listaGridParametrosRiesgos(riesgosBean, tipoLista);				
				break;
		}		
		return listaParametros;
	}
	
	// listas para comboBox de la pantalla de Parámetros de Riesgos
	public  Object[] listaCombo(int tipoLista) {				
		List listaParametros= null;
		switch(tipoLista){
			case (Enum_Lis_Params.comboParametros): 
				listaParametros = parametrosRiesgosDAO.listaComboParametros(tipoLista);
				break;					
		}		
		return listaParametros.toArray();		
	}	
	
	 /* ********************** GETTERS y SETTERS **************************** */
	public ParametrosRiesgosDAO getParametrosRiesgosDAO() {
		return parametrosRiesgosDAO;
	}

	public void setParametrosRiesgosDAO(ParametrosRiesgosDAO parametrosRiesgosDAO) {
		this.parametrosRiesgosDAO = parametrosRiesgosDAO;
	}
	
	
}
