package bancaMovil.reporte;

import java.util.Calendar;
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
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import bancaMovil.bean.BAMOperacionBean;
import bancaMovil.servicio.BAMBitacoraOperServicio;
import bancaMovil.servicio.BAMBitacoraOperServicio.Enum_Lis_BitacoraOper;

public class RepBitacoraOperControlador extends AbstractCommandController {

	public static interface Enum_Tipo_Reporte {
		int excel = 2;
	}

	BAMBitacoraOperServicio bitacoraOperRepServicio = null;

	String successView = null;

	public RepBitacoraOperControlador() {
		setCommandClass(BAMOperacionBean.class);
		setCommandName("bitacoraOperRepBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		BAMOperacionBean operacionBean = (BAMOperacionBean) command;
		
		String usuario = (request.getParameter("usuario") != null) ? request.getParameter("usuario") : " ";
		String nombreInstitucion = (request.getParameter("nombreInstitucion") != null) ? request.getParameter("nombreInstitucion") : " ";

		int tipoReporte = (request.getParameter("tipoRep") != null) ? Integer.parseInt(request.getParameter("tipoRep")) : 0;
		int numReporte = (request.getParameter("numReporte") != null)? Integer.parseInt(request.getParameter("numReporte")) : 0;

		switch (tipoReporte) {
		case Enum_Tipo_Reporte.excel:
			listaReporte(operacionBean, usuario, nombreInstitucion, tipoReporte, numReporte ,response);
			break;

		}
		return null;
	}

	public List<?> listaReporte(BAMOperacionBean operacionBean, String usuario, String nombreInstitucion, int tipoReporte, int numReporte, HttpServletResponse response) {
		List<?> list = null;

		if (tipoReporte == Enum_Tipo_Reporte.excel) {
			list = bitacoraOperRepServicio.lista(operacionBean, Enum_Lis_BitacoraOper.principal);
		}

		Calendar calendario = Calendar.getInstance();

		if (list != null) {
			try {

				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				HSSFFont fuenteNegrita10 = libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short) 10);
				fuenteNegrita10.setFontName("Arial");
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);

				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuente10 = libro.createFont();
				fuente10.setFontHeightInPoints((short) 10);
				fuente10.setFontName("Arial");

				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);

				//Estilo negrita de 8  para encabezados del reporte												
				HSSFCellStyle estiloCentrado = libro.createCellStyle();
				estiloCentrado.setFont(fuenteNegrita10);
				estiloCentrado.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short) HSSFCellStyle.VERTICAL_CENTER);

				//Estilo negrita de 8  para encabezados del reporte												
				HSSFCellStyle estiloCentradoNoNeg = libro.createCellStyle();
				estiloCentradoNoNeg.setFont(fuente10);
				estiloCentradoNoNeg.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);

				CellStyle estiloDerechoNoNeg = libro.createCellStyle();
				estiloDerechoNoNeg.setAlignment(CellStyle.ALIGN_RIGHT);

				//Estilo negrita de 8  para encabezados del reporte
				HSSFCellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita10);

				//Estilo Formato decimal (0.00)
				HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));

				HSSFSheet hoja = libro.createSheet("BITACORA DE OPERACIONES");
				HSSFRow fila = hoja.createRow(0);
				
				if (tipoReporte == Enum_Tipo_Reporte.excel) {
					fila = hoja.createRow(1);
					HSSFCell celda = fila.createCell((short) 1);
					
					celda = fila.createCell	((short)1);//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue(nombreInstitucion);

					hoja.addMergedRegion(new CellRangeAddress( // Rango de filas que requeriremos para la union de estas
																// mismas
							1, // primera fila
							1, // ultima fila
							1, // primer celda
							4 // ultima celda

					));
					
					celda = fila.createCell((short)5);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Usuario:");		
					celda = fila.createCell((short)6);
					celda.setCellValue(usuario);

					fila = hoja.createRow(2);

					celda = fila.createCell((short) 1);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("REPORTE DE BITACORA DE OPERACIONES DEL " + operacionBean.getFechaInicio() + " AL " + operacionBean.getFechaFin());
					hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 4));

					int anio = calendario.get(Calendar.YEAR);
					int mes = calendario.get(Calendar.MONTH);
					int dia = calendario.get(Calendar.DAY_OF_MONTH);

					celda = fila.createCell((short) 5);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Fecha: ");
					celda = fila.createCell((short) 6);
					celda.setCellValue(String.format("%02d", anio) + "-" + String.format("%02d", mes) + "-" + String.format("%02d", dia));

					fila = hoja.createRow(3);

					celda = fila.createCell((short) 5);
					celda.setCellValue("Hora: ");
					celda.setCellStyle(estiloNeg8);
					celda = fila.createCell((short) 6);
					String horaVar = "";

					int hora = calendario.get(Calendar.HOUR_OF_DAY);
					int minutos = calendario.get(Calendar.MINUTE);
					int segundos = calendario.get(Calendar.SECOND);

					String h = Integer.toString(hora);
					String m = "";
					String s = "";
					if (minutos < 10)
						m = "0" + Integer.toString(minutos);
					else
						m = Integer.toString(minutos);
					if (segundos < 10)
						s = "0" + Integer.toString(segundos);
					else
						s = Integer.toString(segundos);

					horaVar = h + ":" + m + ":" + s;
					celda.setCellValue(horaVar);

					fila = hoja.createRow(4);

					celda = fila.createCell((short) 1);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Cliente : ");

					celda = fila.createCell((short) 2);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue(operacionBean.getClienteID().concat(" - ").concat(operacionBean.getNombreCliente()));

					celda = fila.createCell((short) 3);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Tipo Operación : ");

					celda = fila.createCell((short) 4);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue(operacionBean.getDescripcionOperaciones());
					
					//Contents HEAD
					
					fila = hoja.createRow(6);
					int numCelda = 1;
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Fecha Operación");
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Descripción Operación");
					celda.setCellStyle(estiloCentrado);	
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Monto");
					celda.setCellStyle(estiloCentrado);	
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Referencia");
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Folio");
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Origen");
					celda.setCellStyle(estiloCentrado);
					
					// Contents Body
					
					int i=8,iter=0;
					int tamanioLista = list.size();
					BAMOperacionBean repCarteraRepBean = null;
					int linea = 0;
					
					for(iter=0; iter<tamanioLista; iter ++) {
						numCelda = 1;
						repCarteraRepBean =  (BAMOperacionBean) list.get(iter);
						
						fila=hoja.createRow(i);
						linea = i;
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(repCarteraRepBean.getOperationDate());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(repCarteraRepBean.getDescription());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellStyle(estiloDerechoNoNeg);
						celda.setCellValue(repCarteraRepBean.getAmount());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(repCarteraRepBean.getReference());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(repCarteraRepBean.getFolio());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(repCarteraRepBean.getOrigin());
					
						i++;
					}
					
					
					i = i+1;
					fila=hoja.createRow(i); // Fila Registros Exportados
					
					celda = fila.createCell((short)1);
					celda.setCellValue("Registros Exportados");
					celda.setCellStyle(estiloNeg8);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(tamanioLista);
					
					celda=fila.createCell((short)5);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Procedimiento");
					
					celda=fila.createCell((short)6);
					celda.setCellStyle(estiloDerechoNoNeg);
					celda.setCellValue("BANBITACORAOPERLIS");
					
					for(int celd=0; celd<=25; celd++) {
						hoja.autoSizeColumn((short)celd);
					}

				}

				response.addHeader("Content-Disposition", "inline; filename=ReporteBitacoraOperaciones.xls");
				response.setContentType("application/vnd.ms-excel");

				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return list;
	}

	public BAMBitacoraOperServicio getBitacoraOperRepServicio() {
		return bitacoraOperRepServicio;
	}

	public void setBitacoraOperRepServicio(BAMBitacoraOperServicio bitacoraOperRepServicio) {
		this.bitacoraOperRepServicio = bitacoraOperRepServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
