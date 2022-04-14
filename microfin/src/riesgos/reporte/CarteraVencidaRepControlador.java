package riesgos.reporte;

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
import riesgos.servicio.CarteraVencidaServicio;

public class CarteraVencidaRepControlador extends AbstractCommandController{
	CarteraVencidaServicio carteraVencidaServicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporteExcel= 1;
	}
	public CarteraVencidaRepControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("carteraVencida");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
				
		UACIRiesgosBean riesgosBean = (UACIRiesgosBean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
						
			switch(tipoReporte){
				case Enum_Con_TipRepor.ReporteExcel:
					reporteCarteraVencida(tipoReporte,riesgosBean,response);
				break;
			}
			return null;
		}
	// Reporte de Cartera Vencida
	public List reporteCarteraVencida(int tipoReporte,UACIRiesgosBean riesgosBean,  HttpServletResponse response){
		List listaRepote=null;
		String nombreArchivo = "";
		nombreArchivo = "CarteraVencida"; 
		listaRepote = carteraVencidaServicio.listaReporteCarteraVencida(tipoReporte, riesgosBean, response); 
		
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
			
			//Estilo de 8 Negrita para Contenido
			HSSFCellStyle estiloNegrita8 = libro.createCellStyle();
			estiloNegrita8.setFont(fuenteNegrita8);
			
			//Estilo de 8  para Contenido
			HSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat formato = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(formato.getFormat("#,##0.00"));
			estiloFormatoDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Cartera Vencida "+riesgosBean.getFechaOperacion());
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
			            4  //ultima celda   (0-based)
			    ));	
			  
				fila = hoja.createRow(3);
				HSSFCell celdaRep=fila.createCell((short)1);
				celdaRep.setCellValue("REPORTE DE CARTERA VENCIDA: "+riesgosBean.getFechaOperacion());
				celdaRep.setCellStyle(estiloDatosCentrado);
				
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));
				
				//Inicialización de variables
				String montoCarteraCredVen 	= "";
				String saldoCarteraCreVen 	= "";
				String saldoCarteraCredito 	= "";
				String resultadoPorcentual 	= "";
				String parametroPorcentaje 	= "";
				
				String difLimiteEstablecido = "";
				String saldoCarteraCreVencida = "";
				String resultadoPorcCar = "";
				String difLimiteEstabCar = "";
				String parametroPorcCar = "";
				
				int itera=0;
				UACIRiesgosBean riesgos = null;
				if(!listaRepote.isEmpty()){
				for( itera=0; itera<1; itera ++){
					riesgos = (UACIRiesgosBean) listaRepote.get(itera);
					montoCarteraCredVen = riesgos.getMontoCarteraCredVen();
					saldoCarteraCreVen = riesgos.getSaldoCarteraCreVen();
					saldoCarteraCredito = riesgos.getSaldoCarteraCredito();
					resultadoPorcentual = riesgos.getResultadoPorcentual();
					parametroPorcentaje = riesgos.getParametroPorcentaje();
					
					difLimiteEstablecido = riesgos.getDifLimiteEstablecido();
					saldoCarteraCreVencida = riesgos.getSaldoCarteraCreVencida();
					resultadoPorcCar = riesgos.getResultadoPorcCar();
					difLimiteEstabCar = riesgos.getDifLimiteEstabCar();
					parametroPorcCar = riesgos.getParametroPorcCar();
					
					}
				}
				
				fila = hoja.createRow(5);
				HSSFCell celda=fila.createCell((short)5);
				celda = fila.createCell((short)1);
				celda.setCellValue("Monto de Cartera Acumulado del Día de Ayer");
				celda.setCellStyle(estiloNegrita8);
				celda = fila.createCell((short)4);
				celda.setCellValue("Saldo de Cartera Acumulado al Día de Ayer");
				celda.setCellStyle(estiloNegrita8);
				
				fila = hoja.createRow(7);
				HSSFCell celdaMonto=fila.createCell((short)7);
				celdaMonto = fila.createCell((short)1);
				celdaMonto.setCellValue("Monto Cartera de Crédito Vencida");
				celdaMonto.setCellStyle(estilo8);
				celdaMonto = fila.createCell((short)2);
				celdaMonto.setCellValue(Double.parseDouble(montoCarteraCredVen));
				celdaMonto.setCellStyle(estiloFormatoDecimal);
				celdaMonto = fila.createCell((short)4);
				celdaMonto.setCellValue("Saldo Total de la Cartera de Crédito Vencida");
				celdaMonto.setCellStyle(estilo8);
				celdaMonto = fila.createCell((short)5);
				celdaMonto.setCellValue(Double.parseDouble(saldoCarteraCreVencida));
				celdaMonto.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(9);
				HSSFCell celdaTotalCredVen=fila.createCell((short)9);
				celdaTotalCredVen = fila.createCell((short)1);
				celdaTotalCredVen.setCellValue("Saldo Total de la Cartera de Crédito Vencida");
				celdaTotalCredVen.setCellStyle(estilo8);
				celdaTotalCredVen = fila.createCell((short)2);
				celdaTotalCredVen.setCellValue(Double.parseDouble(saldoCarteraCreVen));
				celdaTotalCredVen.setCellStyle(estiloFormatoDecimal);
				celdaMonto = fila.createCell((short)4);
				celdaMonto.setCellValue("Saldo Total de la Cartera de Crédito");
				celdaMonto.setCellStyle(estilo8);
				celdaTotalCredVen = fila.createCell((short)5);
				celdaTotalCredVen.setCellValue(Double.parseDouble(saldoCarteraCredito));
				celdaTotalCredVen.setCellStyle(estiloFormatoDecimal);
				

				fila = hoja.createRow(11);
				HSSFCell celdaResPorcentual=fila.createCell((short)11);
				celdaResPorcentual = fila.createCell((short)1);
				celdaResPorcentual.setCellValue("Resultado Porcentual");
				celdaResPorcentual.setCellStyle(estilo8);
				celdaResPorcentual = fila.createCell((short)2);
				celdaResPorcentual.setCellValue(Double.parseDouble(resultadoPorcentual));
				celdaResPorcentual.setCellStyle(estiloFormatoDecimal);
				celdaResPorcentual = fila.createCell((short)3);
				celdaResPorcentual.setCellValue("%");
				celdaResPorcentual.setCellStyle(estilo8);
				celdaResPorcentual = fila.createCell((short)4);
				celdaResPorcentual.setCellValue("Resultado Porcentual");
				celdaResPorcentual.setCellStyle(estilo8);
				celdaResPorcentual = fila.createCell((short)5);
				celdaResPorcentual.setCellValue(Double.parseDouble(resultadoPorcCar));
				celdaResPorcentual.setCellStyle(estiloFormatoDecimal);
				celdaResPorcentual = fila.createCell((short)6);
				celdaResPorcentual.setCellValue("%");
				celdaResPorcentual.setCellStyle(estilo8);
				
				fila = hoja.createRow(13);
				HSSFCell celdaParamPorcentaje=fila.createCell((short)13);
				celdaParamPorcentaje = fila.createCell((short)1);
				celdaParamPorcentaje.setCellValue("Parámetro de Porcentaje");
				celdaParamPorcentaje.setCellStyle(estilo8);
				celdaParamPorcentaje = fila.createCell((short)2);
				celdaParamPorcentaje.setCellValue(Double.parseDouble(parametroPorcentaje));
				celdaParamPorcentaje.setCellStyle(estiloFormatoDecimal);
				celdaParamPorcentaje = fila.createCell((short)3);
				celdaParamPorcentaje.setCellValue("%");
				celdaParamPorcentaje.setCellStyle(estilo8);
				celdaParamPorcentaje = fila.createCell((short)4);
				celdaParamPorcentaje.setCellValue("Parámetro de Porcentaje");
				celdaParamPorcentaje.setCellStyle(estilo8);
				celdaParamPorcentaje = fila.createCell((short)5);
				celdaParamPorcentaje.setCellValue(Double.parseDouble(parametroPorcCar));
				celdaParamPorcentaje.setCellStyle(estiloFormatoDecimal);
				celdaParamPorcentaje = fila.createCell((short)6);
				celdaParamPorcentaje.setCellValue("%");
				celdaParamPorcentaje.setCellStyle(estilo8);
				
				fila = hoja.createRow(15);
				HSSFCell celdaDiferencia=fila.createCell((short)15);
				celdaDiferencia = fila.createCell((short)1);
				celdaDiferencia.setCellValue("Diferencia al Límite Establecido");
				celdaDiferencia.setCellStyle(estilo8);
				celdaDiferencia = fila.createCell((short)2);
				celdaDiferencia.setCellValue(Double.parseDouble(difLimiteEstablecido));
				celdaDiferencia.setCellStyle(estiloFormatoDecimal);
				celdaDiferencia = fila.createCell((short)3);
				celdaDiferencia.setCellValue("%");
				celdaDiferencia.setCellStyle(estilo8);
				celdaDiferencia = fila.createCell((short)4);
				celdaDiferencia.setCellValue("Diferencia al Límite Establecido");
				celdaDiferencia.setCellStyle(estilo8);
				celdaDiferencia = fila.createCell((short)5);
				celdaDiferencia.setCellValue(Double.parseDouble(difLimiteEstabCar));
				celdaDiferencia.setCellStyle(estiloFormatoDecimal);
				celdaDiferencia = fila.createCell((short)6);
				celdaDiferencia.setCellValue("%");
				celdaDiferencia.setCellStyle(estilo8);
				
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

	public CarteraVencidaServicio getCarteraVencidaServicio() {
		return carteraVencidaServicio;
	}

	public void setCarteraVencidaServicio(
			CarteraVencidaServicio carteraVencidaServicio) {
		this.carteraVencidaServicio = carteraVencidaServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
