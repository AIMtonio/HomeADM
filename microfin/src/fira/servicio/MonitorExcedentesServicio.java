package fira.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import bsh.Console;
import fira.bean.MonitorExcedentesBean;
import fira.dao.MonitorExcedentesDAO;

public class MonitorExcedentesServicio extends BaseServicio{
MonitorExcedentesDAO monitorExcedentesDAO = null;
	
	public static interface Enum_Trans_Excedentes{
		int procesaExcedentes = 1;
		
	}
	
	public static interface Enum_Lis_Excedentes{
		int listaExcedentes = 1;
	}
	
	//alta de los tipos de respuesta de cobranza
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, String fecha, MonitorExcedentesBean ExcedentesBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaGrid(ExcedentesBean);
		switch(tipoTransaccion){			
			case Enum_Trans_Excedentes.procesaExcedentes:
				mensaje = monitorExcedentesDAO.grabaListaExcedentes(listaBean,tipoTransaccion, fecha);
				break;
		}
		return mensaje;
	}
	
	//Lista para el grid en la pantalla tipos respuesta 
	public List listaExcedentes(String fecha, int tipoLista, MonitorExcedentesBean excedentesBean){
		List listaParametros = null;
		
		switch(tipoLista){
			case Enum_Lis_Excedentes.listaExcedentes:
				listaParametros = monitorExcedentesDAO.listaExcedentes(fecha, tipoLista, excedentesBean);
				break;
		}

		return listaParametros;
	}	
	

	//lista de parametros del grid
	public List listaGrid(MonitorExcedentesBean lisExcedentesBean){
		
		List<String> grupoIDLis				= lisExcedentesBean.getLisGrupoID();
		List<String> riesgoIDLis			= lisExcedentesBean.getLisRiesgoID();
		List<String> clienteIDLis			= lisExcedentesBean.getLisClienteID();
		List<String> nombreIntegranteLis 	= lisExcedentesBean.getLisNombreIntegrante();
		List<String> tipoPersonaLis 		= lisExcedentesBean.getLisTipoPersona();
		List<String> rfcLis 				= lisExcedentesBean.getLisRFC();
		List<String> curpLis 				= lisExcedentesBean.getLisCURP();
		List<String> saldoIntegranteLis 	= lisExcedentesBean.getLisSaldoIntegrante();
		List<String> saldoGrupalLis 		= lisExcedentesBean.getLisSaldoGrupal();

		ArrayList listaDetalle = new ArrayList();
		MonitorExcedentesBean excedentesBean = null;
		
		if(grupoIDLis !=null){ 			
			try{
			
				for(int i=0; i<grupoIDLis.size(); i++){
				
					excedentesBean = new MonitorExcedentesBean();					
								
					excedentesBean.setGrupoID(grupoIDLis.get(i));
					excedentesBean.setRiesgoID(riesgoIDLis.get(i));
					excedentesBean.setClienteID(clienteIDLis.get(i));
					excedentesBean.setNombreIntegrante(nombreIntegranteLis.get(i));
					excedentesBean.setTipoPersona(tipoPersonaLis.get(i));
					excedentesBean.setRfc(rfcLis.get(i));
					excedentesBean.setCurp(curpLis.get(i));
					excedentesBean.setSaldoIntegrante(saldoIntegranteLis.get(i));
					excedentesBean.setSaldoGrupal(saldoGrupalLis.get(i));
										
					listaDetalle.add(i,excedentesBean);	
				}
			}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Excedentes de Riesgo", e);	
		}
	}
	return listaDetalle;
	}

	public MonitorExcedentesDAO getMonitorExcedentesDAO() {
		return monitorExcedentesDAO;
	}

	public void setMonitorExcedentesDAO(MonitorExcedentesDAO monitorExcedentesDAO) {
		this.monitorExcedentesDAO = monitorExcedentesDAO;
	}
}
