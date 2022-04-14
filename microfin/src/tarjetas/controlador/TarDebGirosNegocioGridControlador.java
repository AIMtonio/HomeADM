package tarjetas.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TarDebGirosNegocioBean;
import tarjetas.servicio.TarDebGirosNegocioServicio;

public class TarDebGirosNegocioGridControlador extends AbstractCommandController{
	TarDebGirosNegocioServicio  tarDebGirosNegocioServicio= null;
	
	public TarDebGirosNegocioGridControlador() {
		setCommandClass(TarDebGirosNegocioBean.class);
		setCommandName("girosTarjeta");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		TarDebGirosNegocioBean tarDebGirosNegocioBean = (TarDebGirosNegocioBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = tarDebGirosNegocioServicio.lista(tipoLista, tarDebGirosNegocioBean);

		return new ModelAndView("tarjetas/tarDebGirosIndGridVista", "listaResultado", listaResultado);
	}
	//------------------setter-------------
	public TarDebGirosNegocioServicio getTarDebGirosNegocioServicio() {
		return tarDebGirosNegocioServicio;
	}

	public void setTarDebGirosNegocioServicio(
			TarDebGirosNegocioServicio tarDebGirosNegocioServicio) {
		this.tarDebGirosNegocioServicio = tarDebGirosNegocioServicio;
	}
}

	