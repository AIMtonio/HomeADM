package arrendamiento.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import arrendamiento.bean.CargoAbonoArrendaBean;
import arrendamiento.servicio.MovimientosCargoAbonoArrendaServicio;

public class CargosArrendamientoControlador extends SimpleFormController {

	MovimientosCargoAbonoArrendaServicio movimientosCargoAbonoArrendaServicio = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public CargosArrendamientoControlador() {
		setCommandClass(CargoAbonoArrendaBean.class);
		setCommandName("cargoAbonoArrendaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		// Servicio
		movimientosCargoAbonoArrendaServicio.getMovimientosCargoAbonoArrendaDAO().getParametrosAuditoriaBean().setNombrePrograma(
				request.getRequestURI().toString());
		// mensaje
		MensajeTransaccionBean mensaje = null;
		// Bean 
		CargoAbonoArrendaBean cargoAbonoArrendaBean = (CargoAbonoArrendaBean) command;
		// tipo de transaccion
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer
				.parseInt(request.getParameter("tipoTransaccion")) : 0;

		mensaje = movimientosCargoAbonoArrendaServicio.grabaTransaccionMovsCA(tipoTransaccion, cargoAbonoArrendaBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	// Getter y Setter
	public MovimientosCargoAbonoArrendaServicio getMovimientosCargoAbonoArrendaServicio() {
		return movimientosCargoAbonoArrendaServicio;
	}

	public void setMovimientosCargoAbonoArrendaServicio(
			MovimientosCargoAbonoArrendaServicio movimientosCargoAbonoArrendaServicio) {
		this.movimientosCargoAbonoArrendaServicio = movimientosCargoAbonoArrendaServicio;
	}
	
	

}
