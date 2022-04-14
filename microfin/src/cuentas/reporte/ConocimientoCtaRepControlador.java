package cuentas.reporte;
import herramientas.Constantes;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;




import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.ConocimientoCtaServicio;
import cuentas.servicio.CuentasPersonaServicio;

public class ConocimientoCtaRepControlador extends SimpleFormController {

	ConocimientoCtaServicio conocimientoCtaServicio = null;
	String nombreReportePF = null;
	String nombreReportePM = null;

	public ConocimientoCtaRepControlador() {
		setCommandClass(CuentasPersonaBean.class);
		setCommandName("ctasPersonaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		CuentasPersonaBean ctasPerBean = (CuentasPersonaBean) command;
		String tipoPersona = (request.getParameter("tipoPersona")!=null)? (request.getParameter("tipoPersona")): Constantes.STRING_VACIO;
		String c = ctasPerBean.getCuentaAhoID();
		String htmlString = "";
		if(tipoPersona.equals(ClienteBean.PER_FISICA )){
			htmlString = conocimientoCtaServicio.reporteFormatoConocimientoCtaPF(ctasPerBean, nombreReportePF);
		}
		
		if(tipoPersona.equals(ClienteBean.PER_FISACTEMP )){
			htmlString = conocimientoCtaServicio.reporteFormatoConocimientoCtaPF(ctasPerBean, nombreReportePF);
		}
		
		if (tipoPersona.equals(ClienteBean.PER_MORAL )){
			htmlString = conocimientoCtaServicio.reporteFormatoConocimientoCtaPM(ctasPerBean, nombreReportePM);
		}
		return new ModelAndView(getSuccessView(), "reporte", htmlString);		
	}


	public void setNombreReportePF(String nombreReportePF) {
		this.nombreReportePF = nombreReportePF;
	}

	public void setNombreReportePM(String nombreReportePM) {
		this.nombreReportePM = nombreReportePM;
	}

	public void setConocimientoCtaServicio(
			ConocimientoCtaServicio conocimientoCtaServicio) {
		this.conocimientoCtaServicio = conocimientoCtaServicio;
	}

	
}

