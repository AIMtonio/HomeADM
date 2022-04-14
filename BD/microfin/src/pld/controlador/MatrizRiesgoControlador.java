package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.MatrizRiesgoBean;
import pld.servicio.MatrizRiesgoServicio;

@SuppressWarnings("deprecation")
public class MatrizRiesgoControlador extends SimpleFormController{

	MatrizRiesgoServicio  matrizRiesgoServicio=null;
	
	public MatrizRiesgoControlador() {
		setCommandClass(MatrizRiesgoBean.class);
		setCommandName("conceptoMatriz");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		MatrizRiesgoBean matrizRiesgoBean = (MatrizRiesgoBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = matrizRiesgoServicio.grabaTransaccion(matrizRiesgoBean,tipoTransaccion);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
}

	public MatrizRiesgoServicio getMatrizRiesgoServicio() {
		return matrizRiesgoServicio;
	}

	public void setMatrizRiesgoServicio(MatrizRiesgoServicio matrizRiesgoServicio) {
		this.matrizRiesgoServicio = matrizRiesgoServicio;
	}

	
}
