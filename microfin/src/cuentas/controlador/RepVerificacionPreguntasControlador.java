package cuentas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import cuentas.bean.RepVerificacionPreguntasBean;
import cuentas.servicio.RepVerificacionPreguntasServicio;

public class RepVerificacionPreguntasControlador extends SimpleFormController{

	RepVerificacionPreguntasServicio repVerificacionPreguntasServicio = null;
	
	public RepVerificacionPreguntasControlador() {
		setCommandClass(RepVerificacionPreguntasBean.class);
		setCommandName("repVerificacionPreguntasBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, 
			HttpServletResponse response, Object command, 
			BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	// ==================== GETTER & SETTER ================ //

	public RepVerificacionPreguntasServicio getRepVerificacionPreguntasServicio() {
		return repVerificacionPreguntasServicio;
	}

	public void setRepVerificacionPreguntasServicio(
			RepVerificacionPreguntasServicio repVerificacionPreguntasServicio) {
		this.repVerificacionPreguntasServicio = repVerificacionPreguntasServicio;
	}
	
}
