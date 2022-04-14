package soporte.reporte;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.apache.log4j.Logger;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.io.ByteArrayOutputStream;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import soporte.bean.BitacoraHuellaBean;
import soporte.servicio.BitacoraHuellaServicio;

import javax.servlet.ServletOutputStream;

public class ReporteHuellaControlador extends AbstractCommandController{
	BitacoraHuellaServicio bitacoraHuellaServicio =null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public ReporteHuellaControlador() {
		setCommandClass(BitacoraHuellaBean.class);
		setCommandName("bitacoraHuellaBean");
	}
	
	public static interface Enum_Reporte_TipRepor{
		int cliente=1;
		int usuario=2;
	}
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command, BindException errors)throws Exception{
		MensajeTransaccionBean mensaje = null;
		BitacoraHuellaBean reporteHuellaBean= (BitacoraHuellaBean) command;		
		
		
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		int tipoPresentacion = Utileria.convierteEntero(request.getParameter("tipoPresentacion"));

		String fechaReporte=request.getParameter("fechaReporte");			
		String empresaID=request.getParameter("empresa");
		String fechaInicio = request.getParameter("fechaInicio");
		String fechaFin = request.getParameter("fechaFin");
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
			0;
				reporteHuellaBean.setFechaInicio(fechaInicio);
				reporteHuellaBean.setFechaFin(fechaFin);
				reporteHuellaBean.setEmpresaID(empresaID);
				reporteHuellaBean.setFechaReporte(fechaReporte);
		
		String htmlString= "";
		
		switch(tipoPresentacion){
		case Enum_Reporte_TipRepor.cliente:		
				 List listaReportes = clienteExcel(tipoLista,reporteHuellaBean,response);
			break;
			case Enum_Reporte_TipRepor.usuario:
				 List listaReportes2 = usuarioExcel(tipoLista,reporteHuellaBean,response);
			break;

		}
		
		return null;
	}
	private List clienteExcel(int tipoLista,BitacoraHuellaBean reporteHuellaBean, HttpServletResponse response) {
		List listaCartera=null;
		listaCartera = bitacoraHuellaServicio.listaReportesHuella(tipoLista,reporteHuellaBean);
		int regExport = 0;
		try {
			XSSFWorkbook libro = new XSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			XSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			XSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			
			
			XSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			

			//Estilo negrita de 8  y color de fondo
			XSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			
			
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			XSSFCellStyle estiloFormatoTasa = libro.createCellStyle();
			XSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			estiloFormatoTasa.setDataFormat(format.getFormat("###0.00"));
			// Creacion de hoja					
			XSSFSheet hoja = libro.createSheet("Reporte de Huella Cliente");
			XSSFRow fila= hoja.createRow(0);
			// inicio usuario,fecha y hora
			XSSFCell celdaUsu=fila.createCell((short)1);
			 
			celdaUsu = fila.createCell((short)7);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)8);
			celdaUsu.setCellValue((!reporteHuellaBean.getNombreUsuario().isEmpty())?reporteHuellaBean.getNombreUsuario(): "TODOS");
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            8, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
			 
				String horaVar="";
				String fechaVar=reporteHuellaBean.getParFechaEmision();

				
				int itera=0;
				BitacoraHuellaBean aportacionHora = null;
				if(!listaCartera.isEmpty()){
				for( itera=0; itera<1; itera ++){

					aportacionHora = (BitacoraHuellaBean) listaCartera.get(itera);
					horaVar= aportacionHora.getHora();
					
				}
				}
				
				fila = hoja.createRow(1);
				XSSFCell celdaFec=fila.createCell((short)1);
				celdaFec = fila.createCell((short)7);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg8);	
				celdaFec = fila.createCell((short)8);
				celdaFec.setCellValue(fechaVar);
				 
				
				// Nombre Institucion	
				XSSFCell celdaInst=fila.createCell((short)2);
				celdaInst.setCellStyle(estiloNeg10);
				celdaInst.setCellValue(reporteHuellaBean.getNombreInstitucion());
				celdaInst.setCellStyle(estiloDatosCentrado);

									
				  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            2, //primer celda (0-based)
				            6  //ultima celda   (0-based)
				    ));
					

				fila = hoja.createRow(2);
				XSSFCell celdaHora=fila.createCell((short)1);
				Calendar calendario = new GregorianCalendar();
				fila = hoja.createRow(2);
				celdaHora=fila.createCell((short)7);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNeg8);	
				celdaHora = fila.createCell((short)8);
				celdaHora.setCellValue(calendario.get(Calendar.HOUR_OF_DAY) + ":" + calendario.get(Calendar.MINUTE));
				
				   // fin susuario,fecha y hora
				
				XSSFCell celda=fila.createCell((short)2);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("REPORTE DE OPERACIONES DEL CLIENTE DEL " +reporteHuellaBean.getFechaInicio()  +" AL "+reporteHuellaBean.getFechaFin());
				celda.setCellStyle(estiloDatosCentrado);
			
			    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            2, //primer celda (0-based)
			            6  //ultima celda   (0-based)
			    ));
			    
			    // Creacion de fila
				fila = hoja.createRow(4);
				fila = hoja.createRow(5);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Num. Cliente");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Nombre Cliente");
				celda.setCellStyle(estiloNeg8);
			
				celda = fila.createCell((short)2);
				celda.setCellValue("Tipo Operación");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Descripción Operación");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Fecha");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Hora");
				celda.setCellStyle(estiloNeg8);
			
				celda = fila.createCell((short)6);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Nombre Sucursal");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Caja");
			    celda.setCellStyle(estiloNeg8);
				
			    
				int i=6,iter=0;
				int tamanioLista = listaCartera.size();
				BitacoraHuellaBean cartera = null;
				for( iter=0; iter<tamanioLista; iter ++){
					
						cartera = (BitacoraHuellaBean) listaCartera.get(iter);
						fila=hoja.createRow(i);
							
						celda=fila.createCell((short)0);
						celda.setCellValue(cartera.getUsuarioID());
						
						celda=fila.createCell((short)1);
						celda.setCellValue(cartera.getNombreUsuario());
						
						celda=fila.createCell((short)2);
						celda.setCellValue(cartera.getTipoOperacion());
						
						celda=fila.createCell((short)3);
						celda.setCellValue(cartera.getDescripcionOperacion());
						
						celda=fila.createCell((short)4);
						celda.setCellValue(cartera.getFecha());
						
						celda=fila.createCell((short)5);
						celda.setCellValue(cartera.getHora());
						
						celda=fila.createCell((short)6);
						celda.setCellValue(cartera.getSucursalOperacion());
						
						celda=fila.createCell((short)7);
						celda.setCellValue(cartera.getNombreSucursal());
						
						celda=fila.createCell((short)8);
						celda.setCellValue(cartera.getCajaID());
						i++;
				}
				
				i = i+2;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				i = i+1;
				fila=hoja.createRow(i);
				celda=fila.createCell((short)0);
				celda.setCellValue(tamanioLista);
				
				i = i+1;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)0);
				celda.setCellValue("SP-BITACORAHUELLAREP");
				celda.setCellStyle(estiloNeg8);

				for(int celd=0; celd<=13; celd++)
				hoja.autoSizeColumn((short)celd);
			
									
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteOperaciones.xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
				}
		catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		//}
		return listaCartera;
	}
	
	private List usuarioExcel(int tipoLista,BitacoraHuellaBean reporteHuellaBean, HttpServletResponse response) {
		List listaCartera=null;
		listaCartera = bitacoraHuellaServicio.listaReportesHuella(tipoLista,reporteHuellaBean);
		int regExport = 0;
		try {
			XSSFWorkbook libro = new XSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			XSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			XSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			
			
			XSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			

			//Estilo negrita de 8  y color de fondo
			XSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			
			
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			XSSFCellStyle estiloFormatoTasa = libro.createCellStyle();
			XSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			estiloFormatoTasa.setDataFormat(format.getFormat("###0.00"));
			// Creacion de hoja					
			XSSFSheet hoja = libro.createSheet("Reporte de Huella Usuario");
			XSSFRow fila= hoja.createRow(0);
			// inicio usuario,fecha y hora
			XSSFCell celdaUsu=fila.createCell((short)1);
			 
			celdaUsu = fila.createCell((short)7);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)8);
			celdaUsu.setCellValue((!reporteHuellaBean.getNombreUsuario().isEmpty())?reporteHuellaBean.getNombreUsuario(): "TODOS");
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            8, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
			 
				String horaVar="";
				String fechaVar=reporteHuellaBean.getParFechaEmision();

				
				int itera=0;
				BitacoraHuellaBean aportacionHora = null;
				if(!listaCartera.isEmpty()){
				for( itera=0; itera<1; itera ++){

					aportacionHora = (BitacoraHuellaBean) listaCartera.get(itera);
					horaVar= aportacionHora.getHora();
					
				}
				}
				
				fila = hoja.createRow(1);
				XSSFCell celdaFec=fila.createCell((short)1);
				celdaFec = fila.createCell((short)7);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg8);	
				celdaFec = fila.createCell((short)8);
				celdaFec.setCellValue(fechaVar);
				
				// Nombre Institucion	
				XSSFCell celdaInst=fila.createCell((short)2);
				celdaInst.setCellStyle(estiloNeg10);
				celdaInst.setCellValue(reporteHuellaBean.getNombreInstitucion());
				celdaInst.setCellStyle(estiloDatosCentrado);

									
				  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            2, //primer celda (0-based)
				            6  //ultima celda   (0-based)
				    ));
					

				fila = hoja.createRow(2);
				Calendar calendario = new GregorianCalendar();
				XSSFCell celdaHora=fila.createCell((short)1);
				celdaHora = fila.createCell((short)7);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNeg8);	
				celdaHora = fila.createCell((short)8);
				celdaHora.setCellValue(calendario.get(Calendar.HOUR_OF_DAY) + ":" + calendario.get(Calendar.MINUTE));
				
				   // fin susuario,fecha y hora
				
				XSSFCell celda=fila.createCell((short)2);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("REPORTE DE OPERACIONES DEL USUARIO DEL " +reporteHuellaBean.getFechaInicio()  +" AL "+reporteHuellaBean.getFechaFin());
				celda.setCellStyle(estiloDatosCentrado);
			
			    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            2, //primer celda (0-based)
			            6  //ultima celda   (0-based)
			    ));
			    
			    // Creacion de fila
				fila = hoja.createRow(4);
				fila = hoja.createRow(5);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Num. Usuario");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Nombre Usuario");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Autorización");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Fecha");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Hora");
				celda.setCellStyle(estiloNeg8);
			
				celda = fila.createCell((short)5);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Nombre Sucursal");
				celda.setCellStyle(estiloNeg8);
				
				
			    
				int i=6,iter=0;
				int tamanioLista = listaCartera.size();
				BitacoraHuellaBean cartera = null;
				for( iter=0; iter<tamanioLista; iter ++){
					
						cartera = (BitacoraHuellaBean) listaCartera.get(iter);
						fila=hoja.createRow(i);
						
						celda=fila.createCell((short)0);
						celda.setCellValue(cartera.getUsuarioID());
							
						celda=fila.createCell((short)1);
						celda.setCellValue(cartera.getNombreUsuario());
						
						celda=fila.createCell((short)2);
						celda.setCellValue(cartera.getDescripcionOperacion());
						
						celda=fila.createCell((short)3);
						celda.setCellValue(cartera.getFecha());
						
						celda=fila.createCell((short)4);
						celda.setCellValue(cartera.getHora());
						
						celda=fila.createCell((short)5);
						celda.setCellValue(cartera.getSucursalOperacion());
						
						celda=fila.createCell((short)6);
						celda.setCellValue(cartera.getNombreSucursal());
						i++;
				}
				
				i = i+2;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				i = i+1;
				fila=hoja.createRow(i);
				celda=fila.createCell((short)0);
				celda.setCellValue(tamanioLista);
				
				i = i+1;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)0);
				celda.setCellValue("SP-BITACORAHUELLAREP");
				celda.setCellStyle(estiloNeg8);

				for(int celd=0; celd<=13; celd++)
				hoja.autoSizeColumn((short)celd);
			
									
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteOperaciones.xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
				}
		catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		//}
		return listaCartera;
	}
	public BitacoraHuellaServicio getBitacoraHuellaServicio() {
		return bitacoraHuellaServicio;
	}
	public void setBitacoraHuellaServicio(
			BitacoraHuellaServicio bitacoraHuellaServicio) {
		this.bitacoraHuellaServicio = bitacoraHuellaServicio;
	}
	public Logger getLoggerSAFI() {
		return loggerSAFI;
	}
}
