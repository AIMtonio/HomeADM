package credito.controlador;
   
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import general.bean.MensajeTransaccionBean;

public class OperacionBasicaUnidadControlador extends SimpleFormController {

 	public OperacionBasicaUnidadControlador(){
 		setCommandClass(CreditosBean.class);
 		setCommandName("operacionBasicaUnidadBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		CreditosBean creditosBean = (CreditosBean) command;

		MensajeTransaccionBean mensaje = null;
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		
 		}
}
