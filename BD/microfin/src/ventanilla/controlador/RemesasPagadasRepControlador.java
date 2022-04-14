package ventanilla.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import ventanilla.bean.RemesasPagadasRepBean;
import ventanilla.servicio.RemesasPagadasRepServicio;

public class RemesasPagadasRepControlador extends SimpleFormController {
	
	private RemesasPagadasRepServicio remesasPagadasRepServicio;
	
	public RemesasPagadasRepControlador() {
		setCommandClass(RemesasPagadasRepBean.class);
		setCommandName("remesasPagadasRepBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		MensajeTransaccionBean mensaje = null;
		RemesasPagadasRepBean remesasPagadasRepBean = (RemesasPagadasRepBean) command;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RemesasPagadasRepServicio getRemesasPagadasRepServicio() {
		return remesasPagadasRepServicio;
	}

	public void setRemesasPagadasRepServicio(RemesasPagadasRepServicio remesasPagadasRepServicio) {
		this.remesasPagadasRepServicio = remesasPagadasRepServicio;
	}

}
