package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TarDebConciliaCorrespBean;
import tarjetas.servicio.TarDebConciliaCorrespServicio;

public class TarDebCorrespGridControlador extends AbstractCommandController {
	
	TarDebConciliaCorrespServicio	tarDebConciliaCorrespServicio	= null;
	public TarDebCorrespGridControlador() {
		setCommandClass(TarDebConciliaCorrespBean.class);
		setCommandName("tarDebMovs");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		TarDebConciliaCorrespBean movimientosGridBean = (TarDebConciliaCorrespBean) command;
		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		List listaMovimientos = tarDebConciliaCorrespServicio.movsTarjetas(tipoLista, movimientosGridBean);
		
		List listaResultado = (List) new ArrayList();
		listaResultado.add(listaMovimientos);;
		
		return new ModelAndView("tarjetas/tarDebCorrespGridVista", "listaResultado", listaResultado);
	}
	
	public TarDebConciliaCorrespServicio getTarDebConciliaCorrespServicio() {
		return tarDebConciliaCorrespServicio;
	}
	
	public void setTarDebConciliaCorrespServicio(TarDebConciliaCorrespServicio tarDebConciliaCorrespServicio) {
		this.tarDebConciliaCorrespServicio = tarDebConciliaCorrespServicio;
	}
	
}
