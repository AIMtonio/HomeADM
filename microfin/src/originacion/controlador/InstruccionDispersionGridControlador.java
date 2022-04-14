package originacion.controlador;

import java.util.List;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.InstruccionDispersionBean;
import originacion.servicio.InstruccionDispersionServicio;

public class InstruccionDispersionGridControlador extends SimpleFormController {
	InstruccionDispersionServicio instruccionDispersionServicio = null;

	public InstruccionDispersionGridControlador(){
		setCommandClass(InstruccionDispersionBean.class);
		setCommandName("instruccionDispersionGrid");
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		InstruccionDispersionBean instruccionDispersionBean = (InstruccionDispersionBean) command;
		
		if(request.getParameter("tipoLista")!= null){

			
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));			
			
			
			List instruccionDispersionGrid = instruccionDispersionServicio.listainstruccionDispersion(tipoLista, instruccionDispersionBean);
		
			
			return new ModelAndView("originacion/instruccionDispersionGridVista", "listaResultado", instruccionDispersionGrid);			
		}else{

			
			
			
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
			String solicitudID = (request.getParameter("solicitudID")!=null) ? request.getParameter("solicitudID"):"0";
			instruccionDispersionBean.setSolicitudCreditoID(solicitudID);
			
			String altainstruccionDispersion = (request.getParameter("datosGridInstruccion")!=null)?
									request.getParameter("datosGridInstruccion"):"";
			MensajeTransaccionBean mensaje = null;
			mensaje = instruccionDispersionServicio.grabaTransaccion(tipoTransaccion,altainstruccionDispersion,instruccionDispersionBean);
			
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
	}

	public void setInstruccionDispersionServicio(
			InstruccionDispersionServicio instruccionDispersionServicio) {
		this.instruccionDispersionServicio = instruccionDispersionServicio;
	}
	


	
	

	
	
	

}
