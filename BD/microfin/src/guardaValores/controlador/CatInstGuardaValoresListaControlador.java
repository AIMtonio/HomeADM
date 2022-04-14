package guardaValores.controlador;

import java.util.ArrayList;
import java.util.List;

import guardaValores.bean.CatInstGuardaValoresBean;
import guardaValores.servicio.CatInstGuardaValoresServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class CatInstGuardaValoresListaControlador extends AbstractCommandController {
	
	CatInstGuardaValoresServicio catInstGuardaValoresServicio = null;
	
	public CatInstGuardaValoresListaControlador() {
		setCommandClass(CatInstGuardaValoresBean.class);
		setCommandName("catInstGuardaValoresBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CatInstGuardaValoresBean catInstGuardaValoresBean = (CatInstGuardaValoresBean) command;
		List listaInstrumentosBean = catInstGuardaValoresServicio.lista(tipoLista, catInstGuardaValoresBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaInstrumentosBean);
		
		return new ModelAndView("guardaValores/catalogoInstrumentoListaVista", "listaResultado",listaResultado);
	}

	public CatInstGuardaValoresServicio getCatInstGuardaValoresServicio() {
		return catInstGuardaValoresServicio;
	}

	public void setCatInstGuardaValoresServicio(
			CatInstGuardaValoresServicio catInstGuardaValoresServicio) {
		this.catInstGuardaValoresServicio = catInstGuardaValoresServicio;
	}
	
}
