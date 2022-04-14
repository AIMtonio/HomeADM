package ventanilla.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.CatalogoRemesasBean;
import ventanilla.servicio.CatalogoRemesasServicio;

public class CatalogoRemesadoraListaControlador extends AbstractCommandController {
	CatalogoRemesasServicio catalogoRemesasServicio = null;
	
	public CatalogoRemesadoraListaControlador(){
		setCommandClass(CatalogoRemesasBean.class);
		setCommandName("catalogoRemesasBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	String sucursalOrigen;
	CatalogoRemesasBean catalogoRemesas = (CatalogoRemesasBean) command;
	sucursalOrigen = request.getParameter("sucursalOrigen");
	List cajasVentanillaList = catalogoRemesasServicio.lista(tipoLista, catalogoRemesas);

	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(cajasVentanillaList);

	return new ModelAndView("ventanilla/catalogoRemesasListaVista", "listaResultado", listaResultado);
}

	public CatalogoRemesasServicio getCatalogoRemesasServicio() {
		return catalogoRemesasServicio;
	}

	public void setCatalogoRemesasServicio(
			CatalogoRemesasServicio catalogoRemesasServicio) {
		this.catalogoRemesasServicio = catalogoRemesasServicio;
	}

	
	
	
}