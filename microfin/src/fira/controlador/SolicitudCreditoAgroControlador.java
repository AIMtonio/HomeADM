package fira.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio;

public class SolicitudCreditoAgroControlador extends SimpleFormController {

	SolicitudCreditoServicio solicitudCreditoServicio = null;

	public SolicitudCreditoAgroControlador() {
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("SolicitudCreditoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		SolicitudCreditoBean solicitudCredito = (SolicitudCreditoBean) command;
		solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		int tipoActualizacion = Utileria.convierteEntero(request.getParameter("tipoActualizacion"));

		if (tipoActualizacion == 1) {
			String comentario = request.getParameter("comentario");
			solicitudCredito.setComentarioEjecutivo(comentario);
		}
		String detalleFirmasAutoriza = request.getParameter("detalleFirmasAutoriza");
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, solicitudCredito, detalleFirmasAutoriza);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SolicitudCreditoServicio getSolicitudCreditoServicio() {
		return solicitudCreditoServicio;
	}

	public void setSolicitudCreditoServicio(SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}

}
