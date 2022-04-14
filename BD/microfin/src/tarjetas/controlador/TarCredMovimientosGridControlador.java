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



import tarjetas.bean.TarCredMovimientosBean;
import tarjetas.servicio.TarCredMovimientosServicio;


public class TarCredMovimientosGridControlador extends AbstractCommandController{
		
		TarCredMovimientosServicio tarCredMovimientosServicio = null;

		public TarCredMovimientosGridControlador() {
			setCommandClass(TarCredMovimientosBean.class);
	 		setCommandName("tarDebMovimientosBean");
	 	}
		
		protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
			TarCredMovimientosBean tarCredMovimientosBean = (TarCredMovimientosBean) command;
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			List consultaMovimientosList = tarCredMovimientosServicio.lista(tipoLista, tarCredMovimientosBean);
		
			List listaResultado = new ArrayList();
			listaResultado.add(tipoLista);
			listaResultado.add(consultaMovimientosList);
			
			return new ModelAndView("tarjetas/tarCredMovimientosGridVista", "listaResultado", listaResultado);
		
		}
		// Getter y Setter

		public TarCredMovimientosServicio getTarCredMovimientosServicio() {
			return tarCredMovimientosServicio;
		}

		public void setTarCredMovimientosServicio(
				TarCredMovimientosServicio tarCredMovimientosServicio) {
			this.tarCredMovimientosServicio = tarCredMovimientosServicio;
		}
		
		
}
