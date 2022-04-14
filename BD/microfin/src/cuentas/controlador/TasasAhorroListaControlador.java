package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.TasasAhorroBean;
import cuentas.servicio.TasasAhorroServicio;


public class TasasAhorroListaControlador extends AbstractCommandController{

		
		TasasAhorroServicio tasasAhorroServicio = null;
			
		public TasasAhorroListaControlador() {
				setCommandClass(TasasAhorroBean.class);
				setCommandName("tasasAhorro");
		}
				
		protected ModelAndView handle(HttpServletRequest request,
										  HttpServletResponse response,
										  Object command,
										  BindException errors) throws Exception {
				
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		TasasAhorroBean tasasAhorroBean = (TasasAhorroBean) command;
		List tasasAhorro =	tasasAhorroServicio.lista(tipoLista, tasasAhorroBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(tasasAhorro);
				
		return new ModelAndView("cuentas/tasasAhorroListaVista", "listaResultado", listaResultado);
		}

		public void setTasasAhorroServicio(TasasAhorroServicio tasasAhorroServicio) {
			this.tasasAhorroServicio = tasasAhorroServicio;
		}	
	}

