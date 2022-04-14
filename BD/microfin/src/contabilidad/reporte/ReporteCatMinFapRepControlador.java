package contabilidad.reporte;

import java.util.List;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.ReporteCatMinFapBean;
import contabilidad.servicio.ReporteCatMinFapServicio;

public class ReporteCatMinFapRepControlador extends AbstractCommandController{
	ReporteCatMinFapServicio reporteCatMinFapServicio = null;
	String nombreReporte = null;
	String successView = null;	
	String nomTipoReporte = "";
	
	public static interface Enum_Tip_RepRegCatalogoMinimo{
		  
		  int  reporteExcel		= 1 ;
		  int  reporteTxt		= 2 ;
		  int  reportePantalla	= 3 ;
		  int  reportePDF		= 4 ;
	}
	
	public static interface Enum_Tip_RepRegCatalogoMinimoVer2015{
		  int  Excel		= 1 ;
		  int  CVS			= 2 ;
	}
	

 	public ReporteCatMinFapRepControlador(){
 		setCommandClass(ReporteCatMinFapBean.class);
 		setCommandName("reporteCatMinFapBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		try {
			ReporteCatMinFapBean repCatMinBean = (ReporteCatMinFapBean) command;
	
			int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
			int version = (request.getParameter("version") != null) ? Integer.parseInt(request.getParameter("version")) : 0;
			
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
	
			String htmlString = "";
			List listaReportes;
			
			reporteCatMinFapServicio.listaReportesVer2015(tipoReporte,tipoEntidad, repCatMinBean, version, response);
		
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	
	
	
	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ReporteCatMinFapServicio getReporteCatMinFapServicio() {
		return reporteCatMinFapServicio;
	}

	public void setReporteCatMinFapServicio(
			ReporteCatMinFapServicio reporteCatMinFapServicio) {
		this.reporteCatMinFapServicio = reporteCatMinFapServicio;
	}
}
