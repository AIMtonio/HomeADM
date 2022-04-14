package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.GarantesBean;
import originacion.servicio.GarantesServicio;

public class GarantesControlador extends SimpleFormController {

	
	GarantesServicio garantesServicio  = null;

	public GarantesControlador(){
		setCommandClass(GarantesBean.class);
		setCommandName("garantesBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			garantesServicio.getGarantesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			GarantesBean garante = (GarantesBean) command;
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			
			mensaje = garantesServicio.grabaTransaccion(tipoTransaccion, garante);
			

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

	public GarantesServicio getGarantesServicio() {
		return garantesServicio;
	}

	public void setGarantesServicio(GarantesServicio garantesServicio) {
		this.garantesServicio = garantesServicio;
	}
	
	
	
	
} 
