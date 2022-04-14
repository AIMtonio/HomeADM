package cuentas.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;

import cuentas.bean.RepAportaSocioMovBean;
import cuentas.servicio.AportacionSocioServicio;

public class AportaSocioMovRepControlador extends AbstractCommandController {

	AportacionSocioServicio aportacionSocioServicio = null;
	String nombreReporte = null;
	String successView = null;	

	public AportaSocioMovRepControlador() {
		setCommandClass(RepAportaSocioMovBean.class);
		setCommandName("RepAportaSocioMovBean");
	}
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		}
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		RepAportaSocioMovBean repAportaSocioMov = (RepAportaSocioMovBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):
		0;
			
	String htmlString= "";
			
		switch(tipoReporte){
			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = AportacionSocioRepPDF(repAportaSocioMov, nombreReporte, response);
			break;
		}
		
		if(tipoReporte == CreditosBean.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
			
	}

	public ByteArrayOutputStream AportacionSocioRepPDF(RepAportaSocioMovBean repAportaSocioMovBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = aportacionSocioServicio.repCertificadoAportaPDF(repAportaSocioMovBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=CertificadoDeAportacion.pdf");
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

	public void setAportacionSocioServicio(
			AportacionSocioServicio aportacionSocioServicio) {
		this.aportacionSocioServicio = aportacionSocioServicio;
	}


}
