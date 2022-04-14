package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;



import soporte.bean.EdoCtaClavePDFBean;
import soporte.servicio.EdoCtaClavePDFServicio;

public class EdoCtaClavePDFControlador extends SimpleFormController {
	EdoCtaClavePDFServicio edoCtaClavePDFServicio;

	public EdoCtaClavePDFControlador(){
		setCommandClass(EdoCtaClavePDFBean.class);
 		setCommandName("edoCtaClavePDFBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		edoCtaClavePDFServicio.getEdoCtaClavePDFDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		EdoCtaClavePDFBean edoCtaClavePDFBean = (EdoCtaClavePDFBean) command;
		edoCtaClavePDFBean.setClienteID(request.getParameter("clienteID"));
		edoCtaClavePDFBean.setContrasenia(request.getParameter("contrasenia"));
		
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):0;					
		MensajeTransaccionBean mensaje = null;
		mensaje = edoCtaClavePDFServicio.grabaTransaccion(tipoTransaccion, edoCtaClavePDFBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public EdoCtaClavePDFServicio getEdoCtaClavePDFServicio() {
		return edoCtaClavePDFServicio;
	}

	public void setEdoCtaClavePDFServicio(
			EdoCtaClavePDFServicio edoCtaClavePDFServicio) {
		this.edoCtaClavePDFServicio = edoCtaClavePDFServicio;
	}
}
