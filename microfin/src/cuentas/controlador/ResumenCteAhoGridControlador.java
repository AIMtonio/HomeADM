package cuentas.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;



public class ResumenCteAhoGridControlador extends AbstractCommandController {
	CuentasAhoServicio cuentasAhoServicio = null;
	

	public ResumenCteAhoGridControlador() {
		setCommandClass(CuentasAhoBean.class);
		setCommandName("resumenCte");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		CuentasAhoBean ctaAho = (CuentasAhoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List resumenCteAhoList =	cuentasAhoServicio.lista(tipoLista, ctaAho);
		
		
				
		return new ModelAndView("cuentas/resumenCteGridVista", "resumenCte", resumenCteAhoList);
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}
	

}
