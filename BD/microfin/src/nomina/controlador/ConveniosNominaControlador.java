package nomina.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.ConvenioNominaBean;
import nomina.servicio.ConveniosNominaServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class ConveniosNominaControlador extends SimpleFormController {
	ConveniosNominaServicio conveniosNominaServicio = null;

	public ConveniosNominaControlador() {
		// TODO Auto-generated constructor stub
		setCommandClass(ConvenioNominaBean.class);
		setCommandName("convenioNominaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		ConvenioNominaBean convenioNominaBean = (ConvenioNominaBean) command;

		int tipoTransaccion = (request.getParameter("tipoTransaccionConv") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccionConv")) : 0;

		MensajeTransaccionBean mensaje = null;

		mensaje = conveniosNominaServicio.grabaTransaccion(tipoTransaccion, convenioNominaBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ConveniosNominaServicio getConveniosNominaServicio() {
		return conveniosNominaServicio;
	}

	public void setConveniosNominaServicio(
			ConveniosNominaServicio conveniosNominaServicio) {
		this.conveniosNominaServicio = conveniosNominaServicio;
	}
}
