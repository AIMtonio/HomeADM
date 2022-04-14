package spei.controlador;

	import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import spei.bean.CierreDiaSpeiBean;
import spei.servicio.CierreDiaSpeiServicio;

	public class CierreDiaSpeiControlador extends SimpleFormController{

		CierreDiaSpeiServicio cierreDiaSpeiServicio = null;

	 	public CierreDiaSpeiControlador(){
	 		setCommandClass(CierreDiaSpeiBean.class);
	 		setCommandName("cierreDiaSpeiBean");
	 	}

	 	protected ModelAndView onSubmit(HttpServletRequest request,
					HttpServletResponse response,
					Object command,
					BindException errors) throws Exception {
	 		cierreDiaSpeiServicio.getCierreDiaSpeiDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	 		CierreDiaSpeiBean cierreDiaSpeiBean = (CierreDiaSpeiBean) command;

	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;

				MensajeTransaccionBean mensaje = null;
				mensaje = cierreDiaSpeiServicio.grabaTransaccion(tipoTransaccion, cierreDiaSpeiBean);
				return new ModelAndView(getSuccessView(), "mensaje", mensaje);


	 	}
	 	// ---------------  getter y setter -------------------- 
		public CierreDiaSpeiServicio getCierreDiaSpeiServicio() {
			return cierreDiaSpeiServicio;
		}

		public void setCierreDiaSpeiServicio(
				CierreDiaSpeiServicio cierreDiaSpeiServicio) {
			this.cierreDiaSpeiServicio = cierreDiaSpeiServicio;
		}
	 } 
