package pld.controlador;

import gestionComecial.bean.AreasBean;
import gestionComecial.servicio.AreasServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.MotivosPreoBean;
import pld.servicio.MotivosPreoServicio;

public class MotivosPreoListaControlador extends AbstractCommandController{
	
	MotivosPreoServicio motivosPreoServicio = null;

			public MotivosPreoListaControlador() {
					setCommandClass(MotivosPreoBean.class);
					setCommandName("motivosPreo");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				MotivosPreoBean motivosPreo = (MotivosPreoBean) command;
				List motivosPreoList =	motivosPreoServicio.lista(tipoLista, motivosPreo);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(motivosPreoList);

		return new ModelAndView("pld/motivosPreoListaVista", "listaResultado", listaResultado);
		}


		public void setMotivosPreoServicio(
				MotivosPreoServicio motivosPreoServicio) {
				this.motivosPreoServicio = motivosPreoServicio;
		}

	}

