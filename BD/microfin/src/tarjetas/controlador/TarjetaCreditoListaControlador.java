package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import tarjetas.bean.TarjetaCreditoBean;
import tarjetas.servicio.TarjetaCreditoServicio;


public class TarjetaCreditoListaControlador extends AbstractCommandController{
		
	TarjetaCreditoServicio tarjetaCreditoServicio = null;
		
		public TarjetaCreditoListaControlador() {
			setCommandClass(TarjetaCreditoBean.class);
			setCommandName("tarjetaCreditoBean");
		}
				
		protected ModelAndView handle(HttpServletRequest request,
										  HttpServletResponse response,
										  Object command,
										  BindException errors) throws Exception {
				
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		TarjetaCreditoBean tarjetaCreditoBean = (TarjetaCreditoBean) command;
		List listaTarjetasDebito =	tarjetaCreditoServicio.lista( tipoLista, tarjetaCreditoBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaTarjetasDebito);
				
		return new ModelAndView("tarjetas/tarjetaCreditoListaVista", "listaResultado", listaResultado);
		}
		//---------------------setter------------------------

		public TarjetaCreditoServicio getTarjetaCreditoServicio() {
			return tarjetaCreditoServicio;
		}

		public void setTarjetaCreditoServicio(
				TarjetaCreditoServicio tarjetaCreditoServicio) {
			this.tarjetaCreditoServicio = tarjetaCreditoServicio;
		}

		
	
}
