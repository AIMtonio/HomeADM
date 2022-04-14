package contabilidad.reporte;

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
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.RegulatoriosContabilidadBean;
import contabilidad.servicio.RegulatoriosContabilidadServicio;
import contabilidad.servicio.RegulatoriosContabilidadServicio.Enum_Lis_ReportesA2111;

public class RegulatorioB2021ReporteControlador extends AbstractCommandController{
	RegulatoriosContabilidadServicio regulatoriosContabilidadServicio = null;
	String successView = null;
	
	public RegulatorioB2021ReporteControlador () {
		setCommandClass(RegulatoriosContabilidadBean.class);
		setCommandName("regulatoriosContabilidadBean");
	}


	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		RegulatoriosContabilidadBean reporteBean = (RegulatoriosContabilidadBean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		
			
			switch(tipoReporte)	{
				case Enum_Lis_ReportesA2111.excel:		
					reporteRegulatorioB2021(tipoReporte,reporteBean,response);
					break;
				case Enum_Lis_ReportesA2111.csv:
					regulatoriosContabilidadServicio.listaReporteRegulatorioB2021(tipoReporte, reporteBean, response); ;
			}
			
		
		return null;	
	}
	
	
	// Reporte Regulatorio De  razones Financieras Relevantes 
	public List  reporteRegulatorioB2021(int tipoReporte,RegulatoriosContabilidadBean reporteBean,  HttpServletResponse response){
		List listaRepote=null;
		listaRepote = regulatoriosContabilidadServicio.listaReporteRegulatorioB2021(tipoReporte, reporteBean, response); 	
		
		int regExport = 0;
		
		// Creacion de Libro
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			
			//Se crea una Fuente tamaño 10 
			HSSFFont fuentetamanio10= libro.createFont();
			fuentetamanio10.setFontHeightInPoints((short)10);
			fuentetamanio10.setFontName("Arial");
			
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo tamaño 10 alineado a la derecha
			HSSFCellStyle estiloTitulo = libro.createCellStyle();
			estiloTitulo.setFont(fuentetamanio10);
			estiloTitulo.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			
			// La fuente se mete en un estilo para poder ser usada.
			HSSFCellStyle estiloConceptos = libro.createCellStyle();
			estiloConceptos.setFont(fuentetamanio10);
			estiloConceptos.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			
			
			//Estilo tamaño 10 alineado a la derecha y con formato moneda
			HSSFCellStyle estiloSaldos = libro.createCellStyle();
			estiloSaldos.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			//Estilo Formato decimal (0.00)
			HSSFDataFormat format = libro.createDataFormat();
			estiloSaldos.setDataFormat(format.getFormat("#,##0.0000"));
			estiloSaldos.setFont(fuentetamanio10);
			
											
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("B 2021");		
					
			HSSFRow filaVacia= hoja.createRow(0);
			
			HSSFRow filaTitulo= hoja.createRow(1);
			HSSFCell celda=filaTitulo.createCell((short)0);			
			celda.setCellValue("Reporte regulatorio de Razones Financieras Relevantes por Entidad");
			celda.setCellStyle(estiloTitulo);	
			
			HSSFRow fila= hoja.createRow(2);
			celda=fila.createCell((short)0);
			celda.setCellValue("Subreporte: Razones Relevantes por Entidad");
			celda.setCellStyle(estiloTitulo);
			
			fila= hoja.createRow(3);
			celda=fila.createCell((short)0);
			celda.setCellValue("R20 B 2021");
			celda.setCellStyle(estiloTitulo);
									
			
			fila = hoja.createRow(4);	
			fila = hoja.createRow(5);
			
			
			int numeroFila=6  ,iter=0;
			int tamanioLista = listaRepote.size();
			RegulatoriosContabilidadBean reporteRegBean = null;
			for( iter=0; iter<tamanioLista; iter ++){				
				reporteRegBean = (RegulatoriosContabilidadBean) listaRepote.get(iter);
				fila=hoja.createRow(numeroFila);
				
				celda=fila.createCell((short)0);
				celda.setCellValue(reporteRegBean.getConcepto());	
				celda.setCellStyle(estiloConceptos);
				
				celda=fila.createCell((short)1);		
				if(iter == 0){
					celda.setCellValue(Integer.parseInt(reporteRegBean.getNumClientes()));
				}else{
					celda.setCellValue(reporteRegBean.getSaldo());		
					celda.setCellStyle(estiloSaldos);
				}							
						
				numeroFila++;
			} 
			
						
			

			for(int celd=0; celd<=18; celd++)
			hoja.autoSizeColumn((short)celd);
				
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=B 2021 Razones Financieras Relevantes por Entidad.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		}catch(Exception e){
			e.printStackTrace();
		}//Fin del catch
		return  listaRepote;
	}
	
	
	
	public RegulatoriosContabilidadServicio getRegulatoriosContabilidadServicio() {
		return regulatoriosContabilidadServicio;
	}
	public void setRegulatoriosContabilidadServicio(
			RegulatoriosContabilidadServicio regulatoriosContabilidadServicio) {
		this.regulatoriosContabilidadServicio = regulatoriosContabilidadServicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
