package riesgos.reporte;

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
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosPorProductoServicio;

public class CreditosPorProductoRepControlador extends AbstractCommandController{
	CreditosPorProductoServicio creditosPorProductoServicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporteExcel= 3;
	}
	public CreditosPorProductoRepControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("creditosPorProducto");
	}
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
				
		UACIRiesgosBean riesgosBean = (UACIRiesgosBean) command;
		// TODO Auto-generated method stub
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
						
			switch(tipoReporte){
				case Enum_Con_TipRepor.ReporteExcel:
					reporteCreditoProducto(tipoReporte,riesgosBean,response);
				break;
			}
			return null;
		}
	// Reporte de Créditos por Producto
	public List reporteCreditoProducto(int tipoReporte,UACIRiesgosBean riesgosBean,  HttpServletResponse response){
		List listaRepote=null;
		String nombreArchivo = "";
		nombreArchivo = "Créditos por Producto "+riesgosBean.getFechaOperacion(); 
		listaRepote = creditosPorProductoServicio.listaReporteCreditoProducto(tipoReporte, riesgosBean, response); 
		
		int numCelda = 0;
		
		// Creacion de Libro
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Estilo de datos centrados Encabezado
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			//Crea fuente con tamaño 8 para informacion del reporte.
			HSSFFont fuente8= libro.createFont();
			fuente8.setFontHeightInPoints((short)10);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			estiloNeg8.setFont(fuenteNegrita8);
			estiloNeg8.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo de 8  para Contenido
			HSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat formato = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(formato.getFormat("$ #,##0.00"));
			estiloFormatoDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo Formato decimal Negrita ($ 0.00)
			HSSFCellStyle estiloDecimal = libro.createCellStyle();
			HSSFDataFormat formato2 = libro.createDataFormat();
			estiloDecimal.setDataFormat(formato2.getFormat("$ #,##0.00"));
			estiloDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloDecimal.setFont(fuenteNegrita10);
			
			//Estilo negrita tamaño 10 centrado
			HSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setFont(fuenteNegrita10);
			
			//Estilo negrita tamaño 8 centrado
			HSSFCellStyle estiloEncabezado8 = libro.createCellStyle();
			estiloEncabezado8.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloEncabezado8.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezado8.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado8.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado8.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado8.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado8.setFont(fuenteNegrita8);
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Créditos por Producto");
			HSSFRow fila= hoja.createRow(1);
			
			// Encabezado
			// Nombre Institucion	
			HSSFCell celdaInst=fila.createCell((short)1);
			celdaInst.setCellValue(riesgosBean.getNombreInstitucion());
			celdaInst.setCellStyle(estiloDatosCentrado);

			  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            9  //ultima celda   (0-based)
			    ));	
			  
				fila = hoja.createRow(3);
				HSSFCell celda=fila.createCell((short)1);
				celda.setCellValue("REPORTE CRÉDITOS POR PRODUCTOS: "+riesgosBean.getFechaOperacion());
				celda.setCellStyle(estiloDatosCentrado);
				
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            9  //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(5);
				HSSFCell celdaMon=fila.createCell((short)2);
				celdaMon.setCellValue("Monto de Cartera Acumulado del Día de Ayer");			
			        celdaMon.setCellStyle(estiloEncabezado8);
			        
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            5, //primera fila (0-based)
			            5, //ultima fila  (0-based)
			            2, //primer celda (0-based)
			            5  //ultima celda   (0-based)
			    ));
			    	

			    	HSSFCell celdaSal=fila.createCell((short)6);
				celdaSal.setCellValue("Saldo de Cartera Acumulado al Día de Ayer");
				celdaSal.setCellStyle(estiloEncabezado8);
				
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            5, //primera fila (0-based)
			            5, //ultima fila  (0-based)
			            6, //primer celda (0-based)
			            9  //ultima celda   (0-based)
			    ));
			    
				fila = hoja.createRow(6);
				celda = fila.createCell((short)1);
				celda.setCellValue("Nombre Producto");
				celda.setCellStyle(estiloEncabezado8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Monto Cartera");
				celda.setCellStyle(estiloEncabezado8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Resultado\nPorcentual %");
				celda.setCellStyle(estiloEncabezado8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Parámetro\nde Porcentaje  %");
				celda.setCellStyle(estiloEncabezado8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Diferencia al Límite\n Establecido %");
				celda.setCellStyle(estiloEncabezado8);

				celda = fila.createCell((short)6);
				celda.setCellValue("Saldo Cartera");
				celda.setCellStyle(estiloEncabezado8);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Resultado\nPorcentual %");
				celda.setCellStyle(estiloEncabezado8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Parámetro de\n Porcentaje  %");
				celda.setCellStyle(estiloEncabezado8);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Diferencia al Límite\n Establecido %");
				celda.setCellStyle(estiloEncabezado8);
				
				int i=7,iter=0;
				int tamanioLista = listaRepote.size();
				UACIRiesgosBean riesgos = null;
				for( iter=0; iter<tamanioLista; iter ++){
				 
					riesgos = (UACIRiesgosBean) listaRepote.get(iter);
					fila=hoja.createRow(i);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(riesgos.getDescProducto());
					
					celda=fila.createCell((short)2);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getMontoCarteraProducto()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)3);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getResultadoPorcentual()));
					
					celda=fila.createCell((short)4);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getParametroPorcentaje()));
					
					celda=fila.createCell((short)5);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getDifLimiteEstablecido()));
					
					celda=fila.createCell((short)6);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getSaldoCartera()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)7);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getResPorcentualPro()));
					
					celda=fila.createCell((short)8);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getParamPorcentajePro()));
					
					celda=fila.createCell((short)9);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getDifLimitePro()));
					i++;
				}
				
				
				fila = hoja.createRow(13);
				HSSFCell celdaMonto=fila.createCell((short)13);
				celdaMonto = fila.createCell((short)1);
				celdaMonto.setCellValue("Total Monto Cartera");
				celdaMonto.setCellStyle(estiloNeg8);
				celdaMonto = fila.createCell((short)2);
				String resMonto = "SUM(C8:C12)";
				celdaMonto.setCellType (HSSFCell.CELL_TYPE_FORMULA ); 
				celdaMonto.setCellFormula(resMonto);
				celdaMonto.setCellStyle(estiloDecimal);
				
				HSSFCell celdaSaldo=fila.createCell((short)13);
				celdaSaldo = fila.createCell((short)5);
				celdaSaldo.setCellValue("Total Saldo Cartera");
				celdaSaldo.setCellStyle(estiloNeg8);
				celdaSaldo = fila.createCell((short)6);
				String resSaldo = "SUM(G8:G12)";
				celdaSaldo.setCellType (HSSFCell.CELL_TYPE_FORMULA ); 
				celdaSaldo.setCellFormula(resSaldo);
				celdaSaldo.setCellStyle(estiloDecimal);
				//Nombre del Archivo
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

	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosPorProductoServicio getCreditosPorProductoServicio() {
		return creditosPorProductoServicio;
	}
	public void setCreditosPorProductoServicio(
			CreditosPorProductoServicio creditosPorProductoServicio) {
		this.creditosPorProductoServicio = creditosPorProductoServicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	
}
