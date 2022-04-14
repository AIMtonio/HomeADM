package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.NivelCreditoBean;
import originacion.servicio.NivelCreditoServicio;

public class NivelCreditoControlador extends SimpleFormController{
	NivelCreditoServicio nivelCreditoServicio = null;
	
	public NivelCreditoControlador(){
		setCommandClass(NivelCreditoBean.class);
		setCommandName("nivelCreditoBean");		
	}
	

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		nivelCreditoServicio.getNivelCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		NivelCreditoBean nivelCreditoBean = (NivelCreditoBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));				
		MensajeTransaccionBean mensaje = null;

		mensaje = nivelCreditoServicio.grabaTransaccion(tipoTransaccion, nivelCreditoBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	public NivelCreditoServicio getNivelCreditoServicio() {
		return nivelCreditoServicio;
	}


	public void setNivelCreditoServicio(NivelCreditoServicio nivelCreditoServicio) {
		this.nivelCreditoServicio = nivelCreditoServicio;
	}
	
}
