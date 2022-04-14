package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarDebConciliaATMBean;
import tarjetas.servicio.TarDebConciliaATMServicio;


public class CargaConciliacionATMControlador extends SimpleFormController{

	TarDebConciliaATMServicio tarDebConciliaATMServicio = null;
	public CargaConciliacionATMControlador(){
		setCommandClass(TarDebConciliaATMBean.class);
 		setCommandName("cargaConciliaATMBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		tarDebConciliaATMServicio.getTarDebConciliaATMDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		TarDebConciliaATMBean tarjetaConciATMBean = (TarDebConciliaATMBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		mensaje = tarDebConciliaATMServicio.grabaTransaccion(tipoTransaccion, tarjetaConciATMBean);
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TarDebConciliaATMServicio getTarDebConciliaATMServicio() {
		return tarDebConciliaATMServicio;
	}

	public void setTarDebConciliaATMServicio(
			TarDebConciliaATMServicio tarDebConciliaATMServicio) {
		this.tarDebConciliaATMServicio = tarDebConciliaATMServicio;
	}
	
}
