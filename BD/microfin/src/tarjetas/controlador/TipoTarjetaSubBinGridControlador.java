package tarjetas.controlador;

import herramientas.Utileria;
import pld.bean.PerfilTransaccionalBean;
import tarjetas.bean.TarDebGiroxTipoCliCorpBean;
import tarjetas.bean.TipoTarjetaDebBean;
import tarjetas.servicio.TipoTarjetaDebServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.pentaho.di.trans.steps.syslog.SyslogMessage;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class TipoTarjetaSubBinGridControlador extends AbstractCommandController {
	TipoTarjetaDebServicio	tipoTarjetaDebServicio = null ;
	
	public TipoTarjetaSubBinGridControlador(){
		setCommandClass(TipoTarjetaDebBean.class);
		setCommandName("tipoTarjetaDebBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		TipoTarjetaDebBean tipoTarjetaDebBean = (TipoTarjetaDebBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
				
		List listaResultado = tipoTarjetaDebServicio.lista(tipoLista, tipoTarjetaDebBean);
		
		return new ModelAndView("tarjetas/tarjetaSubBinGrid", "listaResultado", listaResultado);
	}
	
	public TipoTarjetaDebServicio getTipoTarjetaDebServicio() {
		return tipoTarjetaDebServicio;
	}
	public void setTipoTarjetaDebServicio(TipoTarjetaDebServicio tipoTarjetaDebServicio) {
		this.tipoTarjetaDebServicio = tipoTarjetaDebServicio;
	}			
	
}
