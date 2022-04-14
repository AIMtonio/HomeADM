package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.EsquemaOtrosAccesoriosBean;
import originacion.servicio.EsquemaOtrosAccesoriosServicio;


public class EsquemaOtrosAccesoriosControlador extends SimpleFormController{
	
	EsquemaOtrosAccesoriosServicio esquemaOtrosAccesoriosServicio;
	
	public EsquemaOtrosAccesoriosControlador(){
		setCommandClass(EsquemaOtrosAccesoriosBean.class);
		setCommandName("esquemaOtrosAccesorios");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		EsquemaOtrosAccesoriosBean esquemaOtrosAccesoriosBean = (EsquemaOtrosAccesoriosBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
			esquemaOtrosAccesoriosServicio.getEsquemaOtrosAccesoriosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = esquemaOtrosAccesoriosServicio.grabaTransaccion(tipoTransaccion, esquemaOtrosAccesoriosBean);
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

	public EsquemaOtrosAccesoriosServicio getEsquemaOtrosAccesoriosServicio() {
		return esquemaOtrosAccesoriosServicio;
	}

	public void setEsquemaOtrosAccesoriosServicio(
			EsquemaOtrosAccesoriosServicio esquemaOtrosAccesoriosServicio) {
		this.esquemaOtrosAccesoriosServicio = esquemaOtrosAccesoriosServicio;
	}
	
}