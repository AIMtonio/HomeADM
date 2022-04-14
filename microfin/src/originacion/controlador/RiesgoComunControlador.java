package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.RiesgoComunBean;
import originacion.servicio.RiesgoComunServicio;


public class RiesgoComunControlador extends SimpleFormController{
	RiesgoComunServicio riesgoComunServicio = null;
	
	public RiesgoComunControlador(){
		setCommandClass(RiesgoComunBean.class);
		setCommandName("riesgoComun");		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		riesgoComunServicio.getRiesgoComunDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		RiesgoComunBean riesgoComunBean = (RiesgoComunBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));				
		MensajeTransaccionBean mensaje = null;
		
		mensaje = riesgoComunServicio.grabaTransaccion(tipoTransaccion, riesgoComunBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RiesgoComunServicio getRiesgoComunServicio() {
		return riesgoComunServicio;
	}

	public void setRiesgoComunServicio(RiesgoComunServicio riesgoComunServicio) {
		this.riesgoComunServicio = riesgoComunServicio;
	}
	
	
	
}
