package cliente.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.CorreoServicio;
import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;

public class ClienteControlador extends SimpleFormController {
	
	private ClienteServicio			clienteServicio			= null;
	private CorreoServicio			correoServicio			= null;
	
	private ParametrosSesionBean	parametrosSesionBean	= null;
	
	public ClienteControlador() {
		setCommandClass(ClienteBean.class);
		setCommandName("cliente");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			clienteServicio.getClienteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			ClienteBean cliente = (ClienteBean) command;
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			
			mensaje = clienteServicio.grabaTransaccion(tipoTransaccion, cliente);
			
			try {//No quitar este try con esto se controla si hay error en el envio continua con la operacion
				correoServicio.EjecutaEnvioCorreo();//Ejecuta el envio de correo
			} catch (Exception exa) {
				exa.printStackTrace();
			}
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
	
	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}
	
	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}
	
	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}
	
	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
}
