package pld.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.ParametrosOpRelBean;
import pld.servicio.ParametrosOpRelServicio;

public class ParametrosOpTipoInstruControlador extends AbstractCommandController{
	ParametrosOpRelServicio parametrosOpRelServicio = null;
	String nombreReporte = null;
	String successView = null;	
	
	public ParametrosOpTipoInstruControlador(){
		setCommandClass(ParametrosOpRelBean.class);
		setCommandName("parametrosOpRel");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		// TODO Auto-generated method stub
		ParametrosOpRelBean parametrosOpRelBean =(ParametrosOpRelBean) command;
		String htmlString =parametrosOpRelServicio.reportesOpTipoInstrum(parametrosOpRelBean, getNombreReporte());

		return new ModelAndView(getSuccessView(), "reporte", htmlString);
		
	}

	public ParametrosOpRelServicio getParametrosOpRelServicio() {
		return parametrosOpRelServicio;
	}

	public void setParametrosOpRelServicio(ParametrosOpRelServicio parametrosOpRelServicio) {
		this.parametrosOpRelServicio = parametrosOpRelServicio;
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


}