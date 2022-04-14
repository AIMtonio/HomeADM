package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.report.modules.parser.base.ReportGenerator;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import reporte.EjemploReporteData;

public class HomePageController extends AbstractController{
	
	private ReportGenerator reportGenerator;
	
	public HomePageController() {}
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
												 HttpServletResponse response)
												throws Exception {
		
		Object seguridadAcegi = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		//TODO Obtener los Datos de un Servicio;
		EjemploReporteData dataReport = new EjemploReporteData();
		return new ModelAndView("home","reporte",null);
		
		/*this.contexto = SecurityContextHolder.getContext();
		this.autenticacion = SecurityContextHolder.getContext().getAuthentication();
		this.listaAutoridades = SecurityContextHolder.getContext().getAuthentication().getAuthorities();
		convertirArrayAuthoritiesToListAuthorities();
		this.nombreUsuario = this.autenticacion.getName();
		this.estaAutenticado = this.autenticacion.isAuthenticated();*/		
		
		
	}

	public ReportGenerator getReportGenerator() {
		return reportGenerator;
	}
	
	public void setReportGenerator(ReportGenerator reportGenerator) {
		this.reportGenerator = reportGenerator;
	}
	
}