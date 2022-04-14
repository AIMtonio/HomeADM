package cuentas.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

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
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ParametrosSisBean;


import cuentas.bean.AnaliticoAhorroBean;
import cuentas.bean.ReporteCuentasAhoMovBean;
import cuentas.servicio.CuentasAhoMovServicio;

public class RepCuentasAhoMovControlador extends AbstractCommandController{
	
	CuentasAhoMovServicio cuentasAhoMovServicio = null;
	ParametrosSesionBean parametrosSesionBean;

	String nombreReporte = null;
	String successView = null;		   
	
	public static interface Enum_Con_TipRepor{
		int ReporPDF = 1;
		int ReporExcel = 2;
	}
	
	
	public RepCuentasAhoMovControlador() {
		setCommandClass(ReporteCuentasAhoMovBean.class);
		setCommandName("reporteCuentasAhoMovBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		ReporteCuentasAhoMovBean reporteCuentasAhoMovBean = (ReporteCuentasAhoMovBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
			0;
				
		String htmlString= "";
				
			switch(tipoReporte){
				
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reportePDF(reporteCuentasAhoMovBean, nombreReporte, response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:		
					List listaReportes = reporteExcel(tipoLista,reporteCuentasAhoMovBean,response);
				break;
			}
			
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
		
	}
	
	public ByteArrayOutputStream reportePDF(ReporteCuentasAhoMovBean reporteCuentasAhoMovBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = cuentasAhoMovServicio.creaRepCuentasAhoMovPDF(reporteCuentasAhoMovBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteMovimientosCuenta.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return htmlStringPDF;
	}
	
	public List  reporteExcel(int tipoLista,ReporteCuentasAhoMovBean reporteCuentasAhoMovBean,  HttpServletResponse response){
		List listaCuentaAhoMov=null;  
		//List listaCreditos = null;
		
		listaCuentaAhoMov = cuentasAhoMovServicio.Reporteslista(tipoLista,reporteCuentasAhoMovBean); 	
		
		int numhoja = 0;
		int numhoja2 = 0;
		int iter=0;
		int tamanioLista = 0;
		int realtamList = 0;
		int i=0;
		double totalAbonos = 0;
		double totalCargos = 0;
		double totalSaldos = 0;
		HSSFSheet hoja	=null;
		HSSFRow fila	=null;
		HSSFCell celda	=null;

		String safilocaleCuenta = "safilocale.ctaAhorroRep";

		safilocaleCuenta = Utileria.generaLocale(safilocaleCuenta, parametrosSesionBean.getNomCortoInstitucion());

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
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			if (listaCuentaAhoMov != null ){
				if(listaCuentaAhoMov.size() > 0){
					iter=0;
					tamanioLista = 0;
					realtamList = listaCuentaAhoMov.size();
					i=7;
					totalAbonos = 0;
					totalCargos = 0;
					totalSaldos = 0;
					hoja	=null;
					fila	=null;
					celda	=null;
					for(iter = 0; iter < realtamList;numhoja++){
						tamanioLista +=65000;
						if(tamanioLista > realtamList){
							tamanioLista = realtamList;
						}
						// Creacion de hoja
						hoja = libro.createSheet();
						if(realtamList <= 65000){
							libro.setSheetName(0, "ReporteMovimientosCuentasAhorro");
						}else{
							libro.setSheetName(numhoja, 	"RepMoviCuentasAhoHoja"+String.valueOf(numhoja+1));
						}

						fila = hoja.createRow(0);
			 			
						celda=fila.createCell((short)1);
						celda.setCellStyle(estiloNeg10);
						celda.setCellValue(reporteCuentasAhoMovBean.getNomInstitucion() );
						celda.setCellStyle(estiloCentrado);
									
					   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            0, //primera fila (0-based)
					            0, //ultima fila  (0-based)
					            1, //primer celda (0-based)
					            7  //ultima celda   (0-based)
					    ));
					    
					   HSSFCell celdaUsu= fila.createCell((short)10);
						celdaUsu.setCellValue("Usuario:");
						celdaUsu.setCellStyle(estiloNeg8);	
						
						celdaUsu = fila.createCell((short)11);
						celdaUsu.setCellValue((!reporteCuentasAhoMovBean.getClaveUsuario().isEmpty())?reporteCuentasAhoMovBean.getClaveUsuario(): "TODOS");
						
						String fechaVar=reporteCuentasAhoMovBean.getFechaActual();
						fila = hoja.createRow(1);
						HSSFCell celdaFec = fila.createCell((short)10);
						celdaFec.setCellValue("Fecha:");
						celdaFec.setCellStyle(estiloNeg8);	
						celdaFec = fila.createCell((short)11);
						celdaFec.setCellValue(fechaVar);
						
						fila = hoja.createRow(2);
						celda=fila.createCell((short)1);
						celda.setCellStyle(estiloNeg10);
						celda.setCellValue("Reporte de "+safilocaleCuenta+" del "+ ((!reporteCuentasAhoMovBean.getFechaInicial().isEmpty())?reporteCuentasAhoMovBean.getFechaInicial(): "1900-01-01")+
								" al "+ ((!reporteCuentasAhoMovBean.getFechaFinal().isEmpty())?reporteCuentasAhoMovBean.getFechaFinal(): "2020-01-01")
								);
						celda.setCellStyle(estiloCentrado);
						   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            2, //primera fila (0-based)
					            2, //ultima fila  (0-based)
					            1, //primer celda (0-based)
					            7  //ultima celda   (0-based)
					    ));
						
						fila = hoja.createRow(3);
						fila = hoja.createRow(4);
						
						celda = fila.createCell((short)0);
						celda.setCellValue("Mostrar:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)1);
						celda.setCellValue((!reporteCuentasAhoMovBean.getDetMostrar().isEmpty())?reporteCuentasAhoMovBean.getDetMostrar().toUpperCase(): "TODOS");
						
						
						celda = fila.createCell((short)3);
						celda.setCellValue("Sucursal:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)4);
						celda.setCellValue((!reporteCuentasAhoMovBean.getDetSucursal().isEmpty())?reporteCuentasAhoMovBean.getDetSucursal().toUpperCase(): "TODOS");

						
						celda = fila.createCell((short)6);
						celda.setCellValue("Promotor:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)7);
						celda.setCellValue((!reporteCuentasAhoMovBean.getDetPromotor().isEmpty())?reporteCuentasAhoMovBean.getDetPromotor().toUpperCase(): "TODOS");
						
						celda = fila.createCell((short)9);
						celda.setCellValue("Estado:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)10);
						celda.setCellValue((!reporteCuentasAhoMovBean.getDetEstado().isEmpty())?reporteCuentasAhoMovBean.getDetEstado().toUpperCase(): "TODOS");
						
						
						
						
						fila = hoja.createRow(5);
						
						celda = fila.createCell((short)0);
						celda.setCellValue("Tipo Cuenta:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)1);
						celda.setCellValue((!reporteCuentasAhoMovBean.getDetTipoCuenta().isEmpty())?reporteCuentasAhoMovBean.getDetTipoCuenta().toUpperCase(): "TODOS");
						
						celda = fila.createCell((short)3);
						celda.setCellValue("Moneda:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)4);
						celda.setCellValue((!reporteCuentasAhoMovBean.getDetMoneda().isEmpty())?reporteCuentasAhoMovBean.getDetMoneda().toUpperCase(): "TODOS");
						
						celda = fila.createCell((short)6);
						celda.setCellValue("Género");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)7);
						celda.setCellValue((!reporteCuentasAhoMovBean.getDetGenero().isEmpty())?reporteCuentasAhoMovBean.getDetGenero().toUpperCase(): "TODOS");
						
						celda = fila.createCell((short)9);
						celda.setCellValue("Municipio:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)10);
						celda.setCellValue((!reporteCuentasAhoMovBean.getDetMunicipio().isEmpty())?reporteCuentasAhoMovBean.getDetMunicipio().toUpperCase(): "TODOS");
						
						
						
						fila = hoja.createRow(6);
						
						celda = fila.createCell((short)0);
						celda.setCellValue("Nombre del Cliente");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)1);
						celda.setCellValue("N° Cuenta");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)2);
						celda.setCellValue("Etiqueta");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)3);
						celda.setCellValue("Cargos del Periodo");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)4);
						celda.setCellValue("Abonos del Periodo");
						celda.setCellStyle(estiloNeg8);
					
				
						celda = fila.createCell((short)5);
						celda.setCellValue("Fecha del Último Retiro/Cargo");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)6);
						celda.setCellValue("Fecha del Último Depósito");
						celda.setCellStyle(estiloNeg8);			

						celda = fila.createCell((short)7);
						celda.setCellValue("Saldo Actual");
						celda.setCellStyle(estiloNeg8);
						
						
						i=7;
						
						
						ReporteCuentasAhoMovBean reporteCuentasAhoMov = null;
						for(; iter < tamanioLista;iter++){
							reporteCuentasAhoMov = (ReporteCuentasAhoMovBean) listaCuentaAhoMov.get(iter);
							fila=hoja.createRow(i);
							celda=fila.createCell((short)0);
							celda.setCellValue(reporteCuentasAhoMov.getNombreCliente());
							
							celda=fila.createCell((short)1);
							celda.setCellValue(reporteCuentasAhoMov.getCuenta());
							
							celda=fila.createCell((short)2);
							celda.setCellValue(reporteCuentasAhoMov.getEtiqueta());
							
							celda=fila.createCell((short)3);
							celda.setCellValue(Double.parseDouble(reporteCuentasAhoMov.getCargos()));
							celda.setCellStyle(estiloFormatoDecimal);

							celda=fila.createCell((short)4);
							celda.setCellValue(Double.parseDouble(reporteCuentasAhoMov.getAbonos()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)5);
							if(reporteCuentasAhoMov.getFechaUltReti().equals("1900-01-01")){
								reporteCuentasAhoMov.setFechaUltReti("");
							}
							celda.setCellValue(reporteCuentasAhoMov.getFechaUltReti());
							
							
							celda=fila.createCell((short)6);
							if(reporteCuentasAhoMov.getFechaUltDepo().equals("1900-01-01")){
								reporteCuentasAhoMov.setFechaUltDepo("");
							}
							celda.setCellValue(reporteCuentasAhoMov.getFechaUltDepo());
							
							celda=fila.createCell((short)7);
							celda.setCellValue(Double.parseDouble(reporteCuentasAhoMov.getSaldo()));
							celda.setCellStyle(estiloFormatoDecimal);
							 totalAbonos += Double.parseDouble(reporteCuentasAhoMov.getAbonos());
							 totalCargos += Double.parseDouble(reporteCuentasAhoMov.getCargos());
							 totalSaldos += Double.parseDouble(reporteCuentasAhoMov.getSaldo());
							i++;
						}
						for(int celd=0; celd<=19; celd++)
							hoja.autoSizeColumn((short)celd);
					}
					
					
					
					i = i+1;
					fila=hoja.createRow(i);
					celda = fila.createCell((short)0);
					celda.setCellValue("Total General:");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue(totalCargos);
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)4);
					celda.setCellValue(totalAbonos);
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)7);
					celda.setCellValue(totalSaldos);
					celda.setCellStyle(estiloFormatoDecimal);
					
					i = i+1;
					fila=hoja.createRow(i);
					celda = fila.createCell((short)0);
					celda.setCellValue("Registros Exportados");
					celda.setCellStyle(estiloNeg8);
					
					i = i+1;
					fila=hoja.createRow(i);
					celda=fila.createCell((short)0);
					celda.setCellValue(tamanioLista);
					}
				else{
				hoja = libro.createSheet();
				fila = hoja.createRow(0);
	 			celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue(reporteCuentasAhoMovBean.getNomInstitucion() );
				celda.setCellStyle(estiloCentrado);
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            7  //ultima celda   (0-based)
			    ));
			    HSSFCell celdaUsu= fila.createCell((short)10);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg8);	
				celdaUsu = fila.createCell((short)11);
				celdaUsu.setCellValue((!reporteCuentasAhoMovBean.getClaveUsuario().isEmpty())?reporteCuentasAhoMovBean.getClaveUsuario(): "TODOS");
				String fechaVar=reporteCuentasAhoMovBean.getFechaActual();
				fila = hoja.createRow(1);
				HSSFCell celdaFec = fila.createCell((short)10);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg8);	
				celdaFec = fila.createCell((short)11);
				celdaFec.setCellValue(fechaVar);
				fila = hoja.createRow(2);
				celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Reporte de "+safilocaleCuenta+" del "+ ((!reporteCuentasAhoMovBean.getFechaInicial().isEmpty())?reporteCuentasAhoMovBean.getFechaInicial(): "1900-01-01")+
						" al "+ ((!reporteCuentasAhoMovBean.getFechaFinal().isEmpty())?reporteCuentasAhoMovBean.getFechaFinal(): "2020-01-01")
						);
				celda.setCellStyle(estiloCentrado);
				   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            7  //ultima celda   (0-based)
			    ));
				fila = hoja.createRow(3);
				fila = hoja.createRow(4);
				celda = fila.createCell((short)0);
				celda.setCellValue("Mostrar:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)1);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetMostrar().isEmpty())?reporteCuentasAhoMovBean.getDetMostrar().toUpperCase(): "TODOS");
				
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Sucursal:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)4);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetSucursal().isEmpty())?reporteCuentasAhoMovBean.getDetSucursal().toUpperCase(): "TODOS");

				
				celda = fila.createCell((short)6);
				celda.setCellValue("Promotor:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)7);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetPromotor().isEmpty())?reporteCuentasAhoMovBean.getDetPromotor().toUpperCase(): "TODOS");
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Estado:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)10);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetEstado().isEmpty())?reporteCuentasAhoMovBean.getDetEstado().toUpperCase(): "TODOS");
				
				
				
				
				fila = hoja.createRow(5);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Tipo Cuenta:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)1);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetTipoCuenta().isEmpty())?reporteCuentasAhoMovBean.getDetTipoCuenta().toUpperCase(): "TODOS");
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Moneda:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)4);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetMoneda().isEmpty())?reporteCuentasAhoMovBean.getDetMoneda().toUpperCase(): "TODOS");
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Género");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)7);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetGenero().isEmpty())?reporteCuentasAhoMovBean.getDetGenero().toUpperCase(): "TODOS");
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Municipio:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)10);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetMunicipio().isEmpty())?reporteCuentasAhoMovBean.getDetMunicipio().toUpperCase(): "TODOS");
				
				fila = hoja.createRow(7);
				celda = fila.createCell((short)1);
				celda.setCellValue("(No existen Movimientos de Cuenta de Ahorro)");
				celda.setCellStyle(estiloNeg8);
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            7, //primera fila (0-based)
			            7, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            7  //ultima celda   (0-based)
			    ));
				}
				
			}else{

				hoja = libro.createSheet();
				fila = hoja.createRow(0);
	 			celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue(reporteCuentasAhoMovBean.getNomInstitucion() );
				celda.setCellStyle(estiloCentrado);
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            7  //ultima celda   (0-based)
			    ));
			    HSSFCell celdaUsu= fila.createCell((short)10);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg8);	
				celdaUsu = fila.createCell((short)11);
				celdaUsu.setCellValue((!reporteCuentasAhoMovBean.getClaveUsuario().isEmpty())?reporteCuentasAhoMovBean.getClaveUsuario(): "TODOS");
				String fechaVar=reporteCuentasAhoMovBean.getFechaActual();
				fila = hoja.createRow(1);
				HSSFCell celdaFec = fila.createCell((short)10);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg8);	
				celdaFec = fila.createCell((short)11);
				celdaFec.setCellValue(fechaVar);
				fila = hoja.createRow(2);
				celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Reporte de "+safilocaleCuenta+" del "+((!reporteCuentasAhoMovBean.getFechaInicial().isEmpty())?reporteCuentasAhoMovBean.getFechaInicial(): "1900-01-01")+
						" al "+ ((!reporteCuentasAhoMovBean.getFechaFinal().isEmpty())?reporteCuentasAhoMovBean.getFechaFinal(): "2020-01-01")
						);
				celda.setCellStyle(estiloCentrado);
				   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            7  //ultima celda   (0-based)
			    ));
				fila = hoja.createRow(3);
				fila = hoja.createRow(4);
				celda = fila.createCell((short)0);
				celda.setCellValue("Mostrar:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)1);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetMostrar().isEmpty())?reporteCuentasAhoMovBean.getDetMostrar().toUpperCase(): "TODOS");
				
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Sucursal:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)4);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetSucursal().isEmpty())?reporteCuentasAhoMovBean.getDetSucursal().toUpperCase(): "TODOS");

				
				celda = fila.createCell((short)6);
				celda.setCellValue("Promotor:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)7);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetPromotor().isEmpty())?reporteCuentasAhoMovBean.getDetPromotor().toUpperCase(): "TODOS");
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Estado:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)10);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetEstado().isEmpty())?reporteCuentasAhoMovBean.getDetEstado().toUpperCase(): "TODOS");
				
				
				
				
				fila = hoja.createRow(5);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Tipo Cuenta:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)1);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetTipoCuenta().isEmpty())?reporteCuentasAhoMovBean.getDetTipoCuenta().toUpperCase(): "TODOS");
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Moneda:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)4);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetMoneda().isEmpty())?reporteCuentasAhoMovBean.getDetMoneda().toUpperCase(): "TODOS");
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Género");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)7);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetGenero().isEmpty())?reporteCuentasAhoMovBean.getDetGenero().toUpperCase(): "TODOS");
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Municipio:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)10);
				celda.setCellValue((!reporteCuentasAhoMovBean.getDetMunicipio().isEmpty())?reporteCuentasAhoMovBean.getDetMunicipio().toUpperCase(): "TODOS");
				
				fila = hoja.createRow(7);
				celda = fila.createCell((short)1);
				celda.setCellValue("(No existen Movimientos de Cuenta de Ahorro)");
				celda.setCellStyle(estiloNeg8);
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            7, //primera fila (0-based)
			            7, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            7  //ultima celda   (0-based)
			    ));
				
			}
			
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteMovimientosCuenta.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		//	log.info("Termina Reporte");
			}catch(Exception e){
			//	log.info("Error al crear el reporte: " + e.getMessage());
				e.printStackTrace();
			}//Fin del catch
		//} 
			
			
		return  listaCuentaAhoMov;
		
		
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

	public CuentasAhoMovServicio getCuentasAhoMovServicio() {
		return cuentasAhoMovServicio;
	}

	public void setCuentasAhoMovServicio(CuentasAhoMovServicio cuentasAhoMovServicio) {
		this.cuentasAhoMovServicio = cuentasAhoMovServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	
}
