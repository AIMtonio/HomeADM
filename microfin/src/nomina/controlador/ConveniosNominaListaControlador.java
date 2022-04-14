package nomina.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.ConvenioNominaBean;
import nomina.servicio.ConveniosNominaServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ConveniosNominaListaControlador extends AbstractCommandController {
	ConveniosNominaServicio conveniosNominaServicio = null;

	public ConveniosNominaListaControlador() {
		setCommandClass(ConvenioNominaBean.class);
		setCommandName("convenioNominaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = (request.getParameter("tipoLista") != null) ? Utileria.convierteEntero(request.getParameter("tipoLista")) : 0;

		String controlID = request.getParameter("controlID");

		ConvenioNominaBean convenioNominaBean = (ConvenioNominaBean) command;

		List<?> listaConvenios = conveniosNominaServicio.lista(tipoLista, convenioNominaBean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaConvenios);

		return new ModelAndView("nomina/conveniosNominaListaVista", "listaResultado", listaResultado);
	}

	public ConveniosNominaServicio getConveniosNominaServicio() {
		return conveniosNominaServicio;
	}

	public void setConveniosNominaServicio(
			ConveniosNominaServicio conveniosNominaServicio) {
		this.conveniosNominaServicio = conveniosNominaServicio;
	}
}
