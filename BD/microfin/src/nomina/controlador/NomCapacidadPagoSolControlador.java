package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nomina.bean.NomCapacidadPagoSolBean;
import nomina.servicio.NomCapacidadPagoSolServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class NomCapacidadPagoSolControlador extends SimpleFormController{
	
	NomCapacidadPagoSolServicio nomCapacidadPagoSolServicio = null;
	
	public NomCapacidadPagoSolControlador(){
		setCommandClass(NomCapacidadPagoSolBean.class);
		setCommandName("nomCapacidadPagoSolBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		NomCapacidadPagoSolBean nomCapacidadPagoSolResult = (NomCapacidadPagoSolBean) command;
			
		String[] clasifClavePresupID = request.getParameterValues("clasifClavPresupID");
		String[] descClasifClavePresup = request.getParameterValues("desclasifClavPresup");
		String[] clavePresupID = request.getParameterValues("nomClavePresupID");	
		String[] clave = request.getParameterValues("clave");
		String[] descClavePresup = request.getParameterValues("descripcion");
		String[] monto = request.getParameterValues("importe");	
									
		nomCapacidadPagoSolResult.setClasifClavePresupID(clasifClavePresupID);
		nomCapacidadPagoSolResult.setDescClasifClavePresup(descClasifClavePresup);
		nomCapacidadPagoSolResult.setClavePresupID(clavePresupID);	
		nomCapacidadPagoSolResult.setClave(clave);	
		nomCapacidadPagoSolResult.setDescClavePresup(descClavePresup);	
		nomCapacidadPagoSolResult.setMonto(monto);	
				
		nomCapacidadPagoSolResult.setMontoResguardo(request.getParameter("totalImporteRG"));
		nomCapacidadPagoSolResult.setMontoCasasComer(request.getParameter("totalImporteMC"));
		nomCapacidadPagoSolResult.setPorcentajeCapacidad(request.getParameter("porcentajeCapacidad"));
		nomCapacidadPagoSolResult.setCapacidadPago(request.getParameter("valorCapacidadPago"));
				
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;			
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)? Integer.parseInt(request.getParameter("tipoActualizacion")): 0;
			
		MensajeTransaccionBean mensaje = null;
		mensaje = nomCapacidadPagoSolServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, nomCapacidadPagoSolResult);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	
	}

	public NomCapacidadPagoSolServicio getNomCapacidadPagoSolServicio() {
		return nomCapacidadPagoSolServicio;
	}

	public void setNomCapacidadPagoSolServicio(
			NomCapacidadPagoSolServicio nomCapacidadPagoSolServicio) {
		this.nomCapacidadPagoSolServicio = nomCapacidadPagoSolServicio;
	}	
}
