package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;


public class ResumenClienteControlador extends AbstractCommandController{
	
	ClienteServicio clienteServicio = null;
	
	public ResumenClienteControlador() {
		setCommandClass(ClienteBean.class);
		setCommandName("clientes");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		ClienteBean cliente = (ClienteBean) command;
		
		return new ModelAndView("cliente/resumenClienteVista", "cliente", cliente);
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}

	
}
