package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.MatrizRiesgoPuntosBean;
import pld.servicio.MatrizRiesgoPuntosServicio;

public class MatrizRiesgoPuntosControlador extends SimpleFormController {
	MatrizRiesgoPuntosServicio	matrizRiesgoPuntosServicio;
	public MatrizRiesgoPuntosControlador() {
		setCommandClass(MatrizRiesgoPuntosBean.class);
		setCommandName("matrizRiesgoPuntos");
	}
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			MatrizRiesgoPuntosBean bean = (MatrizRiesgoPuntosBean) command;
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			mensaje = matrizRiesgoPuntosServicio.grabaTransaccion(tipoTransaccion, bean);
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje = new MensajeTransaccionBean();
			if(mensaje.getNumero()==0){
				mensaje.setNumero(888);
			}
			mensaje.setDescripcion(ex.getMessage());
		} finally {
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(777);
				mensaje.setDescripcion("Error al guardar la Configuración de la Matriz de Riesgo.");
			}
		}
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public MatrizRiesgoPuntosServicio getMatrizRiesgoPuntosServicio() {
		return matrizRiesgoPuntosServicio;
	}
	
	public void setMatrizRiesgoPuntosServicio(MatrizRiesgoPuntosServicio matrizRiesgoPuntosServicio) {
		this.matrizRiesgoPuntosServicio = matrizRiesgoPuntosServicio;
	}
}
