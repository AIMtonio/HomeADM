package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import soporte.bean.ValidaCajasTransferBean;
import soporte.servicio.ValidaCajasTransferServicio;

public class ValidaCajasTransferControlador extends SimpleFormController{

	ValidaCajasTransferServicio validaCajasTransferServicio = null;


	public ValidaCajasTransferControlador(){
		setCommandClass(ValidaCajasTransferBean.class);
		setCommandName("validaCajaTrans");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		validaCajasTransferServicio.getValidaCajasTransferDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ValidaCajasTransferBean validaCajasTransferBean = (ValidaCajasTransferBean) command;
		MensajeTransaccionBean mensaje = null;
		String detalle = "";
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
		
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
								Integer.parseInt(request.getParameter("tipoActualizacion")):
								0;
		detalle = (tipoTransaccion == 2) ? request.getParameter("detalle") :"";
		mensaje = validaCajasTransferServicio.grabaTransaccion(validaCajasTransferBean, tipoTransaccion, tipoActualizacion, detalle);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ValidaCajasTransferServicio getValidaCajasTransferServicio() {
		return validaCajasTransferServicio;
	}

	public void setvalidaCajasTransferServicio(ValidaCajasTransferServicio validaCajasTransferServicio) {
		this.validaCajasTransferServicio = validaCajasTransferServicio;
	}
}