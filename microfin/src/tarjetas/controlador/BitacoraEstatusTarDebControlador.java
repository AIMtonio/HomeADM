
package tarjetas.controlador;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import general.bean.MensajeTransaccionBean;





import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.BitacoraEstatusTarDebBean;
import tarjetas.servicio.BitacoraEstatusTarDebServicio;



public class BitacoraEstatusTarDebControlador extends  SimpleFormController {	
	
	BitacoraEstatusTarDebServicio bitacoraEstatusTarDebServicio= null;
						

	public BitacoraEstatusTarDebControlador(){
 		setCommandClass(BitacoraEstatusTarDebBean.class);
 		setCommandName("bitacoraEstatusTarDeb");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		bitacoraEstatusTarDebServicio.getBitacoraEstatusTarDebDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		BitacoraEstatusTarDebBean bitacoraEstatusTarDebBean = (BitacoraEstatusTarDebBean) command;
		
		//int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
 		MensajeTransaccionBean mensaje = null;

 	//	mensaje = tarjetaDebitoServicio.grabaTransaccion(tipoTransaccion,0, tarjetaDebitoBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}

	public BitacoraEstatusTarDebServicio getBitacoraEstatusTarDebServicio() {
		return bitacoraEstatusTarDebServicio;
	}

	public void setBitacoraEstatusTarDebServicio(
			BitacoraEstatusTarDebServicio bitacoraEstatusTarDebServicio) {
		this.bitacoraEstatusTarDebServicio = bitacoraEstatusTarDebServicio;
	}






}