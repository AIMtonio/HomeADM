package nomina.servicio;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import nomina.bean.AfiliacionBajaCtasClabeBean;
import nomina.dao.AfiliacionBajaCtasClabeDAO;

public class AfiliacionBajaCtasClabeServicio extends BaseServicio{
	AfiliacionBajaCtasClabeDAO afiliacionBajaCtasClabeDAO = null;
	public AfiliacionBajaCtasClabeServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Lis_Afilia{
		int clienteNominaAlta = 1;
		int clientesNomiaTodos = 2;
		int listaConvenios	= 3;
		int folioAfiliaciones = 4;
		int listaExisteGrid = 5;
	}
	
	public static interface Enum_Con_Afilia{
		int principal = 1;
		int afiliacion = 3;
	}
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, List afiliacionBajaCtasClabeBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = afiliacionBajaCtasClabeDAO.grabaLista(afiliacionBajaCtasClabeBean,tipoTransaccion);
		return mensaje;
	}

	
	
	public AfiliacionBajaCtasClabeBean consulta( int tipoConsulta, AfiliacionBajaCtasClabeBean cliente){
		AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Afilia.principal:
				afiliacionBajaCtasClabeBean = afiliacionBajaCtasClabeDAO.consultaPrincipal(cliente,tipoConsulta);
				break;
			case Enum_Con_Afilia.afiliacion:
				afiliacionBajaCtasClabeBean = afiliacionBajaCtasClabeDAO.consultaAfiliacion(cliente,tipoConsulta);
				break;
		}
		return afiliacionBajaCtasClabeBean;
	}
	
	public List lista(int tipoLista,AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean ){
		List listaAfiliacion = null;
		switch (tipoLista) {
			case Enum_Lis_Afilia.clienteNominaAlta:		
				listaAfiliacion = afiliacionBajaCtasClabeDAO.listaPrincipal(afiliacionBajaCtasClabeBean, tipoLista);				
				break;
			case Enum_Lis_Afilia.clientesNomiaTodos:
				listaAfiliacion = afiliacionBajaCtasClabeDAO.listaClientesTodos(afiliacionBajaCtasClabeBean, tipoLista);
				break;
			case Enum_Lis_Afilia.listaConvenios:
				listaAfiliacion = afiliacionBajaCtasClabeDAO.listaConvenios(afiliacionBajaCtasClabeBean, tipoLista);
				break;
			case Enum_Lis_Afilia.folioAfiliaciones:
				listaAfiliacion = afiliacionBajaCtasClabeDAO.listaAfiliaciones(afiliacionBajaCtasClabeBean, tipoLista);
				break;
			case Enum_Lis_Afilia.listaExisteGrid:
				listaAfiliacion = afiliacionBajaCtasClabeDAO.listaAfiliacionesGrid(afiliacionBajaCtasClabeBean, tipoLista);
				break;
		}
		return listaAfiliacion;
	}
	
	
	
	
	public void generaLayout(List afiliacionBajaCtasClabeBean,int folioAfiliacion,HttpServletResponse response){


		try{
			AfiliacionBajaCtasClabeBean afiliacionArchivo = new AfiliacionBajaCtasClabeBean();
			int TipoConsulta = 2;
			ServletOutputStream ouputStream=null;
			BufferedWriter writer;
			Calendar date = Calendar.getInstance();
			String mes;
			String dia;
			String nombreArchivo="";
			if((date.get(Calendar.MONTH)+1)<10){
				mes = "0"+(date.get(Calendar.MONTH)+1);
			}else{
				mes = ""+(date.get(Calendar.MONTH)+1);
			}
			
			if(date.get(Calendar.DAY_OF_MONTH)<10){
				dia = "0"+date.get(Calendar.DAY_OF_MONTH);
			}else{
				dia=""+date.get(Calendar.DAY_OF_MONTH);
			}
			String FechaFormato =date.get(Calendar.YEAR)+mes+dia;
			
			
			
			afiliacionArchivo.setFolioAfiliacion(String.valueOf(folioAfiliacion));
			afiliacionArchivo = afiliacionBajaCtasClabeDAO.consultaArchivo(afiliacionArchivo,TipoConsulta);
			
			nombreArchivo = afiliacionArchivo.getNombreArchivo()+".alt";
			

			writer = new BufferedWriter(new FileWriter(nombreArchivo));
			String espacios ="                                                                                                                                                             ";
		
			
			writer.write("H"+afiliacionArchivo.getClabeBancoInst()+FechaFormato+Utileria.completaCerosIzquierda(afiliacionBajaCtasClabeBean.size(), 6)+"0"+"00"+espacios);
			AfiliacionBajaCtasClabeBean detalle;
			for(int i = 0;i<afiliacionBajaCtasClabeBean.size();i++){
				
				detalle = new AfiliacionBajaCtasClabeBean();
				detalle = (AfiliacionBajaCtasClabeBean)afiliacionBajaCtasClabeBean.get(i);
			
				writer.newLine();
				String MontoSinPunto = detalle.getMontoMaximoCobro().replace(".", "");
				String tipoPersona="";
				if(detalle.getTipoPersona().equalsIgnoreCase("F")||detalle.getTipoPersona().equalsIgnoreCase("A")){
					tipoPersona="2";
				}
				if(detalle.getTipoPersona().equalsIgnoreCase("M")){
					tipoPersona="1";
				}
				writer.write("D"+agregaEspacio(detalle.getReferencia(), 40,'D')+Utileria.completaCerosIzquierda(MontoSinPunto, 15)
				+detalle.getFolio()+agregaEspacio(detalle.getNombreCompleto(),40,'D')+detalle.getTipoCuentaSpei()
				+Utileria.completaCerosIzquierda(detalle.getClabe(), 18)+tipoPersona+detalle.getNumIdentificacion()
				+agregaEspacio(detalle.getIdentificacion(),20,'D')+agregaEspacio(detalle.getRfc(), 18,'D')+"01"+"00"
				+agregaEspacio(detalle.getTipoAfiliacion(),17,'D'));
				
			}
		
			writer.newLine();
			writer.close();

			FileInputStream archivoAfiliacion = new FileInputStream(nombreArchivo);
			int longitud = archivoAfiliacion.available();
			byte[] datos = new byte[longitud];
			archivoAfiliacion.read(datos);
			archivoAfiliacion.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ouputStream = response.getOutputStream();
			ouputStream.write(datos);
			ouputStream.flush();
			ouputStream.close();

		}catch(IOException e){
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+" - generarLayout"+"-"+"Error en genenerar el layout "+ e);
		}
		
	}
	/*Metodo que se utiliza para generar el reporte en Excel para los datos a afiliar*/
	public void generaReporteExcel(List listaAfiliacion,String nombreArchivo,HttpServletResponse response) throws IOException{
		List listaParaExcel = listaAfiliacion;
		int contador = 1;
		Date date = new Date();
		DateFormat fecha = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat hora = new SimpleDateFormat("HH:mm:ss");

		if(listaParaExcel != null){
			try{
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
				
				//fuente Negrita
				Font fuenteNegrita= libro.createFont();
				fuenteNegrita.setFontHeightInPoints((short)8);
				fuenteNegrita.setFontName("Negrita");
				fuenteNegrita.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				CellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setAlignment((short)CellStyle.ALIGN_CENTER);
				estiloNeg10.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
				estiloNeg10.setFont(fuenteNegrita10);
				
				//Estilo negrita de 8  para encabezados del reporte
				CellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
			
				
				
				CellStyle estiloDatosCentrado = libro.createCellStyle();
				estiloDatosCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);  
		
				
				CellStyle estiloCentrado = libro.createCellStyle();
				estiloCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
				estiloCentrado.setFont(fuenteNegrita);
				
				CellStyle estiloIzquierda = libro.createCellStyle();
				estiloIzquierda.setAlignment((short)CellStyle.ALIGN_LEFT);
				estiloIzquierda.setVerticalAlignment((short)CellStyle.ALIGN_LEFT);
							
				
			
				// Creacion de hoja
			
				Sheet hoja = libro.createSheet("AfiliacionCuentasClabe");
				Row fila= hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				//Fin de configuracion y creacio de hoja
				
				
				 celda = fila.createCell((short)5);
				 celda.setCellValue("Usuario:");
				 celda.setCellStyle(estiloNeg8);
				 
				 celda = fila.createCell((short)6);
				 celda.setCellValue(afiliacionBajaCtasClabeDAO.getParametrosSesionBean().getClaveUsuario());
				 
				fila = hoja.createRow(1);
				celda = fila.createCell((short)1);

				celda.setCellValue(afiliacionBajaCtasClabeDAO.getParametrosSesionBean().getNombreInstitucion());
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda (0-based)
			    ));
				celda.setCellStyle(estiloNeg10);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Fecha:");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)6);
				celda.setCellValue(fecha.format(date));

				
				fila = hoja.createRow(2);
				celda = fila.createCell((short)1);
				celda.setCellValue("REPORTE AFILIACIÓN O BAJAS DE CUENTAS CLABES PARA DOMICILIACIÓN.");

				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda (0-based)
			    ));
				celda.setCellStyle(estiloNeg10);
				
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Hora:");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)6);
				celda.setCellValue(hora.format(date));

				
				fila = hoja.createRow(3);
				celda = fila.createCell((short)0);
				
				
				fila = hoja.createRow(4);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("No. Cliente");
				celda.setCellStyle(estiloCentrado);
				
				celda= fila.createCell((short)2);
				celda.setCellValue("Nombre Cliente");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Nombre Institución");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Cuenta Clabe");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Comentario");
				celda.setCellStyle(estiloCentrado);
				
				AfiliacionBajaCtasClabeBean afiliacion = null;
				int rowExcel = 5;
				for(int i=0 ; i<listaParaExcel.size();i++){
					afiliacion = (AfiliacionBajaCtasClabeBean) listaParaExcel.get(i);
					
					fila = hoja.createRow(rowExcel);
					
					celda = fila.createCell((short)1);
					celda.setCellValue(Utileria.completaCerosIzquierda(afiliacion.getClienteID(),afiliacion.LONGITUD_ID));
					celda.setCellStyle(estiloIzquierda);
					
					celda = fila.createCell((short)2);
					celda.setCellValue(afiliacion.getNombreCompleto());
					celda.setCellStyle(estiloIzquierda);
					
					celda = fila.createCell((short)3);
					celda.setCellValue(afiliacion.getNombreBanco());
					celda.setCellStyle(estiloIzquierda);
					
					celda = fila.createCell((short)4);
					celda.setCellValue(afiliacion.getClabe());
					celda.setCellStyle(estiloIzquierda);
					
					celda = fila.createCell((short)5);
					if(afiliacion.getComentario()!=null && !afiliacion.getComentario().isEmpty()){
						celda.setCellValue(afiliacion.getComentario());
						celda.setCellStyle(estiloIzquierda);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloIzquierda);
						
					}
					rowExcel++;
				}
				
				fila = hoja.createRow(rowExcel+1);
				celda = fila.createCell((short)1);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloCentrado);
				
				
				fila = hoja.createRow(rowExcel+2);
				celda = fila.createCell((short)1);
				celda.setCellValue(listaParaExcel.size());

				
				
				for(int celd=0; celd<=21; celd++)
					hoja.autoSizeColumn((short)celd);
				
				
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
			}catch(Exception ex){
				ex.printStackTrace();
			}
		}
	}

	
	
	public void crearDirectorio(String rutaDirectorio){
		File rutaNomina = new File(rutaDirectorio);
		try{
		if(!rutaNomina.exists()){
			rutaNomina.mkdirs();
		}
		}catch(Exception e){
			System.err.println("crearDirectorio"+"-"+"error en la creacion del directorio "+ e);
		}
	}
	
	public String agregaEspacio(String cadena,int longitud,char direccion){
		String cadenaNueva = cadena;

		longitud = longitud-cadena.length();
			if(direccion == 'I'){
				
				for(int i=0; i<longitud;i++){
					cadenaNueva = " "+cadenaNueva;
				}
			}
			if(direccion =='D'){
				for(int i=0; i<longitud;i++){
					cadenaNueva = cadenaNueva+" ";
				}
			}
		return cadenaNueva;
	}
	
	public AfiliacionBajaCtasClabeDAO getAfiliacionBajaCtasClabeDAO() {
		return afiliacionBajaCtasClabeDAO;
	}
	public void setAfiliacionBajaCtasClabeDAO(AfiliacionBajaCtasClabeDAO afiliacionBajaCtasClabeDAO) {
		this.afiliacionBajaCtasClabeDAO = afiliacionBajaCtasClabeDAO;
	}
	

}
