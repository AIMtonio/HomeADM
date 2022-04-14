package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.RepConvenSecBean;
import cliente.servicio.RepConvenSecServicio;


public class RepConvenSecControlador extends SimpleFormController{
	
	RepConvenSecServicio repConvenSecServicio = null;
	
	public RepConvenSecControlador() {
		setCommandClass(RepConvenSecBean.class);
		setCommandName("repConvenSecBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
		RepConvenSecBean repConvenSecBean = (RepConvenSecBean) command;
		MensajeTransaccionBean mensaje = null;
											
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RepConvenSecServicio getRepConvenSecServicio() {
		return repConvenSecServicio;
	}

	public void setRepConvenSecServicio(RepConvenSecServicio repConvenSecServicio) {
		this.repConvenSecServicio = repConvenSecServicio;
	}
	

}
