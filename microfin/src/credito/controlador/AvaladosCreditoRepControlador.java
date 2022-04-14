package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.AvaladosCreditoRepBean;
import credito.servicio.AvaladosCreditoRepServicio;

public class AvaladosCreditoRepControlador extends SimpleFormController{
	

	AvaladosCreditoRepServicio avaladosCreditoRepServicio = null;
	
	public AvaladosCreditoRepControlador() {
		setCommandClass(AvaladosCreditoRepBean.class);
		setCommandName("avaladosCreditoRepBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
	
		AvaladosCreditoRepBean avaladosCreditoRepBean= (AvaladosCreditoRepBean) command;
		MensajeTransaccionBean mensaje = null;
			
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public AvaladosCreditoRepServicio getAvaladosCreditoRepServicio() {
		return avaladosCreditoRepServicio;
	}

	public void setAvaladosCreditoRepServicio(
			AvaladosCreditoRepServicio avaladosCreditoRepServicio) {
		this.avaladosCreditoRepServicio = avaladosCreditoRepServicio;
	}


}
