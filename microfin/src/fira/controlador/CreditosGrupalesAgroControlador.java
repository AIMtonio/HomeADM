package fira.controlador;

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

public class CreditosGrupalesAgroControlador  extends SimpleFormController {
		
	CreditosServicio creditosServicio = null;
	CreditoDocEntServicio creditoDocEntServicio = null;
	
	public CreditosGrupalesAgroControlador() {
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
															
		CreditosBean creditos = (CreditosBean) command;
		
		//Seteamos a los Parametros de Auditoria el Nombrel del Programa o Recurso 
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		MensajeTransaccionBean mensaje = null;		
		
		mensaje = creditosServicio.grabaTransaccionAgro(tipoTransaccion,tipoActualizacion, creditos,null, request);
	
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

