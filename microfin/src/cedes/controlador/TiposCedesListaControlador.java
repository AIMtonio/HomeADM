package cedes.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cedes.bean.TiposCedesBean;
import cedes.servicio.TiposCedesServicio;

public class TiposCedesListaControlador extends AbstractCommandController{
	
	TiposCedesServicio tiposCedesServicio = null;
	
	public TiposCedesListaControlador() {
		setCommandClass(TiposCedesBean.class);
		setCommandName("tiposedesBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		TiposCedesBean tiposCedesBean = (TiposCedesBean) command;
		List tiposCedes =	tiposCedesServicio.lista(tipoLista, tiposCedesBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(tiposCedes);
		
		return new ModelAndView("cedes/tiposCedesListaVista", "listaResultado",listaResultado);
	}

	public TiposCedesServicio getTiposCedesServicio() {
		return tiposCedesServicio;
	}

	public void setTiposCedesServicio(TiposCedesServicio tiposCedesServicio) {
		this.tiposCedesServicio = tiposCedesServicio;
	}
	
} 
