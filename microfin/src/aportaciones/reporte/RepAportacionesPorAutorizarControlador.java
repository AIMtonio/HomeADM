package aportaciones.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
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
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;

public class RepAportacionesPorAutorizarControlador extends AbstractCommandController{
	
	public String nombreReporte = null;
	public String successView = null;
	public ParametrosSesionBean parametrosSesionBean = null;
	public AportacionesServicio aportacionesServicio = null;

	public static interface Enum_Reporte {
		int PDF = 1;
		int EXCEL = 2;
	}
	 
	public static interface Enum_TipoReporte {
		int APORTACIONESNoAutorizadas = 14;
	}

	public RepAportacionesPorAutorizarControlador() {
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		AportacionesBean aportacionesBean = (AportacionesBean) command;

		int tipoReporte = (request.getParameter("tipoRep") != null) ? Integer.parseInt(request.getParameter("tipoRep")) : 0;

		switch (tipoReporte) {
		case Enum_Reporte.PDF:
			ByteArrayOutputStream htmlStringPDF = reportePDF(aportacionesBean, nombreReporte, response, request);
			break;
		case Enum_Reporte.EXCEL:
			List<AportacionesBean>listaReportes = reporteEXCEL(Enum_TipoReporte.APORTACIONESNoAutorizadas, aportacionesBean, response, request);
			break;
		}
		
		return null;
	}
	
	//método para crear el reporte en pdf
	private ByteArrayOutputStream reportePDF(AportacionesBean aportacionBean, String nombreReporte, HttpServletResponse response, HttpServletRequest request) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = aportacionesServicio.aportacionesNoAutorizadasPDF(aportacionBean, nombreReporte, request);
			response.addHeader("Content-Disposition","inline; filename=AportacionesPorAutorizar.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return htmlStringPDF;
	}
	
	// Método para crear el reporte excel
	private List<AportacionesBean> reporteEXCEL(int tipoReporte, AportacionesBean aportacionesBean, HttpServletResponse response, HttpServletRequest request) {
		List lista = null; 
		lista = aportacionesServicio.lista(tipoReporte, aportacionesBean);
		String safilocaleCliente = request.getParameter("safilocaleCliente");
		
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
			
			//Crea un Fuente con tamaño 8 para informacion del reporte.
			HSSFFont fuente10= libro.createFont();
			fuente10.setFontHeightInPoints((short)10);
			fuente10.setFontName(HSSFFont.FONT_ARIAL);
			
			//Estilo de datos centrados Encabezado
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);

			//Estilo Formato Moneda (0.00)
			HSSFCellStyle estiloMoneda = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloMoneda.setDataFormat(format.getFormat("$#,##0.00"));
			
			//Estilo Formato de Tasa (0.0000)
			HSSFCellStyle estiloTasa = libro.createCellStyle();
			HSSFDataFormat formatTasa = libro.createDataFormat();
			estiloTasa.setDataFormat(formatTasa.getFormat("#,##0.0000"));

			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			HSSFCellStyle estiloIzquierda = libro.createCellStyle();
			estiloIzquierda.setFont(fuente10);
			estiloIzquierda.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			estiloIzquierda.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			HSSFCellStyle estiloCentradoCuerpo = libro.createCellStyle();
			estiloCentradoCuerpo.setFont(fuente10);
			estiloCentradoCuerpo.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentradoCuerpo.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Aportaciones por Autorizar");
			
		  	// inicio fecha, usuario,institucion y hora
			HSSFRow fila= hoja.createRow(0);
			HSSFCell celdaUsu=fila.createCell(1);
			celdaUsu = fila.createCell(11);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell(12);
			celdaUsu.setCellValue(((!parametrosSesionBean.getClaveUsuario().isEmpty())?parametrosSesionBean.getClaveUsuario(): "TODOS").toUpperCase());
			
			fila = hoja.createRow(1);
			String fechaVar = parametrosSesionBean.getFechaAplicacion().toString();
		  	HSSFCell celdaFec=fila.createCell(1);
		  	celdaFec = fila.createCell(11);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell(12);
			celdaFec.setCellValue(fechaVar);
			
			HSSFCell celdaInst=fila.createCell(1);
			celdaInst=fila.createCell(1);
			celdaInst.setCellValue(parametrosSesionBean.getNombreInstitucion());
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
			 celdaInst.setCellStyle(estiloDatosCentrado);	
			 
			 
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm:ss");	
			String horaVar=postFormater.format(calendario.getTime());
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell(1);
			celdaHora = fila.createCell(11);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell(12);
			celdaHora.setCellValue(horaVar);
			// fin fecha usuario,institucion y hora
		  
			HSSFCell celda=fila.createCell(1);
			celda = fila.createCell(1);
			celda.setCellValue("REPORTE DE APORTACIONES POR AUTORIZAR DEL " + fechaVar);
			celda.setCellStyle(estiloDatosCentrado);
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            10 //ultima celda   (0-based)
		    ));
			celda.setCellStyle(estiloDatosCentrado);				

			fila = hoja.createRow(4);

			int numCelda = 1;
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Tipo Aportación:");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell(numCelda++);
			celda.setCellValue(aportacionesBean.getDescripcion());
			
			numCelda++;
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Promotor:");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell(numCelda++);
			celda.setCellValue(aportacionesBean.getNombrePromotor());

			numCelda++;
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell(numCelda++);
			celda.setCellValue(aportacionesBean.getNombreSucursal());

			numCelda++;
			celda = fila.createCell(numCelda++);
			celda.setCellValue(safilocaleCliente + ":");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell(numCelda++);
			celda.setCellValue(aportacionesBean.getNombreCliente());
			
			// Creacion de fila
			fila = hoja.createRow(5);
			fila = hoja.createRow(6);

			numCelda = 1;
			// Encabezado de la tabla 
			celda = fila.createCell(numCelda++);
			celda.setCellValue("No. Aportación");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Número de " + safilocaleCliente);
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Nombre del " + safilocaleCliente);
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Tasa");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Tasa ISR");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Tasa Neta");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Plazo (Días)");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Fecha Vencimiento");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Interés Generado");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Interés Retenido");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Interés Recibir");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloCentrado);
			
			int numFila = 7, iter = 0;
			int tamanioLista = lista.size();
			AportacionesBean resultadoAportaciones = null;
			
			for( iter=0; iter<tamanioLista; iter ++){
				numCelda = 1;
				resultadoAportaciones = (AportacionesBean) lista.get(iter);
				fila=hoja.createRow(numFila);

				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getAportacionID());
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getClienteID());
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getNombreCliente());
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(Utileria.convierteDoble(resultadoAportaciones.getTasaFija()));
				celda.setCellStyle(estiloTasa);
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(Utileria.convierteDoble(resultadoAportaciones.getTasaISR()));
				celda.setCellStyle(estiloTasa);
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(Utileria.convierteDoble(resultadoAportaciones.getTasaNeta()));
				celda.setCellStyle(estiloTasa);
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(Utileria.convierteDoble(resultadoAportaciones.getMonto()));
				celda.setCellStyle(estiloMoneda);
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getPlazo());
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getFechaVencimiento());
				celda.setCellStyle(estiloCentradoCuerpo);
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(Utileria.convierteDoble(resultadoAportaciones.getInteresGenerado()));
				celda.setCellStyle(estiloMoneda); 
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(Utileria.convierteDoble(resultadoAportaciones.getInteresRetener()));
				celda.setCellStyle(estiloMoneda); 
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(Utileria.convierteDoble(resultadoAportaciones.getInteresRecibir()));
				celda.setCellStyle(estiloMoneda); 
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getEstatus()); 

				numFila ++;
			}
			
			fila=hoja.createRow(numFila++);
			celda = fila.createCell(0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);

			fila=hoja.createRow(numFila++);
			celda=fila.createCell(0);
			celda.setCellValue(tamanioLista);
			
			for(int celd=0; celd<=numCelda; celd++){
				hoja.autoSizeColumn((short)celd); 
			}
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=AportacionesPorAutorizar.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		} catch (Exception e){
			e.printStackTrace();
		}
		return lista;
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

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}
	
	

}
