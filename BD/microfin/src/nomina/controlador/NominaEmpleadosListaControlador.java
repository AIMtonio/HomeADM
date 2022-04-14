package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import herramientas.Utileria;
import nomina.bean.EmpleadoNominaBean;
import nomina.servicio.NominaEmpleadosServicio;

public class NominaEmpleadosListaControlador extends AbstractCommandController {
	NominaEmpleadosServicio nominaEmpleadosServicio = null;

	public NominaEmpleadosListaControlador() {
		setCommandClass(EmpleadoNominaBean.class);
		setCommandName("empleadoNominaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = (request.getParameter("tipoLista") != null) ? Utileria.convierteEntero(request.getParameter("tipoLista")) : 0;

		String controlID = request.getParameter("controlID");

		EmpleadoNominaBean empleadoNominaBean = (EmpleadoNominaBean) command;

		List<?> listaRegistros = nominaEmpleadosServicio.lista(tipoLista, empleadoNominaBean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaRegistros);

		return new ModelAndView("nomina/nominaEmpleadosListaVista", "listaResultado", listaResultado);
	}

	public NominaEmpleadosServicio getNominaEmpleadosServicio() {
		return nominaEmpleadosServicio;
	}

	public void setNominaEmpleadosServicio(NominaEmpleadosServicio nominaEmpleadosServicio) {
		this.nominaEmpleadosServicio = nominaEmpleadosServicio;
	}
}
