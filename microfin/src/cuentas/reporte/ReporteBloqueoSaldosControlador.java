package cuentas.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

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
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.BloqueoSaldoBean;
import cuentas.servicio.BloqueoSaldoServicio;

public class ReporteBloqueoSaldosControlador extends AbstractCommandController{
	BloqueoSaldoServicio bloqueoSaldoServicio = null;

	String nombreReporte = null;
	String successView = null;		   
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2 ;
		}
	public ReporteBloqueoSaldosControlador() {
		setCommandClass(BloqueoSaldoBean.class);
		setCommandName("bloqueosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		BloqueoSaldoBean bloqueoSaldoBean = (BloqueoSaldoBean) command;
 		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		
				
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
				0;
		String htmlString= "";
		
		switch(tipoReporte){
			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = bloqueoSaldosPDF(bloqueoSaldoBean, nombreReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
			   List listaReportes = listaReporteExcel(tipoLista,bloqueoSaldoBean,response);
			break;
		}
			return null;
		}

	// Reporte en  PDF
	public ByteArrayOutputStream bloqueoSaldosPDF(BloqueoSaldoBean bloqueoSaldoBean, String nombreReporte, 
			HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = bloqueoSaldoServicio.reporteBloqueoSaldos(bloqueoSaldoBean, getNombreReporte());
			response.addHeader("Content-Disposition","inline; filename=BloqueoSaldos.pdf");
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
	

	// Reporte de saldos capital de credito en excel
	public List  listaReporteExcel(int tipoLista,BloqueoSaldoBean bloqueoSaldoBean,  HttpServletResponse response){
		List listaCreditos=null;
		listaCreditos = bloqueoSaldoServicio.listaReporteBloqueoSaldos(tipoLista,bloqueoSaldoBean,response); 	
	 
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
		
		HSSFCellStyle estiloDatoDerecho = libro.createCellStyle();
		estiloDatoDerecho.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT); 
		
		HSSFCellStyle estiloFormatoFecha = libro.createCellStyle();
		HSSFDataFormat formatD = libro.createDataFormat();
		estiloFormatoFecha.setDataFormat(formatD.getFormat("yyyy-MM-dd"));
		// Creacion de hoja					
		HSSFSheet hoja = libro.createSheet("Reporte Bloqueo de Saldos");
		HSSFRow fila= hoja.createRow(0);
		
		// inicio usuario,fecha y hora
		HSSFCell celdaUsu=fila.createCell((short)1);
		
		celdaUsu = fila.createCell((short)11);
		celdaUsu.setCellValue("Usuario:");
		celdaUsu.setCellStyle(estiloNeg8);	
		celdaUsu = fila.createCell((short)12);
		celdaUsu.setCellValue((!bloqueoSaldoBean.getClaveUsuario().isEmpty())?bloqueoSaldoBean.getClaveUsuario(): "TODOS");
		
		String horaVar=bloqueoSaldoBean.getHora();
		String fechaVar=bloqueoSaldoBean.getFechaEmision();

//		
//		int itera=0;
//		BloqueoSaldoBean bloqueoSaldo = null;
//		if(!listaCreditos.isEmpty()){
//			for( itera=0; itera<1; itera ++){
//				bloqueoSaldo = (BloqueoSaldoBean) listaCreditos.get(itera);
//				horaVar= bloqueoSaldo.getHora();
//				fechaVar= bloqueoSaldo.getFecha();				
//			}
//		}
//		
		
		fila = hoja.createRow(1);
		HSSFCell celdaFec=fila.createCell((short)1);
				
		celdaFec = fila.createCell((short)11);
		celdaFec.setCellValue("Fecha:");
		celdaFec.setCellStyle(estiloNeg8);	
		celdaFec = fila.createCell((short)12);
		celdaFec.setCellValue(fechaVar);
		 
		
		// Nombre Institucion	
		HSSFCell celdaInst=fila.createCell((short)1);
		//celdaInst.setCellStyle(estiloNeg10);
		celdaInst.setCellValue(bloqueoSaldoBean.getNombreInstitucion());
							
		  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            10  //ultima celda   (0-based)
		    ));
		  
		 celdaInst.setCellStyle(estiloCentrado);	
		
		
		fila = hoja.createRow(2);
		HSSFCell celdaHora=fila.createCell((short)1);
		celdaHora = fila.createCell((short)11);
		celdaHora.setCellValue("Hora:");
		celdaHora.setCellStyle(estiloNeg8);	
		celdaHora = fila.createCell((short)12);
		celdaHora.setCellValue(horaVar);
		
		// Titulo del Reporte	
		HSSFCell celda=fila.createCell((short)1);
		celda.setCellValue("BLOQUEO DE SALDOS ");
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
		celda.setCellValue("Cliente:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)2);
		celda.setCellValue((!bloqueoSaldoBean.getNombreCliente().equals("")? bloqueoSaldoBean.getNombreCliente():"TODOS"));
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Cuenta:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)5);
		celda.setCellValue((!bloqueoSaldoBean.getDescripcion().equals("")? bloqueoSaldoBean.getDescripcion():"TODAS"));
		
	
		// Creacion de fila
		fila = hoja.createRow(5); // Fila vacia
		fila = hoja.createRow(6);// Campos
								

		
		celda = fila.createCell((short)1);
		celda.setCellValue("Cliente");
		celda.setCellStyle(estiloCentrado);	
		
		celda = fila.createCell((short)2);
		celda.setCellValue("Nombre del Cliente");
		celda.setCellStyle(estiloCentrado);	
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Cuenta");
		celda.setCellStyle(estiloCentrado);	
				
		celda = fila.createCell((short)4);
		celda.setCellValue("Etiqueta");
		celda.setCellStyle(estiloCentrado);	
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Sucursal");
		celda.setCellStyle(estiloCentrado);		

		celda = fila.createCell((short)6);
		celda.setCellValue("Motivo Bloqueo");
		celda.setCellStyle(estiloCentrado);	
		
		celda = fila.createCell((short)7);
		celda.setCellValue("Descripción");
		celda.setCellStyle(estiloCentrado);	
		
		celda = fila.createCell((short)8);
		celda.setCellValue("Referencia");
		celda.setCellStyle(estiloCentrado);	
		
		celda = fila.createCell((short)9);
		celda.setCellValue("Monto Bloqueado");
		celda.setCellStyle(estiloCentrado);		
		
		celda = fila.createCell((short)10);
		celda.setCellValue("Fecha Bloqueo");
		celda.setCellStyle(estiloCentrado);	
		
		celda = fila.createCell((short)11);
		celda.setCellValue("Usuario Bloqueo");
		celda.setCellStyle(estiloCentrado);	

		celda = fila.createCell((short)12);
		celda.setCellValue("Desbloqueo");
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)13);
		celda.setCellValue("Fecha Desbloqueo");
		celda.setCellStyle(estiloCentrado);	
		// Recorremos la lista para la parte de los datos 	
		int i=7,iter=0;
		int tamanioLista = listaCreditos.size();
		BloqueoSaldoBean bloqueos = null;
		for( iter=0; iter<tamanioLista; iter ++){
			bloqueos = (BloqueoSaldoBean) listaCreditos.get(iter);
			fila=hoja.createRow(i);
			String Desbloqueo="";
			if (bloqueos.getNatMovimiento().equals("D")){
				 Desbloqueo="SI";
			}else{
				 Desbloqueo="NO";
			}
			
						
			celda=fila.createCell((short)1); 
			celda.setCellValue(bloqueos.getClienteID());
			
			celda=fila.createCell((short)2);
			celda.setCellValue(bloqueos.getNombreCliente()); 
				
			celda=fila.createCell((short)3);
			celda.setCellValue(bloqueos.getCuentaAhoID());

			celda=fila.createCell((short)4);
			celda.setCellValue(bloqueos.getDescripcion());
			
			celda=fila.createCell((short)5);
			celda.setCellValue(bloqueos.getNombreSucursal());
			
			celda=fila.createCell((short)6);
			celda.setCellValue(bloqueos.getMotivoBloqueo());
			
			celda=fila.createCell((short)7);
			celda.setCellValue(bloqueos.getDescripcionBloq());
			
			celda=fila.createCell((short)8);
			celda.setCellValue(bloqueos.getReferencia());
			celda.setCellStyle(estiloDatoDerecho);
			
			celda=fila.createCell((short)9);
			celda.setCellValue(Double.parseDouble(bloqueos.getMontoBloq()));
			celda.setCellStyle(estiloFormatoDecimal);
			
			celda=fila.createCell((short)10);
			celda.setCellValue(bloqueos.getFecha());
			celda.setCellStyle(	estiloFormatoFecha);
					
			celda=fila.createCell((short)11);
			celda.setCellValue(bloqueos.getUsuarioIDAuto() +" - "+ bloqueos.getNombreUsuario());
			
			celda=fila.createCell((short)12);
			celda.setCellValue(Desbloqueo);
			
			celda=fila.createCell((short)13);
			celda.setCellValue((!bloqueos.getFechaDesbloq().equals("1900-01-01")? bloqueos.getFechaDesbloq():""));
			
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
							
		response.addHeader("Content-Disposition","inline; filename=RepBloqueoSaldos.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();

		System.out.println("Termina Reporte");
		}catch(Exception e){
			System.out.println("Error al crear el reporte: " + e.getMessage());
			e.printStackTrace();
		}//Fin del catch
		//} 

	return  listaCreditos;
	
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

	public void setBloqueoSaldoServicio(
			BloqueoSaldoServicio bloqueoSaldoServicio) {
		this.bloqueoSaldoServicio = bloqueoSaldoServicio;
	}	
}
