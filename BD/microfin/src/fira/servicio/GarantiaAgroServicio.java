package fira.servicio;

import java.util.ArrayList;
import java.util.List;

import originacion.servicio.CalendarioProdServicio.Enum_Tra_Calendario;
import originacion.servicio.GarantiaServicio.Enum_Con_garantia;
import originacion.servicio.GarantiaServicio.Enum_TipoCon_garantia;
import originacion.servicio.GarantiaServicio.Enum_TipoLis_AsignaGarantias;

import fira.bean.GarantiaAgroBean;
import fira.dao.GarantiasAgroDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GarantiaAgroServicio extends BaseServicio {
	GarantiasAgroDAO garantiasDAO = null;

	public static interface Enum_Con_garantia{
		int alta = 1;
		int modificacion = 2;
		int principal=1;
		int altaAsignacion=3;
		int foranea=2;
		int altaGarantiasReest = 4;
		int altaAsignaciongro=5;
	}
	public static interface Enum_TipoCon_garantia{
		int principal=1;
		int requiereGaraCred=3;
		int requiereGaraSoli=4;
		int fueAsignada = 5;
		int perteneceASolicitud = 6;
		int garantiaReest= 7;

	}
	
	public static interface Enum_TipoLis_AsignaGarantias{
		int principal=1; //lista para grid de garantias
		int listCliPros=3; //lista de ayuda en pantalla de registro de garantias
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GarantiaAgroBean garantiaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaDetalle = null;
		switch (tipoTransaccion) {
		
		case Enum_Tra_Calendario.alta:		
			mensaje = garantiasDAO.altaGarantia(garantiaBean);						
			break;	
		case Enum_Tra_Calendario.modificacion:		
			mensaje = garantiasDAO.actualizaGarantia(garantiaBean);
			break;
		case Enum_Con_garantia.altaAsignacion:		
			listaDetalle = (ArrayList) DetalleGrid(garantiaBean,tipoTransaccion);
			mensaje = garantiasDAO.grabaListaGarantias(garantiaBean, listaDetalle);
			break;
		case Enum_Con_garantia.altaGarantiasReest:		
			listaDetalle = (ArrayList) DetalleGridReest(garantiaBean);
			mensaje = garantiasDAO.altaAsignaGarReest(garantiaBean, listaDetalle);
			break;
		case Enum_Con_garantia.altaAsignaciongro:		
			listaDetalle = (ArrayList) DetalleGrid(garantiaBean,tipoTransaccion);
			mensaje = garantiasDAO.grabaListaGarantias(garantiaBean, listaDetalle);
			break;
		}
		return mensaje;
	}


	public List clasifGarantiasLista(int tipoLista,  GarantiaAgroBean garantiaBean){
		List ListaClasGarantias = null;
		ListaClasGarantias = garantiasDAO.clasificacionGarantias(tipoLista, garantiaBean);
		return ListaClasGarantias;
	}

	public GarantiaAgroBean consultaGarantia(int tipoCon,  GarantiaAgroBean garantiaBean){
		GarantiaAgroBean garantiaBeanSalida= null;
		switch(tipoCon){
		case Enum_TipoCon_garantia.principal:
			garantiaBeanSalida= garantiasDAO.consultaPrincipalGarantia(tipoCon, garantiaBean);
			break;
		case Enum_TipoCon_garantia.requiereGaraCred:
			garantiaBeanSalida= garantiasDAO.productoRequiereGarantia(garantiaBean, tipoCon);
			break;
		case Enum_TipoCon_garantia.requiereGaraSoli:
			garantiaBeanSalida= garantiasDAO.productoRequiereGarantia(garantiaBean, tipoCon);
			break;
		case Enum_TipoCon_garantia.fueAsignada:
			garantiaBeanSalida= garantiasDAO.estaAsignadaGarantia(garantiaBean, tipoCon);
			break;
		case Enum_TipoCon_garantia.perteneceASolicitud:
			garantiaBeanSalida= garantiasDAO.estaAsigGarantiaASolicitud(garantiaBean, tipoCon);
			break;			
			
		}
		return garantiaBeanSalida;
	}

	public List lista(int tipoLista,  GarantiaAgroBean garantiaBean){		
		List listaGarantias = null;
		switch (tipoLista) {
		case Enum_Con_garantia.principal:		
			listaGarantias = garantiasDAO.listaPrincipal(garantiaBean, tipoLista);				
			break;	
		case Enum_Con_garantia.foranea:		
			listaGarantias = garantiasDAO.listaGrigAsignacion(garantiaBean, tipoLista);			
			break;		
		case Enum_TipoLis_AsignaGarantias.listCliPros:		
			listaGarantias = garantiasDAO.listaCliPro(garantiaBean, tipoLista);			
			break;
		case Enum_TipoCon_garantia.garantiaReest:		
			listaGarantias = garantiasDAO.listaGarantiaReest(garantiaBean, tipoLista);			
			break;
		}		
		return listaGarantias;
	}
	
	
	public List listaAsignaGarantias(int tipoLista, GarantiaAgroBean garantiaBean){		
		List listaGarantiasAsignada = null;
		switch (tipoLista) {
		case Enum_TipoLis_AsignaGarantias.principal:		
			listaGarantiasAsignada = garantiasDAO.listaAutorizadas(garantiaBean, tipoLista);			
			break;		
		}		
		return listaGarantiasAsignada;
	}
	
	
	

	public MensajeTransaccionBean altaAsignaciones(GarantiaAgroBean garantiaBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje=null;
		GarantiaAgroBean garantiaGridBean=null;
		mensaje=garantiasDAO.bajaAsignacionGarantia(garantiaBean);
		if(mensaje.getNumero()==0){
			ArrayList listaDetalle = (ArrayList) DetalleGrid(garantiaBean,tipoTransaccion);
			if(!listaDetalle.isEmpty()){
				for(int i=0; i<listaDetalle.size(); i++){
					garantiaGridBean=(GarantiaAgroBean)listaDetalle.get(i);
					mensaje=garantiasDAO.altaAsignacionGarantia(garantiaGridBean);
				}
			}
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaAsignaGarReest(GarantiaAgroBean garantiaBean){
		MensajeTransaccionBean mensaje=null;
		GarantiaAgroBean garantiaGridBean=null;
		mensaje=garantiasDAO.bajaAsignacionGarantiaReest(garantiaBean);
		if(mensaje.getNumero()==0){
			ArrayList listaDetalle = (ArrayList) DetalleGridReest(garantiaBean);
			if(!listaDetalle.isEmpty()){
				for(int i=0; i<listaDetalle.size(); i++){
					garantiaGridBean=(GarantiaAgroBean)listaDetalle.get(i);
					char Origen = 'O';
					
					String estatus = garantiaGridBean.getEstatusSolicitud();
				
					if(estatus.charAt(0)!= Origen){
						mensaje=garantiasDAO.altaAsignacionGarantia(garantiaGridBean);
					}
					
				}
			}
		}
		return mensaje;
	}



	public List DetalleGrid(GarantiaAgroBean garantiaBean, int tipoTransaccion) {
 
		List<String> listaGarantias   = garantiaBean.getLgarantiaID();
		List<String> listaMontoAsig   = garantiaBean.getLmontoAsignado();
		List<String> listaSustituyeGL = garantiaBean.getLsustituyeGL();
		List<String> listaEstatusSolicitud = garantiaBean.getLestatusSolicitud();
		int tamanio=0;
		ArrayList listaDetalle = new ArrayList();
		GarantiaAgroBean garantiaBeanSalida = null;

		if( listaGarantias!=null){
		  tamanio= listaGarantias.size();
		}
		for (int i = 0; i < tamanio; i++) {
			garantiaBeanSalida = new GarantiaAgroBean();

			garantiaBeanSalida.setCreditoID(garantiaBean.getCreditoID());
			garantiaBeanSalida.setSolicitudCreditoID(garantiaBean.getSolicitudCreditoID());
			garantiaBeanSalida.setGarantiaID(listaGarantias.get(i));
			garantiaBeanSalida.setMontoAsignado( listaMontoAsig.get(i).trim().replaceAll(",","").replaceAll("\\$",""));
			garantiaBeanSalida.setEstatus(garantiaBean.getEstatus());
			garantiaBeanSalida.setEstatusSolicitud(listaEstatusSolicitud.get(i));
			if(tipoTransaccion==Enum_Con_garantia.altaAsignacion){
				//asignar valor
				garantiaBeanSalida.setSustituyeGL("N");

			}else{
				garantiaBeanSalida.setSustituyeGL(listaSustituyeGL.get(i));

			}
			listaDetalle.add(garantiaBeanSalida);
		}

		return listaDetalle;
	}
	
	public List DetalleGridReest(GarantiaAgroBean garantiaBean) {

		List<String> listaGarantias  = garantiaBean.getLgarantiaID();
		List<String> listaMontoAsig = garantiaBean.getLmontoAsignado();
		List<String> listaEstatusSol = garantiaBean.getLestatusSolicitud();
		List<String> listaEstatusSolicitud = garantiaBean.getLestatusSolicitud();
		int tamanio=0;
		ArrayList listaDetalle = new ArrayList();
		GarantiaAgroBean garantiaBeanSalida = null;

		if( listaGarantias!=null){
		  tamanio= listaGarantias.size();
		}
		for (int i = 0; i < tamanio; i++) {
			garantiaBeanSalida = new GarantiaAgroBean();

			garantiaBeanSalida.setCreditoID(garantiaBean.getCreditoID());
			garantiaBeanSalida.setSolicitudCreditoID(garantiaBean.getSolicitudCreditoID());
			garantiaBeanSalida.setGarantiaID(listaGarantias.get(i));
			garantiaBeanSalida.setMontoAsignado( listaMontoAsig.get(i).trim().replaceAll(",","").replaceAll("\\$",""));
			garantiaBeanSalida.setEstatus(garantiaBean.getEstatus());
			garantiaBeanSalida.setEstatusSolicitud(listaEstatusSolicitud.get(i));
			listaDetalle.add(garantiaBeanSalida);
		}

		return listaDetalle;
	}


	public void setGarantiasAgroDAO(GarantiasAgroDAO garantiasAgroDAO){
		this.garantiasDAO= garantiasAgroDAO;

	}
	public GarantiasAgroDAO getgarantiasAgroDAO(){
		return garantiasDAO;
	}
}

