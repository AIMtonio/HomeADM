package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import tarjetas.bean.EdoCtaCredClienteBean;
import tarjetas.servicio.EdoCtaCredClienteServicio;





public class EdoCtaCredClienteControlador extends SimpleFormController  {
	EdoCtaCredClienteServicio edoCtaCredClienteServicio = null;
	public EdoCtaCredClienteControlador(){
		setCommandClass(EdoCtaCredClienteBean.class);
		setCommandName("edoCtaCredClienteBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		


		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));

		EdoCtaCredClienteBean estadoCuenta = (EdoCtaCredClienteBean) command;
		MensajeTransaccionBean mensaje = null;
		

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public EdoCtaCredClienteServicio getEdoCtaCredClienteServicio() {
		return edoCtaCredClienteServicio;
	}

	public void setEdoCtaCredClienteServicio(
			EdoCtaCredClienteServicio edoCtaCredClienteServicio) {
		this.edoCtaCredClienteServicio = edoCtaCredClienteServicio;
	}


	
}
