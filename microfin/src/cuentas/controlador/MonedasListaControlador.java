package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.MonedasBean;
import cuentas.servicio.MonedasServicio;

public class MonedasListaControlador extends AbstractCommandController{

	
	MonedasServicio monedasServicio = null;
		
	public MonedasListaControlador() {
			setCommandClass(MonedasBean.class);
			setCommandName("monedas");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	MonedasBean moneda = (MonedasBean) command;
	List monedas =	monedasServicio.lista(tipoLista, moneda);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(monedas);
			
	return new ModelAndView("cuentas/monedasListaVista", "listaResultado", listaResultado);
	}

	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}
		
		
	
}
