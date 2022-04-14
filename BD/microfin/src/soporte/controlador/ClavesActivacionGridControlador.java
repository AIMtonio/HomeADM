package soporte.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ControlClaveBean;
import soporte.servicio.ControlClaveServicio;


public class ClavesActivacionGridControlador extends AbstractCommandController{
	ControlClaveServicio controlClaveServicio = null;
	public ClavesActivacionGridControlador() {
		setCommandClass(ControlClaveBean.class);
		setCommandName("controlClaveBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		ControlClaveBean controlClave = (ControlClaveBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List clavesAccesoList = controlClaveServicio.lista(tipoLista, controlClave);

		return new ModelAndView("soporte/clavesActivacionGridVista", "clavesAcceso", clavesAccesoList );
	}
	
	public ControlClaveServicio getControlClaveServicio() {
		return controlClaveServicio;
	}
	public void setControlClaveServicio(ControlClaveServicio controlClaveServicio) {
		this.controlClaveServicio = controlClaveServicio;
	}
}