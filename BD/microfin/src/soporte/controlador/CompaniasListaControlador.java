package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.CompaniasBean;
import soporte.servicio.CompaniasServicio;

public class CompaniasListaControlador extends AbstractCommandController{
	
	CompaniasServicio companiasServicio = null;
	
	public CompaniasListaControlador() {
		setCommandClass(CompaniasBean.class);
		setCommandName("compania");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CompaniasBean compania = (CompaniasBean) command;
		List clientes =	companiasServicio.lista(tipoLista, compania);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(clientes);
		
		return new ModelAndView("soporte/companiasListaVista", "listaResultado",listaResultado);
	}

	public CompaniasServicio getCompaniasServicio() {
		return companiasServicio;
	}

	public void setCompaniasServicio(CompaniasServicio companiasServicio) {
		this.companiasServicio = companiasServicio;
	}




	
	
}
