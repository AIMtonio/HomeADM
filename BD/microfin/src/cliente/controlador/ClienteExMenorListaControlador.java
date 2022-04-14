
package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.CliAplicaPROFUNBean;
import cliente.bean.ClienteExMenorBean;
import cliente.servicio.CliAplicaPROFUNServicio;
import cliente.servicio.ClienteExMenorServicio;

public class ClienteExMenorListaControlador extends AbstractCommandController {
	
	ClienteExMenorServicio clienteExMenorServicio = null;
	
	public ClienteExMenorListaControlador() {
		setCommandClass(ClienteExMenorBean.class);
		setCommandName("clienteExMenor");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ClienteExMenorBean clienteExMenor = (ClienteExMenorBean) command;
		List clienteExMenores =	clienteExMenorServicio.listaPrincipal(tipoLista, clienteExMenor);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(clienteExMenores);
		
		return new ModelAndView("cliente/clienteExMenorListaVista", "listaResultado",listaResultado);
	}

	public void setClienteExMenorServicio(
			ClienteExMenorServicio clienteExMenorServicio) {
		this.clienteExMenorServicio = clienteExMenorServicio;
	}
	
	
}


