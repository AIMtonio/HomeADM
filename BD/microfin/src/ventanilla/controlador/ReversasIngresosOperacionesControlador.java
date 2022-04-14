package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.bean.ReversasOperBean;
import ventanilla.servicio.IngresosOperacionesServicio;

public class ReversasIngresosOperacionesControlador extends SimpleFormController {
	IngresosOperacionesServicio	ingresosOperacionesServicio	= null;
	protected final Logger		loggerSAFI					= Logger.getLogger("SAFI");

	public ReversasIngresosOperacionesControlador() {
	setCommandClass(ReversasOperBean.class);
	setCommandName("reversas");
}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		ReversasOperBean ingresosOperacionesBean = (ReversasOperBean) command;
	ingresosOperacionesServicio.getIngresosOperacionesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
							
	MensajeTransaccionBean mensaje = null;
		mensaje = ingresosOperacionesServicio.grabaTransaccionReversa(tipoTransaccion, request, ingresosOperacionesBean);

	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
}

//--------------setter------------
	public void setIngresosOperacionesServicio(IngresosOperacionesServicio ingresosOperacionesServicio) {
		this.ingresosOperacionesServicio = ingresosOperacionesServicio;
	}
}
