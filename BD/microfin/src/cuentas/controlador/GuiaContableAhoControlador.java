package cuentas.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.servicio.GuiaContableAhoServicio;

public class GuiaContableAhoControlador extends SimpleFormController {

	GuiaContableAhoServicio guiaContableAhoServicio = null;

 	public GuiaContableAhoControlador(){
 		setCommandClass(Object.class);
 		setCommandName("GuiaContable");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		MensajeTransaccionBean mensaje = null; 		
 		
 		mensaje = guiaContableAhoServicio.grabaTransaccion(request);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public void setGuiaContableAhoServicio(
			GuiaContableAhoServicio guiaContableAhoServicio) {
		this.guiaContableAhoServicio = guiaContableAhoServicio;
	}
 	
 } 


