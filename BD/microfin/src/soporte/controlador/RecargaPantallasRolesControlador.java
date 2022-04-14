package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.mvc.SimpleFormController;


public class RecargaPantallasRolesControlador  extends SimpleFormController{


	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			 HttpServletResponse response)
	throws Exception {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);
		mensaje.setDescripcion("Pantallas Activadas Correctamente");
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	
}