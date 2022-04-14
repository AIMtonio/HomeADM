package tesoreria.reporte;



import general.bean.ParametrosAuditoriaBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
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
import tesoreria.bean.CargaMasivaFacturasBean;
import tesoreria.servicio.CargaMasivaFacturasServicio;


 

public class ReporteProvCargaMasivaControlador extends AbstractCommandController {
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	CargaMasivaFacturasServicio cargaMasivaFacturasServicio = null;
	
	//String nombreReporte = null;
	String successView = null;		
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public static interface Enum_Con_TipRepor {
		  int  ReporExcelProExiste= 1 ;
	}
 	public ReporteProvCargaMasivaControlador(){
 		setCommandClass(CargaMasivaFacturasBean.class);
 		setCommandName("cargaMasivaFacturasBean");
 	}
    
 	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		CargaMasivaFacturasBean cargaMasivaFacturasBean = (CargaMasivaFacturasBean) command;
 		 
 		int tipoReporte =(request.getParameter("tipoReporte")!=null)? Integer.parseInt(request.getParameter("tipoReporte")):0;	
		int tipoLista =(request.getParameter("tipoLista")!=null)? Integer.parseInt(request.getParameter("tipoLista")):0;		
		String usuario =request.getParameter("usuario");
		String nombreInstitucion =request.getParameter("nombreInstitucion");
		
		cargaMasivaFacturasServicio.getCargaMasivaFacturasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			String htmlString= "";
			List listaReportes = null;
			switch(tipoReporte){
				case Enum_Con_TipRepor.ReporExcelProExiste:
					 listaReportes = reporteFacturasExcel(tipoLista,cargaMasivaFacturasBean,usuario, nombreInstitucion, response);
				break;

			}				
			
		return null;
 	}
 	 	
 	
 	public List  reporteFacturasExcel(int tipoLista,CargaMasivaFacturasBean cargaMasivaFacturasBean, String usuario,String nombreInstitucion, HttpServletResponse response){
 		Calendar calendario = new GregorianCalendar();
		SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
		String hora = postFormater.format(calendario.getTime());
		
 		List listaProveedoresCargaMasiva=null;
		listaProveedoresCargaMasiva = cargaMasivaFacturasServicio.listaReporte(tipoLista, cargaMasivaFacturasBean); 	
		
		int regExport = 0;
	
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
		estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
		estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
		estiloCentrado.setFont(fuenteNegrita10);
		
		//estilo centrado para id y fechas
		HSSFCellStyle estiloTexto = libro.createCellStyle();			
		estiloTexto.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
				
		//estilo centrado para id y fechas
		HSSFCellStyle estiloCentrado2 = libro.createCellStyle();			
		estiloCentrado2.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
		
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
		HSSFSheet hoja = libro.createSheet("Reporte proveedores Carga Masiva");
		HSSFRow fila= hoja.createRow(0);
	
		// inicio usuario,fecha y hora
	
		HSSFCell celdaUsu=fila.createCell((short)1);
		
		celdaUsu = fila.createCell((short)4);
		celdaUsu.setCellValue("Usuario:");
		celdaUsu.setCellStyle(estiloNeg8);	
		celdaUsu = fila.createCell((short)5);
		celdaUsu.setCellValue(usuario);
		String fechaVar=cargaMasivaFacturasBean.getFechaEmision();

		
		
		fila = hoja.createRow(1);
		HSSFCell celdaFec=fila.createCell((short)1);
				
		celdaFec = fila.createCell((short)4);
		celdaFec.setCellValue("Fecha:");
		celdaFec.setCellStyle(estiloNeg8);	
		celdaFec = fila.createCell((short)5);
		celdaFec.setCellValue(fechaVar);
		 
		// Nombre Institucion	
		HSSFCell celdaInst=fila.createCell((short)1);
		celdaInst.setCellStyle(estiloNeg10);
		celdaInst.setCellValue(nombreInstitucion);
							
		  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            3  //ultima celda   (0-based)
		    ));
		  
		 celdaInst.setCellStyle(estiloCentrado);	
		
		fila = hoja.createRow(2);
		HSSFCell celdaHora=fila.createCell((short)1);
		celdaHora = fila.createCell((short)4);
		celdaHora.setCellValue("Hora:");
		celdaHora.setCellStyle(estiloNeg8);	
		celdaHora = fila.createCell((short)5);
		celdaHora.setCellValue(hora);
		
		// Titulo del Reporte
					HSSFCell celda=fila.createCell((short)1);					
					celda.setCellValue("REPORTE DE PROVEEDORES CARGA MASIVA ");
									
					 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            2, //primera fila (0-based)
					            2, //ultima fila  (0-based)
					            1, //primer celda (0-based)
					            3  //ultima celda   (0-based)
					    ));
					 
					 celda.setCellStyle(estiloCentrado);
					 
						

		
		
		// Creacion de fila
		fila = hoja.createRow(3); // Fila vacia
		fila = hoja.createRow(4);// Campos
								

		celda = fila.createCell((short)1);
		celda.setCellValue("ID SAFI");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		 
		celda = fila.createCell((short)2);
		celda.setCellValue("RFC");
		celda.setCellStyle(estiloCentrado);
		 
		celda = fila.createCell((short)3);
		celda.setCellValue("Nombre Completo/Razón Social");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Descripción Error");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
	
	
		// Recorremos la lista para la parte de los datos 	
		int i=5,iter=0;
		int tamanioLista = listaProveedoresCargaMasiva.size();
		CargaMasivaFacturasBean proveedores = null;
		
		for( iter=0; iter<tamanioLista; iter ++){					
			proveedores = (CargaMasivaFacturasBean) listaProveedoresCargaMasiva.get(iter);
			
			
			fila=hoja.createRow(i);

			celda=fila.createCell((short)1);
			celda.setCellValue(proveedores.getSafiID());
			celda.setCellStyle(estiloTexto);
					
			celda=fila.createCell((short)2);
			celda.setCellValue(proveedores.getRfcEmisor());
			celda.setCellStyle(estiloTexto);
			
			celda=fila.createCell((short)3);
			celda.setCellValue(proveedores.getNombreEmisor());
			celda.setCellStyle(estiloTexto);
			
			celda=fila.createCell((short)4);
			celda.setCellValue(proveedores.getDescripcionError());
			celda.setCellStyle(estiloTexto);								 
			i++;
		}
		 
		i = i+2;
		fila=hoja.createRow(i); // Fila Registros Exportados
		celda = fila.createCell((short)0);
		celda.setCellValue("Registros Exportados");
		celda.setCellStyle(estiloNeg8);
		
		i = i+1;
		fila=hoja.createRow(i); // Fila Total de Registros Exportados
		celda=fila.createCell((short)0);
		celda.setCellValue(tamanioLista);
		

		for(int celd=0; celd<=15; celd++)
		hoja.autoSizeColumn((short)celd);
							
		//Creo la cabecera
		response.addHeader("Content-Disposition","inline; filename=RepProveedoresCargaMasiva.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();
		
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Termina Reporte");
		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte: " + e.getMessage());
			e.printStackTrace();
		}//Fin del catch
	//} 
		
		
	return  listaProveedoresCargaMasiva;
	
	
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public CargaMasivaFacturasServicio getCargaMasivaFacturasServicio() {
		return cargaMasivaFacturasServicio;
	}

	public void setCargaMasivaFacturasServicio(
			CargaMasivaFacturasServicio cargaMasivaFacturasServicio) {
		this.cargaMasivaFacturasServicio = cargaMasivaFacturasServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
 	
	

}
