package cobranza.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cobranza.bean.TipoAccionCobBean;
import cobranza.servicio.TipoAccionCobServicio;

public class TipoAccionCobGridControlador extends AbstractCommandController{
	TipoAccionCobServicio tipoAccionCobServicio = null;
	
	public TipoAccionCobGridControlador(){
		setCommandClass(TipoAccionCobBean.class);
		setCommandName("tipoAccionCobBean");		
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		TipoAccionCobBean accionBean = (TipoAccionCobBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	

		List listaResultado = new ArrayList();
		List parametrosList = tipoAccionCobServicio.listaTipoAccion(tipoLista);
		
		listaResultado.add(tipoLista);
		listaResultado.add(parametrosList);
		
		return new ModelAndView("cobranza/tipoAccionCobGridVista", "listaResultado", listaResultado);
	}	

	public TipoAccionCobServicio getTipoAccionCobServicio() {
		return tipoAccionCobServicio;
	}

	public void setTipoAccionCobServicio(TipoAccionCobServicio tipoAccionCobServicio) {
		this.tipoAccionCobServicio = tipoAccionCobServicio;
	}
}
