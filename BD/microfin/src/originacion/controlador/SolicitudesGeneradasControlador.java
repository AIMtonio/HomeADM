package originacion.controlador;


import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio;


public class SolicitudesGeneradasControlador extends SimpleFormController {
	
	SolicitudCreditoServicio solicitudCreditoServicio = null;

	public SolicitudesGeneradasControlador() {
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("repsolicitudCredito");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		SolicitudCreditoBean bean = (SolicitudCreditoBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoServicio.grabaTransaccion(tipoTransaccion, tipoTransaccion, bean, "");
												
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


