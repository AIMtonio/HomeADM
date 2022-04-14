package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.RepPerfilGrupoCreditoBean;
import credito.servicio.RepPerfilGrupoCreditoServicio;

public class PerfilGrupoCreditoControlador extends SimpleFormController{
	

	RepPerfilGrupoCreditoServicio repPerfilGrupoCreditoServicio = null;
	
	public PerfilGrupoCreditoControlador() {
		setCommandClass(RepPerfilGrupoCreditoBean.class);
		setCommandName("repPerfilGrupoCreditoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
	
		RepPerfilGrupoCreditoBean repPerfilGrupoCreditoBean = (RepPerfilGrupoCreditoBean) command;
		MensajeTransaccionBean mensaje = null;
			
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setRepPerfilGrupoCreditoServicio(
			RepPerfilGrupoCreditoServicio repPerfilGrupoCreditoServicio) {
		this.repPerfilGrupoCreditoServicio = repPerfilGrupoCreditoServicio;
	}

	

		
}
