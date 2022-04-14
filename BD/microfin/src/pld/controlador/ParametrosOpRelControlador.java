package pld.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.ParametrosOpRelBean;
import pld.servicio.ParametrosOpRelServicio;


public class ParametrosOpRelControlador  extends SimpleFormController {
	
	ParametrosOpRelServicio parametrosOpRelServicio = null;

	public ParametrosOpRelControlador() {
		setCommandClass(ParametrosOpRelBean.class);
		setCommandName("parametrosOpRel");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		parametrosOpRelServicio.getParametrosOpRelDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
		ParametrosOpRelBean parametrosOR = (ParametrosOpRelBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
	
		 mensaje = parametrosOpRelServicio.grabaTransaccion(tipoTransaccion,parametrosOR);
		 																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	public void setParametrosOpRelServicio(
			ParametrosOpRelServicio parametrosOpRelServicio) {
		this.parametrosOpRelServicio = parametrosOpRelServicio;
	}


	public ParametrosOpRelServicio getParametrosOpRelServicio() {
		return parametrosOpRelServicio;
	}
	
	
}
