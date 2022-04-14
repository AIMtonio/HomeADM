
package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.SociosSinActCrediticiaRepBean;
import pld.servicio.SociosSinActCrediticiaRepServicio;

public class SociosSinActCrediticiaRepControlador extends SimpleFormController{
	

	private SociosSinActCrediticiaRepServicio sociosSinActCrediticiaRepServicio;
	
	public SociosSinActCrediticiaRepControlador() {
		setCommandClass(SociosSinActCrediticiaRepBean.class);
		setCommandName("sociosSinActCrediticiaRepBean");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		SociosSinActCrediticiaRepBean sociosSinActCrediticiaBean = (SociosSinActCrediticiaRepBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public SociosSinActCrediticiaRepServicio getSociosSinActCrediticiaRepServicio() {
		return sociosSinActCrediticiaRepServicio;
	}
	public void setSociosSinActCrediticiaRepServicio(
			SociosSinActCrediticiaRepServicio sociosSinActCrediticiaRepServicio) {
		this.sociosSinActCrediticiaRepServicio = sociosSinActCrediticiaRepServicio;
	}

		
	
}
