package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.AutorizaAvalesBean;
import credito.servicio.AutorizaAvalesServicio;

public class AutorizaAvalesControlador extends SimpleFormController{
	

	private AutorizaAvalesServicio autorizaAvalesServicio;
	
	public AutorizaAvalesControlador() {
		setCommandClass(AutorizaAvalesBean.class);
		setCommandName("autorizaAvales");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		autorizaAvalesServicio.getAutorizaAvalesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		AutorizaAvalesBean autorizaAvales = (AutorizaAvalesBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		String avalesDetalle = request.getParameter("avales");
					
		MensajeTransaccionBean mensaje = null;
		mensaje = autorizaAvalesServicio.grabaListaAvales(tipoTransaccion, autorizaAvales, avalesDetalle);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public AutorizaAvalesServicio getAutorizaAvalesServicio() {
		return autorizaAvalesServicio;
	}
	public void setAutorizaAvalesServicio(
			AutorizaAvalesServicio autorizaAvalesServicio) {
		this.autorizaAvalesServicio = autorizaAvalesServicio;
	}
	
	
}
