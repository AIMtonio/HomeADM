package nomina.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.PagoNominaBean;
import nomina.bean.ParametrosNominaBean;
import nomina.servicio.PagoNominaServicio;
import nomina.servicio.ParametrosNominaServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class ParametrosNominaControlador extends SimpleFormController{
	ParametrosNominaServicio parametrosNominaServicio = null;

	public ParametrosNominaControlador() {
		setCommandClass(ParametrosNominaBean.class);
		setCommandName("paramsNominaBean");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
	
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	
				ParametrosNominaBean paramsNominaBean = (ParametrosNominaBean) command;
		MensajeTransaccionBean mensaje = null;
		parametrosNominaServicio.getParametrosNominaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		mensaje = parametrosNominaServicio.grabaTransaccion(tipoTransaccion,paramsNominaBean);
	
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public ParametrosNominaServicio getParametrosNominaServicio() {
		return parametrosNominaServicio;
	}
	public void setParametrosNominaServicio(
			ParametrosNominaServicio parametrosNominaServicio) {
		this.parametrosNominaServicio = parametrosNominaServicio;
	}
	
	
	
}
