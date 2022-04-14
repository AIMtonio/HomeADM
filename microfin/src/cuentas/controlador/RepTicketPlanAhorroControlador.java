package cuentas.controlador;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.ParametrosSesionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.FoliosPlanAhorroBean;
import cuentas.servicio.FoliosPlanAhorroServicio;

public class RepTicketPlanAhorroControlador extends AbstractCommandController {

	FoliosPlanAhorroServicio ticketPlanAhorroServicio = null;
	ParametrosSesionBean parametrosSesionBean;
	String nombreReporte = null;
	
	public 	RepTicketPlanAhorroControlador(){
		setCommandClass(FoliosPlanAhorroBean.class);
		setCommandName("folioPlanAhorroTicket");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errores) throws Exception{
		
		FoliosPlanAhorroBean ticketPlanAhorroBean = (FoliosPlanAhorroBean) command;
		
		ByteArrayOutputStream htmlStringPDF = repTicketPlanAhorro(ticketPlanAhorroBean,nombreReporte,response);
		
		return null;
	}
	
	public ByteArrayOutputStream repTicketPlanAhorro(FoliosPlanAhorroBean ticketPlanAhorro,String nombreReporte,HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = ticketPlanAhorroServicio.repTicketPlanAhorro(ticketPlanAhorro,nombreReporte,parametrosSesionBean);
			response.addHeader("Content-Disposition","inline; filename=TicketPlanAhorro.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return htmlStringPDF; 
	}
	
	public FoliosPlanAhorroServicio getTicketPlanAhorroServicio() {
		return ticketPlanAhorroServicio;
	}
	public void setTicketPlanAhorroServicio(
			FoliosPlanAhorroServicio ticketPlanAhorroServicio) {
		this.ticketPlanAhorroServicio = ticketPlanAhorroServicio;
	}
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	public String getNombreReporte() {
		return nombreReporte;
	}
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}	
}
