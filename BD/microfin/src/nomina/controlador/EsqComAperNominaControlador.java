package nomina.controlador;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.EsqComAperNominaBean;
import nomina.servicio.EsqComAperNominaServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;

 
public class EsqComAperNominaControlador extends SimpleFormController {
	EsqComAperNominaServicio esqComAperNominaServicio = null;
	
	public EsqComAperNominaControlador() {
		setCommandClass(EsqComAperNominaBean.class);
		setCommandName("esqComAperNominaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
				
		EsqComAperNominaBean esqComAperNominaBean = (EsqComAperNominaBean)command;
		
		MensajeTransaccionBean mensaje = null;
		
		esqComAperNominaServicio.getEsqComAperNominaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
			
		mensaje = esqComAperNominaServicio.grabaTransaccion(tipoTransaccion,esqComAperNominaBean);

		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}

	public EsqComAperNominaServicio getEsqComAperNominaServicio() {
		return esqComAperNominaServicio;
	}

	public void setEsqComAperNominaServicio(
			EsqComAperNominaServicio esqComAperNominaServicio) {
		this.esqComAperNominaServicio = esqComAperNominaServicio;
	}

	// ============== GETTER & SETTER ============= //

}
