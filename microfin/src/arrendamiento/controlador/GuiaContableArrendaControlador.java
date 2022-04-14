package arrendamiento.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import arrendamiento.servicio.GuiaContableArrendaServicio;

public class GuiaContableArrendaControlador extends SimpleFormController{

	GuiaContableArrendaServicio guiaContableArrendaServicio = null;

 	public GuiaContableArrendaControlador(){
 		setCommandClass(Object.class);
 		setCommandName("GuiaContable");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		guiaContableArrendaServicio.getCuentasMayorArrendaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		MensajeTransaccionBean mensaje = null; 		
 		mensaje = guiaContableArrendaServicio.grabaTransaccion(request);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public GuiaContableArrendaServicio getGuiaContableArrendaServicio() {
		return guiaContableArrendaServicio;
	}

	public void setGuiaContableArrendaServicio(
			GuiaContableArrendaServicio guiaContableArrendaServicio) {
		this.guiaContableArrendaServicio = guiaContableArrendaServicio;
	}
 	
 } 