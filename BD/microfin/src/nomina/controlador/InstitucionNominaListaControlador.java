package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.InstitucionNominaBean;
import nomina.servicio.InstitucionNominaServicio;

public class InstitucionNominaListaControlador extends AbstractCommandController{
		
	InstitucionNominaServicio institucionNomServicio = null;
		
		public InstitucionNominaListaControlador() {
			setCommandClass(InstitucionNominaBean.class);
			setCommandName("institucionNominaBean");
		}
				
		protected ModelAndView handle(HttpServletRequest request,
										  HttpServletResponse response,
										  Object command,
										  BindException errors) throws Exception {
				
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		InstitucionNominaBean institucionNominaBean = (InstitucionNominaBean) command;
		List listaInstitucionNomina =	institucionNomServicio.lista( tipoLista, institucionNominaBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaInstitucionNomina);
				
		return new ModelAndView("nomina/institucionNominaListaVista", "listaResultado", listaResultado);
		}

		// Getter y Setter

		public InstitucionNominaServicio getInstitucionNomServicio() {
			return institucionNomServicio;
		}

		public void setInstitucionNomServicio(
				InstitucionNominaServicio institucionNomServicio) {
			this.institucionNomServicio = institucionNomServicio;
		}
		}