package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.PaisesGAFIPLDBean;
import pld.servicio.PaisesGAFIPLDServicio;

public class PaisesGAFIPLDControlador extends SimpleFormController{
	
	PaisesGAFIPLDServicio paisesGAFIPLDServicio;
	
	public PaisesGAFIPLDControlador(){
		setCommandClass(PaisesGAFIPLDBean.class);
		setCommandName("paisesGAFIPLDBean");
	}
	
	protected ModelAndView showForm(HttpServletRequest request,HttpServletResponse response,BindException errors) throws Exception {
		int tipoCatalogo = Utileria.convierteEntero(request.getParameter("tipoCatalogo"));
		return new ModelAndView(this.getFormView(), "tipoCatalogo", tipoCatalogo);
		
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		PaisesGAFIPLDBean paisesGAFIPLDBean = (PaisesGAFIPLDBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
			paisesGAFIPLDServicio.getPaisesGAFIPLDDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = paisesGAFIPLDServicio.grabaTransaccion(tipoTransaccion, paisesGAFIPLDBean, "");
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

	public PaisesGAFIPLDServicio getPaisesGAFIPLDServicio() {
		return paisesGAFIPLDServicio;
	}

	public void setPaisesGAFIPLDServicio(PaisesGAFIPLDServicio paisesGAFIPLDServicio) {
		this.paisesGAFIPLDServicio = paisesGAFIPLDServicio;
	}

}