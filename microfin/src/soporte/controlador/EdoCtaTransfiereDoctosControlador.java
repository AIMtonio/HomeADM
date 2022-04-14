package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.EdoCtaEnvioCorreoBean;
import soporte.servicio.EdoCtaEnvioCorreoServicio;

public class EdoCtaTransfiereDoctosControlador extends SimpleFormController {
	EdoCtaEnvioCorreoServicio edoCtaEnvioCorreoServicio;

	public EdoCtaTransfiereDoctosControlador() {
		setCommandClass(EdoCtaEnvioCorreoBean.class);
 		setCommandName("edoCtaEnvioCorreoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {	
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		int anioMes =(request.getParameter("anioMes")!=null)?
						Integer.parseInt(request.getParameter("anioMes")):0;
				
		EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean = (EdoCtaEnvioCorreoBean) command;
		edoCtaEnvioCorreoBean.setAnioMes("" + anioMes);
		
		MensajeTransaccionBean mensaje = null;
		mensaje = edoCtaEnvioCorreoServicio.grabaTransaccion(tipoTransaccion, edoCtaEnvioCorreoBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public EdoCtaEnvioCorreoServicio getEdoCtaEnvioCorreoServicio() {
		return edoCtaEnvioCorreoServicio;
	}

	public void setEdoCtaEnvioCorreoServicio(
			EdoCtaEnvioCorreoServicio edoCtaEnvioCorreoServicio) {
		this.edoCtaEnvioCorreoServicio = edoCtaEnvioCorreoServicio;
	}
}
