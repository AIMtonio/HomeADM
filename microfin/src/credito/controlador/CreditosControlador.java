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

public class CreditosControlador  extends SimpleFormController {
	
	//public String	tranGralCredito ="C";
	//public String	tranGralFondeo ="F";
	int operAutorizaCredito=1; //Tipo de operacion autorizacion de crédito individual(Pantalla de Mesa de Control Individual)
	int operDocumentosEnt=2;		// Tipo de operacion Actualizacion de documentos entregados(Pantalla de Mesa de control individual)
	int operCondicionaCredito = 3;	// Tipo de Operación que condiciona el Crédito antes de ser autorizado
	
	CreditosServicio creditosServicio = null;
	CreditoDocEntServicio creditoDocEntServicio= null;
	
	public CreditosControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		//Creacion y Seteo del Bean
		CreditosBean creditos = (CreditosBean) command;
		
		
		String datosGrid = "";
		int tipoOperacion = 0;
		
		//Tipo de Transaccion: Alta, Modifica, Baja
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
							Integer.parseInt(request.getParameter("tipoTransaccion")):0;
							
		//Tipo de Actualizacion: PagareImpreso, Autorizacion, Actualiza Monto Desembolsado
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
								Integer.parseInt(request.getParameter("tipoActualizacion")):0;
		
		String tipoDispersion = request.getParameter("tipoDispersion");
		creditos.setTipoDispersion(tipoDispersion);
		
		//Seteamos a los Parametros de Auditoria el Nombrel del Programa o Recurso
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		//Mensaje de Respuesta
		MensajeTransaccionBean mensaje = null;
		
		//Si el Tipo de Transaccion es Actualizacion: Autorizacion
		if (tipoTransaccion == CreditosServicio.Enum_Tra_Creditos.actualizaAut) {
			//Tipo de Operacion: Utilizado por la Pantalla mesa de control Cred individual
			//Autorizacion de los Creditos:1
			//Actualizar el CheckLis de Documentos Entregados:2	 
			
			
			tipoOperacion =(request.getParameter("tipoOperacion")!=null)?
							Integer.parseInt(request.getParameter("tipoOperacion")):0;
												
			datosGrid = request.getParameter("datosGridDocEnt");	//Datos del grid de documentos(Pantalla Mesa de control )	
			
			if(tipoOperacion == operAutorizaCredito){
				
				mensaje = creditosServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, creditos,request);
				

			}
				
			if(tipoOperacion == operDocumentosEnt){
			
				CreditoDocEntBean creditoDocEntBean= new CreditoDocEntBean();
				mensaje = creditoDocEntServicio.grabaTransaccion(tipoActualizacion,creditoDocEntBean, datosGrid );	
			}
			if(tipoOperacion == operCondicionaCredito){
				mensaje = creditosServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, creditos,request);
			}	
			
			
			
		}else{
			mensaje = creditosServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, creditos,request);	
		}
		
	
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	//--------- setter---------------------	
	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public void setCreditoDocEntServicio(CreditoDocEntServicio creditoDocEntServicio) {
		this.creditoDocEntServicio = creditoDocEntServicio;
	}
	
	

		
}
