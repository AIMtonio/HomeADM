package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.AportDispersionesBean;
import aportaciones.servicio.AportDispersionesServicio;

public class AportDispersionesControlador extends SimpleFormController{
	
	AportDispersionesServicio aportDispersionesServicio;
	
	public AportDispersionesControlador(){
		setCommandClass(AportDispersionesBean.class);
		setCommandName("aportDispersionesBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		AportDispersionesBean aportDispersionesBean = (AportDispersionesBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			aportDispersionesServicio.getAportDispersionesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = aportDispersionesServicio.grabaTransaccion(tipoTransaccion, aportDispersionesBean);
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Grabar los Montos y Beneficiarios.");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public AportDispersionesServicio getAportDispersionesServicio() {
		return aportDispersionesServicio;
	}

	public void setAportDispersionesServicio(
			AportDispersionesServicio aportDispersionesServicio) {
		this.aportDispersionesServicio = aportDispersionesServicio;
	}

}