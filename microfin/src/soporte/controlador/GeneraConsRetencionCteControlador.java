package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.GeneraConstanciaRetencionBean;
import soporte.servicio.GeneraConsRetencionCteServicio;

public class GeneraConsRetencionCteControlador extends SimpleFormController {
	GeneraConsRetencionCteServicio generaConsRetencionCteServicio = null;
	
	public GeneraConsRetencionCteControlador (){
		setCommandClass(GeneraConstanciaRetencionBean.class);
		setCommandName("generaConstanciaRetencionBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		generaConsRetencionCteServicio.getGeneraConsRetencionCteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		GeneraConstanciaRetencionBean constanciaRetencion = (GeneraConstanciaRetencionBean) command;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = generaConsRetencionCteServicio.grabaTransaccion(tipoTransaccion, constanciaRetencion);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ============ SETTER's Y GETTER's =============== */

	public GeneraConsRetencionCteServicio getGeneraConsRetencionCteServicio() {
		return generaConsRetencionCteServicio;
	}

	public void setGeneraConsRetencionCteServicio(
			GeneraConsRetencionCteServicio generaConsRetencionCteServicio) {
		this.generaConsRetencionCteServicio = generaConsRetencionCteServicio;
	}
	
}
