package cuentas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.AltaTiposSoporteBean;
import cuentas.servicio.AltaTiposSoporteServicio;

public class AltaTiposSoporteControlador extends SimpleFormController{

	AltaTiposSoporteServicio altaTiposSoporteServicio = null;
	
	public AltaTiposSoporteControlador(){
 		setCommandClass(AltaTiposSoporteBean.class);
 		setCommandName("altaTiposSoporteBean"); 		
 	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		altaTiposSoporteServicio.getAltaTiposSoporteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		
		AltaTiposSoporteBean altaTiposSoporteBean = (AltaTiposSoporteBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")):0;

		MensajeTransaccionBean mensaje = null;
		
		mensaje = altaTiposSoporteServicio.grabaTransaccion(tipoTransaccion, altaTiposSoporteBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	// ---------------  GETTER y SETTER -------------------- 
	
	public AltaTiposSoporteServicio getAltaTiposSoporteServicio() {
		return altaTiposSoporteServicio;
	}

	public void setAltaTiposSoporteServicio(
			AltaTiposSoporteServicio altaTiposSoporteServicio) {
		this.altaTiposSoporteServicio = altaTiposSoporteServicio;
	}

}
