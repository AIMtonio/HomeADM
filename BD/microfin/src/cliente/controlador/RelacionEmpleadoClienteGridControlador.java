package cliente.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.RelacionEmpleadoClienteBean;
import cliente.servicio.RelacionEmpleadoClienteServicio;


public class RelacionEmpleadoClienteGridControlador extends AbstractCommandController{

	RelacionEmpleadoClienteServicio relacionEmpleadoClienteServicio= null;
	
	public RelacionEmpleadoClienteGridControlador() {
		setCommandClass(RelacionEmpleadoClienteBean.class);
		setCommandName("relacionesCliente");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		RelacionEmpleadoClienteBean relacionesCliente = (RelacionEmpleadoClienteBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List relacionesClienteList = relacionEmpleadoClienteServicio.lista(tipoLista, relacionesCliente);
		return new ModelAndView("cliente/relacionEmpleadoClienteGridVista", "relacionesCliente", relacionesClienteList);
	}

	public RelacionEmpleadoClienteServicio getRelacionEmpleadoClienteServicio() {
		return relacionEmpleadoClienteServicio;
	}

	public void setRelacionEmpleadoClienteServicio(RelacionEmpleadoClienteServicio relacionEmpleadoClienteServicio) {
		this.relacionEmpleadoClienteServicio = relacionEmpleadoClienteServicio;
	}

	
}
