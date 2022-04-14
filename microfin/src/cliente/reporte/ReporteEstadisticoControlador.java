package cliente.reporte;

import general.bean.ParametrosAuditoriaBean;

import java.io.ByteArrayOutputStream;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.RepEstadisticoBean;
import cliente.servicio.RepEstadisticoServicio;



public class ReporteEstadisticoControlador extends AbstractCommandController{
	ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	RepEstadisticoServicio repEstadisticoServicio = null;
	String nombreReporte		= null;
	String nombreReporteSumCap  = null;
	String nombreReporteSumCar	= null;
	String nombreReporteDetCap	= null;
	String nombreReporteDetCar	= null;
	String successView=null;;
	
	public static interface Enum_RepEstadistico{
		int detalladoCarteraPDF 		=1;
		int sumarizadoCarteraPDF		=2;
		int detalladoCaptacionPDF		=3;		
		int sumarizadoCaptacionPDF		=4;
		int detalladoCarteraExcel		=5;
		int sumarizadoCarteraExcel		=6;
		int detalladoCaptacionExcel		=7;		
		int sumarizadoCaptacionExcel	=8;
	}
	
	public ReporteEstadisticoControlador(){
		setCommandClass(RepEstadisticoBean.class);
		setCommandName("RepEstadisticoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, 
			Object command, 
			BindException errors)throws Exception {
		
		RepEstadisticoBean reportBean = (RepEstadisticoBean) command;
		int tipoReporte = (request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
					0;
		String hora = (request.getParameter("horaEmision"));
				reportBean.setHoraEmision(hora);
				reportBean.setTipoReporte(tipoReporte);
				String htmlString="";
	
				switch(tipoReporte){
				
				case Enum_RepEstadistico.detalladoCarteraPDF:
					ByteArrayOutputStream htmlStringPDF=reporteEstadisticoPDF(reportBean, nombreReporteDetCar, response);
					break;
				
				case Enum_RepEstadistico.detalladoCaptacionPDF:
					ByteArrayOutputStream htmlStringPDF2=reporteEstadisticoPDF(reportBean, nombreReporteDetCap, response);
					break;
				
				case Enum_RepEstadistico.sumarizadoCarteraPDF:
					ByteArrayOutputStream htmlStringPDF3=reporteEstadisticoPDF(reportBean, nombreReporteSumCar, response);
					break;
				
				case Enum_RepEstadistico.sumarizadoCaptacionPDF:
					ByteArrayOutputStream htmlStringPDF4=reporteEstadisticoPDF(reportBean, nombreReporteSumCap, response);
					break;
					
				case Enum_RepEstadistico.detalladoCarteraExcel:
					List listaReporte5=repEstadisticoServicio.repEstadisticoDetCartera(nombreReporte, reportBean, response);
					break;
					
				case Enum_RepEstadistico.sumarizadoCarteraExcel:
					List listaReporte6=repEstadisticoServicio.repEstadisticoSumCartera(nombreReporte, reportBean, response);
					break;
					
				case Enum_RepEstadistico.detalladoCaptacionExcel:
					List listaReporte7=repEstadisticoServicio.repEstadisticoDetCap(nombreReporte, reportBean, response);
					break;
					
				
				case Enum_RepEstadistico.sumarizadoCaptacionExcel:
					List listaReporte8=repEstadisticoServicio.repEstadisticoSumCaptacion(nombreReporte, reportBean, response);
					break;
				}
				return null;
				
				
	}
	
	//Reporte  en PDF
	public ByteArrayOutputStream reporteEstadisticoPDF(RepEstadisticoBean reporteBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF=null;
		try{
			htmlStringPDF=repEstadisticoServicio.reporteEstadisticoPDF(reporteBean, nombreReporte);
			response.addHeader("Content-Dispositipon", "inline; filename=ReporteEstadistico.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return htmlStringPDF;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
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

	public RepEstadisticoServicio getRepEstadisticoServicio() {
		return repEstadisticoServicio;
	}

	public void setRepEstadisticoServicio(
			RepEstadisticoServicio repEstadisticoServicio) {
		this.repEstadisticoServicio = repEstadisticoServicio;
	}

	public String getNombreReporteSumCap() {
		return nombreReporteSumCap;
	}

	public void setNombreReporteSumCap(String nombreReporteSumCap) {
		this.nombreReporteSumCap = nombreReporteSumCap;
	}

	public String getNombreReporteSumCar() {
		return nombreReporteSumCar;
	}

	public void setNombreReporteSumCar(String nombreReporteSumCar) {
		this.nombreReporteSumCar = nombreReporteSumCar;
	}

	public String getNombreReporteDetCap() {
		return nombreReporteDetCap;
	}

	public void setNombreReporteDetCap(String nombreReporteDetCap) {
		this.nombreReporteDetCap = nombreReporteDetCap;
	}

	public String getNombreReporteDetCar() {
		return nombreReporteDetCar;
	}

	public void setNombreReporteDetCar(String nombreReporteDetCar) {
		this.nombreReporteDetCar = nombreReporteDetCar;
	}
	
	
}
