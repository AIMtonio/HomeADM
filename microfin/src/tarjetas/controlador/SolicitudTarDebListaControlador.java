package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.SolicitudTarDebBean;
import tarjetas.servicio.SolicitudTarDebServicio;
import tarjetas.servicio.TarjetaDebitoServicio;

public class SolicitudTarDebListaControlador extends AbstractCommandController{
		
	SolicitudTarDebServicio solicitudTarDebServicio = null;
		
		public SolicitudTarDebListaControlador() {
			setCommandClass(SolicitudTarDebBean.class);
			setCommandName("solicitudTarDebBean");
		}
				
		protected ModelAndView handle(HttpServletRequest request,
										  HttpServletResponse response,
										  Object command,
										  BindException errors) throws Exception {
				
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		SolicitudTarDebBean solicitudTarDebBean = (SolicitudTarDebBean) command;
		List listaTarjetasDebito =	solicitudTarDebServicio.lista( tipoLista, solicitudTarDebBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaTarjetasDebito);
				
		return new ModelAndView("tarjetas/solicitudTarDebListaVista", "listaResultado", listaResultado);
		}

		//---------------------setter------------------------
		public void setSolicitudTarDebServicio(SolicitudTarDebServicio solicitudTarDebServicio) {
			this.solicitudTarDebServicio = solicitudTarDebServicio;
		}

		
}
