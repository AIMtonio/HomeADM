package cuentas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.VerificacionPreguntasBean;
import cuentas.servicio.VerificacionPreguntasServicio;


public class VerificacionPreguntasControlador extends SimpleFormController{
	
	VerificacionPreguntasServicio verificacionPreguntasServicio = null;
	
	public VerificacionPreguntasControlador() {
		setCommandClass(VerificacionPreguntasBean.class);
		setCommandName("verificacionPreguntasBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, 
			HttpServletResponse response, Object command, 
			BindException errors) throws Exception {
		
		verificacionPreguntasServicio.getVerificacionPreguntasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		VerificacionPreguntasBean verificacionPreguntasBean = (VerificacionPreguntasBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		String datosGrid = request.getParameter("datosGridPreguntas");	
		
		MensajeTransaccionBean mensaje = null;
		
		mensaje = verificacionPreguntasServicio.grabaTransaccion(tipoTransaccion, verificacionPreguntasBean,datosGrid);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	// ==================== GETTER & SETTER ================ //
	
	public VerificacionPreguntasServicio getVerificacionPreguntasServicio() {
		return verificacionPreguntasServicio;
	}

	public void setVerificacionPreguntasServicio(
			VerificacionPreguntasServicio verificacionPreguntasServicio) {
		this.verificacionPreguntasServicio = verificacionPreguntasServicio;
	}

}
