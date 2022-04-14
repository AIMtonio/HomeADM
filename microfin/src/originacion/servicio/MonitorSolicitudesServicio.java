package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import cobranza.bean.EmisionNotiCobBean;
import cobranza.servicio.EmisionNotiCobServicio.Enum_Lis_CredNoti;
import originacion.bean.MonitorSolicitudesBean;
import originacion.dao.MonitorSolicitudesDAO;



public class MonitorSolicitudesServicio extends BaseServicio {
	MonitorSolicitudesDAO monitorSolicitudesDAO= null;
	
	public static interface Enum_Lis_Solicitud{
		int lisNumSol =1; // Lista la cantidad de estatus que hay en las solicitudes de crédito.
		int lisDetSol = 2; // Lista información de las solicitudes de Crédito.
		int lisCanalIngreso = 3; // Lista información del Canal de Ingreso de las Solicitudes de Crédito.
		int lisCredCond = 4;	// Lista de las Solicitudes con Créditos Condicionados
	}
	
	//---------- Tipo de Transacciones ----------------------------------------------------------------	
		public static interface Enum_Tra_Creditos {
			int actualizaEst =1;
			int actualizaEstSol =2;
			

		}
	
	private MonitorSolicitudesServicio(){
		super();
	}		


	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	MonitorSolicitudesBean monitorSolicitudesBean ){		
		ArrayList listaSolicitudesSolventar = new ArrayList();
		ArrayList listaSolicitudesActualizacion = new ArrayList();

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_Creditos.actualizaEst:
				listaSolicitudesSolventar = (ArrayList) creaListaDetalle(monitorSolicitudesBean);
				mensaje = monitorSolicitudesDAO.grabaEstatus(monitorSolicitudesBean,listaSolicitudesSolventar, Enum_Tra_Creditos.actualizaEst);	
				int  mensajeError = mensaje.getNumero();
				
				break;	
			case Enum_Tra_Creditos.actualizaEstSol:
				listaSolicitudesActualizacion = (ArrayList) creaListaDetalleAct(monitorSolicitudesBean);
				mensaje = monitorSolicitudesDAO.grabaEstatusAct(monitorSolicitudesBean,listaSolicitudesActualizacion, Enum_Tra_Creditos.actualizaEst);	
				break;	
		}
		return mensaje;
	}
	

		public List creaListaDetalle(MonitorSolicitudesBean monitorSolicitudesBean) {
			
			List<String> solicitudes  = monitorSolicitudesBean.getLsolicitud();
			List<String> creditos  = monitorSolicitudesBean.getLcredito();	
			List<String> estatus  = monitorSolicitudesBean.getLvalorSolventar();	
			List<String> comentario  = monitorSolicitudesBean.getLcomentario();	
			ArrayList listaDetalle = new ArrayList();
			MonitorSolicitudesBean solicitudesSolventar = null;	
			if(solicitudes != null){
				int tamanio = solicitudes.size();	

				for (int i = 0; i < tamanio; i++) {
					solicitudesSolventar = new MonitorSolicitudesBean();
					solicitudesSolventar.setSolicitudCreditoID(solicitudes.get(i));
					solicitudesSolventar.setCreditoID(creditos.get(i));	
					solicitudesSolventar.setValorSolventar(estatus.get(i));
					solicitudesSolventar.setComentario(comentario.get(i));	
					
					listaDetalle.add(solicitudesSolventar);
				}
			}
			return listaDetalle;
			
		}
		

		
		private List<MonitorSolicitudesBean> creaListaDetalleAct(MonitorSolicitudesBean monitorSolicitudesBean) {
			String detalles=monitorSolicitudesBean.getDetalleEstatus();
			StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		
			String stringCampos;
			String tokensCampos[];
			List<MonitorSolicitudesBean> listaDetalle = new ArrayList<MonitorSolicitudesBean>();
			MonitorSolicitudesBean detalle;
			try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new MonitorSolicitudesBean();
				stringCampos = tokensBean.nextToken();
				
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				detalle.setSolicitudCreditoID(tokensCampos[0]);
				detalle.setEstatusSolicitud(tokensCampos[1]);
				
				listaDetalle.add(detalle);
			}
			} catch (Exception e){
				e.printStackTrace();
			}
			return listaDetalle;
		}



	public List listaCantidadSolGrid(int tipoLista,MonitorSolicitudesBean monitorSolicitudesBean){		
		List listaSol = null;
	
		switch(tipoLista){
		case Enum_Lis_Solicitud.lisNumSol:
			listaSol = monitorSolicitudesDAO.listaCantidadSolicitudesDAO(tipoLista,monitorSolicitudesBean);
			break;
		case Enum_Lis_Solicitud.lisDetSol:
			listaSol = monitorSolicitudesDAO.listaDetalleSolicitudesDAO(tipoLista,monitorSolicitudesBean);
			break;
		case Enum_Lis_Solicitud.lisCanalIngreso:
			listaSol = monitorSolicitudesDAO.listaCanalIngresoSolicitudesDAO(tipoLista,monitorSolicitudesBean);
			break;
		case Enum_Lis_Solicitud.lisCredCond:
			listaSol = monitorSolicitudesDAO.listaDetalleSolicitudesDAO(tipoLista,monitorSolicitudesBean);
			break;
			
		}
		
		
		
		return listaSol;
	}
	public MonitorSolicitudesDAO getmonitorSolicitudesDAO() {
		return monitorSolicitudesDAO;
	}

	public void setmonitorSolicitudesDAO(MonitorSolicitudesDAO monitorSolicitudesDAO) {
		this.monitorSolicitudesDAO = monitorSolicitudesDAO;
	}
	
	
}
