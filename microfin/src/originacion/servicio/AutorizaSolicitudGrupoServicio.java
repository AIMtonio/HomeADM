package originacion.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.AutorizaSolicitudGrupoBean;
import originacion.dao.AutorizaSolicitudGrupoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class AutorizaSolicitudGrupoServicio extends BaseServicio {
	
	/* Declaracion de Variables */
	AutorizaSolicitudGrupoDAO autorizaSolicitudGrupoDAO = null;

	public AutorizaSolicitudGrupoServicio() {
		super();
	}
	
	public static interface Enum_Tra_SolCredito {
		int actualiza = 3;
	}
	
	public static interface Enum_Act_SolCredito {
		int autoriza 		= 1;	// autoriza la solicitud de credito grupal
		int regresarEjec	= 3;	//regresa a ejecutivo la solicitud de credito grupal
		int rechazar		= 4;	// rechaza la solicitud de credito grupal
	}

	
	//Lista de Integrantes de grupos 
	public static interface Enum_Lis_Grupos{
		int integraSolCredGrupal = 12;			//Lista de Integrantes Solicitud Grupal Solicitud Liberada
	}

	/* Transacciones de autorizacion de solicitud grupal */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,int tipoActualizacion,  AutorizaSolicitudGrupoBean autoriza){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {		
			case Enum_Tra_SolCredito.actualiza:		
				mensaje = actualizaSolicitudCredito(autoriza, tipoActualizacion);								
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizaSolicitudCredito(AutorizaSolicitudGrupoBean autoriza,int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
		case Enum_Act_SolCredito.autoriza:
			mensaje = autorizaSolicitudCredito(autoriza);	
			break;
		case Enum_Act_SolCredito.regresarEjec:
			mensaje = regresarEjecSolicitudCredito(autoriza,tipoActualizacion);	
			break;
		case Enum_Act_SolCredito.rechazar:
			mensaje = rechazarSolicitudCredito(autoriza,tipoActualizacion);	
			break;

		}
		return mensaje;
	}
	

		//Metodo para autorizar una solicitud de credito grupal
		public MensajeTransaccionBean autorizaSolicitudCredito(AutorizaSolicitudGrupoBean autoriza){
			MensajeTransaccionBean mensaje = null;
			ArrayList listaGrupos = (ArrayList) creaListaSolicitudFirma(autoriza.getListaIntegrantes(),autoriza.getDetalleFirmasAutoriza());

			mensaje = autorizaSolicitudGrupoDAO.autorizaSolicitudCredito(listaGrupos);
		  return mensaje;
         }
				
	
		//Metodo de rechazo de una solicitud de credito
		public MensajeTransaccionBean rechazarSolicitudCredito(AutorizaSolicitudGrupoBean autoriza, int tipoActualizacion){
			MensajeTransaccionBean mensaje = null;
			ArrayList listaRechazaSolicitud = (ArrayList) creaListaSolicitud(autoriza.getListaIntegrantes());
			
			mensaje = autorizaSolicitudGrupoDAO.rechazarSolicitudCredito(autoriza, tipoActualizacion,listaRechazaSolicitud);
			return mensaje;
		}

		//Metodo de regreso a ejecutivo de una solicitud de credito
		public MensajeTransaccionBean regresarEjecSolicitudCredito(AutorizaSolicitudGrupoBean autoriza, int tipoActualizacion){
			MensajeTransaccionBean mensaje = null;
			ArrayList listaAutorizaSolicitud = (ArrayList) creaListaSolicitud(autoriza.getListaIntegrantes());
			mensaje = autorizaSolicitudGrupoDAO.regresarEjecSolicitudCredito(autoriza, tipoActualizacion,listaAutorizaSolicitud);
			return mensaje;
		}
		
	//Lista de integrantes de una solicitud grupal
	public List lista(int tipoLista, AutorizaSolicitudGrupoBean bean){		
		List listaGrupos = null;
		switch (tipoLista) {
			case Enum_Lis_Grupos.integraSolCredGrupal:		
				listaGrupos=  autorizaSolicitudGrupoDAO.listaIntegraSolicitudGrupal(bean, tipoLista);				
				break;
		}		
		return listaGrupos;
	}
	

		// Crea la lista de solicitudes para rechazar / regresar a ejecutivo
		private List creaListaSolicitud(String listaIntegrantes){		
			StringTokenizer tokensBean = new StringTokenizer(listaIntegrantes, ",");
			String stringCampos;
			String tokensCampos[];
			ArrayList listaSolicitud = new ArrayList();
			AutorizaSolicitudGrupoBean autorizaSolicitudGrupoBean;
			
			while(tokensBean.hasMoreTokens()){
				autorizaSolicitudGrupoBean = new AutorizaSolicitudGrupoBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "-");
			
			autorizaSolicitudGrupoBean.setSolicitudCreditoID(tokensCampos[1]);
			autorizaSolicitudGrupoBean.setMontoAutorizado(tokensCampos[2]);
			autorizaSolicitudGrupoBean.setAporte(tokensCampos[3]);
			
			listaSolicitud.add(autorizaSolicitudGrupoBean);
			
			}	
			return listaSolicitud;
		}
		

		// Crea la lista de solicitudes con firmas para autorizar
		private List creaListaSolicitudFirma(String listaIntegrantes,String detalleFirmasAutor){		
			StringTokenizer tokensBean = new StringTokenizer(listaIntegrantes, ",");
			String stringCampos;
			String tokensCampos[];
			
			ArrayList listaSolicitud = new ArrayList();
			AutorizaSolicitudGrupoBean autorizaSolicitudGrupoBean= null;
			
			while(tokensBean.hasMoreTokens()){
			
				stringCampos = tokensBean.nextToken();		
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "-");
				StringTokenizer tokensBean2 = new StringTokenizer(detalleFirmasAutor, ",");
				String stringCampos2;
				String tokensCampos2[];
	
				while(tokensBean2.hasMoreTokens()){	
					stringCampos2 = tokensBean2.nextToken();		
					tokensCampos2 = herramientas.Utileria.divideString(stringCampos2, "-");
					autorizaSolicitudGrupoBean = new AutorizaSolicitudGrupoBean();
					
					autorizaSolicitudGrupoBean.setSolicitudCreditoID(tokensCampos[1]);
					autorizaSolicitudGrupoBean.setMontoAutorizado(tokensCampos[2]);
					autorizaSolicitudGrupoBean.setAporte(tokensCampos[3]);
					autorizaSolicitudGrupoBean.setEsquemaID(tokensCampos2[1]);
					autorizaSolicitudGrupoBean.setNumFirma(tokensCampos2[2]);
					autorizaSolicitudGrupoBean.setOrganoID(tokensCampos2[3]);

					listaSolicitud.add(autorizaSolicitudGrupoBean);
					
				}
			}	
			return listaSolicitud;
		}


	//* ============== Getter & Setter =============  //*	

	public AutorizaSolicitudGrupoDAO getAutorizaSolicitudGrupoDAO() {
		return autorizaSolicitudGrupoDAO;
	}

	public void setAutorizaSolicitudGrupoDAO(
			AutorizaSolicitudGrupoDAO autorizaSolicitudGrupoDAO) {
		this.autorizaSolicitudGrupoDAO = autorizaSolicitudGrupoDAO;
	}
	
}
