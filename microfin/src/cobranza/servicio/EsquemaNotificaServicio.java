package cobranza.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import cobranza.bean.EsquemaNotificaBean;
import cobranza.dao.EsquemaNotificaDAO;

public class EsquemaNotificaServicio extends BaseServicio{
	EsquemaNotificaDAO esquemaNotificaDAO = null;
	
	public static interface Enum_Tran_EsquemaNoti{
		int alta = 1;
	}
	
	public static interface Enum_Lis_EsquemaNoti{
		int gridParametros = 1;
		int etiquetasEtapa = 2;
	}
	
	public static interface Enum_Lis_Formatos{
		int listaCombo = 1;
	}
	
	//Mensaje de alta de esquema de notificacion de cobranza
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EsquemaNotificaBean esquemaBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaGrid(esquemaBean);
		switch(tipoTransaccion){
			case Enum_Tran_EsquemaNoti.alta:
				mensaje = esquemaNotificaDAO.grabaListaEsquema(esquemaBean,listaBean);
				break;
		}
		return mensaje;
	}
	
	//lista de parametros del grid
	public List listaGrid(EsquemaNotificaBean lisEsquemaNotificaBean){

		List<String> esquemaIDLis	  = lisEsquemaNotificaBean.getLisEsquemaID();
		List<String> diasAtrasoIniLis = lisEsquemaNotificaBean.getLisDiasAtrasoIni();
		List<String> diasAtrasoFinLis = lisEsquemaNotificaBean.getLisDiasAtrasoFin();
		List<String> numEtapaLis	  = lisEsquemaNotificaBean.getLisNumEtapa();
		List<String> etiquetaEtapaLis = lisEsquemaNotificaBean.getLisEtiquetaEtapa();
		List<String> accionLis		  = lisEsquemaNotificaBean.getLisAccion();
		List<String> formatoNotiLis   = lisEsquemaNotificaBean.getLisFormatoNoti();
		
		ArrayList listaDetalle = new ArrayList();
		EsquemaNotificaBean esquemaNotiBean = null;
		if(diasAtrasoIniLis !=null){ 			
			try{
				
			int tamanio = diasAtrasoIniLis.size();
				for(int i=0; i<tamanio; i++){
				
					esquemaNotiBean = new EsquemaNotificaBean();
					
					esquemaNotiBean.setEsquemaID(esquemaIDLis.get(i));
					esquemaNotiBean.setDiasAtrasoIni(diasAtrasoIniLis.get(i));
					esquemaNotiBean.setDiasAtrasoFin(diasAtrasoFinLis.get(i));
					esquemaNotiBean.setNumEtapa(numEtapaLis.get(i));
					esquemaNotiBean.setEtiquetaEtapa(etiquetaEtapaLis.get(i));
					esquemaNotiBean.setAccion(accionLis.get(i));
					esquemaNotiBean.setFormatoNoti(formatoNotiLis.get(i));
					listaDetalle.add(i,esquemaNotiBean);	
				}

			}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid de esquema de notificaciones", e);	
		}
	}
	return listaDetalle;
	}
	
	//Lista para el grid en la pantala esquema de notificaciones
	public List listaEsquemaNotifica(int tipoLista, EsquemaNotificaBean esquemaBean){
		List listaParametros = null;
		
		switch(tipoLista){
			case Enum_Lis_EsquemaNoti.gridParametros:
				listaParametros = esquemaNotificaDAO.listaGridEsquemaNoti(tipoLista, esquemaBean);
				break;
		}

		return listaParametros;
	}
	
	// listas para comboBox de formatos de notificacion
	public  Object[] listaCombo(int tipoLista) {
		List listaFormatos = null;
			switch(tipoLista){
				case (Enum_Lis_Formatos.listaCombo): 
					listaFormatos =  esquemaNotificaDAO.listaCombo(tipoLista);
					break;
			}			
		return listaFormatos.toArray(); 
	}

	// listas para comboBox de etiquetas de etapas de cobranza patalla bitacora de seg de cob
	public  Object[] listaComboEtapas(int tipoLista) {
		List lista = null;
			switch(tipoLista){
				case (Enum_Lis_EsquemaNoti.etiquetasEtapa): 
					lista =  esquemaNotificaDAO.listaComboEtapas(tipoLista);
					break;
			}			
		return lista.toArray(); 
	}
	
	public EsquemaNotificaDAO getEsquemaNotificaDAO() {
		return esquemaNotificaDAO;
	}

	public void setEsquemaNotificaDAO(EsquemaNotificaDAO esquemaNotificaDAO) {
		this.esquemaNotificaDAO = esquemaNotificaDAO;
	}

}
