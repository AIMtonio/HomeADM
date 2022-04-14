package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.GeneraEdoCtaBean;
import soporte.servicio.EdoCtaClienteServicio;



public class EdoCtaClienteControlador extends SimpleFormController  {
	EdoCtaClienteServicio generaEdoCtaServicio = null;
	public EdoCtaClienteControlador(){
		setCommandClass(GeneraEdoCtaBean.class);
		setCommandName("estadoCuentaCte");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		generaEdoCtaServicio.getEdoCtaClienteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));

		GeneraEdoCtaBean estadoCuenta = (GeneraEdoCtaBean) command;
		MensajeTransaccionBean mensaje = null;
		
		mensaje = generaEdoCtaServicio.grabaTransaccion(tipoTransaccion, estadoCuenta);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public EdoCtaClienteServicio getGeneraEdoCtaServicio() {
		return generaEdoCtaServicio;
	}

	public void setGeneraEdoCtaServicio(EdoCtaClienteServicio generaEdoCtaServicio) {
		this.generaEdoCtaServicio = generaEdoCtaServicio;
	}
	
}
