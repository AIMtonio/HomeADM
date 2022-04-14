package fira.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.RecupCarteraCastAgroBean;
import fira.servicio.RecupCarteraCastAgroServicio;
import general.bean.MensajeTransaccionBean;


public class RecupCarteraCastAgroControlador  extends SimpleFormController {

	RecupCarteraCastAgroServicio recupCarteraCastAgroServicio = null;

 	public RecupCarteraCastAgroControlador(){
 		setCommandClass(RecupCarteraCastAgroBean.class);
 		setCommandName("recupCarteraCastAgro");
 	}
 	
 	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

 		
 		recupCarteraCastAgroServicio.getRecupCarteraCastAgroDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 							
 		RecupCarteraCastAgroBean  recupCarteraCastAgroBean = (RecupCarteraCastAgroBean) command;

 		MensajeTransaccionBean mensaje = null;
 		
 		try {
 	 		mensaje = recupCarteraCastAgroServicio.grabaTransaccion(tipoTransaccion,recupCarteraCastAgroBean );
 		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje=new MensajeTransaccionBean();
			mensaje.setNumero(404);
			mensaje.setDescripcion("Error en el controlador .");
		}
 		
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public RecupCarteraCastAgroServicio getRecupCarteraCastAgroServicio() {
		return recupCarteraCastAgroServicio;
	}

	public void setRecupCarteraCastAgroServicio(
			RecupCarteraCastAgroServicio recupCarteraCastAgroServicio) {
		this.recupCarteraCastAgroServicio = recupCarteraCastAgroServicio;
	}

 } 
