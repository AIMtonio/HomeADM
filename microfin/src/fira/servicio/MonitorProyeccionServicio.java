package fira.servicio;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import bsh.Console;
import fira.bean.MonitorProyeccionBean;
import fira.dao.MonitorProyeccionDAO;

public class MonitorProyeccionServicio extends BaseServicio {
	MonitorProyeccionDAO monitorProyeccionDAO = null;
	
	public static interface Enum_Trans_Proyeccion{
		int procesaProyecion = 1;
		int actualizaProyeccion = 2;
		
	}
	
	public static interface Enum_Lis_Proyeccion{
		int listaAnioProyeccion = 1;
	}
	
	//alta de los tipos de respuesta de cobranza
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int anioLista, MonitorProyeccionBean ProyeccionBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaGrid(ProyeccionBean);
		switch(tipoTransaccion){			
			case Enum_Trans_Proyeccion.procesaProyecion:
				mensaje = monitorProyeccionDAO.grabaListaProyeccion(listaBean,tipoTransaccion, anioLista);
				break;
			case Enum_Trans_Proyeccion.actualizaProyeccion:
				mensaje = monitorProyeccionDAO.modificaListaProyeccion(listaBean,tipoTransaccion, anioLista);
				break;
		}
		return mensaje;
	}
	
	//Lista para el grid en la pantalla tipos respuesta 
	public List listaProyeccion(int anioLista, int tipoLista, MonitorProyeccionBean proyeccionBean){
		List listaParametros = null;
		
		switch(tipoLista){
			case Enum_Lis_Proyeccion.listaAnioProyeccion:
				listaParametros = monitorProyeccionDAO.listaProyeccion(anioLista, tipoLista, proyeccionBean);
				break;
		}

		return listaParametros;
	}	
	

	//lista de parametros del grid
	public List listaGrid(MonitorProyeccionBean lisProyeccionBean){
		
		List<String> consecutivoIDLis	= lisProyeccionBean.getLisConsecutivoID();
		List<String> anioLis			= lisProyeccionBean.getLisAnio();
		List<String> mesLis 			= lisProyeccionBean.getLisMes();
		List<String> saldoTotalLis 		= lisProyeccionBean.getLisSaldoTotal();
		List<String> saldoFiraLis 		= lisProyeccionBean.getLisSaldoFira();
		List<String> gastosAdminLis 	= lisProyeccionBean.getLisGastosAdmin();
		List<String> capitalContaLis 	= lisProyeccionBean.getLisCapitalConta();
		List<String> utilidadNetaLis 	= lisProyeccionBean.getLisUtilidadNeta();
		List<String> activoTotalLis 	= lisProyeccionBean.getLisActivoTotal();
		List<String> saldoVencidoLis 	= lisProyeccionBean.getLisSaldoVencido();
		List<String> flagLis 			= lisProyeccionBean.getLisFlag();

		ArrayList listaDetalle = new ArrayList();
		MonitorProyeccionBean proyeccionBean = null;
		if(consecutivoIDLis !=null){ 			
			try{
				
			int tamanio = 12;
				for(int i=0; i<tamanio; i++){
				
					proyeccionBean = new MonitorProyeccionBean();					
								
					proyeccionBean.setConsecutivoID(consecutivoIDLis.get(i));
					proyeccionBean.setAnio(anioLis.get(i));
					proyeccionBean.setMes(mesLis.get(i));
					proyeccionBean.setSaldoTotal(saldoTotalLis.get(i));
					proyeccionBean.setSaldoFira(saldoFiraLis.get(i));
					proyeccionBean.setGastosAdmin(gastosAdminLis.get(i));
					proyeccionBean.setCapitalConta(capitalContaLis.get(i));
					proyeccionBean.setUtilidadNeta(utilidadNetaLis.get(i));
					proyeccionBean.setActivoTotal(activoTotalLis.get(i));
					proyeccionBean.setSaldoVencido(saldoVencidoLis.get(i));
					proyeccionBean.setFlag(flagLis.get(i));
					
					listaDetalle.add(i,proyeccionBean);	
				}
			}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de proyección", e);	
		}
	}
	return listaDetalle;
	}

	public MonitorProyeccionDAO getMonitorProyeccionDAO() {
		return monitorProyeccionDAO;
	}

	public void setMonitorProyeccionDAO(MonitorProyeccionDAO monitorProyeccionDAO) {
		this.monitorProyeccionDAO = monitorProyeccionDAO;
	}

}
