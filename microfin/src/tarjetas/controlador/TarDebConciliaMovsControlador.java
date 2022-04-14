package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarDebConciEncabezaBean;
import tarjetas.servicio.TarDebConciliaMovsServicio;

public class TarDebConciliaMovsControlador extends SimpleFormController{

	TarDebConciliaMovsServicio tarDebConciliaMovsServicio = null;
	public TarDebConciliaMovsControlador() {
		setCommandClass(TarDebConciEncabezaBean.class);
		setCommandName("tarDebConciliaMovs");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		tarDebConciliaMovsServicio.getTarDebConciliaMovsDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		TarDebConciEncabezaBean tarDebConciliaBean = (TarDebConciEncabezaBean) command;
			
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		MensajeTransaccionBean mensaje = null;
		mensaje = tarDebConciliaMovsServicio.grabaTransaccion(tarDebConciliaBean, tipoTransaccion);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public TarDebConciliaMovsServicio getTarDebConciliaMovsServicio() {
		return tarDebConciliaMovsServicio;
	}
	public void setTarDebConciliaMovsServicio(
			TarDebConciliaMovsServicio tarDebConciliaMovsServicio) {
		this.tarDebConciliaMovsServicio = tarDebConciliaMovsServicio;
	}
}