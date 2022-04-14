package nomina.reporte;
import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.ArrayList;

import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.ConvenioNominaBean;
import nomina.servicio.BitacoraConveniosNominaServicio;
import originacion.bean.SolicitudCreditoBean;

public class BitacoraCambiosInstitNomControlador extends AbstractCommandController {
	
	public static interface Enum_Con_TipRepor {
		  int reporteExcelTodos = 1 ;
		  int reporteIndivExcel = 2;
		  int reportePDFTodos = 3;
		  int reporteIndivPDF = 4;
	}
	
	BitacoraConveniosNominaServicio bitacoraConveniosNominaServicio = null;
	
	private String nombreReporte = null;
	private String successView = null;
	
	public BitacoraCambiosInstitNomControlador() {
		setCommandClass(ConvenioNominaBean.class);
		setCommandName("convenioNominaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		ConvenioNominaBean convenioNominaBean = (ConvenioNominaBean) command;
		int tipoReporte =(request.getParameter("tipoRep")!=null)?
				Integer.parseInt(request.getParameter("tipoRep")):0;
			
		switch(tipoReporte){	
			case Enum_Con_TipRepor.reporteExcelTodos:	
				List<ConvenioNominaBean> listaReportes = bitacoraConveniosNominaServicio.listaReporteExcelTodos(tipoReporte, convenioNominaBean, response);
			break;
			case Enum_Con_TipRepor.reporteIndivExcel:
				List<ConvenioNominaBean> listaReporteIndividual = bitacoraConveniosNominaServicio.listaReporteExcelIndividual(tipoReporte, convenioNominaBean, response);
			break;
			case Enum_Con_TipRepor.reportePDFTodos:	
				ByteArrayOutputStream htmlStringPDFTodos = reporteCambiosTodosPDF(convenioNominaBean, nombreReporte, response);
			break;
			case Enum_Con_TipRepor.reporteIndivPDF:
				ByteArrayOutputStream htmlStringPDFIndividual = reporteCambiosIndividualPDF(convenioNominaBean, nombreReporte, response);
			break;
		}
		return null;	
	}
	
	// Reporte Cambios Todos
	public ByteArrayOutputStream reporteCambiosTodosPDF(ConvenioNominaBean convenioNominaBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = bitacoraConveniosNominaServicio.listaReportePDF(convenioNominaBean, nombreReporte);
			response.addHeader("Content-Disposition", "inline; filename=BitacoraCambiosInstitNom.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return htmlStringPDF;
	}
	
	// Reporte Cambios Individuales
	public ByteArrayOutputStream reporteCambiosIndividualPDF(ConvenioNominaBean convenioNominaBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = bitacoraConveniosNominaServicio.listaReportePDF(convenioNominaBean, nombreReporte);
			response.addHeader("Content-Disposition", "inline; filename=BitacoraCambiosInstitNomIndividual.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return htmlStringPDF;
	}
	
	public BitacoraConveniosNominaServicio getBitacoraConveniosNominaServicio() {
		return bitacoraConveniosNominaServicio;
	}

	public void setBitacoraConveniosNominaServicio(
			BitacoraConveniosNominaServicio bitacoraConveniosNominaServicio) {
		this.bitacoraConveniosNominaServicio = bitacoraConveniosNominaServicio;
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
