package nomina.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.EmpleadoNominaBean;
import nomina.servicio.NominaEmpleadosServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class NominaEmpleadosControlador extends SimpleFormController {
	NominaEmpleadosServicio nominaEmpleadosServicio = null;

	public NominaEmpleadosControlador() {
		// TODO Auto-generated constructor stub
		setCommandClass(EmpleadoNominaBean.class);
		setCommandName("empleadoNominaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		EmpleadoNominaBean empleadoNominaBean = (EmpleadoNominaBean) command;

		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : Constantes.ENTERO_CERO;

		int tipoActualizacion = (request.getParameter("tipoActualizacion") != null) ? Utileria.convierteEntero(request.getParameter("tipoActualizacion")) : Constantes.ENTERO_CERO;

		MensajeTransaccionBean mensaje = null;

		mensaje = nominaEmpleadosServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, empleadoNominaBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public NominaEmpleadosServicio getNominaEmpleadosServicio() {
		return nominaEmpleadosServicio;
	}

	public void setNominaEmpleadosServicio(
			NominaEmpleadosServicio nominaEmpleadosServicio) {
		this.nominaEmpleadosServicio = nominaEmpleadosServicio;
	}
}
