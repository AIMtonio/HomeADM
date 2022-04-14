package cobranza.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import cobranza.bean.TipoRespuestaCobBean;
import cobranza.dao.TipoRespuestaCobDAO;

public class TipoRespuestaCobServicio extends BaseServicio{
	TipoRespuestaCobDAO tipoRespuestaCobDAO = null;
	
	public static interface Enum_Trans_TipoRespuesta{
		int alta = 1;
	}
	
	public static interface Enum_Lis_TipoRespuesta{
		int lisGridParametros = 1;
		int listaCombo	= 2;
	}
	
	//alta de los tipos de respuesta de cobranza
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TipoRespuestaCobBean tipoRespuestaBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaGrid(tipoRespuestaBean);
		switch(tipoTransaccion){
			case Enum_Trans_TipoRespuesta.alta:
				mensaje = tipoRespuestaCobDAO.grabaListaRespuestasCob(tipoRespuestaBean,listaBean);
				break;
		}
		return mensaje;
	}

	//lista de parametros del grid
	public List listaGrid(TipoRespuestaCobBean lisTipoRespuestaBean){

		List<String> respuestaIDLis	= lisTipoRespuestaBean.getLisRespuestaID();
		List<String> descripcionLis = lisTipoRespuestaBean.getLisDescripcion();
		List<String> estatusLis 	= lisTipoRespuestaBean.getLisEstatus();
		
		ArrayList listaDetalle = new ArrayList();
		TipoRespuestaCobBean tipoRespuestaBean = null;
		if(respuestaIDLis !=null){ 			
			try{
				
			int tamanio = respuestaIDLis.size();
				for(int i=0; i<tamanio; i++){
				
					tipoRespuestaBean = new TipoRespuestaCobBean();
					
					tipoRespuestaBean.setAccionID(lisTipoRespuestaBean.getAccionID());
					tipoRespuestaBean.setRespuestaID(respuestaIDLis.get(i));
					tipoRespuestaBean.setDescripcion(descripcionLis.get(i));
					tipoRespuestaBean.setEstatus(estatusLis.get(i));
					
					listaDetalle.add(i,tipoRespuestaBean);	
				}

			}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid de tipos de respuestas", e);	
		}
	}
	return listaDetalle;
	}
	
	//Lista para el grid en la pantala tipos respuesta 
	public List listaTipoRespuesta(int tipoLista, TipoRespuestaCobBean respuestaBean){
		List listaParametros = null;
		
		switch(tipoLista){
			case Enum_Lis_TipoRespuesta.lisGridParametros:
				listaParametros = tipoRespuestaCobDAO.listaTipoRespuestaCob(tipoLista, respuestaBean);
				break;
		}

		return listaParametros;
	}	
	
	// listas para comboBox 
	public  Object[] listaCombo(int tipoLista,  TipoRespuestaCobBean respuestaBean) {
		List listaRespuestas = null;
			switch(tipoLista){
			case Enum_Lis_TipoRespuesta.listaCombo:
				listaRespuestas = tipoRespuestaCobDAO.listaTipoRespuestaCob(tipoLista, respuestaBean);
				break;
			}			
		return listaRespuestas.toArray(); 
	}

	public TipoRespuestaCobDAO getTipoRespuestaCobDAO() {
		return tipoRespuestaCobDAO;
	}

	public void setTipoRespuestaCobDAO(TipoRespuestaCobDAO tipoRespuestaCobDAO) {
		this.tipoRespuestaCobDAO = tipoRespuestaCobDAO;
	}

	
}
