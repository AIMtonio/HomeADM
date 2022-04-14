package originacion.controlador;


import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.CapacidadPagoBean;
import originacion.servicio.CapacidadPagoServicio;


public class RepCapacidadPagoControlador extends SimpleFormController {
	
	CapacidadPagoServicio capacidadPagoServicio = null;

	public RepCapacidadPagoControlador() {
		setCommandClass(CapacidadPagoBean.class);
		setCommandName("capacidadPagoBean");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		capacidadPagoServicio.getCapacidadPagoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		CapacidadPagoBean bean = (CapacidadPagoBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = capacidadPagoServicio.grabaTransaccion(tipoTransaccion,bean);
												
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CapacidadPagoServicio getCapacidadPagoServicio() {
		return capacidadPagoServicio;
	}

	public void setCapacidadPagoServicio(CapacidadPagoServicio capacidadPagoServicio) {
		this.capacidadPagoServicio = capacidadPagoServicio;
	}

}


