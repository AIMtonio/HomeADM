package cliente.controlador;

import cliente.bean.RelacionEmpleadoClienteBean;
import cliente.servicio.RelacionEmpleadoClienteServicio;



import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class RelacionEmpresaListaControlador extends AbstractCommandController{
	
	RelacionEmpleadoClienteServicio relacionEmpleadoClienteServicio= null;

			public RelacionEmpresaListaControlador() {
					setCommandClass(RelacionEmpleadoClienteBean.class);
					setCommandName("relaciones");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				RelacionEmpleadoClienteBean empleados = (RelacionEmpleadoClienteBean) command;
				List empleadosList =relacionEmpleadoClienteServicio.listaRelaciones(tipoLista, empleados);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(empleadosList);

		return new ModelAndView("cliente/relacionadosEmpresaListaVista", "listaResultado", listaResultado);
		}

			public RelacionEmpleadoClienteServicio getRelacionEmpleadoClienteServicio() {
				return relacionEmpleadoClienteServicio;
			}

			public void setRelacionEmpleadoClienteServicio(RelacionEmpleadoClienteServicio relacionEmpleadoClienteServicio) {
				this.relacionEmpleadoClienteServicio = relacionEmpleadoClienteServicio;
			}

		

		

	}
