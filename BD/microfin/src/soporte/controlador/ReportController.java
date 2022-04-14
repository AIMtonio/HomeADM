package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.report.modules.parser.base.ReportGenerator;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import reporte.EjemploReporteData2;
import reporte.Reporte;

public class ReportController extends AbstractController{
			
	private ReportGenerator reportGenerator;
	
	public ReportController() {		
	}
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
												 HttpServletResponse response)
												throws Exception {
		
	//TODO Obtener los Datos de un Servicio;
	EjemploReporteData2 dataReport = new EjemploReporteData2();
	return new ModelAndView("home","reporte", null);
		
	}
		
	public ReportGenerator getReportGenerator() {
		return reportGenerator;
	}
	
	public void setReportGenerator(ReportGenerator reportGenerator) {
		this.reportGenerator = reportGenerator;
	}
	
	
}
