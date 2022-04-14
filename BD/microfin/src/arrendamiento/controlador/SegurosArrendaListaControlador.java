package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.SegurosArrendaBean;
import arrendamiento.servicio.SegurosArrendaServicio;

public class SegurosArrendaListaControlador extends AbstractCommandController {
	
	SegurosArrendaServicio segurosArrendaServicio = null;
	
	public SegurosArrendaListaControlador() {
		setCommandClass(SegurosArrendaBean.class);
		setCommandName("segurosArrendaBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	SegurosArrendaBean producto = (SegurosArrendaBean) command;
	
	List lineaArrenda =	 segurosArrendaServicio.lista(tipoLista, producto);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(lineaArrenda);
			
	return new ModelAndView("arrendamiento/segurosArrendaListaVista", "listaResultado", listaResultado);
	}

	public SegurosArrendaServicio getSegurosArrendaServicio() {
		return segurosArrendaServicio;
	}

	public void setSegurosArrendaServicio(
			SegurosArrendaServicio segurosArrendaServicio) {
		this.segurosArrendaServicio = segurosArrendaServicio;
	}


	
}
