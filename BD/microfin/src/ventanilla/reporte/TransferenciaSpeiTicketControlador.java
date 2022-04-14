		package ventanilla.reporte;
		import java.io.ByteArrayOutputStream;
		import javax.servlet.http.HttpServletRequest;
		import javax.servlet.http.HttpServletResponse;

		import org.springframework.validation.BindException;
		import org.springframework.web.servlet.ModelAndView;
		import org.springframework.web.servlet.mvc.AbstractCommandController;

		import ventanilla.bean.SpeiEnvioBean;
		import ventanilla.servicio.SpeiEnvioServicio;



		public class TransferenciaSpeiTicketControlador extends AbstractCommandController {

			SpeiEnvioServicio  speiEnvioServicio = null;
			String nombreReporte= null;
			String successView = null;
			
			public TransferenciaSpeiTicketControlador () {
				setCommandClass(SpeiEnvioBean.class);
				setCommandName("speiEnvioBean");
			}

			
			protected ModelAndView handle(HttpServletRequest request,
					HttpServletResponse response,
					Object command,
					BindException errors)throws Exception {
				
				SpeiEnvioBean speiEnvioBean = (SpeiEnvioBean) command;
				
				ByteArrayOutputStream htmlString = speiEnvioServicio.reporteTicketTranSpei(speiEnvioBean, request, nombreReporte);
				
				response.addHeader("Content-Disposition","inline; filename=TicketTransferenciaSpei.pdf");
		 		response.setContentType("application/pdf");
		 		byte[] bytes = htmlString.toByteArray();
		 		response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
				
				return null;	
			}
			
			public String getNombreReporte() {
				return nombreReporte;
			}

			public void setNombreReporte(String nombreReporte) {
				this.nombreReporte = nombreReporte;
			}

			public String getSuccessView() {
				return successView;
			}
			
			public void setSuccessView(String successView) {
			
				this.successView = successView;
			}

			public SpeiEnvioServicio getSpeiEnvioServicio() {
				return speiEnvioServicio;
			}

			public void setSpeiEnvioServicio(SpeiEnvioServicio speiEnvioServicio) {
				this.speiEnvioServicio = speiEnvioServicio;
			}	
			
		}
