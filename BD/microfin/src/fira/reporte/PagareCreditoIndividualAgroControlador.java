package fira.reporte;

import general.bean.MensajeTransaccionBean;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class PagareCreditoIndividualAgroControlador extends AbstractCommandController{
	
	CreditosServicio creditosServicio = null;
	String nombreReporteTV = null;	
	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	String nombRepAmorticre=null;
	String nombRepCaratContra=null;
	String nombreReporteAvio= null;
	String nombRepCaratContraInd=null;
	
	public PagareCreditoIndividualAgroControlador(){
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	@Override
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
								
								MensajeTransaccionBean mensaje = null;
								mensaje=creditosServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, creditos,request);
								
								String tf = "1";
								String tablaAmort="10";// reporte para tabla de AMORTICREDIO
								String caratContratInd="8";
								
								if(creditos.getCalcInteresID().equals(tf ) ){
									
									ByteArrayOutputStream htmlString = creditosServicio.reportePagareTF(creditos, nombreReporteAvio);
									
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

								if(creditos.getCalcInteresID().equals(caratContratInd)){
									ByteArrayOutputStream htmlString = creditosServicio.reporteCaratulaContratoInd(creditos, nombRepCaratContraInd) ;
								
									response.addHeader("Content-Disposition","inline; filename=CaratulaContratoInd.pdf");
									response.setContentType("application/pdf");
									byte[] bytes = htmlString.toByteArray();
									response.getOutputStream().write(bytes,0,bytes.length);
									response.getOutputStream().flush();
									response.getOutputStream().close();
								}
						

								return null;	
	}
	
	

	public String getNombreReporteTV() {
		return nombreReporteTV;
	}

	public void setNombreReporteTV(String nombreReporteTV) {
		this.nombreReporteTV = nombreReporteTV;
	}

	public String getNombRepAmorticre() {
		return nombRepAmorticre;
	}

	public void setNombRepAmorticre(String nombRepAmorticre) {
		this.nombRepAmorticre = nombRepAmorticre;
	}

	public String getNombRepCaratContra() {
		return nombRepCaratContra;
	}

	public void setNombRepCaratContra(String nombRepCaratContra) {
		this.nombRepCaratContra = nombRepCaratContra;
	}

	public String getNombreReporteAvio() {
		return nombreReporteAvio;
	}

	public void setNombreReporteAvio(String nombreReporteAvio) {
		this.nombreReporteAvio = nombreReporteAvio;
	}

	public String getNombRepCaratContraInd() {
		return nombRepCaratContraInd;
	}

	public void setNombRepCaratContraInd(String nombRepCaratContraInd) {
		this.nombRepCaratContraInd = nombRepCaratContraInd;
	}
	
}
