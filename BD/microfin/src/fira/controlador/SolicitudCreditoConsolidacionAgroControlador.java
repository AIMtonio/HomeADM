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


public class SolicitudCreditoConsolidacionAgroControlador extends SimpleFormController {

	SolicitudCreditoServicio solicitudCreditoServicio = null;

	public SolicitudCreditoConsolidacionAgroControlador() {
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("SolicitudCreditoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		SolicitudCreditoBean solicitudCreditoBean = (SolicitudCreditoBean) command;
		solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		int tipoActualizacion = Utileria.convierteEntero(request.getParameter("tipoActualizacion"));
		String detalleFirmasAutoriza = request.getParameter("detalleFirmasAutoriza");

		if( tipoActualizacion == SolicitudCreditoServicio.Enum_Tra_SolCredito.alta || 
			tipoActualizacion == SolicitudCreditoServicio.Enum_Tra_SolCredito.altaConsolidacionAgro) {
			String comentario = request.getParameter("comentario");
			solicitudCreditoBean.setComentarioEjecutivo(comentario);
		}
		
		MensajeTransaccionBean mensajeTransaccionBean = null;
		mensajeTransaccionBean = solicitudCreditoServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, solicitudCreditoBean, detalleFirmasAutoriza);
		return new ModelAndView(getSuccessView(), "mensaje", mensajeTransaccionBean);
	}

	
	public SolicitudCreditoServicio getSolicitudCreditoServicio() {
		return solicitudCreditoServicio;
	}

	public void setSolicitudCreditoServicio(
			SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}
}
