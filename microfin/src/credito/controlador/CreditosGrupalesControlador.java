package credito.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditoDocEntBean;
import credito.bean.CreditosBean;
import credito.servicio.CreditoDocEntServicio;
import credito.servicio.CreditosServicio;

// Este Controlador es utilizado en el Proceso de Credito
// En las pantallas de Manejo de Grupos: altaDeCredito, autorizacionDeCredito, pagareCredito, desembolso

public class CreditosGrupalesControlador  extends SimpleFormController {
		
	CreditosServicio creditosServicio = null;
	CreditoDocEntServicio creditoDocEntServicio = null;
	
	int operAutoriza = 1;		// tipo operacion autorizacion de credito grupal (Pantalla de Autorizacion Creditos Grupales)
	int operDocumentosEnt = 2;	// tipo operacion graba documentos entregados (Pantalla de Autorizacion Creditos Grupales)
	
	
	public CreditosGrupalesControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		String datosGrid = "";
		int tipoOperacion = 0;
		
		//Tipo de Transaccion: Alta, Modifica, Baja
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
							Integer.parseInt(request.getParameter("tipoTransaccion")): 0;

		//Tipo de Actualizacion: PagareImpreso, Autorizacion, Actualiza Monto Desembolsado
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
								Integer.parseInt(request.getParameter("tipoActualizacion")):
								0;
								
		if (tipoTransaccion == CreditosServicio.Enum_Tra_Creditos.autorizaGrupal ) {
			//Tipo de Operacion: Utilizado por la Pantalla de Autorizacion Grupal
			//Autorizacion de los Creditos:1
			//Actualizar el CheckLis de Documentos Entregados:2							
			tipoOperacion =(request.getParameter("tipoOperacion")!=null)?
								Integer.parseInt(request.getParameter("tipoOperacion")):0;
															
			datosGrid = request.getParameter("datosGridDocEnt");	//Datos del grid de documentos(Pantalla Mesa de control )		
		}
										
		CreditosBean creditos = (CreditosBean) command;
		
		//Seteamos a los Parametros de Auditoria el Nombrel del Programa o Recurso 
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		MensajeTransaccionBean mensaje = null;		
		
		if (tipoTransaccion == CreditosServicio.Enum_Tra_Creditos.autorizaGrupal ) {
			if(tipoOperacion == operAutoriza){
				mensaje = creditosServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, creditos,request);	
				
			}
				
			if(tipoOperacion == operDocumentosEnt){
				CreditoDocEntBean creditoDocEntBean= new CreditoDocEntBean();
				mensaje = creditoDocEntServicio.grabaTransaccion(tipoActualizacion,creditoDocEntBean, datosGrid );	
			}			
		} else{
			mensaje = creditosServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, creditos,request);
		}
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);	
		
	}
//----------setter
	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public void setCreditoDocEntServicio(CreditoDocEntServicio creditoDocEntServicio) {
		this.creditoDocEntServicio = creditoDocEntServicio;
	}

		
}

