package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.RepEstadisticoBean;
import cliente.servicio.RepEstadisticoServicio;

public class RepEstadisticoControlador extends SimpleFormController{
	
	RepEstadisticoServicio repEstadisticoServicio=null;
				
	public RepEstadisticoControlador() {
		setCommandClass(RepEstadisticoBean.class);
		setCommandName("RepEstadisticoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public RepEstadisticoServicio getRepEstadisticoServicio() {
		return repEstadisticoServicio;
	}
	public void setRepEstadisticoServicio(
			RepEstadisticoServicio repEstadisticoServicio) {
		this.repEstadisticoServicio = repEstadisticoServicio;
	}
	
	
	
}
