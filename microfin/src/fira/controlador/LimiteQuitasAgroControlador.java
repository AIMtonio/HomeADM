 

package fira.controlador;
  
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.CreLimiteQuitasFiraBean;
import fira.servicio.CreLimiteQuitasFiraServicio;

public class LimiteQuitasAgroControlador extends SimpleFormController {
	CreLimiteQuitasFiraServicio creLimiteQuitasFiraServicio = null;
 
	 

	public LimiteQuitasAgroControlador(){
		setCommandClass(CreLimiteQuitasFiraBean.class);
		setCommandName("limiteQuitas");
	}
   
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		CreLimiteQuitasFiraBean creLimiteQuitasFiraBean = (CreLimiteQuitasFiraBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?Integer.parseInt(request.getParameter("tipoTransaccion")):	0;
		creLimiteQuitasFiraServicio.getCreLimiteQuitasFiraDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());  
		
		 MensajeTransaccionBean mensaje = null;
		 
		mensaje =creLimiteQuitasFiraServicio.grabaTransaccion(tipoTransaccion,  creLimiteQuitasFiraBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CreLimiteQuitasFiraServicio getCreLimiteQuitasFiraServicio() {
		return creLimiteQuitasFiraServicio;
	}

	public void setCreLimiteQuitasFiraServicio(
			CreLimiteQuitasFiraServicio creLimiteQuitasFiraServicio) {
		this.creLimiteQuitasFiraServicio = creLimiteQuitasFiraServicio;
	}


	 

}

