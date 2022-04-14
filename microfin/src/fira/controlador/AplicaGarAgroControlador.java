package fira.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.GarantiaFiraBean;
import fira.servicio.GarantiaFiraServicio;

public class AplicaGarAgroControlador extends SimpleFormController{
	
	GarantiaFiraServicio garantiaFiraServicio = null;
	
	
	public AplicaGarAgroControlador() {
		setCommandClass(GarantiaFiraBean.class);
		setCommandName("aplicaGarantiaFira");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		garantiaFiraServicio.getGarantiaFiraDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		GarantiaFiraBean garantiaFiraBean = (GarantiaFiraBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Utileria.convierteEntero(request.getParameter("tipoTransaccion")): 0;
		
		MensajeTransaccionBean mensaje = null;
		
		mensaje = garantiaFiraServicio.grabaTransaccion(garantiaFiraBean, tipoTransaccion);		
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}

	
	public GarantiaFiraServicio getGarantiaFiraServicio() {
		return garantiaFiraServicio;
	}

	public void setGarantiaFiraServicio(GarantiaFiraServicio garantiaFiraServicio) {
		this.garantiaFiraServicio = garantiaFiraServicio;
	}

}
