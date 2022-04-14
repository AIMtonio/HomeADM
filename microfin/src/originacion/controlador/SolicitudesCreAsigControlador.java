package originacion.controlador;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.AnalistasAsignacionBean;
import originacion.bean.SolicitudesCreAsigBean;
import originacion.servicio.AnalistasAsignacionServicio;
import originacion.servicio.SolicitudesCreAsigServicio;

public class SolicitudesCreAsigControlador  extends SimpleFormController {
	

	SolicitudesCreAsigServicio solicitudesCreAsigServicio = null;

	public SolicitudesCreAsigControlador(){
		setCommandClass(SolicitudesCreAsigBean.class);
		setCommandName("solicitudCreAsig");
	}
	
	
	protected ModelAndView showForm(HttpServletRequest request,HttpServletResponse response,BindException errors) throws Exception {
		int tipoCatalogo = Utileria.convierteEntero(request.getParameter("tipoCatalogo"));
		return new ModelAndView(this.getFormView(), "tipoCatalogo", tipoCatalogo);
		
	}

	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		SolicitudesCreAsigBean solicitudesCreAsigBean = (SolicitudesCreAsigBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
			solicitudesCreAsigServicio.getSolicitudesCreAsigDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			System.out.println("SolicitudesCreAsigControldaor pues ctomas"+tipoTransaccion);
			mensaje = solicitudesCreAsigServicio.grabaTransaccion(tipoTransaccion, solicitudesCreAsigBean,"");
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Grabar el Catalogo Asignacion Analista.");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setSolicitudesCreAsigServicio(SolicitudesCreAsigServicio solicitudesCreAsigServicio){
                    this.solicitudesCreAsigServicio = solicitudesCreAsigServicio;
	}

	public SolicitudesCreAsigServicio getSolicitudesCreAsigServicio() {
		return solicitudesCreAsigServicio;
	}
	



}
