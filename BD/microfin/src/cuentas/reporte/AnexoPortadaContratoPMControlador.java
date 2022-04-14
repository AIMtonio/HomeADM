package cuentas.reporte;

import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteBean;

import cuentas.bean.CuentasFirmaBean;
import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.CuentasAhoServicio;
import cuentas.servicio.CuentasFirmaServicio;

public class AnexoPortadaContratoPMControlador extends AbstractCommandController{
	
	CuentasAhoServicio cuentasAhoServicio = null;
	String nombreReporteAnexoPM = null;
	String successView = null;		   
	
	public AnexoPortadaContratoPMControlador() {
		setCommandClass(CuentasPersonaBean.class);
		setCommandName("ctasPersonaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

	
		
		CuentasPersonaBean ctasPerBean = (CuentasPersonaBean) command;

		
		String htmlString = "";
	
			htmlString = cuentasAhoServicio.anexoPortadaContratoCtaPF(ctasPerBean, nombreReporteAnexoPM);
		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
		
	}

	


	public String getNombreReporteAnexoPM() {
		return nombreReporteAnexoPM;
	}

	public void setNombreReporteAnexoPM(String nombreReporteAnexoPM) {
		this.nombreReporteAnexoPM = nombreReporteAnexoPM;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	private String getSuccessView() {
		return successView;
	}
	
	
	
	
}

