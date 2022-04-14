package cuentas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.RepSeguimientoFolioJPMovilBean;


public class RepSeguimientoFolioJPMovilControlador extends SimpleFormController{
	
	public RepSeguimientoFolioJPMovilControlador() {
		setCommandClass(RepSeguimientoFolioJPMovilBean.class);
		setCommandName("repSeguimientoFolioJPMovilBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, 
			HttpServletResponse response, Object command, 
			BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
}
