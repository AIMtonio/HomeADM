package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.RepSaldoBancosCCBean;
import tesoreria.servicio.RepSaldoBancosCCServicio;


public class RepSaldoBancosCCControlador extends SimpleFormController{
	
	RepSaldoBancosCCServicio repSaldoBancosCCServicio=null;
	
	public RepSaldoBancosCCControlador() {
		setCommandClass(RepSaldoBancosCCBean.class);
		setCommandName("repSaldoBancosCCBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,							
			BindException errors) throws Exception {


		RepSaldoBancosCCBean repSaldoBancosCCBean= (RepSaldoBancosCCBean) command;
	MensajeTransaccionBean mensaje = null;

	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public RepSaldoBancosCCServicio getRepSaldoBancosCCServicio() {
		return repSaldoBancosCCServicio;
	}

	public void setRepSaldoBancosCCServicio(
			RepSaldoBancosCCServicio repSaldoBancosCCServicio) {
		this.repSaldoBancosCCServicio = repSaldoBancosCCServicio;
	}

}
