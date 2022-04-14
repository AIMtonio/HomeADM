package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClientesPROFUNBean;
import cliente.servicio.ClientesPROFUNServicio;

public class ClientesPROFUNControlador extends SimpleFormController {
	ClientesPROFUNServicio clientesPROFUNServicio = null;
 	
	public ClientesPROFUNControlador() {
		setCommandClass(ClientesPROFUNBean.class);
		setCommandName("clientesPROFUN");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		clientesPROFUNServicio.getClientesPROFUNDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ClientesPROFUNBean clientesPROFUN = (ClientesPROFUNBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;

		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
					Integer.parseInt(request.getParameter("tipoActualizacion")):
					0;
					
		MensajeTransaccionBean mensaje = null;
		mensaje = clientesPROFUNServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, clientesPROFUN);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ClientesPROFUNServicio getClientesPROFUNServicio() {
		return clientesPROFUNServicio;
	}

	public void setClientesPROFUNServicio(
			ClientesPROFUNServicio clientesPROFUNServicio) {
		this.clientesPROFUNServicio = clientesPROFUNServicio;
	}

}
