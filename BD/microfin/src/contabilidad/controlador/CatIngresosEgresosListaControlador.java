package contabilidad.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.CatIngresosEgresosBean;
import contabilidad.servicio.CatIngresosEgresosServicio;

public class CatIngresosEgresosListaControlador extends AbstractCommandController {
	
	CatIngresosEgresosServicio	catIngresosEgresosServicio	= null;
	
	public CatIngresosEgresosListaControlador() {
		setCommandClass(CatIngresosEgresosBean.class);
		setCommandName("catListaIngresosEgresos");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CatIngresosEgresosBean catTipoListaIngresosEgresosBean = (CatIngresosEgresosBean) command;
		List<CatIngresosEgresosBean> catListaIngresosEgresosBeanList = catIngresosEgresosServicio.lista(tipoLista, catTipoListaIngresosEgresosBean);
		
		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(catListaIngresosEgresosBeanList);
		return new ModelAndView("contabilidad/catIngresosEgresosListaVista", "listaResultado", listaResultado);
	}

	public CatIngresosEgresosServicio getCatIngresosEgresosServicio() {
		return catIngresosEgresosServicio;
	}

	public void setCatIngresosEgresosServicio(
			CatIngresosEgresosServicio catIngresosEgresosServicio) {
		this.catIngresosEgresosServicio = catIngresosEgresosServicio;
	}
	
	
	
}
