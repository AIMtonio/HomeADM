package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio;



public class FlujoIndividualControlador  extends SimpleFormController {
	
	SolicitudCreditoServicio solicitudCreditoServicio = null;
	int liberaGrupal =6;
	int rechazo =4;
	int agregaComentario= 7 ;
	
	public FlujoIndividualControlador() {
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("solicitudCredito");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		SolicitudCreditoBean solicitudCredito = null;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
			
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						Integer.parseInt(request.getParameter("tipoActualizacion")):
						0;		
	

	String  solicitudCreditoID = (request.getParameter("numSolicitud")!=null)? request.getParameter("numSolicitud"):"0";		
			String  comentarioEjec = (request.getParameter("nuevosComents")!=null)? request.getParameter("nuevosComents"):"";
			String  comentarioRechazo = (request.getParameter("motivoRechazo")!=null)? request.getParameter("motivoRechazo"):"";
			
			solicitudCredito = new SolicitudCreditoBean();
			solicitudCredito.setSolicitudCreditoID(solicitudCreditoID);
			if(tipoActualizacion == rechazo){
				solicitudCredito.setComentarioEjecutivo(comentarioRechazo);
			}			
			else  {
				solicitudCredito.setComentarioEjecutivo(comentarioEjec);
			}
			
			
		
	 
		solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;
		
		mensaje = solicitudCreditoServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion,solicitudCredito,Constantes.STRING_VACIO);
		
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SolicitudCreditoServicio getSolicitudCreditoServicio() {
		return solicitudCreditoServicio;
	}

	public void setSolicitudCreditoServicio(
			SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}

	
}

