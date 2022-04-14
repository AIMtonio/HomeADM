package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarDebConciliaCorrespBean;
import tarjetas.servicio.TarDebConciliaCorrespServicio;

public class TarDebConciliaCorrespControlador extends SimpleFormController {
	
	TarDebConciliaCorrespServicio	tarDebConciliaCorrespServicio	= null;
	public TarDebConciliaCorrespControlador() {
		setCommandClass(TarDebConciliaCorrespBean.class);
		setCommandName("tarDebConciliaMovs");
	}
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		tarDebConciliaCorrespServicio.getTarDebConciliaCorrespDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		TarDebConciliaCorrespBean tarDebConciliaBean = (TarDebConciliaCorrespBean) command;
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		MensajeTransaccionBean mensaje = null;
		mensaje = tarDebConciliaCorrespServicio.grabaTransaccion(tarDebConciliaBean, tipoTransaccion);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public TarDebConciliaCorrespServicio getTarDebConciliaCorrespServicio() {
		return tarDebConciliaCorrespServicio;
	}
	public void setTarDebConciliaCorrespServicio(TarDebConciliaCorrespServicio tarDebConciliaCorrespServicio) {
		this.tarDebConciliaCorrespServicio = tarDebConciliaCorrespServicio;
	}
	
}