package cuentas.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.CuentasAhoMovBean;
import cuentas.servicio.CuentasAhoMovServicio;

public class CuentasAhoMovGridInuControlador  extends AbstractCommandController {
	CuentasAhoMovServicio cuentasAhoMovServicio = null;
	

	public CuentasAhoMovGridInuControlador() {
		setCommandClass(CuentasAhoMovBean.class);
		setCommandName("cuentasAhoMovBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		CuentasAhoMovBean cuentasAhoMov = (CuentasAhoMovBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	
		List lisCuentasAhoMov =cuentasAhoMovServicio.lista(tipoLista, cuentasAhoMov); 
		return new ModelAndView("cuentas/cuentasAhoMovInuGridVista", "movcuentasaho", lisCuentasAhoMov);
	}

	public CuentasAhoMovServicio getCuentasAhoMovServicio() {
		return cuentasAhoMovServicio;
	}

	public void setCuentasAhoMovServicio(CuentasAhoMovServicio cuentasAhoMovServicio) {
		this.cuentasAhoMovServicio = cuentasAhoMovServicio;
	}


	
}

