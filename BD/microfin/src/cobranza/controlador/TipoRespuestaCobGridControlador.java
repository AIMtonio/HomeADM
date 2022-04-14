package cobranza.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cobranza.bean.TipoRespuestaCobBean;
import cobranza.servicio.TipoRespuestaCobServicio;

public class TipoRespuestaCobGridControlador extends AbstractCommandController{
	TipoRespuestaCobServicio tipoRespuestaCobServicio = null;
	
	public TipoRespuestaCobGridControlador(){
		setCommandClass(TipoRespuestaCobBean.class);
		setCommandName("tipoRespuestaCobBean");	
		
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		TipoRespuestaCobBean respuestaBean = (TipoRespuestaCobBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	

		List listaResultado = new ArrayList();
		List parametrosList = tipoRespuestaCobServicio.listaTipoRespuesta(tipoLista,respuestaBean);
		
		listaResultado.add(tipoLista);
		listaResultado.add(parametrosList);
		
		return new ModelAndView("cobranza/tipoRespuestaCobGridVista", "listaResultado", listaResultado);
	}	

	public TipoRespuestaCobServicio getTipoRespuestaCobServicio() {
		return tipoRespuestaCobServicio;
	}

	public void setTipoRespuestaCobServicio(
			TipoRespuestaCobServicio tipoRespuestaCobServicio) {
		this.tipoRespuestaCobServicio = tipoRespuestaCobServicio;
	}
	
}
