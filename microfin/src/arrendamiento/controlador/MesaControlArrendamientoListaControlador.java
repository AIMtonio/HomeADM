package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.MesaControlArrendamientoBean;
import arrendamiento.servicio.ArrendamientosServicio;

public class MesaControlArrendamientoListaControlador extends AbstractCommandController {
	ArrendamientosServicio arrendamientosServicio = null; 
	public MesaControlArrendamientoListaControlador(){
		setCommandClass(MesaControlArrendamientoBean.class);
		setCommandName("mesaControlArrendamientoBean");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		MesaControlArrendamientoBean mesaControlArrendamientoBean = (MesaControlArrendamientoBean) command;
		List listaArrendamientos = arrendamientosServicio.lista(tipoLista, mesaControlArrendamientoBean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaArrendamientos);

		return new ModelAndView("arrendamiento/mesaControlArrendamientoListaVista", "listaResultado", listaResultado);
	}

	//------------------setter---------------
	public void setArrendamientosServicio(ArrendamientosServicio arrendamientosServicio) {
		this.arrendamientosServicio = arrendamientosServicio;
	}
}
