package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.TesoMovsConciliaBean;
import tesoreria.servicio.TesoMovsConciliaServicio;

public class TesoMovsConciliaManualControlador extends  SimpleFormController {	

	TesoMovsConciliaServicio tesoMovsConciliaServicio = null;
	
	public TesoMovsConciliaManualControlador(){
		setCommandClass(TesoMovsConciliaBean.class);
		setCommandName("conciliacion");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		tesoMovsConciliaServicio.getTesoMovsConciliaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		TesoMovsConciliaBean tesomovs = (TesoMovsConciliaBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
	
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		mensaje = tesoMovsConciliaServicio.grabaTransaccion(tesomovs,tipoTransaccion);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);	
	}

	public TesoMovsConciliaServicio getTesoMovsConciliaServicio() {
		return tesoMovsConciliaServicio;
	}

	public void setTesoMovsConciliaServicio(
			TesoMovsConciliaServicio tesoMovsConciliaServicio) {
		this.tesoMovsConciliaServicio = tesoMovsConciliaServicio;
	}

	
}
