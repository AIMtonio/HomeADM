package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.EsquemaAutorizaBean;
import originacion.servicio.EsquemaAutorizaServicio;



public class EsquemaAutorizaGridControlador extends SimpleFormController {
	
	EsquemaAutorizaServicio esquemaAutorizaServicio = null;
	
	public EsquemaAutorizaGridControlador() {
		setCommandClass(EsquemaAutorizaBean.class);
		setCommandName("esquemaAutGrid");
	}
		
	

	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response, Object command, BindException errors)
									throws Exception {

		
		EsquemaAutorizaBean esquemaAutorizaBean = (EsquemaAutorizaBean) command;
		
		//El controlador es para la Lista del Grid
		if(request.getParameter("tipoLista")!= null){

			
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));			
			
			List esquemaAutorizaGrid = esquemaAutorizaServicio.listaEsquemaAutoriza(tipoLista, esquemaAutorizaBean);
			
			
			return new ModelAndView("originacion/esquemaAutorizaGridVista", "listaResultado", esquemaAutorizaGrid);			
		}else{

			
			
			
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
			
		
	}

	//---------setter---------------------
	public void setEsquemaAutorizaServicio(
			EsquemaAutorizaServicio esquemaAutorizaServicio) {
		this.esquemaAutorizaServicio = esquemaAutorizaServicio;
	}
	
	

}
