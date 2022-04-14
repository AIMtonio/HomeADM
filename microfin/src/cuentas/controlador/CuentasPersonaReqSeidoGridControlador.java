package cuentas.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.CuentasPersonaServicio;

public class CuentasPersonaReqSeidoGridControlador  extends AbstractCommandController {
	CuentasPersonaServicio cuentasPersonaServicio = null;
	

	public CuentasPersonaReqSeidoGridControlador() {
		setCommandClass(CuentasPersonaBean.class);
		setCommandName("cuentasPersonaBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		CuentasPersonaBean CuentasPersona = (CuentasPersonaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	
		List lisCuentasPersona =cuentasPersonaServicio.lista(tipoLista, CuentasPersona); 
		return new ModelAndView("cuentas/cuentasPersonaReqSeidoGridVista", "cuentasPersona", lisCuentasPersona);
	}

	public CuentasPersonaServicio getCuentasPersonaServicio() {
		return cuentasPersonaServicio;
	}

	public void setCuentasPersonaServicio(
			CuentasPersonaServicio cuentasPersonaServicio) {
		this.cuentasPersonaServicio = cuentasPersonaServicio;
	}
	
}

