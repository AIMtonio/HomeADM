package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.ObligadosSolidariosBean;
import credito.servicio.AutorizaObliSolidServicio;
import credito.servicio.ObligadosSolidariosServicio;

public class ObligadosSolidariosListaControlador  extends AbstractCommandController{
	
	ObligadosSolidariosServicio obligadosSolidariosServicio = null;

			public ObligadosSolidariosListaControlador() {
					setCommandClass(ObligadosSolidariosBean.class);
					setCommandName("obligadosSolidariosLis");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				ObligadosSolidariosBean obligadosSolidariosBean = (ObligadosSolidariosBean) command;
				List obligadosSolidariosList =	obligadosSolidariosServicio.lista(tipoLista, obligadosSolidariosBean);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(obligadosSolidariosList);

		return new ModelAndView("credito/obligadosSolidariosListaVista", "listaResultado", listaResultado);
		}

		public void setObligadosSolidariosServicio(
				ObligadosSolidariosServicio obligadosSolidariosServicio) {
			this.obligadosSolidariosServicio = obligadosSolidariosServicio;
		}
		
	}
