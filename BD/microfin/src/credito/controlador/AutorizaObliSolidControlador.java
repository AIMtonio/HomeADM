package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.AutorizaObliSolidBean;
import credito.servicio.AutorizaObliSolidServicio;

public class AutorizaObliSolidControlador extends SimpleFormController{
	

	private AutorizaObliSolidServicio autorizaObliSolidServicio;
	
	public AutorizaObliSolidControlador() {
		setCommandClass(AutorizaObliSolidBean.class);
		setCommandName("autorizaObligados");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		autorizaObliSolidServicio.getAutorizaObliSolidDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		AutorizaObliSolidBean autorizaObligados = (AutorizaObliSolidBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		String obligadosDetalle = request.getParameter("obligados");
					
		MensajeTransaccionBean mensaje = null;
		mensaje = autorizaObliSolidServicio.grabaListaObligados(tipoTransaccion, autorizaObligados, obligadosDetalle);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public AutorizaObliSolidServicio getAutorizaObliSolidServicio() {
		return autorizaObliSolidServicio;
	}
	public void setAutorizaObliSolidServicio(
			AutorizaObliSolidServicio autorizaObliSolidServicio) {
		this.autorizaObliSolidServicio = autorizaObliSolidServicio;
	}
	
	
}
