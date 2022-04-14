package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.ReimpresionTicketBean;
import ventanilla.servicio.ReimpresionTicketServicio;

public class ReimpresionTicketControlador extends SimpleFormController{
	ReimpresionTicketServicio reimpresionTicketServicio = null;
	
	public ReimpresionTicketControlador(){
		setCommandClass(ReimpresionTicketBean.class);
		setCommandName("reimpresionTicket");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception{
		
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
					
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ReimpresionTicketServicio getReimpresionTicketServicio() {
		return reimpresionTicketServicio;
	}
	public void setReimpresionTicketServicio(
			ReimpresionTicketServicio reimpresionTicketServicio) {
		this.reimpresionTicketServicio = reimpresionTicketServicio;
	}
}
