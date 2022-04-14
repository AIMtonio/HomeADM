package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.CorreoServicio;
import tesoreria.bean.ProveedoresBean;
import tesoreria.servicio.ProveedoresServicio;

public class ProveedoresControlador  extends SimpleFormController{

	ProveedoresServicio proveedoresServicio = null;
	CorreoServicio correoServicio = null;

	public ProveedoresControlador() {
		setCommandClass(ProveedoresBean.class);
		setCommandName("proveedores");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		proveedoresServicio.getproveedoresDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ProveedoresBean proveedores = (ProveedoresBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));


		MensajeTransaccionBean mensaje = null;
		mensaje = proveedoresServicio.grabaTransaccion(tipoTransaccion,proveedores);
		
		try {//No quitar este try con esto se controla si hay error en el envio continua con la operacion
			correoServicio.EjecutaEnvioCorreo();//Ejecuta el envio de correo
		} catch (Exception exa) {
			exa.printStackTrace();
		}

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ProveedoresServicio getProveedoresServicio() {
		return proveedoresServicio;
	}

	public void setProveedoresServicio(ProveedoresServicio proveedoresServicio) {
		this.proveedoresServicio = proveedoresServicio;
	}

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

}