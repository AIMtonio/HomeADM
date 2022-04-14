package soporte.controlador;

import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import soporte.bean.TarEnvioCorreoParamBean;
import soporte.servicio.TarEnvioCorreoParamServicio;

public class TarEnvioCorreoParamControlador extends SimpleFormController {
	
	
private TarEnvioCorreoParamServicio	tarEnvioCorreoParamServicio;

	public TarEnvioCorreoParamControlador() {
		setCommandClass(TarEnvioCorreoParamBean.class);
		setCommandName("EnvioCorreoParam");
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			tarEnvioCorreoParamServicio.getTarEnvioCorreoParamDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			TarEnvioCorreoParamBean tarEnvioCorreoParam = (TarEnvioCorreoParamBean) command;
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			mensaje = tarEnvioCorreoParamServicio.grabaTransaccion(tipoTransaccion, tarEnvioCorreoParam);
			
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
	
	
	
	public TarEnvioCorreoParamServicio getTarEnvioCorreoParamServicio() {
	return tarEnvioCorreoParamServicio;
}


public void setTarEnvioCorreoParamServicio(
		TarEnvioCorreoParamServicio tarEnvioCorreoParamServicio) {
	this.tarEnvioCorreoParamServicio = tarEnvioCorreoParamServicio;
}



}
