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
import riesgos.servicio.CreditosClasificacionServicio;

public class CreditosClasificacionRepControlador extends AbstractCommandController {
	CreditosClasificacionServicio creditosClasificacionServicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporteExcel= 1;
	}
	public CreditosClasificacionRepControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("creditosClasificacion");
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
					reporteCreditosConsumo(tipoReporte,riesgosBean,response);
				break;
			}
			return null;
		}
	// Reporte de Créditos por Clasificación
	public List reporteCreditosConsumo(int tipoReporte,UACIRiesgosBean riesgosBean,  HttpServletResponse response){
		List listaRepote=null;
		String nombreArchivo = "";
		nombreArchivo = "Créditos por Clasificación"; 
		listaRepote = creditosClasificacionServicio.listaReporteCredConsumo(tipoReporte, riesgosBean, response); 
		
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
			
			//Estilo Formato decimal (0.0000)
			HSSFCellStyle estiloFormatoDecimal4 = libro.createCellStyle();
			HSSFDataFormat formato4 = libro.createDataFormat();
			estiloFormatoDecimal4.setDataFormat(formato4.getFormat("#,##0.0000"));
			estiloFormatoDecimal4.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Créditos por Clasificación");
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
				celdaRep.setCellValue("REPORTE CRÉDITOS POR CLASIFICACIÓN: "+riesgosBean.getFechaOperacion());
				celdaRep.setCellStyle(estiloDatosCentrado);
				
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));
				
				//Inicialización de variables
				String montoCarteraCredito 	= "";
				String montoCreditoConsumo	= "";
				String montoCreditoComerc	= "";
				String montoCreditoVivienda	= "";
				String saldoCarteraCredito	= "";
				
				String porcentualConsumo	= "";
				String porcentualComercial	= "";
				String porcentualVivienda	= "";
				String porcentajeConsumo	= "";
				String porcentajeComercial	= "";
				
				String porcentajeVivienda	= "";
				String limiteConsumo		= "";
				String limiteComercial		= "";
				String limiteVivienda		= "";
				
				String saldoCartera 		= "";
				String credConsumo			= "";
				String credComercial		= "";
				String credVivienda			= "";
				String saldoTotalCartera	= "";
				
				String porcentConsumo		= "";
				String porcentComercial		= "";
				String porcentVivienda		= "";
				String porcConsumo			= "";
				String porcComercial		= "";
				
				String porcVivienda			= "";
				String diferenciaConsumo	= "";
				String diferenciaComercial	= "";
				String diferenciaVivienda	= "";
				
				int itera=0;
				UACIRiesgosBean riesgos = null;
				if(!listaRepote.isEmpty()){
				for( itera=0; itera<1; itera ++){
					riesgos = (UACIRiesgosBean) listaRepote.get(itera);
					montoCarteraCredito = riesgos.getMontoCarteraAnterior();
					montoCreditoConsumo = riesgos.getCreditoConsumo();
					montoCreditoComerc = riesgos.getCreditoComercial();
					montoCreditoVivienda = riesgos.getCreditoVivienda();
					saldoCarteraCredito = riesgos.getSaldoCarteraCredito();
					
					porcentualConsumo	= riesgos.getPorcentualConsumo();
					porcentualComercial	= riesgos.getPorcentualComercial();
					porcentualVivienda	= riesgos.getPorcentualVivienda();
					porcentajeConsumo	= riesgos.getPorcentajeConsumo();
					porcentajeComercial	= riesgos.getPorcentajeComercial();
					
					porcentajeVivienda	= riesgos.getPorcentajeVivienda();
					limiteConsumo		= riesgos.getLimiteConsumo();
					limiteComercial		= riesgos.getLimiteComercial();
					limiteVivienda		= riesgos.getLimiteVivienda();
					
					saldoCartera 		= riesgos.getSaldoCartera();
					credConsumo 		= riesgos.getCredConsumo();
					credComercial	 	= riesgos.getCredComercial();
					credVivienda 		= riesgos.getCredVivienda();
					saldoTotalCartera 	= riesgos.getSaldoTotalCartera();
					
					porcentConsumo		= riesgos.getPorcentConsumo();
					porcentComercial	= riesgos.getPorcentComercial();
					porcentVivienda		= riesgos.getPorcentVivienda();
					porcConsumo			= riesgos.getPorcConsumo();
					porcComercial		= riesgos.getPorcComercial();
					
					porcVivienda		= riesgos.getPorcVivienda();
					diferenciaConsumo	= riesgos.getDiferenciaConsumo();
					diferenciaComercial	= riesgos.getDiferenciaComercial();
					diferenciaVivienda	= riesgos.getDiferenciaVivienda();
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
				celdaMonto.setCellValue("Monto de Cartera por Clasificación");
				celdaMonto.setCellStyle(estilo8);
				celdaMonto = fila.createCell((short)2);
				celdaMonto.setCellValue(Double.parseDouble(montoCarteraCredito));
				celdaMonto.setCellStyle(estiloFormatoDecimal);
				celdaMonto = fila.createCell((short)4);
				celdaMonto.setCellValue("Saldo de Cartera por Clasificación");
				celdaMonto.setCellStyle(estilo8);
				celdaMonto = fila.createCell((short)5);
				celdaMonto.setCellValue(Double.parseDouble(saldoCartera));
				celdaMonto.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(8);
				HSSFCell celdaMontoConsumo=fila.createCell((short)8);
				celdaMontoConsumo = fila.createCell((short)1);
				celdaMontoConsumo.setCellValue("Consumo");
				celdaMontoConsumo.setCellStyle(estilo8);
				celdaMontoConsumo = fila.createCell((short)2);
				celdaMontoConsumo.setCellValue(Double.parseDouble(montoCreditoConsumo));
				celdaMontoConsumo.setCellStyle(estiloFormatoDecimal);
				celdaMontoConsumo = fila.createCell((short)4);
				celdaMontoConsumo.setCellValue("Consumo");
				celdaMontoConsumo.setCellStyle(estilo8);
				celdaMontoConsumo = fila.createCell((short)5);
				celdaMontoConsumo.setCellValue(Double.parseDouble(credConsumo));
				celdaMontoConsumo.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(9);
				HSSFCell celdaMontoComercial=fila.createCell((short)9);
				celdaMontoComercial = fila.createCell((short)1);
				celdaMontoComercial.setCellValue("Comercial");
				celdaMontoComercial.setCellStyle(estilo8);
				celdaMontoComercial = fila.createCell((short)2);
				celdaMontoComercial.setCellValue(Double.parseDouble(montoCreditoComerc));
				celdaMontoComercial.setCellStyle(estiloFormatoDecimal);
				celdaMontoComercial = fila.createCell((short)4);
				celdaMontoComercial.setCellValue("Comercial");
				celdaMontoComercial.setCellStyle(estilo8);
				celdaMontoComercial = fila.createCell((short)5);
				celdaMontoComercial.setCellValue(Double.parseDouble(credComercial));
				celdaMontoComercial.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(10);
				HSSFCell celdaMontoVivienda=fila.createCell((short)10);
				celdaMontoVivienda = fila.createCell((short)1);
				celdaMontoVivienda.setCellValue("Vivienda");
				celdaMontoVivienda.setCellStyle(estilo8);
				celdaMontoVivienda = fila.createCell((short)2);
				celdaMontoVivienda.setCellValue(Double.parseDouble(montoCreditoVivienda));
				celdaMontoVivienda.setCellStyle(estiloFormatoDecimal);
				celdaMontoVivienda = fila.createCell((short)4);
				celdaMontoVivienda.setCellValue("Vivienda");
				celdaMontoVivienda.setCellStyle(estilo8);
				celdaMontoVivienda = fila.createCell((short)5);
				celdaMontoVivienda.setCellValue(Double.parseDouble(credVivienda));
				celdaMontoVivienda.setCellStyle(estiloFormatoDecimal);
				
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
				HSSFCell celdaResPorcConsumo=fila.createCell((short)15);
				celdaResPorcConsumo = fila.createCell((short)1);
				celdaResPorcConsumo.setCellValue("Consumo");
				celdaResPorcConsumo.setCellStyle(estilo8);
				celdaResPorcConsumo = fila.createCell((short)2);
				celdaResPorcConsumo.setCellValue(Double.parseDouble(porcentualConsumo));
				celdaResPorcConsumo.setCellStyle(estiloFormatoDecimal4);
				celdaResPorcConsumo = fila.createCell((short)3);
				celdaResPorcConsumo.setCellValue("%");
				celdaResPorcConsumo.setCellStyle(estilo8);
				celdaResPorcConsumo = fila.createCell((short)4);
				celdaResPorcConsumo.setCellValue("Consumo");
				celdaResPorcConsumo.setCellStyle(estilo8);
				celdaResPorcConsumo = fila.createCell((short)5);
				celdaResPorcConsumo.setCellValue(Double.parseDouble(porcentConsumo));
				celdaResPorcConsumo.setCellStyle(estiloFormatoDecimal4);
				celdaResPorcConsumo = fila.createCell((short)6);
				celdaResPorcConsumo.setCellValue("%");
				celdaResPorcConsumo.setCellStyle(estilo8);
				
				fila = hoja.createRow(16);
				HSSFCell celdaResPorcComercial=fila.createCell((short)16);
				celdaResPorcComercial = fila.createCell((short)1);
				celdaResPorcComercial.setCellValue("Comercial");
				celdaResPorcComercial.setCellStyle(estilo8);
				celdaResPorcComercial = fila.createCell((short)2);
				celdaResPorcComercial.setCellValue(Double.parseDouble(porcentualComercial));
				celdaResPorcComercial.setCellStyle(estiloFormatoDecimal4);
				celdaResPorcComercial = fila.createCell((short)3);
				celdaResPorcComercial.setCellValue("%");
				celdaResPorcComercial.setCellStyle(estilo8);
				celdaResPorcComercial = fila.createCell((short)4);
				celdaResPorcComercial.setCellValue("Comercial");
				celdaResPorcComercial.setCellStyle(estilo8);
				celdaResPorcComercial = fila.createCell((short)5);
				celdaResPorcComercial.setCellValue(Double.parseDouble(porcentComercial));
				celdaResPorcComercial.setCellStyle(estiloFormatoDecimal4);
				celdaResPorcComercial = fila.createCell((short)6);
				celdaResPorcComercial.setCellValue("%");
				celdaResPorcComercial.setCellStyle(estilo8);
				
				fila = hoja.createRow(17);
				HSSFCell celdaResPorcVivienda=fila.createCell((short)17);
				celdaResPorcVivienda = fila.createCell((short)1);
				celdaResPorcVivienda.setCellValue("Vivienda");
				celdaResPorcVivienda.setCellStyle(estilo8);
				celdaResPorcVivienda = fila.createCell((short)2);
				celdaResPorcVivienda.setCellValue(Double.parseDouble(porcentualVivienda));
				celdaResPorcVivienda.setCellStyle(estiloFormatoDecimal4);
				celdaResPorcVivienda = fila.createCell((short)3);
				celdaResPorcVivienda.setCellValue("%");
				celdaResPorcVivienda.setCellStyle(estilo8);
				celdaResPorcVivienda = fila.createCell((short)4);
				celdaResPorcVivienda.setCellValue("Vivienda");
				celdaResPorcVivienda.setCellStyle(estilo8);
				celdaResPorcVivienda = fila.createCell((short)5);
				celdaResPorcVivienda.setCellValue(Double.parseDouble(porcentVivienda));
				celdaResPorcVivienda.setCellStyle(estiloFormatoDecimal4);
				celdaResPorcVivienda = fila.createCell((short)6);
				celdaResPorcVivienda.setCellValue("%");
				celdaResPorcVivienda.setCellStyle(estilo8);
				
				fila = hoja.createRow(19);
				HSSFCell celdaParamPorcentaje=fila.createCell((short)19);
				celdaParamPorcentaje = fila.createCell((short)1);
				celdaParamPorcentaje.setCellValue("Parámetro de Porcentaje");
				celdaParamPorcentaje.setCellStyle(estilo8);
				celdaParamPorcentaje = fila.createCell((short)4);
				celdaParamPorcentaje.setCellValue("Parámetro de Porcentaje");
				celdaParamPorcentaje.setCellStyle(estilo8);
				
				fila = hoja.createRow(20);
				HSSFCell celdaParamConsumo=fila.createCell((short)20);
				celdaParamConsumo = fila.createCell((short)1);
				celdaParamConsumo.setCellValue("Consumo");
				celdaParamConsumo.setCellStyle(estilo8);
				celdaParamConsumo = fila.createCell((short)2);
				celdaParamConsumo.setCellValue(Double.parseDouble(porcentajeConsumo));
				celdaParamConsumo.setCellStyle(estiloFormatoDecimal);
				celdaParamConsumo = fila.createCell((short)3);
				celdaParamConsumo.setCellValue("%");
				celdaParamConsumo.setCellStyle(estilo8);
				celdaParamConsumo = fila.createCell((short)4);
				celdaParamConsumo.setCellValue("Consumo");
				celdaParamConsumo.setCellStyle(estilo8);
				celdaParamConsumo = fila.createCell((short)5);
				celdaParamConsumo.setCellValue(Double.parseDouble(porcConsumo));
				celdaParamConsumo.setCellStyle(estiloFormatoDecimal);
				celdaParamConsumo = fila.createCell((short)6);
				celdaParamConsumo.setCellValue("%");
				celdaParamConsumo.setCellStyle(estilo8);
				
				
				fila = hoja.createRow(21);
				HSSFCell celdaParamComercial=fila.createCell((short)21);
				celdaParamComercial = fila.createCell((short)1);
				celdaParamComercial.setCellValue("Comercial");
				celdaParamComercial.setCellStyle(estilo8);
				celdaParamComercial = fila.createCell((short)2);
				celdaParamComercial.setCellValue(Double.parseDouble(porcentajeComercial));
				celdaParamComercial.setCellStyle(estiloFormatoDecimal);
				celdaParamComercial = fila.createCell((short)3);
				celdaParamComercial.setCellValue("%");
				celdaParamComercial.setCellStyle(estilo8);
				celdaParamComercial = fila.createCell((short)4);
				celdaParamComercial.setCellValue("Comercial");
				celdaParamComercial.setCellStyle(estilo8);
				celdaParamComercial = fila.createCell((short)5);
				celdaParamComercial.setCellValue(Double.parseDouble(porcComercial));
				celdaParamComercial.setCellStyle(estiloFormatoDecimal);
				celdaParamComercial = fila.createCell((short)6);
				celdaParamComercial.setCellValue("%");
				celdaParamComercial.setCellStyle(estilo8);
				
				fila = hoja.createRow(22);
				HSSFCell celdaParamVivienda=fila.createCell((short)22);
				celdaParamVivienda = fila.createCell((short)1);
				celdaParamVivienda.setCellValue("Vivienda");
				celdaParamVivienda.setCellStyle(estilo8);
				celdaParamVivienda = fila.createCell((short)2);
				celdaParamVivienda.setCellValue(Double.parseDouble(porcentajeVivienda));
				celdaParamVivienda.setCellStyle(estiloFormatoDecimal);
				celdaParamVivienda = fila.createCell((short)3);
				celdaParamVivienda.setCellValue("%");
				celdaParamVivienda.setCellStyle(estilo8);
				celdaParamVivienda = fila.createCell((short)4);
				celdaParamVivienda.setCellValue("Vivienda");
				celdaParamVivienda.setCellStyle(estilo8);
				celdaParamVivienda = fila.createCell((short)5);
				celdaParamVivienda.setCellValue(Double.parseDouble(porcVivienda));
				celdaParamVivienda.setCellStyle(estiloFormatoDecimal);
				celdaParamVivienda = fila.createCell((short)6);
				celdaParamVivienda.setCellValue("%");
				celdaParamVivienda.setCellStyle(estilo8);
				
				fila = hoja.createRow(24);
				HSSFCell celdaDiferencia=fila.createCell((short)24);
				celdaDiferencia = fila.createCell((short)1);
				celdaDiferencia.setCellValue("Diferencia al Límite Establecido");
				celdaDiferencia.setCellStyle(estilo8);
				celdaDiferencia = fila.createCell((short)4);
				celdaDiferencia.setCellValue("Diferencia al Límite Establecido");
				celdaDiferencia.setCellStyle(estilo8);
				
				fila = hoja.createRow(25);
				HSSFCell celdaDifConsumo=fila.createCell((short)25);
				celdaDifConsumo = fila.createCell((short)1);
				celdaDifConsumo.setCellValue("Consumo");
				celdaDifConsumo.setCellStyle(estilo8);
				celdaDifConsumo = fila.createCell((short)2);
				celdaDifConsumo.setCellValue(Double.parseDouble(limiteConsumo));
				celdaDifConsumo.setCellStyle(estiloFormatoDecimal4);
				celdaDifConsumo = fila.createCell((short)3);
				celdaDifConsumo.setCellValue("%");
				celdaDifConsumo.setCellStyle(estilo8);
				celdaDifConsumo = fila.createCell((short)4);
				celdaDifConsumo.setCellValue("Consumo");
				celdaDifConsumo.setCellStyle(estilo8);
				celdaDifConsumo = fila.createCell((short)5);
				celdaDifConsumo.setCellValue(Double.parseDouble(diferenciaConsumo));
				celdaDifConsumo.setCellStyle(estiloFormatoDecimal4);
				celdaDifConsumo = fila.createCell((short)6);
				celdaDifConsumo.setCellValue("%");
				celdaDifConsumo.setCellStyle(estilo8);
				
				fila = hoja.createRow(26);
				HSSFCell celdaDifComercial=fila.createCell((short)26);
				celdaDifComercial = fila.createCell((short)1);
				celdaDifComercial.setCellValue("Comercial");
				celdaDifComercial.setCellStyle(estilo8);
				celdaDifComercial = fila.createCell((short)2);
				celdaDifComercial.setCellValue(Double.parseDouble(limiteComercial));
				celdaDifComercial.setCellStyle(estiloFormatoDecimal4);
				celdaDifComercial = fila.createCell((short)3);
				celdaDifComercial.setCellValue("%");
				celdaDifComercial.setCellStyle(estilo8);
				celdaDifComercial = fila.createCell((short)4);
				celdaDifComercial.setCellValue("Comercial");
				celdaDifComercial.setCellStyle(estilo8);
				celdaDifComercial = fila.createCell((short)5);
				celdaDifComercial.setCellValue(Double.parseDouble(diferenciaComercial));
				celdaDifComercial.setCellStyle(estiloFormatoDecimal4);
				celdaDifComercial = fila.createCell((short)6);
				celdaDifComercial.setCellValue("%");
				celdaDifComercial.setCellStyle(estilo8);
				
				fila = hoja.createRow(27);
				HSSFCell celdaDifVivienda=fila.createCell((short)27);
				celdaDifVivienda = fila.createCell((short)1);
				celdaDifVivienda.setCellValue("Vivienda");
				celdaDifVivienda.setCellStyle(estilo8);
				celdaDifVivienda = fila.createCell((short)2);
				celdaDifVivienda.setCellValue(Double.parseDouble(limiteVivienda));
				celdaDifVivienda.setCellStyle(estiloFormatoDecimal4);
				celdaDifVivienda = fila.createCell((short)3);
				celdaDifVivienda.setCellValue("%");
				celdaDifVivienda.setCellStyle(estilo8);
				celdaDifVivienda = fila.createCell((short)4);
				celdaDifVivienda.setCellValue("Vivienda");
				celdaDifVivienda.setCellStyle(estilo8);
				celdaDifVivienda = fila.createCell((short)5);
				celdaDifVivienda.setCellValue(Double.parseDouble(diferenciaVivienda));
				celdaDifVivienda.setCellStyle(estiloFormatoDecimal4);
				celdaDifVivienda = fila.createCell((short)6);
				celdaDifVivienda.setCellValue("%");
				celdaDifVivienda.setCellStyle(estilo8);
				
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
	public CreditosClasificacionServicio getCreditosClasificacionServicio() {
		return creditosClasificacionServicio;
	}
	public void setCreditosClasificacionServicio(
			CreditosClasificacionServicio creditosClasificacionServicio) {
		this.creditosClasificacionServicio = creditosClasificacionServicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}
