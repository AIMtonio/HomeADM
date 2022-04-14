package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;
import aportaciones.servicio.CondicionesVencimServicio;


public class CondicionesVencimControlador extends SimpleFormController{
	AportacionesServicio aportacionesServicio = null;
	CondicionesVencimServicio condicionesVencimServicio = null;
	
	public CondicionesVencimControlador(){
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		AportacionesBean aportacionesBean = (AportacionesBean) command;
		MensajeTransaccionBean mensaje = null;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		condicionesVencimServicio.getCondicionesVencimDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		mensaje = condicionesVencimServicio.grabaTransaccion(tipoTransaccion, aportacionesBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}

	public CondicionesVencimServicio getCondicionesVencimServicio() {
		return condicionesVencimServicio;
	}

	public void setCondicionesVencimServicio(CondicionesVencimServicio condicionesVencimServicio) {
		this.condicionesVencimServicio = condicionesVencimServicio;
	}
	
}
