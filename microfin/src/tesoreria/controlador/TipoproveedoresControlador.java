
package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.TipoproveedoresBean;
import tesoreria.servicio.TipoproveedoresServicio;


public class TipoproveedoresControlador  extends SimpleFormController{
	
	TipoproveedoresServicio tipoproveedoresServicio = null;

	public TipoproveedoresControlador() {
		setCommandClass(TipoproveedoresBean.class);
		setCommandName("tiposproveedores");
}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		tipoproveedoresServicio.getTipoproveedoresDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TipoproveedoresBean tipoproveedores = (TipoproveedoresBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		

		MensajeTransaccionBean mensaje = null;
		mensaje = tipoproveedoresServicio.grabaTransaccion(tipoTransaccion,tipoproveedores);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

		public TipoproveedoresServicio getTipoproveedoresServicio() {
			return tipoproveedoresServicio;
		}

		public void setTipoproveedoresServicio(
				TipoproveedoresServicio tipoproveedoresServicio) {
			this.tipoproveedoresServicio = tipoproveedoresServicio;
		}
		
		
		
		
}
