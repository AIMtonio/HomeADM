package tesoreria.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.ImprimeChequeBean;
import tesoreria.servicio.ImprimeChequeServicio;

public class ImprimeChequeRepControlador extends AbstractCommandController {
	
	ImprimeChequeServicio imprimeChequeServicio = null;
	String successView = null;	
	
	public ImprimeChequeRepControlador(){
 		setCommandClass(ImprimeChequeBean.class);
 		setCommandName("imprimeChequeBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
			ImprimeChequeBean imprimeChequeBean = (ImprimeChequeBean) command;
		
			String htmlString= "";
					
			
			ByteArrayOutputStream htmlStringPDF = ImprimeChequeRepPDF(imprimeChequeBean,response);
						
			return null;

			}
			
			// Reporte de Impresión de Cheques
			public ByteArrayOutputStream ImprimeChequeRepPDF(ImprimeChequeBean imprimeChequeBean, HttpServletResponse response){
				ByteArrayOutputStream htmlStringPDF = null;
				try {
					htmlStringPDF = imprimeChequeServicio.reporteImprimeChequePDF(imprimeChequeBean);
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
		public ImprimeChequeServicio getImprimeChequeServicio() {
			return imprimeChequeServicio;
		}

		public void setImprimeChequeServicio(ImprimeChequeServicio imprimeChequeServicio) {
			this.imprimeChequeServicio = imprimeChequeServicio;
		}

		public String getSuccessView() {
			return successView;
		}

		public void setSuccessView(String successView) {
			this.successView = successView;
		}

	}
