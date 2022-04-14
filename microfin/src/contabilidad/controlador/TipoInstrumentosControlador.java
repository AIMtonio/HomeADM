package contabilidad.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.TipoInstrumentosBean;
import contabilidad.servicio.TipoInstrumentosServicio;

public class TipoInstrumentosControlador extends AbstractCommandController{
	TipoInstrumentosServicio tipoInstrumentosServicio = null;

	public TipoInstrumentosControlador() {
			setCommandClass(TipoInstrumentosBean.class);
			setCommandName("tipoInstrumentosBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		
		TipoInstrumentosBean tipoInstrumentosBean = (TipoInstrumentosBean) command;
		List tipoInstrumentoList = tipoInstrumentosServicio.lista(tipoLista, tipoInstrumentosBean);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(tipoInstrumentoList);

		return new ModelAndView("contabilidad/tipoInstrumentoListaVista", "listaResultado", listaResultado);
	}

	public TipoInstrumentosServicio getTipoInstrumentosServicio() {
		return tipoInstrumentosServicio;
	}

	public void setTipoInstrumentosServicio(
			TipoInstrumentosServicio tipoInstrumentosServicio) {
		this.tipoInstrumentosServicio = tipoInstrumentosServicio;
	}


	
}
