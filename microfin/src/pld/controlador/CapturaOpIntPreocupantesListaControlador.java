package pld.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.OpIntPreocupantesBean;
import pld.servicio.OpIntPreocupantesServicio;

import tesoreria.bean.ProveedoresBean;
import tesoreria.servicio.ProveedoresServicio;

public class CapturaOpIntPreocupantesListaControlador extends AbstractCommandController{
	
	OpIntPreocupantesServicio opIntPreocupantesServicio = null;

			public CapturaOpIntPreocupantesListaControlador() {
					setCommandClass(OpIntPreocupantesBean.class);
					setCommandName("capturaOp");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				OpIntPreocupantesBean opIntPreocupantes = (OpIntPreocupantesBean) command;
				opIntPreocupantes.setOrigenDatos(request.getParameter("origenDatos"));
				List opIntPreocupantesList =	opIntPreocupantesServicio.lista(tipoLista, opIntPreocupantes);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(opIntPreocupantesList);

		return new ModelAndView("pld/capturaPersonaInvListaVista", "listaResultado", listaResultado);
		}


		public void setOpIntPreocupantesServicio(
				OpIntPreocupantesServicio opIntPreocupantesServicio) {
				this.opIntPreocupantesServicio = opIntPreocupantesServicio;
		}

	}
