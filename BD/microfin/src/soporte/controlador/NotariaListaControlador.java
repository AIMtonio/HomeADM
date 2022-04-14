package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.NotariaBean;
import soporte.servicio.NotariaServicio;

public class NotariaListaControlador extends AbstractCommandController {
	
	NotariaServicio notariaServicio = null;
	
	public NotariaListaControlador() {
		setCommandClass(NotariaBean.class);
		setCommandName("notaria");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	NotariaBean notaria = (NotariaBean) command;
	List notarias =	notariaServicio.lista(tipoLista, notaria);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(notarias);
			
	return new ModelAndView("soporte/notariaListaVista", "listaResultado", listaResultado);
	}

	public void setNotariaServicio(NotariaServicio notariaServicio) {
		this.notariaServicio = notariaServicio;
	}
	
}
