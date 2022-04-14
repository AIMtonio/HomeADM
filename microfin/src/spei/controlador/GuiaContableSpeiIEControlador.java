package spei.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import spei.bean.GuiaContableSpeiIEBean;
import spei.servicio.GuiaContableSpeiIEServicio;

public class GuiaContableSpeiIEControlador extends SimpleFormController{
	
	GuiaContableSpeiIEServicio guiaContableSpeiIEServicio = null;

 	public GuiaContableSpeiIEControlador(){
 		setCommandClass(GuiaContableSpeiIEBean.class);
 		setCommandName("guiaContableSpeiIEBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
 		guiaContableSpeiIEServicio.getGuiaContableSpeiIEDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		GuiaContableSpeiIEBean guiaContableSpeiIEBean = (GuiaContableSpeiIEBean) command;

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
			Integer.parseInt(request.getParameter("tipoTransaccion")):
		0;

			MensajeTransaccionBean mensaje = null;
			mensaje = guiaContableSpeiIEServicio.grabaTransaccion(tipoTransaccion, guiaContableSpeiIEBean);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);


 	}
 	// ---------------  getter y setter -------------------- 
	public GuiaContableSpeiIEServicio getGuiaContableSpeiIEServicio() {
		return guiaContableSpeiIEServicio;
	}

	public void setGuiaContableSpeiIEServicio(
			GuiaContableSpeiIEServicio guiaContableSpeiIEServicio) {
		this.guiaContableSpeiIEServicio = guiaContableSpeiIEServicio;
	}

}
