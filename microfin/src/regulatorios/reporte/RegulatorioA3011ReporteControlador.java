

package regulatorios.reporte;
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

import regulatorios.bean.RegulatorioA3011Bean;
import regulatorios.servicio.RegulatorioA3011Servicio;
import regulatorios.servicio.RegulatorioA3011Servicio.Enum_Lis_ReportesA3011;

public class RegulatorioA3011ReporteControlador extends AbstractCommandController{
	RegulatorioA3011Servicio regulatorioA3011Servicio = null;
	String successView = null;
	
	public RegulatorioA3011ReporteControlador () {
		setCommandClass(RegulatorioA3011Bean.class);
		setCommandName("RegulatorioA3011Bean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		RegulatorioA3011Bean reporteBean = (RegulatorioA3011Bean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		
			switch(tipoReporte)	{
				case Enum_Lis_ReportesA3011.excel:		
					reporteRegulatorioA3011(tipoReporte,reporteBean,response);
					break;
				case Enum_Lis_ReportesA3011.csv:
					regulatorioA3011Servicio.listaReporteRegulatorioA3011(tipoReporte, reporteBean, response); ;
			}
	
		return null;	
	}
	
	// Reporte Regulatorio De  Requerimientos de Capital por Riesgos 
	public List  reporteRegulatorioA3011(int tipoReporte,RegulatorioA3011Bean reporteBean,  HttpServletResponse response){
		List listaRepote=null;
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";
		mesEnLetras = regulatorioA3011Servicio.descripcionMes(reporteBean.getMes());
		
		anio	= reporteBean.getAnio();
		
		nombreArchivo = "R20 A 3011 "+mesEnLetras +" "+anio; 
		
		listaRepote = regulatorioA3011Servicio.listaReporteRegulatorioA3011(tipoReporte, reporteBean, response); 	
		
		int numCelda = 0;
		
		// Creacion de Libro
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 11 
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)11);
			fuenteNegrita10.setFontName("Calibri");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Se crea una Fuente tamaño 10 
			HSSFFont fuentetamanio10= libro.createFont();
			fuentetamanio10.setFontHeightInPoints((short)10);
			fuentetamanio10.setFontName("Calibri");
			
			//Se crea una Fuente tamaño 10 Arial
			HSSFFont fuentetamanio10Arial= libro.createFont();
			fuentetamanio10Arial.setFontHeightInPoints((short)10);
			fuentetamanio10Arial.setFontName("Arial");
			
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo tamaño 10 alineado a la derecha
			HSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setFont(fuenteNegrita10);
			estiloEncabezado.setFillForegroundColor(HSSFColor.YELLOW.index);
			estiloEncabezado.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			
			//Estilo tamaño 10 alineado a la derecha
			HSSFCellStyle estiloDatoEntero = libro.createCellStyle();
			estiloDatoEntero.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			//Estilo Formato entero (000,000)
			HSSFDataFormat format = libro.createDataFormat();
			estiloDatoEntero.setDataFormat(format.getFormat("#,##0"));
			estiloDatoEntero.setFont(fuentetamanio10Arial);
			
			//Estilo tamaño 10 alineado a la derecha
			HSSFCellStyle estiloDatoTexto = libro.createCellStyle();
			estiloDatoTexto.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			estiloDatoTexto.setFont(fuentetamanio10Arial);
			
			//Estilo tamaño 10 alineado a la derecha y con formato moneda
			HSSFCellStyle estiloDatoDecimal = libro.createCellStyle();
			estiloDatoDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloDatoDecimal.setDataFormat(format.getFormat("#,##0"));
			estiloDatoDecimal.setFont(fuentetamanio10Arial);
			
											
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("A 3011");		
					
			HSSFRow filaEncabezado= hoja.createRow(0);
			HSSFCell celda=filaEncabezado.createCell((short)numCelda++);			
			celda.setCellValue("PERIODO");
			celda.setCellStyle(estiloEncabezado);			
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CLAVE DE \nLA ENTIDAD");
			celda.setCellStyle(estiloEncabezado);			
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CLAVE DEL \nFORMULARIO");
			celda.setCellStyle(estiloEncabezado);									
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CLAVE \nESTADO");
			celda.setCellStyle(estiloEncabezado);									
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CLAVE \nMUNICIPIO");
			celda.setCellStyle(estiloEncabezado);									
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("NUMERO DE \nSUCURSALES");
			celda.setCellStyle(estiloEncabezado);									
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("NUMERO DE \nCAJEROS \nAUTOMATICOS");
			celda.setCellStyle(estiloEncabezado);			
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("NUMERO DE \nSOCIOS \nMUJERES");
			celda.setCellStyle(estiloEncabezado);			
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("NUMERO DE \nSOCIOS \nHOMBRES");
			celda.setCellStyle(estiloEncabezado);			
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("VALOR DE LA \nPARTE SOCIAL");
			celda.setCellStyle(estiloEncabezado);			
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CAPTACION, \nDEPOSITOS DE \nEXIGIBILIDAD \nNUMERO DE \nCONTRATOS");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CAPTACION, \nDEPOSITOS DE \nEXIGIBILIDAD \nINMEDIATA \nSALDO \nACUMULADO");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CAPTACION, \nDEPOSITOS A \nPLAZO  NUMERO \nDE CONTRATOS");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CAPTACION, \nDEPOSITOS A \nPLAZO  SALDO \nACUMULADO");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CAPTACION, \nTARJETA DE \nDEBITO NUMERO \nDE CONTRATOS");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CAPTACION, \nTARJETA DE \nDEBITO  SALDO \nACUMULADO");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CAPTACION, \nTARJETAS \nRECARGABLES  \nNUMERO DE \nCONTRATOS");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CAPTACION, \nTARJETAS \nRECARGABLES  \nSALDO \nACUMULADO");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nCREDITOS \nCOMERCIALES  (SIN \nMICROCREDITO)   \nNUMERO DE \nCONTRATOS");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nCREDITOS \nCOMERCIALES  \n(SIN \nMICROCREDITO)  \nSALDO VIGENTE");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nCREDITOS \nCOMERCIALES  \n(SIN \nMICROCREDITO) \nSALDO VENCIDO");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nMICROCREDI\nTOS  NUMERO DE \nCONTRATOS");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nMICROCRE\nDITOS  \nSALDO \nVIGENTE");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nMICROCREDI\nTOS SALDO \nVENCIDO");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nTARJETAS DE \nCREDITO  \nNUMERO DE \nCONTRATOS");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nTARJETAS DE \nCREDITO  \nSALDO \nVIGENTE");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nTARJETAS DE \nCREDITO  \nSALDO \nVENCIDO");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, CREDITOS \nCONSUMO (SIN TARJETAS \nDE CREDITO)  NUMERO DE \nCONTRATOS");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nCREDITOS \nCONSUMO  (SIN \nTARJETAS DE \nCREDITO)  \nSALDO VIGENTE");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nCREDITOS \nCONSUMO  (SIN \nTARJETAS DE \nCREDITO)  \nSALDO VENCIDO");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nCREDITOS A LA \nVIVIENDA  \nNUMERO DE \nCONTRATOS");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nPRODUCTO \nCREDITOS A LA \nVIVIENDA  SALDO \nVIGENTE");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("CREDITO, \nPRODUCTO \nCREDITOS A \nLA VIVIENDA \nSALDO \nVENCIDO");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("NUMERO \nDE \nREMESAS");
			celda.setCellStyle(estiloEncabezado);
			celda=filaEncabezado.createCell((short)numCelda++);
			celda.setCellValue("MONTO \nDE \nREMESAS");
			celda.setCellStyle(estiloEncabezado);
			
			for(byte cell= 0; cell < numCelda; cell++){
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila 
			            6, //ultima fila  
			            cell, //primer columna 
			            cell //ultima columna  
			    ));
				hoja.autoSizeColumn((short)cell);
			}
			
		
			int numeroFila=7  ,iter=0;
			int tamanioLista = listaRepote.size();
			RegulatorioA3011Bean reporteRegBean = null;
			HSSFRow fila;			
			
			for( iter=0; iter<tamanioLista; iter ++){
				numCelda = 0;
				reporteRegBean = (RegulatorioA3011Bean) listaRepote.get(iter);
				fila =hoja.createRow(numeroFila);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getPeriodo()));	
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(reporteRegBean.getClaveEntidad());		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(reporteRegBean.getClaveFormulario());		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(reporteRegBean.getEstadoID());		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(reporteRegBean.getMunicipioID());		
				celda.setCellStyle(estiloDatoTexto);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumSucursales()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumCajerosATM()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumMujeres()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumHombres()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getParteSocial()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumContrato()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoAcum()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumContratoPlazo()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoAcumPlazo()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumContratoTD()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoAcumTD()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumContratoTDRecar()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoAcumTDRecar()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumCreditos()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoVigenteCre()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoVencidoCre()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumMicroCreditos()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoVigenteMicroCre()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoVencidoMicroCre()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumContratoTC()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoVigenteTC()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoVencidoTC()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumCreConsumo()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoVigenteCreConsumo()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoVencidoCreConsumo()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumCreVivienda()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoVigenteCreVivienda()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldoVencidoCreVivienda()));		
				celda.setCellStyle(estiloDatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Integer.parseInt(reporteRegBean.getNumRemesas()));		
				celda.setCellStyle(estiloDatoEntero);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getMontoRemesas()));		
				celda.setCellStyle(estiloDatoEntero);
						
				numeroFila++;
			} 
			
						
			
				
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
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
	
	


	public RegulatorioA3011Servicio getRegulatorioA3011Servicio() {
		return regulatorioA3011Servicio;
	}

	public void setRegulatorioA3011Servicio(
			RegulatorioA3011Servicio regulatorioA3011Servicio) {
		this.regulatorioA3011Servicio = regulatorioA3011Servicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}