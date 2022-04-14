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
import riesgos.servicio.CreditosZonaGeograficaServicio;

public class CreditosZonaGeograficaRepControlador extends AbstractCommandController{
	CreditosZonaGeograficaServicio creditosZonaGeograficaServicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporteExcel= 1;
	}
	public CreditosZonaGeograficaRepControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("zonaGeografica");
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
					reporteCredZonaGeografica(tipoReporte,riesgosBean,response);
				break;
			}
			return null;
		}
	// Reporte de Créditos por Zona Geográfica
	public List reporteCredZonaGeografica(int tipoReporte,UACIRiesgosBean riesgosBean,  HttpServletResponse response){
		List listaRepote=null;
		String nombreArchivo = "";
		nombreArchivo = "Créditos por Zona Geográfica"; 
		listaRepote = creditosZonaGeograficaServicio.listaReporteCredZonaGeo(tipoReporte, riesgosBean, response); 
		
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
			HSSFSheet hoja = libro.createSheet("Créditos por Zona Geográfica");
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
				celdaRep.setCellValue("REPORTE CRÉDITOS POR ZONA GEOGRÁFICA: "+riesgosBean.getFechaOperacion());
				celdaRep.setCellStyle(estiloDatosCentrado);
				
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));
				
				//Inicialización de variables
				String montoCarteraZona 	= "";
				String carteraPuebla		= "";
				String carteraOaxaca		= "";
				String carteraVeracruz		= "";
				String saldoCarteraCredito	= "";
				
				String porcentualPuebla		= "";
				String porcentualOaxaca		= "";
				String porcentualVeracruz	= "";
				String porcentajePuebla		= "";
				String porcentajeOaxaca		= "";
				
				String porcentajeVeracruz	= "";
				String limitePuebla			= "";
				String limiteOaxaca			= "";
				String limiteVeracruz		= "";
				
				String saldoCarteraZona 	= "";
				String carteraPue			= "";
				String carteraOax			= "";
				String carteraVer			= "";
				String saldoTotalCartera	= "";
				
				String porcentualPue		= "";
				String porcentualOax		= "";
				String porcentualVer		= "";
				String porcentajePue		= "";
				String porcentajeOax		= "";
				
				String porcentajeVer		= "";
				String limitePue			= "";
				String limiteOax			= "";
				String limiteVer			= "";
				
				
				int itera=0;
				UACIRiesgosBean riesgos = null;
				if(!listaRepote.isEmpty()){
				for( itera=0; itera<1; itera ++){
					riesgos = (UACIRiesgosBean) listaRepote.get(itera);
					montoCarteraZona 	= riesgos.getMontoCarteraZona();
					carteraPuebla 		= riesgos.getCarteraPuebla();
					carteraOaxaca	 	= riesgos.getCarteraOaxaca();
					carteraVeracruz 	= riesgos.getCarteraVeracruz();
					saldoCarteraCredito = riesgos.getSaldoCarteraCredito();
					
					porcentualPuebla	= riesgos.getPorcentualPuebla();
					porcentualOaxaca	= riesgos.getPorcentualOaxaca();
					porcentualVeracruz	= riesgos.getPorcentualVeracruz();
					porcentajePuebla	= riesgos.getPorcentajePuebla();
					porcentajeOaxaca	= riesgos.getPorcentajeOaxaca();
					
					porcentajeVeracruz	= riesgos.getPorcentajeVeracruz();
					limitePuebla		= riesgos.getLimitePuebla();
					limiteOaxaca		= riesgos.getLimiteOaxaca();
					limiteVeracruz		= riesgos.getLimiteVeracruz();
					
					saldoCarteraZona 	= riesgos.getSaldoCarteraZona();
					carteraPue 			= riesgos.getCarteraPue();
					carteraOax	 		= riesgos.getCarteraOax();
					carteraVer 			= riesgos.getCarteraVer();
					saldoTotalCartera 	= riesgos.getSaldoTotalCartera();
					
					porcentualPue		= riesgos.getPorcentualPue();
					porcentualOax		= riesgos.getPorcentualOax();
					porcentualVer		= riesgos.getPorcentualVer();
					porcentajePue		= riesgos.getPorcentajePue();
					porcentajeOax		= riesgos.getPorcentajeOax();
					
					porcentajeVer		= riesgos.getPorcentajeVer();
					limitePue			= riesgos.getLimitePue();
					limiteOax			= riesgos.getLimiteOax();
					limiteVer			= riesgos.getLimiteVer();
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
				celdaMonto.setCellValue("Monto de Cartera por Zona Geográfica");
				celdaMonto.setCellStyle(estilo8);
				celdaMonto = fila.createCell((short)2);
				celdaMonto.setCellValue(Double.parseDouble(montoCarteraZona));
				celdaMonto.setCellStyle(estiloFormatoDecimal);
				celdaMonto = fila.createCell((short)4);
				celdaMonto.setCellValue("Saldo de Cartera por Zona Geográfica");
				celdaMonto.setCellStyle(estilo8);
				celdaMonto = fila.createCell((short)5);
				celdaMonto.setCellValue(Double.parseDouble(saldoCarteraZona));
				celdaMonto.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(8);
				HSSFCell celdaMontoPuebla=fila.createCell((short)8);
				celdaMontoPuebla = fila.createCell((short)1);
				celdaMontoPuebla.setCellValue("Puebla");
				celdaMontoPuebla.setCellStyle(estilo8);
				celdaMontoPuebla = fila.createCell((short)2);
				celdaMontoPuebla.setCellValue(Double.parseDouble(carteraPuebla));
				celdaMontoPuebla.setCellStyle(estiloFormatoDecimal);
				celdaMontoPuebla = fila.createCell((short)4);
				celdaMontoPuebla.setCellValue("Puebla");
				celdaMontoPuebla.setCellStyle(estilo8);
				celdaMontoPuebla = fila.createCell((short)5);
				celdaMontoPuebla.setCellValue(Double.parseDouble(carteraPue));
				celdaMontoPuebla.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(9);
				HSSFCell celdaMontoOaxaca=fila.createCell((short)9);
				celdaMontoOaxaca = fila.createCell((short)1);
				celdaMontoOaxaca.setCellValue("Oaxaca");
				celdaMontoOaxaca.setCellStyle(estilo8);
				celdaMontoOaxaca = fila.createCell((short)2);
				celdaMontoOaxaca.setCellValue(Double.parseDouble(carteraOaxaca));
				celdaMontoOaxaca.setCellStyle(estiloFormatoDecimal);
				celdaMontoOaxaca = fila.createCell((short)4);
				celdaMontoOaxaca.setCellValue("Oaxaca");
				celdaMontoOaxaca.setCellStyle(estilo8);
				celdaMontoOaxaca = fila.createCell((short)5);
				celdaMontoOaxaca.setCellValue(Double.parseDouble(carteraOax));
				celdaMontoOaxaca.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(10);
				HSSFCell celdaMontoVeracruz=fila.createCell((short)10);
				celdaMontoVeracruz = fila.createCell((short)1);
				celdaMontoVeracruz.setCellValue("Veracruz");
				celdaMontoVeracruz.setCellStyle(estilo8);
				celdaMontoVeracruz = fila.createCell((short)2);
				celdaMontoVeracruz.setCellValue(Double.parseDouble(carteraVeracruz));
				celdaMontoVeracruz.setCellStyle(estiloFormatoDecimal);
				celdaMontoVeracruz = fila.createCell((short)4);
				celdaMontoVeracruz.setCellValue("Veracruz");
				celdaMontoVeracruz.setCellStyle(estilo8);
				celdaMontoVeracruz = fila.createCell((short)5);
				celdaMontoVeracruz.setCellValue(Double.parseDouble(carteraVer));
				celdaMontoVeracruz.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(12);
				HSSFCell celdaTotCartera=fila.createCell((short)12);
				celdaTotCartera = fila.createCell((short)1);
				celdaTotCartera.setCellValue("Saldo Total de la Cartera de Crédito");
				celdaTotCartera.setCellStyle(estilo8);
				celdaTotCartera = fila.createCell((short)2);
				celdaTotCartera.setCellValue(Double.parseDouble(saldoCarteraCredito));
				celdaTotCartera.setCellStyle(estiloFormatoDecimal);
				celdaTotCartera = fila.createCell((short)4);
				celdaTotCartera.setCellValue("Saldo Total de la Cartera de Crédito");
				celdaTotCartera.setCellStyle(estilo8);
				celdaTotCartera = fila.createCell((short)5);
				celdaTotCartera.setCellValue(Double.parseDouble(saldoTotalCartera));
				celdaTotCartera.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(14);
				HSSFCell celdaResPorcentual=fila.createCell((short)14);
				celdaResPorcentual = fila.createCell((short)1);
				celdaResPorcentual.setCellValue("Resultado Porcentual");
				celdaResPorcentual.setCellStyle(estilo8);
				celdaResPorcentual = fila.createCell((short)4);
				celdaResPorcentual.setCellValue("Resultado Porcentual");
				celdaResPorcentual.setCellStyle(estilo8);
				
				fila = hoja.createRow(15);
				HSSFCell celdaResPorcPuebla=fila.createCell((short)15);
				celdaResPorcPuebla = fila.createCell((short)1);
				celdaResPorcPuebla.setCellValue("Puebla");
				celdaResPorcPuebla.setCellStyle(estilo8);
				celdaResPorcPuebla = fila.createCell((short)2);
				celdaResPorcPuebla.setCellValue(Double.parseDouble(porcentualPuebla));
				celdaResPorcPuebla.setCellStyle(estiloFormatoDecimal);
				celdaResPorcPuebla = fila.createCell((short)3);
				celdaResPorcPuebla.setCellValue("%");
				celdaResPorcPuebla.setCellStyle(estilo8);
				celdaResPorcPuebla = fila.createCell((short)4);
				celdaResPorcPuebla.setCellValue("Puebla");
				celdaResPorcPuebla.setCellStyle(estilo8);
				celdaResPorcPuebla = fila.createCell((short)5);
				celdaResPorcPuebla.setCellValue(Double.parseDouble(porcentualPue));
				celdaResPorcPuebla.setCellStyle(estiloFormatoDecimal);
				celdaResPorcPuebla = fila.createCell((short)6);
				celdaResPorcPuebla.setCellValue("%");
				celdaResPorcPuebla.setCellStyle(estilo8);
				
				fila = hoja.createRow(16);
				HSSFCell celdaResPorcOaxaca=fila.createCell((short)16);
				celdaResPorcOaxaca = fila.createCell((short)1);
				celdaResPorcOaxaca.setCellValue("Oaxaca");
				celdaResPorcOaxaca.setCellStyle(estilo8);
				celdaResPorcOaxaca = fila.createCell((short)2);
				celdaResPorcOaxaca.setCellValue(Double.parseDouble(porcentualOaxaca));
				celdaResPorcOaxaca.setCellStyle(estiloFormatoDecimal);
				celdaResPorcOaxaca = fila.createCell((short)3);
				celdaResPorcOaxaca.setCellValue("%");
				celdaResPorcOaxaca.setCellStyle(estilo8);
				celdaResPorcOaxaca = fila.createCell((short)4);
				celdaResPorcOaxaca.setCellValue("Oaxaca");
				celdaResPorcOaxaca.setCellStyle(estilo8);
				celdaResPorcOaxaca = fila.createCell((short)5);
				celdaResPorcOaxaca.setCellValue(Double.parseDouble(porcentualOax));
				celdaResPorcOaxaca.setCellStyle(estiloFormatoDecimal);
				celdaResPorcOaxaca = fila.createCell((short)6);
				celdaResPorcOaxaca.setCellValue("%");
				celdaResPorcOaxaca.setCellStyle(estilo8);
				
				
				fila = hoja.createRow(17);
				HSSFCell celdaResPorcVeracuz=fila.createCell((short)17);
				celdaResPorcVeracuz = fila.createCell((short)1);
				celdaResPorcVeracuz.setCellValue("Veracruz");
				celdaResPorcVeracuz.setCellStyle(estilo8);
				celdaResPorcVeracuz = fila.createCell((short)2);
				celdaResPorcVeracuz.setCellValue(Double.parseDouble(porcentualVeracruz));
				celdaResPorcVeracuz.setCellStyle(estiloFormatoDecimal);
				celdaResPorcVeracuz = fila.createCell((short)3);
				celdaResPorcVeracuz.setCellValue("%");
				celdaResPorcVeracuz.setCellStyle(estilo8);
				celdaResPorcVeracuz = fila.createCell((short)4);
				celdaResPorcVeracuz.setCellValue("Veracruz");
				celdaResPorcVeracuz.setCellStyle(estilo8);
				celdaResPorcVeracuz = fila.createCell((short)5);
				celdaResPorcVeracuz.setCellValue(Double.parseDouble(porcentualVer));
				celdaResPorcVeracuz.setCellStyle(estiloFormatoDecimal);
				celdaResPorcVeracuz = fila.createCell((short)6);
				celdaResPorcVeracuz.setCellValue("%");
				celdaResPorcVeracuz.setCellStyle(estilo8);
				
				fila = hoja.createRow(19);
				HSSFCell celdaParamPorcentaje=fila.createCell((short)19);
				celdaParamPorcentaje = fila.createCell((short)1);
				celdaParamPorcentaje.setCellValue("Parámetro de Porcentaje");
				celdaParamPorcentaje.setCellStyle(estilo8);
				celdaParamPorcentaje = fila.createCell((short)4);
				celdaParamPorcentaje.setCellValue("Parámetro de Porcentaje");
				celdaParamPorcentaje.setCellStyle(estilo8);
				
				fila = hoja.createRow(20);
				HSSFCell celdaParamPuebla=fila.createCell((short)20);
				celdaParamPuebla = fila.createCell((short)1);
				celdaParamPuebla.setCellValue("Puebla");
				celdaParamPuebla.setCellStyle(estilo8);
				celdaParamPuebla = fila.createCell((short)2);
				celdaParamPuebla.setCellValue(Double.parseDouble(porcentajePuebla));
				celdaParamPuebla.setCellStyle(estiloFormatoDecimal);
				celdaParamPuebla = fila.createCell((short)3);
				celdaParamPuebla.setCellValue("%");
				celdaParamPuebla.setCellStyle(estilo8);
				celdaParamPuebla = fila.createCell((short)4);
				celdaParamPuebla.setCellValue("Puebla");
				celdaParamPuebla.setCellStyle(estilo8);
				celdaParamPuebla = fila.createCell((short)5);
				celdaParamPuebla.setCellValue(Double.parseDouble(porcentajePue));
				celdaParamPuebla.setCellStyle(estiloFormatoDecimal);
				celdaParamPuebla = fila.createCell((short)6);
				celdaParamPuebla.setCellValue("%");
				celdaParamPuebla.setCellStyle(estilo8);
				
				fila = hoja.createRow(21);
				HSSFCell celdaParamOaxaca=fila.createCell((short)21);
				celdaParamOaxaca = fila.createCell((short)1);
				celdaParamOaxaca.setCellValue("Oaxaca");
				celdaParamOaxaca.setCellStyle(estilo8);
				celdaParamOaxaca = fila.createCell((short)2);
				celdaParamOaxaca.setCellValue(Double.parseDouble(porcentajeOaxaca));
				celdaParamOaxaca.setCellStyle(estiloFormatoDecimal);
				celdaParamOaxaca = fila.createCell((short)3);
				celdaParamOaxaca.setCellValue("%");
				celdaParamOaxaca.setCellStyle(estilo8);
				celdaParamOaxaca = fila.createCell((short)4);
				celdaParamOaxaca.setCellValue("Oaxaca");
				celdaParamOaxaca.setCellStyle(estilo8);
				celdaParamOaxaca = fila.createCell((short)5);
				celdaParamOaxaca.setCellValue(Double.parseDouble(porcentajeOax));
				celdaParamOaxaca.setCellStyle(estiloFormatoDecimal);
				celdaParamOaxaca = fila.createCell((short)6);
				celdaParamOaxaca.setCellValue("%");
				celdaParamOaxaca.setCellStyle(estilo8);
				
				fila = hoja.createRow(22);
				HSSFCell celdaParamVeracruz=fila.createCell((short)22);
				celdaParamVeracruz = fila.createCell((short)1);
				celdaParamVeracruz.setCellValue("Veracruz");
				celdaParamVeracruz.setCellStyle(estilo8);
				celdaParamVeracruz = fila.createCell((short)2);
				celdaParamVeracruz.setCellValue(Double.parseDouble(porcentajeVeracruz));
				celdaParamVeracruz.setCellStyle(estiloFormatoDecimal);
				celdaParamVeracruz = fila.createCell((short)3);
				celdaParamVeracruz.setCellValue("%");
				celdaParamVeracruz.setCellStyle(estilo8);
				celdaParamVeracruz = fila.createCell((short)4);
				celdaParamVeracruz.setCellValue("Veracruz");
				celdaParamVeracruz.setCellStyle(estilo8);
				celdaParamVeracruz = fila.createCell((short)5);
				celdaParamVeracruz.setCellValue(Double.parseDouble(porcentajeVer));
				celdaParamVeracruz.setCellStyle(estiloFormatoDecimal);
				celdaParamVeracruz = fila.createCell((short)6);
				celdaParamVeracruz.setCellValue("%");
				celdaParamVeracruz.setCellStyle(estilo8);
				
				
				fila = hoja.createRow(24);
				HSSFCell celdaDiferencia=fila.createCell((short)24);
				celdaDiferencia = fila.createCell((short)1);
				celdaDiferencia.setCellValue("Diferencia al Límite Establecido");
				celdaDiferencia.setCellStyle(estilo8);
				celdaDiferencia = fila.createCell((short)4);
				celdaDiferencia.setCellValue("Diferencia al Límite Establecido");
				celdaDiferencia.setCellStyle(estilo8);
				
				fila = hoja.createRow(25);
				HSSFCell celdaDifPuebla=fila.createCell((short)25);
				celdaDifPuebla = fila.createCell((short)1);
				celdaDifPuebla.setCellValue("Puebla");
				celdaDifPuebla.setCellStyle(estilo8);
				celdaDifPuebla = fila.createCell((short)2);
				celdaDifPuebla.setCellValue(Double.parseDouble(limitePuebla));
				celdaDifPuebla.setCellStyle(estiloFormatoDecimal);
				celdaDifPuebla = fila.createCell((short)3);
				celdaDifPuebla.setCellValue("%");
				celdaDifPuebla.setCellStyle(estilo8);
				celdaDifPuebla = fila.createCell((short)4);
				celdaDifPuebla.setCellValue("Puebla");
				celdaDifPuebla.setCellStyle(estilo8);
				celdaDifPuebla = fila.createCell((short)5);
				celdaDifPuebla.setCellValue(Double.parseDouble(limitePue));
				celdaDifPuebla.setCellStyle(estiloFormatoDecimal);
				celdaDifPuebla = fila.createCell((short)6);
				celdaDifPuebla.setCellValue("%");
				celdaDifPuebla.setCellStyle(estilo8);
				
				fila = hoja.createRow(26);
				HSSFCell celdaDifOaxaca=fila.createCell((short)26);
				celdaDifOaxaca = fila.createCell((short)1);
				celdaDifOaxaca.setCellValue("Oaxaca");
				celdaDifOaxaca.setCellStyle(estilo8);
				celdaDifOaxaca = fila.createCell((short)2);
				celdaDifOaxaca.setCellValue(Double.parseDouble(limiteOaxaca));
				celdaDifOaxaca.setCellStyle(estiloFormatoDecimal);
				celdaDifOaxaca = fila.createCell((short)3);
				celdaDifOaxaca.setCellValue("%");
				celdaDifOaxaca.setCellStyle(estilo8);
				celdaDifOaxaca = fila.createCell((short)4);
				celdaDifOaxaca.setCellValue("Oaxaca");
				celdaDifOaxaca.setCellStyle(estilo8);
				celdaDifOaxaca = fila.createCell((short)5);
				celdaDifOaxaca.setCellValue(Double.parseDouble(limiteOax));
				celdaDifOaxaca.setCellStyle(estiloFormatoDecimal);
				celdaDifOaxaca = fila.createCell((short)6);
				celdaDifOaxaca.setCellValue("%");
				celdaDifOaxaca.setCellStyle(estilo8);
				
				fila = hoja.createRow(27);
				HSSFCell celdaDifVeracruz=fila.createCell((short)27);
				celdaDifVeracruz = fila.createCell((short)1);
				celdaDifVeracruz.setCellValue("Veracruz");
				celdaDifVeracruz.setCellStyle(estilo8);
				celdaDifVeracruz = fila.createCell((short)2);
				celdaDifVeracruz.setCellValue(Double.parseDouble(limiteVeracruz));
				celdaDifVeracruz.setCellStyle(estiloFormatoDecimal);
				celdaDifVeracruz = fila.createCell((short)3);
				celdaDifVeracruz.setCellValue("%");
				celdaDifVeracruz.setCellStyle(estilo8);
				celdaDifVeracruz = fila.createCell((short)4);
				celdaDifVeracruz.setCellValue("Veracruz");
				celdaDifVeracruz.setCellStyle(estilo8);
				celdaDifVeracruz = fila.createCell((short)5);
				celdaDifVeracruz.setCellValue(Double.parseDouble(limiteVer));
				celdaDifVeracruz.setCellStyle(estiloFormatoDecimal);
				celdaDifVeracruz = fila.createCell((short)6);
				celdaDifVeracruz.setCellValue("%");
				celdaDifVeracruz.setCellStyle(estilo8);
				
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
	public CreditosZonaGeograficaServicio getCreditosZonaGeograficaServicio() {
		return creditosZonaGeograficaServicio;
	}
	public void setCreditosZonaGeograficaServicio(
			CreditosZonaGeograficaServicio creditosZonaGeograficaServicio) {
		this.creditosZonaGeograficaServicio = creditosZonaGeograficaServicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
