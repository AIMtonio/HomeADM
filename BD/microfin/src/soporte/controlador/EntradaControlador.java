package soporte.controlador;

import general.bean.ParametrosSesionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

public class EntradaControlador extends AbstractController{
	
	ParametrosSesionBean parametrosSesionBean = null;
	
	public EntradaControlador() {
		super();
		//TODO Auto-generated constructor stub
	}
	
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			 HttpServletResponse response)
			throws Exception {
		
		return new ModelAndView("entradaView", "ParametroSession", parametrosSesionBean);
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
