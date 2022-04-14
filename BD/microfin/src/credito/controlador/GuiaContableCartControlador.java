package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.servicio.GuiaContableCartServicio;

public class GuiaContableCartControlador extends SimpleFormController{
	
	//---------- Variables ------------------------------------------------------------------------

	GuiaContableCartServicio guiaContableCartServicio = null;
	
	public GuiaContableCartControlador(){
		setCommandClass(Object.class);
		setCommandName("Cartera");
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		//Establecemos el Parametro de Auditoria del Nombre del Programa 
		guiaContableCartServicio.getSubctaFondeadorCartDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;
		mensaje = guiaContableCartServicio.grabaTransaccion(request);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	
	}
	
	
	//------------------ Geters y Seters ------------------------------------------------------	

	public GuiaContableCartServicio getGuiaContableCartServicio() {
		return guiaContableCartServicio;
	}


	public void setGuiaContableCartServicio(
			GuiaContableCartServicio guiaContableCartServicio) {
		this.guiaContableCartServicio = guiaContableCartServicio;
	}
	
	
	
	
	

}
