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



public class SolicitudCreditoGrupalActualizaControlador  extends SimpleFormController {
	SolicitudCreditoServicio solicitudCreditoServicio = null;
	public SolicitudCreditoGrupalActualizaControlador() {
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("solicitudCredito");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		SolicitudCreditoBean solicitudCredito = (SolicitudCreditoBean) command;
		solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						Integer.parseInt(request.getParameter("tipoActualizacion")):
						0;		
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

