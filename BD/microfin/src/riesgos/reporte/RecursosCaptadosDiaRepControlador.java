package riesgos.reporte;

import java.io.ByteArrayOutputStream;
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
import riesgos.servicio.RecursosCaptadosDiaServicio;

public class RecursosCaptadosDiaRepControlador extends AbstractCommandController{
	RecursosCaptadosDiaServicio recursosCaptadosDiaServicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporteExcel= 1;
	}
	public RecursosCaptadosDiaRepControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("recursosCaptadosDia");
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
					reporteRecursoCaptadosDia(tipoReporte,riesgosBean,response);
				break;
			}
			return null;
		}
		
	// Reporte de Recursos Captados al Día
	public List reporteRecursoCaptadosDia(int tipoReporte,UACIRiesgosBean riesgosBean,  HttpServletResponse response){
		List listaRepote=null;
		String nombreArchivo = "";
		nombreArchivo = "Recursos Captados Día "+riesgosBean.getFechaOperacion(); 
		listaRepote = recursosCaptadosDiaServicio.listaReporteCaptadosDia(tipoReporte, riesgosBean, response); 
			
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
			HSSFSheet hoja = libro.createSheet("Recursos Captados Día");
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
			            5  //ultima celda   (0-based)
			    ));	
			  
				fila = hoja.createRow(3);
				HSSFCell celdaRep=fila.createCell((short)1);
				celdaRep.setCellValue("REPORTE RECURSOS CAPTADOS AL DÍA: "+riesgosBean.getFechaOperacion());
				celdaRep.setCellStyle(estiloDatosCentrado);
				
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            5  //ultima celda   (0-based)
			    ));
				
				//Inicialización de variables
				String montoCaptadoDia		= "";
				String ahorroPlazo 			= "";
				String ahorroMenores 		= "";
				String ahorroOrdinario 		= "";
				String ahorroVista 			= "";
				
				String cuentaSinMov         = "";
				String depositoInversion 	= "";
				String montoPlazo30 		= "";
				String montoPlazo60 		= "";
				String montoPlazo90 		= "";
				
				String montoPlazo120 		= "";
				String montoPlazo180 		= "";
				String montoPlazo360 		= "";
				String montoInteresMensual  = "";
				String captacionTradicional = "";
				
				String carteraDiaAnterior 	= "";
				String carteraCredVigente 	= "";
				String carteraCredVencida 	= "";
				String totalCarteraCredito 	= "";
				String resultadoPorcentual 	= "";
				
				String parametroPorcentaje 	= "";
				String difLimiteEstablecido = "";
				String saldoCaptadoDia		= "";
				String salAhorroPlazo 		= "";
				String salAhorroMenores 	= "";
				
				String salAhorroOrdinario 	= "";
				String salAhorroVista 		= "";
				String salCuentaSinMov      = "";
				String saldDepInversion 	= "";
				String saldoPlazo30 		= "";
				
				String saldoPlazo60 		= "";
				String saldoPlazo90 		= "";
				String saldoPlazo120 		= "";
				String saldoPlazo180 		= "";
				String saldoPlazo360 		= "";
				
				String saldoInteresMensual  = "";
				String salCapTradicional	= "";
				String saldoCartera 		= "";
				String saldoCredVigente 	= "";
				String saldoCredVencida 	= "";
				
				String saldoTotalCartera 	= "";
				String saldoPorcentual 		= "";
				String saldoPorcentaje 		= "";
				String saldoDiferencia 		= "";
				
				int itera=0;
				UACIRiesgosBean riesgos = null;
				if(!listaRepote.isEmpty()){
				for( itera=0; itera<1; itera ++){
					riesgos = (UACIRiesgosBean) listaRepote.get(itera);
					montoCaptadoDia = riesgos.getMontoCaptadoDia();
					ahorroPlazo = riesgos.getAhorroPlazo();
					ahorroMenores = riesgos.getAhorroMenores();
					ahorroOrdinario = riesgos.getAhorroOrdinario();
					ahorroVista = riesgos.getAhorroVista();
					
					cuentaSinMov = riesgos.getCuentaSinMov();
					depositoInversion = riesgos.getDepositoInversion();
					montoPlazo30 = riesgos.getMontoPlazo30();
					montoPlazo60 = riesgos.getMontoPlazo60();
					montoPlazo90 = riesgos.getMontoPlazo90();
					
					montoPlazo120 = riesgos.getMontoPlazo120();
					montoPlazo180 = riesgos.getMontoPlazo180();
					montoPlazo360 = riesgos.getMontoPlazo360();
					montoInteresMensual = riesgos.getMontoInteresMensual();
					captacionTradicional = riesgos.getCaptacionTradicional();
					
					carteraDiaAnterior = riesgos.getCarteraDiaAnterior();
					carteraCredVigente = riesgos.getCarteraCredVigente();
					carteraCredVencida = riesgos.getCarteraCredVencida();
					totalCarteraCredito = riesgos.getTotalCarteraCredito();
					resultadoPorcentual = riesgos.getResultadoPorcentual();
					
					parametroPorcentaje = riesgos.getParametroPorcentaje();
					difLimiteEstablecido = riesgos.getDifLimiteEstablecido();
					saldoCaptadoDia		= riesgos.getSaldoCaptadoDia();
					salAhorroPlazo 		= riesgos.getSalAhorroPlazo();
					salAhorroMenores 	= riesgos.getSalAhorroMenores();
					
					salAhorroOrdinario 	= riesgos.getSalAhorroOrdinario();
					salAhorroVista 		= riesgos.getSalAhorroVista();
					salCuentaSinMov     = riesgos.getSalCuentaSinMov();
					saldDepInversion 	= riesgos.getSaldDepInversion();
					saldoPlazo30 		= riesgos.getSaldoPlazo30();
					
					saldoPlazo60 		= riesgos.getSaldoPlazo60();
					saldoPlazo90 		= riesgos.getSaldoPlazo90();
					saldoPlazo120 		= riesgos.getSaldoPlazo120();
					saldoPlazo180 		= riesgos.getSaldoPlazo180();
					saldoPlazo360 		= riesgos.getSaldoPlazo360();
					
					saldoInteresMensual = riesgos.getSaldoInteresMensual();
					salCapTradicional	= riesgos.getSalCapTradicional();
					saldoCartera 		= riesgos.getSaldoCartera();
					saldoCredVigente 	= riesgos.getSaldoCredVigente();
					saldoCredVencida 	= riesgos.getSaldoCredVencida();
					
					saldoTotalCartera 	= riesgos.getSaldoTotalCartera();
					saldoPorcentual 	= riesgos.getSaldoPorcentual();
					saldoPorcentaje 	= riesgos.getSaldoPorcentaje();
					saldoDiferencia 	= riesgos.getSaldoDiferencia();
					
				  }
				}

				fila = hoja.createRow(5);
				HSSFCell celda=fila.createCell((short)5);
				celda = fila.createCell((short)1);
				celda.setCellValue("Monto Captado Acumulado del Día de Ayer");
				celda.setCellStyle(estiloNegrita8);
				celda = fila.createCell((short)4);
				celda.setCellValue("Saldo Captado Acumulado al Día de Ayer");
				celda.setCellStyle(estiloNegrita8);
				
				fila = hoja.createRow(7);
				HSSFCell celdaMonto=fila.createCell((short)7);
				celdaMonto = fila.createCell((short)1);
				celdaMonto.setCellValue("Monto Captado");
				celdaMonto.setCellStyle(estilo8);
				celdaMonto = fila.createCell((short)2);
				celdaMonto.setCellValue(Double.parseDouble(montoCaptadoDia));
				celdaMonto.setCellStyle(estiloFormatoDecimal);
				celdaMonto = fila.createCell((short)4);
				celdaMonto.setCellValue("Saldo Captado");
				celdaMonto.setCellStyle(estilo8);
				celdaMonto = fila.createCell((short)5);
				celdaMonto.setCellValue(Double.parseDouble(saldoCaptadoDia));
				celdaMonto.setCellStyle(estiloFormatoDecimal);
				
				
				fila = hoja.createRow(9);
				HSSFCell celdaAhorroPlazo=fila.createCell((short)9);
				celdaAhorroPlazo = fila.createCell((short)1);
				celdaAhorroPlazo.setCellValue("Ahorro a Plazo");
				celdaAhorroPlazo.setCellStyle(estilo8);
				celdaAhorroPlazo = fila.createCell((short)2);
				celdaAhorroPlazo.setCellValue(Double.parseDouble(ahorroPlazo));
				celdaAhorroPlazo.setCellStyle(estiloFormatoDecimal);
				celdaAhorroPlazo = fila.createCell((short)4);
				celdaAhorroPlazo.setCellValue("Ahorro a Plazo");
				celdaAhorroPlazo.setCellStyle(estilo8);
				celdaAhorroPlazo = fila.createCell((short)5);
				celdaAhorroPlazo.setCellValue(Double.parseDouble(salAhorroPlazo));
				celdaAhorroPlazo.setCellStyle(estiloFormatoDecimal);
				
				
				fila = hoja.createRow(10);
				HSSFCell celdaAhorroMenor=fila.createCell((short)10);
				celdaAhorroMenor = fila.createCell((short)1);
				celdaAhorroMenor.setCellValue("Ahorro de Menores");
				celdaAhorroMenor.setCellStyle(estilo8);
				celdaAhorroMenor = fila.createCell((short)2);
				celdaAhorroMenor.setCellValue(Double.parseDouble(ahorroMenores));
				celdaAhorroMenor.setCellStyle(estiloFormatoDecimal);
				celdaAhorroMenor = fila.createCell((short)4);
				celdaAhorroMenor.setCellValue("Ahorro de Menores");
				celdaAhorroMenor.setCellStyle(estilo8);
				celdaAhorroMenor = fila.createCell((short)5);
				celdaAhorroMenor.setCellValue(Double.parseDouble(salAhorroMenores));
				celdaAhorroMenor.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(11);
				HSSFCell celdaAhorroOrd=fila.createCell((short)11);
				celdaAhorroOrd = fila.createCell((short)1);
				celdaAhorroOrd.setCellValue("Ahorro Ordinario");
				celdaAhorroOrd.setCellStyle(estilo8);
				celdaAhorroOrd = fila.createCell((short)2);
				celdaAhorroOrd.setCellValue(Double.parseDouble(ahorroOrdinario));
				celdaAhorroOrd.setCellStyle(estiloFormatoDecimal);
				celdaAhorroOrd = fila.createCell((short)4);
				celdaAhorroOrd.setCellValue("Ahorro Ordinario");
				celdaAhorroOrd.setCellStyle(estilo8);
				celdaAhorroOrd = fila.createCell((short)5);
				celdaAhorroOrd.setCellValue(Double.parseDouble(salAhorroOrdinario));
				celdaAhorroOrd.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(12);
				HSSFCell celdaAhorroVista=fila.createCell((short)12);
				celdaAhorroVista = fila.createCell((short)1);
				celdaAhorroVista.setCellValue("Ahorro Vista");
				celdaAhorroVista.setCellStyle(estilo8);
				celdaAhorroVista = fila.createCell((short)2);
				celdaAhorroVista.setCellValue(Double.parseDouble(ahorroVista));
				celdaAhorroVista.setCellStyle(estiloFormatoDecimal);
				celdaAhorroVista = fila.createCell((short)4);
				celdaAhorroVista.setCellValue("Ahorro Vista");
				celdaAhorroVista.setCellStyle(estilo8);
				celdaAhorroVista = fila.createCell((short)5);
				celdaAhorroVista.setCellValue(Double.parseDouble(salAhorroVista));
				celdaAhorroVista.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(13);
				HSSFCell celdaCtaSinMov=fila.createCell((short)13);
				celdaCtaSinMov = fila.createCell((short)1);
				celdaCtaSinMov.setCellValue("Cuentas sin Movimientos");
				celdaCtaSinMov.setCellStyle(estilo8);
				celdaCtaSinMov = fila.createCell((short)2);
				celdaCtaSinMov.setCellValue(Double.parseDouble(cuentaSinMov));
				celdaCtaSinMov.setCellStyle(estiloFormatoDecimal);
				celdaCtaSinMov = fila.createCell((short)4);
				celdaCtaSinMov.setCellValue("Cuentas sin Movimientos");
				celdaCtaSinMov.setCellStyle(estilo8);
				celdaCtaSinMov = fila.createCell((short)5);
				celdaCtaSinMov.setCellValue(Double.parseDouble(salCuentaSinMov));
				celdaCtaSinMov.setCellStyle(estiloFormatoDecimal);
				
				
				fila = hoja.createRow(15);
				HSSFCell celdaTotDepInv=fila.createCell((short)15);
				celdaTotDepInv = fila.createCell((short)1);
				celdaTotDepInv.setCellValue("Total de Depósitos de Inversiones");
				celdaTotDepInv.setCellStyle(estilo8);
				celdaTotDepInv = fila.createCell((short)2);
				celdaTotDepInv.setCellValue(Double.parseDouble(depositoInversion));
				celdaTotDepInv.setCellStyle(estiloFormatoDecimal);
				celdaTotDepInv = fila.createCell((short)4);
				celdaTotDepInv.setCellValue("Total de Depósitos de Inversiones");
				celdaTotDepInv.setCellStyle(estilo8);
				celdaTotDepInv = fila.createCell((short)5);
				celdaTotDepInv.setCellValue(Double.parseDouble(saldDepInversion));
				celdaTotDepInv.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(16);
				HSSFCell celdaPlazo30=fila.createCell((short)16);
				celdaPlazo30 = fila.createCell((short)1);
				celdaPlazo30.setCellValue("Monto Plazo 30");
				celdaPlazo30.setCellStyle(estilo8);
				celdaPlazo30 = fila.createCell((short)2);
				celdaPlazo30.setCellValue(Double.parseDouble(montoPlazo30));
				celdaPlazo30.setCellStyle(estiloFormatoDecimal);
				celdaPlazo30 = fila.createCell((short)4);
				celdaPlazo30.setCellValue("Saldo Plazo 30");
				celdaPlazo30.setCellStyle(estilo8);
				celdaPlazo30 = fila.createCell((short)5);
				celdaPlazo30.setCellValue(Double.parseDouble(saldoPlazo30));
				celdaPlazo30.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(17);
				HSSFCell celdaPlazo60=fila.createCell((short)17);
				celdaPlazo60 = fila.createCell((short)1);
				celdaPlazo60.setCellValue("Monto Plazo 60");
				celdaPlazo60.setCellStyle(estilo8);
				celdaPlazo60 = fila.createCell((short)2);
				celdaPlazo60.setCellValue(Double.parseDouble(montoPlazo60));
				celdaPlazo60.setCellStyle(estiloFormatoDecimal);
				celdaPlazo60 = fila.createCell((short)4);
				celdaPlazo60.setCellValue("Saldo Plazo 60");
				celdaPlazo60.setCellStyle(estilo8);
				celdaPlazo60 = fila.createCell((short)5);
				celdaPlazo60.setCellValue(Double.parseDouble(saldoPlazo60));
				celdaPlazo60.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(18);
				HSSFCell celdaPlazo90=fila.createCell((short)18);
				celdaPlazo90 = fila.createCell((short)1);
				celdaPlazo90.setCellValue("Monto Plazo 90");
				celdaPlazo90.setCellStyle(estilo8);
				celdaPlazo90 = fila.createCell((short)2);
				celdaPlazo90.setCellValue(Double.parseDouble(montoPlazo90));
				celdaPlazo90.setCellStyle(estiloFormatoDecimal);
				celdaPlazo90 = fila.createCell((short)4);
				celdaPlazo90.setCellValue("Saldo Plazo 90");
				celdaPlazo90.setCellStyle(estilo8);
				celdaPlazo90 = fila.createCell((short)5);
				celdaPlazo90.setCellValue(Double.parseDouble(saldoPlazo90));
				celdaPlazo90.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(19);
				HSSFCell celdaPlazo120=fila.createCell((short)19);
				celdaPlazo120 = fila.createCell((short)1);
				celdaPlazo120.setCellValue("Monto Plazo 120");
				celdaPlazo120.setCellStyle(estilo8);
				celdaPlazo120 = fila.createCell((short)2);
				celdaPlazo120.setCellValue(Double.parseDouble(montoPlazo120));
				celdaPlazo120.setCellStyle(estiloFormatoDecimal);
				celdaPlazo120 = fila.createCell((short)4);
				celdaPlazo120.setCellValue("Saldo Plazo 120");
				celdaPlazo120.setCellStyle(estilo8);
				celdaPlazo120 = fila.createCell((short)5);
				celdaPlazo120.setCellValue(Double.parseDouble(saldoPlazo120));
				celdaPlazo120.setCellStyle(estiloFormatoDecimal);
				
				
				fila = hoja.createRow(20);
				HSSFCell celdaPlazo180=fila.createCell((short)20);
				celdaPlazo180 = fila.createCell((short)1);
				celdaPlazo180.setCellValue("Monto Plazo 180");
				celdaPlazo180.setCellStyle(estilo8);
				celdaPlazo180 = fila.createCell((short)2);
				celdaPlazo180.setCellValue(Double.parseDouble(montoPlazo180));
				celdaPlazo180.setCellStyle(estiloFormatoDecimal);
				celdaPlazo180 = fila.createCell((short)4);
				celdaPlazo180.setCellValue("Saldo Plazo 180");
				celdaPlazo180.setCellStyle(estilo8);
				celdaPlazo180 = fila.createCell((short)5);
				celdaPlazo180.setCellValue(Double.parseDouble(saldoPlazo180));
				celdaPlazo180.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(21);
				HSSFCell celdaPlazo300=fila.createCell((short)21);
				celdaPlazo300 = fila.createCell((short)1);
				celdaPlazo300.setCellValue("Monto Plazo 360");
				celdaPlazo300.setCellStyle(estilo8);
				celdaPlazo300 = fila.createCell((short)2);
				celdaPlazo300.setCellValue(Double.parseDouble(montoPlazo360));
				celdaPlazo300.setCellStyle(estiloFormatoDecimal);
				celdaPlazo300 = fila.createCell((short)4);
				celdaPlazo300.setCellValue("Saldo Plazo 360");
				celdaPlazo300.setCellStyle(estilo8);
				celdaPlazo300 = fila.createCell((short)5);
				celdaPlazo300.setCellValue(Double.parseDouble(saldoPlazo360));
				celdaPlazo300.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(22);
				HSSFCell celdaIntereses=fila.createCell((short)22);
				celdaIntereses = fila.createCell((short)1);
				celdaIntereses.setCellValue("Intereses");
				celdaIntereses.setCellStyle(estilo8);
				celdaIntereses = fila.createCell((short)2);
				celdaIntereses.setCellValue(Double.parseDouble(montoInteresMensual));
				celdaIntereses.setCellStyle(estiloFormatoDecimal);
				celdaIntereses = fila.createCell((short)4);
				celdaIntereses.setCellValue("Intereses");
				celdaIntereses.setCellStyle(estilo8);
				celdaIntereses = fila.createCell((short)5);
				celdaIntereses.setCellValue(Double.parseDouble(saldoInteresMensual));
				celdaIntereses.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(24);
				HSSFCell celdaTotCapTrad=fila.createCell((short)24);
				celdaTotCapTrad = fila.createCell((short)1);
				celdaTotCapTrad.setCellValue("Total de Captación Tradicional");
				celdaTotCapTrad.setCellStyle(estilo8);
				celdaTotCapTrad = fila.createCell((short)2);
				celdaTotCapTrad.setCellValue(Double.parseDouble(captacionTradicional));
				celdaTotCapTrad.setCellStyle(estiloFormatoDecimal);
				celdaTotCapTrad = fila.createCell((short)4);
				celdaTotCapTrad.setCellValue("Total de Captación Tradicional");
				celdaTotCapTrad.setCellStyle(estilo8);
				celdaTotCapTrad = fila.createCell((short)5);
				celdaTotCapTrad.setCellValue(Double.parseDouble(salCapTradicional));
				celdaTotCapTrad.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(26);
				HSSFCell celdaMontoCartera=fila.createCell((short)26);
				celdaMontoCartera = fila.createCell((short)1);
				celdaMontoCartera.setCellValue("Monto de Cartera");
				celdaMontoCartera.setCellStyle(estilo8);
				celdaMontoCartera = fila.createCell((short)2);
				celdaMontoCartera.setCellValue(Double.parseDouble(carteraDiaAnterior));
				celdaMontoCartera.setCellStyle(estiloFormatoDecimal);
				celdaMontoCartera = fila.createCell((short)4);
				celdaMontoCartera.setCellValue("Saldo de Cartera");
				celdaMontoCartera.setCellStyle(estilo8);
				celdaMontoCartera = fila.createCell((short)5);
				celdaMontoCartera.setCellValue(Double.parseDouble(saldoCartera));
				celdaMontoCartera.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(27);
				HSSFCell celdaMontoCarteraVig=fila.createCell((short)27);
				celdaMontoCarteraVig = fila.createCell((short)1);
				celdaMontoCarteraVig.setCellValue("Cartera de Crédito Vigente");
				celdaMontoCarteraVig.setCellStyle(estilo8);
				celdaMontoCarteraVig = fila.createCell((short)2);
				celdaMontoCarteraVig.setCellValue(Double.parseDouble(carteraCredVigente));
				celdaMontoCarteraVig.setCellStyle(estiloFormatoDecimal);
				celdaMontoCarteraVig = fila.createCell((short)4);
				celdaMontoCarteraVig.setCellValue("Cartera de Crédito Vigente");
				celdaMontoCarteraVig.setCellStyle(estilo8);
				celdaMontoCarteraVig = fila.createCell((short)5);
				celdaMontoCarteraVig.setCellValue(Double.parseDouble(saldoCredVigente));
				celdaMontoCarteraVig.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(28);
				HSSFCell celdaMontoCarteraVen=fila.createCell((short)28);
				celdaMontoCarteraVen = fila.createCell((short)1);
				celdaMontoCarteraVen.setCellValue("Cartera de Crédito Vencida");
				celdaMontoCarteraVen.setCellStyle(estilo8);
				celdaMontoCarteraVen = fila.createCell((short)2);
				celdaMontoCarteraVen.setCellValue(Double.parseDouble(carteraCredVencida));
				celdaMontoCarteraVen.setCellStyle(estiloFormatoDecimal);
				celdaMontoCarteraVen = fila.createCell((short)4);
				celdaMontoCarteraVen.setCellValue("Cartera de Crédito Vencida");
				celdaMontoCarteraVen.setCellStyle(estilo8);
				celdaMontoCarteraVen = fila.createCell((short)5);
				celdaMontoCarteraVen.setCellValue(Double.parseDouble(saldoCredVencida));
				celdaMontoCarteraVen.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(30);
				HSSFCell celdaTotCartera=fila.createCell((short)30);
				celdaTotCartera = fila.createCell((short)1);
				celdaTotCartera.setCellValue("Total de la Cartera de Crédito");
				celdaTotCartera.setCellStyle(estilo8);
				celdaTotCartera = fila.createCell((short)2);
				celdaTotCartera.setCellValue(Double.parseDouble(totalCarteraCredito));
				celdaTotCartera.setCellStyle(estiloFormatoDecimal);
				celdaTotCartera = fila.createCell((short)4);
				celdaTotCartera.setCellValue("Total de la Cartera de Crédito");
				celdaTotCartera.setCellStyle(estilo8);
				celdaTotCartera = fila.createCell((short)5);
				celdaTotCartera.setCellValue(Double.parseDouble(saldoTotalCartera));
				celdaTotCartera.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(32);
				HSSFCell celdaResPorcentual=fila.createCell((short)32);
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
				celdaResPorcentual.setCellValue(Double.parseDouble(saldoPorcentual));
				celdaResPorcentual.setCellStyle(estiloFormatoDecimal);
				celdaResPorcentual = fila.createCell((short)6);
				celdaResPorcentual.setCellValue("%");
				celdaResPorcentual.setCellStyle(estilo8);
				
				
				fila = hoja.createRow(34);
				HSSFCell celdaParamPorcentaje=fila.createCell((short)34);
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
				celdaParamPorcentaje.setCellValue(Double.parseDouble(saldoPorcentaje));
				celdaParamPorcentaje.setCellStyle(estiloFormatoDecimal);
				celdaParamPorcentaje = fila.createCell((short)6);
				celdaParamPorcentaje.setCellValue("%");
				celdaParamPorcentaje.setCellStyle(estilo8);
				
				fila = hoja.createRow(36);
				HSSFCell celdaDiferencia=fila.createCell((short)36);
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
				celdaDiferencia.setCellValue(Double.parseDouble(saldoDiferencia));
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
	public RecursosCaptadosDiaServicio getRecursosCaptadosDiaServicio() {
		return recursosCaptadosDiaServicio;
	}

	public void setRecursosCaptadosDiaServicio(
			RecursosCaptadosDiaServicio recursosCaptadosDiaServicio) {
		this.recursosCaptadosDiaServicio = recursosCaptadosDiaServicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
