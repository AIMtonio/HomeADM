
package fira.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.SolicitudCreditoFiraBean;
import fira.servicio.SolicitudCreditoFiraServicio;



public class FlujoIndividualRenovacionFiraControlador  extends SimpleFormController {
	
	SolicitudCreditoFiraServicio solicitudCreditoFiraServicio = null;
	int liberar =6;
	int rechazar =4;
	int agregarComentario= 7 ;
	
	public FlujoIndividualRenovacionFiraControlador() {
		setCommandClass(SolicitudCreditoFiraBean.class);
		setCommandName("solicitudCredito");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response,
									Object command,	BindException errors) throws Exception {
		
		SolicitudCreditoFiraBean solicitudCredito = null;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
				Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
			
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null) ?
						Integer.parseInt(request.getParameter("tipoActualizacion")): 0;		
	

			String  solicitudCreditoID = (request.getParameter("numSolicitud")!=null)? request.getParameter("numSolicitud"):"0";		
			String  comentarioEjec = (request.getParameter("nuevosComents")!=null)? request.getParameter("nuevosComents"):"";
			String  comentarioRechazo = (request.getParameter("motivoRechazo")!=null)? request.getParameter("motivoRechazo"):"";
			
			solicitudCredito = new SolicitudCreditoFiraBean();
			solicitudCredito.setSolicitudCreditoID(solicitudCreditoID);
			if(tipoActualizacion == rechazar){
				solicitudCredito.setComentarioEjecutivo(comentarioRechazo);
			}			
			else  {
				solicitudCredito.setComentarioEjecutivo(comentarioEjec);
			}
			
			
		
	 
		solicitudCreditoFiraServicio.getSolicitudCreditoFiraDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;
		
		mensaje = solicitudCreditoFiraServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, solicitudCredito, Constantes.STRING_VACIO);
		
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SolicitudCreditoFiraServicio getSolicitudCreditoFiraServicio() {
		return solicitudCreditoFiraServicio;
	}

	public void setSolicitudCreditoFiraServicio(
			SolicitudCreditoFiraServicio solicitudCreditoFiraServicio) {
		this.solicitudCreditoFiraServicio = solicitudCreditoFiraServicio;
	}


}

