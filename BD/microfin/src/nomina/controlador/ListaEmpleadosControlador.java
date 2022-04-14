package nomina.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

import nomina.bean.ActualizaEstatusEmpBean;
import nomina.servicio.ActualizaEstatusEmpServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


public class ListaEmpleadosControlador extends AbstractCommandController{
	ActualizaEstatusEmpServicio actualizaEstatusEmpServicio = null;
			
		public ListaEmpleadosControlador() {
				setCommandClass(ActualizaEstatusEmpBean.class);
				setCommandName("actualizaEstatusEmpBean");
		}
				
		protected ModelAndView handle(HttpServletRequest request,
										  HttpServletResponse response,
										  Object command,
										  BindException errors) throws Exception {
				
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ActualizaEstatusEmpBean actualizaEstatusEmpBean = (ActualizaEstatusEmpBean) command;
		List listaEmpleadoNomina =	actualizaEstatusEmpServicio.lista(tipoLista, actualizaEstatusEmpBean);
		
		List listaResultado = (List)new ArrayList();

		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaEmpleadoNomina);
				
		return new ModelAndView("nomina/empleadosListaVista", "listaResultado", listaResultado);
		}

		// GETtERS Y SETTERS
		public ActualizaEstatusEmpServicio getActualizaEstatusEmpServicio() {
			return actualizaEstatusEmpServicio;
		}

		public void setActualizaEstatusEmpServicio(
				ActualizaEstatusEmpServicio actualizaEstatusEmpServicio) {
			this.actualizaEstatusEmpServicio = actualizaEstatusEmpServicio;
		}
  }

		
		