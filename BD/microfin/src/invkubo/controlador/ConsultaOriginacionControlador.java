package invkubo.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio;

public class ConsultaOriginacionControlador extends SimpleFormController {

	SolicitudCreditoServicio solicitudCreditoServicio = null;

	public ConsultaOriginacionControlador(){
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("solicitudCreditos");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		SolicitudCreditoBean solicitudCreditoBean = (SolicitudCreditoBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
								
		MensajeTransaccionBean mensaje = null;
		// mensaje = solicitudCreditoServicio.grabaTransaccion(tipoTransaccion,solicitudCreditoBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setSolicitudCreditoServicio(
			SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}

} 
