package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.GeneraConstanciaRetencionBean;
import soporte.servicio.GeneraConstanciaRetencionServicio;

public class GeneraConstanciaRetencionControlador extends SimpleFormController{
	GeneraConstanciaRetencionServicio generaConstanciaRetencionServicio = null;
	
	public GeneraConstanciaRetencionControlador (){
		setCommandClass(GeneraConstanciaRetencionBean.class);
		setCommandName("generaConstanciaRetencionBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		generaConstanciaRetencionServicio.getGeneraConstanciaRetencionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		GeneraConstanciaRetencionBean generaConstanciaRetencionBean = (GeneraConstanciaRetencionBean) command;
		
		MensajeTransaccionBean mensaje = null;
		
		mensaje = generaConstanciaRetencionServicio.grabaTransaccion(tipoTransaccion, generaConstanciaRetencionBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ============ SETTER's Y GETTER's =============== */
	public GeneraConstanciaRetencionServicio getGeneraConstanciaRetencionServicio() {
		return generaConstanciaRetencionServicio;
	}

	public void setGeneraConstanciaRetencionServicio(
			GeneraConstanciaRetencionServicio generaConstanciaRetencionServicio) {
		this.generaConstanciaRetencionServicio = generaConstanciaRetencionServicio;
	}

}