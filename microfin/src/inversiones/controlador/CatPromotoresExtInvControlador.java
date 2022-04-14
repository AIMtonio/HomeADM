package inversiones.controlador;

import general.bean.MensajeTransaccionBean;
import inversiones.bean.CatPromotoresExtInvBean;
import inversiones.servicio.CatPromotoresExtInvServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class CatPromotoresExtInvControlador extends SimpleFormController{

	CatPromotoresExtInvServicio catPromotoresExtInvServicio = null;
	
 	public CatPromotoresExtInvControlador(){
 		setCommandClass(CatPromotoresExtInvBean.class);
 		setCommandName("catPromotorExtBean"); 
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
 	
 		CatPromotoresExtInvBean catPromotoresExtInvBean = (CatPromotoresExtInvBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
 								
 								
		MensajeTransaccionBean mensaje = null;
		mensaje = catPromotoresExtInvServicio.grabaTransaccion(tipoTransaccion,catPromotoresExtInvBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	

	public CatPromotoresExtInvServicio getCatPromotoresExtInvServicio() {
		return catPromotoresExtInvServicio;
	}

	public void setCatPromotoresExtInvServicio(
			CatPromotoresExtInvServicio catPromotoresExtInvServicio) {
		this.catPromotoresExtInvServicio = catPromotoresExtInvServicio;
	}



}

	

