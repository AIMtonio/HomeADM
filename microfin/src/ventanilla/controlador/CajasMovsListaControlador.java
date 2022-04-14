package ventanilla.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.servicio.IngresosOperacionesServicio;

public class CajasMovsListaControlador extends AbstractCommandController {
	IngresosOperacionesServicio ingresosOperacionesServicio = null;

	
	public CajasMovsListaControlador(){
		setCommandClass(IngresosOperacionesBean.class);
		setCommandName("reversas");
	}

	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	
	
	IngresosOperacionesBean listaCajasMovs = (IngresosOperacionesBean) command;
	List lista = ingresosOperacionesServicio.lista(tipoLista, listaCajasMovs);

	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(lista);

	return new ModelAndView("ventanilla/cajasMovsListaVista", "listaResultado", listaResultado);
}


//--------------getter y setter------------------
	public void setIngresosOperacionesServicio(
			IngresosOperacionesServicio ingresosOperacionesServicio) {
		this.ingresosOperacionesServicio = ingresosOperacionesServicio;
	}

	
}