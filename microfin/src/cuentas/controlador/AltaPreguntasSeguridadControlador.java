package cuentas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.AltaPreguntasSeguridadBean;
import cuentas.servicio.AltaPreguntasSeguridadServicio;

public class AltaPreguntasSeguridadControlador extends SimpleFormController{
	
	AltaPreguntasSeguridadServicio altaPreguntasSeguridadServicio = null;
	
	public AltaPreguntasSeguridadControlador(){
 		setCommandClass(AltaPreguntasSeguridadBean.class);
 		setCommandName("altaPreguntasSeguridadBean"); 		
 	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		altaPreguntasSeguridadServicio.getAltaPreguntasSeguridadDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		
		AltaPreguntasSeguridadBean altaPreguntasSeguridadBean = (AltaPreguntasSeguridadBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")):0;

		MensajeTransaccionBean mensaje = null;
		
		mensaje = altaPreguntasSeguridadServicio.grabaTransaccion(tipoTransaccion, altaPreguntasSeguridadBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	 // ---------------  GETTER y SETTER -------------------- 
	public AltaPreguntasSeguridadServicio getAltaPreguntasSeguridadServicio() {
		return altaPreguntasSeguridadServicio;
	}

	public void setAltaPreguntasSeguridadServicio(
			AltaPreguntasSeguridadServicio altaPreguntasSeguridadServicio) {
		this.altaPreguntasSeguridadServicio = altaPreguntasSeguridadServicio;
	}
	
}
