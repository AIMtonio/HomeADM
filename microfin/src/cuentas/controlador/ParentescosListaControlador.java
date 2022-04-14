package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.ParentescosBean;
import cuentas.servicio.ParentescosServicio;

public class ParentescosListaControlador extends AbstractCommandController{

	ParentescosServicio parentescosServicio = null;
		
	public ParentescosListaControlador() {
		setCommandClass(ParentescosBean.class);
		setCommandName("parentescos");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	ParentescosBean parentescosB = (ParentescosBean) command;
	List parentescos =	parentescosServicio.lista(tipoLista, parentescosB);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(parentescos);
			
	return new ModelAndView("cuentas/parentescosListaVista", "listaResultado", listaResultado);
	}

	public void setParentescosServicio(ParentescosServicio parentescosServicio) {
		this.parentescosServicio = parentescosServicio;
	}	
	
}
