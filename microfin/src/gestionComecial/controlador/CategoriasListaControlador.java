package gestionComecial.controlador;

import gestionComecial.bean.AreasBean;
import gestionComecial.bean.CategoriasBean;
import gestionComecial.servicio.AreasServicio;
import gestionComecial.servicio.CategoriasServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class CategoriasListaControlador extends AbstractCommandController{
	
	CategoriasServicio categoriasServicio = null;

			public CategoriasListaControlador() {
					setCommandClass(CategoriasBean.class);
					setCommandName("categorias");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				CategoriasBean categorias = (CategoriasBean) command;
				List categoriasList =	categoriasServicio.lista(tipoLista, categorias);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(categoriasList);

		return new ModelAndView("gestionComercial/categoriasListaVista", "listaResultado", listaResultado);
		}


		public void setCategoriasServicio(
				CategoriasServicio categoriasServicio) {
				this.categoriasServicio = categoriasServicio;
		}

	}

