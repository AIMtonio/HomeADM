package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import bsh.Console;
import originacion.bean.MonitorRiesgoComunBean;
import originacion.dao.MonitorRiesgoComunDAO;

public class MonitorRiesgoComunServicio extends BaseServicio{
	MonitorRiesgoComunDAO monitorRiesgoComunDAO = null;
	
	public static interface Enum_Trans_RiesgoComun{
		int actualizaRiesgoComun = 1;
		int procesaRiesgoComun = 2;
	}
	
	public static interface Enum_Lis_RiesgoComun{
		int lisRiesgosSolicitud = 1;
		int listaTotalRiesgos	= 2;
	}
	
	//alta de los tipos de respuesta de cobranza
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, MonitorRiesgoComunBean riesgoComunBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaGrid(riesgoComunBean);
		switch(tipoTransaccion){			
			case Enum_Trans_RiesgoComun.procesaRiesgoComun:
				mensaje = monitorRiesgoComunDAO.grabaListaRiesgoComun(listaBean,tipoTransaccion);
				break;
		}
		return mensaje;
	}

	//lista de parametros del grid
	public List listaGrid(MonitorRiesgoComunBean lisRiesgoComunBean){
		
		List<String> solicitudCreditoIDLis	= lisRiesgoComunBean.getLisSolicitudCreditoID();
		List<String> creditoIDLis	= lisRiesgoComunBean.getLisCreditoID();
		List<String> clienteIDLis = lisRiesgoComunBean.getLisClienteID();
		List<String> nombreLis 	= lisRiesgoComunBean.getLisNombreCliente();
		List<String> clienteIDRelLis = lisRiesgoComunBean.getLisClienteIDRel();
		List<String> nombreRelLis 	= lisRiesgoComunBean.getLisNombreClienteRel();
		List<String> motivoLis 	= lisRiesgoComunBean.getLisMotivo();
		List<String> esRiesgoLis 	= lisRiesgoComunBean.getLisEsRiesgo();
		List<String> comentariosLis 	= lisRiesgoComunBean.getLisComentario();
		List<String> procesadoLis 	= lisRiesgoComunBean.getLisProcesado();
		List<String> comentariosMonitorLis 	= lisRiesgoComunBean.getLisComentariosMonitor();
		List<String> consecutivoLis 	= lisRiesgoComunBean.getLisConsecutivoID();
		List<String> descParentLis 	= lisRiesgoComunBean.getLisDescParen();
		List<String> estatusLis 	= lisRiesgoComunBean.getLisEstatus();
		List<String> claveLis 	= lisRiesgoComunBean.getLisClave();
		
		ArrayList listaDetalle = new ArrayList();
		MonitorRiesgoComunBean riesgoComunBean = null;
		if(creditoIDLis !=null){ 			
			try{
				
			int tamanio = creditoIDLis.size();
				for(int i=0; i<tamanio; i++){
				
					riesgoComunBean = new MonitorRiesgoComunBean();					
								
					riesgoComunBean.setSolicitudCreditoID(lisRiesgoComunBean.getSolicitudCreditoID());
					riesgoComunBean.setCreditoID(creditoIDLis.get(i));
					riesgoComunBean.setClienteID(clienteIDLis.get(i));
					riesgoComunBean.setNombreCliente(nombreLis.get(i));
					riesgoComunBean.setClienteIDRel(clienteIDRelLis.get(i));
					riesgoComunBean.setNombreClienteRel(nombreRelLis.get(i));
					riesgoComunBean.setMotivo(motivoLis.get(i));
					riesgoComunBean.setEsRiesgo(esRiesgoLis.get(i));
					riesgoComunBean.setComentarios(comentariosLis.get(i));
					riesgoComunBean.setSolicitudCreditoID(solicitudCreditoIDLis.get(i));
					riesgoComunBean.setProcesado(procesadoLis.get(i));
					riesgoComunBean.setComentariosMonitor(comentariosMonitorLis.get(i));
					riesgoComunBean.setConsecutivoID(consecutivoLis.get(i));					
					riesgoComunBean.setEstatus(estatusLis.get(i));
					riesgoComunBean.setClave(claveLis.get(i));
					
					
					listaDetalle.add(i,riesgoComunBean);	
				}

			}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de posibles riesgos", e);	
		}
	}
	return listaDetalle;
	}
	
	//Lista para el grid en la pantalla tipos respuesta 
	public List listaRiesgoComun(int tipoLista, MonitorRiesgoComunBean riesgoComunBean){
		List listaParametros = null;
		
		switch(tipoLista){
			case Enum_Lis_RiesgoComun.listaTotalRiesgos:
				listaParametros = monitorRiesgoComunDAO.listaRiesgoComun(tipoLista, riesgoComunBean);
				break;
		}

		return listaParametros;
	}	
	
	

	public MonitorRiesgoComunDAO getMonitorRiesgoComunDAO() {
		return monitorRiesgoComunDAO;
	}

	public void setMonitorRiesgoComunDAO(MonitorRiesgoComunDAO monitorRiesgoComunDAO) {
		this.monitorRiesgoComunDAO = monitorRiesgoComunDAO;
	}

	

	

	
}
