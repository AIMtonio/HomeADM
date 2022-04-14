package pld.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
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

import pld.bean.ParametrosegoperBean;
import pld.bean.SeguimientoOperacionesRepBean;
import pld.servicio.ParametrosegoperServicio;

   
public class RepParametrosSegOperControlador  extends AbstractCommandController{

	ParametrosegoperServicio parametrosegoperServicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporExcel= 1 ;
	}
	
	public RepParametrosSegOperControlador () {
		setCommandClass(SeguimientoOperacionesRepBean.class);
		setCommandName("parametrosegoperBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		SeguimientoOperacionesRepBean reporteBean = (SeguimientoOperacionesRepBean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		int tipoLista = Enum_Con_TipRepor.ReporExcel;
		String htmlString= "";	
		List listaReportes = reporteSeguimientoOperaciones(tipoLista,reporteBean,response,request);
		return null;	
	}

	// Reporte de saldos capital de credito en excel
	public List  reporteSeguimientoOperaciones(int tipoLista,SeguimientoOperacionesRepBean reporteBean,  HttpServletResponse response,HttpServletRequest request){
		List listaRepote=null;
		listaRepote = parametrosegoperServicio.listaSegOp(tipoLista, reporteBean); 	
		String etiquetaSocio = request.getParameter("etiquetaSocio").toString();
		String fechaVar=reporteBean.getFechaSistema();
		int regExport = 0;
		
		// Creacion de Libro
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
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
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			

			HSSFCellStyle estiloDatosDerecha = libro.createCellStyle();
			estiloDatosDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);  
			
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

			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("ReporteSeguimientoOperaciones");
			HSSFRow fila= hoja.createRow(0);
		  	// inicio fecha, usuario,institucion y hora
			HSSFCell celdaUsu=fila.createCell((short)1);
			celdaUsu = fila.createCell((short)12);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)13);
			celdaUsu.setCellValue((!reporteBean.getNombreUsuario().isEmpty())?reporteBean.getNombreUsuario(): "TODOS");

			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
		  	celdaFec = fila.createCell((short)12);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)13);
			celdaFec.setCellValue(fechaVar);
			
			HSSFCell celdaInst=fila.createCell((short)1);
			celdaInst=fila.createCell((short)1);
			celdaInst.setCellValue(request.getParameter("nombreInstitucion"));
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            11  //ultima celda (0-based)
			    ));
			 celdaInst.setCellStyle(estiloDatosCentrado);

			Calendar calendario = new GregorianCalendar();
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)12);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)13);
			celdaHora.setCellValue(calendario.get(Calendar.HOUR_OF_DAY) + ":" + calendario.get(Calendar.MINUTE) + ":" + calendario.get(Calendar.SECOND));
			// fin fecha usuario,institucion y hora
			  
			HSSFCell celdaTit=fila.createCell((short)1);
			celdaTit = fila.createCell((short)1);
			celdaTit.setCellValue("Reporte de Seguimiento de Operaciones del "+reporteBean.getFechaInicio()+" al "+reporteBean.getFechaFin());
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            11  //ultima celda (0-based)
		    ));
			celdaTit.setCellStyle(estiloDatosCentrado);
			fila = hoja.createRow(4);
			fila = hoja.createRow(5);

			HSSFCell celda=fila.createCell((short)1);
			celda = fila.createCell((short)1);
			celda.setCellValue("Fecha Detección");
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("No. Cuenta");
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Número Mov.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Fecha");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Naturaleza");
			celda.setCellStyle(estiloNeg8);			

			celda = fila.createCell((short)6);
			celda.setCellValue("Cantidad");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)7);
			celda.setCellValue("Descripción");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Referencia");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Moneda");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)10);
			celda.setCellValue("No. "+etiquetaSocio);
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Tipo Persona");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Nacionalidad "+etiquetaSocio);
			celda.setCellStyle(estiloNeg8);
			

			celda = fila.createCell((short)13);
			celda.setCellValue("Acumulado Mensual");
			celda.setCellStyle(estiloNeg8);
			
			
		
			int numeroFila=6,iter=0;
			int tamanioLista = listaRepote.size();
			SeguimientoOperacionesRepBean reporteRegBean = null;
			for( iter=0; iter<tamanioLista; iter ++){
				reporteRegBean = (SeguimientoOperacionesRepBean) listaRepote.get(iter);
				fila=hoja.createRow(numeroFila);
				

				celda=fila.createCell((short)1);
				celda.setCellValue(reporteRegBean.getFechaDetec());
			
				
				celda=fila.createCell((short)2);
				celda.setCellValue(reporteRegBean.getCuentaAhoID());
			
				celda=fila.createCell((short)3);
				celda.setCellValue(reporteRegBean.getNumeroMov());

				celda=fila.createCell((short)4);
				celda.setCellValue(reporteRegBean.getFecha());

				celda=fila.createCell((short)5);
				celda.setCellValue(reporteRegBean.getNatMovimiento());
				
				celda=fila.createCell((short)6);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getCantidadMov()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)7);
				celda.setCellValue(reporteRegBean.getDescripcionMov());

				celda=fila.createCell((short)8);
				celda.setCellValue(reporteRegBean.getReferenciaMov());

				celda=fila.createCell((short)9);
				celda.setCellValue(reporteRegBean.getMonedaID());

				celda=fila.createCell((short)10);
				celda.setCellValue(reporteRegBean.getClienteID());

				celda=fila.createCell((short)11);
				celda.setCellValue(reporteRegBean.getTipoPersona());

				celda=fila.createCell((short)12);
				celda.setCellValue(reporteRegBean.getNacionCliente());

				celda=fila.createCell((short)13);
				if(Integer.parseInt(reporteRegBean.getTransaccion()) == 0){
					celda.setCellValue("Si");
				}else{
					celda.setCellValue("No");
				}
				numeroFila++;
			}

			numeroFila = numeroFila+2;
			fila=hoja.createRow(numeroFila); // Fila Registros Exportados
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);

			numeroFila = numeroFila+1;
			fila=hoja.createRow(numeroFila); // Fila Total de Registros Exportados
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);
			
			numeroFila = numeroFila+1;
			fila=hoja.createRow(numeroFila); // Anotaciones Especiales

			HSSFCell notas=fila.createCell((short)1);
			notas = fila.createCell((short)0);
			notas.setCellValue("* Indica que se trata de una persona física con actividad empresarial, para efectos de pld se considera como moral.");
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					numeroFila, //primera fila (0-based)
					numeroFila, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            7  //ultima celda (0-based)
		    ));
			
			for(int celd=0; celd<=18; celd++)
			hoja.autoSizeColumn((short)celd);
				
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=Seguimiento de Operaciones.xls");
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

	public ParametrosegoperServicio getParametrosegoperServicio() {
		return parametrosegoperServicio;
	}

	public void setParametrosegoperServicio(
			ParametrosegoperServicio parametrosegoperServicio) {
		this.parametrosegoperServicio = parametrosegoperServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
