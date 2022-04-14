package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import originacion.bean.ConsolidacionesBean;
import originacion.servicio.ConsolidacionesServicio;
import soporte.bean.BitacoraHuellaBean;

public class ConsolidacionAgroControlador extends AbstractCommandController {

	ConsolidacionesServicio consolidacionesServicio = null;
	
	public ConsolidacionAgroControlador(){
		setCommandClass(ConsolidacionesBean.class);
		setCommandName("consolidacionesBean");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		ConsolidacionesBean consolidacionesBean = (ConsolidacionesBean) command;
		consolidacionesServicio.getConsolidacionesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		MensajeTransaccionBean mensajeTransaccionBean = null;
		mensajeTransaccionBean = consolidacionesServicio.grabaTransaccion(tipoTransaccion, consolidacionesBean);
		
		if(mensajeTransaccionBean == null){
			mensajeTransaccionBean = new MensajeTransaccionBean();
		}
		
		Utileria.respuestaJsonTransaccion(mensajeTransaccionBean, response);
		
		return null;
	}

	public ConsolidacionesServicio getConsolidacionesServicio() {
		return consolidacionesServicio;
	}

	public void setConsolidacionesServicio(
			ConsolidacionesServicio consolidacionesServicio) {
		this.consolidacionesServicio = consolidacionesServicio;
	}

}
