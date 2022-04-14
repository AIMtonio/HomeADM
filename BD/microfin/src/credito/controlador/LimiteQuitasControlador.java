 

package credito.controlador;
  
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreLimiteQuitasBean;
import credito.servicio.CreLimiteQuitasServicio;

public class LimiteQuitasControlador extends SimpleFormController {
	CreLimiteQuitasServicio creLimiteQuitasServicio = null;
 
	 

	public LimiteQuitasControlador(){
		setCommandClass(CreLimiteQuitasBean.class);
		setCommandName("limiteQuitas");
	}
   
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		CreLimiteQuitasBean creLimiteQuitasBean = (CreLimiteQuitasBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?Integer.parseInt(request.getParameter("tipoTransaccion")):	0;
		creLimiteQuitasServicio.getCreLimiteQuitasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());  
		
		 MensajeTransaccionBean mensaje = null;
		 
		mensaje =creLimiteQuitasServicio.grabaTransaccion(tipoTransaccion,  creLimiteQuitasBean);

		
		
		
		 
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		

}


	public void setCreLimiteQuitasServicio(CreLimiteQuitasServicio creLimiteQuitasServicio) {
		this.creLimiteQuitasServicio = creLimiteQuitasServicio;
	}

	 

}

