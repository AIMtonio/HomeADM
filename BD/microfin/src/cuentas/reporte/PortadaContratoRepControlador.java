package cuentas.reporte;

import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cuentas.bean.CuentasAhoBean;
import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.CuentasAhoServicio;

public class PortadaContratoRepControlador extends AbstractCommandController {
	
	CuentasAhoServicio cuentasAhoServicio = null;
	String nombreReportePF = null;
	String nombreReportePM = null;
	String successView = null;	
	   
	
	public PortadaContratoRepControlador() {
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
		/*String tpm = (request.getParameter("tipoPersona2")!=null)?
				(request.getParameter("tipoPersona2")): vacio;
		*/
	
		
		CuentasPersonaBean ctasPerBean = (CuentasPersonaBean) command;
	
		
		String htmlString = "";
		
		if(tp.equals(ClienteBean.PER_FISICA ) ){
			htmlString = cuentasAhoServicio.reportePortadaContratoCtaPF(ctasPerBean, nombreReportePF);
		}
		
		if(tp.equals(ClienteBean.PER_MORAL)){
			htmlString = cuentasAhoServicio.reportePortadaContratoCtaPM(ctasPerBean, nombreReportePM);
		}
	
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
		
	}


	public void setNombreReportePF(String nombreReportePF) {
		this.nombreReportePF = nombreReportePF;
	}

	public void setNombreReportePM(String nombreReportePM) {
		this.nombreReportePM = nombreReportePM;
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


