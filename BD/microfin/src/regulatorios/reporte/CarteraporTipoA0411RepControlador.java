package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.CarteraPorTipoA0411Bean;
import regulatorios.servicio.RegulatorioA0411Servicio;

public class CarteraporTipoA0411RepControlador extends AbstractCommandController  {
	
	RegulatorioA0411Servicio regulatorioA0411Servicio = null;
		String successView = null;
		
		public CarteraporTipoA0411RepControlador () {
			setCommandClass(CarteraPorTipoA0411Bean.class);
			setCommandName("carteraPorTipoA0411Bean");
		}
	
		protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
			try {
				MensajeTransaccionBean mensaje = null;
				CarteraPorTipoA0411Bean regulatorioA0411Bean = (CarteraPorTipoA0411Bean) command;

				int tipoReporte = (request.getParameter("tipoReporte") != null)
						? Integer.parseInt(request.getParameter("tipoReporte"))
						: 0;
						
				int tipoEntidad = (request.getParameter("tipoEntidad") != null)
						? Integer.parseInt(request.getParameter("tipoEntidad"))
						: 0;
				
				

				regulatorioA0411Servicio.listaReporteRegulatorioA0411(tipoReporte,tipoEntidad, regulatorioA0411Bean, response);

			    	
						
				
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			return null;
		}

		public RegulatorioA0411Servicio getRegulatorioA0411Servicio() {
			return regulatorioA0411Servicio;
		}

		public void setRegulatorioA0411Servicio(
				RegulatorioA0411Servicio regulatorioA0411Servicio) {
			this.regulatorioA0411Servicio = regulatorioA0411Servicio;
		}

		public String getSuccessView() {
			return successView;
		}

		public void setSuccessView(String successView) {
			this.successView = successView;
		}
		

}
