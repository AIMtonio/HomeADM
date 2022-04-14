package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.EstadoCuentaUnicoBean;
import cliente.servicio.EdoCuentaUnicoRepServicio;

public class EdoCuentaUnicoRepControlador extends SimpleFormController{

	EdoCuentaUnicoRepServicio edoCuentaUnicoRepServicio=null;
	
 	public EdoCuentaUnicoRepControlador(){
 		setCommandClass(EstadoCuentaUnicoBean.class);
 		setCommandName("estadoCuentaUnico");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Estado de Cuenta");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	/* ======== GETTERS & SETTERS ========= */
	public EdoCuentaUnicoRepServicio getEdoCuentaUnicoRepServicio() {
		return edoCuentaUnicoRepServicio;
	}

	public void setEdoCuentaUnicoRepServicio(
			EdoCuentaUnicoRepServicio edoCuentaUnicoRepServicio) {
		this.edoCuentaUnicoRepServicio = edoCuentaUnicoRepServicio;
	}

}
