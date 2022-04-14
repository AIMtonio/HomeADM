package credito.reporte;

import java.io.ByteArrayOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class RepActaComiteControlador extends AbstractCommandController {
	CreditosServicio creditosServicio = null;
	String nombreReporte = null;
	public RepActaComiteControlador(){
		setCommandClass(CreditosBean.class);
 		setCommandName("creditos");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		
 		CreditosBean creditos = (CreditosBean) command;
 		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		System.out.println("Dato1 ->" + creditos.getGrupoID());
 		System.out.println("Dato1 ->" + creditos.getSolicitudCreditoID());
 		System.out.println("Dato1 ->" + creditos.getUsuario());
 		System.out.println("Dato2 ->" + request.getParameter("grupoID"));
 		System.out.println("Dato2 ->" + request.getParameter("solicitudCreditoID"));
 		System.out.println("Dato2 ->" + request.getParameter("usuario"));
 		ByteArrayOutputStream htmlString = creditosServicio.reporteActaComite(creditos, nombreReporte);
 		
 		response.addHeader("Content-Disposition","inline; filename=ReporteActaComite.pdf");
 		response.setContentType("application/pdf");
 		byte[] bytes = htmlString.toByteArray();
 		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();
		return null;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	
}
