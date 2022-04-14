package inversiones.controlador;

import inversiones.bean.InversionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class ConsultaInversionesCteControlador extends SimpleFormController{
	public ConsultaInversionesCteControlador(){
 		setCommandClass(InversionBean.class);
 		setCommandName("inversionBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 	}
	
}
