package riesgos.reporte;

import general.bean.ParametrosSesionBean;

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
import riesgos.servicio.SumaTiposAhorroServicio;

public class SumaTiposAhorroRepControlador extends AbstractCommandController{
	SumaTiposAhorroServicio sumaTiposAhorroServicio = null;
	ParametrosSesionBean parametrosSesionBean;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporteExcel= 1;
	}
	public SumaTiposAhorroRepControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("sumaTiposAhorro");
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
					reporteTiposAhorro(tipoReporte,riesgosBean,response);
				break;
			}
			return null;
		}
	// Reporte de Tipos de Ahorro
	public List reporteTiposAhorro(int tipoReporte,UACIRiesgosBean riesgosBean,  HttpServletResponse response){
		List listaRepote=null;
		String nombreArchivo = "";
		nombreArchivo = "Suma Tipos Ahorro "+riesgosBean.getFechaOperacion();
		listaRepote = sumaTiposAhorroServicio.listaReporteSumaTiposAhorro(tipoReporte, riesgosBean, response); 
		
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

				//Estilo Formato Texto alineado a la derecha
			HSSFCellStyle estiloFormatoDerecha = libro.createCellStyle();
			HSSFDataFormat formato2 = libro.createDataFormat();
			estiloFormatoDerecha.setDataFormat(formato2.getFormat("#,##0.00"));
			estiloFormatoDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Suma Tipos Ahorro");
			HSSFRow fila= hoja.createRow(1);
			
			// Encabezado
			// Nombre Institucion	
			HSSFCell celda=fila.createCell((short)1);
			celda.setCellValue(riesgosBean.getNombreInstitucion());
			celda.setCellStyle(estiloDatosCentrado);

			  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            5  //ultima celda   (0-based)
			    ));	
			  
				fila = hoja.createRow(3);
				HSSFCell celdaInst=fila.createCell((short)1);
				celdaInst.setCellValue("REPORTE SUMA TIPOS AHORRO: "+riesgosBean.getFechaOperacion());
				celdaInst.setCellStyle(estiloDatosCentrado);
				
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            5  //ultima celda   (0-based)
			    ));
				
				//Inicialización de variables
				String montoCaptadoDia          = "";
				String ahorroMenores            = "";
				String ahorroOrdinario       	= "";
				String ahorroVista 				= "";  
				String cuentaSinMov 			= "";

				String depositoInversion 		= "";
				String montoPlazo30 			= "";
				String montoPlazo60 			= "";
				String montoPlazo90 			= "";
				String montoPlazo120 			= "";
				
				String montoPlazo180 			= "";
				String montoPlazo360 			= "";
				String montoInteresMensual 		= "";
				String montoVistaOrdinario 		= "";
				String porcentualAhorroVista 	= "";

				String montoInversion 			= "";
				String porcentualInversiones 	= "";
				String saldoCaptadoDia 			= "";
				String salAhorroMenores 		= "";
				String salAhorroOrdinario 		= "";

				String salAhorroVista 			= "";
				String salCuentaSinMov 			= "";
				String saldDepInversion 		= "";
				String saldoPlazo30 			= "";
				String saldoPlazo60 			= "";

				String saldoPlazo90 			= "";
				String saldoPlazo120 			= "";
				String saldoPlazo180 			= "";
				String saldoPlazo360 			= "";
				String saldoInteresMensual 		= "";

				String saldoVistaOrdinario 		= "";
				String salPorcentualAhorroVista = "";
				String saldoInversion 			= "";
				String salPorcentualInversiones = "";
				
				int itera=0;
				UACIRiesgosBean riesgos = null;
				if(!listaRepote.isEmpty()){
				for( itera=0; itera<1; itera ++){
					riesgos = (UACIRiesgosBean) listaRepote.get(itera);
					montoCaptadoDia         = riesgos.getMontoCaptadoDia();
					ahorroMenores           = riesgos.getAhorroMenores();
					ahorroOrdinario       	= riesgos.getAhorroOrdinario();
					ahorroVista 			= riesgos.getAhorroVista();  
					cuentaSinMov 			= riesgos.getCuentaSinMov();

					depositoInversion 		= riesgos.getDepositoInversion();
					montoPlazo30 			= riesgos.getMontoPlazo30();
					montoPlazo60 			= riesgos.getMontoPlazo60();
					montoPlazo90 			= riesgos.getMontoPlazo90();
					montoPlazo120 			= riesgos.getMontoPlazo120();
					
					montoPlazo180 			= riesgos.getMontoPlazo180();
					montoPlazo360 			= riesgos.getMontoPlazo360();
					montoInteresMensual 	= riesgos.getMontoInteresMensual();
					montoVistaOrdinario 	= riesgos.getMontoVistaOrdinario();
					porcentualAhorroVista 	= riesgos.getPorcentualAhorroVista();

					montoInversion 			= riesgos.getMontoInversion();
					porcentualInversiones 	= riesgos.getPorcentualInversiones();
					saldoCaptadoDia 		= riesgos.getSaldoCaptadoDia();
					salAhorroMenores 		= riesgos.getSalAhorroMenores();
					salAhorroOrdinario 		= riesgos.getSalAhorroOrdinario();

					salAhorroVista 			= riesgos.getSalAhorroVista();
					salCuentaSinMov 		= riesgos.getSalCuentaSinMov();
					saldDepInversion 		= riesgos.getSaldDepInversion();
					saldoPlazo30 			= riesgos.getSaldoPlazo30();
					saldoPlazo60 			= riesgos.getSaldoPlazo30();

					saldoPlazo90 			= riesgos.getSaldoPlazo90();
					saldoPlazo120 			= riesgos.getSaldoPlazo120();
					saldoPlazo180 			= riesgos.getSaldoPlazo180();
					saldoPlazo360 			= riesgos.getSaldoPlazo360();
					saldoInteresMensual 	= riesgos.getSaldoInteresMensual();

					saldoVistaOrdinario 		= riesgos.getSaldoVistaOrdinario();
					salPorcentualAhorroVista 	= riesgos.getSalPorcentualAhorroVista();
					saldoInversion 				= riesgos.getSaldoInversion();
					salPorcentualInversiones 	= riesgos.getSalPorcentualInversiones();
					
				  }
				}
				
				fila = hoja.createRow(5);
				HSSFCell celdaConcepto=fila.createCell((short)5);
				celdaConcepto = fila.createCell((short)1);
				celdaConcepto.setCellValue("Monto Captado Acumulado del Día de Ayer");
				celdaConcepto.setCellStyle(estiloNegrita8);
				celdaConcepto = fila.createCell((short)4);
				celdaConcepto.setCellValue("Saldo Captado Acumulado al Día de Ayer");
				celdaConcepto.setCellStyle(estiloNegrita8);
				
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
				
				fila = hoja.createRow(8);
				HSSFCell celdaAhoMenor=fila.createCell((short)8);
				celdaAhoMenor = fila.createCell((short)1);
				celdaAhoMenor.setCellValue("Ahorro de Menores");
				celdaAhoMenor.setCellStyle(estilo8);
				celdaAhoMenor = fila.createCell((short)2);
				celdaAhoMenor.setCellValue(Double.parseDouble(ahorroMenores));
				celdaAhoMenor.setCellStyle(estiloFormatoDecimal);
				celdaAhoMenor = fila.createCell((short)4);
				celdaAhoMenor.setCellValue("Ahorro de Menores");
				celdaAhoMenor.setCellStyle(estilo8);
				celdaAhoMenor = fila.createCell((short)5);
				celdaAhoMenor.setCellValue(Double.parseDouble(salAhorroMenores));
				celdaAhoMenor.setCellStyle(estiloFormatoDecimal);

				fila = hoja.createRow(9);
				HSSFCell celdaAhoOrdina=fila.createCell((short)9);
				celdaAhoOrdina = fila.createCell((short)1);
				celdaAhoOrdina.setCellValue("Ahorro Ordinario");
				celdaAhoOrdina.setCellStyle(estilo8);
				celdaAhoOrdina = fila.createCell((short)2);
				celdaAhoOrdina.setCellValue(Double.parseDouble(ahorroOrdinario));
				celdaAhoOrdina.setCellStyle(estiloFormatoDecimal);
				celdaAhoOrdina = fila.createCell((short)4);
				celdaAhoOrdina.setCellValue("Ahorro Ordinario");
				celdaAhoOrdina.setCellStyle(estilo8);
				celdaAhoOrdina = fila.createCell((short)5);
				celdaAhoOrdina.setCellValue(Double.parseDouble(salAhorroOrdinario));
				celdaAhoOrdina.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(10);
				HSSFCell celdaAhoVista=fila.createCell((short)10);
				celdaAhoVista = fila.createCell((short)1);
				celdaAhoVista.setCellValue("Ahorro Vista");
				celdaAhoVista.setCellStyle(estilo8);
				celdaAhoVista = fila.createCell((short)2);
				celdaAhoVista.setCellValue(Double.parseDouble(ahorroVista));
				celdaAhoVista.setCellStyle(estiloFormatoDecimal);
				celdaAhoVista = fila.createCell((short)4);
				celdaAhoVista.setCellValue("Ahorro Vista");
				celdaAhoVista.setCellStyle(estilo8);
				celdaAhoVista = fila.createCell((short)5);
				celdaAhoVista.setCellValue(Double.parseDouble(salAhorroVista));
				celdaAhoVista.setCellStyle(estiloFormatoDecimal);

				fila = hoja.createRow(11);
				HSSFCell celdaCtaSinMov=fila.createCell((short)11);
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
				
				fila = hoja.createRow(13);
				HSSFCell celdaInversiones=fila.createCell((short)13);
				celdaInversiones = fila.createCell((short)1);
				celdaInversiones.setCellValue("Total de Depósitos de Inversiones");
				celdaInversiones.setCellStyle(estilo8);
				celdaInversiones = fila.createCell((short)2);
				celdaInversiones.setCellValue(Double.parseDouble(depositoInversion));
				celdaInversiones.setCellStyle(estiloFormatoDecimal);
				celdaInversiones = fila.createCell((short)4);
				celdaInversiones.setCellValue("Total de Depósitos de Inversiones");
				celdaInversiones.setCellStyle(estilo8);
				celdaInversiones = fila.createCell((short)5);
				celdaInversiones.setCellValue(Double.parseDouble(saldDepInversion));
				celdaInversiones.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(14);
				HSSFCell celdaPlazo30=fila.createCell((short)14);
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
				
				fila = hoja.createRow(15);
				HSSFCell celdaPlazo60=fila.createCell((short)15);
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
				
				fila = hoja.createRow(16);
				HSSFCell celdaPlazo90=fila.createCell((short)16);
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
				
				fila = hoja.createRow(17);
				HSSFCell celdaPlazo120=fila.createCell((short)17);
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
				
				
				fila = hoja.createRow(18);
				HSSFCell celdaPlazo180=fila.createCell((short)18);
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
				
				fila = hoja.createRow(19);
				HSSFCell celdaPlazo300=fila.createCell((short)19);
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

				fila = hoja.createRow(20);
				HSSFCell celdaIntereses=fila.createCell((short)20);
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

				fila = hoja.createRow(22);
				HSSFCell celdaAhorroVista=fila.createCell((short)22);
				celdaAhorroVista = fila.createCell((short)1);
				celdaAhorroVista.setCellValue("Total de Ahorro Vista/Ordinario");
				celdaAhorroVista.setCellStyle(estilo8);
				celdaAhorroVista = fila.createCell((short)2);
				String sumMonAhoVista = "SUM(C10:C12)"; 
				celdaAhorroVista.setCellType (HSSFCell.CELL_TYPE_FORMULA ); 
				celdaAhorroVista.setCellFormula(sumMonAhoVista);
				celdaAhorroVista.setCellStyle(estiloFormatoDecimal);
				celdaAhorroVista = fila.createCell((short)4);
				celdaAhorroVista.setCellValue("Total de Ahorro Vista/Ordinario");
				celdaAhorroVista.setCellStyle(estilo8);
				celdaAhorroVista = fila.createCell((short)5);
				String sumSalAhoVista = "SUM(F10:F12)"; 
				celdaAhorroVista.setCellType (HSSFCell.CELL_TYPE_FORMULA ); 
				celdaAhorroVista.setCellFormula(sumSalAhoVista);
				celdaAhorroVista.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(23);
				HSSFCell celdaResPorcAhoVista=fila.createCell((short)23);
				celdaResPorcAhoVista = fila.createCell((short)1);
				celdaResPorcAhoVista.setCellValue("Resultado Porcentual");
				celdaResPorcAhoVista.setCellStyle(estilo8);
				celdaResPorcAhoVista = fila.createCell((short)2);

				String montoCapta = riesgos.getMontoCaptadoDia();
				String saldoCapta = riesgos.getSaldoCaptadoDia();

					if(montoCapta.equals("0.00")){
						celdaResPorcAhoVista.setCellValue(0);					
					}
					else{
						String resMonPorcAho = "(C23/C8)*100"; 
						celdaResPorcAhoVista.setCellType (HSSFCell.CELL_TYPE_FORMULA ); 
						celdaResPorcAhoVista.setCellFormula(resMonPorcAho);
					} 
				celdaResPorcAhoVista.setCellStyle(estiloFormatoDecimal);
				celdaResPorcAhoVista = fila.createCell((short)3);
				celdaResPorcAhoVista.setCellValue("%");
				celdaResPorcAhoVista.setCellStyle(estilo8);
				celdaResPorcAhoVista = fila.createCell((short)4);
				celdaResPorcAhoVista.setCellValue("Resultado Porcentual");
				celdaResPorcAhoVista.setCellStyle(estilo8);
				celdaResPorcAhoVista = fila.createCell((short)5);

					if(saldoCapta.equals("0.00")){
						celdaResPorcAhoVista.setCellValue(0);					
					}
					else{
						String resSalPorcAho = "(F23/F8)*100"; 
						celdaResPorcAhoVista.setCellType (HSSFCell.CELL_TYPE_FORMULA ); 
						celdaResPorcAhoVista.setCellFormula(resSalPorcAho);
					} 
				
				celdaResPorcAhoVista.setCellStyle(estiloFormatoDecimal);
				celdaResPorcAhoVista = fila.createCell((short)6);
				celdaResPorcAhoVista.setCellValue("%");
				celdaResPorcAhoVista.setCellStyle(estilo8);
				
				fila = hoja.createRow(24);
				HSSFCell celdaLimiteAhoVista=fila.createCell((short)24);
				celdaLimiteAhoVista = fila.createCell((short)1);
				celdaLimiteAhoVista.setCellValue("Límite Porcentual");
				celdaLimiteAhoVista.setCellStyle(estilo8);
				celdaLimiteAhoVista = fila.createCell((short)2);
				celdaLimiteAhoVista.setCellValue("60 / 85 "); 
				celdaLimiteAhoVista.setCellStyle(estiloFormatoDerecha);
				celdaLimiteAhoVista = fila.createCell((short)3);
				celdaLimiteAhoVista.setCellValue("%");
				celdaLimiteAhoVista.setCellStyle(estilo8);
				celdaLimiteAhoVista = fila.createCell((short)4);
				celdaLimiteAhoVista.setCellValue("Límite Porcentual");
				celdaLimiteAhoVista.setCellStyle(estilo8);
				celdaLimiteAhoVista = fila.createCell((short)5);
				celdaLimiteAhoVista.setCellValue("60 / 85 ");
				celdaLimiteAhoVista.setCellStyle(estiloFormatoDerecha);
				celdaLimiteAhoVista = fila.createCell((short)6);
				celdaLimiteAhoVista.setCellValue("%");
				celdaLimiteAhoVista.setCellStyle(estilo8);
				
				fila = hoja.createRow(26);
				HSSFCell celdaAhorroPlazo=fila.createCell((short)26);
				celdaAhorroPlazo = fila.createCell((short)1);
				celdaAhorroPlazo.setCellValue("Total de Ahorro a Plazo");
				celdaAhorroPlazo.setCellStyle(estilo8);
				celdaAhorroPlazo = fila.createCell((short)2);
				String monAhoPlazo = "(C14)"; 
				celdaAhorroPlazo.setCellType (HSSFCell.CELL_TYPE_FORMULA ); 
				celdaAhorroPlazo.setCellFormula(monAhoPlazo);
				celdaAhorroPlazo.setCellStyle(estiloFormatoDecimal);
				celdaAhorroPlazo = fila.createCell((short)4);
				celdaAhorroPlazo.setCellValue("Total de Ahorro a Plazo");
				celdaAhorroPlazo.setCellStyle(estilo8);
				celdaAhorroPlazo = fila.createCell((short)5);
				String salAhoPlazo = "(F14)"; 
				celdaAhorroPlazo.setCellType (HSSFCell.CELL_TYPE_FORMULA ); 
				celdaAhorroPlazo.setCellFormula(salAhoPlazo);
				celdaAhorroPlazo.setCellStyle(estiloFormatoDecimal);

				fila = hoja.createRow(27);
				HSSFCell celdaResPorcInversion=fila.createCell((short)27);
				celdaResPorcInversion = fila.createCell((short)1);
				celdaResPorcInversion.setCellValue("Resultado Porcentual");
				celdaResPorcInversion.setCellStyle(estilo8);
				celdaResPorcInversion = fila.createCell((short)2);

					if(montoCapta.equals("0.00")){
						celdaResPorcInversion.setCellValue(0);					
					}
					else{
						String resMonPorcInv = "(C27/C8)*100"; 
						celdaResPorcInversion.setCellType (HSSFCell.CELL_TYPE_FORMULA ); 
						celdaResPorcInversion.setCellFormula(resMonPorcInv);
					} 

				celdaResPorcInversion.setCellStyle(estiloFormatoDecimal);
				celdaResPorcInversion = fila.createCell((short)3);
				celdaResPorcInversion.setCellValue("%");
				celdaResPorcInversion.setCellStyle(estilo8);
				celdaResPorcInversion = fila.createCell((short)4);
				celdaResPorcInversion.setCellValue("Resultado Porcentual");
				celdaResPorcInversion.setCellStyle(estilo8);
				celdaResPorcInversion = fila.createCell((short)5);

					if(saldoCapta.equals("0.00")){
						celdaResPorcAhoVista.setCellValue(0);					
					}
					else{
						String resSalPorcInv = "(F27/F8)*100"; 
						celdaResPorcInversion.setCellType (HSSFCell.CELL_TYPE_FORMULA ); 
						celdaResPorcInversion.setCellFormula(resSalPorcInv);
					} 

				celdaResPorcInversion.setCellStyle(estiloFormatoDecimal);
				celdaResPorcInversion = fila.createCell((short)6);
				celdaResPorcInversion.setCellValue("%");
				celdaResPorcInversion.setCellStyle(estilo8);

				fila = hoja.createRow(28);
				HSSFCell celdaLimiteAhoPlazo=fila.createCell((short)28);
				celdaLimiteAhoPlazo = fila.createCell((short)1);
				celdaLimiteAhoPlazo.setCellValue("Límite Porcentual");
				celdaLimiteAhoPlazo.setCellStyle(estilo8);
				celdaLimiteAhoPlazo = fila.createCell((short)2);
				celdaLimiteAhoPlazo.setCellValue("15 / 40 ");
				celdaLimiteAhoPlazo.setCellStyle(estiloFormatoDerecha);
				celdaLimiteAhoPlazo = fila.createCell((short)3);
				celdaLimiteAhoPlazo.setCellValue("%");
				celdaLimiteAhoPlazo.setCellStyle(estilo8);
				celdaLimiteAhoPlazo = fila.createCell((short)4);
				celdaLimiteAhoPlazo.setCellValue("Límite Porcentual");
				celdaLimiteAhoPlazo.setCellStyle(estilo8);
				celdaLimiteAhoPlazo = fila.createCell((short)5);
				celdaLimiteAhoPlazo.setCellValue("15 / 40 ");
				celdaLimiteAhoPlazo.setCellStyle(estiloFormatoDerecha);
				celdaLimiteAhoPlazo = fila.createCell((short)6);
				celdaLimiteAhoPlazo.setCellValue("%");
				celdaLimiteAhoPlazo.setCellStyle(estilo8);

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
	public SumaTiposAhorroServicio getSumaTiposAhorroServicio() {
		return sumaTiposAhorroServicio;
	}
	public void setSumaTiposAhorroServicio(
			SumaTiposAhorroServicio sumaTiposAhorroServicio) {
		this.sumaTiposAhorroServicio = sumaTiposAhorroServicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
