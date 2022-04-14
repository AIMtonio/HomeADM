package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.OrganoIntegraBean;
import soporte.servicio.OrganoIntegraServicio;

public class OrganoIntegraControlador extends SimpleFormController{
	OrganoIntegraServicio organoIntegraServicio = null;
	
	public OrganoIntegraControlador() {
		setCommandClass(OrganoIntegraBean.class);
		setCommandName("organoIntegra");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		OrganoIntegraBean organoIntegra = (OrganoIntegraBean) command;
		String listaDatos = request.getParameter("datosOrganoIntegra");
		MensajeTransaccionBean mensaje = null;

		mensaje = organoIntegraServicio.grabaTransaccion(tipoTransaccion,organoIntegra,listaDatos);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	//------------setter---------------
	public void setOrganoIntegraServicio(OrganoIntegraServicio organoIntegraServicio) {
		this.organoIntegraServicio = organoIntegraServicio;
	}

	
	

}
