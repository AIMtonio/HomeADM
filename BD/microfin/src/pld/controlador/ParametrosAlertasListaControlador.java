package pld.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.ParametrosAlertasBean;
import pld.servicio.ParametrosAlertasServicio;

import credito.bean.GruposCreditoBean;


public class ParametrosAlertasListaControlador extends AbstractCommandController{
	
	ParametrosAlertasServicio parametrosAlertasServicio = null;

			public ParametrosAlertasListaControlador() {
					setCommandClass(ParametrosAlertasBean.class);
					setCommandName("parAlertas");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				ParametrosAlertasBean alertas = (ParametrosAlertasBean) command;
				List alertasList =	parametrosAlertasServicio.lista(tipoLista, alertas);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(alertasList);

		return new ModelAndView("pld/parametrosAlertasListaVista", "listaResultado", listaResultado);
		}
			
			public void setParametrosAlertasServicio(
					ParametrosAlertasServicio parametrosAlertasServicio) {
				this.parametrosAlertasServicio = parametrosAlertasServicio;
			}
		
	}
