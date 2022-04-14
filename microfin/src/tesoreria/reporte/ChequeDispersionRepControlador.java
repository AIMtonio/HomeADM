package tesoreria.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.ImprimeChequeBean;
import tesoreria.servicio.ChequeDispersionRepServicio;
import tesoreria.servicio.ImprimeChequeServicio;

public class ChequeDispersionRepControlador extends AbstractCommandController {
	
	ChequeDispersionRepServicio chequeServicio = null;
	String successView = null;	
	
	public ChequeDispersionRepControlador(){
 		setCommandClass(ImprimeChequeBean.class);
 		setCommandName("imprimeChequeBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
			ImprimeChequeBean imprimeChequeBean = (ImprimeChequeBean) command;
		
			String htmlString= "";
					
			
			ByteArrayOutputStream htmlStringPDF = ImprimeChequeDispersion(imprimeChequeBean,response);
						
			return null;

			}
			
			// Reporte de Impresión de Cheques
			public ByteArrayOutputStream ImprimeChequeDispersion(ImprimeChequeBean imprimeChequeBean, HttpServletResponse response){
				ByteArrayOutputStream htmlStringPDF = null;
				try {
					htmlStringPDF = chequeServicio.reporteImprimeChequeDisper(imprimeChequeBean);
					response.addHeader("Content-Disposition","inline; filename=ImprimeCheque.pdf");
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
	 		
		// Getter y Setter
	

		public String getSuccessView() {
			return successView;
		}		
		public void setSuccessView(String successView) {
			this.successView = successView;
		}

		public ChequeDispersionRepServicio getChequeServicio() {
			return chequeServicio;
		}

		public void setChequeServicio(ChequeDispersionRepServicio chequeServicio) {
			this.chequeServicio = chequeServicio;
		}

	}
