package credito.reporte;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import credito.servicio.CreQuitasServicio; 
import credito.bean.CreQuitasBean; 


public class ReporteQuitasCondControlador extends AbstractCommandController {
	CreQuitasServicio creQuitasServicio = null;
	String nombreReporte = null;
	String successView = null;		

	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
	}
	public ReporteQuitasCondControlador(){
		setCommandClass(CreQuitasBean.class);
		setCommandName("creQuitasBean");
	}
   
	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		CreQuitasBean creQuitasBean = (CreQuitasBean) command;
		 
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
	
		int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;
			
			String htmlString= "";
			
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPantalla:
					 htmlString = creQuitasServicio.reporteQuitasCondPantalla(creQuitasBean, nombreReporte);
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
	public ByteArrayOutputStream reporteQuitasCondPDF(CreQuitasBean creQuitasBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creQuitasServicio.reporteQuitasCondPDF(creQuitasBean, nomReporte);
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
			CreQuitasBean creQuitasBean, HttpServletResponse response) {
		// TODO Auto-generated method stub
		List listaCreditosQuitas=null;
		//List listaCreditos = null;
  	listaCreditosQuitas = creQuitasServicio.listaReportesCreditos(tipoLista,creQuitasBean,response); 	
		
		int regExport = 0;
		
	//	if(listaCreditosQuitas != null){
		

			try {
			SXSSFWorkbook libro = new SXSSFWorkbook();
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
			
			CellStyle estiloDatosCentradoNegr8 = libro.createCellStyle();
			estiloDatosCentradoNegr8.setFont(fuenteNegrita8);
			estiloDatosCentradoNegr8.setAlignment((short)CellStyle.ALIGN_CENTER); 
			
			CellStyle estiloDatosCentradoNegr10= libro.createCellStyle();
			estiloDatosCentradoNegr10.setFont(fuenteNegrita10);
			estiloDatosCentradoNegr10.setAlignment((short)CellStyle.ALIGN_CENTER); 

			CellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			
			
			//Estilo negrita de 8  y color de fondo
			CellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(CellStyle.SOLID_FOREGROUND);
			
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja					
			SXSSFSheet hoja = (SXSSFSheet) libro.createSheet("Reporte De Quitas Y Condonaciones");
			Row fila= hoja.createRow(0);
			// inicio usuario,fecha y hora

				        Cell celdaUsu2=fila.createCell((short)3);
						celdaUsu2.setCellValue(creQuitasBean.getNombreInstitucion());
						celdaUsu2.setCellStyle(estiloDatosCentradoNegr10);	
						hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            0, //primera fila (0-based)
					            0, //ultima fila  (0-based)
					            3, //primer celda (0-based)
					            9  //ultima celda   (0-based)
					    ));
						
					    Cell celdaUsu=fila.createCell((short)1);			 
						celdaUsu = fila.createCell((short)15);
						celdaUsu.setCellValue("Usuario:");
						celdaUsu.setCellStyle(estiloNeg8);	
						celdaUsu = fila.createCell((short)16);
						celdaUsu.setCellValue((!creQuitasBean.getNombreUsuario().isEmpty())?creQuitasBean.getNombreUsuario(): "TODOS");

						
						String horaVar="";
						String fechaVar=creQuitasBean.getParFechaEmision();

						
						int itera=0;

						CreQuitasBean creditoHora = null;
						if(!listaCreditosQuitas.isEmpty()){
						for( itera=0; itera<1; itera ++){

							creditoHora = (CreQuitasBean) listaCreditosQuitas.get(itera);
							horaVar= creditoHora.getHora();
							fechaVar= creditoHora.getFecha();
							
						}
						}
						fechaVar=creQuitasBean.getParFechaEmision();
							fila = hoja.createRow(1);


						fila = hoja.createRow(1);

						Cell celdaFec=fila.createCell((short)1);
						celdaFec = fila.createCell((short)15);
						celdaFec.setCellValue("Fecha:");
						celdaFec.setCellStyle(estiloNeg8);	
						celdaFec = fila.createCell((short)16);
						celdaFec.setCellValue(fechaVar);

						Calendar calendario = new GregorianCalendar();
						fila = hoja.createRow(2);
						Cell celdaHora=fila.createCell((short)1);
						celdaHora = fila.createCell((short)15);
						celdaHora.setCellValue("Hora:");
						celdaHora.setCellStyle(estiloNeg8);	
						celdaHora = fila.createCell((short)16);
						celdaHora.setCellValue(calendario.get(Calendar.HOUR_OF_DAY) + ":" + calendario.get(Calendar.MINUTE));

			    // fin susuario,fecha y hora
			
			Cell celda=fila.createCell((short)3);
			celda.setCellStyle(estiloDatosCentradoNegr10);
			celda.setCellValue("REPORTE DE QUITAS Y CONDONACIONES DEL "+creQuitasBean.getFechaInicio()+ " AL " + creQuitasBean.getFechaFin() );
			
		
		    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            3, //primer celda (0-based)
		            9  //ultima celda   (0-based)
		    ));
		    
			
			// Creacion de fila
			fila = hoja.createRow(3);
			
			fila = hoja.createRow(4);
			celda = fila.createCell((short)1);
			celda.setCellValue("Crédito:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)2);
			celda.setCellValue(creQuitasBean.getNomCredito());
			celda = fila.createCell((short)3);
			celda.setCellValue((creQuitasBean.getNomCliente()));
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Producto de Crédito:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)6);
			celda.setCellValue((!creQuitasBean.getNombreProducto().equals("")? creQuitasBean.getNombreProducto():"TODOS"));
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)9);
			celda.setCellValue((!creQuitasBean.getNombreSucursal().equals("")? creQuitasBean.getNombreSucursal():"TODAS"));
			
			if("S".equals(creQuitasBean.getEsproducNomina())){
				celda = fila.createCell((short)11);
				celda.setCellValue("Institución Nómina:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)12);
				celda.setCellValue((!creQuitasBean.getNombreInstit().equals("")? creQuitasBean.getNombreInstit():"TODAS"));
				if("S".equals(creQuitasBean.getManejaConvenio()))
				{
				celda = fila.createCell((short)14);
				celda.setCellValue("Convenio Nómina:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)15);
				celda.setCellValue((!creQuitasBean.getDesConvenio().equals("")? creQuitasBean.getDesConvenio():"TODOS"));
				}
			}
			
			fila = hoja.createRow(5); //Fila Vacia
			
			fila = hoja.createRow(6);
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
			celda.setCellValue("Institución Nómina");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Convenio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("ID Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Nombre Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("ID Producto");
			celda.setCellStyle(estiloNeg8);			

			celda = fila.createCell((short)10);
			celda.setCellValue("Nombre del Producto.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Monto Crédito");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Usuario");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)14);
			celda.setCellValue("Puesto");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)15);
			celda.setCellValue("                      Detalle de Quitas y Condonación");
			celda.setCellStyle(estiloDatosCentradoNegr8);
			
		    hoja.addMergedRegion(new CellRangeAddress(
		    		 6, 6, 15,19 
		    ));
		   //Capital	Intereses	Moratorios	Comisiones	IVA	TOTAL PAGADO

			fila = hoja.createRow(7);//NUEVA FILA
			
			celda = fila.createCell((short)15);
			celda.setCellValue("Capital");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)16);
			celda.setCellValue("Intereses");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)17);
			celda.setCellValue("Moratorios");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)18);
			celda.setCellValue("Comisiones");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)19);
			celda.setCellValue("Notas de cargo");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)20);
			celda.setCellValue("Total Condonado");
			celda.setCellStyle(estiloNeg8);	
			
		
			int i=9,iter=0;
			int tamanioLista = listaCreditosQuitas.size();
			CreQuitasBean creQuitas = null;
			for( iter=0; iter<tamanioLista; iter ++){
				//Fecha	ID Crédito	No.Cliente	NombreCliente	Id producto	Sucursal	Monto Credito
					creQuitas = (CreQuitasBean) listaCreditosQuitas.get(iter);
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
					celda.setCellValue(creQuitas.getInstitucionNominaID());
					
					celda=fila.createCell((short)6);
					celda.setCellValue(creQuitas.getConvenioNominaID());
					
					celda=fila.createCell((short)7);
					celda.setCellValue(creQuitas.getClienteID());
					
					celda=fila.createCell((short)8);
					celda.setCellValue(creQuitas.getNomCliente());

					celda=fila.createCell((short)9);
					celda.setCellValue(creQuitas.getProducCreditoID());
					
					celda=fila.createCell((short)10);
					celda.setCellValue(creQuitas.getNombreProducto());
					
					celda=fila.createCell((short)11);
					celda.setCellValue(creQuitas.getNombreSucursal());

					celda=fila.createCell((short)12);
					celda.setCellValue(Double.parseDouble(creQuitas.getMontoCredito()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)13);
					celda.setCellValue(creQuitas.getClaveUsuario());
					
					celda=fila.createCell((short)14);
					celda.setCellValue(creQuitas.getPuestoID());
					
					celda=fila.createCell((short)15);
					celda.setCellValue(creQuitas.getMontoCapital());
					 //Capital	Intereses	Moratorios	Comisiones	IVA	TOTAL PAGADO

					
					
					

					celda=fila.createCell((short)16);
					celda.setCellValue(Double.parseDouble(creQuitas.getMontoInteres()) );
					celda.setCellStyle(estiloFormatoDecimal);
						
					celda=fila.createCell((short)17);
					celda.setCellValue(Double.parseDouble(creQuitas.getMontoMoratorios()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)18);
					celda.setCellValue(Double.parseDouble(creQuitas.getMontoComisiones()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)19);
					celda.setCellValue(Double.parseDouble(creQuitas.getMontoNotasCargo()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)20);
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
			

			for (int celd = 0; celd <= 19; celd++) {
				try {
					hoja.autoSizeColumn((short) celd);
				} catch (Exception ex) {

				}
			}
		
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteCreditoQuitas.xlsx");
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
		return  listaCreditosQuitas;
		
	}
	
	public void setCreQuitasServicio(CreQuitasServicio creQuitasServicio ) {
		this.creQuitasServicio = creQuitasServicio;
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

}


