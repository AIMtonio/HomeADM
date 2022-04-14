package inversiones.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import inversiones.servicio.GuiaContableInverServicio;

public class GuiaContableInverControlador extends SimpleFormController {

	GuiaContableInverServicio guiaContableInverServicio = null;
	
	public GuiaContableInverControlador(){
		setCommandClass(Object.class);
		setCommandName("GuiaContable");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

	MensajeTransaccionBean mensaje = null; 		
	
	mensaje = guiaContableInverServicio.grabaTransaccion(request);

	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public void setGuiaContableInverServicio(
			GuiaContableInverServicio guiaContableInverServicio) {
		this.guiaContableInverServicio = guiaContableInverServicio;
	}
	


 } 


