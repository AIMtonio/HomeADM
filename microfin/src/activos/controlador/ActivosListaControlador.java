package activos.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import activos.bean.ActivosBean;
import activos.servicio.ActivosServicio;

public class ActivosListaControlador extends AbstractCommandController{
	private ActivosServicio activosServicio = null;
	
	public ActivosListaControlador(){
		setCommandClass(ActivosBean.class);
		setCommandName("activosBean");		
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ActivosBean bean = (ActivosBean)command;
		List beanLis = activosServicio.lista(tipoLista, bean);
 
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(beanLis);
		
		return new ModelAndView("activos/activosListaVista", "listaResultado",listaResultado);
	}

	public ActivosServicio getActivosServicio() {
		return activosServicio;
	}

	public void setActivosServicio(ActivosServicio activosServicio) {
		this.activosServicio = activosServicio;
	}
}
