package seguimiento.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguimiento.bean.SegtoRecomendasBean;
import seguimiento.servicio.SegtoRecomendasServicio;

public class CatSegtoRecomendaControlador extends SimpleFormController{
	
	SegtoRecomendasServicio segtoRecomendasServicio=null;

	public CatSegtoRecomendaControlador(){
		setCommandClass(SegtoRecomendasBean.class);
		setCommandName("catSegtoRecomendas");
		
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		SegtoRecomendasBean segtoRecomendasBean = (SegtoRecomendasBean)command;
		segtoRecomendasServicio.getSegtoRecomendasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = segtoRecomendasServicio.grabaTransaccion(tipoTransaccion, segtoRecomendasBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public SegtoRecomendasServicio getSegtoRecomendasServicio() {
		return segtoRecomendasServicio;
	}

	public void setSegtoRecomendasServicio(
			SegtoRecomendasServicio segtoRecomendasServicio) {
		this.segtoRecomendasServicio = segtoRecomendasServicio;
	}
}
