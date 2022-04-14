package activos.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import activos.bean.RepDepAmortizaActivosBean;
import activos.servicio.RepDepAmortizaActivosServicio;

public class RepDepAmortizaActivosControlador extends AbstractCommandController{
	
	RepDepAmortizaActivosServicio repDepAmortizaActivosServicio = null;
	
	String nombreReporte = null;
	String successView = null;

	public RepDepAmortizaActivosControlador(){
		setCommandClass(RepDepAmortizaActivosBean.class);
 		setCommandName("repDepAmortizaActivosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse httpServletResponse, Object command, BindException errors)
			throws Exception {

		RepDepAmortizaActivosBean repDepAmortizaActivosBean =(RepDepAmortizaActivosBean)command;		
		int tipoReporte = (request.getParameter("tipoReporte")!=null) ? Integer.parseInt(request.getParameter("tipoReporte")): 0;

		// Reporte Excel Depreciacion y Amortizacion de Activos
		repDepAmortizaActivosServicio.listaDepAmortizaActivos(tipoReporte, repDepAmortizaActivosBean, httpServletResponse);
 		return null;
	}

	public RepDepAmortizaActivosServicio getRepDepAmortizaActivosServicio() {
		return repDepAmortizaActivosServicio;
	}

	public void setRepDepAmortizaActivosServicio(
			RepDepAmortizaActivosServicio repDepAmortizaActivosServicio) {
		this.repDepAmortizaActivosServicio = repDepAmortizaActivosServicio;
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
}
