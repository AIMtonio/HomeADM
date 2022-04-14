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

import cuentas.bean.CuentasFirmaBean;
import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.CuentasFirmaServicio;
import cuentas.servicio.CuentasPersonaServicio;

public class CuentasFirmaGridControlador extends AbstractCommandController{
		
	CuentasFirmaServicio cuentasFirmaServicio = null;

	public CuentasFirmaGridControlador() {
		setCommandClass(CuentasFirmaBean.class);
		setCommandName("cuentasFirma");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		CuentasFirmaBean cuentasFirmaBean = (CuentasFirmaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List cuentasPersonaList =cuentasFirmaServicio.lista(2, cuentasFirmaBean);
		
		return new ModelAndView("cuentas/cuentasFirmaGridVista", "cuentasFirma", cuentasPersonaList);
	}
	
	
	public void setCuentasFirmaServicio(
			CuentasFirmaServicio cuentasFirmaServicio) {
		this.cuentasFirmaServicio = cuentasFirmaServicio;
	}

}
