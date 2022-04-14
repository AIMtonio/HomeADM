package guardaValores.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.AbstractController;

import guardaValores.bean.CatalogoMovGuardaValoresBean;
import guardaValores.servicio.CatalogoMovGuardaValoresServicio;

public class CatalogoMovGuardaValoresListaControlador extends AbstractCommandController {

	CatalogoMovGuardaValoresServicio catalogoMovGuardaValoresServicio = null;
	
	public CatalogoMovGuardaValoresListaControlador() {
		setCommandClass(CatalogoMovGuardaValoresBean.class);
		setCommandName("catalogoMovGuardaValoresBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CatalogoMovGuardaValoresBean catalogoMovGuardaValoresBean = (CatalogoMovGuardaValoresBean) command;
		List listaCatalogoMovGuardaValoresBean = catalogoMovGuardaValoresServicio.lista(tipoLista, catalogoMovGuardaValoresBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaCatalogoMovGuardaValoresBean);
		
		return new ModelAndView("guardaValores/catalogoMovimientosListaVista", "listaResultado",listaResultado);
	}
	
	public CatalogoMovGuardaValoresServicio getCatalogoMovGuardaValoresServicio() {
		return catalogoMovGuardaValoresServicio;
	}
	
	public void setCatalogoMovGuardaValoresServicio(CatalogoMovGuardaValoresServicio catalogoMovGuardaValoresServicio) {
		this.catalogoMovGuardaValoresServicio = catalogoMovGuardaValoresServicio;
	}

}
