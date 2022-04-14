package soporte.controlador;

import java.util.List;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.RelacionadosFiscalesBean;
import soporte.servicio.RelacionadosFiscalesServicio;

public class RelacionadosFiscalesControlador extends SimpleFormController{
	private RelacionadosFiscalesServicio relacionadosFiscalesServicio = null;
	
	public RelacionadosFiscalesControlador(){
		setCommandClass(RelacionadosFiscalesBean.class);
		setCommandName("relacionadosFiscalesBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		relacionadosFiscalesServicio.getRelacionadosFiscalesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		RelacionadosFiscalesBean bean = (RelacionadosFiscalesBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;

		mensaje = relacionadosFiscalesServicio.grabaTransaccion(tipoTransaccion, bean);
				
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RelacionadosFiscalesServicio getRelacionadosFiscalesServicio() {
		return relacionadosFiscalesServicio;
	}

	public void setRelacionadosFiscalesServicio(
			RelacionadosFiscalesServicio relacionadosFiscalesServicio) {
		this.relacionadosFiscalesServicio = relacionadosFiscalesServicio;
	}
}
