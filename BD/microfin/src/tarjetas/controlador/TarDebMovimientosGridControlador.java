package tarjetas.controlador;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.BitacoraEstatusTarDebBean;
import tarjetas.bean.TarDebMovimientosBean;
import tarjetas.servicio.BitacoraEstatusTarDebServicio;
import tarjetas.servicio.TarDebMovimientosServicio;

public class TarDebMovimientosGridControlador extends AbstractCommandController{
		
		TarDebMovimientosServicio tarDebMovimientosServicio = null;

		public TarDebMovimientosGridControlador() {
			setCommandClass(TarDebMovimientosBean.class);
	 		setCommandName("tarDebMovimientosBean");
	 	}
		
		protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
			TarDebMovimientosBean tarDebMovimientosBean = (TarDebMovimientosBean) command;
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			List consultaMovimientosList = tarDebMovimientosServicio.lista(tipoLista, tarDebMovimientosBean);
		
			List listaResultado = new ArrayList();
			listaResultado.add(tipoLista);
			listaResultado.add(consultaMovimientosList);
			
			return new ModelAndView("tarjetas/tarDebMovimientosGridVista", "listaResultado", listaResultado);
		
		}
		// Getter y Setter
		public TarDebMovimientosServicio getTarDebMovimientosServicio() {
			return tarDebMovimientosServicio;
		}

		public void setTarDebMovimientosServicio(
				TarDebMovimientosServicio tarDebMovimientosServicio) {
			this.tarDebMovimientosServicio = tarDebMovimientosServicio;
		}
}
