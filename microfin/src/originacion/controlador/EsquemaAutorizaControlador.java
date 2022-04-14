package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.EsquemaAutorizaBean;

import originacion.servicio.EsquemaAutorizaServicio;

public class EsquemaAutorizaControlador extends SimpleFormController {
	EsquemaAutorizaServicio esquemaAutorizaServicio = null;

	public EsquemaAutorizaControlador(){
		setCommandClass(EsquemaAutorizaBean.class);
		setCommandName("esquemaAutoriza");
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		EsquemaAutorizaBean esquemaAutorizaBean = (EsquemaAutorizaBean) command;
		
		esquemaAutorizaServicio.getEsquemaAutorizaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
							Integer.parseInt(request.getParameter("tipoTransaccion")):0;

		String datosAltaEsquema = (request.getParameter("datosGridEsquema")!=null)?
									request.getParameter("datosGridEsquema"):"";	
									
		String datosBajaEsquema = (request.getParameter("datosGridBajaEsquema")!=null)?
								request.getParameter("datosGridBajaEsquema"):"";
								
		
				
		MensajeTransaccionBean mensaje = null;
		
		mensaje = esquemaAutorizaServicio.grabaTransaccion(tipoTransaccion,esquemaAutorizaBean,datosBajaEsquema,datosAltaEsquema);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	


	
	
	//----------- setter------------
	public void setEsquemaAutorizaServicio(
			EsquemaAutorizaServicio esquemaAutorizaServicio) {
		this.esquemaAutorizaServicio = esquemaAutorizaServicio;
	}
	
	

}
