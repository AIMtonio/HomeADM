package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;

public class FlujoClienteControlador extends SimpleFormController {
	
	ClienteServicio clienteServicio = null;
 	private ParametrosSesionBean parametrosSesionBean = null;

	public FlujoClienteControlador() {
		setCommandClass(ClienteBean.class);
		setCommandName("cliente");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		clienteServicio.getClienteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ClienteBean cliente = (ClienteBean) command;
//		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
//		mensaje = clienteServicio.grabaTransaccion(tipoTransaccion,cliente);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
}
