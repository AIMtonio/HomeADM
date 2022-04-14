package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.PerfilTransaccionalBean;
import pld.bean.SeguimientoPersonaListaBean;
import pld.servicio.SeguimientoPersonaListaServicio;


public class SeguimientoPersonaControlador extends SimpleFormController {

	SeguimientoPersonaListaServicio seguimientoPersonaListaServicio=null;
	
	public SeguimientoPersonaControlador() {
		setCommandClass(SeguimientoPersonaListaBean.class);
		setCommandName("seguimientoPersonaListaBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response, 
			Object command, BindException errors) throws Exception {
		SeguimientoPersonaListaBean bean = (SeguimientoPersonaListaBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		
		mensaje = seguimientoPersonaListaServicio.grabaTransaccion(tipoTransaccion, bean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SeguimientoPersonaListaServicio getSeguimientoPersonaListaServicio() {
		return seguimientoPersonaListaServicio;
	}

	public void setSeguimientoPersonaListaServicio(
			SeguimientoPersonaListaServicio seguimientoPersonaListaServicio) {
		this.seguimientoPersonaListaServicio = seguimientoPersonaListaServicio;
	}
	
	
}
