package activos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import activos.bean.AplicacionDepreciacionBean;
import activos.servicio.AplicacionDepreciacionServicio;


public class AplicacionDepreciacionControlador extends SimpleFormController{
	
	AplicacionDepreciacionServicio aplicacionDepreciacionServicio = null;
	
	public AplicacionDepreciacionControlador(){
		setCommandClass(AplicacionDepreciacionBean.class);
 		setCommandName("aplicacionDepreciacionBean");
		
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, 
		HttpServletResponse response, Object command, 
		BindException errors) throws Exception {

		MensajeTransaccionBean mensaje = null;
	
		AplicacionDepreciacionBean aplicacionDepreciacionBean = (AplicacionDepreciacionBean) command;
		aplicacionDepreciacionServicio.getAplicacionDepreciacionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")):0;

		mensaje = aplicacionDepreciacionServicio.grabaTransaccion(tipoTransaccion, aplicacionDepreciacionBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

	/* ============== GETTER & SETTER ===================== */
	public AplicacionDepreciacionServicio getAplicacionDepreciacionServicio() {
		return aplicacionDepreciacionServicio;
	}

	public void setAplicacionDepreciacionServicio(AplicacionDepreciacionServicio aplicacionDepreciacionServicio) {
		this.aplicacionDepreciacionServicio = aplicacionDepreciacionServicio;
	}


}
