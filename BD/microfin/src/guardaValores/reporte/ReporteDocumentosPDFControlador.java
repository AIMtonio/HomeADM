package guardaValores.reporte;

import java.io.ByteArrayOutputStream;

import guardaValores.bean.DocumentosGuardaValoresBean;
import guardaValores.servicio.DocumentosGuardaValoresServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ReporteDocumentosPDFControlador extends AbstractCommandController {

	DocumentosGuardaValoresServicio documentosGuardaValoresServicio = null;
	String nombreReporte = null;
	String ingresoDocumentos = null;
	String estatusDocumentos = null;
	String prestamoDocumentos = null;
	String bitacoraDocumentos = null;
	String successView = null;

	public static interface Enum_Rep_PDF {
		int ingresoDocumentos  	 = 1;
		int estatusDocumentos  	 = 2;
		int prestamoDocumentos 	 = 3;
		int expedienteDocumentos = 4;
	}

	public static interface Enum_NombreRep_PDF {
		String ingresoDocumentos  = "ingresoDocumentos";
		String estatusDocumentos  = "estatusDocumento";
		String prestamoDocumentos = "prestamoDocumentos";
		String bitacoraDocumentos = "bitacoraDocumentos";
	}

	public ReporteDocumentosPDFControlador () {
		setCommandClass(DocumentosGuardaValoresBean.class);
		setCommandName("documentosGuardaValoresBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {

		DocumentosGuardaValoresBean documentosGuardaValoresBean = (DocumentosGuardaValoresBean) command;

		ByteArrayOutputStream reportePDF = null ;
		int tipoReporte =(request.getParameter("tipoReporte")!=null) ? Integer.parseInt(request.getParameter("tipoReporte")): 0;
		
		switch(tipoReporte){
			case Enum_Rep_PDF.ingresoDocumentos:
				reportePDF = reporteIngresoDocumentosPDF(documentosGuardaValoresBean, ingresoDocumentos, response);
			break;
			case Enum_Rep_PDF.estatusDocumentos:
				reportePDF = reporteEstatusDocumentosPDF(documentosGuardaValoresBean, estatusDocumentos, response);
			break;
			case Enum_Rep_PDF.prestamoDocumentos:
				reportePDF = reportePrestamoDocumentosPDF(documentosGuardaValoresBean, prestamoDocumentos, response);
			break;
			case Enum_Rep_PDF.expedienteDocumentos:
				reportePDF = reporteExpedientePDF(documentosGuardaValoresBean, bitacoraDocumentos, response);
			break;
		}

		return null;
	}
	
	// Reporte Ingreso de Documentos
	public ByteArrayOutputStream reporteIngresoDocumentosPDF(DocumentosGuardaValoresBean documentosGuardaValoresBean, String nombreReporte, HttpServletResponse response){
		
		ByteArrayOutputStream htmlStringPDF = null;
		
		try {
		
			htmlStringPDF =documentosGuardaValoresServicio.reporteIngresoDocumentosPDF(documentosGuardaValoresBean, nombreReporte);
			response.addHeader("Content-Disposition", "inline; filename=ReporteIngresoDocumentos.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		
		} catch (Exception exception) {
			exception.printStackTrace();
		}
		
		return htmlStringPDF;
	}
	
	// Reporte Estatus de Documentos
	public ByteArrayOutputStream reporteEstatusDocumentosPDF(DocumentosGuardaValoresBean documentosGuardaValoresBean, String nombreReporte, HttpServletResponse response){
		
		ByteArrayOutputStream htmlStringPDF = null;
		
		try {
		
			htmlStringPDF =documentosGuardaValoresServicio.reporteEstatusDocumentosPDF(documentosGuardaValoresBean, nombreReporte);
			response.addHeader("Content-Disposition", "inline; filename=ReporteEstatusDocumentos.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		
		} catch (Exception exception) {
			exception.printStackTrace();
		}
		
		return htmlStringPDF;
	}

	// Reporte Préstamo de Documentos
	public ByteArrayOutputStream reportePrestamoDocumentosPDF(DocumentosGuardaValoresBean documentosGuardaValoresBean, String nombreReporte, HttpServletResponse response){
		
		ByteArrayOutputStream htmlStringPDF = null;
		
		try {
		
			htmlStringPDF =documentosGuardaValoresServicio.reportePrestamoDocumentosPDF(documentosGuardaValoresBean, nombreReporte);
			response.addHeader("Content-Disposition", "inline; filename=ReportePrestamoDocumentos.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		
		} catch (Exception exception) {
			exception.printStackTrace();
		}
		
		return htmlStringPDF;
	}
	
	// Reporte Bitácora de Documentos
	public ByteArrayOutputStream reporteExpedientePDF(DocumentosGuardaValoresBean documentosGuardaValoresBean, String nombreReporte, HttpServletResponse response){
		
		ByteArrayOutputStream htmlStringPDF = null;
		
		try {
		
			htmlStringPDF =documentosGuardaValoresServicio.reporteExpedientePDF(documentosGuardaValoresBean, nombreReporte);
			response.addHeader("Content-Disposition", "inline; filename=ReporteBitacoraDocumentos.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		
		} catch (Exception exception) {
			exception.printStackTrace();
		}
		
		return htmlStringPDF;
	}
	
	public DocumentosGuardaValoresServicio getDocumentosGuardaValoresServicio() {
		return documentosGuardaValoresServicio;
	}

	public void setDocumentosGuardaValoresServicio(DocumentosGuardaValoresServicio documentosGuardaValoresServicio) {
		this.documentosGuardaValoresServicio = documentosGuardaValoresServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getIngresoDocumentos() {
		return ingresoDocumentos;
	}

	public void setIngresoDocumentos(String ingresoDocumentos) {
		this.ingresoDocumentos = ingresoDocumentos;
	}

	public String getEstatusDocumentos() {
		return estatusDocumentos;
	}

	public void setEstatusDocumentos(String estatusDocumentos) {
		this.estatusDocumentos = estatusDocumentos;
	}

	public String getPrestamoDocumentos() {
		return prestamoDocumentos;
	}

	public void setPrestamoDocumentos(String prestamoDocumentos) {
		this.prestamoDocumentos = prestamoDocumentos;
	}

	public String getBitacoraDocumentos() {
		return bitacoraDocumentos;
	}

	public void setBitacoraDocumentos(String bitacoraDocumentos) {
		this.bitacoraDocumentos = bitacoraDocumentos;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
