package credito.controlador;

import gestionComecial.bean.PuestosBean;
import gestionComecial.servicio.PuestosServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.TipoContratoBCBean;
import credito.servicio.TipoContratoBCServicio;

public class TipoContratoBCListaControlador extends AbstractCommandController{
	
	TipoContratoBCServicio tipoContratoBCServicio = null;

			public TipoContratoBCListaControlador() {
					setCommandClass(TipoContratoBCBean.class);
					setCommandName("tipoContrato");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				TipoContratoBCBean contrato = (TipoContratoBCBean) command;
				List contratoList =	tipoContratoBCServicio.lista(tipoLista, contrato);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(contratoList);

		return new ModelAndView("credito/tipoContratoBCListaVista", "listaResultado", listaResultado);
		}

			public void setTipoContratoBCServicio(
					TipoContratoBCServicio tipoContratoBCServicio) {
				this.tipoContratoBCServicio = tipoContratoBCServicio;
			}
			

	}
