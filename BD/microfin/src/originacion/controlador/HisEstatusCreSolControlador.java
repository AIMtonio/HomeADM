
package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.HisEstatusCreSolBean;
import originacion.servicio.HisEstatusCreSolServicio;

public class HisEstatusCreSolControlador extends SimpleFormController {

	HisEstatusCreSolServicio hisEstatusCreSolServicio = null;

	public HisEstatusCreSolControlador() {
		setCommandClass(HisEstatusCreSolBean.class);
		setCommandName("hisEstatusCreSolBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		MensajeTransaccionBean mensaje = null;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public HisEstatusCreSolServicio getHisEstatusCreSolServicio() {
		return hisEstatusCreSolServicio;
	}

	public void setHisEstatusCreSolServicio(HisEstatusCreSolServicio hisEstatusCreSolServicio) {
		this.hisEstatusCreSolServicio = hisEstatusCreSolServicio;
	}

}
