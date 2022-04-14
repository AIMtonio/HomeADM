package originacion.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.Utileria;
import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio;

public class CiclosProcesaClienteGrupalControlador extends AbstractCommandController{
	SolicitudCreditoServicio solicitudCreditoServicio = null;
	
	public CiclosProcesaClienteGrupalControlador() {
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("solicitudCredito");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
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
		MensajeTransaccionBean mensajeTransaccionBean = null;
		
		//Peticion de transaccion de la propuesta
		mensajeTransaccionBean = solicitudCreditoServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion,solicitudCredito,Constantes.STRING_VACIO);
		//Se convierte la respuesta en formato JSON
		Utileria.respuestaJsonTransaccion(mensajeTransaccionBean, response);
		
		return null;
	}

	public SolicitudCreditoServicio getSolicitudCreditoServicio() {
		return solicitudCreditoServicio;
	}

	public void setSolicitudCreditoServicio(SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}
}