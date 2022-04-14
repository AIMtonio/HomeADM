package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.servicio.GuiaContableDivServicio;

public class GuiaContableDivControlador extends SimpleFormController{
	
	GuiaContableDivServicio guiaContableDivServicio = null;
	
	public GuiaContableDivControlador(){
		setCommandClass(Object.class);
		setCommandName("Divisas");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

			MensajeTransaccionBean mensaje = null; 		
			guiaContableDivServicio.getCuentasMayorMonDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = guiaContableDivServicio.grabaTransaccion(request);

	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public GuiaContableDivServicio getGuiaContableDivServicio() {
		return guiaContableDivServicio;
	}

	public void setGuiaContableDivServicio(
			GuiaContableDivServicio guiaContableDivServicio) {
		this.guiaContableDivServicio = guiaContableDivServicio;
	}

	
	
}
