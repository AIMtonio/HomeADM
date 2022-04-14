package pld.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import gestionComecial.bean.EmpleadosBean;
import gestionComecial.servicio.EmpleadosServicio;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;

import pld.bean.EscalamientoPrevioBean;
import pld.bean.OpIntPreocupantesBean;
import pld.servicio.EscalamientoPrevioServicio;
import pld.servicio.OpIntPreocupantesServicio;

public class OpIntPreocupantesControlador extends SimpleFormController{
	

	private OpIntPreocupantesServicio opIntPreocupantesServicio;
	
	public OpIntPreocupantesControlador() {
		setCommandClass(OpIntPreocupantesBean.class);
		setCommandName("opIntPreocupantes");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		opIntPreocupantesServicio.getOpIntPreocupantesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		OpIntPreocupantesBean opIntPreocupantes = (OpIntPreocupantesBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = opIntPreocupantesServicio.grabaTransaccion(tipoTransaccion, opIntPreocupantes);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public OpIntPreocupantesServicio getOpIntPreocupantesServicio() {
		return opIntPreocupantesServicio;
	}
	public void setOpIntPreocupantesServicio(
			OpIntPreocupantesServicio opIntPreocupantesServicio) {
		this.opIntPreocupantesServicio = opIntPreocupantesServicio;
	}

	
	
}
