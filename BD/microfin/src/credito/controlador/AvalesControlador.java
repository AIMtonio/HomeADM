package credito.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.CorreoServicio;
import credito.bean.AvalesBean;
import credito.servicio.AvalesServicio;

public class AvalesControlador extends SimpleFormController {
	private AvalesServicio	avalesServicio;
	private CorreoServicio	correoServicio	= null;
	
	public AvalesControlador() {
		setCommandClass(AvalesBean.class);
		setCommandName("avales");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			avalesServicio.getAvalesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			AvalesBean avales = (AvalesBean) command;
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			
			mensaje = avalesServicio.grabaTransaccion(tipoTransaccion, avales);
			try {
				correoServicio.EjecutaEnvioCorreo();//Ejecuta el envio de correo
			} catch (Exception exa) {
				exa.printStackTrace();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
			}
			if(mensaje.getDescripcion()!=null && mensaje.getDescripcion().isEmpty()){
				mensaje.setDescripcion("Error al grabar la Transacción");
			}
			mensaje.setNumero(999);
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public AvalesServicio getAvalesServicio() {
		return avalesServicio;
	}
	
	public void setAvalesServicio(AvalesServicio avalesServicio) {
		this.avalesServicio = avalesServicio;
	}
	
	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}
	
	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}
	
}
