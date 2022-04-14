package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.NivelesRiesgoBean;
import pld.servicio.NivelesRiesgoServicio;
import ventanilla.bean.OpcionesPorCajaBean;

@SuppressWarnings("deprecation")
public class NivelesRiesgoControlador extends SimpleFormController{
	NivelesRiesgoServicio nivelesRiesgoServicio=null;

	public NivelesRiesgoControlador() {
		setCommandClass(NivelesRiesgoBean.class);
		setCommandName("nivelesRiesgoCatalogo");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		NivelesRiesgoBean nivelesBean = (NivelesRiesgoBean) command;
		MensajeTransaccionBean mensaje = null;
		
		if(nivelesBean.getListaNivelesPLD().length()<1 || nivelesBean.getListaNivelesPLD()==null){
        mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(999);
		mensaje.setDescripcion("La Lista de Niveles de Riesgo Está Vacia");
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
		
		mensaje = nivelesRiesgoServicio.actualizaCatalogoNiveles(nivelesBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
	
	public NivelesRiesgoServicio getNivelesRiesgoServicio() {
		return nivelesRiesgoServicio;
	}

	public void setNivelesRiesgoServicio(NivelesRiesgoServicio nivelesRiesgoServicio) {
		this.nivelesRiesgoServicio = nivelesRiesgoServicio;
	}
		
}
