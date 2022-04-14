package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosPorSucursalServicio;

public class CreditosPorSucursalControlador extends SimpleFormController{
	CreditosPorSucursalServicio creditosPorSucursalServicio = null;
	
	public CreditosPorSucursalControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("creditosSucursal");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosPorSucursalServicio getCreditosPorSucursalServicio() {
		return creditosPorSucursalServicio;
	}
	public void setCreditosPorSucursalServicio(
			CreditosPorSucursalServicio creditosPorSucursalServicio) {
		this.creditosPorSucursalServicio = creditosPorSucursalServicio;
	}

}
