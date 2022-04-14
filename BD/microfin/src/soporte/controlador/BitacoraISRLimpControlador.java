	package soporte.controlador;
	import general.bean.MensajeTransaccionBean;

	import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
	import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import soporte.bean.BitacoraCliISRBean;
import soporte.servicio.BitacoraCliISRServicio;
public class BitacoraISRLimpControlador extends SimpleFormController{
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	BitacoraCliISRServicio bitacoraCliISRServicio=null; 
		
		public BitacoraISRLimpControlador() {
			setCommandClass(BitacoraCliISRBean.class);
			setCommandName("bitacoraCliISRBean");
		}
		
		protected ModelAndView onSubmit(HttpServletRequest request,
										HttpServletResponse response,
										Object command,							
										BindException errors) throws Exception {
		
			BitacoraCliISRBean bitacoraCliISRBean= (BitacoraCliISRBean) command;
			
			MensajeTransaccionBean mensaje = null;
	
		
			
			mensaje=bitacoraCliISRServicio.GrabaBitacoraClientISR(bitacoraCliISRBean);
			
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public BitacoraCliISRServicio getBitacoraCliISRServicio() {
			return bitacoraCliISRServicio;
		}

		public void setBitacoraCliISRServicio(
				BitacoraCliISRServicio bitacoraCliISRServicio) {
			this.bitacoraCliISRServicio = bitacoraCliISRServicio;
		}

	

	}

