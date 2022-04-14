package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.SegurosVidaArrendaBean;
import arrendamiento.servicio.SegurosVidaArrendaServicio;


public class SegurosVidaArrendaListaControlador extends AbstractCommandController {
	
	SegurosVidaArrendaServicio segurosVidaArrendaServicio = null;
	
	public SegurosVidaArrendaListaControlador() {
		setCommandClass(SegurosVidaArrendaBean.class);
		setCommandName("segurosVidaArrendaBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	SegurosVidaArrendaBean producto = (SegurosVidaArrendaBean) command;
	
	List lineaArrenda =	 segurosVidaArrendaServicio.lista(tipoLista, producto);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(lineaArrenda);
			
	return new ModelAndView("arrendamiento/segurosVidaArrendaListaVista", "listaResultado", listaResultado);
	}

	public SegurosVidaArrendaServicio getSegurosVidaArrendaServicio() {
		return segurosVidaArrendaServicio;
	}

	public void setSegurosVidaArrendaServicio(
			SegurosVidaArrendaServicio segurosVidaArrendaServicio) {
		this.segurosVidaArrendaServicio = segurosVidaArrendaServicio;
	}
}
