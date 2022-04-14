package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.TasaImpuestoISRBean;
import tesoreria.servicio.TasaImpuestoISRServicio;

public class TasaImpuestoISRControlador extends SimpleFormController{
	
	TasaImpuestoISRServicio tasaImpuestoISRServicio = null;

	public TasaImpuestoISRControlador(){
		setCommandClass(TasaImpuestoISRBean.class);
		setCommandName("tasaImpuestoISRBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		tasaImpuestoISRServicio.getTasaImpuestoISRDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		TasaImpuestoISRBean tasaImpuestoISRBean = (TasaImpuestoISRBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = tasaImpuestoISRServicio.grabaTransaccion(tipoTransaccion, tasaImpuestoISRBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TasaImpuestoISRServicio getTasaImpuestoISRServicio() {
		return tasaImpuestoISRServicio;
	}

	public void setTasaImpuestoISRServicio(TasaImpuestoISRServicio tasaImpuestoISRServicio){
		this.tasaImpuestoISRServicio = tasaImpuestoISRServicio;
	}
}