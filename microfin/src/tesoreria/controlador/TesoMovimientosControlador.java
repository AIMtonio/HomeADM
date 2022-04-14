package tesoreria.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.CorreoServicio;
import tesoreria.bean.TesoreriaMovsBean;
import tesoreria.servicio.TesoMovimientosServicio;


public class TesoMovimientosControlador extends SimpleFormController  {
	  
	TesoMovimientosServicio tesoMovimientosServicio = null;
	CorreoServicio correoServicio = null;
	
	public  TesoMovimientosControlador() { 
		setCommandClass(TesoreriaMovsBean.class);
		setCommandName("tesoMovimientos"); 
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
        TesoreriaMovsBean tesoMovsBean = (TesoreriaMovsBean) command;         
        int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
        String institucionID = request.getParameter("institucionID");

		MensajeTransaccionBean mensaje = null;
		mensaje = tesoMovimientosServicio.grabaTransaccion(tipoTransaccion, tesoMovsBean ,institucionID,request);

 		/** Proceso de envío de correo para operaciones PLD.*/
		try {
			correoServicio.EjecutaEnvioCorreo();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	 }

	public void setTesoMovimientosServicio(TesoMovimientosServicio tesoMovimientosServicio) {
		this.tesoMovimientosServicio = tesoMovimientosServicio;
	}

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

}