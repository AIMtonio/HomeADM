
package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.RepBitacoraSolBean;
import originacion.servicio.RepBitacoraSolServicio;


public class RepBitacoraSolControlador extends SimpleFormController{
	
	RepBitacoraSolServicio repBitacoraSolServicio = null;
	
	public RepBitacoraSolControlador() {
		setCommandClass(RepBitacoraSolBean.class);
		setCommandName("repBitacoraSolBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
		RepBitacoraSolBean repBitacoraSolBean = (RepBitacoraSolBean) command;
		MensajeTransaccionBean mensaje = null;
											
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RepBitacoraSolServicio getRepBitacoraSolServicio() {
		return repBitacoraSolServicio;
	}

	public void setRepBitacoraSolServicio(RepBitacoraSolServicio repBitacoraSolServicio) {
		this.repBitacoraSolServicio = repBitacoraSolServicio;
	}
	

}
