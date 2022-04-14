package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.SeguimientoPersonaListaBean;
import pld.bean.SeguimientoPersonaRepBean;

public class SeguimientoPersonaRepControlador extends SimpleFormController{
	
	
	public SeguimientoPersonaRepControlador() {
		setCommandClass(SeguimientoPersonaRepBean.class);
		setCommandName("seguimientoPersonaRepBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response, 
			Object command, BindException errors) throws Exception {
		SeguimientoPersonaListaBean bean = (SeguimientoPersonaListaBean) command;
	
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
}
