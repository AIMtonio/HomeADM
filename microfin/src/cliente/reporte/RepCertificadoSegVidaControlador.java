package cliente.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.reporte.EstimacionesCredPrevRepControlador.Enum_Con_TipRepor;

import cliente.bean.RepSeguroClienteBean;
import cliente.servicio.SeguroClienteServicio;

public class RepCertificadoSegVidaControlador extends AbstractCommandController{

	SeguroClienteServicio seguroClienteServicio = null;
	String nomReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		
		}
	public RepCertificadoSegVidaControlador () {
		setCommandClass(RepSeguroClienteBean.class);
		setCommandName("seguroClienteBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		RepSeguroClienteBean clienteBean = (RepSeguroClienteBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):
		0;
			
	String htmlString= "";
	switch(tipoReporte){
	
	case Enum_Con_TipRepor.ReporPDF:
		ByteArrayOutputStream htmlStringPDF = certificadoSeguroVidaRepPDF(clienteBean, nomReporte, response);
	break;
	}	
		return null;
		
	
			
	}
		
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream certificadoSeguroVidaRepPDF(RepSeguroClienteBean seguroClienteBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = seguroClienteServicio.creaRepCertificadoSegVidaPDF(seguroClienteBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=CertificadoDeSeguroVida.pdf");
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

	
	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}


	public void setSeguroClienteServicio(SeguroClienteServicio seguroClienteServicio) {
		this.seguroClienteServicio = seguroClienteServicio;
	}
	
}