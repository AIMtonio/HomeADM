package credito.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.CorreoServicio;
import credito.bean.ObligadosSolidariosBean;
import credito.servicio.ObligadosSolidariosServicio;

public class ObligadosSolidariosControlador extends SimpleFormController {
	private ObligadosSolidariosServicio	obligadosSolidariosServicio;
	private CorreoServicio	correoServicio	= null;
	
	public ObligadosSolidariosControlador() {
		setCommandClass(ObligadosSolidariosBean.class);
		setCommandName("obligadosSolidarios");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			obligadosSolidariosServicio.getObligadosSolidariosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			ObligadosSolidariosBean oblSolidariosBean = (ObligadosSolidariosBean) command;
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			
			mensaje = obligadosSolidariosServicio.grabaTransaccion(tipoTransaccion, oblSolidariosBean);
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
	
	public ObligadosSolidariosServicio getObligadosSolidariosServicio() {
		return obligadosSolidariosServicio;
	}
	
	public void setObligadosSolidariosServicio(ObligadosSolidariosServicio oblSolidariosServicio) {
		this.obligadosSolidariosServicio = oblSolidariosServicio;
	}
	
	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}
	
	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}
	
}
