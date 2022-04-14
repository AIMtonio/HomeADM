package cedes.controlador;

import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cedes.bean.CedesBean;
import cedes.servicio.CedesServicio;

public class ResumenCteCedeGridControlador extends AbstractCommandController{
	CedesServicio cedesServicio = null;

	public ResumenCteCedeGridControlador() {
		setCommandClass(CedesBean.class);
		setCommandName("resumCteCede");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		CedesBean cede = (CedesBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List resumenCteCedeList = cedesServicio.lista(tipoLista, cede);
		
		return new ModelAndView("cedes/resumenCteCedeGridVista","resumenCteCede",resumenCteCedeList);
		
	}

	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}

	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
	}

 

	
	
}
