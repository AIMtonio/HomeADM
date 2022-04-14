package gestionComecial.controlador;

import gestionComecial.bean.EmpleadosBean;
import gestionComecial.servicio.EmpleadosServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class EmpleadosNombreListaControlador extends AbstractCommandController{
	
	EmpleadosServicio empleadosServicio = null;

			public EmpleadosNombreListaControlador() {
					setCommandClass(EmpleadosBean.class);
					setCommandName("empleadosNombre");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				EmpleadosBean empleados = (EmpleadosBean) command;
				empleadosServicio.getEmpleadosDAO().getParametrosAuditoriaBean().setOrigenDatos(empleados.getOrigenDatos());
				List empleadosList =	empleadosServicio.lista(tipoLista, empleados);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(empleadosList);

		return new ModelAndView("gestionComercial/empleadosNombreListaVista", "listaResultado", listaResultado);
		}


		public void setEmpleadosServicio(
				EmpleadosServicio empleadosServicio) {
				this.empleadosServicio = empleadosServicio;
		}

	}
