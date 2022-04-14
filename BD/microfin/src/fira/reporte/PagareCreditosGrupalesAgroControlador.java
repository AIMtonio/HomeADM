package fira.reporte;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteBean;

import contabilidad.bean.CuentasContablesBean;
import contabilidad.servicio.CuentasContablesServicio;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class PagareCreditosGrupalesAgroControlador extends AbstractCommandController{

	CreditosServicio creditosServicio = null;
	String nombreReporteTF = null;
	String nombreReporteTV = null;	
	String nombreReporteTFGru= null;
	String nombRepAmorticre=null;
	String nombRepCaratContra=null;
	String nombRepClausuContra=null;
	String nombRepObligacionesCG=null;
	String nombRepCaratContraInd=null;
	String nombreReporteTFInd	=null;
	
	public PagareCreditosGrupalesAgroControlador(){
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		CreditosBean creditos = (CreditosBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;

		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						Integer.parseInt(request.getParameter("tipoActualizacion")):
							0;		
		int tipoReporte = (request.getParameter("tipoReporte")!=null)?
								Integer.parseInt(request.getParameter("tipoReporte")):
									0;				
		MensajeTransaccionBean mensaje = null;
		mensaje=creditosServicio.grabaTransaccionAgro(tipoTransaccion,tipoActualizacion, creditos,null, request);
		
		String tf = "1";
		String tv ="2";
		String tv2 = "3";
		String tv3 = "4";
		int tFijaGrupal = 4;	
		String tablaAmort="10";// reporte para tabla de AMORTICREDIO
		String clausuContrat="5";
		String caratContrat="6";
		String obligacionesCG="7";
		String caratContratInd="8";
		String tFijaInd="9";
		
								
			if(creditos.getCalcInteresID().equals(tf ) ){
			
				ByteArrayOutputStream htmlString = creditosServicio.reportePagareTF(creditos, nombreReporteTF);
			
				response.addHeader("Content-Disposition","inline; filename=PagareTasaFija.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			
			if(creditos.getCalcInteresID().equals(tablaAmort) ){
			
				ByteArrayOutputStream htmlString = creditosServicio.reportePagareTFPDF(creditos, nombRepAmorticre);
			
				response.addHeader("Content-Disposition","inline; filename=tablaAmortizacion.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			
			if(creditos.getCalcInteresID().equals(tv) || creditos.getCalcInteresID().equals(tv2)  || creditos.getCalcInteresID().equals(tv3) ){
			
				ByteArrayOutputStream htmlString = creditosServicio.reportePagareTVPDF(creditos, nombreReporteTV);
			
				response.addHeader("Content-Disposition","inline; filename=PagareTasaVar.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			
			if(tipoReporte== tFijaGrupal){
				ByteArrayOutputStream htmlString = creditosServicio.reportePagareTasaFijaGrupal(creditos, nombreReporteTFGru);
			
				response.addHeader("Content-Disposition","inline; filename=PagareTFGrupal.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			
			
			if(creditos.getCalcInteresID().equals(clausuContrat)){
				ByteArrayOutputStream htmlString = creditosServicio.reporteClausulasContrato(creditos, nombRepClausuContra);
			
				response.addHeader("Content-Disposition","inline; filename=ClausulasContrato.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			
			if(creditos.getCalcInteresID().equals(caratContrat)){
				ByteArrayOutputStream htmlString = creditosServicio.reporteCaratulaContrato(creditos, nombRepCaratContra) ;
			
				response.addHeader("Content-Disposition","inline; filename=CaratulaContrato.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			if(creditos.getCalcInteresID().equals(obligacionesCG)){
				ByteArrayOutputStream htmlString = creditosServicio.reporteObligacionesCG(creditos, nombRepObligacionesCG) ;
			
				response.addHeader("Content-Disposition","inline; filename=ObligacionesCreditoGrupal.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			if(creditos.getCalcInteresID().equals(caratContratInd)){
				ByteArrayOutputStream htmlString = creditosServicio.reporteCaratulaContratoInd(creditos, nombRepCaratContraInd) ;
			
				response.addHeader("Content-Disposition","inline; filename=CaratulaContratoInd.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			
			if(creditos.getCalcInteresID().equals(tFijaInd) ){
			
				ByteArrayOutputStream htmlString = creditosServicio.reportePagareTFInd(creditos, nombreReporteTFInd);
			
				response.addHeader("Content-Disposition","inline; filename=PagareTasaFija.pdf");
				response.setContentType("application/pdf");
											byte[] bytes = htmlString.toByteArray();
											response.getOutputStream().write(bytes,0,bytes.length);
											response.getOutputStream().flush();
											response.getOutputStream().close();
										}
							
			
										return null;	
			}
	

	public void setNombRepAmorticre(String nombRepAmorticre) {
		this.nombRepAmorticre = nombRepAmorticre;
	}
	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public void setNombreReporteTF(String nombreReporteTF) {
		this.nombreReporteTF = nombreReporteTF;
	}

	public void setNombreReporteTV(String nombreReporteTV) {
		this.nombreReporteTV = nombreReporteTV;
	}

	public void setNombreReporteTFGru(String nombreReporteTFGru) {
		this.nombreReporteTFGru = nombreReporteTFGru;
	}

	public void setNombRepClausuContra(String nombRepClausuContra){
		this.nombRepClausuContra = nombRepClausuContra ;
	}
 	
 	public void setNombRepCaratContra(String nombRepCaratContra){
 		this.nombRepCaratContra = nombRepCaratContra;
 	}

	public String getNombRepObligacionesCG() {
		return nombRepObligacionesCG;
	}

	public void setNombRepObligacionesCG(String nombRepObligacionesCG) {
		this.nombRepObligacionesCG = nombRepObligacionesCG;
	}

	public String getNombRepCaratContraInd() {
		return nombRepCaratContraInd;
	}

	public void setNombRepCaratContraInd(String nombRepCaratContraInd) {
		this.nombRepCaratContraInd = nombRepCaratContraInd;
	}

	public String getNombreReporteTFInd() {
		return nombreReporteTFInd;
	}

	public void setNombreReporteTFInd(String nombreReporteTFInd) {
		this.nombreReporteTFInd = nombreReporteTFInd;
	}

}
