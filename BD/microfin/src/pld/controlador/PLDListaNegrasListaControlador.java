package pld.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import pld.servicio.PLDListaNegrasServicio;
import pld.bean.PLDListaNegrasBean;


public class PLDListaNegrasListaControlador extends AbstractCommandController {
	
	PLDListaNegrasServicio pldListaNegrasServicio = null;

	public PLDListaNegrasListaControlador() {
			setCommandClass(PLDListaNegrasBean.class);
			setCommandName("listaNegra");
	}

	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {


		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		PLDListaNegrasBean listaNegraLista = (PLDListaNegrasBean) command;
		List listaNegra =	pldListaNegrasServicio.lista(tipoLista, listaNegraLista);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaNegra);

		return new ModelAndView("pld/pldListasNegrasListaVista", "listaResultado", listaResultado);
	}

	//--------------setter--------------
	public void setPldListaNegrasServicio(PLDListaNegrasServicio pldListaNegrasServicio) {
		this.pldListaNegrasServicio = pldListaNegrasServicio;
	}
	
	
	

}
