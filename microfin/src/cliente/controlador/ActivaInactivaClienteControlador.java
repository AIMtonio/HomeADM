package cliente.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;

public class ActivaInactivaClienteControlador extends SimpleFormController {
	
	ClienteServicio clienteServicio = null;
	public ActivaInactivaClienteControlador() {
		setCommandClass(ClienteBean.class);
		setCommandName("cliente");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		clienteServicio.getClienteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ClienteBean cliente = (ClienteBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		cliente.setClaveUsuAuto((request.getParameter("claveUsuarioAut")!=null) ? request.getParameter("claveUsuarioAut") : Constantes.STRING_VACIO);
		cliente.setContraseniaUsu((request.getParameter("contraseniaAut")!=null) ? request.getParameter("contraseniaAut") : Constantes.STRING_VACIO);
		MensajeTransaccionBean mensaje = null;
		mensaje = clienteServicio.grabaTransaccion(tipoTransaccion,cliente);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}

	
}
