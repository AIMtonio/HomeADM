package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.ActivoArrendaBean;
import arrendamiento.servicio.ActivoArrendaServicio;

public class VinculacionActivosListaControlador extends AbstractCommandController {
	ActivoArrendaServicio activoArrendaServicio = null; 
	public VinculacionActivosListaControlador(){
		setCommandClass(ActivoArrendaBean.class);
		setCommandName("activoArrendaBean");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		ActivoArrendaBean activoArrendaBean = (ActivoArrendaBean) command;
		List listaActivos = activoArrendaServicio.lista(tipoLista, activoArrendaBean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaActivos);

		return new ModelAndView("arrendamiento/vinculacionActivosListaVista", "listaResultado", listaResultado);
	}

	//------------------setter---------------
	public void setActivoArrendaServicio(ActivoArrendaServicio activoArrendaServicio) {
		this.activoArrendaServicio = activoArrendaServicio;
	}
}
