package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TarDebAclaraBean;
import tarjetas.servicio.TarDebAclaraServicio;
import tarjetas.servicio.TarjetaDebitoServicio;

public class TarDebAclaraListaControlador extends AbstractCommandController{
		
	TarDebAclaraServicio aclaracionServicio= null;
		
		public TarDebAclaraListaControlador() {
			setCommandClass(TarDebAclaraBean.class);
			setCommandName("tarDebAclaraBean");
		}
				
		protected ModelAndView handle(HttpServletRequest request,
										  HttpServletResponse response,
										  Object command,
										  BindException errors) throws Exception {
				
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		TarDebAclaraBean tarDebAclaraBean = (TarDebAclaraBean) command;
		List aclaracionesTarjetasDebito =	aclaracionServicio.lista( tipoLista, tarDebAclaraBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(aclaracionesTarjetasDebito);
				
		return new ModelAndView("tarjetas/aclaraTarjListaVista", "listaResultado", listaResultado);
		}

		public TarDebAclaraServicio getAclaracionServicio() {
			return aclaracionServicio;
		}

		public void setAclaracionServicio(TarDebAclaraServicio aclaracionServicio) {
			this.aclaracionServicio = aclaracionServicio;
		}

		//---------------------setter------------------------

		
}
