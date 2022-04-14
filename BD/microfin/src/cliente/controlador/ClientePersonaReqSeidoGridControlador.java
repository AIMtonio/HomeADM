package cliente.controlador;
import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;

public class ClientePersonaReqSeidoGridControlador  extends AbstractCommandController {
	ClienteServicio clienteServicio = null;
	

	public ClientePersonaReqSeidoGridControlador() {
		setCommandClass(ClienteBean.class);
		setCommandName("clienteBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		ClienteBean CuentasPersona = (ClienteBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	
		List lisClientesSeido =clienteServicio.lista(tipoLista, CuentasPersona); 
		return new ModelAndView("cliente/clientePersonaReqSeidoGridVista", "clientePersona", lisClientesSeido);
	}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}

	
}
