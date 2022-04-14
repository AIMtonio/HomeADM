package cuentas.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;

import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.ConocimientoCtaServicio;
import cuentas.servicio.CuentasAhoServicio;

public class PDFConocimientoCtaRepControlador extends AbstractCommandController{

	ConocimientoCtaServicio conocimientoCtaServicio = null;
	String nombreReportePF = null;
	String nombreReportePM = null;

 	public PDFConocimientoCtaRepControlador(){
 		setCommandClass(CuentasPersonaBean.class);
		setCommandName("ctasPersonaBean");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
 		ByteArrayOutputStream htmlString = null;
 			
 		String vacio="";
		String tp = (request.getParameter("tipoPersona")!=null)?
				(request.getParameter("tipoPersona")):vacio;
	
		CuentasPersonaBean ctasPerBean = (CuentasPersonaBean) command;
		String c = ctasPerBean.getCuentaAhoID();

		
		if(tp.equals(ClienteBean.PER_FISICA ) ){
			htmlString = conocimientoCtaServicio.reporteFormatoConocimientoCtaPFPDF(ctasPerBean, nombreReportePF);
		}
		
		if(tp.equals(ClienteBean.PER_FISACTEMP )){
			htmlString = conocimientoCtaServicio.reporteFormatoConocimientoCtaPFPDF(ctasPerBean, nombreReportePF);
		}
		
		
		if(tp.equals(ClienteBean.PER_MORAL)){
			htmlString = conocimientoCtaServicio.reporteFormatoConocimientoCtaPMPDF(ctasPerBean, nombreReportePM);
		}
 		response.addHeader("Content-Disposition","inline; filename=conocimientoCta.pdf");
 		response.setContentType("application/pdf");
 		byte[] bytes = htmlString.toByteArray();
 		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();

 		return null;
 	}

	public void setConocimientoCtaServicio(
			ConocimientoCtaServicio conocimientoCtaServicio) {
		this.conocimientoCtaServicio = conocimientoCtaServicio;
	}

	public void setNombreReportePF(String nombreReportePF) {
		this.nombreReportePF = nombreReportePF;
	}

	public void setNombreReportePM(String nombreReportePM) {
		this.nombreReportePM = nombreReportePM;
	}
}
