package regulatorios.reporte;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioI0391Bean;
import regulatorios.servicio.RegulatorioI0391Servicio;

public class RegulatorioI0391ReporteControlador extends AbstractCommandController{
	RegulatorioI0391Servicio regulatorioI0391Servicio = null;
	String successView = null;

	
	public RegulatorioI0391ReporteControlador () {
		setCommandClass(RegulatorioI0391Bean.class);
		setCommandName("regulatorioI0391Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		RegulatorioI0391Bean reporteBean = (RegulatorioI0391Bean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		int tipoEntidad = Integer.parseInt(reporteBean.getInstitucionID());		
		
		regulatorioI0391Servicio.listaReporteRegulatorioI0391(tipoReporte,tipoEntidad, reporteBean, response); ;
		
		return null;	
	}


	

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RegulatorioI0391Servicio getRegulatorioI0391Servicio() {
		return regulatorioI0391Servicio;
	}

	public void setRegulatorioI0391Servicio(
			RegulatorioI0391Servicio regulatorioI0391Servicio) {
		this.regulatorioI0391Servicio = regulatorioI0391Servicio;
	}
	
}