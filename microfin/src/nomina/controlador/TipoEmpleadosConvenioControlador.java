package nomina.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import nomina.bean.TipoEmpleadosConvenioBean;
import nomina.servicio.TipoEmpleadosConvenioServicio;;

public class TipoEmpleadosConvenioControlador extends SimpleFormController  {
	
	TipoEmpleadosConvenioServicio tipoEmpleadosConvenioServicio = null;

	public TipoEmpleadosConvenioControlador() {
		// TODO Auto-generated constructor stub
		setCommandClass(TipoEmpleadosConvenioBean.class);
		setCommandName("tipoEmpleadosConvenioBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		TipoEmpleadosConvenioBean tipoEmpleadosConvenioBean = (TipoEmpleadosConvenioBean) command;
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
		tipoEmpleadosConvenioServicio.getTipoEmpleadosConvenioDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;

		mensaje = tipoEmpleadosConvenioServicio.grabaTransaccion(tipoTransaccion, tipoEmpleadosConvenioBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TipoEmpleadosConvenioServicio getTipoEmpleadosConvenioServicio() {
		return tipoEmpleadosConvenioServicio;
	}

	public void setTipoEmpleadosConvenioServicio(
			TipoEmpleadosConvenioServicio tipoEmpleadosConvenioServicio) {
		this.tipoEmpleadosConvenioServicio = tipoEmpleadosConvenioServicio;
	}

	
}
