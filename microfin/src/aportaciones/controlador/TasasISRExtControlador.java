package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.TasasISRExtBean;
import aportaciones.servicio.TasasISRExtServicio;

public class TasasISRExtControlador extends SimpleFormController{

	TasasISRExtServicio tasasISRExtServicio;

	public TasasISRExtControlador(){
		setCommandClass(TasasISRExtBean.class);
		setCommandName("tasasISRExtBean");
	}

	protected ModelAndView showForm(HttpServletRequest request,HttpServletResponse response,BindException errors) throws Exception {
		int tipoCatalogo = Utileria.convierteEntero(request.getParameter("tipoCatalogo"));
		return new ModelAndView(this.getFormView(), "tipoCatalogo", tipoCatalogo);

	}

	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		TasasISRExtBean tasasISRExtBean = (TasasISRExtBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			tasasISRExtServicio.getTasasISRExtDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = tasasISRExtServicio.grabaTransaccion(tipoTransaccion, tasasISRExtBean, "");
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

	public TasasISRExtServicio getTasasISRExtServicio() {
		return tasasISRExtServicio;
	}

	public void setTasasISRExtServicio(TasasISRExtServicio tasasISRExtServicio) {
		this.tasasISRExtServicio = tasasISRExtServicio;
	}

}