package fira.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.CatReportesFIRABean;
import general.bean.MensajeTransaccionBean;

public class CatReportesFIRAControlador extends SimpleFormController {
	
	public CatReportesFIRAControlador(){
		setCommandClass(CatReportesFIRABean.class);
		setCommandName("catReportesFIRABean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		CatReportesFIRABean catReportesFIRABean = (CatReportesFIRABean) command;
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

}