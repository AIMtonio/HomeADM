package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.EntregaArrendamientoBean;
import arrendamiento.servicio.ArrendamientosServicio;

public class EntregaArrendamientoListaControlador extends AbstractCommandController {
	ArrendamientosServicio arrendamientosServicio = null; 
	public EntregaArrendamientoListaControlador(){
		setCommandClass(EntregaArrendamientoBean.class);
		setCommandName("entregaArrendamientoBean");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		EntregaArrendamientoBean entregaArrendamientoBean = (EntregaArrendamientoBean) command;
		List listaArrendamientos = arrendamientosServicio.lista(tipoLista, entregaArrendamientoBean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaArrendamientos);

		return new ModelAndView("arrendamiento/entregaArrendamientoListaVista", "listaResultado", listaResultado);
	}

	//------------------setter---------------
	public void setArrendamientosServicio(ArrendamientosServicio arrendamientosServicio) {
		this.arrendamientosServicio = arrendamientosServicio;
	}
}
