package bancaMovil.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.mapeaBean;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import bancaMovil.bean.BAMParametrosBean;
import bancaMovil.servicio.BAMParametrosServicio;

@SuppressWarnings("deprecation")
public class BAMParametrosControlador extends SimpleFormController{
	BAMParametrosServicio parametrosServicio=null;
	
	public BAMParametrosControlador(){
 		setCommandClass(BAMParametrosBean.class);
 		setCommandName("parametrosBean");
 	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws ServletException, IOException  {
		
			parametrosServicio.getParametrosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			BAMParametrosBean parametrosBean = (BAMParametrosBean) command;
			
			parametrosBean = (BAMParametrosBean) mapeaBean.valoresDefaultABean(parametrosBean);
 			MensajeTransaccionBean mensaje = parametrosServicio.grabaTransaccion(BAMParametrosServicio.Enum_Tra_Parametros.modificacion, parametrosBean);
		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public BAMParametrosServicio getParametrosServicio() {
		return parametrosServicio;
	}

	public void setParametrosServicio(BAMParametrosServicio parametrosServicio) {
		this.parametrosServicio = parametrosServicio;
	}		
	
}
