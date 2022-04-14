package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import pld.bean.OpeInusualesBean;
import pld.servicio.OpeInusualesServicio;

public class PLDOpeInusualesRepControlador extends SimpleFormController {
	
	OpeInusualesServicio opeInusualesServicio = null;

	public PLDOpeInusualesRepControlador() {
		setCommandClass(OpeInusualesBean.class);
		setCommandName("opeInusuales");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		opeInusualesServicio.getOpeInusualesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
		OpeInusualesBean parametrosOperInusuales = (OpeInusualesBean) command;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
								Integer.parseInt(request.getParameter("tipoActualizacion")):0;
		
		int tipoTransaccion =  (request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
								
		MensajeTransaccionBean mensaje = null;
				
		String  datosOperInusuales = request.getParameter("datosOperInusuales");
		mensaje = opeInusualesServicio.actualizaReporte(tipoActualizacion,tipoTransaccion, parametrosOperInusuales,datosOperInusuales);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}
	
	

	//---------- setter---------------
	public void setOpeInusualesServicio(OpeInusualesServicio opeInusualesServicio) {
		this.opeInusualesServicio = opeInusualesServicio;
	}


}
