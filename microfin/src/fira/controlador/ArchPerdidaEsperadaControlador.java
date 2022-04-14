package fira.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.ArchPerdidaEsperadaBean;
import general.bean.MensajeTransaccionBean;

public class ArchPerdidaEsperadaControlador extends SimpleFormController {
	
	public ArchPerdidaEsperadaControlador() {
		setCommandClass(ArchPerdidaEsperadaBean.class);
		setCommandName("archPerdidaEsperadaBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		ArchPerdidaEsperadaBean archPerdidaEsperadaBean = (ArchPerdidaEsperadaBean) command;
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
}