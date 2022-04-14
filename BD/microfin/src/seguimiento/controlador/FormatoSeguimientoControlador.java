package seguimiento.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguimiento.bean.FormatoSeguimientoBean;
import seguimiento.bean.SeguimientoBean;
import seguimiento.servicio.FormatoSeguimientoServicio;


public class FormatoSeguimientoControlador extends SimpleFormController{
	
	FormatoSeguimientoServicio formatoSeguimientoServicio = null;
	public FormatoSeguimientoControlador(){
		setCommandClass(FormatoSeguimientoBean.class);
		setCommandName("formatoSeguimientoBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

			SeguimientoBean seguimientoBean = (SeguimientoBean) command;
			
			formatoSeguimientoServicio.getSeguimientoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
						0;
			MensajeTransaccionBean mensaje = null;
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	// Getter y Setter
	public FormatoSeguimientoServicio getFormatoSeguimientoServicio() {
		return formatoSeguimientoServicio;
	}
	public void setFormatoSeguimientoServicio(
			FormatoSeguimientoServicio formatoSeguimientoServicio) {
		this.formatoSeguimientoServicio = formatoSeguimientoServicio;
	}
	
}