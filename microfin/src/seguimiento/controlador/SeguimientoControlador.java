package seguimiento.controlador;

import java.util.List;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguimiento.bean.SeguimientoBean;
import seguimiento.servicio.SeguimientoServicio;

public class SeguimientoControlador extends SimpleFormController {

	SeguimientoServicio seguimientoServicio  = null;
	public SeguimientoControlador(){
		setCommandClass(SeguimientoBean.class);
		setCommandName("seguimientoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		SeguimientoBean seguimiento = (SeguimientoBean)command;
		seguimientoServicio.getSeguimientoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
				
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = seguimientoServicio.grabaTransaccion(tipoTransaccion, seguimiento);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SeguimientoServicio getSeguimientoServicio() {
		return seguimientoServicio;
	}

	public void setSeguimientoServicio(SeguimientoServicio seguimientoServicio) {
		this.seguimientoServicio = seguimientoServicio;
	}
	
}