package credito.controlador;


import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CarCreditoSuspendidoBean;
import credito.servicio.CarCreditoSuspendidoServicio;

public class CarCreditoSuspendidoControlador  extends SimpleFormController{
	CarCreditoSuspendidoServicio carCreditoSuspendidoServicio = null;
	
	public CarCreditoSuspendidoControlador(){
		setCommandClass(CarCreditoSuspendidoBean.class);
		setCommandName("carCreditoSuspendidoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,Object command,
			BindException errors) throws Exception {
		
		CarCreditoSuspendidoBean carCreditoSuspendido = (CarCreditoSuspendidoBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;			
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)? Integer.parseInt(request.getParameter("tipoActualizacion")): 0;
			
		MensajeTransaccionBean mensaje = null;
		mensaje = carCreditoSuspendidoServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, carCreditoSuspendido);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	
	}

	public CarCreditoSuspendidoServicio getCarCreditoSuspendidoServicio() {
		return carCreditoSuspendidoServicio;
	}

	public void setCarCreditoSuspendidoServicio(
			CarCreditoSuspendidoServicio carCreditoSuspendidoServicio) {
		this.carCreditoSuspendidoServicio = carCreditoSuspendidoServicio;
	}

	
}
