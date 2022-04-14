package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;

public class ActaComiteControlador extends SimpleFormController{
	public ActaComiteControlador(){
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,							
			BindException errors) throws Exception {


		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		CreditosBean creditos = (CreditosBean) command;
		MensajeTransaccionBean mensaje = null;
		//	mensaje = creditosServicio.grabaTransaccion(tipoTransaccion, creditos);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
}
