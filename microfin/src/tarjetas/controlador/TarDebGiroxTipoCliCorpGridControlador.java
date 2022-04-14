
package tarjetas.controlador;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.GiroNegocioTarDebBean;
import tarjetas.bean.TarDebGiroxTipoCliCorpBean;
import tarjetas.servicio.GiroNegocioTarDebServicio;
import tarjetas.servicio.TarDebGiroxTipoCliCorpServicio;

public class TarDebGiroxTipoCliCorpGridControlador extends AbstractCommandController{
	
	TarDebGiroxTipoCliCorpServicio  tarDebGiroxTipoCliCorpServicio= null;

	public TarDebGiroxTipoCliCorpGridControlador() {
		setCommandClass(TarDebGiroxTipoCliCorpBean.class);
		setCommandName("tarDebGiroxTipoCliCorpBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		TarDebGiroxTipoCliCorpBean tarDebGiroxTipoCliCorpBean = (TarDebGiroxTipoCliCorpBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = tarDebGiroxTipoCliCorpServicio.lista(tipoLista, tarDebGiroxTipoCliCorpBean);
		
		return new ModelAndView("tarjetas/giroNegocioxTipoTarCliCorporGridVista", "listaResultado", listaResultado);
	}

	public TarDebGiroxTipoCliCorpServicio getTarDebGiroxTipoCliCorpServicio() {
		return tarDebGiroxTipoCliCorpServicio;
	}

	public void setTarDebGiroxTipoCliCorpServicio(
			TarDebGiroxTipoCliCorpServicio tarDebGiroxTipoCliCorpServicio) {
		this.tarDebGiroxTipoCliCorpServicio = tarDebGiroxTipoCliCorpServicio;
	}

	


}