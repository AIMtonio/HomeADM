package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClasificacionCliBean;
import cliente.servicio.ClasificacionCliServicio;

public class ClasificacionCliControlador extends SimpleFormController  {
	

	ClasificacionCliServicio clasificacionCliServicio = null;


	public ClasificacionCliControlador() {
		setCommandClass(ClasificacionCliBean.class); 
		setCommandName("clasificacionCliBean");	
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {	

		clasificacionCliServicio.getClasificacionCliDAO() .getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ClasificacionCliBean clasificacionBean = (ClasificacionCliBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
					

		MensajeTransaccionBean mensaje = null;		
		mensaje = clasificacionCliServicio.grabaTransaccion(tipoTransaccion,clasificacionBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit



	
	//* ============== GETTER & SETTER =============  //*

	public ClasificacionCliServicio getClasificacionCliServicio() {
		return clasificacionCliServicio;
	}


	public void setClasificacionCliServicio(
			ClasificacionCliServicio clasificacionCliServicio) {
		this.clasificacionCliServicio = clasificacionCliServicio;
	}


}
