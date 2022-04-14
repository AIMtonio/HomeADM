package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.ClasificaTipDocBean;
import originacion.servicio.ClasificaTipDocServicio;

public class ClasificaTipDocControlador extends SimpleFormController {

	ClasificaTipDocServicio clasificaTipDocServicio = null;

	public ClasificaTipDocControlador(){
		setCommandClass(ClasificaTipDocBean.class);
		setCommandName("clasificaDocumentos");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		ClasificaTipDocBean clasificacion = (ClasificaTipDocBean) command;
		
		clasificaTipDocServicio.getClasificaTipDocDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		int tipoBaja =(request.getParameter("tipoBaja")!=null)?
				Integer.parseInt(request.getParameter("tipoBaja")):0;
					
								
		MensajeTransaccionBean mensaje = null;
		mensaje = clasificaTipDocServicio.grabaTransaccion(tipoTransaccion,tipoBaja,clasificacion);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

	
	//---------------setter-------------
	public void setClasificaTipDocServicio(
			ClasificaTipDocServicio clasificaTipDocServicio) {
		this.clasificaTipDocServicio = clasificaTipDocServicio;
	}

	
} 
