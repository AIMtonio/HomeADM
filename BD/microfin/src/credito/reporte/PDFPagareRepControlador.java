package credito.reporte;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;
import contabilidad.bean.CuentasContablesBean;
import contabilidad.servicio.CuentasContablesServicio;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class PDFPagareRepControlador extends AbstractCommandController{

	CreditosServicio creditosServicio = null;

	ParamGeneralesServicio paramGeneralesServicio;

	String nombreReporteTF = null;
	String nombreReporteTV = null;	
	String nombreReporteTFGru= null;
	String nombRepAmorticre=null;
	String nombRepCaratContra=null;
	String nombRepClausuContra=null;
	String nombRepObligacionesCG=null;
	String nombRepCaratContraInd=null;
	String nombreReporteTFInd	=null;
	String nombreReportePagareSF	=null;
	String nombreReporteMIPYME	=null;
	String nombreReporteSolidario =null;
	String nombreReporteAgroHabGar =null;
	String nombreReporteAgroRefGar =null;
	String nombreReporteSolidarioLineaCre =null;
	String nombreReporteAnexosContrato =null;
	String nombreReportePagareSOFINI = null;
	String nombreReporteContratoSOFINI = null;
	String nombreReporteCaratulaAsefimex = null;
	String nombreReportePresentacionAsefimex = null;
	String nombreReporteAmortizacionAsefimex = null;
	String nombreReporteContAse = null;
	
	
	public PDFPagareRepControlador(){
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		CreditosBean creditos = (CreditosBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));

		int tipoActualizacion = Utileria.convierteEntero(request.getParameter("tipoActualizacion"));
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		String referenciaPay =request.getParameter("refPayCas")!=null? request.getParameter("refPayCas"):"";

		MensajeTransaccionBean mensaje = null;
		mensaje=creditosServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, creditos,request);
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
		int PagareGrupalStaFe = 4;
		int PagareIndStaFe	= 0;
		int CoYAne = 1;
		
		// Atributos para el cliente Santa Fe
		int numConCliProEspecifico = 13;
		String cliProSantaFe = "29";
		String proMiPyME = "3000";
		String proSolidario1= "1000";
		String proSolidario2= "1001";
		String proSolidario3= "1002";
		String proAgroHabGar1= "2000";
		String proAgroHabGar2= "2001";
		String proAgroRefGar1= "2002";
		String proAgroRefGar2= "2003";
		String proSolidarioLineaCre1= "4000";
		String proSolidarioLineaCre2= "4001";
		String anexosContratoSantaFe = "11";
		
		int pagareTamazula = 12;
		int pagareSOFINI = 13;
		int contratoSOFINI = 14;
		
		int caratulaAsefimex = 15;
		int presentacionAsefimex=16;
		int amortizacionAsefimex = 17;
		int ContratoUnicoAse	= 18;
		
		//CONSULTA Numero de Cliente para Procesos Especificos
		ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
		paramGeneralesBean = paramGeneralesServicio.consulta(numConCliProEspecifico, paramGeneralesBean);
		if(creditos.getNumProducCre() == null){
			creditos.setNumProducCre("0");
		}
		if(creditos.getCalcInteresID() == null){
			System.out.println("nullo CalcInteres");
			creditos.setCalcInteresID("0");
		}
		
		if(paramGeneralesBean.getValorParametro().equals(cliProSantaFe)){
			if(creditos.getNumProducCre().equals(proMiPyME)){				
					ByteArrayOutputStream htmlString = creditosServicio.reporteCaratulaContratoSantaFe(creditos, nombreReporteMIPYME, "");
					
					response.addHeader("Content-Disposition","inline; filename=CaratulaContraMIPYME.pdf");
					response.setContentType("application/pdf");
					byte[] bytes = htmlString.toByteArray();
					response.getOutputStream().write(bytes,0,bytes.length);
					response.getOutputStream().flush();
					response.getOutputStream().close();
				
			}
			
			if((creditos.getNumProducCre().equals(proSolidario1) || creditos.getNumProducCre().equals(proSolidario2) || creditos.getNumProducCre().equals(proSolidario3))){
				if(tipoReporte != CoYAne ){
					ByteArrayOutputStream htmlString = creditosServicio.reporteCaratulaContratoSantaFe(creditos, nombreReporteSolidario, "");
					
					response.addHeader("Content-Disposition","inline; filename=CaratulaContraSolidario.pdf");
					response.setContentType("application/pdf");
					byte[] bytes = htmlString.toByteArray();
					response.getOutputStream().write(bytes,0,bytes.length);
					response.getOutputStream().flush();
					response.getOutputStream().close();
				}
			}
			
			if((creditos.getNumProducCre().equals(proAgroHabGar1) || creditos.getNumProducCre().equals(proAgroHabGar2))){
					ByteArrayOutputStream htmlString = creditosServicio.reporteCaratulaContratoSantaFe(creditos, nombreReporteAgroHabGar, "");

					response.addHeader("Content-Disposition","inline; filename=CaratulaContraAgroHabiGar.pdf");
					response.setContentType("application/pdf");
					byte[] bytes = htmlString.toByteArray();
					response.getOutputStream().write(bytes,0,bytes.length);
					response.getOutputStream().flush();
					response.getOutputStream().close();
				
			}

			if((creditos.getNumProducCre().equals(proAgroRefGar1) || creditos.getNumProducCre().equals(proAgroRefGar2))){ 
					ByteArrayOutputStream htmlString = creditosServicio.reporteCaratulaContratoSantaFe(creditos, nombreReporteAgroRefGar, "");

					response.addHeader("Content-Disposition","inline; filename=CaratulaContraAgroRefGar.pdf");
					response.setContentType("application/pdf");
					byte[] bytes = htmlString.toByteArray();
					response.getOutputStream().write(bytes,0,bytes.length);
					response.getOutputStream().flush();
					response.getOutputStream().close();
				
			}
			
			if((creditos.getNumProducCre().equals(proSolidarioLineaCre1) || creditos.getNumProducCre().equals(proSolidarioLineaCre2))&& tipoReporte != CoYAne){
				
					ByteArrayOutputStream htmlString = creditosServicio.reporteCaratulaContratoSantaFe(creditos, nombreReporteSolidarioLineaCre, "");

					response.addHeader("Content-Disposition","inline; filename=CaratulaContraSolidarioLineaCre.pdf");
					response.setContentType("application/pdf");
					byte[] bytes = htmlString.toByteArray();
					response.getOutputStream().write(bytes,0,bytes.length);
					response.getOutputStream().flush();
					response.getOutputStream().close();
				
			}
			
			if(creditos.getCalcInteresID().equals(tablaAmort) && tipoReporte != CoYAne ){

				ByteArrayOutputStream htmlString = creditosServicio.reportePagareTFPDF(creditos, nombRepAmorticre);

				response.addHeader("Content-Disposition","inline; filename=tablaAmortizacion.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			
			if(tipoReporte == CoYAne){	



			ByteArrayOutputStream htmlString = creditosServicio.reporteCaratulaContratoSantaFe(creditos, nombreReporteAnexosContrato, referenciaPay);

					response.addHeader("Content-Disposition","inline; filename=AnexosContratos.pdf");
					response.setContentType("application/pdf");
					byte[] bytes = htmlString.toByteArray();
					response.getOutputStream().write(bytes,0,bytes.length);
					response.getOutputStream().flush();
					response.getOutputStream().close();
			}
			
			// Pagare especifico para Santa Fe
			if(tipoReporte == PagareGrupalStaFe || tipoReporte == PagareIndStaFe ){			
				ByteArrayOutputStream htmlString = creditosServicio.reportePagareSF(paramGeneralesBean.getValorParametro(),creditos, tipoReporte, nombreReportePagareSF);

				response.addHeader("Content-Disposition","inline; filename=PagareSF.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
		}else{// Si no realiza el proceso normal
			if(creditos.getCalcInteresID().equals(tf ) ){
				System.out.println("entro la primera opción");
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

			System.out.println("creditos.getCalcInteresID(): "+creditos.getCalcInteresID());
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

			if(tipoReporte == pagareTamazula){
				ByteArrayOutputStream htmlString = creditosServicio.reportePagare(creditos, nombreReporteTF);
				response.addHeader("Content-Disposition","inline; filename=PagareCredito"+creditos.getCreditoID().trim()+".pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}

			if(tipoReporte == pagareSOFINI){
				ByteArrayOutputStream htmlString = creditosServicio.reportePagareSOFINI(creditos, nombreReportePagareSOFINI);
				
				response.addHeader("Content-Disposition","inline; filename=Pagare.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			if(tipoReporte == contratoSOFINI){
				ByteArrayOutputStream htmlString = creditosServicio.reporteContratoSOFINI(creditos, nombreReporteContratoSOFINI);
				response.addHeader("Content-Disposition","inline; filename=Contrato.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			if(tipoReporte == caratulaAsefimex){
				ByteArrayOutputStream htmlString = creditosServicio.reporteCaratulaAsefimex(creditos, nombreReporteCaratulaAsefimex);
				response.addHeader("Content-Disposition","inline; filename=CaratulaContratoIndiv.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			if(tipoReporte == presentacionAsefimex){
				ByteArrayOutputStream htmlString = creditosServicio.reportePresentacionCreditoAsefimex(creditos, nombreReportePresentacionAsefimex);
				response.addHeader("Content-Disposition","inline; filename=PresentacionCred.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			if(tipoReporte == amortizacionAsefimex){
				ByteArrayOutputStream htmlString = creditosServicio.reporteAmortizacionAsefimex(creditos, nombreReporteAmortizacionAsefimex);
				response.addHeader("Content-Disposition","inline; filename=Amortizacion.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			if(tipoReporte == ContratoUnicoAse){
				ByteArrayOutputStream htmlString = creditosServicio.reporteContratoAsefimex(creditos, nombreReporteContAse);
				response.addHeader("Content-Disposition","inline; filename=Amortizacion.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
			
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

	public String getNombreReporteMIPYME() {
		return nombreReporteMIPYME;
	}

	public void setNombreReporteMIPYME(String nombreReporteMIPYME) {
		this.nombreReporteMIPYME = nombreReporteMIPYME;
	}
	public String getNombreReporteSolidario() {
		return nombreReporteSolidario;
	}

	public void setNombreReporteSolidario(String nombreReporteSolidario) {
		this.nombreReporteSolidario = nombreReporteSolidario;
	}

	public String getNombreReporteAgroHabGar() {
		return nombreReporteAgroHabGar;
	}

	public void setNombreReporteAgroHabGar(String nombreReporteAgroHabGar) {
		this.nombreReporteAgroHabGar = nombreReporteAgroHabGar;
	}

	public String getNombreReporteAgroRefGar() {
		return nombreReporteAgroRefGar;
	}

	public void setNombreReporteAgroRefGar(String nombreReporteAgroRefGar) {
		this.nombreReporteAgroRefGar = nombreReporteAgroRefGar;
	}

	public String getNombreReporteSolidarioLineaCre() {
		return nombreReporteSolidarioLineaCre;
	}

	public void setNombreReporteSolidarioLineaCre(
			String nombreReporteSolidarioLineaCre) {
		this.nombreReporteSolidarioLineaCre = nombreReporteSolidarioLineaCre;
	}

	public String getNombreReporteAnexosContrato() {
		return nombreReporteAnexosContrato;
	}

	public void setNombreReporteAnexosContrato(String nombreReporteAnexosContrato) {
		this.nombreReporteAnexosContrato = nombreReporteAnexosContrato;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public String getNombreReportePagareSF() {
		return nombreReportePagareSF;
	}

	public void setNombreReportePagareSF(String nombreReportePagareSF) {
		this.nombreReportePagareSF = nombreReportePagareSF;
	}

	public String getNombreReportePagareSOFINI() {
		return nombreReportePagareSOFINI;
	}

	public void setNombreReportePagareSOFINI(String nombreReportePagareSOFINI) {
		this.nombreReportePagareSOFINI = nombreReportePagareSOFINI;
	}

	public String getNombreReporteContratoSOFINI() {
		return nombreReporteContratoSOFINI;
	}

	public void setNombreReporteContratoSOFINI(String nombreReporteContratoSOFINI) {
		this.nombreReporteContratoSOFINI = nombreReporteContratoSOFINI;
	}

	public String getNombreReporteCaratulaAsefimex() {
		return nombreReporteCaratulaAsefimex;
	}

	public void setNombreReporteCaratulaAsefimex(
			String nombreReporteCaratulaAsefimex) {
		this.nombreReporteCaratulaAsefimex = nombreReporteCaratulaAsefimex;
	}

	public String getNombreReportePresentacionAsefimex() {
		return nombreReportePresentacionAsefimex;
	}

	public void setNombreReportePresentacionAsefimex(
			String nombreReportePresentacionAsefimex) {
		this.nombreReportePresentacionAsefimex = nombreReportePresentacionAsefimex;
	}

	public String getNombreReporteAmortizacionAsefimex() {
		return nombreReporteAmortizacionAsefimex;
	}

	public void setNombreReporteAmortizacionAsefimex(
			String nombreReporteAmortizacionAsefimex) {
		this.nombreReporteAmortizacionAsefimex = nombreReporteAmortizacionAsefimex;
	}

	public String getNombreReporteContAse() {
		return nombreReporteContAse;
	}

	public void setNombreReporteContAse(
			String nombreReporteContAse) {
		this.nombreReporteContAse = nombreReporteContAse;
	}
	
}
