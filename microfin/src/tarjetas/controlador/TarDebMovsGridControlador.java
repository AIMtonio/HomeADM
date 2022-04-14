package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TarDebMovsGridBean;
import tarjetas.servicio.TarDebMovsGridServicio;


public class TarDebMovsGridControlador extends AbstractCommandController {
	
	TarDebMovsGridServicio tarDebMovsGridServicio = null;
	public TarDebMovsGridControlador() {
		setCommandClass(TarDebMovsGridBean.class);
		setCommandName("tarDebMovs");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		
		TarDebMovsGridBean movimientosGridBean = (TarDebMovsGridBean) command;
		int tipoLista =(request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		List listaMovimientos = tarDebMovsGridServicio.movsTarjetas(tipoLista,movimientosGridBean);
         
        List listaResultado = (List)new ArrayList();
        listaResultado.add(listaMovimientos);;
       
		return new ModelAndView("tarjetas/tarDebMovsGridVista", "listaResultado", listaResultado);
	}

	public TarDebMovsGridServicio getTarDebMovsGridServicio() {
		return tarDebMovsGridServicio;
	}

	public void setTarDebMovsGridServicio(
			TarDebMovsGridServicio tarDebMovsGridServicio) {
		this.tarDebMovsGridServicio = tarDebMovsGridServicio;
	}
}

