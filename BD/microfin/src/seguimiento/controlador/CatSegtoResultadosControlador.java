package seguimiento.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguimiento.bean.SegtoResultadosBean;
import seguimiento.servicio.SegtoResultadosServicio;

public class CatSegtoResultadosControlador extends SimpleFormController {

	
	SegtoResultadosServicio segtoResultadosServicio=null;

	public CatSegtoResultadosControlador(){
		setCommandClass(SegtoResultadosBean.class);
		setCommandName("catSegtoResultados");
		
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		SegtoResultadosBean segtoRecomendasBean = (SegtoResultadosBean)command;
		segtoResultadosServicio.getSegtoResultadosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = segtoResultadosServicio.grabaTransaccion(tipoTransaccion, segtoRecomendasBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SegtoResultadosServicio getSegtoResultadosServicio() {
		return segtoResultadosServicio;
	}

	public void setSegtoResultadosServicio(
			SegtoResultadosServicio segtoResultadosServicio) {
		this.segtoResultadosServicio = segtoResultadosServicio;
	}
	

}