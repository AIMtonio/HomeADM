package fondeador.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fondeador.bean.RedesCuentoBean;
import fondeador.servicio.RedesCuentoServicio;
import general.bean.MensajeTransaccionBean;

public class RedesCuentoControlador extends SimpleFormController {
	RedesCuentoServicio redesCuentoServicio = null;

	public RedesCuentoControlador() {
		setCommandClass(RedesCuentoBean.class);
		setCommandName("redesCuentoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,							
			BindException errors) throws Exception {


	int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
	RedesCuentoBean redesCuentoBean = (RedesCuentoBean) command;
	MensajeTransaccionBean mensaje = null;
	mensaje = redesCuentoServicio.grabaTransaccion(tipoTransaccion, redesCuentoBean);
			
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public void setRedesCuentoServicio(
			RedesCuentoServicio redesCuentoServicio) {
		this.redesCuentoServicio = redesCuentoServicio;
	}
	
}
