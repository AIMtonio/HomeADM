package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.RespaldoPagoCreditoBean;
import credito.servicio.RespaldoPagoCreditoServicio;

public class RespaldoPagoCreditoControlador extends SimpleFormController{
	
	RespaldoPagoCreditoServicio respaldoPagoCreditoServicio = null;
	
	public RespaldoPagoCreditoControlador() {
		setCommandClass(RespaldoPagoCreditoBean.class);
		setCommandName("respaldoPagoCredito");
	} 
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,							
			BindException errors) throws Exception {
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
				
 		RespaldoPagoCreditoBean respaldoPagoCreditoBean = (RespaldoPagoCreditoBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = respaldoPagoCreditoServicio.grabaTransaccion(tipoTransaccion, respaldoPagoCreditoBean,request);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RespaldoPagoCreditoServicio getRespaldoPagoCreditoServicio() {
		return respaldoPagoCreditoServicio;
	}

	public void setRespaldoPagoCreditoServicio(
			RespaldoPagoCreditoServicio respaldoPagoCreditoServicio) {
		this.respaldoPagoCreditoServicio = respaldoPagoCreditoServicio;
	}
				
		
}
