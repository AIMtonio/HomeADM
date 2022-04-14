package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.servicio.CatCajerosATMServicio;
import tesoreria.bean.CatCajerosATMBean;


public class CatCajerosATMControlador extends SimpleFormController{
	CatCajerosATMServicio catCajerosATMServicio=null;

	public CatCajerosATMControlador() {
		setCommandClass(CatCajerosATMBean.class);
		setCommandName("catCajerosATMBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		catCajerosATMServicio.getCatCajerosATMDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		CatCajerosATMBean catCajerosATM= (CatCajerosATMBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		int tipoActualizacion =(request.getParameter("tipoActualizacion")!=null)?
				Integer.parseInt(request.getParameter("tipoActualizacion")):
					0;
		MensajeTransaccionBean mensaje = null;
		mensaje = catCajerosATMServicio.grabaTransaccion(tipoTransaccion,catCajerosATM,tipoActualizacion);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CatCajerosATMServicio getCatCajerosATMServicio() {
		return catCajerosATMServicio;
	}

	public void setCatCajerosATMServicio(CatCajerosATMServicio catCajerosATMServicio) {
		this.catCajerosATMServicio = catCajerosATMServicio;
	}
	
	
	
	
}
