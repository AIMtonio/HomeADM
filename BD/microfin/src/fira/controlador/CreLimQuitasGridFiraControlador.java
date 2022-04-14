
package fira.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.CreLimiteQuitasFiraBean;
import fira.servicio.CreLimiteQuitasFiraServicio; 


public class CreLimQuitasGridFiraControlador extends AbstractCommandController{


	CreLimiteQuitasFiraServicio creLimiteQuitasFiraServicio = null;
	public 	CreLimQuitasGridFiraControlador(){
		setCommandClass( CreLimiteQuitasFiraBean.class);
		setCommandName("limiteQuitas");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		

		CreLimiteQuitasFiraBean creLimiteQuitasFiraBean = new CreLimiteQuitasFiraBean();
		                                              
        String   tipoCon   =(request.getParameter("tipoConsulta")!=null) ? request.getParameter("tipoConsulta") : "";
       String productoCreID= (request.getParameter("producCreditoID")!=null) ? request.getParameter("producCreditoID") : "0";
       creLimiteQuitasFiraBean.setProducCreditoID(productoCreID);
       
		int tipoConsulta = Integer.parseInt(tipoCon);
		List listaResul = creLimiteQuitasFiraServicio.lista(tipoConsulta, creLimiteQuitasFiraBean);
	    List listaResultado = (List)new ArrayList();
		listaResultado.add(listaResul);
		
		return new ModelAndView("fira/creLimQuitasGridVista", "listaResultado", listaResultado);
	}

	public CreLimiteQuitasFiraServicio getCreLimiteQuitasFiraServicio() {
		return creLimiteQuitasFiraServicio;
	}

	public void setCreLimiteQuitasFiraServicio(
			CreLimiteQuitasFiraServicio creLimiteQuitasFiraServicio) {
		this.creLimiteQuitasFiraServicio = creLimiteQuitasFiraServicio;
	}


}
