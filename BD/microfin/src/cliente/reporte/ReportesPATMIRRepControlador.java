package cliente.reporte;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ReportesPATMIRBean;
import cliente.servicio.ReportesPATMIRServicio;



public class ReportesPATMIRRepControlador extends AbstractCommandController{
	ReportesPATMIRServicio reportesPATMIRServicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public ReportesPATMIRRepControlador() {
		setCommandClass(ReportesPATMIRBean.class);
		setCommandName("PATMIRRep");
	}
	
	public static interface Enum_Reporte_TipRepor{
		int socioMenor=1;
		int bajas=2;
		int parteSocial=3;
		int creditos=4;
		int ahorros=5;
		int sociosMen =6;
		int altasMen =7;
		int ahorrosMen = 8;
		int bajasMen =9;
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command, BindException errors)throws Exception{
		MensajeTransaccionBean mensaje = null;
		ReportesPATMIRBean reportesPATMIRBean= (ReportesPATMIRBean) command;	
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		String fechaReporte=request.getParameter("fechaReporte");			
		
		reportesPATMIRBean.setFechaReporte(fechaReporte);
		mensaje=reportesPATMIRServicio.generaReporte(tipoReporte,reportesPATMIRBean,response);
				
		return null;
	}
	
	
	public ReportesPATMIRServicio getReportesPATMIRServicio() {
		return reportesPATMIRServicio;
	}
	public void setReportesPATMIRServicio(
			ReportesPATMIRServicio reportesPATMIRServicio) {
		this.reportesPATMIRServicio = reportesPATMIRServicio;
	}
	
}
