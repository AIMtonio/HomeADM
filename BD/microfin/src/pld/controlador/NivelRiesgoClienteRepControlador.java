package pld.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.NivelRiesgoClienteBean;
import pld.bean.RepConocimientoCteBean;

public class NivelRiesgoClienteRepControlador extends SimpleFormController{

	private ParametrosSesionBean parametrosSesionBean = null;
	
 	public NivelRiesgoClienteRepControlador(){
 		setCommandClass(NivelRiesgoClienteBean.class);
 		setCommandName("riesgoActualClienteRep");
 	}
 	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

					   
	MensajeTransaccionBean mensaje = null;
	mensaje = new MensajeTransaccionBean();
	mensaje.setNumero(0);

	mensaje.setDescripcion("Reporte Conocimiento cliente");
							
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);

}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
