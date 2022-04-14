package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;



public class SaldoBloqGridControlador extends AbstractCommandController {
	CuentasAhoServicio cuentasAhoServicio = null;
	

	public SaldoBloqGridControlador() {
		setCommandClass(CuentasAhoBean.class);
		setCommandName("resumenCte");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		CuentasAhoBean ctaAho = (CuentasAhoBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List resumenCteAhoList =	cuentasAhoServicio.lista(tipoLista, ctaAho);
		List listaResultado = (List)new ArrayList();
		
		listaResultado.add(tipoTransaccion);
		listaResultado.add(resumenCteAhoList);
				
		return new ModelAndView("cuentas/saldoBloqClienteGrid",  "listaResultado", listaResultado);
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}
	

}
