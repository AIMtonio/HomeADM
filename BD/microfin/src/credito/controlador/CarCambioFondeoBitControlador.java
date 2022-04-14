package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CarCambioFondeoBitBean;
import credito.servicio.CarCambioFondeoBitServicio;

public class CarCambioFondeoBitControlador  extends SimpleFormController{
	CarCambioFondeoBitServicio carCambioFondeoBitServicio = null;
	
	public CarCambioFondeoBitControlador(){
		setCommandClass(CarCambioFondeoBitBean.class);
		setCommandName("carCambioFondeoBitBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		CarCambioFondeoBitBean carCambioFondeoBit = (CarCambioFondeoBitBean) command;
		System.out.println("cambio Fomdeo creditoID "+carCambioFondeoBit.getCreditoID());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;			
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)? Integer.parseInt(request.getParameter("tipoActualizacion")): 0;
			
		MensajeTransaccionBean mensaje = null;
		mensaje = carCambioFondeoBitServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, carCambioFondeoBit);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CarCambioFondeoBitServicio getCarCambioFondeoBitServicio() {
		return carCambioFondeoBitServicio;
	}

	public void setCarCambioFondeoBitServicio(
			CarCambioFondeoBitServicio carCambioFondeoBitServicio) {
		this.carCambioFondeoBitServicio = carCambioFondeoBitServicio;
	}

}
