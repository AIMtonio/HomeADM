package cedes.controlador;


	import general.bean.MensajeTransaccionBean;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;
	import cedes.bean.DocPorTipoCedesBean;
	import cedes.servicio.DocPorTipoCedesServicio;

	public class DocPorTipoCedesControlador extends SimpleFormController {

		
		DocPorTipoCedesServicio docPorTipoCedesServicio  = null;

		public DocPorTipoCedesControlador(){
			setCommandClass(DocPorTipoCedesBean.class);
			setCommandName("docPorTipoCedes");
		}

		protected ModelAndView onSubmit(HttpServletRequest request,
										HttpServletResponse response,
										Object command,
										BindException errors) throws Exception {

			DocPorTipoCedesBean docPorTipoCedesBean = (DocPorTipoCedesBean) command;
			
			docPorTipoCedesServicio.getDocPorTipoCedesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;		
					
			String detalleDocumentosReq = request.getParameter("detalleDocumentosReq");
							
			MensajeTransaccionBean mensaje = null;
			mensaje = docPorTipoCedesServicio.grabaTransaccion(tipoTransaccion,docPorTipoCedesBean,detalleDocumentosReq);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public void setDocPorTipoCedesServicio(DocPorTipoCedesServicio docPorTipoCedesServicio) {
			this.docPorTipoCedesServicio = docPorTipoCedesServicio;
		}

		 
		

	} 




