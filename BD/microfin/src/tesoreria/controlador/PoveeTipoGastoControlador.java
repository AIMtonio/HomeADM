
package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.ProveedoresBean;
import tesoreria.servicio.ProveedoresServicio;

public class PoveeTipoGastoControlador  extends SimpleFormController{
	
	ProveedoresServicio proveedoresServicio = null;

	public PoveeTipoGastoControlador() {
		setCommandClass(ProveedoresBean.class);
		setCommandName("proveedoresTipoGasto");
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
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
		public void setProveedoresServicio(ProveedoresServicio proveedoresServicio) {
			this.proveedoresServicio = proveedoresServicio;
	}
}