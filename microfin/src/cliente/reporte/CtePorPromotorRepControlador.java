
package cliente.reporte;
import java.io.ByteArrayOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteBean;
import cliente.bean.HiscambiosucurcliBean;
import cliente.servicio.ClienteServicio;
  
public class CtePorPromotorRepControlador  extends AbstractCommandController{	
	ClienteServicio  clienteServicio = null;
	String nomReporte= null;
	String successView = null;
	
	public CtePorPromotorRepControlador () {
		setCommandClass(ClienteBean.class);
		setCommandName("reporteBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		ClienteBean clienteBean = (ClienteBean) command;
		ByteArrayOutputStream htmlString = clienteServicio.reporteClientePorPromotor(clienteBean,request, nomReporte);
		
		response.addHeader("Content-Disposition","inline; filename=ReporteClientesPorPromotor.pdf");
 		response.setContentType("application/pdf");
 		byte[] bytes = htmlString.toByteArray();
 		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();
		
		return null;	
	}
	
	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
	
		this.successView = successView;
	}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}	
	
}
