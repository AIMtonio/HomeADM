package fondeador.controlador;

import general.bean.MensajeTransaccionBean;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CarCambioFondeoBitBean;
import credito.servicio.CarCambioFondeoBitServicio;
import credito.servicio.CarCreditoSuspendidoServicio;


@SuppressWarnings("deprecation")
public class CambioFuenteFondeoMasivoControlador extends SimpleFormController {
	CarCambioFondeoBitServicio carCambioFondeoBitServicio = null;
	
	public CambioFuenteFondeoMasivoControlador() {
		setCommandClass(CarCambioFondeoBitBean.class);
		setCommandName("carCambioFondeoBitBean");
		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		
		CarCambioFondeoBitBean carCambioFondeoBitBean = (CarCambioFondeoBitBean)command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)? Integer.parseInt(request.getParameter("tipoActualizacion")): 0;
		
 		MensajeTransaccionBean mensaje = null;
 		mensaje = carCambioFondeoBitServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, carCambioFondeoBitBean);
 		
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
