package fondeador.controlador;

import fondeador.servicio.GuiaContableCreditoPasServicio;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class GuiaContableCreditoPasControlador extends SimpleFormController{

	GuiaContableCreditoPasServicio guiaContableCreditoPasServicio = null;

 	public GuiaContableCreditoPasControlador(){
 		setCommandClass(Object.class);
 		setCommandName("GuiaContable");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		guiaContableCreditoPasServicio.getCuentasMayorCreditoPasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

 		MensajeTransaccionBean mensaje = null; 		
 		
 		mensaje = guiaContableCreditoPasServicio.grabaTransaccion(request);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public GuiaContableCreditoPasServicio getGuiaContableCreditoPasServicio() {
		return guiaContableCreditoPasServicio;
	}

	public void setGuiaContableCreditoPasServicio(
			GuiaContableCreditoPasServicio guiaContableCreditoPasServicio) {
		this.guiaContableCreditoPasServicio = guiaContableCreditoPasServicio;
	}

 	
 } 