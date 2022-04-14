package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.RequisicionGastosBean;
import tesoreria.servicio.RequisicionGastosServicio;

public class RequisicionGastosControlador extends SimpleFormController {
	
	RequisicionGastosServicio requisicionGastosServicio = null;
	
	public RequisicionGastosControlador(){
		setCommandClass(RequisicionGastosBean.class);
		setCommandName("requisicionGastosBean");
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, 
									HttpServletResponse response, 
									Object command, 
									BindException errors) throws Exception{
		
		RequisicionGastosBean requisicionGastosBean = (RequisicionGastosBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = requisicionGastosServicio.grabaTransaccion(tipoTransaccion, requisicionGastosBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);	
	}
	
	public void setRequisicionGastosServicio(RequisicionGastosServicio requisicionGastosServicio) {
		this.requisicionGastosServicio = requisicionGastosServicio;
	}
	
	

}
