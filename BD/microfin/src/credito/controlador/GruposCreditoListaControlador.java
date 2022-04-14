package credito.controlador;

import gestionComecial.bean.EmpleadosBean;
import gestionComecial.servicio.EmpleadosServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.GruposCreditoBean;
import credito.servicio.GruposCreditoServicio;

public class GruposCreditoListaControlador extends AbstractCommandController{
	
	GruposCreditoServicio gruposCreditoServicio = null;

			public GruposCreditoListaControlador() {
					setCommandClass(GruposCreditoBean.class);
					setCommandName("gruposCre");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				GruposCreditoBean grupos = (GruposCreditoBean) command;
				List gruposList =	gruposCreditoServicio.lista(tipoLista, grupos);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(gruposList);

		return new ModelAndView("credito/gruposCreditoListaVista", "listaResultado", listaResultado);
		}

			public void setGruposCreditoServicio(GruposCreditoServicio gruposCreditoServicio) {
				this.gruposCreditoServicio = gruposCreditoServicio;
			}


		
	}
