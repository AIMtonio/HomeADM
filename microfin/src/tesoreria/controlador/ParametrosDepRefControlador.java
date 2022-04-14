package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.ParametrosDepRefBean;
import tesoreria.servicio.ParametrosDepRefServicio;

public class ParametrosDepRefControlador  extends SimpleFormController{
	ParametrosDepRefServicio parametrosDepRefServicio = null;


	public ParametrosDepRefControlador(){
		setCommandClass(ParametrosDepRefBean.class);
		setCommandName("parametrosDepRef");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		ParametrosDepRefBean parametros = (ParametrosDepRefBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosDepRefServicio.grabaTransaccion(tipoTransaccion,parametros);
		
		

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ParametrosDepRefServicio getParametrosDepRefServicio() {
		return parametrosDepRefServicio;
	}

	public void setParametrosDepRefServicio(ParametrosDepRefServicio parametrosDepRefServicio) {
		this.parametrosDepRefServicio = parametrosDepRefServicio;
	}
}
