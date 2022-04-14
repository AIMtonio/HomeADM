package cuentas.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.CuentasAhoServicio;

public class PDFAnexoPortadaContratoPMControlador extends AbstractCommandController{

	CuentasAhoServicio cuentasAhoServicio = null;
	String nombreReporteAnexoPM = null;   	

 	public PDFAnexoPortadaContratoPMControlador(){
 		setCommandClass(CuentasPersonaBean.class);
		setCommandName("ctasPersonaBean");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
 		
 		CuentasPersonaBean ctasPerBean = (CuentasPersonaBean) command;

 		ByteArrayOutputStream htmlString = cuentasAhoServicio.anexoPortadaContratoCtaPFPDF(ctasPerBean, nombreReporteAnexoPM);
 		
 		response.addHeader("Content-Disposition","inline; filename=anexoPortada.pdf");
 		response.setContentType("application/pdf");
 		byte[] bytes = htmlString.toByteArray();
 		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();

 		return null;
 	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	public void setNombreReporteAnexoPM(String nombreReporteAnexoPM) {
		this.nombreReporteAnexoPM = nombreReporteAnexoPM;
	}
	
}
