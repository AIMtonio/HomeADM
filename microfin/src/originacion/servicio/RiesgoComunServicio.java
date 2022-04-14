package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import originacion.bean.MonitorSolicitudesBean;
import originacion.bean.RiesgoComunBean;
import originacion.dao.RiesgoComunDAO;
import originacion.servicio.MonitorSolicitudesServicio.Enum_Tra_Creditos;

public class RiesgoComunServicio extends BaseServicio{
	RiesgoComunDAO riesgoComunDAO = null;
	
	public static interface Enum_Trans_RiesgoComun{
		int actualizaRiesgoComun = 1;
	}
	
	public static interface Enum_Lis_RiesgoComun{
		int lisGridParametros = 1;
		int listaCombo	= 2;
	}
	
	//alta de los tipos de respuesta de cobranza
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, RiesgoComunBean riesgoComunBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaGrid(riesgoComunBean);
		switch(tipoTransaccion){
			case Enum_Trans_RiesgoComun.actualizaRiesgoComun:
				mensaje = riesgoComunDAO.grabaListaRiesgoComun(listaBean,tipoTransaccion);
				break;
		}
		return mensaje;
	}
	

	//lista de parametros del grid
	public List listaGrid(RiesgoComunBean lisRiesgoComunBean){

		List<String> creditoIDLis	= lisRiesgoComunBean.getLisCreditoID();
		List<String> clienteIDLis = lisRiesgoComunBean.getLisClienteID();
		List<String> esRiesgoLis 	= lisRiesgoComunBean.getLisEsRiesgo();
		List<String> comentariosLis 	= lisRiesgoComunBean.getLisComentarios();
		List<String> consecutivoLis 	= lisRiesgoComunBean.getLisConsecutivoID();
		
		
		ArrayList listaDetalle = new ArrayList();
		RiesgoComunBean riesgoComunBean = null;
		if(creditoIDLis !=null){ 			
			try{
				
			int tamanio = creditoIDLis.size();
				for(int i=0; i<tamanio; i++){
				
					riesgoComunBean = new RiesgoComunBean();
					
					riesgoComunBean.setSolicitudCreditoID(lisRiesgoComunBean.getSolicitudCreditoID());
					riesgoComunBean.setCreditoID(creditoIDLis.get(i));
					riesgoComunBean.setClienteID(clienteIDLis.get(i));
					riesgoComunBean.setEsRiesgo(esRiesgoLis.get(i));
					riesgoComunBean.setComentarios(comentariosLis.get(i));
					riesgoComunBean.setConsecutivoID(consecutivoLis.get(i));
					
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
	public List listaRiesgoComun(int tipoLista, RiesgoComunBean riesgoComunBean){
		List listaParametros = null;
		
		switch(tipoLista){
			case Enum_Lis_RiesgoComun.lisGridParametros:
				listaParametros = riesgoComunDAO.listaRiesgoComun(tipoLista, riesgoComunBean);
				break;
		}

		return listaParametros;
	}	
	
	// listas para comboBox 
	public  Object[] listaCombo(int tipoLista,  RiesgoComunBean riesgoComunBean) {
		List listaRiesgos = null;
			switch(tipoLista){
			case Enum_Lis_RiesgoComun.listaCombo:
				listaRiesgos = riesgoComunDAO.listaRiesgoComun(tipoLista, riesgoComunBean);
				break;
			}			
		return listaRiesgos.toArray(); 
	}

	public RiesgoComunDAO getRiesgoComunDAO() {
		return riesgoComunDAO;
	}

	public void setRiesgoComunDAO(RiesgoComunDAO riesgoComunDAO) {
		this.riesgoComunDAO = riesgoComunDAO;
	}

	

	
}
