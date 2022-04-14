package spei.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import spei.bean.ParametrosSpeiBean;
import spei.servicio.ParametrosSpeiServicio;

public class ParametrosSpeiControlador extends SimpleFormController{
	
	ParametrosSpeiServicio parametrosSpeiServicio = null;

 	public ParametrosSpeiControlador(){
 		setCommandClass(ParametrosSpeiBean.class);
 		setCommandName("parametrosSpeiBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
 		parametrosSpeiServicio.getParametrosSpeiDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		ParametrosSpeiBean parametrosSpeiBean = (ParametrosSpeiBean) command;

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
			Integer.parseInt(request.getParameter("tipoTransaccion")):
		0;

			MensajeTransaccionBean mensaje = null;
			mensaje = parametrosSpeiServicio.grabaTransaccion(tipoTransaccion, parametrosSpeiBean);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);


 	}
 	// ---------------  getter y setter -------------------- 
	public ParametrosSpeiServicio getParametrosSpeiServicio() {
		return parametrosSpeiServicio;
	}

	public void setParametrosSpeiServicio(
			ParametrosSpeiServicio parametrosSpeiServicio) {
		this.parametrosSpeiServicio = parametrosSpeiServicio;
	}

}
