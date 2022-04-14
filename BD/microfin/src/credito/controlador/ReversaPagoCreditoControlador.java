package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.ReversaPagoCreditoBean;
import credito.servicio.ReversaPagoCreditoServicio;



public class ReversaPagoCreditoControlador extends SimpleFormController{
	
	ReversaPagoCreditoServicio reversaPagoCreditoServicio = null;

	public ReversaPagoCreditoControlador(){
		setCommandClass(ReversaPagoCreditoBean.class);
		setCommandName("reversaPagoCreditoBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
					HttpServletResponse response,
					Object command,
					BindException errors) throws Exception{
		ReversaPagoCreditoBean reversaPagoBean = (ReversaPagoCreditoBean) command;
		reversaPagoCreditoServicio.getReversaPagoCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
				
		MensajeTransaccionBean mensaje = null;
		mensaje = reversaPagoCreditoServicio.grabaTransaccion(reversaPagoBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	
	public ReversaPagoCreditoServicio getReversaPagoCreditoServicio() {
		return reversaPagoCreditoServicio;
	}

	public void setReversaPagoCreditoServicio(
			ReversaPagoCreditoServicio reversaPagoCreditoServicio) {
		this.reversaPagoCreditoServicio = reversaPagoCreditoServicio;
	}
	
	
}
