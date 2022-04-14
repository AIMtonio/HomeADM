package cliente.controlador;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import cliente.bean.DireccionesClienteBean;
import cliente.servicio.DireccionesClienteServicio;


public class DireccionesClienteListaControlador extends AbstractCommandController{
	
	DireccionesClienteServicio direccionesclienteServicio = null;
	
	public DireccionesClienteListaControlador() {
		setCommandClass(DireccionesClienteBean.class);
		setCommandName("direcClientes");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		DireccionesClienteBean direccionescliente = (DireccionesClienteBean) command;
		List direccionesclientes =	direccionesclienteServicio.lista(tipoLista, direccionescliente);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(direccionesclientes);
		
		return new ModelAndView("cliente/direccionesClienteListaVista", "listaResultado",listaResultado);
	}

	public void setDireccionesClienteServicio(DireccionesClienteServicio direccionesclienteServicio) {
		this.direccionesclienteServicio = direccionesclienteServicio;
	}
	
	
}
