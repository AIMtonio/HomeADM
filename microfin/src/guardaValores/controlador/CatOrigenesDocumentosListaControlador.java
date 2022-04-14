package guardaValores.controlador;

import guardaValores.bean.CatOrigenesDocumentosBean;
import guardaValores.servicio.CatOrigenesDocumentosServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class CatOrigenesDocumentosListaControlador extends AbstractCommandController {
	
	CatOrigenesDocumentosServicio catOrigenesDocumentosServicio = null;
	
	public CatOrigenesDocumentosListaControlador() {
		setCommandClass(CatOrigenesDocumentosBean.class);
		setCommandName("catOrigenesDocumentosBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CatOrigenesDocumentosBean catOrigenesDocumentosBean = (CatOrigenesDocumentosBean) command;
		List listaOrigenesBean = catOrigenesDocumentosServicio.lista(tipoLista, catOrigenesDocumentosBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaOrigenesBean);
		
		return new ModelAndView("guardaValores/catalogoOrigenDocumentoListaVista", "listaResultado", listaResultado);
	}

	public CatOrigenesDocumentosServicio getCatOrigenesDocumentosServicio() {
		return catOrigenesDocumentosServicio;
	}

	public void setCatOrigenesDocumentosServicio(
			CatOrigenesDocumentosServicio catOrigenesDocumentosServicio) {
		this.catOrigenesDocumentosServicio = catOrigenesDocumentosServicio;
	}
	
}
