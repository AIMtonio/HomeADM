package cliente.controlador;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import cliente.bean.TiposDireccionBean;
import cliente.servicio.TiposDireccionServicio;



public class TiposDireccionListaControlador extends AbstractCommandController {
	TiposDireccionServicio tiposDireccionServicio = null;
	
	public TiposDireccionListaControlador() {
			setCommandClass(TiposDireccionBean.class);
			setCommandName("tiposdirecciones");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	TiposDireccionBean tiposdirec = (TiposDireccionBean) command;
	List direcciones =	tiposDireccionServicio.lista(tipoLista, tiposdirec);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(direcciones);
			
	return new ModelAndView("cliente/tiposDirecListaVista", "listaResultado", listaResultado);
	}
	
	public void setTiposDireccionServicio(TiposDireccionServicio tiposDireccionServicio) {
		this.tiposDireccionServicio = tiposDireccionServicio;
	}
		
		
	
}


