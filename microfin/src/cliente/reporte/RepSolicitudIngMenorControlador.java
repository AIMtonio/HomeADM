package cliente.reporte;


import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import cliente.bean.ClienteBean;
import cliente.bean.ReporteClienteBean;
import cliente.reporte.ReportePerfilCteControlador.Enum_Con_TipRepor;
import cliente.servicio.ClienteServicio;

public class RepSolicitudIngMenorControlador extends AbstractCommandController{

	



		ClienteServicio clienteServicio = new ClienteServicio ();
		String nombreReporte = null;
		
		public RepSolicitudIngMenorControlador(){
			setCommandClass(ReporteClienteBean.class);
			setCommandName("reporteClienteBean");
		}

		protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
		
			ReporteClienteBean reporteClienteBean= (ReporteClienteBean) command;
			 
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = clienteServicio.reporteSolicitudIngresoMenorPDF(reporteClienteBean, nombreReporte);
				response.setContentType("application/pdf");
				response.addHeader("Content-Disposition", "inline; filename=SolicitudDeIngresoMenor.pdf");
				
				byte[] bytes = htmlStringPDF.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			} catch (Exception e) {
				e.printStackTrace();
			}		
			return null;
		}

		public ClienteServicio getClienteServicio() {
			return clienteServicio;
		}

		public String getNombreReporte() {
			return nombreReporte;
		}

		public void setClienteServicio(ClienteServicio clienteServicio) {
			this.clienteServicio = clienteServicio;
		}

		public void setNombreReporte(String nombreReporte) {
			this.nombreReporte = nombreReporte;
		}


	
	
}
