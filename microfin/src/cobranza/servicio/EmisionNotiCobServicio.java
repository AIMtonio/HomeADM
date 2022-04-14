package cobranza.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import cobranza.bean.EmisionNotiCobBean;
import cobranza.dao.EmisionNotiCobDAO;

public class EmisionNotiCobServicio extends BaseServicio{
	EmisionNotiCobDAO emisionNotiCobDAO = null;
	
	public static interface Enum_Trans_EmisionNoti{
		int emitir 	= 1;
	}
	
	public static interface Enum_Lis_CredNoti{
		int principal = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,EmisionNotiCobBean emisionNoti){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaGrid(emisionNoti);
		switch(tipoTransaccion){
			case Enum_Trans_EmisionNoti.emitir:
				mensaje = emisionNotiCobDAO.altaEmisionNotificacion(emisionNoti,listaBean);
				break;
		}
		return mensaje;
	}	
	
	//lista de parametros del grid
	public List listaGrid(EmisionNotiCobBean lisEmisionNotificaBean){

		List<String> creditosLis  = lisEmisionNotificaBean.getLisCreditoID();
		List<String> soliCredLis  = lisEmisionNotificaBean.getLisSoliCredito(); 
		List<String> formatoIDLis = lisEmisionNotificaBean.getLisFormatoID();
		List<String> etiEtapaLis  = lisEmisionNotificaBean.getLisEtiquetaEtapa();
		List<String> fechaCitaLis = lisEmisionNotificaBean.getLisFechaCita();
		List<String> horaCitaLis  = lisEmisionNotificaBean.getLisHoraCita();
		List<String> emitirLis    = lisEmisionNotificaBean.getLisEmitirCheck();
		
		ArrayList listaDetalle = new ArrayList();
		EmisionNotiCobBean emisionNotiBean = null;
		if(creditosLis != null){
			try{
			int tamanio = creditosLis.size();	
			int aux = 0;
				for(int i = 0; i < tamanio; i++){

					if((emitirLis.get(i)).equals("S")){

						emisionNotiBean = new EmisionNotiCobBean();

						emisionNotiBean.setCreditoID(creditosLis.get(i));						
						emisionNotiBean.setSolicitudCreditoID(soliCredLis.get(i));
						emisionNotiBean.setFormatoID(formatoIDLis.get(i));						
						emisionNotiBean.setEtiquetaEtapa(etiEtapaLis.get(i));						
						emisionNotiBean.setFechaCita(fechaCitaLis.get(i));
						emisionNotiBean.setHoraCita(horaCitaLis.get(i));
						emisionNotiBean.setEmitirCheck(emitirLis.get(i));
												
						emisionNotiBean.setFechaSis(lisEmisionNotificaBean.getFechaSis());
						emisionNotiBean.setUsuarioID(lisEmisionNotificaBean.getUsuarioID());
						emisionNotiBean.setClaveUsuario(lisEmisionNotificaBean.getClaveUsuario());
						emisionNotiBean.setSucursalUsuID(lisEmisionNotificaBean.getSucursalUsuID());
						emisionNotiBean.setNombreInsti(lisEmisionNotificaBean.getNombreInsti());
						
						listaDetalle.add(aux,emisionNotiBean);
						aux++;
					}
				}
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid de emision de notificaciones", e);	
			}
	}
	return listaDetalle;
	}
	
	public List listaCreditosGrid(int tipoLista,EmisionNotiCobBean emisionBean){		
		List listaCred = null;
		
		switch(tipoLista){
		case Enum_Lis_CredNoti.principal:
			listaCred = emisionNotiCobDAO.listaEmisionCreditos(tipoLista,emisionBean);
			break;
		}

		return listaCred;
	}

	public EmisionNotiCobDAO getEmisionNotiCobDAO() {
		return emisionNotiCobDAO;
	}

	public void setEmisionNotiCobDAO(EmisionNotiCobDAO emisionNotiCobDAO) {
		this.emisionNotiCobDAO = emisionNotiCobDAO;
	}	
}
