package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.CuentasAhoBean;

public class Regulatorio0815VistaControlador extends SimpleFormController {

	String successView = null;		

 	public Regulatorio0815VistaControlador(){
 		setCommandClass(CuentasAhoBean.class);
 		setCommandName("cuentasAhoBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
	

}
