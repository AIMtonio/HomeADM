package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import aportaciones.servicio.GuiaContableAportacionServicio;

public class GuiaContableAportacionControlador extends SimpleFormController{
	
	GuiaContableAportacionServicio guiaContableAportacionServicio = null;
	
	
	public GuiaContableAportacionControlador(){
		setCommandClass(Object.class);
		setCommandName("GuiaContable");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,	HttpServletResponse response, Object command,BindException errors) throws Exception {
		
		guiaContableAportacionServicio.getSubCtaTiProAportacionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null; 		
		mensaje = guiaContableAportacionServicio.grabaTransaccion(request);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public GuiaContableAportacionServicio getGuiaContableAportacionServicio() {
		return guiaContableAportacionServicio;
	}

	public void setGuiaContableAportacionServicio(
			GuiaContableAportacionServicio guiaContableAportacionServicio) {
		this.guiaContableAportacionServicio = guiaContableAportacionServicio;
	}
	
}
