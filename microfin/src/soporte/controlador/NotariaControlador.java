package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.NotariaBean;
import soporte.servicio.NotariaServicio;

@SuppressWarnings("deprecation")
public class NotariaControlador extends SimpleFormController {

	NotariaServicio notariaServicio = null;
	
	public NotariaControlador() {
		setCommandClass(NotariaBean.class);
		setCommandName("notaria");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		NotariaBean notaria = (NotariaBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = notariaServicio.grabaTransaccion(tipoTransaccion, notaria);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setNotariaServicio(NotariaServicio notariaServicio) {
		this.notariaServicio = notariaServicio;
	}
		
}
