
package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreLimiteQuitasBean;
import credito.servicio.CreLimiteQuitasServicio; 


public class CreLimQuitasGridControlador extends AbstractCommandController{


	CreLimiteQuitasServicio creLimiteQuitasServicio = null;
	public 	CreLimQuitasGridControlador(){
		setCommandClass( CreLimiteQuitasBean.class);
		setCommandName("limiteQuitas");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		

		CreLimiteQuitasBean creLimiteQuitasBean = new CreLimiteQuitasBean();
		                                              
        String   tipoCon   =(request.getParameter("tipoConsulta")!=null) ? request.getParameter("tipoConsulta") : "";
       String productoCreID= (request.getParameter("producCreditoID")!=null) ? request.getParameter("producCreditoID") : "0";
       creLimiteQuitasBean.setProducCreditoID(productoCreID);
       
		int tipoConsulta = Integer.parseInt(tipoCon);
		List listaResul = creLimiteQuitasServicio.lista(tipoConsulta, creLimiteQuitasBean);
	    List listaResultado = (List)new ArrayList();
		listaResultado.add(listaResul);
		
		return new ModelAndView("credito/creLimQuitasGridVista", "listaResultado", listaResultado);
	}

	public CreLimiteQuitasServicio getCreLimiteQuitasServicio() {
		return creLimiteQuitasServicio;
		     
	}
 
	public void setCreLimiteQuitasServicio(
			CreLimiteQuitasServicio creLimiteQuitasServicio) {
		this.creLimiteQuitasServicio = creLimiteQuitasServicio;
	}
}
