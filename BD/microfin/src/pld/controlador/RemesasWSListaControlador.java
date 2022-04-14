package pld.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.RemesasWSBean;
import pld.servicio.RemesasWSServicio;

public class RemesasWSListaControlador extends AbstractCommandController{
	
	RemesasWSServicio remesasWSServicio = null;
	
	public RemesasWSListaControlador() {
		setCommandClass(RemesasWSBean.class);
		setCommandName("remesasBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")): 0;
				
		String controlID = request.getParameter("controlID");
		
		RemesasWSBean remesasBean = (RemesasWSBean)command;
		
		List beanLis = remesasWSServicio.lista(tipoLista, remesasBean);
 
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(beanLis);
		
		return new ModelAndView("pld/remesasWSListaVista", "listaResultado",listaResultado);
		
	}
	
	// GETTER && SETTER
	public RemesasWSServicio getRemesasWSServicio() {
		return remesasWSServicio;
	}

	public void setRemesasWSServicio(RemesasWSServicio remesasWSServicio) {
		this.remesasWSServicio = remesasWSServicio;
	}

}
