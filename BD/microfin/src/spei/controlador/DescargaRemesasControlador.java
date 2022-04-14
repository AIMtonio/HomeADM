package spei.controlador;

	import general.bean.MensajeTransaccionBean;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;


	import spei.bean.DescargaRemesasBean;
	import spei.servicio.DescargaRemesasServicio;


	public class DescargaRemesasControlador  extends SimpleFormController {

		DescargaRemesasServicio descargaRemesasServicio = null;


	 	public DescargaRemesasControlador(){
	 		setCommandClass(DescargaRemesasBean.class);
	 		setCommandName("descargaRemesasBean");
	 	}

	 	protected ModelAndView onSubmit(HttpServletRequest request,
	 									HttpServletResponse response,
	 									Object command,
	 									BindException errors) throws Exception {
	 		DescargaRemesasBean  descargaRemesasBean = (DescargaRemesasBean) command;
	 		descargaRemesasServicio.getDescargaRemesasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	 	
	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
	 								Integer.parseInt(request.getParameter("tipoTransaccion")):
									0;
	 	
	 		MensajeTransaccionBean mensaje = null;
	 	
	 		mensaje = descargaRemesasServicio.grabaTransaccion(tipoTransaccion,request,descargaRemesasBean);

	 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	 	}
	 	
	 	

		public DescargaRemesasServicio getDescargaRemesasServicio() {
			return descargaRemesasServicio;
		}

		public void setDescargaRemesasServicio(DescargaRemesasServicio descargaRemesasServicio) {
			this.descargaRemesasServicio = descargaRemesasServicio;
		}

	
	 } 


