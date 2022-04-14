package contabilidad.servicio;

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
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;

import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;

import contabilidad.bean.EstatusTimbradoProdBean;
import contabilidad.dao.EstatusTimbradoProdDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class EstatusTimbradoProdServicio extends BaseServicio{
	
	EstatusTimbradoProdDAO estatusTimbradoProdDAO;
	
	public static interface Enum_Lis_EstarusTimProduc{
		int EstatusTimbrado = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoLista, EstatusTimbradoProdBean estatusTimbradoProdBean, HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		
		return mensaje;
	}
	public List lista(int tipoLista, EstatusTimbradoProdBean estatusTimbradoProdBean){	
		List estatusTimbradoProd = null;
		switch (tipoLista) {
		case Enum_Lis_EstarusTimProduc.EstatusTimbrado:		
			estatusTimbradoProd = estatusTimbradoProdDAO.listaEstatusTimbrado(estatusTimbradoProdBean, tipoLista);			
			break;	

		}				
		return estatusTimbradoProd;
	}

	
	public List listaReportesTimbrado(int tipoLista, EstatusTimbradoProdBean estatusTimbradoProd, HttpServletResponse response) {
		// TODO Auto-generated method stub
		List lestatusTimbrado = null;
		lestatusTimbrado = reporteEstatusTimbradoExcel(tipoLista, estatusTimbradoProd,response);
		return lestatusTimbrado;
	}
	
	
	private List reporteEstatusTimbradoExcel(int tipoLista, EstatusTimbradoProdBean estatusTimbradoProd, HttpServletResponse response) {
		// TODO Auto-generated method stub
		List listaTimbradoProd=null;
		//List listaCreditos = null;
		listaTimbradoProd = estatusTimbradoProdDAO.listaEstatusTimbradoRep(estatusTimbradoProd, tipoLista);; 	
		
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
			HSSFSheet hoja = libro.createSheet("ESTATUS DE TIMBRADO POR PRODUCTO DEL ANIO"+estatusTimbradoProd.getAnio());
			HSSFRow fila= hoja.createRow(0);			
			// inicio usuario,fecha y hora
			fila = hoja.createRow(0);
			HSSFCell celdaNomIns=fila.createCell((short)0);
			celdaNomIns.setCellStyle(estiloCentrado);	
			celdaNomIns.setCellValue(estatusTimbradoProd.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            0, //primera fila (0-based)
		            0, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            13  //ultima celda   (0-based)
		    ));
			
			celdaNomIns.setCellStyle(estiloCentrado);	
			celdaNomIns = fila.createCell((short)14);
			celdaNomIns.setCellValue("Usuario:");
			celdaNomIns.setCellStyle(estiloNeg8);	
			celdaNomIns = fila.createCell((short)15);
			celdaNomIns.setCellValue((!estatusTimbradoProd.getNombreUsuario().equals("")?estatusTimbradoProd.getNombreUsuario(): "TODOS"));
			
			
			
			fila = hoja.createRow(1);
			HSSFCell celdaTituloRep=fila.createCell((short)0);
			celdaTituloRep.setCellStyle(estiloCentrado);
			celdaTituloRep.setCellValue("REPORTE DE ESTATUS DE TIMBRADO POR PRODUCTO DEL AÑO "+estatusTimbradoProd.getAnio());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            13  //ultima celda   (0-based)
		    ));
			
			String fechaVar=estatusTimbradoProd.getParFechaEmision();
			//HSSFCell celdaFec=fila.createCell((short)1);
			celdaTituloRep = fila.createCell((short)14);
			celdaTituloRep.setCellValue("Fecha:");
			celdaTituloRep.setCellStyle(estiloNeg8);	
			celdaTituloRep = fila.createCell((short)15);
			celdaTituloRep.setCellValue(fechaVar);

			fila = hoja.createRow(2);
			Calendar calendario = new GregorianCalendar();
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)14);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)15);
			celdaHora.setCellValue(calendario.get(Calendar.HOUR_OF_DAY) + ":" + calendario.get(Calendar.MINUTE));
			
			
			// fin susuario,fecha y hora
			// Creacion de fila
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			HSSFCell celda=fila.createCell((short)0);
			celda = fila.createCell((short)1);
			celda.setCellValue("Producto Crédito");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Enero");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Febrero");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Marzo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Abril");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Mayo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Junio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Julio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Agosto");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Septiembre");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Octubre");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Noviembre");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Diciembre");
			celda.setCellStyle(estiloNeg8);
			
			
			
			fila = hoja.createRow(5);
			int i=5,iter=0;
			int tamanioLista = listaTimbradoProd.size();
			EstatusTimbradoProdBean estatusTimbrado = null;
			for( iter=0; iter<tamanioLista; iter ++){
				//Fecha	ID Crédito	No.Cliente	NombreCliente	Id producto	Sucursal	Monto Credito
				estatusTimbrado = (EstatusTimbradoProdBean) listaTimbradoProd.get(iter);
					fila=hoja.createRow(i);

					celda=fila.createCell((short)1);
					celda.setCellValue(estatusTimbrado.getNombreProducto());
					
					celda=fila.createCell((short)2);
					celda.setCellValue(estatusTimbrado.getEnero());
					
					celda=fila.createCell((short)3);
					celda.setCellValue(estatusTimbrado.getFebrero());
					
					celda=fila.createCell((short)4);
					celda.setCellValue(estatusTimbrado.getMarzo());
					
					celda=fila.createCell((short)5);
					celda.setCellValue(estatusTimbrado.getAbril());
					
					celda=fila.createCell((short)6);
					celda.setCellValue(estatusTimbrado.getMayo());

					celda=fila.createCell((short)7);
					celda.setCellValue(estatusTimbrado.getJunio());
					
					celda=fila.createCell((short)8);
					celda.setCellValue(estatusTimbrado.getJulio());
					
					celda=fila.createCell((short)9);
					celda.setCellValue(estatusTimbrado.getAgosto());

					celda=fila.createCell((short)10);
					celda.setCellValue(estatusTimbrado.getSeptiembre());
					
					celda=fila.createCell((short)11);
					celda.setCellValue(estatusTimbrado.getOctubre());
					
					celda=fila.createCell((short)12);
					celda.setCellValue(estatusTimbrado.getNoviembre());
					
					celda=fila.createCell((short)13);
					celda.setCellValue(estatusTimbrado.getDiciembre());

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
			response.addHeader("Content-Disposition","inline; filename=ESTATUS_TIMBRADO-"+estatusTimbradoProd.getAnio()+".xls");
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
		return  listaTimbradoProd;
		
	}
	
	public EstatusTimbradoProdDAO getEstatusTimbradoProdDAO() {
		return estatusTimbradoProdDAO;
	}


	public void setEstatusTimbradoProdDAO(
			EstatusTimbradoProdDAO estatusTimbradoProdDAO) {
		this.estatusTimbradoProdDAO = estatusTimbradoProdDAO;
	}



	
	
}
