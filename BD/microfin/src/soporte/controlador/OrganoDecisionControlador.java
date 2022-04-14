package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.OrganoDecisionServicio;
import soporte.bean.OrganoDecisionBean;

public class OrganoDecisionControlador extends SimpleFormController  {
	
	
	private OrganoDecisionServicio organoDecisionServicio;
	
	public OrganoDecisionControlador() {
		setCommandClass(OrganoDecisionBean.class);
		setCommandName("organosDecision");
	}	
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
									BindException errors) throws Exception {
	
		OrganoDecisionBean organoDecisionBean = (OrganoDecisionBean) command;
		
		organoDecisionServicio.getOrganoDecisionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		
		
		
		MensajeTransaccionBean mensaje = null;
		mensaje = organoDecisionServicio.grabaTransaccion(tipoTransaccion, organoDecisionBean);
	
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

//------setter--------------

	public void setOrganoDecisionServicio(
			OrganoDecisionServicio organoDecisionServicio) {
		this.organoDecisionServicio = organoDecisionServicio;
	}

}
