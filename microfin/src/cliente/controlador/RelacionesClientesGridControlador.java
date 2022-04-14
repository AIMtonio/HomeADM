package cliente.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.RelacionClienteEmpleadoBean;
import cliente.servicio.RelacionClienteEmpleadoServicio;

public class RelacionesClientesGridControlador extends AbstractCommandController{

	RelacionClienteEmpleadoServicio relacionClienteServicio= null;
	
	public RelacionesClientesGridControlador() {
		setCommandClass(RelacionClienteEmpleadoBean.class);
		setCommandName("relacionesCliente");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		RelacionClienteEmpleadoBean relacionesCliente = (RelacionClienteEmpleadoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List relacionesClienteList = relacionClienteServicio.lista(tipoLista, relacionesCliente);
		return new ModelAndView("cliente/relacionesClienteGridVista", "relacionesCliente", relacionesClienteList);
	}

	public RelacionClienteEmpleadoServicio getRelacionClienteServicio() {
		return relacionClienteServicio;
	}

	public void setRelacionClienteServicio(
			RelacionClienteEmpleadoServicio relacionClienteServicio) {
		this.relacionClienteServicio = relacionClienteServicio;
	}
}