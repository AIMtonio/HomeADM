package psl.reporte;
import general.bean.ParametrosAuditoriaBean;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import psl.bean.PSLReportePagoBean;
import psl.servicio.PSLReportePagoServicio;

public class PSLReportePagoControlador extends AbstractCommandController {
	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	PSLReportePagoServicio pslReportePagoServicio = null;
	String nombreReporte = null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public static interface Enum_Rep_TipoReporte {
		int ReportePDF = 1;
		int ReporteExcel = 2;
	}

	public static interface Enum_Rep_NumeroReporte {
		int reportePagoServicios = 1;
	}

	public PSLReportePagoControlador(){
		setCommandClass(PSLReportePagoBean.class);
		setCommandName("PSLReportePagoBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {

		PSLReportePagoBean pslReportePagoBean = (PSLReportePagoBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null) ?
				Integer.parseInt(request.getParameter("tipoReporte")) : 0;

		String htmlString = "";

		switch (tipoReporte) {
		case Enum_Rep_TipoReporte.ReportePDF:
			ByteArrayOutputStream htmlStringPDF = reportePagoPDF(pslReportePagoBean, nombreReporte, response);
			break;

		case Enum_Rep_TipoReporte.ReporteExcel:
			int numeroReporte = 1;
			List listaReportes = pslReportePagoServicio.reportePagoExcel(numeroReporte, pslReportePagoBean, response);
			break;
		}

		return null;
	}

	public ByteArrayOutputStream reportePagoPDF(PSLReportePagoBean pslReportePagoBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF=null;
		try{
			htmlStringPDF = pslReportePagoServicio.reportePagoPDF(pslReportePagoBean, nombreReporte);
			response.addHeader("Content-Dispositipon", "inline; filename=ReportePagoServicios.pdf");
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

	public PSLReportePagoServicio getPslReportePagoServicio() {
		return pslReportePagoServicio;
	}

	public void setPslReportePagoServicio(
			PSLReportePagoServicio pslReportePagoServicio) {
		this.pslReportePagoServicio = pslReportePagoServicio;
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
