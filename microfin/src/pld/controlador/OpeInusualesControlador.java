package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.OpIntPreocupantesBean;
import pld.bean.OpeInusualesBean;
import pld.servicio.OpIntPreocupantesServicio;
import pld.servicio.OpeInusualesServicio;

public class OpeInusualesControlador extends SimpleFormController{
	

	private OpeInusualesServicio opeInusualesServicio;
	
	public OpeInusualesControlador() {
		setCommandClass(OpeInusualesBean.class);
		setCommandName("opeInusuales");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		opeInusualesServicio.getOpeInusualesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		OpeInusualesBean opeInusuales = (OpeInusualesBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = opeInusualesServicio.grabaTransaccion(tipoTransaccion, opeInusuales);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public OpeInusualesServicio getOpeInusualesServicio() {
		return opeInusualesServicio;
	}
	public void setOpeInusualesServicio(
			OpeInusualesServicio opeInusualesServicio) {
		this.opeInusualesServicio = opeInusualesServicio;
	}

	
	
}
