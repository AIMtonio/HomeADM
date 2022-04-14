package tesoreria.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.ReporteChequesEmitidosBean;
import tesoreria.servicio.ReporteChequesEmitidosServicio;

public class ChequesEmitidosRepControlador extends AbstractCommandController {
	
	ReporteChequesEmitidosServicio chequeServicio = null;
	String successView = null;	
	String nomReporte = null;
	
	public ChequesEmitidosRepControlador(){
 		setCommandClass(ReporteChequesEmitidosBean.class);
 		setCommandName("chequesEmitidosRep");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		ReporteChequesEmitidosBean imprimeChequeBean = (ReporteChequesEmitidosBean) command;
			ByteArrayOutputStream htmlStringPDF = ImprimeChequeEmitido(imprimeChequeBean,response);
			return null;
			}
			
			// Reporte de Impresión de Cheques
			public ByteArrayOutputStream ImprimeChequeEmitido(ReporteChequesEmitidosBean imprimeChequeBean, HttpServletResponse response){
				ByteArrayOutputStream htmlStringPDF = null;
				try {
					htmlStringPDF = chequeServicio.reporteChequesEmitidosPDF(imprimeChequeBean, nomReporte);
					response.addHeader("Content-Disposition","inline; filename=ReporteChequesEmitidos.pdf");
					response.setContentType("application/pdf");
					byte[] bytes = htmlStringPDF.toByteArray();
					response.getOutputStream().write(bytes,0,bytes.length);
					response.getOutputStream().flush();
					response.getOutputStream().close();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			return htmlStringPDF;
			}
			
		public String getSuccessView() {
			return successView;
		}	
		
		public void setSuccessView(String successView) {
			this.successView = successView;
		}

		public ReporteChequesEmitidosServicio getChequeServicio() {
			return chequeServicio;
		}

		public void setChequeServicio(ReporteChequesEmitidosServicio chequeServicio) {
			this.chequeServicio = chequeServicio;
		}

		public String getNomReporte() {
			return nomReporte;
		}

		public void setNomReporte(String nomReporte) {
			this.nomReporte = nomReporte;
		}

	}
