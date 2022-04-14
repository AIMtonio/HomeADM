package fondeador.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fondeador.bean.CreditoFondeoBean;
import fondeador.reporte.ContratoInvRepControlador.Enum_Con_TipRepor;
import fondeador.servicio.CreditoFondeoServicio;

public class ContratoCreditoPasivoControlador extends AbstractCommandController{
	
	CreditoFondeoServicio creditoFondeoServicio = null;
	String nombreReportePF = null;
	String nombreReportePM = null;
	String successView=null;;
	
	public static interface Enum_Con_TipRepor {
		int ContratoPF =1;  
		int ContratoPM= 2 ;
		  
	}
	
	public ContratoCreditoPasivoControlador() {
		setCommandClass(CreditoFondeoBean.class);
		setCommandName("creditoFondeoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		CreditoFondeoBean creditoFondeoBean = (CreditoFondeoBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
				
		String htmlString= "";
		switch(tipoReporte){	
		
		case Enum_Con_TipRepor.ContratoPF:
			ByteArrayOutputStream htmlStringPDF = reporteContratoCredPasivo(creditoFondeoBean, nombreReportePF, response);
		break;
		
		case Enum_Con_TipRepor.ContratoPM:
			ByteArrayOutputStream htmlStringPDFM = reporteContratoCredPasivo(creditoFondeoBean, nombreReportePM, response);
		break;
		
		}
		return null;
		
	}
	
	public ByteArrayOutputStream reporteContratoCredPasivo(CreditoFondeoBean creditoFondeoBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditoFondeoServicio.repContratoCreditoPasivo(creditoFondeoBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=ContratoCreditoPasivo.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	return htmlStringPDF;
	}

	public CreditoFondeoServicio getCreditoFondeoServicio() {
		return creditoFondeoServicio;
	}

	public void setCreditoFondeoServicio(CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
	}

	public String getNombreReportePF() {
		return nombreReportePF;
	}

	public void setNombreReportePF(String nombreReportePF) {
		this.nombreReportePF = nombreReportePF;
	}

	public String getNombreReportePM() {
		return nombreReportePM;
	}

	public void setNombreReportePM(String nombreReportePM) {
		this.nombreReportePM = nombreReportePM;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	

}
