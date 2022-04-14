package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;

public class ClienteListaControlador extends AbstractCommandController{
	
	ClienteServicio clienteServicio = null;
	
	public ClienteListaControlador() {
		setCommandClass(ClienteBean.class);
		setCommandName("cliente");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ClienteBean cliente = (ClienteBean) command;
		List clientes =	clienteServicio.lista(tipoLista, cliente);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(clientes);
		
		return new ModelAndView("cliente/clienteListaVista", "listaResultado",listaResultado);
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}
	
	
}
