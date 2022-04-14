package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.RepRenovacionesBean;


@SuppressWarnings("deprecation")
public class RepRenovacionesVistaControlador extends SimpleFormController{
	
	public RepRenovacionesVistaControlador() {	
		setCommandClass(RepRenovacionesBean.class);
		setCommandName("repRenovaciones");	
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, 
						HttpServletResponse response, Object command,
						BindException errors) 
	throws Exception {	
		
		MensajeTransaccionBean mensaje = null;		
												
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	


}
