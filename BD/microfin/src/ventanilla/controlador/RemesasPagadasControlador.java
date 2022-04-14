package ventanilla.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import ventanilla.bean.RemesasPagadasBean;
import ventanilla.servicio.RemesasPagadasServicio;

public class RemesasPagadasControlador extends SimpleFormController{

	RemesasPagadasServicio remesasPagadasServicio = null;
	
	public RemesasPagadasControlador() {
		setCommandClass(RemesasPagadasBean.class);
		setCommandName("remesasPagadasBean");
	}
	
	@Override
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,
			BindException errors) throws Exception {
		RemesasPagadasBean remesasPagadasBean = (RemesasPagadasBean) command;
		MensajeTransaccionBean mensaje = remesasPagadasServicio.reimpresionPagoRemesa(remesasPagadasBean.getReferencia());
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public RemesasPagadasServicio getRemesasPagadasServicio() {
		return remesasPagadasServicio;
	}
	
	public void setRemesasPagadasServicio(RemesasPagadasServicio remesasPagadasServicio) {
		this.remesasPagadasServicio = remesasPagadasServicio;
	}
}
