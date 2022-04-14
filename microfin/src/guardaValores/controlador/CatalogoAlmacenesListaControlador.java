package guardaValores.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import guardaValores.bean.CatalogoAlmacenesBean;
import guardaValores.servicio.CatalogoAlmacenesServicio;

public class CatalogoAlmacenesListaControlador extends AbstractCommandController {

	CatalogoAlmacenesServicio catalogoAlmacenesServicio = null;
	
	public CatalogoAlmacenesListaControlador() {
		setCommandClass(CatalogoAlmacenesBean.class);
		setCommandName("catalogoAlmacenesBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CatalogoAlmacenesBean catalogoAlmacenesBean = (CatalogoAlmacenesBean) command;
		List listaAlmancenesBean = catalogoAlmacenesServicio.lista(tipoLista, catalogoAlmacenesBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaAlmancenesBean);
		
		return new ModelAndView("guardaValores/catalogoAlmacenesListaVista", "listaResultado",listaResultado);
	}

	public CatalogoAlmacenesServicio getCatalogoAlmacenesServicio() {
		return catalogoAlmacenesServicio;
	}

	public void setCatalogoAlmacenesServicio(CatalogoAlmacenesServicio catalogoAlmacenesServicio) {
		this.catalogoAlmacenesServicio = catalogoAlmacenesServicio;
	}

}
