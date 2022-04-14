package tesoreria.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.ConsolaBean;
import tesoreria.servicio.ConsolaServicio;

public class ConsolaControlador extends SimpleFormController {
	
	public ConsolaControlador(){
		setCommandClass(ConsolaBean.class);
		setCommandName("consolaBean");
	}
	
	ConsolaServicio consolaServicio = null;
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		
		
		return null;
	}

	public void setConsolaServicio(ConsolaServicio consolaServicio) {
		this.consolaServicio = consolaServicio;
	}

}
