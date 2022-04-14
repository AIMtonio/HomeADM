package buroCredito.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import java.util.ArrayList;
import java.util.List;

import buroCredito.bean.TipoInstitucionCirculoBean;
import buroCredito.servicio.TipoInstitucionCirculoServicio;

public class TipoInstitucionCirculoListaControlador extends
		AbstractCommandController {

	TipoInstitucionCirculoServicio tipoInstitucionCirculoServicio = null;
	
	public TipoInstitucionCirculoListaControlador() {
		setCommandClass(TipoInstitucionCirculoBean.class);
		setCommandName("tipoInstitucionCirculoBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		TipoInstitucionCirculoBean tipoInstitucionCirculoBean = (TipoInstitucionCirculoBean) command;
		List listaInstituciones = tipoInstitucionCirculoServicio.lista(tipoLista, tipoInstitucionCirculoBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaInstituciones);
		
		return new ModelAndView("buroCredito/tipoInstitucionCirculoListaVista", "listaResultado", listaResultado);
	}

	public TipoInstitucionCirculoServicio getTipoInstitucionCirculoServicio() {
		return tipoInstitucionCirculoServicio;
	}

	public void setTipoInstitucionCirculoServicio(
			TipoInstitucionCirculoServicio tipoInstitucionCirculoServicio) {
		this.tipoInstitucionCirculoServicio = tipoInstitucionCirculoServicio;
	}
	
}
