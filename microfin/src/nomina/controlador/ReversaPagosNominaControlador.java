package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.PagoNominaBean;
import nomina.bean.ReversaPagoNominaBean;
import nomina.servicio.ReversaPagoNominaServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class ReversaPagosNominaControlador extends SimpleFormController{
	ReversaPagoNominaServicio reversaPagoNominaServicio = null;

	public ReversaPagosNominaControlador() {
		setCommandClass(ReversaPagoNominaBean.class);
		setCommandName("reversaPagosNomina");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
			
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	
				ReversaPagoNominaBean reversaPagoNominaBean = (ReversaPagoNominaBean) command;
		MensajeTransaccionBean mensaje = null;
	
		mensaje = reversaPagoNominaServicio.grabaTransaccion(tipoTransaccion,reversaPagoNominaBean);
	
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}
	
	public ReversaPagoNominaServicio getReversaPagoNominaServicio() {
		return reversaPagoNominaServicio;
	}
	public void setReversaPagoNominaServicio(
			ReversaPagoNominaServicio reversaPagoNominaServicio) {
		this.reversaPagoNominaServicio = reversaPagoNominaServicio;
	}
	
}
