package cuentas.controlador;

import herramientas.Constantes;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.CuentasPersonaServicio;

public class CuentasPersonaGridControlador extends AbstractCommandController{
		
	CuentasPersonaServicio cuentasPersonaServicio = null;

	public CuentasPersonaGridControlador() {
		setCommandClass(CuentasPersonaBean.class);
		setCommandName("cuentasPersona");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		CuentasPersonaBean cuentasPersona = (CuentasPersonaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List cuentasPersonaList =	cuentasPersonaServicio.lista(tipoLista, cuentasPersona);
		
		return new ModelAndView("cuentas/cuentasPersonaGridVista", "cuentasPersona", cuentasPersonaList);
	}
	
	
	public void setCuentasPersonaServicio(
			CuentasPersonaServicio cuentasPersonaServicio) {
		this.cuentasPersonaServicio = cuentasPersonaServicio;
	}

}
