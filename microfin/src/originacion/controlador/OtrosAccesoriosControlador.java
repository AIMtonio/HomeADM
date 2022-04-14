package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.OtrosAccesoriosBean;
import originacion.servicio.OtrosAccesoriosServicio;

public class OtrosAccesoriosControlador extends SimpleFormController{
	
	OtrosAccesoriosServicio otrosAccesoriosServicio;
	
	public OtrosAccesoriosControlador(){
		setCommandClass(OtrosAccesoriosBean.class);
		setCommandName("otrosAccesorios");
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		OtrosAccesoriosBean otrosAccesoriosBean = (OtrosAccesoriosBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
			otrosAccesoriosServicio.getOtrosAccesoriosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = otrosAccesoriosServicio.grabaTransaccion(tipoTransaccion, otrosAccesoriosBean, "");
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Grabar el Catalogo.");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public OtrosAccesoriosServicio getOtrosAccesoriosServicio() {
		return otrosAccesoriosServicio;
	}

	public void setOtrosAccesoriosServicio(
			OtrosAccesoriosServicio otrosAccesoriosServicio) {
		this.otrosAccesoriosServicio = otrosAccesoriosServicio;
	}

}