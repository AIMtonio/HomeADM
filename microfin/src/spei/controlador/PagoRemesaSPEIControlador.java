package spei.controlador;

	import general.bean.MensajeTransaccionBean;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;

	import spei.bean.PagoRemesaSPEIBean;
	import spei.servicio.PagoRemesaSPEIServicio;


	public class PagoRemesaSPEIControlador extends SimpleFormController {

		PagoRemesaSPEIServicio	pagoRemesaSPEIServicio=null;

		public PagoRemesaSPEIControlador(){
			setCommandClass(PagoRemesaSPEIBean.class);
			setCommandName("pagoRemesaSPEIBean");
		}

		protected ModelAndView onSubmit(HttpServletRequest request,
										HttpServletResponse response,
										Object command,
										BindException errors) throws Exception {

			PagoRemesaSPEIBean pagoRemesaSPEIBean = (PagoRemesaSPEIBean) command;
			
			pagoRemesaSPEIServicio.getPagoRemesaSPEIDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
			String datosGrid = request.getParameter("datosGrid");	
			MensajeTransaccionBean mensaje = null;
		    mensaje = pagoRemesaSPEIServicio.grabaTransaccion(tipoTransaccion, pagoRemesaSPEIBean, datosGrid);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public PagoRemesaSPEIServicio getPagoRemesaSPEIServicio() {
			return pagoRemesaSPEIServicio;
		}

		public void setPagoRemesaSPEIServicio(
				PagoRemesaSPEIServicio pagoRemesaSPEIServicio) {
			this.pagoRemesaSPEIServicio = pagoRemesaSPEIServicio;
		}

		

		
		
		
	} 



