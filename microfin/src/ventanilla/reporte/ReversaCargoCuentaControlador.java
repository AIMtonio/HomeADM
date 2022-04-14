package ventanilla.reporte;

import general.bean.ParametrosAuditoriaBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.servicio.IngresosOperacionesServicio;

public class ReversaCargoCuentaControlador extends AbstractCommandController {
	
	private ParametrosAuditoriaBean	parametrosAuditoriaBean		= null;
	IngresosOperacionesServicio		ingresosOperacionesServicio	= null;
	String							nombreReporte				= null;
	String							successView					= null;
	protected final Logger			loggerVent					= Logger.getLogger("Vent");
	public ReversaCargoCuentaControlador() {
		setCommandClass(IngresosOperacionesBean.class);
		setCommandName("ingresosOperacionesBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		IngresosOperacionesBean ingresosOperacionesBean = (IngresosOperacionesBean) command;
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "llega a controlador de Cargo a Cuenta " + tipoTransaccion);
		String htmlString = ingresosOperacionesServicio.reporteTicketReversa(tipoTransaccion, request, getNombreReporte());
		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
		
	}
	
	public String getNombreReporte() {
		return nombreReporte;
	}
	
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	
	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
	public void setIngresosOperacionesServicio(IngresosOperacionesServicio ingresosOperacionesServicio) {
		this.ingresosOperacionesServicio = ingresosOperacionesServicio;
	}
	
	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}
	
	public void setParametrosAuditoriaBean(ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	
}
