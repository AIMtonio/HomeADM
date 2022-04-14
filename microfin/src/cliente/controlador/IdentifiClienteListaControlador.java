package cliente.controlador;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.IdentifiClienteBean;
import cliente.servicio.IdentifiClienteServicio;



public class IdentifiClienteListaControlador extends AbstractCommandController {

	IdentifiClienteServicio identifiClienteServicio = null;
	
	public IdentifiClienteListaControlador() {
		setCommandClass(IdentifiClienteBean.class);
		setCommandName("identifiCliente");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		IdentifiClienteBean identifiCliente = (IdentifiClienteBean) command;
		List identCliente =	identifiClienteServicio.lista(tipoLista, identifiCliente);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(identCliente);
		
		return new ModelAndView("cliente/identifiClienteListaVista", "listaResultado",listaResultado);
	}

	public void setIdentifiClienteServicio(IdentifiClienteServicio identifiClienteServicio) {
		this.identifiClienteServicio = identifiClienteServicio;
	}
	
	
}
