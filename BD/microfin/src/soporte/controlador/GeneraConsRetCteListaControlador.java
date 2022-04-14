package soporte.controlador;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.GeneraConstanciaRetencionBean;
import soporte.servicio.GeneraConsRetencionCteServicio;

public class GeneraConsRetCteListaControlador  extends AbstractCommandController{
	
	GeneraConsRetencionCteServicio generaConsRetencionCteServicio = null;
	
	public GeneraConsRetCteListaControlador() {
		setCommandClass(GeneraConstanciaRetencionBean.class);
		setCommandName("cliente");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		GeneraConstanciaRetencionBean cliente = (GeneraConstanciaRetencionBean) command;
		List clientes =	generaConsRetencionCteServicio.lista(tipoLista, cliente);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(clientes);
		
		return new ModelAndView("soporte/consRetCteListaVista", "listaResultado",listaResultado);
	}

	/* ============ SETTER's Y GETTER's =============== */
	public void setGeneraConsRetencionCteServicio(GeneraConsRetencionCteServicio generaConsRetencionCteServicio) {
		this.generaConsRetencionCteServicio = generaConsRetencionCteServicio;
	}

	public GeneraConsRetencionCteServicio getGeneraConsRetencionCteServicio() {
		return generaConsRetencionCteServicio;
	}
	
}