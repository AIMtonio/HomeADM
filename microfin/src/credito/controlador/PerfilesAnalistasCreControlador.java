package credito.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.PerfilesAnalistasCreBean;
import credito.servicio.PerfilesAnalistasCreServicio;

public class PerfilesAnalistasCreControlador extends SimpleFormController {

	PerfilesAnalistasCreServicio perfilesAnalistasCreServicio = null;

	public PerfilesAnalistasCreControlador(){
		setCommandClass(PerfilesAnalistasCreBean.class);
		setCommandName("perfilesAnalistasCreBean");
	}
	
	
	protected ModelAndView showForm(HttpServletRequest request,HttpServletResponse response,BindException errors) throws Exception {
		int tipoCatalogo = Utileria.convierteEntero(request.getParameter("tipoCatalogo"));
		return new ModelAndView(this.getFormView(), "tipoCatalogo", tipoCatalogo);
		
	}

	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		PerfilesAnalistasCreBean perfilesAnalistasCreBean = (PerfilesAnalistasCreBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
			perfilesAnalistasCreServicio.getPerfilesAnalistasCreDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = perfilesAnalistasCreServicio.grabaTransaccion(tipoTransaccion, perfilesAnalistasCreBean, "");
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

	public void setPerfilesAnalistasCreServicio(PerfilesAnalistasCreServicio perfilesAnalistasCreServicio){
                    this.perfilesAnalistasCreServicio = perfilesAnalistasCreServicio;
	}

	public PerfilesAnalistasCreServicio getPerfilesAnalistasCreServicio() {
		return perfilesAnalistasCreServicio;
	}
	




} 
