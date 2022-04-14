package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio;

public class SolicitudCreditoControlador extends SimpleFormController {

	
	SolicitudCreditoServicio solicitudCreditoServicio  = null;

	public SolicitudCreditoControlador(){
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("solicitudCreditoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		SolicitudCreditoBean solicitudCredito = (SolicitudCreditoBean) command;
		solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion") != null) ? Integer.parseInt(request.getParameter("tipoActualizacion")) : 0;

		if (tipoActualizacion == SolicitudCreditoServicio.Enum_Act_SolCredito.liberar) {
			String comentario = request.getParameter("comentario");
			solicitudCredito.setComentarioEjecutivo(comentario);
		}

		String detalleFirmasAutoriza = request.getParameter("detalleFirmasAutoriza");
		MensajeTransaccionBean mensaje = null;

		mensaje = solicitudCreditoServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, solicitudCredito, detalleFirmasAutoriza);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public void setSolicitudCreditoServicio(
			SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}

	
	
} 
