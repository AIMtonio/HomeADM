package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.CorreoServicio;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.servicio.IngresosOperacionesServicio;


public class IngresosOperacionesControlador  extends SimpleFormController {

	IngresosOperacionesServicio ingresosOperacionesServicio = null;
	CorreoServicio correoServicio = null;

 	public IngresosOperacionesControlador(){
 		setCommandClass(IngresosOperacionesBean.class);
 		setCommandName("ingresosOperaciones");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		IngresosOperacionesBean  ingresosOperacionesBean = (IngresosOperacionesBean) command;
 		ingresosOperacionesServicio.getIngresosOperacionesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		//IngresosOperacionesBean ingresosOperacionesBean = (IngresosOperacionesBean) command;

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 	
 		MensajeTransaccionBean mensaje = null;
 		mensaje = ingresosOperacionesServicio.grabaTransaccion(tipoTransaccion,request,ingresosOperacionesBean );

 		/** Proceso de envío de correo para operaciones PLD.*/
		try {
			correoServicio.EjecutaEnvioCorreo();
		} catch (Exception e) {
			e.printStackTrace();
		}
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public void setIngresosOperacionesServicio(
			IngresosOperacionesServicio ingresosOperacionesServicio) {
		this.ingresosOperacionesServicio = ingresosOperacionesServicio;
	}

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}
 } 
