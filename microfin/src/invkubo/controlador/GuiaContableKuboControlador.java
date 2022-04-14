package invkubo.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import invkubo.servicio.GuiaContableKuboServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class GuiaContableKuboControlador extends SimpleFormController{
	
	//---------- Variables ------------------------------------------------------------------------
	
	GuiaContableKuboServicio guiaContableKuboServicio = null;

	public GuiaContableKuboControlador() {
		setCommandClass(Object.class);
		setCommandName("Kubo");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		MensajeTransaccionBean mensaje = null; 	
		
		mensaje = guiaContableKuboServicio.grabaTransaccion(request);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	 	
	}

	
	//------------------ Geters y Seters ------------------------------------------------------	

	public GuiaContableKuboServicio getGuiaContableKuboServicio() {
		return guiaContableKuboServicio;
	}

	public void setGuiaContableKuboServicio(
			GuiaContableKuboServicio guiaContableKuboServicio) {
		this.guiaContableKuboServicio = guiaContableKuboServicio;
	}

	
}
