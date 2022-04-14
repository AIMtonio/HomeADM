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
import riesgos.servicio.CreditosSectorEconomicoServicio;

public class CreditosSectorEconomicoRepControlador extends AbstractCommandController{
	CreditosSectorEconomicoServicio creditosSectorEconomicoServicio = null;	
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporteExcel= 3;
	}
	public CreditosSectorEconomicoRepControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("creditosSectorEconomico");
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
					reporteSectorEconomico(tipoReporte,riesgosBean,response);
				break;
			}
			return null;
		}
	// Reporte de Créditos por Sector Económico
	public List reporteSectorEconomico(int tipoReporte,UACIRiesgosBean riesgosBean,  HttpServletResponse response){
		List listaRepote=null;
		String nombreArchivo = "";
		nombreArchivo = "Crédito por Sector Económico "+riesgosBean.getFechaOperacion();
		listaRepote = creditosSectorEconomicoServicio.listaReporteSectorEconomico(tipoReporte, riesgosBean, response); 
		
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
			estiloNeg8.setFont(fuenteNegrita8);
			
			//Estilo de 8  para Contenido
			HSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);
			
			//Estilo de datos centrados contenido
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			estiloCentrado.setFont(fuente8);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo de datos derecha contenido
			HSSFCellStyle estiloDerecha = libro.createCellStyle();
			estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);  
			estiloDerecha.setFont(fuente8);
			estiloDerecha.setVerticalAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat formato = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(formato.getFormat("#,##0.00"));
			estiloFormatoDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Crédito por Sector Económico");
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
				celda.setCellValue("REPORTE CRÉDITOS POR SECTOR ECONÓMICO: "+riesgosBean.getFechaOperacion());
				celda.setCellStyle(estiloDatosCentrado);
				
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            9  //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(5);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Nombre Sector");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Monto Cartera\nSector");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Resultado\nPorcentual (Monto)  %");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Parámetro de\nPorcentaje  %");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Diferencia al Límite\n Establecido (Monto)  %");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Saldo Cartera\nSector");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Resultado\nPorcentual (Saldo)  %");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Parámetro de\n Porcentaje  %");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Diferencia al Límite\n Establecido (Saldo)  %");
				celda.setCellStyle(estiloNeg8);
				
				int i=6,iter=0;
				int tamanioLista = listaRepote.size();
				UACIRiesgosBean riesgos = null;
				for( iter=0; iter<tamanioLista; iter ++){
				 
					riesgos = (UACIRiesgosBean) listaRepote.get(iter);
					fila=hoja.createRow(i);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(riesgos.getDescActEconomica());
					
					celda=fila.createCell((short)2);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getMontoActEconomica()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)3);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getResultadoPorcentual()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)4);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getParametroPorcentaje()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)5);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getDifLimiteEstablecido()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)6);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getSaldoCartera()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)7);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getResPorcentualSecEcon()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)8);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getParamPorcentajeSecEcon()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getDifLimiteSecEcon()));
					celda.setCellStyle(estiloFormatoDecimal);
					i++;
				}
				
				i = i+1;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				i = i+1;
				fila=hoja.createRow(i);
				celda=fila.createCell((short)0);
				celda.setCellValue(tamanioLista);

				for(int celd=0; celd<=19; celd++)
				hoja.autoSizeColumn((short)celd);
				
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
	public CreditosSectorEconomicoServicio getCreditosSectorEconomicoServicio() {
		return creditosSectorEconomicoServicio;
	}
	public void setCreditosSectorEconomicoServicio(
			CreditosSectorEconomicoServicio creditosSectorEconomicoServicio) {
		this.creditosSectorEconomicoServicio = creditosSectorEconomicoServicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
