package originacion.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.AnalistasAsignacionBean;
import originacion.servicio.AnalistasAsignacionServicio;

public class AnalistasAsignacionControlador  extends SimpleFormController {
	

	AnalistasAsignacionServicio analistasAsignacionServicio = null;

	public AnalistasAsignacionControlador(){
		setCommandClass(AnalistasAsignacionBean.class);
		setCommandName("analistasAsignacionBean");
	}
	
	
	protected ModelAndView showForm(HttpServletRequest request,HttpServletResponse response,BindException errors) throws Exception {
		int tipoCatalogo = Utileria.convierteEntero(request.getParameter("tipoCatalogo"));
		return new ModelAndView(this.getFormView(), "tipoCatalogo", tipoCatalogo);
		
	}

	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		AnalistasAsignacionBean perfilesAnalistasCreBean = (AnalistasAsignacionBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
			analistasAsignacionServicio.getAnalistasAsignacionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = analistasAsignacionServicio.grabaTransaccion(tipoTransaccion, perfilesAnalistasCreBean, "");
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

	public void setAnalistasAsignacionServicio(AnalistasAsignacionServicio analistasAsignacionServicio){
                    this.analistasAsignacionServicio = analistasAsignacionServicio;
	}

	public AnalistasAsignacionServicio getPerfilesAnalistasCreServicio() {
		return analistasAsignacionServicio;
	}
	



}
