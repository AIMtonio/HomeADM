package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.CondicionesVencimServicio;

public class RepCondicionesVencimControlador extends SimpleFormController {
	
	CondicionesVencimServicio condicionesVencimServicio = null;
	public RepCondicionesVencimControlador(){
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,	HttpServletResponse response,
			Object command,	BindException errors)
			throws Exception {
		
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CondicionesVencimServicio getCondicionesVencimServicio() {
		return condicionesVencimServicio;
	}

	public void setCondicionesVencimServicio(
			CondicionesVencimServicio condicionesVencimServicio) {
		this.condicionesVencimServicio = condicionesVencimServicio;
	}
	
	
}
