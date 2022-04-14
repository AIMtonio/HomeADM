package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.OpeEscalamientoInternoBean;
import pld.servicio.OpeEscalamientoInternoServicio;

public class OpeEscalamientoInternoControlador extends SimpleFormController {

	OpeEscalamientoInternoServicio opeEscalamientoInternoServicio = null;


 	public OpeEscalamientoInternoControlador(){
 		setCommandClass(OpeEscalamientoInternoBean.class);
 		setCommandName("opeEscalamientoInterno");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		
 		opeEscalamientoInternoServicio.getOpeEscalamientoInternoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		OpeEscalamientoInternoBean opeEscalamientoInternoBean = (OpeEscalamientoInternoBean) command;

 		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
 								Integer.parseInt(request.getParameter("tipoActualizacion")):0;
 		int autorizar = (request.getParameter("autorizacion")!=null)?
				Integer.parseInt(request.getParameter("autorizacion")):0;

 		MensajeTransaccionBean mensaje = null;
 		mensaje = opeEscalamientoInternoServicio.actualiza(tipoActualizacion, opeEscalamientoInternoBean);
 		
 		if(mensaje.getNumero()==0 && autorizar==1){
 			mensaje = opeEscalamientoInternoServicio.envioCorreoAutorizacion(opeEscalamientoInternoBean, mensaje);
 		}
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public void setOpeEscalamientoInternoServicio(
			OpeEscalamientoInternoServicio opeEscalamientoInternoServicio) {
		this.opeEscalamientoInternoServicio = opeEscalamientoInternoServicio;
	}
}
