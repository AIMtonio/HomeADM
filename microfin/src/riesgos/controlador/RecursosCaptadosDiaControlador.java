package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.RecursosCaptadosDiaServicio;

public class RecursosCaptadosDiaControlador extends SimpleFormController{
	RecursosCaptadosDiaServicio recursosCaptadosDiaServicio = null;

	public RecursosCaptadosDiaControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("recursosCaptadosDia");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public RecursosCaptadosDiaServicio getRecursosCaptadosDiaServicio() {
		return recursosCaptadosDiaServicio;
	}

	public void setRecursosCaptadosDiaServicio(
			RecursosCaptadosDiaServicio recursosCaptadosDiaServicio) {
		this.recursosCaptadosDiaServicio = recursosCaptadosDiaServicio;
	}

}
