package gestionComecial.controlador;

import gestionComecial.bean.PuestosBean;
import gestionComecial.servicio.PuestosServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.ProveedoresBean;
import tesoreria.servicio.ProveedoresServicio;

public class PuestosListaControlador extends AbstractCommandController{
	
	PuestosServicio puestosServicio = null;

			public PuestosListaControlador() {
					setCommandClass(PuestosBean.class);
					setCommandName("puestos");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				PuestosBean puestos = (PuestosBean) command;
				List puestosList =	puestosServicio.lista(tipoLista, puestos);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(puestosList);

		return new ModelAndView("gestionComercial/puestosListaVista", "listaResultado", listaResultado);
		}


		public void setPuestosServicio(
				PuestosServicio puestosServicio) {
				this.puestosServicio = puestosServicio;
		}

	}
