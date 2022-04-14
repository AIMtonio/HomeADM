package cobranza.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import cobranza.bean.TipoAccionCobBean;
import cobranza.dao.TipoAccionCobDAO;

public class TipoAccionCobServicio extends BaseServicio{
	TipoAccionCobDAO tipoAccionCobDAO = null;
	
	public static interface Enum_Trans_TipoAccion{
		int alta = 1;
	}
	
	public static interface Enum_Lis_TipoAccion{
		int lisGridParametros = 1;
		int listaCombo	= 2;
	}
	
	//alta tipos de acciones de cobranza
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TipoAccionCobBean tipoAccionBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaGrid(tipoAccionBean);
		switch(tipoTransaccion){
			case Enum_Trans_TipoAccion.alta:
				mensaje = tipoAccionCobDAO.grabaListaAccionesCob(tipoAccionBean,listaBean);
				break;
		}
		return mensaje;
	}

	//lista de parametros del grid
	public List listaGrid(TipoAccionCobBean lisTipoAccionBean){

		List<String> accionIDLis	  = lisTipoAccionBean.getLisAccionID();
		List<String> descripcionLis = lisTipoAccionBean.getLisDescripcion();
		List<String> estatusLis = lisTipoAccionBean.getLisEstatus();
		
		ArrayList listaDetalle = new ArrayList();
		TipoAccionCobBean tipoAccionBean = null;
		if(accionIDLis !=null){ 			
			try{
				
			int tamanio = accionIDLis.size();
				for(int i=0; i<tamanio; i++){
				
					tipoAccionBean = new TipoAccionCobBean();
					
					tipoAccionBean.setAccionID(accionIDLis.get(i));
					tipoAccionBean.setDescripcion(descripcionLis.get(i));
					tipoAccionBean.setEstatus(estatusLis.get(i));
					
					listaDetalle.add(i,tipoAccionBean);	
				}

			}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid de tipos de acciones", e);	
		}
	}
	return listaDetalle;
	}
	
	//Lista para el grid en la pantala tipos de accion
	public List listaTipoAccion(int tipoLista){
		List listaParametros = null;
		
		switch(tipoLista){
			case Enum_Lis_TipoAccion.lisGridParametros:
				listaParametros = tipoAccionCobDAO.listaTipoAccionCob(tipoLista);
				break;
		}

		return listaParametros;
	}	
	
	// listas para comboBox 
	public  Object[] listaCombo(int tipoLista) {
		List listaAcciones = null;
			switch(tipoLista){
			case Enum_Lis_TipoAccion.listaCombo:
				listaAcciones = tipoAccionCobDAO.listaTipoAccionCob(tipoLista);
				break;
			}			
		return listaAcciones.toArray(); 
	}
	
	public TipoAccionCobDAO getTipoAccionCobDAO() {
		return tipoAccionCobDAO;
	}

	public void setTipoAccionCobDAO(TipoAccionCobDAO tipoAccionCobDAO) {
		this.tipoAccionCobDAO = tipoAccionCobDAO;
	}
	
}
