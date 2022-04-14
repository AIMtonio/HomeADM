package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import tesoreria.bean.DivisasBean;
import tesoreria.servicio.DivisasServicio;


public class DivisasControlador extends SimpleFormController{
	
	//CuentaNostroServicio cuentaNostroServicio =null;
	DivisasServicio divisasServicio = null;
	
	public DivisasControlador() { 
		setCommandClass(DivisasBean.class);
		setCommandName("divisas"); 
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		DivisasBean divisaBean = (DivisasBean) command;
		divisasServicio.getDivisasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());	
		
        int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
	

		MensajeTransaccionBean mensaje = null;
		mensaje = divisasServicio.grabaTransaccion(tipoTransaccion, divisaBean);
        
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setDivisasServicio(DivisasServicio divisasServicio) {
		this.divisasServicio = divisasServicio;
	}


}
