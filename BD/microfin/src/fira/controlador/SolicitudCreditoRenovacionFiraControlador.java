
package fira.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.SolicitudCreditoFiraBean;
import fira.servicio.SolicitudCreditoFiraServicio;

public class SolicitudCreditoRenovacionFiraControlador extends SimpleFormController {

	
	SolicitudCreditoFiraServicio solicitudCreditoFiraServicio  = null;

	public SolicitudCreditoRenovacionFiraControlador(){
		setCommandClass(SolicitudCreditoFiraBean.class);
		setCommandName("solicitudCreditoFiraBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		SolicitudCreditoFiraBean solicitudCreditoFiraBean = (SolicitudCreditoFiraBean) command;
		
		solicitudCreditoFiraServicio.getSolicitudCreditoFiraDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
				Integer.parseInt(request.getParameter("tipoActualizacion")):
				0;		
						
		if (tipoActualizacion == SolicitudCreditoFiraServicio.Enum_Act_SolCredito.liberar) {				 											
			String comentario = request.getParameter("comentario");
			String comentarioEjecutivo = request.getParameter("comentarioEjecutivo");
			
			solicitudCreditoFiraBean.setComentarioEjecutivo(comentario);			

			
			}
				
		String detalleFirmasAutoriza = request.getParameter("detalleFirmasAutoriza");
		
		MensajeTransaccionBean mensaje = null;
		

		mensaje = solicitudCreditoFiraServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion,solicitudCreditoFiraBean,detalleFirmasAutoriza);
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
