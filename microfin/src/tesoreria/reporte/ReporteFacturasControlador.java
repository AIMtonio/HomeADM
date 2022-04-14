package tesoreria.reporte;



import general.bean.ParametrosAuditoriaBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Date;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.servicio.FacturaprovServicio;
import tesoreria.servicio.ImpuestosServicio;
import tesoreria.bean.FacturaprovBean;
import tesoreria.bean.ImpuestosBean;

 

public class ReporteFacturasControlador extends AbstractCommandController {
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	FacturaprovServicio facturaprovServicio = null;
	ImpuestosServicio impuestosServicio = null;
	String nombreReporte = null;
	String successView = null;		
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
		  int  ReporExcelDet=4; 
	}
 	public ReporteFacturasControlador(){
 		setCommandClass(FacturaprovBean.class);
 		setCommandName("facturaBean");
 	}
    
 	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		FacturaprovBean facturaprovBean = (FacturaprovBean) command;
 		 
 		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
	
		int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;		
			facturaprovServicio.getFacturaprovDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			String htmlString= "";
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPantalla:
					 htmlString = facturaprovServicio.reporteFacturasPantalla(facturaprovBean, nombreReporte);
				break;					
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporteFacturasPDF(facturaprovBean, nombreReporte, response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:
					 List <FacturaprovBean>listaReportes = reporteFacturasExcel(tipoLista,facturaprovBean,response);
				break;
				
				case Enum_Con_TipRepor.ReporExcelDet:
					 List listaRepExcelDet = reporteFacExcelDet(tipoLista,facturaprovBean,response);
				break;
			}				
				if(tipoReporte ==Enum_Con_TipRepor.ReporPantalla ){
					return new ModelAndView(getSuccessView(), "reporte", htmlString);
				}else {
					return null;
				}
 	}
 	 	
 	// Reporte  de  ministraciones  en PDF
	public ByteArrayOutputStream reporteFacturasPDF(FacturaprovBean facturaprovBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = facturaprovServicio.reporteFacturasPDF(facturaprovBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteFacturas.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch(Exception e){
			e.printStackTrace();
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	return htmlStringPDF;
	}
	
	public List reporteFacturasExcel(int tipoLista,FacturaprovBean facturaprovBean,HttpServletResponse response) throws Exception{
		String reporteExcel=null;
			reporteExcel = facturaprovServicio.reporteExcelLista(tipoLista,facturaprovBean, response);

			Date FechaD = new Date();
			java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("H:mm");
			String hora = sdf.format(FechaD);
			facturaprovBean.setHoraEmision(hora);
		
			try {
			Workbook libro = new SXSSFWorkbook();
								
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);	
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			Font fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			CellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			CellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);  
			
			CellStyle estiloCentrado = libro.createCellStyle();			
			estiloCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			estiloCentrado.setFont(fuenteNegrita10);
			
			//estilo centrado para id y fechas
			CellStyle estiloCentrado2 = libro.createCellStyle();			
			estiloCentrado2.setAlignment((short)CellStyle.ALIGN_CENTER);
			
			//Estilo negrita de 8  y color de fondo
			CellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(CellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
			
			// Creacion de hoja					
			Sheet hoja = libro.createSheet("Reporte Facturas");			
			Row fila= hoja.createRow(0);
			
			// inicio usuario,fecha y hora
			
			Cell celdaUsu=fila.createCell((short)1);
			
			celdaUsu = fila.createCell((short)17);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			
			celdaUsu = fila.createCell((short)18);
			celdaUsu.setCellValue((!facturaprovBean.getNombreUsuario().isEmpty())?facturaprovBean.getNombreUsuario():"TODOS");			
			
			String horaVar=facturaprovBean.getHoraEmision();
			String fechaVar=facturaprovBean.getParFechaEmision();
			
			fila = hoja.createRow(1);
			Cell celdaFec=fila.createCell((short)1);
					
			celdaFec = fila.createCell((short)17);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)18);
			celdaFec.setCellValue(fechaVar);
						
			// Nombre Institucion	
			Cell celdaInst=fila.createCell((short)0);
			celdaInst.setCellValue(facturaprovBean.getNombreInstitucion());
								
			  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            16  //ultima celda   (0-based)
			    ));			 
			 celdaInst.setCellStyle(estiloCentrado);
			 
			 fila = hoja.createRow(2);
			Cell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)17);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)18);
			celdaHora.setCellValue(horaVar);
			
			// Titulo del Reporte
			Cell celda=fila.createCell((short)0);					
			celda.setCellValue("REPORTE FACTURAS DEL "+facturaprovBean.getFechaInicio()+" AL "+facturaprovBean.getFechaFin());
							
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            16  //ultima celda   (0-based)
			    ));				 
			 celda.setCellStyle(estiloCentrado);
			 
			// Creacion de fila
			fila = hoja.createRow(3); // Fila vacia
			fila = hoja.createRow(4);// Campos
			celda = fila.createCell((short)1);
			celda.setCellValue("Estatus: ");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)2);
			celda.setCellValue((!facturaprovBean.getNombreEstatus().equals("0"))	? facturaprovBean.getNombreEstatus() :"TODOS");
			
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Proveedor:	");			
			celda.setCellStyle(estiloNeg8);						
			celda = fila.createCell((short)9);
			celda.setCellValue((!facturaprovBean.getNombreProveedor().equals("")? facturaprovBean.getNombreProveedor():"TODOS"));
			
			
			fila = hoja.createRow(5);
			celda = fila.createCell((short)1);
			celda.setCellValue("Sucursal:   ");
			celda.setCellStyle(estiloNeg8);			
			celda = fila.createCell((short)2);
			celda.setCellValue((!facturaprovBean.getNombreSucursal().equals("0")? facturaprovBean.getNombreSucursal():"TODAS"));
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Tipo Captura:	");			
			celda.setCellStyle(estiloNeg8);						
			celda = fila.createCell((short)9);
			celda.setCellValue(facturaprovBean.getDesTipoCaptura());

			fila = hoja.createRow(6); // Fila vacia
			fila = hoja.createRow(7);// Campos
			
			// se recorre lista para las columnas del reporte
			List reporteExcelColumnas=null;
			reporteExcelColumnas = facturaprovServicio.reporteExcel(4,facturaprovBean, response);

			int c=8,iter=0;
			int tamanioCol= reporteExcelColumnas.size();
			FacturaprovBean facturaBean = null;
			String nombreColum;	
			
			facturaBean= (FacturaprovBean)reporteExcelColumnas.get(iter);
			StringTokenizer tokensColm = new StringTokenizer(facturaBean.getColumnas(), ",");
			
				int noCol = 1;
				
				while(tokensColm.hasMoreTokens()){			
					nombreColum = tokensColm.nextToken();
					celda=fila.createCell((short)noCol);
					celda.setCellValue(nombreColum);
					hoja.autoSizeColumn((short)noCol);
					celda.setCellStyle(estiloNeg8);
					noCol ++;
					
				}
				
					
			// Recorremos la lista para la parte de los datos del reporte	
			int j=9;
			int tamanio = 0;
			ImpuestosBean impuestosBean = new ImpuestosBean();
			impuestosBean = impuestosServicio.consulta(4, impuestosBean);
			int numImp = impuestosBean.getNumImpuestos();
			
			StringTokenizer tokensFilas = new StringTokenizer(reporteExcel, "[");		

				while(tokensFilas.hasMoreTokens()){		
					String stringFila;
					String tokensCampos[];

					fila=hoja.createRow(j);
					stringFila = tokensFilas.nextToken();
					tokensCampos = herramientas.Utileria.divideString(stringFila, "]");

					StringTokenizer tokensColumnas = new StringTokenizer(stringFila,"]");
					
					int noColumna = 1;
						while(tokensColumnas.hasMoreTokens()){	
							String valorColumna;							
							valorColumna = tokensColumnas.nextToken();							
							celda=fila.createCell((short)noColumna);							
							
							int valorCelda = numImp+7+5;
							
							if(noColumna > 10 && noColumna  < valorCelda){
							celda.setCellValue(Utileria.convierteDoble(valorColumna));	
							celda.setCellStyle(estiloFormatoDecimal);
							}else{
								celda.setCellValue(valorColumna);	
							}
							noColumna ++;
						}					
					j++;	
					tamanio = j-9;
					
				}
			
			
			j = j+2;
			
			fila=hoja.createRow(j); // Fila Registros Exportados
			celda = fila.createCell((short)1);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			celda=fila.createCell((short)17);
			celda.setCellValue("Procedure:");
			celda.setCellStyle(estiloNeg8);
			
			celda=fila.createCell((short)18);
			celda.setCellValue("FACTURAREP");
			
			j = j+1;
			fila=hoja.createRow(j); // Fila Registros Exportados
			celda=fila.createCell((short)1);
			celda.setCellValue(tamanio);
			
			for(int celd=2; celd<=23; celd++)
			hoja.autoSizeColumn((short)celd);
			
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteFacturas.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
			
		return null;
	}
	
	//Reporte de excel de facturas pagadas en modo detallado
	public List reporteFacExcelDet(int tipoLista,FacturaprovBean facturaprovBean,HttpServletResponse response) throws Exception{
		String reporteExcel=null;
			reporteExcel = facturaprovServicio.reporteExcelLista(tipoLista,facturaprovBean, response);

			Date FechaD = new Date();
			// java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy/MM/dd");
			java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("H:mm");
			String hora = sdf.format(FechaD);
			facturaprovBean.setHoraEmision(hora);
			
		
			try {
			Workbook libro = new SXSSFWorkbook();
								
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);	
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			Font fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			CellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			CellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);  
			
			CellStyle estiloCentrado = libro.createCellStyle();			
			estiloCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			estiloCentrado.setFont(fuenteNegrita10);
			
			//estilo centrado para id y fechas
			CellStyle estiloCentrado2 = libro.createCellStyle();			
			estiloCentrado2.setAlignment((short)CellStyle.ALIGN_CENTER);
			
			//Estilo negrita de 8  y color de fondo
			CellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(CellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
			
			// Creacion de hoja					
			Sheet hoja = libro.createSheet("Reporte Facturas");			
			Row fila= hoja.createRow(0);
			
			// inicio usuario,fecha y hora
			
			Cell celdaUsu=fila.createCell((short)1);
			
			celdaUsu = fila.createCell((short)17);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			
			celdaUsu = fila.createCell((short)18);
			celdaUsu.setCellValue((!facturaprovBean.getNombreUsuario().isEmpty())?facturaprovBean.getNombreUsuario():"TODOS");			
			
			String horaVar=facturaprovBean.getHoraEmision();
			String fechaVar=facturaprovBean.getParFechaEmision();
			
			fila = hoja.createRow(1);
			Cell celdaFec=fila.createCell((short)1);
					
			celdaFec = fila.createCell((short)17);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)18);
			celdaFec.setCellValue(fechaVar);
						
			// Nombre Institucion	
			Cell celdaInst=fila.createCell((short)1);
			//celdaInst.setCellStyle(estiloNeg10);
			celdaInst.setCellValue(facturaprovBean.getNombreInstitucion());
								
			  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            16  //ultima celda   (0-based)
			    ));			 
			 celdaInst.setCellStyle(estiloCentrado);
			 
			 fila = hoja.createRow(2);
			Cell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)17);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)18);
			celdaHora.setCellValue(horaVar);
			
			// Titulo del Reporte
			Cell celda=fila.createCell((short)1);					
			celda.setCellValue("REPORTE FACTURAS DEL "+facturaprovBean.getFechaInicio()+" AL "+facturaprovBean.getFechaFin());
							
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            16  //ultima celda   (0-based)
			    ));				 
			 celda.setCellStyle(estiloCentrado);
			 
			// Creacion de fila
			fila = hoja.createRow(3); // Fila vacia
			fila = hoja.createRow(4);// Campos
			celda = fila.createCell((short)1);
			celda.setCellValue("Estatus: ");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)2);
			celda.setCellValue((!facturaprovBean.getNombreEstatus().equals("0"))	? facturaprovBean.getNombreEstatus() :"TODOS");
			
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Proveedor:	");			
			celda.setCellStyle(estiloNeg8);						
			celda = fila.createCell((short)5);
			celda.setCellValue((!facturaprovBean.getNombreProveedor().equals("")? facturaprovBean.getNombreProveedor():"TODOS"));
			
			
			fila = hoja.createRow(5);
			celda = fila.createCell((short)1);
			celda.setCellValue("Sucursal:   ");
			celda.setCellStyle(estiloNeg8);			
			celda = fila.createCell((short)2);
			celda.setCellValue((!facturaprovBean.getNombreSucursal().equals("0")? facturaprovBean.getNombreSucursal():"TODAS"));
			

			fila = hoja.createRow(6); // Fila vacia
			fila = hoja.createRow(7);// Campos	
			
			// se recorre lista para las columnas del reporte
			List reporteExcelColumnas=null;
			reporteExcelColumnas = facturaprovServicio.reporteExcel(4,facturaprovBean, response);

			int c=8,iter=0;
			int tamanioCol= reporteExcelColumnas.size();
			FacturaprovBean facturaBean = null;
			String nombreColum;	
			
			facturaBean= (FacturaprovBean)reporteExcelColumnas.get(iter);
			StringTokenizer tokensColm = new StringTokenizer(facturaBean.getColumnas(), ",");
			
				int noCol = 1;
				
				while(tokensColm.hasMoreTokens()){			
					nombreColum = tokensColm.nextToken();
					celda=fila.createCell((short)noCol);
					celda.setCellValue(nombreColum);
					hoja.autoSizeColumn((short)noCol);
					celda.setCellStyle(estiloNeg8);
					noCol ++;
					
				}
				
					
			// Recorremos la lista para la parte de los datos del reporte	
			int j=9;
			int tamanio = 0;
			
			ImpuestosBean impuestosBean = new ImpuestosBean();
			impuestosBean = impuestosServicio.consulta(4, impuestosBean);
			int numImp = impuestosBean.getNumImpuestos();
			
			StringTokenizer tokensFilas = new StringTokenizer(reporteExcel, "[");		

				while(tokensFilas.hasMoreTokens()){		
					String stringFila;
					String tokensCampos[];

					fila=hoja.createRow(j);
					stringFila = tokensFilas.nextToken();
					tokensCampos = herramientas.Utileria.divideString(stringFila, "]");

					StringTokenizer tokensColumnas = new StringTokenizer(stringFila,"]");
					
					int noColumna = 1;
						while(tokensColumnas.hasMoreTokens()){	
							String valorColumna;							
							valorColumna = tokensColumnas.nextToken();							
							celda=fila.createCell((short)noColumna);
							
							int valorCelda = numImp+10+6;
							
							if(noColumna > 9 && noColumna  < valorCelda){
							celda.setCellValue(Utileria.convierteDoble(valorColumna));	
							celda.setCellStyle(estiloFormatoDecimal);
							}else{
								celda.setCellValue(valorColumna);	
							}
							
							
							noColumna ++;
						}
						
					j++;	
					tamanio = j-9;
				}
				
				
			j = j+2;
			
			
			fila=hoja.createRow(j); // Fila Registros Exportados
			celda = fila.createCell((short)1);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			celda=fila.createCell((short)17);
			celda.setCellValue("Procedure:");
			celda.setCellStyle(estiloNeg8);
			
			celda=fila.createCell((short)18);
			celda.setCellValue("FACTURAREP");
			
			j = j+1;
			fila=hoja.createRow(j); // Fila Registros Exportados
			celda=fila.createCell((short)1);
			celda.setCellValue(tamanio);
			
			for(int celd=2; celd<=26; celd++)
			hoja.autoSizeColumn((short)celd);
			
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteFacturasPagadas.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
			
		return null;

	}
	


	public void setFacturaprovServicio(FacturaprovServicio facturaprovServicio) {
		this.facturaprovServicio = facturaprovServicio;
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

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public ImpuestosServicio getImpuestosServicio() {
		return impuestosServicio;
	}

	public void setImpuestosServicio(ImpuestosServicio impuestosServicio) {
		this.impuestosServicio = impuestosServicio;
	}

	

}
