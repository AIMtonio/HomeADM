package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.ReferenciaClienteBean;
import originacion.servicio.ReferenciaClienteServicio;

public class ReferenciasCteControlador extends SimpleFormController {

	ReferenciaClienteServicio referenciaClienteServicio = null;

	public ReferenciasCteControlador() {
		setCommandClass(ReferenciaClienteBean.class);
		setCommandName("referenciasBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		MensajeTransaccionBean mensaje = null;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ReferenciaClienteServicio getReferenciaClienteServicio() {
		return referenciaClienteServicio;
	}

	public void setReferenciaClienteServicio(
			ReferenciaClienteServicio referenciaClienteServicio) {
		this.referenciaClienteServicio = referenciaClienteServicio;
	}

}
