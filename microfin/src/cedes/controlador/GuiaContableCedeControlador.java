package cedes.controlador;

import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.servicio.GuiaContableCedeServicio;

public class GuiaContableCedeControlador extends SimpleFormController{
	
	GuiaContableCedeServicio guiaContableCedeServicio = null;
	
	
	public GuiaContableCedeControlador(){
		setCommandClass(Object.class);
		setCommandName("GuiaContable");
	}

	
	protected ModelAndView onSubmit(HttpServletRequest request,	HttpServletResponse response, Object command,BindException errors) throws Exception {
		
		guiaContableCedeServicio.getSubCtaTiProCedeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null; 		
		mensaje = guiaContableCedeServicio.grabaTransaccion(request);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	public GuiaContableCedeServicio getGuiaContableCedeServicio() {
		return guiaContableCedeServicio;
	}


	public void setGuiaContableCedeServicio(
			GuiaContableCedeServicio guiaContableCedeServicio) {
		this.guiaContableCedeServicio = guiaContableCedeServicio;
	}

 
}
