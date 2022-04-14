package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.MatrizRiesgoBean;
import pld.servicio.MatrizRiesgoServicio;

public class EvalMatrizRiesgoControlador extends SimpleFormController{

	MatrizRiesgoServicio matrizRiesgoServicio = null;

	public EvalMatrizRiesgoControlador() {
		setCommandClass(MatrizRiesgoBean.class);
		setCommandName("matrizRiesgoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			MatrizRiesgoBean matrizRiesgoBean = (MatrizRiesgoBean) command;
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			
			matrizRiesgoServicio.getMatrizRiesgoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

			mensaje = matrizRiesgoServicio.grabaTransaccion(matrizRiesgoBean,tipoTransaccion);
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje=new MensajeTransaccionBean();
			mensaje.setNumero(800);
			mensaje.setDescripcion("No se pudo realizar la operacion. Ha ocurrido un error.");
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public MatrizRiesgoServicio getMatrizRiesgoServicio() {
		return matrizRiesgoServicio;
	}

	public void setMatrizRiesgoServicio(MatrizRiesgoServicio matrizRiesgoServicio) {
		this.matrizRiesgoServicio = matrizRiesgoServicio;
	}

}