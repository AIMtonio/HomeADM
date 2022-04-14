package cuentas.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.CorreoServicio;
import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.CuentasPersonaServicio;

public class CuentasPersonaControlador extends SimpleFormController {
	
	CuentasPersonaServicio	cuentasPersonaServicio	= null;
	private CorreoServicio	correoServicio			= null;
	
	public CuentasPersonaControlador() {
		setCommandClass(CuentasPersonaBean.class);
		setCommandName("cuentasPersonaBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			CuentasPersonaBean cuentasPersonaBean = (CuentasPersonaBean) command;
			cuentasPersonaServicio.getCuentasPersonaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			cuentasPersonaBean.setClienteID(request.getParameter("numeroCte"));
			mensaje = cuentasPersonaServicio.grabaTransaccion(tipoTransaccion, cuentasPersonaBean);
			
			try {
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
	
	public CuentasPersonaServicio getCuentasPersonaServicio() {
		return cuentasPersonaServicio;
	}
	
	public void setCuentasPersonaServicio(
			CuentasPersonaServicio cuentasPersonaServicio) {
		this.cuentasPersonaServicio = cuentasPersonaServicio;
	}
	
	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}
	
	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}
	
}
