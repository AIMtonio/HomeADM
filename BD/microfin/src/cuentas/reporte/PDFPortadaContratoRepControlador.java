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

import cuentas.bean.CuentasFirmaBean;
import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.CuentasAhoServicio;
import cuentas.servicio.CuentasFirmaServicio;

public class PDFPortadaContratoRepControlador extends AbstractCommandController{

	CuentasAhoServicio cuentasAhoServicio = null;
	CuentasFirmaServicio cuentasFirmaServicio = null;
	String nombreReportePF = null;
	String nombreReportePM = null;
	String nombreReporteME = null;
	String successView = null;	

 	public PDFPortadaContratoRepControlador(){
 		setCommandClass(CuentasPersonaBean.class);
 		setCommandName("ctasPersonaBean");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		String vacio="";
		String tp = (request.getParameter("tipoPersona")!=null)?
				(request.getParameter("tipoPersona")):vacio;
		ByteArrayOutputStream htmlString =null;
		
		CuentasPersonaBean ctasPerBean = (CuentasPersonaBean) command;
		CuentasFirmaBean cuentasFirmaBean = new CuentasFirmaBean();
		cuentasFirmaBean.setCuentaAhoID(ctasPerBean.getCuentaAhoID());
		
		
		cuentasFirmaServicio.actualizarImprimirFirmas(cuentasFirmaBean, 1);
		
		
		if(tp.equals(ClienteBean.PER_MORAL)){
			htmlString = cuentasAhoServicio.reportePortadaContratoCtaPMPDF(ctasPerBean, nombreReportePM);
		}else if(tp.equals(ClienteBean.MENOR_EDAD)){
			htmlString = cuentasAhoServicio.reportePortadaContratoCtaPFMENORPDF(ctasPerBean, nombreReporteME);
		}else{
				htmlString = cuentasAhoServicio.reportePortadaContratoCtaPFPDF(ctasPerBean, nombreReportePF);
			}
		
 		response.addHeader("Content-Disposition","inline; filename=portadaContrato.pdf");
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

	public void setNombreReportePF(String nombreReportePF) {
		this.nombreReportePF = nombreReportePF;
	}

	public void setNombreReportePM(String nombreReportePM) {
		this.nombreReportePM = nombreReportePM;
	}

	public void setNombreReporteME(String nombreReporteME) {
		this.nombreReporteME = nombreReporteME;
	}

	public CuentasFirmaServicio getCuentasFirmaServicio() {
		return cuentasFirmaServicio;
	}

	public void setCuentasFirmaServicio(CuentasFirmaServicio cuentasFirmaServicio) {
		this.cuentasFirmaServicio = cuentasFirmaServicio;
	}	

	
	
}
