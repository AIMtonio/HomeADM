package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.SucursalesBean;
import cliente.servicio.SucursalesServicio;

public class SucursalesControlador  extends SimpleFormController{

	SucursalesServicio sucursalesServicio = null;
	
	public SucursalesControlador() {
		setCommandClass(SucursalesBean.class);
		setCommandName("sucursal");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		SucursalesBean sucursal = (SucursalesBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
	
		
		MensajeTransaccionBean mensaje = null;
		mensaje = sucursalesServicio.grabaTransaccion(tipoTransaccion,sucursal);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setSucursalesServicio(SucursalesServicio sucursalesServicio) {
		this.sucursalesServicio = sucursalesServicio;
	}
	
	
}
