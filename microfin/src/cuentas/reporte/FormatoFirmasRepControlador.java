package cuentas.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.ByteArrayOutputStream;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.CuentasFirmaBean;
import cuentas.servicio.CuentasFirmaServicio;

public class FormatoFirmasRepControlador extends AbstractCommandController{
	
	CuentasFirmaServicio cuentasFirmaServicio = null;
	String nombreReporte = null;
	String successView = null;		   
	
	public FormatoFirmasRepControlador() {
		setCommandClass(CuentasFirmaBean.class);
		setCommandName("cuentasFirma");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		CuentasFirmaBean cuentasFirmaBean = (CuentasFirmaBean) command;
		cuentasFirmaServicio.actualizarImprimirFirmas(cuentasFirmaBean, 1);
		ByteArrayOutputStream htmlString = cuentasFirmaServicio.reporteFormatoFirmas(cuentasFirmaBean, getNombreReporte());		
		
		
		response.addHeader("Content-Disposition","inline; filename=anexoPortada.pdf");
 		response.setContentType("application/pdf");
 		byte[] bytes = htmlString.toByteArray();
 		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();

 		return null;
		
	}

	public void setCuentasFirmaServicio(CuentasFirmaServicio cuentasFirmaServicio) {
		this.cuentasFirmaServicio = cuentasFirmaServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}	
	
	private String getNombreReporte() {
		return nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	private String getSuccessView() {
		return successView;
	}
	
	
	
	
}
