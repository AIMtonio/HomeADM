package tesoreria.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.TasaImpuestoISRBean;
import tesoreria.servicio.TasaImpuestoISRServicio;

public class TasaImpISRListaControlador extends AbstractCommandController {

	TasaImpuestoISRServicio tasaImpuestoISRServicio = null;

	public TasaImpISRListaControlador(){
		setCommandClass(TasaImpuestoISRBean.class);
		setCommandName("tasaImpuestoISRBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		TasaImpuestoISRBean tasaImpuestoISRBean = (TasaImpuestoISRBean) command;
		List<TasaImpuestoISRBean> tasaImpuestoISR = tasaImpuestoISRServicio.lista(tipoLista, tasaImpuestoISRBean);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(tasaImpuestoISR);
		return new ModelAndView("tesoreria/tasaImpuestoISRListaVista", "listaResultado", listaResultado);
	}

	public TasaImpuestoISRServicio getTasaImpuestoISRServicio() {
		return tasaImpuestoISRServicio;
	}

	public void setTasaImpuestoISRServicio(TasaImpuestoISRServicio tasaImpuestoISRServicio){
		this.tasaImpuestoISRServicio = tasaImpuestoISRServicio;
	}
}