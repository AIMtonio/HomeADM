package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ProtecionAhorroCreditoBean;
import cliente.servicio.ProtectAhoCredServicio;


public class ProteccionAhorroGridVistaControlador extends AbstractCommandController{
	
	ProtectAhoCredServicio protectAhoCredServicio = null;
	public ProteccionAhorroGridVistaControlador() {
		setCommandClass(ProtecionAhorroCreditoBean.class);
		setCommandName("protecionAhorroCreditoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  						HttpServletResponse response,
			  						Object command,
			  						BindException errors) throws Exception {
		
		ProtecionAhorroCreditoBean ctaAho = (ProtecionAhorroCreditoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaProtec =	protectAhoCredServicio.listaProteccionCuenta(tipoLista, ctaAho);

		List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(listaProtec);
	        
		return new ModelAndView("cuentas/proteccionAhorroGridVista", "listaResultado", listaResultado);
	}

	//---------------setter------------
	public ProtectAhoCredServicio getProtectAhoCredServicio() {
		return protectAhoCredServicio;
	}

	public void setProtectAhoCredServicio(
			ProtectAhoCredServicio protectAhoCredServicio) {
		this.protectAhoCredServicio = protectAhoCredServicio;
	}
}
