package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.PromotoresBean;
import cliente.servicio.PromotoresServicio;

public class PromotoresControlador extends SimpleFormController {
	
	PromotoresServicio promotoresServicio = null;
	
	public PromotoresControlador() {
		setCommandClass(PromotoresBean.class);
		setCommandName("promotor");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		PromotoresBean promotor = (PromotoresBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		//int tipoTransaccion =1;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = promotoresServicio.grabaTransaccion(tipoTransaccion,promotor);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setPromotoresServicio(PromotoresServicio promotoresServicio) {
		this.promotoresServicio = promotoresServicio;
	}
	
	
}
