package bancaMovil.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import bancaMovil.bean.BAMImagenAntiphishingBean;
import bancaMovil.servicio.BAMImagenAntiphishingServicio;

@SuppressWarnings("deprecation")
public class BAMImagenAntiphishingVerControlador extends AbstractCommandController{
	BAMImagenAntiphishingServicio imagenServicio=null;
	
	public BAMImagenAntiphishingVerControlador() {
		setCommandClass(BAMImagenAntiphishingBean.class);
		setCommandName("imagen");
	}
	
 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
 		
 			return null;
			
		}
		
	
	public BAMImagenAntiphishingServicio getImagenServicio() {
		return imagenServicio;
	}

	public void setImagenServicio(BAMImagenAntiphishingServicio imagenServicio) {
		this.imagenServicio = imagenServicio;
	}

}
