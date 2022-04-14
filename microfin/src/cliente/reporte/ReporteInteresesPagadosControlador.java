package cliente.reporte;

import general.bean.MensajeTransaccionBean;

import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.bean.SaldosCarteraAvaRefRepBean;
import cliente.bean.RepInteresesPagadosBean;
import cliente.servicio.RepInteresesPagadosServicio;

public class ReporteInteresesPagadosControlador extends AbstractCommandController{
	
	public static interface Enum_Con_TipRepor {
		  int  excel= 1 ;
	}
	RepInteresesPagadosServicio repInteresesPagadosServicio = null;
	
	String nombreReporte = null;
	String successView = null;
	
	public ReporteInteresesPagadosControlador(){
		setCommandClass(RepInteresesPagadosBean.class);
		setCommandName("repInteresesPagados");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response,  Object command, BindException errors) throws Exception {

		RepInteresesPagadosBean repInteresesPagadosBean = (RepInteresesPagadosBean) command;
		
		int tipoReporte =(request.getParameter("tipoRep")!=null)?Integer.parseInt(request.getParameter("tipoRep")):0;
	
		String htmlString= "";
		
		switch(tipoReporte){	
		case Enum_Con_TipRepor.excel:	
			 List<RepInteresesPagadosBean>listaReportes = listaReporte(tipoReporte, repInteresesPagadosBean ,response);
			 break;
			 
		}
		return null;	
	}
	
	public List<RepInteresesPagadosBean> listaReporte(int tipoReporte,RepInteresesPagadosBean repInteresesPagadosBean,  HttpServletResponse response){
		List<RepInteresesPagadosBean> listaIntereses=null;
		
		if(tipoReporte ==1){
			listaIntereses = repInteresesPagadosServicio.listaReporte(1, repInteresesPagadosBean, response);
		}	
		
	     
		int regExport = 0;
		Calendar calendario = Calendar.getInstance();
		
		if(listaIntereses != null){
			try {
				Workbook libro = new SXSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				Font fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Arial");
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);						
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuente10= libro.createFont();
				fuente10.setFontHeightInPoints((short)10);
				fuente10.setFontName("Arial");												
						
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				CellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);			

			
				//Estilo negrita de 8  para encabezados del reporte												
				CellStyle estiloCentrado = libro.createCellStyle();
				estiloCentrado.setFont(fuenteNegrita10);
				estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
												
				//Estilo negrita de 8  para encabezados del reporte												
				CellStyle estiloCentradoNoNeg = libro.createCellStyle();
				estiloCentradoNoNeg.setFont(fuente10);
				estiloCentradoNoNeg.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				
						
				//Estilo negrita de 8  para encabezados del reporte
				CellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita10);
						
				//Estilo Formato decimal (0.00)
				CellStyle estiloFormatoDecimal = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
						
						
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("Reporte Intereses Pagados");
				Row fila = hoja.createRow(0);
				
				if(tipoReporte == 1) {	
						
					fila = hoja.createRow(1);
					Cell celda=fila.createCell((short)1);	
						
					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue(repInteresesPagadosBean.getNombreInstitucion());
					CellRangeAddress region = new CellRangeAddress(1,1,1,9);
					hoja.addMergedRegion(region);
						 
					celda = fila.createCell((short)10);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Usuario:");				// Usuario que genera el reporte		
					celda = fila.createCell((short)11);
					celda.setCellValue(repInteresesPagadosBean.getNomUsuario().toUpperCase());
					//celda.setCellStyle(estiloNeg10);					
							
					fila = hoja.createRow(2);		
							
					celda = fila.createCell	((short)1);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Reporte de Intereses Pagados de "+repInteresesPagadosBean.getFechaInicio()+" AL "+repInteresesPagadosBean.getFechaFin());
					hoja.addMergedRegion(new CellRangeAddress(
				            2, //primera fila 
				            2, //ultima fila 
				            1, //primer celda
				            9 //ultima celda
				    ));	
							
					celda=fila.createCell((short)10);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Fecha: ");
						
					celda=fila.createCell((short)11);
					//celda.setCellStyle(estiloNeg10);
					celda.setCellValue(repInteresesPagadosBean.getFechaSistema());	// Fecha de Emisión del Reporte
						
					fila = hoja.createRow(3);								
	
					celda = fila.createCell((short)10);
					celda.setCellValue("Hora: ");
					celda.setCellStyle(estiloNeg8);
					celda = fila.createCell((short)11);
					String horaVar="";
				
					int hora =calendario.get(Calendar.HOUR_OF_DAY);
					int minutos = calendario.get(Calendar.MINUTE);
					int segundos = calendario.get(Calendar.SECOND);
				
					String h = Integer.toString(hora);
					String m = "";
					String s = "";
					if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
					if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);
					 
					horaVar= h+":"+m+":"+s;
					celda.setCellValue(horaVar);
					//celda.setCellStyle(estiloNeg10);				
								
					// Creacion de fila
					fila = hoja.createRow(4);					
					fila = hoja.createRow(5);
					
					int numCelda = 1;
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("No. Cliente");
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Nombre Completo");
					celda.setCellStyle(estiloCentrado);						
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Número Cuenta/Inversión");
					celda.setCellStyle(estiloCentrado);
								

					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Fecha Apertura");
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Fecha Vencimiento");
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Número Días");
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Monto");
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Tasa Promedio Anual");
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Interés Nominal");
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("ISR Retenido");
					celda.setCellStyle(estiloCentrado);
					
					// Solicitud Actualizada
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Interés Real");
					celda.setCellStyle(estiloCentrado);
						
					int i=6,iter=0;
					int tamanioLista = listaIntereses.size();
					RepInteresesPagadosBean repInteresesPagados = null;
					
					for( iter=0; iter<tamanioLista; iter ++){
						numCelda = 1;
						repInteresesPagados =  (RepInteresesPagadosBean) listaIntereses.get(iter);
						
						fila=hoja.createRow(i);
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(repInteresesPagados.getClienteID().equals(null) || repInteresesPagados.getClienteID().equals("") ? "" : repInteresesPagados.getClienteID());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(repInteresesPagados.getNombreCompleto().equals(null) || repInteresesPagados.getNombreCompleto().equals("") ? "" : repInteresesPagados.getNombreCompleto());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(repInteresesPagados.getInstrumentoID().equals(null) || repInteresesPagados.getInstrumentoID().equals("") ? "" : repInteresesPagados.getInstrumentoID());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(repInteresesPagados.getFechaApertura().equals(null) || repInteresesPagados.getFechaApertura().equals("") ? "" : repInteresesPagados.getFechaApertura());
						celda.setCellStyle(estiloCentradoNoNeg);
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(repInteresesPagados.getFechaVencimiento().equals(null) || repInteresesPagados.getFechaVencimiento().equals("") ? "" : repInteresesPagados.getFechaVencimiento());
						celda.setCellStyle(estiloCentradoNoNeg);
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(repInteresesPagados.getNumDias().equals(null) || repInteresesPagados.getNumDias().equals("") ? "0" : repInteresesPagados.getNumDias());
						celda.setCellStyle(estiloCentradoNoNeg);
				
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(Double.parseDouble(repInteresesPagados.getMonto()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)numCelda++);					
						celda.setCellValue(repInteresesPagados.getTasaInteres().equals(null) || repInteresesPagados.getTasaInteres().equals("") ? "0.00" : repInteresesPagados.getTasaInteres());
						celda.setCellStyle(estiloCentradoNoNeg);
						
						celda=fila.createCell((short)numCelda++);							
						celda.setCellValue(Double.parseDouble(repInteresesPagados.getInteresesGen()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(Double.parseDouble(repInteresesPagados.getISR()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(Double.parseDouble(repInteresesPagados.getInteresReal()));
						celda.setCellStyle(estiloFormatoDecimal);
						i++;
					}		
						
					i = i+2;
					fila=hoja.createRow(i);
					celda = fila.createCell((short)0);
					celda.setCellValue("Registros Exportados");
					celda.setCellStyle(estiloNeg8);
					celda=fila.createCell((short)1);
					celda.setCellValue(tamanioLista);			

					for(int celd=0; celd<=numCelda+1; celd++){
						hoja.autoSizeColumn((short)celd);
					}

				}					

				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteInteresesPagados.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			}catch(Exception e){
			
				e.printStackTrace();
			}//Fin del catch
		}
						
		return  listaIntereses;
			
	}

	public RepInteresesPagadosServicio getRepInteresesPagadosServicio() {
		return repInteresesPagadosServicio;
	}

	public void setRepInteresesPagadosServicio(
			RepInteresesPagadosServicio repInteresesPagadosServicio) {
		this.repInteresesPagadosServicio = repInteresesPagadosServicio;
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
