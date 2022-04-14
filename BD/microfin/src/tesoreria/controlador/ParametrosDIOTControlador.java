
package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.ParametrosDIOTBean;
import tesoreria.servicio.ParametrosDIOTServicio;


public class ParametrosDIOTControlador  extends SimpleFormController{
	
	ParametrosDIOTServicio parametrosDIOTServicio = null;

	public ParametrosDIOTControlador() {
		setCommandClass(ParametrosDIOTBean.class);
		setCommandName("parametrosDIOT");
}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		parametrosDIOTServicio.getParametrosDIOTDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ParametrosDIOTBean parametros = (ParametrosDIOTBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		

		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosDIOTServicio.grabaTransaccion(tipoTransaccion,parametros);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ParametrosDIOTServicio getParametrosDIOTServicio() {
		return parametrosDIOTServicio;
	}

	public void setParametrosDIOTServicio(
			ParametrosDIOTServicio parametrosDIOTServicio) {
		this.parametrosDIOTServicio = parametrosDIOTServicio;
	}

		
		
		
		
}
