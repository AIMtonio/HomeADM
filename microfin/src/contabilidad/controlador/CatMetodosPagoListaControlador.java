package contabilidad.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.CatMetodosPagoBean;
import contabilidad.servicio.CatMetodosPagoServicio;


public class CatMetodosPagoListaControlador extends AbstractCommandController {
	
	CatMetodosPagoServicio	catMetodosPagoServicio	= null;
	
	public CatMetodosPagoListaControlador() {
		setCommandClass(CatMetodosPagoBean.class);
		setCommandName("catListaMetodosPago");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CatMetodosPagoBean catTipoListaMetodosPagoBean = (CatMetodosPagoBean) command;
		List<CatMetodosPagoBean> catListaMetodosPagoBeanList = catMetodosPagoServicio.lista(tipoLista, catTipoListaMetodosPagoBean);
		
		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(catListaMetodosPagoBeanList);
		return new ModelAndView("contabilidad/catMetodosPagoListaVista", "listaResultado", listaResultado);
	}

	public CatMetodosPagoServicio getCatMetodosPagoServicio() {
		return catMetodosPagoServicio;
	}

	public void setCatMetodosPagoServicio(
			CatMetodosPagoServicio catMetodosPagoServicio) {
		this.catMetodosPagoServicio = catMetodosPagoServicio;
	}


	
	
}
