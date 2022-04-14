package pld.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.MotivosInuBean;
import pld.bean.MotivosPreoBean;
import pld.servicio.MotivosInuServicio;
import pld.servicio.MotivosPreoServicio;

public class MotivosInuListaControlador extends AbstractCommandController{
	
	MotivosInuServicio motivosInuServicio = null;

			public MotivosInuListaControlador() {
					setCommandClass(MotivosInuBean.class);
					setCommandName("motivosInu");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				MotivosInuBean motivosInu = (MotivosInuBean) command;
				List motivosInuList =	motivosInuServicio.lista(tipoLista, motivosInu);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(motivosInuList);

		return new ModelAndView("pld/motivosInuListaVista", "listaResultado", listaResultado);
		}


		public void setMotivosInuServicio(
				MotivosInuServicio motivosInuServicio) {
				this.motivosInuServicio = motivosInuServicio;
		}

	}

