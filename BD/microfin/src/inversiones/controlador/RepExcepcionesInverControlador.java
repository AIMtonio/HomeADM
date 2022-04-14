	package inversiones.controlador;

		import general.bean.MensajeTransaccionBean;
		import javax.servlet.http.HttpServletRequest;
		import javax.servlet.http.HttpServletResponse;
		import org.springframework.validation.BindException;
		import org.springframework.web.servlet.ModelAndView;
		import org.springframework.web.servlet.mvc.SimpleFormController;
		import inversiones.bean.RepExcepcionesInverBean;
		import inversiones.servicio.RepExcepcionesInverServicio;

		public class RepExcepcionesInverControlador extends SimpleFormController{

			RepExcepcionesInverServicio repExcepcionesInverServicio = null;

		 	public RepExcepcionesInverControlador(){
		 		setCommandClass(RepExcepcionesInverBean.class);
		 		setCommandName("repExcepciones");
		 	}


	protected ModelAndView onSubmit(HttpServletRequest request,
							HttpServletResponse response,
							Object command,
							BindException errors) throws Exception {

		repExcepcionesInverServicio.getRepExcepcionesInverDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		RepExcepcionesInverBean repExcepcionesInverBean = (RepExcepcionesInverBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		//mensaje = repExcepcionesInverServicio.grabaTransaccion(tipoTransaccion, repExcepcionesInverBean);
														
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
		 		
	
	// ---------------  getter y setter -------------------- 

	public RepExcepcionesInverServicio getRepExcepcionesInverServicio() {
		return repExcepcionesInverServicio;
	}


	public void setRepExcepcionesInverServicio(
			RepExcepcionesInverServicio repExcepcionesInverServicio) {
		this.repExcepcionesInverServicio = repExcepcionesInverServicio;
	}


					 

		 	
		 } 
