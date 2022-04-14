package cliente.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteArchivosBean;
import cliente.servicio.ClienteArchivosServicio;

public class ClienteArchivosGridGeneralControlador extends AbstractCommandController {
	ClienteArchivosServicio clienteArchivosServicio = null;
	
	public ClienteArchivosGridGeneralControlador() {
		setCommandClass(ClienteArchivosBean.class);
		setCommandName("clienteArchivo");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		ClienteArchivosBean clientArchivo = (ClienteArchivosBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List clienteArchivoList =	clienteArchivosServicio.listaArchivosCliente(tipoLista, clientArchivo);
				
		return new ModelAndView("cliente/clienteArchivosGridGeneralVista", "clienteArchivo", clienteArchivoList);
	}

	public ClienteArchivosServicio getClienteArchivosServicio() {
		return clienteArchivosServicio;
	}

	public void setClienteArchivosServicio(
			ClienteArchivosServicio clienteArchivosServicio) {
		this.clienteArchivosServicio = clienteArchivosServicio;
	}
	
}
