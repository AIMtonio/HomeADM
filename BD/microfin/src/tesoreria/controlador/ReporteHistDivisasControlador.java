package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.DivisasBean;

public class ReporteHistDivisasControlador extends SimpleFormController {
	
	public ReporteHistDivisasControlador() {
		setCommandClass(DivisasBean.class);
		setCommandName("divisas");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		DivisasBean bean = (DivisasBean) command;
		
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	
}
