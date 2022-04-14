package nomina.reporte;

import general.bean.ParametrosAuditoriaBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.EmpleadoNominaBean;
import nomina.servicio.NominaEmpleadosServicio;

import org.apache.log4j.Logger;
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




public class RepNominaEmpleadosControlador  extends AbstractCommandController{
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	NominaEmpleadosServicio nominaEmpleadosServicio = null;
	
	String nomReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2 ;
	}
	public RepNominaEmpleadosControlador () {
		setCommandClass(EmpleadoNominaBean.class);
		setCommandName("empleadoNominaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errors)throws Exception {
		

		EmpleadoNominaBean empleadoNominaBean = (EmpleadoNominaBean) command;

			int tipoReporte =(request.getParameter("tipoReporte")!=null)?
							Integer.parseInt(request.getParameter("tipoReporte")):
							0;
			int tipoLista =(request.getParameter("tipoLista")!=null)?
							Integer.parseInt(request.getParameter("tipoLista")):
							0;
		
			String htmlString= "";
			loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Entra en controlador: "+ tipoReporte);
		switch(tipoReporte){			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = ReporteClientesNomPDF(empleadoNominaBean, nomReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:	
				 List listaReportes = listaReporteClientesNom(tipoLista,empleadoNominaBean,response);
			break;
		}
		return null;
			
	}
	
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream ReporteClientesNomPDF(EmpleadoNominaBean empleadoNominaBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = nominaEmpleadosServicio.creaRepClientesNomPDF(empleadoNominaBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteCreditosCastigados.pdf");
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

	// Reporte de saldos capital de credito en excel
	public List  listaReporteClientesNom(int tipoLista,EmpleadoNominaBean empleadoNominaBean,  HttpServletResponse response){
		List listaCreditos=null;
		listaCreditos = nominaEmpleadosServicio.listaReporte(tipoLista,empleadoNominaBean,response); 	

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
		HSSFSheet hoja = libro.createSheet("Cliente Empresa Nómina");
		HSSFRow fila= hoja.createRow(0);
		
		// inicio usuario,fecha y hora
		HSSFCell celdaUsu=fila.createCell((short)1);
		
		celdaUsu = fila.createCell((short)11);
		celdaUsu.setCellValue("Usuario:");
		celdaUsu.setCellStyle(estiloNeg8);	
		celdaUsu = fila.createCell((short)12);
		celdaUsu.setCellValue((!empleadoNominaBean.getClaveUsuario().isEmpty())?empleadoNominaBean.getClaveUsuario(): "TODOS");
		
		String horaVar="";
		String fechaVar=empleadoNominaBean.getFechaEmision();

		fila = hoja.createRow(1);
		HSSFCell celdaFec=fila.createCell((short)1);
				
		celdaFec = fila.createCell((short)11);
		celdaFec.setCellValue("Fecha:");
		celdaFec.setCellStyle(estiloNeg8);	
		celdaFec = fila.createCell((short)12);
		celdaFec.setCellValue(empleadoNominaBean.getFechaEmision());
		 
		
		// Nombre Institucion	
		HSSFCell celdaInst=fila.createCell((short)1);
		//celdaInst.setCellStyle(estiloNeg10);
		celdaInst.setCellValue(empleadoNominaBean.getNombreInstitucion());
							
		  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            10  //ultima celda (0-based)
		    ));
		  
		 celdaInst.setCellStyle(estiloCentrado);	
		
		
		fila = hoja.createRow(2);
		HSSFCell celdaHora=fila.createCell((short)1);
		celdaHora = fila.createCell((short)11);
		celdaHora.setCellValue("Hora:");
		celdaHora.setCellStyle(estiloNeg8);	
		celdaHora = fila.createCell((short)12);
		Calendar calendario = Calendar.getInstance();
		celdaHora.setCellValue(calendario.get(Calendar.HOUR_OF_DAY) + ":" + calendario.get(Calendar.MINUTE));
		
		// Titulo del Reporte	
		HSSFCell celda=fila.createCell((short)1);
		celda.setCellValue("REPORTE DE CLIENTES EMPRESA DE NÓMINA");
		celda.setCellStyle(estiloCentrado);
	   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            2, //primera fila (0-based)
	            2, //ultima fila  (0-based)
	            1, //primer celda (0-based)
	            10  //ultima celda   (0-based)
	    ));
	    
		
	   
	   
	   	fila = hoja.createRow(3); // Fila vacia
		fila = hoja.createRow(4);// Campos
		celda = fila.createCell((short)1);
		celda.setCellValue("Empresa de Nómina:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)2);
		celda.setCellValue((!empleadoNominaBean.getNombreInstNomina().equals("")? empleadoNominaBean.getNombreInstNomina():"TODAS"));
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Convenio:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)4);
		celda.setCellValue((!empleadoNominaBean.getDescripcionConvenio().equals("")? empleadoNominaBean.getDescripcionConvenio():"TODOS"));
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Sucursal:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)6);
		celda.setCellValue((!empleadoNominaBean.getNombreSucursal().equals("")? empleadoNominaBean.getNombreSucursal():"TODAS"));
		
		celda = fila.createCell((short)7);
		celda.setCellValue("Cliente:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)8);
		celda.setCellValue((!empleadoNominaBean.getNombreCompleto().equals("")? empleadoNominaBean.getNombreCompleto():"TODAS"));
		
		
		// Creacion de fila
		fila = hoja.createRow(5);
		fila = hoja.createRow(6);
		celda = fila.createCell((short)1);
		celda.setCellValue("Institución Nómina");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)2);
		celda.setCellValue("Convenio");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)3);
		celda.setCellValue("NoCliente");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)4);
		celda.setCellValue("No. Empleado");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Nombre");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)6);
		celda.setCellValue("CURP");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)7);
		celda.setCellValue("RFC");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)8);
		celda.setCellValue("TIPO EMPLEADO");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)9);
		celda.setCellValue("PUESTO");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)10);
		celda.setCellValue("ESTATUS");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)11);
		celda.setCellValue("QUINQUENIO");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)12);
		celda.setCellValue("FECHA INGRESO");
		celda.setCellStyle(estiloNeg8);

		


		// Recorremos la lista para la parte de los datos 	
		int i=7, iter=0;
		int tamanioLista = listaCreditos.size();
		EmpleadoNominaBean empNominaBean = null;
		for( iter=0; iter<tamanioLista; iter ++){
		
			empNominaBean = (EmpleadoNominaBean) listaCreditos.get(iter);
			fila=hoja.createRow(i);

			
			celda=fila.createCell((short)1);
			celda.setCellValue(empNominaBean.getNombreInstNomina());
			
			celda=fila.createCell((short)2);
			celda.setCellValue(empNominaBean.getDescripcionConvenio());
			
			celda=fila.createCell((short)3);
			celda.setCellValue(empNominaBean.getClienteID());
			
			celda=fila.createCell((short)4);
			celda.setCellValue(empNominaBean.getNoEmpleado());
			
			celda=fila.createCell((short)5);
			celda.setCellValue(empNominaBean.getNombreCompleto());
			
			celda=fila.createCell((short)6);
			celda.setCellValue(empNominaBean.getCURP());
			
			celda=fila.createCell((short)7);
			celda.setCellValue(empNominaBean.getRFC());
			
			celda=fila.createCell((short)8);
			celda.setCellValue(empNominaBean.getDesTipoEmpleado());
			
			celda=fila.createCell((short)9);
			celda.setCellValue(empNominaBean.getDesPuestoOcupacion());
			
			celda=fila.createCell((short)10);
			celda.setCellValue(empNominaBean.getEstatus());
			
			celda=fila.createCell((short)11);
			celda.setCellValue(empNominaBean.getDesQuinquenio());
			
			celda=fila.createCell((short)12);
			celda.setCellValue(empNominaBean.getFechaIngreso());
			
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
		

		for(int celd=0; celd<=18; celd++)
		hoja.autoSizeColumn((short)celd);
							
		//Creo la cabecera
		response.addHeader("Content-Disposition","inline; filename=RepClientesNomina.xls");
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
		
		
	return  listaCreditos;
	
	
	}
	
	

	public String getNomReporte() {
		return nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
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
	public NominaEmpleadosServicio getNominaEmpleadosServicio() {
		return nominaEmpleadosServicio;
	}

	public void setNominaEmpleadosServicio(
			NominaEmpleadosServicio nominaEmpleadosServicio) {
		this.nominaEmpleadosServicio = nominaEmpleadosServicio;
	}
		

}
