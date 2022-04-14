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

import regulatorios.bean.VariacionCarteraBean;
import regulatorios.servicio.VariacionCarteraServicio;
import regulatorios.servicio.VariacionCarteraServicio.Enum_Lis_VariacionCartera;

public class VariacionCarteraRepControlador extends AbstractCommandController{
	VariacionCarteraServicio variacionCarteraServicio = null;
	String successView = null;
	
	public VariacionCarteraRepControlador(){
		setCommandClass(VariacionCarteraBean.class);
		setCommandName("variacionCarteraBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		VariacionCarteraBean variacionCartera = (VariacionCarteraBean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
			0;
			
			switch(tipoReporte)	{
			case Enum_Lis_VariacionCartera.excel:		
				reporteVariacionCartera(tipoReporte,variacionCartera,response);
				break;
			}
			return null;	
		}

		// Reporte Regulatorio De  Variación de Cartera
		@SuppressWarnings("deprecation")
		public List reporteVariacionCartera(int tipoReporte,VariacionCarteraBean variacionCartera,  HttpServletResponse response){
			List listaRepote=null;
			String mesEnLetras	= "";
			String anio	= "";
			String nombreArchivo = "";
			mesEnLetras = variacionCarteraServicio.descripcionMes(variacionCartera.getMes());
			anio = variacionCartera.getAnio();
			nombreArchivo = "Variacion Cartera "+mesEnLetras +" "+anio; 
			listaRepote = variacionCarteraServicio.listaReporteVariacionCartera(tipoReporte, variacionCartera, response); 	
			
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
				
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				//Estilo de datos centrados Encabezado
				HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
				estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
				estiloDatosCentrado.setFont(fuenteNegrita10);
				estiloDatosCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				
				//Estilo de 8 Negrita para Contenido
				HSSFCellStyle estiloNegrita8 = libro.createCellStyle();
				estiloNegrita8.setFont(fuenteNegrita8);
				
				//Crea fuente con tamaño 10 para informacion del reporte.
				HSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)10);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				//Estilo de 8  para Contenido
				HSSFCellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);
				
				
				//Estilo de datos centrados contenido
				HSSFCellStyle estiloCentrado = libro.createCellStyle();
				estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
				estiloCentrado.setFont(fuente8);
				estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				
				//Estilo Formato decimal (0.00)
				HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
				HSSFDataFormat formato = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(formato.getFormat("#,##0.00"));
				estiloFormatoDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				
				// Creacion de hoja					
				HSSFSheet hoja = libro.createSheet("Variación Cartera");
				HSSFRow fila= hoja.createRow(1);
				
				// Encabezado
				// Nombre Institucion	
				HSSFCell celdaInst=fila.createCell((short)0);
				celdaInst.setCellValue(variacionCartera.getNombreInstitucion());
				celdaInst.setCellStyle(estiloDatosCentrado);

				  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            5  //ultima celda   (0-based)
				    ));	
					
				  	fila = hoja.createRow(4);
					HSSFCell celdaRep=fila.createCell((short)0);
					celdaRep.setCellValue("REPORTE DE VARIACIÓN DE CARTERA MENSUAL");
					celdaRep.setCellStyle(estiloDatosCentrado);
					
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            4, //primera fila (0-based)
				            4, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            5  //ultima celda   (0-based)
				    ));
					
					fila = hoja.createRow(5);
					HSSFCell celdaMes=fila.createCell((short)0);
					celdaMes.setCellValue("MES DE: "+mesEnLetras +" "+anio);
					celdaMes.setCellStyle(estiloDatosCentrado);
					
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            5, //primera fila (0-based)
				            5, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            5  //ultima celda   (0-based)
				    ));
				
					fila = hoja.createRow(8);
					HSSFCell celda=fila.createCell((short)1);
					celda.setCellValue("(Cifras en Pesos)");
					
					//Inicialización de variables
					String saldoInicialCarVig = "";
					String numCredSaldoCarVig = "";
					
					String incremCarVig = "";
					String numCredIncremCarVig = "";
					
					String credOtorCarVig = "";
					String numCredOtorCarVig = "";
					
					String interDevCarVig = "";
					String numCredInterDevCarVig = "";
					
					String traspasoCarVig = "";
					String numCredTraspasoCarVig = "";
					
					String decremCarVig = "";
					String numCredDecremCarVig = "";
					
					String amorCarVig = "";
					String numCredAmorCarVig = "";
					
					String trasNetCarVig = "";
					String numCredTrasNetCarVig = "";
					
					String saldoFinCarVig = "";
					String numCredSaldoFinCarVig = "";
					
					String saldoInicialCarVen = "";
					String numCredSaldoCarVen = "";
					
					String incremCarVen = "";
					String numCredIncremCarVen = "";
					
					String traspasoCarVen = "";
					String numCredTraspasoCarVen = "";
					
					String decremCarVen = "";
					String numCredDecremCarVen = "";
					
					String credCastCarVen = "";
					String numCredCastCarVen = "";
					
					String trasNetCarVen = "";
					String numCredTrasNetCarVen = "";
					
					String amorCarVen = "";
					String numCredAmorCarVen = "";
					
					String saldoFinCarVen = "";
					String numCredSaldoFinCarVen = "";	
										
					int itera=0;
					VariacionCarteraBean variacionCarteraBean = null;
					if(!listaRepote.isEmpty()){
					for( itera=0; itera<1; itera ++){
						variacionCarteraBean = (VariacionCarteraBean) listaRepote.get(itera);
						saldoInicialCarVig = variacionCarteraBean.getSaldoInicialCarVig();
						numCredSaldoCarVig = variacionCarteraBean.getNumCredSalCarVig();
						incremCarVig = variacionCarteraBean.getIncremCarVig();
						numCredIncremCarVig = variacionCarteraBean.getNumCredIncremCarVig();
						credOtorCarVig = variacionCarteraBean.getCredOtorCarVig();
						numCredOtorCarVig = variacionCarteraBean.getNumCredOtorCarVig();
						interDevCarVig = variacionCarteraBean.getInterDevCarVig();
						numCredInterDevCarVig = variacionCarteraBean.getNumCredInterDevCarVig();
						traspasoCarVig = variacionCarteraBean.getTraspasoCarVig();
						numCredTraspasoCarVig = variacionCarteraBean.getNumCredTraspasoCarVig();
						decremCarVig = variacionCarteraBean.getDecremCarVig();
						numCredDecremCarVig = variacionCarteraBean.getNumCredDecremCarVig();
						amorCarVig = variacionCarteraBean.getAmorCarVig();
						numCredAmorCarVig = variacionCarteraBean.getNumCredAmorCarVig();
						trasNetCarVig = variacionCarteraBean.getTrasNetCarVig();
						numCredTrasNetCarVig = variacionCarteraBean.getNumCredTrasNetCarVig();
						saldoFinCarVig = variacionCarteraBean.getSaldoFinCarVig();
						numCredSaldoFinCarVig = variacionCarteraBean.getNumCredSaldoFinCarVig();
						saldoInicialCarVen = variacionCarteraBean.getSaldoInicialCarVen();
						numCredSaldoCarVen = variacionCarteraBean.getNumCredSaldoCarVen();
						incremCarVen = variacionCarteraBean.getIncremCarVen();
						numCredIncremCarVen = variacionCarteraBean.getNumCredIncremCarVen();
						traspasoCarVen = variacionCarteraBean.getTraspasoCarVen();
						numCredTraspasoCarVen = variacionCarteraBean.getNumCredTraspasoCarVen();
						decremCarVen = variacionCarteraBean.getDecremCarVen();
						numCredDecremCarVen = variacionCarteraBean.getNumCredDecremCarVen();
						credCastCarVen = variacionCarteraBean.getCredCastCarVen();
						numCredCastCarVen = variacionCarteraBean.getNumCredCastCarVen();
						trasNetCarVen = variacionCarteraBean.getTrasNetCarVen();
						numCredTrasNetCarVen = variacionCarteraBean.getNumCredTrasNetCarVen();
						amorCarVen = variacionCarteraBean.getAmorCarVen();
						numCredAmorCarVen = variacionCarteraBean.getNumCredAmorCarVen();
						saldoFinCarVen = variacionCarteraBean.getSaldoFinCarVen();
						numCredSaldoFinCarVen = variacionCarteraBean.getNumCredSaldoFinCarVen();
						
						}
					}
					
					//MOVIMIENTOS DE LA CARTERA VIGENTE
					fila = hoja.createRow(10);
					celda = fila.createCell((short)1);
					celda.setCellValue("Movimientos de la Cartera Vigente");
					celda.setCellStyle(estiloNeg10);
					
					//Concepto
					fila = hoja.createRow(11);
					celda = fila.createCell((short)1);
					celda.setCellValue("Concepto");
					celda.setCellStyle(estilo8);
					
					//Importes
					celda = fila.createCell((short)2);
					celda.setCellValue("Importes");
					celda.setCellStyle(estiloCentrado);
					
					//Número de Créditos
					celda = fila.createCell((short)3);
					celda.setCellValue("No. Créditos");
					celda.setCellStyle(estiloCentrado);
					
					//Saldo Inicial
					fila = hoja.createRow(12);
					HSSFCell celdaSaldoIniCarVig=fila.createCell((short)12);
					celdaSaldoIniCarVig = fila.createCell((short)1);
					celdaSaldoIniCarVig.setCellValue("Saldo Inicial");
					celdaSaldoIniCarVig.setCellStyle(estilo8);
					celdaSaldoIniCarVig = fila.createCell((short)2);
					celdaSaldoIniCarVig.setCellValue(Double.parseDouble(saldoInicialCarVig));
					celdaSaldoIniCarVig.setCellStyle(estiloFormatoDecimal);
					celdaSaldoIniCarVig = fila.createCell((short)3);
					celdaSaldoIniCarVig.setCellValue(Double.parseDouble(numCredSaldoCarVig));
					celdaSaldoIniCarVig.setCellStyle(estiloFormatoDecimal);
					
					//Incrementos
					fila = hoja.createRow(13);
					HSSFCell celdaIncremCarVig=fila.createCell((short)13);
					celdaIncremCarVig = fila.createCell((short)1);
					celdaIncremCarVig.setCellValue("Incrementos");
					celdaIncremCarVig.setCellStyle(estiloNeg10);
					celdaIncremCarVig = fila.createCell((short)2);
					celdaIncremCarVig.setCellValue(Double.parseDouble(incremCarVig));
					celdaIncremCarVig.setCellStyle(estiloFormatoDecimal);
					celdaIncremCarVig = fila.createCell((short)3);
					celdaIncremCarVig.setCellValue(Double.parseDouble(numCredIncremCarVig));
					celdaIncremCarVig.setCellStyle(estiloFormatoDecimal);
					
					//Créditos Otorgados
					fila = hoja.createRow(14);
					HSSFCell celdaCredOtorCarVig=fila.createCell((short)14);
					celdaCredOtorCarVig = fila.createCell((short)1);
					celdaCredOtorCarVig.setCellValue("Créditos Otorgados");
					celdaCredOtorCarVig.setCellStyle(estilo8);
					celdaCredOtorCarVig = fila.createCell((short)2);
					celdaCredOtorCarVig.setCellValue(Double.parseDouble(credOtorCarVig));
					celdaCredOtorCarVig.setCellStyle(estiloFormatoDecimal);
					celdaCredOtorCarVig = fila.createCell((short)3);
					celdaCredOtorCarVig.setCellValue(Double.parseDouble(numCredOtorCarVig));
					celdaCredOtorCarVig.setCellStyle(estiloFormatoDecimal);
					
					// Intereses Devengados
					fila = hoja.createRow(15);
					HSSFCell celdaInterDevCarVig=fila.createCell((short)15);
					celdaInterDevCarVig = fila.createCell((short)1);
					celdaInterDevCarVig.setCellValue("Intereses Devengados");
					celdaInterDevCarVig.setCellStyle(estilo8);
					celdaInterDevCarVig = fila.createCell((short)2);
					celdaInterDevCarVig.setCellValue(Double.parseDouble(interDevCarVig));
					celdaInterDevCarVig.setCellStyle(estiloFormatoDecimal);
					celdaInterDevCarVig = fila.createCell((short)3);
					celdaInterDevCarVig.setCellValue(Double.parseDouble(numCredInterDevCarVig));  
					celdaInterDevCarVig.setCellStyle(estiloFormatoDecimal);
					
					// Traspaso Neto de Cartera Vencida
					fila = hoja.createRow(16);
					HSSFCell celdaTraspasoCarVig=fila.createCell((short)16);
					celdaTraspasoCarVig = fila.createCell((short)1);
					celdaTraspasoCarVig.setCellValue("Traspaso Neto de Cartera Vencida");
					celdaTraspasoCarVig.setCellStyle(estilo8);
					celdaTraspasoCarVig = fila.createCell((short)2);
					celdaTraspasoCarVig.setCellValue(Double.parseDouble(traspasoCarVig));
					celdaTraspasoCarVig.setCellStyle(estiloFormatoDecimal);
					celdaTraspasoCarVig = fila.createCell((short)3);
					celdaTraspasoCarVig.setCellValue(Double.parseDouble(numCredTraspasoCarVig));  
					celdaTraspasoCarVig.setCellStyle(estiloFormatoDecimal);
					
					
					//Decrementos
					fila = hoja.createRow(17);
					HSSFCell celdaDecrementosCarVig=fila.createCell((short)17);
					celdaDecrementosCarVig = fila.createCell((short)1);
					celdaDecrementosCarVig.setCellValue("Decrementos:");
					celdaDecrementosCarVig.setCellStyle(estiloNeg10);
					celdaDecrementosCarVig = fila.createCell((short)2);
					celdaDecrementosCarVig.setCellValue(Double.parseDouble(decremCarVig));
					celdaDecrementosCarVig.setCellStyle(estiloFormatoDecimal);
					celdaDecrementosCarVig = fila.createCell((short)3);
					celdaDecrementosCarVig.setCellValue(Double.parseDouble(numCredDecremCarVig));  
					celdaDecrementosCarVig.setCellStyle(estiloFormatoDecimal);
					
					//Amortizaciones de Crédito
					fila = hoja.createRow(18);
					HSSFCell celdaAmortiCarVig=fila.createCell((short)18);
					celdaAmortiCarVig = fila.createCell((short)1);
					celdaAmortiCarVig.setCellValue("Amortizaciones de Crédito");
					celdaAmortiCarVig.setCellStyle(estilo8);
					celdaAmortiCarVig = fila.createCell((short)2);
					celdaAmortiCarVig.setCellValue(Double.parseDouble(amorCarVig));
					celdaAmortiCarVig.setCellStyle(estiloFormatoDecimal);
					celdaAmortiCarVig = fila.createCell((short)3);
					celdaAmortiCarVig.setCellValue(Double.parseDouble(numCredAmorCarVig));  
					celdaAmortiCarVig.setCellStyle(estiloFormatoDecimal);
					
					//Traspaso Neto a Cartera Vencida
					fila = hoja.createRow(19);
					HSSFCell celdaTrasNetoCarVig=fila.createCell((short)19);
					celdaTrasNetoCarVig = fila.createCell((short)1);
					celdaTrasNetoCarVig.setCellValue("Traspaso Neto a Cartera Vencida");
					celdaTrasNetoCarVig.setCellStyle(estilo8);
					celdaTrasNetoCarVig = fila.createCell((short)2);
					celdaTrasNetoCarVig.setCellValue(Double.parseDouble(trasNetCarVig));
					celdaTrasNetoCarVig.setCellStyle(estiloFormatoDecimal);
					celdaTrasNetoCarVig = fila.createCell((short)3);
					celdaTrasNetoCarVig.setCellValue(Double.parseDouble(numCredTrasNetCarVig));  
					celdaTrasNetoCarVig.setCellStyle(estiloFormatoDecimal);
					
					
					//Saldo Final
					fila = hoja.createRow(20);
					HSSFCell celdaSaldoFinCarVig=fila.createCell((short)20);
					celdaSaldoFinCarVig = fila.createCell((short)1);
					celdaSaldoFinCarVig.setCellValue("Saldo Final");
					celdaSaldoFinCarVig.setCellStyle(estiloNeg10);
					celdaSaldoFinCarVig = fila.createCell((short)2);
					celdaSaldoFinCarVig.setCellValue(Double.parseDouble(saldoFinCarVig));
					celdaSaldoFinCarVig.setCellStyle(estiloFormatoDecimal);
					celdaSaldoFinCarVig = fila.createCell((short)3);
					celdaSaldoFinCarVig.setCellValue(Double.parseDouble(numCredSaldoFinCarVig));  
					celdaSaldoFinCarVig.setCellStyle(estiloFormatoDecimal);
					//FIN DE MOVIMIENTOS DE LA CARTERA VIGENTE
					
					//MOVIMIENTOS DE LA CARTERA VENCIDA
					fila = hoja.createRow(23);
					celda = fila.createCell((short)1);
					celda.setCellValue("Movimientos de la Cartera Vencida");
					celda.setCellStyle(estiloNeg10);
					
					//Concepto
					fila = hoja.createRow(24);
					celda = fila.createCell((short)1);
					celda.setCellValue("Concepto");
					celda.setCellStyle(estilo8);
					
					//Importes
					celda = fila.createCell((short)2);
					celda.setCellValue("Importes");
					celda.setCellStyle(estiloCentrado);
					
					//Número de Créditos
					celda = fila.createCell((short)3);
					celda.setCellValue("No. Créditos");
					celda.setCellStyle(estiloCentrado);
					
					//Saldo Inicial
					fila = hoja.createRow(25);
					HSSFCell celdaSaldoIniCarVen=fila.createCell((short)25);
					celdaSaldoIniCarVen = fila.createCell((short)1);
					celdaSaldoIniCarVen.setCellValue("Saldo Inicial");
					celdaSaldoIniCarVen.setCellStyle(estilo8);
					celdaSaldoIniCarVen = fila.createCell((short)2);
					celdaSaldoIniCarVen.setCellValue(Double.parseDouble(saldoInicialCarVen));
					celdaSaldoIniCarVen.setCellStyle(estiloFormatoDecimal);
					celdaSaldoIniCarVen = fila.createCell((short)3);
					celdaSaldoIniCarVen.setCellValue(Double.parseDouble(numCredSaldoCarVen));  
					celdaSaldoIniCarVen.setCellStyle(estiloFormatoDecimal);
					
					//Incrementos
					fila = hoja.createRow(26);
					HSSFCell celdaIncremCarVen=fila.createCell((short)26);
					celdaIncremCarVen = fila.createCell((short)1);
					celdaIncremCarVen.setCellValue("Incrementos:");
					celdaIncremCarVen.setCellStyle(estiloNeg10);
					celdaIncremCarVen = fila.createCell((short)2);
					celdaIncremCarVen.setCellValue(Double.parseDouble(incremCarVen));
					celdaIncremCarVen.setCellStyle(estiloFormatoDecimal);
					celdaIncremCarVen = fila.createCell((short)3);
					celdaIncremCarVen.setCellValue(Double.parseDouble(numCredIncremCarVen));  
					celdaIncremCarVen.setCellStyle(estiloFormatoDecimal);
					
					//Traspaso Neto de Cartera Vigente
					fila = hoja.createRow(27);
					HSSFCell celdaTraspasoCarVen=fila.createCell((short)27);
					celdaTraspasoCarVen = fila.createCell((short)1);
					celdaTraspasoCarVen.setCellValue("Traspaso Neto de Cartera Vigente");
					celdaTraspasoCarVen.setCellStyle(estilo8);
					celdaTraspasoCarVen = fila.createCell((short)2);
					celdaTraspasoCarVen.setCellValue(Double.parseDouble(traspasoCarVen));
					celdaTraspasoCarVen.setCellStyle(estiloFormatoDecimal);
					celdaTraspasoCarVen = fila.createCell((short)3);
					celdaTraspasoCarVen.setCellValue(Double.parseDouble(numCredTraspasoCarVen));  
					celdaTraspasoCarVen.setCellStyle(estiloFormatoDecimal);
					
					//Decrementos
					fila = hoja.createRow(28);
					HSSFCell celdaDecremCarVen=fila.createCell((short)28);
					celdaDecremCarVen = fila.createCell((short)1);
					celdaDecremCarVen.setCellValue("Decrementos:");
					celdaDecremCarVen.setCellStyle(estiloNeg10);
					celdaDecremCarVen = fila.createCell((short)2);
					celdaDecremCarVen.setCellValue(Double.parseDouble(decremCarVen));
					celdaDecremCarVen.setCellStyle(estiloFormatoDecimal);
					celdaDecremCarVen = fila.createCell((short)3);
					celdaDecremCarVen.setCellValue(Double.parseDouble(numCredDecremCarVen));  
					celdaDecremCarVen.setCellStyle(estiloFormatoDecimal);
					
					//Créditos Castigados
					fila = hoja.createRow(29);
					HSSFCell celdaCredCarVen=fila.createCell((short)29);
					celdaCredCarVen = fila.createCell((short)1);
					celdaCredCarVen.setCellValue("Créditos Castigados");
					celdaCredCarVen.setCellStyle(estilo8);
					celdaCredCarVen = fila.createCell((short)2);
					celdaCredCarVen.setCellValue(Double.parseDouble(credCastCarVen));
					celdaCredCarVen.setCellStyle(estiloFormatoDecimal);
					celdaCredCarVen = fila.createCell((short)3);
					celdaCredCarVen.setCellValue(Double.parseDouble(numCredCastCarVen));  
					celdaCredCarVen.setCellStyle(estiloFormatoDecimal);
					
					//Traspaso Neto a Cartera Vigente
					fila = hoja.createRow(30);
					HSSFCell celdaTrasNetoCarVen=fila.createCell((short)30);
					celdaTrasNetoCarVen = fila.createCell((short)1);
					celdaTrasNetoCarVen.setCellValue("Traspaso Neto a Cartera Vigente");
					celdaTrasNetoCarVen.setCellStyle(estilo8);
					celdaTrasNetoCarVen = fila.createCell((short)2);
					celdaTrasNetoCarVen.setCellValue(Double.parseDouble(trasNetCarVen));
					celdaTrasNetoCarVen.setCellStyle(estiloFormatoDecimal);
					celdaTrasNetoCarVen = fila.createCell((short)3);
					celdaTrasNetoCarVen.setCellValue(Double.parseDouble(numCredTrasNetCarVen));  
					celdaTrasNetoCarVen.setCellStyle(estiloFormatoDecimal);
					
					//Amortizaciones de Crédito
					fila = hoja.createRow(31);
					HSSFCell celdaAmortCarVen=fila.createCell((short)31);
					celdaAmortCarVen = fila.createCell((short)1);
					celdaAmortCarVen.setCellValue("Amortizaciones de Crédito");
					celdaAmortCarVen.setCellStyle(estilo8);
					celdaAmortCarVen = fila.createCell((short)2);
					celdaAmortCarVen.setCellValue(Double.parseDouble(amorCarVen));
					celdaAmortCarVen.setCellStyle(estiloFormatoDecimal);
					celdaAmortCarVen = fila.createCell((short)3);
					celdaAmortCarVen.setCellValue(Double.parseDouble(numCredAmorCarVen));  
					celdaAmortCarVen.setCellStyle(estiloFormatoDecimal);
					
					//Saldo Final
					fila = hoja.createRow(32);
					HSSFCell celdaSaldoFinCarVen=fila.createCell((short)32);
					celdaSaldoFinCarVen = fila.createCell((short)1);
					celdaSaldoFinCarVen.setCellValue("Saldo Final");
					celdaSaldoFinCarVen.setCellStyle(estiloNeg10);
					celdaSaldoFinCarVen = fila.createCell((short)2);
					celdaSaldoFinCarVen.setCellValue(Double.parseDouble(saldoFinCarVen));
					celdaSaldoFinCarVen.setCellStyle(estiloFormatoDecimal);
					celdaSaldoFinCarVen = fila.createCell((short)3);
					celdaSaldoFinCarVen.setCellValue(Double.parseDouble(numCredSaldoFinCarVen));  
					celdaSaldoFinCarVen.setCellStyle(estiloFormatoDecimal);
					//FIN DE MOVIMIENTOS DE LA CARTERA VENCIDA

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
		
		// GETTER Y SETTER
		public VariacionCarteraServicio getVariacionCarteraServicio() {
			return variacionCarteraServicio;
		}

		public void setVariacionCarteraServicio(
				VariacionCarteraServicio variacionCarteraServicio) {
			this.variacionCarteraServicio = variacionCarteraServicio;
		}

		public String getSuccessView() {
			return successView;
		}

		public void setSuccessView(String successView) {
			this.successView = successView;
		}
	}
	
	