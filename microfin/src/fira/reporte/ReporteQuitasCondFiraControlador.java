package fira.reporte;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

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
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import fira.servicio.CreQuitasFiraServicio; 
import fira.bean.CreQuitasFiraBean; 


public class ReporteQuitasCondFiraControlador extends AbstractCommandController {
	CreQuitasFiraServicio creQuitasFiraServicio = null;
	String nombreReporte = null;
	String successView = null;		

	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
	}
	public ReporteQuitasCondFiraControlador(){
		setCommandClass(CreQuitasFiraBean.class);
		setCommandName("creQuitasBean");
	}
   
	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		CreQuitasFiraBean creQuitasBean = (CreQuitasFiraBean) command;
		 
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
	
		int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;
		
			String htmlString= "";
			
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPantalla:
					 htmlString = creQuitasFiraServicio.reporteQuitasCondPantalla(creQuitasBean, nombreReporte);
				break;
					
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporteQuitasCondPDF(creQuitasBean, nombreReporte, response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:		
				List listaReportes = reporteCreditoQuitasExcel(tipoLista,creQuitasBean,response);
				break;
			}
				
				if(tipoReporte ==Enum_Con_TipRepor.ReporPantalla ){
					return new ModelAndView(getSuccessView(), "reporte", htmlString);
				}else {
					return null;
				}
	}
	
	

// Reporte  de  ministraciones  en PDF
	public ByteArrayOutputStream reporteQuitasCondPDF(CreQuitasFiraBean creQuitasBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creQuitasFiraServicio.reporteQuitasCondPDF(creQuitasBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=RepQuitasCondonaciones.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	return htmlStringPDF;
	}

	private List reporteCreditoQuitasExcel(int tipoLista,
			CreQuitasFiraBean creQuitasBean, HttpServletResponse response) {
		// TODO Auto-generated method stub
		List listaCreditosQuitas=null;
		//List listaCreditos = null;
  	listaCreditosQuitas = creQuitasFiraServicio.listaReportesCreditos(tipoLista,creQuitasBean,response); 	
		
		int regExport = 0;
		
	//	if(listaCreditos != null){
		

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
			
			CellStyle estiloDatosCentradoNegr8 = libro.createCellStyle();
			estiloDatosCentradoNegr8.setFont(fuenteNegrita8);
			estiloDatosCentradoNegr8.setAlignment((short)CellStyle.ALIGN_CENTER); 
			
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
			HSSFSheet hoja = libro.createSheet("Reporte De Quitas Y Condonaciones");
			HSSFRow fila= hoja.createRow(0);

			// inicio usuario,fecha y hora
						HSSFCell celdaUsu=fila.createCell((short)1);
						celdaUsu.setCellStyle(estiloCentrado);	
						celdaUsu.setCellValue(creQuitasBean.getNombreInstitucion());
						hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            0, //primera fila (0-based)
					            0, //ultima fila  (0-based)
					            1, //primer celda (0-based)
					            15  //ultima celda   (0-based)
					    ));
						
						
						celdaUsu = fila.createCell((short)16);
						celdaUsu.setCellValue("Usuario:");
						celdaUsu.setCellStyle(estiloNeg8);	
						celdaUsu = fila.createCell((short)17);
						celdaUsu.setCellValue((!creQuitasBean.getNombreUsuario().equals("")?creQuitasBean.getNombreUsuario(): "TODOS"));

						
						String fechaVar=creQuitasBean.getParFechaEmision();

						fila = hoja.createRow(1);
						HSSFCell celdaFec=fila.createCell((short)1);
						celdaFec = fila.createCell((short)16);
						celdaFec.setCellValue("Fecha:");
						celdaFec.setCellStyle(estiloNeg8);	
						celdaFec = fila.createCell((short)17);
						celdaFec.setCellValue(fechaVar);
						 
						Calendar calendario = new GregorianCalendar();

						fila = hoja.createRow(2);
						HSSFCell celdaHora=fila.createCell((short)1);
						celdaHora = fila.createCell((short)16);
						celdaHora.setCellValue("Hora:");
						celdaHora.setCellStyle(estiloNeg8);	
						celdaHora = fila.createCell((short)17);
						celdaHora.setCellValue(calendario.get(Calendar.HOUR_OF_DAY) + ":" + calendario.get(Calendar.MINUTE));
			    // fin susuario,fecha y hora
			
			HSSFCell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloCentrado);
			celda.setCellValue("REPORTE DE QUITAS Y CONDONACIONES DEL "+creQuitasBean.getFechaInicio()+ " AL " + creQuitasBean.getFechaFin() );
	
		    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            15  //ultima celda   (0-based)
		    ));
			
			// Creacion de fila
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			
		
		
			celda = fila.createCell((short)1);
			celda.setCellValue("Fecha");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("ID Crédito");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("ID Grupo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Nombre Grupo");
			celda.setCellStyle(estiloNeg8);	
			
			
			celda = fila.createCell((short)5);
			celda.setCellValue("ID Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Nombre Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("ID Producto");
			celda.setCellStyle(estiloNeg8);			

			celda = fila.createCell((short)8);
			celda.setCellValue("Nombre del Producto.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Monto Crédito");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Usuario");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Puesto");
			celda.setCellStyle(estiloNeg8);
			
			
			celda = fila.createCell((short)13);
			celda.setCellValue("                      Detalle de Quitas y Condonación");
			celda.setCellStyle(estiloDatosCentradoNegr8);
			
		    hoja.addMergedRegion(new CellRangeAddress(
		    		 4, 4, 13,17 
		    ));
			
		   //Capital	Intereses	Moratorios	Comisiones	IVA	TOTAL PAGADO

			fila = hoja.createRow(5);//NUEVA FILA
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Capital");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)14);
			celda.setCellValue("Intereses");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)15);
			celda.setCellValue("Moratorios");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)16);
			celda.setCellValue("Comisiones");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)17);
			celda.setCellValue("Total Condonado");
			celda.setCellStyle(estiloNeg8);	
					
		
			int i=6,iter=0;
			int tamanioLista = listaCreditosQuitas.size();
			CreQuitasFiraBean creQuitas = null;
			for( iter=0; iter<tamanioLista; iter ++){
				//Fecha	ID Crédito	No.Cliente	NombreCliente	Id producto	Sucursal	Monto Credito
					creQuitas = (CreQuitasFiraBean) listaCreditosQuitas.get(iter);
					fila=hoja.createRow(i);

					

					celda=fila.createCell((short)1);
					celda.setCellValue(creQuitas.getFechaRegistro());
					
					celda=fila.createCell((short)2);
					celda.setCellValue(creQuitas.getCreditoID());
					
					celda=fila.createCell((short)3);
					celda.setCellValue(creQuitas.getGrupoID());
					
					celda=fila.createCell((short)4);
					celda.setCellValue(creQuitas.getNombreGrupo());
					
					celda=fila.createCell((short)5);
					celda.setCellValue(creQuitas.getClienteID());
					
					celda=fila.createCell((short)6);
					celda.setCellValue(creQuitas.getNomCliente());

					celda=fila.createCell((short)7);
					celda.setCellValue(creQuitas.getProducCreditoID());
					
					celda=fila.createCell((short)8);
					celda.setCellValue(creQuitas.getNombreProducto());
					
					celda=fila.createCell((short)9);
					celda.setCellValue(creQuitas.getNombreSucursal());

					celda=fila.createCell((short)10);
					celda.setCellValue(Double.parseDouble(creQuitas.getMontoCredito()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)11);
					celda.setCellValue(creQuitas.getClaveUsuario());
					
					celda=fila.createCell((short)12);
					celda.setCellValue(creQuitas.getPuestoID());
					

					 //Capital	Intereses	Moratorios	Comisiones	IVA	TOTAL PAGADO
					celda=fila.createCell((short)13);
					celda.setCellValue(Double.parseDouble(creQuitas.getMontoCapital()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)14);
					celda.setCellValue(Double.parseDouble(creQuitas.getMontoInteres()) );
					celda.setCellStyle(estiloFormatoDecimal);
						
					celda=fila.createCell((short)15);
					celda.setCellValue(Double.parseDouble(creQuitas.getMontoMoratorios()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)16);
					celda.setCellValue(Double.parseDouble(creQuitas.getMontoComisiones()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)17);
					celda.setCellValue(Double.parseDouble(creQuitas.getTotalCondonado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
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
			

			for(int celd=0; celd<=17; celd++)
			hoja.autoSizeColumn((short)celd);
		
								
			//Creo la cabecera
			if(tipoLista ==  2){
				response.addHeader("Content-Disposition","inline; filename=ReporteCreditoQuitasCont.xls");
			}else{
				response.addHeader("Content-Disposition","inline; filename=ReporteCreditoQuitas.xls");
			}
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		//}
		return  listaCreditosQuitas;
		
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

	public CreQuitasFiraServicio getCreQuitasFiraServicio() {
		return creQuitasFiraServicio;
	}

	public void setCreQuitasFiraServicio(CreQuitasFiraServicio creQuitasFiraServicio) {
		this.creQuitasFiraServicio = creQuitasFiraServicio;
	}

}


