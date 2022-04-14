package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import soporte.bean.EdoCtaEnvioCorreoBean;
import soporte.servicio.EdoCtaEnvioCorreoServicio;

public class EdoCtaImportaEnvioCorreoControlador extends SimpleFormController {
	EdoCtaEnvioCorreoServicio edoCtaEnvioCorreoServicio;

	public EdoCtaImportaEnvioCorreoControlador(){
		setCommandClass(EdoCtaEnvioCorreoBean.class);
 		setCommandName("edoCtaEnvioCorreoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		System.out.println("EdoCtaImportaEnvioCorreosControlador.onSubmit()");		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
				
		EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean = (EdoCtaEnvioCorreoBean) command;
		edoCtaEnvioCorreoBean.setAnioMes(request.getParameter("anioMes"));
		
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
