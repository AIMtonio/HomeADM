package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.servicio.GuiaContableInverBancariaServicio;

public class GuiaContableInverBancariaControlador extends SimpleFormController{

	GuiaContableInverBancariaServicio guiaContableInverBancariaServicio = null;
	
	public GuiaContableInverBancariaControlador(){
		setCommandClass(Object.class);
		setCommandName("guiaContableInvBancaria");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {

		MensajeTransaccionBean mensaje = null; 		
		mensaje = guiaContableInverBancariaServicio.grabaTransaccion(request);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public GuiaContableInverBancariaServicio getGuiaContableInverBancariaServicio() {
		return guiaContableInverBancariaServicio;
	}

	public void setGuiaContableInverBancariaServicio(
			GuiaContableInverBancariaServicio guiaContableInverBancariaServicio) {
		this.guiaContableInverBancariaServicio = guiaContableInverBancariaServicio;
	}

}
