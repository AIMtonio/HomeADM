package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;

public class ParamPLDControlador extends SimpleFormController {
	ParametrosSisServicio	parametrosSisServicio	= null;
	public ParamPLDControlador() {
		setCommandClass(ParametrosSisBean.class);
		setCommandName("parametrosSisBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		parametrosSisServicio.getParametrosSisDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ParametrosSisBean parametrosSisBean = (ParametrosSisBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosSisServicio.actualizacion(tipoTransaccion, parametrosSisBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}
	
	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}
