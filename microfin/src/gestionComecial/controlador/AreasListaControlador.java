package gestionComecial.controlador;

import gestionComecial.bean.AreasBean;
import gestionComecial.bean.PuestosBean;
import gestionComecial.servicio.AreasServicio;
import gestionComecial.servicio.PuestosServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class AreasListaControlador extends AbstractCommandController{
	
	AreasServicio areasServicio = null;

			public AreasListaControlador() {
					setCommandClass(AreasBean.class);
					setCommandName("areas");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				AreasBean areas = (AreasBean) command;
				List areasList =	areasServicio.lista(tipoLista, areas);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(areasList);

		return new ModelAndView("gestionComercial/areasListaVista", "listaResultado", listaResultado);
		}


		public void setAreasServicio(
				AreasServicio areasServicio) {
				this.areasServicio = areasServicio;
		}

	}

