package spei.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import spei.bean.RepPagoRemesaSPEIBean;
import spei.servicio.RepPagoRemesaSPEIServicio;

	public class RepPagoRemesaSPEIControlador extends SimpleFormController{

		RepPagoRemesaSPEIServicio repPagoRemesaSPEIServicio = null;

	 	public RepPagoRemesaSPEIControlador(){
	 		setCommandClass(RepPagoRemesaSPEIBean.class);
	 		setCommandName("repPagoRemesaSPEIBean");
	 	}

	 	protected ModelAndView onSubmit(HttpServletRequest request,
					HttpServletResponse response,
					Object command,
					BindException errors) throws Exception {
	 		repPagoRemesaSPEIServicio.getRepPagoRemesaSPEIDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	 		RepPagoRemesaSPEIBean repPagoRemesaSPEIBean = (RepPagoRemesaSPEIBean) command;

	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;

				MensajeTransaccionBean mensaje = null;
			 // mensaje = repPagoRemesaSPEIServicio.grabaTransaccion(tipoTransaccion, repPagoRemesaSPEIBean);
				return new ModelAndView(getSuccessView(), "mensaje", mensaje);


	 	}
	 	// ---------------  getter y setter -------------------- 

		public RepPagoRemesaSPEIServicio getRepPagoRemesaSPEIServicio() {
			return repPagoRemesaSPEIServicio;
		}

		public void setRepPagoRemesaSPEIServicio(
				RepPagoRemesaSPEIServicio repPagoRemesaSPEIServicio) {
			this.repPagoRemesaSPEIServicio = repPagoRemesaSPEIServicio;
		}

	 } 
