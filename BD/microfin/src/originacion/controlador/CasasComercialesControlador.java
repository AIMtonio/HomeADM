package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.CasasComercialesBean;
import originacion.servicio.CasasComercialesServicio;

public class CasasComercialesControlador extends SimpleFormController{
	
	CasasComercialesServicio casasComercialesServicio =  null;
	
	public CasasComercialesControlador() { 
		setCommandClass(CasasComercialesBean.class);
		setCommandName("casaComercial"); 
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errores) throws Exception {
		
		casasComercialesServicio.getCasasComercialesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		CasasComercialesBean casaComercialBean = (CasasComercialesBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = casasComercialesServicio.grabaTransaccion(tipoTransaccion, casaComercialBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public CasasComercialesServicio getCasasComercialesServicio(){
		return casasComercialesServicio;
	}
	
	public void setCasasComercialesServicio(CasasComercialesServicio casasComercialesServicio){
		this.casasComercialesServicio = casasComercialesServicio;
	}

}
