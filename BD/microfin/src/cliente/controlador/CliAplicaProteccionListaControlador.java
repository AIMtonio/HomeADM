package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ProtecionAhorroCreditoBean;
import cliente.servicio.ProtectAhoCredServicio;

public class CliAplicaProteccionListaControlador extends AbstractCommandController{
	
	ProtectAhoCredServicio protectAhoCredServicio = null;
	
	public CliAplicaProteccionListaControlador() {
		setCommandClass(ProtecionAhorroCreditoBean.class);
		setCommandName("cliente");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ProtecionAhorroCreditoBean cliente = (ProtecionAhorroCreditoBean) command;
		List clientes =	protectAhoCredServicio.listaCliAplicaProteccion(tipoLista, cliente);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(clientes);
		return new ModelAndView("cliente/proteccionAhorroListaVista", "listaResultado",listaResultado);
	}

	//--------------- setter ----------------------
	public void setProtectAhoCredServicio(
			ProtectAhoCredServicio protectAhoCredServicio) {
		this.protectAhoCredServicio = protectAhoCredServicio;
	}


}
