package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.ParamDiasFrecuenciaBean;
import originacion.servicio.ParamDiasFrecuenciaServicio;

public class ParamDiasFrecuenciaControlador extends SimpleFormController{
	
	ParamDiasFrecuenciaServicio paramDiasFrecuenciaServicio;
	
	public ParamDiasFrecuenciaControlador(){
		setCommandClass(ParamDiasFrecuenciaBean.class);
		setCommandName("paramDiasFrecuencia");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		ParamDiasFrecuenciaBean paramDiasFrecuenciaBean = (ParamDiasFrecuenciaBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
			String detalles = request.getParameter("detalle");
			paramDiasFrecuenciaServicio.getParamDiasFrecuenciaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = paramDiasFrecuenciaServicio.grabaTransaccion(tipoTransaccion,paramDiasFrecuenciaBean,detalles);
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Realizar la Operación.");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ParamDiasFrecuenciaServicio getParamDiasFrecuenciaServicio() {
		return paramDiasFrecuenciaServicio;
	}

	public void setParamDiasFrecuenciaServicio(ParamDiasFrecuenciaServicio paramDiasFrecuenciaServicio) {
		this.paramDiasFrecuenciaServicio = paramDiasFrecuenciaServicio;
	}

}
