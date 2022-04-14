package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.servicio.ProtectAhoCredServicio;
import cliente.bean.ProtecionAhorroCreditoBean;

public class ProtecAhorroGridControlador extends AbstractCommandController{
	ProtectAhoCredServicio protectAhoCredServicio = null;
	
	public ProtecAhorroGridControlador() {
		setCommandClass(ProtecionAhorroCreditoBean.class);
		setCommandName("creditosBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		ProtecionAhorroCreditoBean creditos = (ProtecionAhorroCreditoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
		List lista = protectAhoCredServicio.listaProteccionCuenta(tipoLista, creditos);		
			
		List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(lista);
        
		return new ModelAndView("cuentas/proteccionAhorroGridVista", "listaResultado", listaResultado);			
	}

	public ProtectAhoCredServicio getProtectAhoCredServicio() {
		return protectAhoCredServicio;
	}

	public void setProtectAhoCredServicio(
			ProtectAhoCredServicio protectAhoCredServicio) {
		this.protectAhoCredServicio = protectAhoCredServicio;
	}
}
