package soporte.controlador;
import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import soporte.servicio.BitacoraHuellaServicio;
import org.springframework.web.servlet.mvc.SimpleFormController;


	public class RepBitacoraHuellaControlador extends SimpleFormController {
		BitacoraHuellaServicio bitacoraHuellaServicio = null;
		protected final Logger loggerSAFI = Logger.getLogger("SAFI");
		
	 	public RepBitacoraHuellaControlador(){
	 		setCommandClass(Object.class);
	 		setCommandName("bitacoraHuella");
	 	}

	 	protected ModelAndView onSubmit(HttpServletRequest request,
					HttpServletResponse response,
					Object command,
					BindException errors) throws Exception {
	 		MensajeTransaccionBean mensaje = null;
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	 		

	}

		public BitacoraHuellaServicio getBitacoraHuellaServicio() {
			return bitacoraHuellaServicio;
		}

		public void setBitacoraHuellaServicio(
				BitacoraHuellaServicio bitacoraHuellaServicio) {
			this.bitacoraHuellaServicio = bitacoraHuellaServicio;
		}

		public Logger getLoggerSAFI() {
			return loggerSAFI;
		}


}
