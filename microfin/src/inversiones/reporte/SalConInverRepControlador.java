package inversiones.reporte;
import herramientas.Utileria;
import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

	public class SalConInverRepControlador extends AbstractCommandController{
		
		InversionServicio inversionServicio = null;
		String nombreReporte = null;
		String successView = null;		   
		
		public SalConInverRepControlador() {
			setCommandClass(InversionBean.class);
			setCommandName("inverSalCon");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {

			String fecha = request.getParameter("fecha");
			String htmlString = inversionServicio.reporteInverSalCon(fecha,nombreReporte); 		 		
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
			
		}

		public InversionServicio getInversionServicio() {
			return inversionServicio;
		}

		public void setInversionServicio(InversionServicio inversionServicio) {
			this.inversionServicio = inversionServicio;
		}

		public String getNombreReporte() {
			return nombreReporte;
		}

		public void setNombreReporte(String nombreReporte) {
			this.nombreReporte = nombreReporte;
		}

		public String getSuccessView() {
			return successView;
		}

		public void setSuccessView(String successView) {
			this.successView = successView;
		}

		
	}