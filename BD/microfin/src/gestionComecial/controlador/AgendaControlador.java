package gestionComecial.controlador;

import gestionComecial.bean.AgendaBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class AgendaControlador extends SimpleFormController {
	
	public AgendaControlador(){
		setCommandClass(AgendaBean.class);
		setCommandName("agendaBean");
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
		return null;
	}

}
