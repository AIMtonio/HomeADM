package credito.reporte;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;
import cuentas.bean.CuentasPersonaBean;



public class PagareRepControlador extends AbstractCommandController  {
	
	
	CreditosServicio creditosServicio = null;
	String nomReporTasaVar= null;
	String nomReporTasaFij= null;
	String successView = null;
	
	public PagareRepControlador () {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
	CreditosBean creditosBean = (CreditosBean) command;
	String calcInteresID = creditosBean.getCalcInteresID();
	
	String tasaF = "1";
	String tasaVar = "2";
	String tasaVar2 = "3";	
	
	String htmlString = "";
	int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
			Integer.parseInt(request.getParameter("tipoTransaccion")):
		0;

		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
					Integer.parseInt(request.getParameter("tipoActualizacion")):
					0;		
	MensajeTransaccionBean mensaje = null;
	mensaje=creditosServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, creditosBean,request);
		

	if(calcInteresID.equals(tasaF)){
		
		htmlString = creditosServicio.reportePagareTasaFija(creditosBean, nomReporTasaFij);
	}
	
	if(calcInteresID.equals(tasaVar)|| calcInteresID.equals(tasaVar2)){
		htmlString = creditosServicio.reportePagareTasaVar(creditosBean, nomReporTasaVar);
	}

	return new ModelAndView(getSuccessView(),"reporte", htmlString);
	
	}
	

	public void setNomReporTasaVar(String nomReporTasaVar) {
		this.nomReporTasaVar = nomReporTasaVar;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public void setNomReporTasaFij(String nomReporTasaFij) {
		this.nomReporTasaFij = nomReporTasaFij;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
