
package cliente.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClientesCancelaBean;
import cliente.servicio.ClientesCancelaServicio;

public class PagoClientesCancelaRepControlador  extends AbstractCommandController{
	ClientesCancelaServicio clientesCancelaServicio = null;
	String nomReporteAtencion = null;
	String nomReporteCobranza = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  atencionSocio  = 1 ;
		  int  cobranza  = 2 ;
	}
	
	public PagoClientesCancelaRepControlador () {
		setCommandClass(ClientesCancelaBean.class);
		setCommandName("clientesCancelaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		ClientesCancelaBean bean = (ClientesCancelaBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)? Integer.parseInt(request.getParameter("tipoReporte")): 0;
		int numReporte =(request.getParameter("numReporte")!=null)? Integer.parseInt(request.getParameter("numReporte")): 0;
		ByteArrayOutputStream htmlStringPDF = null;
		switch(tipoReporte){	
			case Enum_Con_TipRepor.atencionSocio:
				htmlStringPDF = reportePagoSolPDF(tipoReporte,bean, nomReporteAtencion, response);
			break;
			case Enum_Con_TipRepor.cobranza:
				htmlStringPDF = reportePagoSolPDF(tipoReporte,bean, nomReporteCobranza, response);
			break;
		}
		return null;	
	}
	
	/* Reporte de apoyo escolar en PDF */
	public ByteArrayOutputStream reportePagoSolPDF(int tipoReporte,ClientesCancelaBean bean, String nomReportePago, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = clientesCancelaServicio.reportePagoSolicitudClientesCancela(tipoReporte,bean, nomReportePago);
			response.addHeader("Content-Disposition","inline; filename=PagoSolicitudCancela.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	return htmlStringPDF;
	}// reporte PDF
	
	

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}


	public ClientesCancelaServicio getClientesCancelaServicio() {
		return clientesCancelaServicio;
	}
	public void setClientesCancelaServicio(
			ClientesCancelaServicio clientesCancelaServicio) {
		this.clientesCancelaServicio = clientesCancelaServicio;
	}

	public String getNomReporteAtencion() {
		return nomReporteAtencion;
	}

	public void setNomReporteAtencion(String nomReporteAtencion) {
		this.nomReporteAtencion = nomReporteAtencion;
	}

	public String getNomReporteCobranza() {
		return nomReporteCobranza;
	}

	public void setNomReporteCobranza(String nomReporteCobranza) {
		this.nomReporteCobranza = nomReporteCobranza;
	}

	
}