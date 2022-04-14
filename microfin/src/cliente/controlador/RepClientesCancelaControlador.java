package cliente.controlador;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClientesCancelaBean;
import cliente.servicio.ClientesCancelaServicio;


public class RepClientesCancelaControlador extends SimpleFormController {
	
	ClientesCancelaServicio clientesCancelaServicio = null;

	public RepClientesCancelaControlador() {
		setCommandClass(ClientesCancelaBean.class);
		setCommandName("clientesCancelaBean");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		clientesCancelaServicio.getClientesCancelaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ClientesCancelaBean bean = (ClientesCancelaBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		int tipoActualizacion = 0;
		MensajeTransaccionBean mensaje = null;
		mensaje = clientesCancelaServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion,bean);
												
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	

	public ClientesCancelaServicio getClientesCancelaServicio() {
		return clientesCancelaServicio;
	}
	public void setClientesCancelaServicio(
			ClientesCancelaServicio clientesCancelaServicio) {
		this.clientesCancelaServicio = clientesCancelaServicio;
	}
}


