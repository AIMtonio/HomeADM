package cliente.controlador;
import herramientas.Constantes;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;


import cliente.bean.ClienteArchivosBean;
import cliente.servicio.ClienteArchivosServicio;;


public class ClienteArchivosGridControlador extends AbstractCommandController {
	ClienteArchivosServicio clienteArchivosServicio = null;
	

	public ClienteArchivosGridControlador() {
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
				
		return new ModelAndView("cliente/clienteArchivosGridVista", "clienteArchivo", clienteArchivoList);
	}

	public ClienteArchivosServicio getClienteArchivosServicio() {
		return clienteArchivosServicio;
	}

	public void setClienteArchivosServicio(
			ClienteArchivosServicio clienteArchivosServicio) {
		this.clienteArchivosServicio = clienteArchivosServicio;
	}
	
		
}
