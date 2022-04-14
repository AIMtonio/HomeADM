package regulatorios.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RepRegCatalogoMinimoBean;


public class RepRegCatalogoMinimoControlador extends SimpleFormController{
	
	public RepRegCatalogoMinimoControlador() {
		setCommandClass(RepRegCatalogoMinimoBean.class);
		setCommandName("repRegCatalogoMinimoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
	
		RepRegCatalogoMinimoBean repRegCatalogoMinimoBean= (RepRegCatalogoMinimoBean) command;
		MensajeTransaccionBean mensaje = null;
			
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}	

}
