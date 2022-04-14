package nomina.servicio;

import java.io.ByteArrayOutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import nomina.bean.BitacoraDomiciPagosBean;
import nomina.dao.BitacoraDomiciPagosDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class BitacoraDomiciPagosServicio extends BaseServicio{
	
	BitacoraDomiciPagosDAO bitacoraDomiciPagosDAO = null;
	
	public static interface Enum_Con_Bitacora {
		int principal	= 1;
		
	}
	
	public static interface Enum_Lis_Bitacora {
		int lisprincipal	= 1;
		int lisFrecuencias 	= 2;
	}
	
	public BitacoraDomiciPagosServicio(){
		super();
	}
	
	
	public BitacoraDomiciPagosBean consulta(int tipoConsulta, BitacoraDomiciPagosBean bitacoraDomiciPagosBean){
		BitacoraDomiciPagosBean bitacora = null;
		switch (tipoConsulta) {
		case Enum_Con_Bitacora.principal:
			bitacora = bitacoraDomiciPagosDAO.consultaBitacoraFecha(tipoConsulta,bitacoraDomiciPagosBean);
		break;
		
	}
	return bitacora;
	}

	public List lista(int tipoLista, BitacoraDomiciPagosBean bitacoraDomiciPagosBean){
		
		List listaBitacora = null;
		
		switch (tipoLista) {
		case Enum_Lis_Bitacora.lisFrecuencias:
			listaBitacora = bitacoraDomiciPagosDAO.listaFrecuenciaDomiciPagos(bitacoraDomiciPagosBean,tipoLista);
		break;

	}
	return listaBitacora;
	}
	
	public void generaReporteExcel(BitacoraDomiciPagosBean bitacoraBean,HttpServletResponse response){
		List listaParaExcel = bitacoraDomiciPagosDAO.listaReporteExcel(bitacoraBean, 1);
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
				
				// fuente 8 para los montos
				Font fuente8Izquierda= libro.createFont();
				fuente8Izquierda.setFontHeightInPoints((short)8);
				
				Font fuente8Derecha= libro.createFont();
				fuente8Derecha.setFontHeightInPoints((short)8);
				
				Font fuenteCentrado8 = libro.createFont();
				fuenteCentrado8.setFontHeightInPoints((short)8);
				
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
				estiloDatosCentrado.setFont(fuenteCentrado8);
				estiloDatosCentrado.setWrapText(true);
				
				CellStyle estiloCentrado = libro.createCellStyle();
				estiloCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
				estiloCentrado.setBorderBottom((short)1);
				estiloCentrado.setBorderLeft((short)1);
				estiloCentrado.setBorderRight((short)1);
				estiloCentrado.setBorderTop((short)1);
				
				estiloCentrado.setFont(fuenteNegrita);

				//estilo decimal para montos
				CellStyle estiloFormatoDecimal = libro.createCellStyle();
				DataFormat formatodecimal = libro.createDataFormat();
				estiloFormatoDecimal.setAlignment((short)CellStyle.ALIGN_RIGHT);
				estiloFormatoDecimal.setDataFormat(formatodecimal.getFormat("#,##0.00"));
				estiloFormatoDecimal.setFont(fuente8Derecha);
				estiloFormatoDecimal.setWrapText(true);
				
				
				//estilo izquierda
				CellStyle estiloizquierda8 = libro.createCellStyle();
				estiloizquierda8.setFont(fuente8Izquierda);
				estiloizquierda8.setAlignment((short)CellStyle.ALIGN_LEFT);
				estiloizquierda8.setWrapText(true);
				
				CellStyle estiloDerecha8 = libro.createCellStyle();
				estiloDerecha8.setFont(fuente8Derecha);
				estiloDerecha8.setAlignment((short)CellStyle.ALIGN_RIGHT);
				estiloDerecha8.setWrapText(true);
				// Creacion de hoja
			
				Sheet hoja = libro.createSheet("BitacoraPagosDomiciliados");
				Row fila= hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				//Fin de configuracion y creacio de hoja

				fila = hoja.createRow(1);
				celda = fila.createCell((short)4);

				celda.setCellValue("FINANCIERA S.A DE C.V");
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            4, //primer celda (0-based)
			            15  //ultima celda (0-based)
			    ));
				celda.setCellStyle(estiloNeg10);
				
				celda=fila.createCell((short)19);
				celda.setCellValue("Usuario: ");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short) 20);
				celda.setCellValue(bitacoraDomiciPagosDAO.getParametrosSesionBean().getClaveUsuario().toUpperCase());
				
				fila = hoja.createRow(2);
				celda = fila.createCell((short)4);
				celda.setCellValue("BITÁCORA DOMICILIACIÓN DEL "+bitacoraBean.getFechaInicio()+" AL "+bitacoraBean.getFechaFin());
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            4, //primer celda (0-based)
			            15  //ultima celda (0-based)
			    ));
				celda.setCellStyle(estiloNeg10);
				
				celda = fila.createCell((short)19);
				celda.setCellValue("Fecha: ");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short) 20);
				celda.setCellValue(bitacoraBean.getFechaReporte());
				
						
				
				
				fila = hoja.createRow(3);
				celda = fila.createCell((short)3);
				celda.setCellValue("Clientes: ");
				celda = fila.createCell((short)4);
				celda.setCellValue(bitacoraBean.getClienteID()+"-"+bitacoraBean.getNombreCliente());
				hoja.addMergedRegion(new CellRangeAddress(
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            4, //primer celda (0-based)
			            7  //ultima celda (0-based)
			    ));
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Fecha Inicio: ");
				celda = fila.createCell((short)9);
				celda.setCellValue(bitacoraBean.getFechaInicio());
				
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Fecha Final: ");				
				celda = fila.createCell((short)14);
				celda.setCellValue(bitacoraBean.getFechaFin());
				
				
				Cell celdaHora=fila.createCell((short)2);
				celdaHora = fila.createCell((short)19);
				
				celdaHora.setCellValue("Hora:");
				
				celdaHora.setCellStyle(estiloNeg8);	
				celdaHora = fila.createCell((short)20);
				
				String horaVar="";
				
				Calendar calendario = Calendar.getInstance();	 
				int hora2 =calendario.get(Calendar.HOUR_OF_DAY);
				int minutos = calendario.get(Calendar.MINUTE);
				int segundos = calendario.get(Calendar.SECOND);
				
				String h = "";
				String m = "";
				String s = "";
				if(hora2<10)h="0"+Integer.toString(hora2); else h=Integer.toString(hora2);
				if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
				if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);		
					 
				horaVar= h+":"+m+":"+s;
				
				celdaHora.setCellValue(horaVar);
				
				fila = hoja.createRow(4);			
				celda = fila.createCell((short)3);
				celda.setCellValue("Frecuencia: ");
				celda = fila.createCell((short)4);
				if(bitacoraBean.getFrecuencia().equals("") || bitacoraBean.getFrecuencia().equals("0")){
					celda.setCellValue(bitacoraBean.getFrecuencia()+" TODAS");
				}else{
					celda.setCellValue(((BitacoraDomiciPagosBean) listaParaExcel.get(0)).getFrecuencia());
				}
				
				
				

				fila = hoja.createRow(5);
				celda = fila.createCell((short)0);
				celda.setCellValue("Folio Aplicación");
				celda.setCellStyle(estiloCentrado);
				
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Fecha");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Hora");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Referencia");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("No. Cliente");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Nombre Cliente");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("No. Crédito");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Empresa");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("No. Convenio");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Bancos");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Cuenta CLABE");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Monto Aplicado");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Monto no Aplicado");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Monto Pendiente por Cubrir");
				celda.setCellStyle(estiloCentrado);
				
				
				celda = fila.createCell((short)14);
				celda.setCellValue("Cuotas Pendientes por Cubrir");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("Código de Respuesta");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("Frecuencia Pagos");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("Fecha Vencimiento");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)18);
				celda.setCellValue("Monto Otorgado");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)19);
				celda.setCellValue("No. Cuota");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)20);
				celda.setCellValue("Monto Cuota");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)21);
				celda.setCellValue("Es Reprocesado");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)22);
				celda.setCellValue("No. Transacción");
				celda.setCellStyle(estiloCentrado);
				
				BitacoraDomiciPagosBean bitacoraDomiciPagosBean = null;
				int rowExcel = 6;
				for(int i=0 ; i<listaParaExcel.size();i++){
					bitacoraDomiciPagosBean = (BitacoraDomiciPagosBean) listaParaExcel.get(i);
					
					fila = hoja.createRow(rowExcel);
					
					celda = fila.createCell((short)0);
					celda.setCellValue(bitacoraDomiciPagosBean.getFolioID());
					celda.setCellStyle(estiloDerecha8);
					
					celda = fila.createCell((short)1);
					celda.setCellValue(bitacoraDomiciPagosBean.getFecha());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short)2);
					celda.setCellValue(bitacoraDomiciPagosBean.getHora());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short)3);
					celda.setCellValue(bitacoraDomiciPagosBean.getReferencia());
					celda.setCellStyle(estiloizquierda8);
					
					celda = fila.createCell((short)4);
					celda.setCellValue(bitacoraDomiciPagosBean.getClienteID());
					celda.setCellStyle(estiloDerecha8);
					
					celda = fila.createCell((short)5);
					celda.setCellValue(bitacoraDomiciPagosBean.getNombreCliente());
					celda.setCellStyle(estiloizquierda8);
					
					celda = fila.createCell((short)6);
					celda.setCellValue(bitacoraDomiciPagosBean.getCreditoID());
					celda.setCellStyle(estiloDerecha8);
					
					celda = fila.createCell((short)7);
					if(bitacoraDomiciPagosBean.getNombreInstitNomina()!= null && !bitacoraDomiciPagosBean.getNombreInstitNomina().isEmpty()){
					celda.setCellValue(bitacoraDomiciPagosBean.getNombreInstitNomina());
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
					}
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short)8);
					if(bitacoraDomiciPagosBean.getConvenio()!=null && !bitacoraDomiciPagosBean.getConvenio().isEmpty()){
						celda.setCellValue(bitacoraDomiciPagosBean.getConvenio());
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
					}
					celda.setCellStyle(estiloDerecha8);
					
					celda = fila.createCell((short)9);
					celda.setCellValue(bitacoraDomiciPagosBean.getNombreInstitucion());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short)10);
					celda.setCellValue(bitacoraDomiciPagosBean.getCuentaClabe());
					celda.setCellStyle(estiloDerecha8);
					
					celda = fila.createCell((short)11);
					celda.setCellValue(Utileria.convierteDoble(bitacoraDomiciPagosBean.getMontoAplicado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)12);
					celda.setCellValue(Utileria.convierteDoble(bitacoraDomiciPagosBean.getMontoNoAplicado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)13);
					celda.setCellValue(Utileria.convierteDoble(bitacoraDomiciPagosBean.getMontoPendiente()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)14);
					if(bitacoraDomiciPagosBean.getCuotasPendientes()!=null && !bitacoraDomiciPagosBean.getCuotasPendientes().isEmpty()){
						celda.setCellValue(bitacoraDomiciPagosBean.getCuotasPendientes());
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
					}
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short)15);
					celda.setCellValue(bitacoraDomiciPagosBean.getClaveDomicilia());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short)16);
					celda.setCellValue(bitacoraDomiciPagosBean.getFrecuencia());
					celda.setCellStyle(estiloizquierda8);
					
					celda = fila.createCell((short)17);
					celda.setCellValue(bitacoraDomiciPagosBean.getFechaVencimiento());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short)18);
					celda.setCellValue(Utileria.convierteDoble(bitacoraDomiciPagosBean.getMontoOtorgado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)19);
					if(bitacoraDomiciPagosBean.getNumCuotas()!=null && !bitacoraDomiciPagosBean.getNumCuotas().isEmpty()){
						celda.setCellValue(bitacoraDomiciPagosBean.getNumCuotas());
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
					}
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short)20);
					celda.setCellValue(Utileria.convierteDoble(bitacoraDomiciPagosBean.getMontoCuota()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)21);
					celda.setCellValue(bitacoraDomiciPagosBean.getReprocesado());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short)22);
					celda.setCellValue(bitacoraDomiciPagosBean.getNumTransaccion());
					celda.setCellStyle(estiloDerecha8);
					
					rowExcel++;
				}
				fila = hoja.createRow(rowExcel+1);
				celda = fila.createCell((short)1);
				celda.setCellValue("Registros Exportados");
				
				
				
				
				fila = hoja.createRow(rowExcel+2);
				celda = fila.createCell((short)1);
				celda.setCellValue(listaParaExcel.size());

				
				
				for(int celd=0; celd<=22; celd++)
					hoja.autoSizeColumn((short)celd);
				
				
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=BitacoraDomiciPagos.xlsx");
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
	
	
	
	
	
	public ByteArrayOutputStream repBitacoraPDF(BitacoraDomiciPagosBean bitacoraBean,String nombreReporte)throws Exception{
		DateFormat hora = new SimpleDateFormat("HH:mm:ss");	
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FolioID",bitacoraBean.getFolioID());
		parametrosReporte.agregaParametro("Par_FechaInicio",bitacoraBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",bitacoraBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_ClienteID",bitacoraBean.getClienteID());
		parametrosReporte.agregaParametro("Par_InstitNominaID",bitacoraBean.getInstitNominaID());
		parametrosReporte.agregaParametro("Par_Frecuencia",bitacoraBean.getFrecuencia());
		parametrosReporte.agregaParametro("Par_Usuario", bitacoraDomiciPagosDAO.getParametrosSesionBean().getClaveUsuario().toUpperCase());
		parametrosReporte.agregaParametro("Par_FechaReporte",bitacoraBean.getFechaReporte());
		parametrosReporte.agregaParametro("Par_Clientes",bitacoraBean.getClienteID()+" "+bitacoraBean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_Hora", hora.format(new Date()));
		parametrosReporte.agregaParametro("Par_Institucion", bitacoraBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_DesFrecuencia",bitacoraBean.getDescFrecuencia());
		
		parametrosReporte.agregaParametro("Par_NombreInsNomina",bitacoraBean.getInstitNominaID()+"-"+bitacoraBean.getInstitNomina());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, 
									bitacoraDomiciPagosDAO.getParametrosAuditoriaBean().getRutaReportes(),
									bitacoraDomiciPagosDAO.getParametrosAuditoriaBean().getRutaImgReportes());
	}
	
	
	
	
	
	
	
	public BitacoraDomiciPagosDAO getBitacoraDomiciPagosDAO() {
		return bitacoraDomiciPagosDAO;
	}


	public void setBitacoraDomiciPagosDAO(BitacoraDomiciPagosDAO bitacoraDomiciPagosDAO) {
		this.bitacoraDomiciPagosDAO = bitacoraDomiciPagosDAO;
	}
	
	
	
}
