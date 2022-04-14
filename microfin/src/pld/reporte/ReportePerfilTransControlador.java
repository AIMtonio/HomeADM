package pld.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteArchivosBean;
import cliente.servicio.ClienteArchivosServicio;
import cliente.servicio.ClienteArchivosServicio.Enum_Lis_Archivo;
import cliente.servicio.ClienteArchivosServicio.Enum_Rep_Archivo;
import pld.bean.PerfilTransaccionalBean;
import pld.bean.ReportesSITIBean;
import pld.dao.ReportesSITIDAO;
import pld.servicio.PerfilTransaccionalServicio;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class ReportePerfilTransControlador extends AbstractCommandController {
	String					nombreReporte			= null;
	String					successView				= null;
	ParametrosSesionBean	parametrosSesionBean	= null;
	ParametrosSisServicio	parametrosSisServicio	= null;
	PerfilTransaccionalServicio perfilTransaccionalServicio = null;	
	public static interface Enum_Con_TipRepor {
		int	EXCEL	= 1;
		int EXCELAUTPERFIL = 2;
	}
	
	public ReportePerfilTransControlador() {
		setCommandClass(PerfilTransaccionalBean.class);
		setCommandName("perfilTransaccional");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		PerfilTransaccionalBean bean = (PerfilTransaccionalBean) command;
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		String htmlString = "";
		switch (tipoReporte) {
			case Enum_Con_TipRepor.EXCEL :
						reporteExcel(bean, request, response, tipoReporte);
				break;
			case Enum_Con_TipRepor.EXCELAUTPERFIL :
				repExcelAutPerfilTransac(bean, request, response, tipoReporte);
		break;
		}
		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}
	private List<PerfilTransaccionalBean> reporteExcel(PerfilTransaccionalBean bean, HttpServletRequest request, HttpServletResponse response, int tipoReporte) {
		List<PerfilTransaccionalBean> listaReporte = null;
		try {
			listaReporte = perfilTransaccionalServicio.listaReporte(tipoReporte,bean);
			
			// Se obtiene el tipo de institucion financiera
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
			String safilocaleCliente = Utileria.generaLocale("safilocale.cliente", parametrosSisBean.getNombreCortoInst());
			
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			String hora = postFormater.format(calendario.getTime());
			
			XSSFSheet hoja = null;
			XSSFWorkbook libro = null;
			libro = new XSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFFont fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			XSSFFont fuenteNegrita10Izq = libro.createFont();
			fuenteNegrita10Izq.setFontHeightInPoints((short) 10);
			fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10Izq.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short) 8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			// Fuente encabezado del reporte
			XSSFFont fuenteEncabezado = libro.createFont();
			fuenteEncabezado.setFontHeightInPoints((short) 8);
			fuenteEncabezado.setFontName(HSSFFont.FONT_ARIAL);
			fuenteEncabezado.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente8 = libro.createFont();
			fuente8.setFontHeightInPoints((short) 8);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);
			
			XSSFFont fuente8Decimal = libro.createFont();
			fuente8Decimal.setFontHeightInPoints((short) 8);
			fuente8Decimal.setFontName(HSSFFont.FONT_ARIAL);
			
			XSSFFont fuente8Cuerpo = libro.createFont();
			fuente8Cuerpo.setFontHeightInPoints((short) 8);
			fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);
			
			//Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente10 = libro.createFont();
			fuente8.setFontHeightInPoints((short) 10);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			XSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			
			//Alineado a la izq
			XSSFCellStyle estiloNeg10Izq = libro.createCellStyle();
			estiloNeg10Izq.setFont(fuenteNegrita10Izq);
			estiloNeg10Izq.setAlignment(XSSFCellStyle.ALIGN_LEFT);
			
			//Estilo negrita de 8  para encabezados del reporte
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			// Estilo de datos centrados 
			XSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteEncabezado);
			estiloCentrado.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
			
			XSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);
			
			XSSFCellStyle estilo10 = libro.createCellStyle();
			estilo8.setFont(fuente10);
			
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			XSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
			estiloFormatoDecimal.setFont(fuente8);
			
			XSSFCellStyle estiloDecimalSinSimbol = libro.createCellStyle();
			XSSFDataFormat format2 = libro.createDataFormat();
			estiloDecimalSinSimbol.setDataFormat(format2.getFormat("#,###,##0.00"));
			estiloDecimalSinSimbol.setFont(fuente8Decimal);
			estiloDecimalSinSimbol.setAlignment(XSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimalTit = libro.createCellStyle();
			XSSFDataFormat formatTit = libro.createDataFormat();
			estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
			estiloFormatoDecimalTit.setFont(fuenteNegrita8);
			
			// Creacion de hoja					
			hoja = libro.createSheet("PerfilTransaccional");
			
			// inicio fecha, usuario,institucion y hora
			XSSFRow fila = hoja.createRow(0);
			XSSFCell celdaUsu = fila.createCell(9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg10Izq);
			celdaUsu = fila.createCell(10);
			celdaUsu.setCellValue(((!bean.getUsuario().isEmpty()) ? bean.getUsuario() : "TODOS").toUpperCase());
			
			fila = hoja.createRow(1);
			String fechaVar = bean.getFechaSistema().toString();
			XSSFCell celdaFec = fila.createCell(9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg10Izq);
			celdaFec = fila.createCell(10);
			celdaFec.setCellValue(fechaVar);
			
			XSSFCell celdaInst = fila.createCell((short) 1);
			celdaInst.setCellValue(bean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			1, //primera fila (0-based)
			1, //ultima fila  (0-based)
			1, //primer celda (0-based)
			8 //ultima celda   (0-based)
			));
			celdaInst.setCellStyle(estiloNeg10);
			
			fila = hoja.createRow(2);
			XSSFCell celdaHora = fila.createCell(9);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg10Izq);
			celdaHora = fila.createCell(10);
			celdaHora.setCellValue(hora);
			// fin fecha usuario,institucion y hora
			XSSFCell celda = fila.createCell((short) 1);
			celda.setCellValue("REPORTE DE PERFIL TRANSACCIONAL DEL "+bean.getFechaInicio()+" AL "+bean.getFechaFinal());
			celda.setCellStyle(estiloNeg10);
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			2, //primera fila (0-based)
			2, //ultima fila  (0-based)
			1, //primer celda (0-based)
			8 //ultima celda   (0-based)
			));
			celda.setCellStyle(estiloNeg10);
			
			
			fila = hoja.createRow(5);
			XSSFCell celdaSucur = fila.createCell(0);
			
			if(Utileria.convierteEntero(bean.getClienteID())==0){
				celdaSucur.setCellValue("Sucursal:");
				celdaSucur.setCellStyle(estiloNeg10Izq);
				celdaSucur = fila.createCell(1);
				celdaSucur.setCellStyle(estilo10);
				celdaSucur.setCellValue(bean.getSucursalID()+" - "+bean.getSucursalDes());
				
				celdaSucur = fila.createCell(3);
				celdaSucur.setCellValue("Tipo de Persona:");
				celdaSucur.setCellStyle(estiloNeg10Izq);
				celdaSucur = fila.createCell(4);
				celdaSucur.setCellStyle(estilo10);
				celdaSucur.setCellValue(bean.getTipoPersonaDes());
			} else {
				celdaSucur.setCellValue(safilocaleCliente+": ");
				celdaSucur.setCellStyle(estiloNeg10Izq);
				celdaSucur = fila.createCell(1);
				celdaSucur.setCellStyle(estilo10);
				celdaSucur.setCellValue(bean.getClienteID()+" - "+bean.getNombreCompleto());
			}
			
			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			fila = hoja.createRow(6);
			int numCelda = 0;
			celda = fila.createCell(numCelda);
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			

			celda = fila.createCell(numCelda++);
			celda.setCellValue("Fecha");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue(safilocaleCliente);
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Nombre Completo");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Nivel Riesgo");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Perfil Transaccional inicial\n(Monto Depósitos)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Perfil Transaccional Real Depósitos\n(Monto Depósitos)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Porcentaje excedido Depósitos\n(Monto Depósitos)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Perfil Transaccional inicial\n(Monto Retiros)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Perfil Transaccional Real Retiros\n(Monto Retiros)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Porcentaje excedido Retiros\n(Monto Retiros)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell(numCelda++);
			celda.setCellValue("Perfil Transaccional inicial\n(Número Depósitos)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Perfil Transaccional Real\n(Número Depósitos)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Porcentaje excedido\n(Número Depósitos)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Perfil Transaccional inicial\n(Número Retiros)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Perfil Transaccional Real\n(Número Retiros)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Porcentaje excedido\n(Número Retiros)");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			for (int celd = 0; celd <= 42; celd++) {
				hoja.autoSizeColumn(celd, true);
			}
			int i = 8;
			if (listaReporte != null) {
				
				int tamanioLista = listaReporte.size();
				
				PerfilTransaccionalBean sitiBean = null;
				for (int iter = 0; iter < tamanioLista; iter++) {
					sitiBean = (PerfilTransaccionalBean) listaReporte.get(iter);
					
					numCelda = 0;
					fila = hoja.createRow(i);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getFecha());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getClienteID());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getNombreCompleto());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getNivelRiesgo());
					celda.setCellStyle(estilo8);
					
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getAntDepositosMax()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getDepositosMax()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getPorcExcDepo()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getAntRetirosMax()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getRetirosMax()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getRetirosExc()));
					celda.setCellStyle(estiloDecimalSinSimbol);

					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getAntNumDepositos()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getNumDepositos()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getNumDepEx()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getAntNumRetiros()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getNumRetiros()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getNumRetEx()));
					celda.setCellStyle(estiloDecimalSinSimbol);

					i++;
				}
				
				i = i + 2;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue("Registros Exportados:");
				celda.setCellStyle(estiloNeg8);
				i++;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue(listaReporte.size());
				celda.setCellStyle(estilo8);
				
				i++;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
			
			}

			for (int celd = 0; celd <= 42; celd++) {
				hoja.autoSizeColumn(celd, true);
			}
			//Creo la cabecera
			response.addHeader("Content-Disposition", "inline; filename=ReportePerfilTransaccional.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return listaReporte;
	}
	
	private List<PerfilTransaccionalBean> repExcelAutPerfilTransac(PerfilTransaccionalBean bean, HttpServletRequest request, HttpServletResponse response, int tipoReporte) {
		List<PerfilTransaccionalBean> listaReporte = null;
		try {
			listaReporte = perfilTransaccionalServicio.listaReporte(tipoReporte,bean);
			
			// Se obtiene el tipo de institucion financiera
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
			String safilocaleCliente = Utileria.generaLocale("safilocale.cliente", parametrosSisBean.getNombreCortoInst());
			
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			String hora = postFormater.format(calendario.getTime());
			
			XSSFSheet hoja = null;
			XSSFWorkbook libro = null;
			libro = new XSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFFont fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			XSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			
			XSSFFont fuenteNegrita10Izq = libro.createFont();
			fuenteNegrita10Izq.setFontHeightInPoints((short) 10);
			fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10Izq.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			//Alineado a la izq
			XSSFCellStyle estiloNeg10Izq = libro.createCellStyle();
			estiloNeg10Izq.setFont(fuenteNegrita10Izq);
			estiloNeg10Izq.setAlignment(XSSFCellStyle.ALIGN_LEFT);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short) 8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			//Estilo negrita de 8  para encabezados del reporte
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			// Fuente encabezado del reporte
			XSSFFont fuenteEncabezado = libro.createFont();
			fuenteEncabezado.setFontHeightInPoints((short) 8);
			fuenteEncabezado.setFontName(HSSFFont.FONT_ARIAL);
			fuenteEncabezado.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			// Estilo de datos centrados 
			XSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteEncabezado);
			estiloCentrado.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
			
			//Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente8 = libro.createFont();
			fuente8.setFontHeightInPoints((short) 8);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);
			
			XSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);
			
			//Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente10 = libro.createFont();
			fuente10.setFontHeightInPoints((short) 10);
			fuente10.setFontName(HSSFFont.FONT_ARIAL);
			
			XSSFCellStyle estilo10 = libro.createCellStyle();
			estilo10.setFont(fuente10);
			
			XSSFFont fuente8Cuerpo = libro.createFont();
			fuente8Cuerpo.setFontHeightInPoints((short) 8);
			fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);
			
			XSSFCellStyle estiloMoneda = libro.createCellStyle();
			XSSFDataFormat format3 = libro.createDataFormat();
			estiloMoneda.setDataFormat(format3.getFormat("$#,##0.00"));
			estiloMoneda.setFont(fuente8);
			// Creacion de hoja					
			hoja = libro.createSheet("PerfilTransaccional");
			
			// inicio fecha, usuario,institucion y hora
			XSSFRow fila = hoja.createRow(0);
			XSSFCell celdaUsu = fila.createCell(9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg10Izq);
			celdaUsu = fila.createCell(10);
			celdaUsu.setCellValue(((!bean.getUsuario().isEmpty()) ? bean.getUsuario() : "TODOS").toUpperCase());
			
			fila = hoja.createRow(1);
			String fechaVar = bean.getFechaSistema().toString();
			XSSFCell celdaFec = fila.createCell(9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg10Izq);
			celdaFec = fila.createCell(10);
			celdaFec.setCellValue(fechaVar);
			
			XSSFCell celdaInst = fila.createCell((short) 1);
			celdaInst.setCellValue(bean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			1, //primera fila (0-based)
			1, //ultima fila  (0-based)
			1, //primer celda (0-based)
			8 //ultima celda   (0-based)
			));
			celdaInst.setCellStyle(estiloNeg10);
			
			fila = hoja.createRow(2);
			XSSFCell celdaHora = fila.createCell(9);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg10Izq);
			celdaHora = fila.createCell(10);
			celdaHora.setCellValue(hora);
			// fin fecha usuario,institucion y hora
			XSSFCell celda = fila.createCell((short) 1);
			celda.setCellValue("REPORTE DE TRANSACCIÓN REAL DEL "+bean.getFechaInicio()+" AL "+bean.getFechaFinal());
			celda.setCellStyle(estiloNeg10);
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			2, //primera fila (0-based)
			2, //ultima fila  (0-based)
			1, //primer celda (0-based)
			8 //ultima celda   (0-based)
			));
			celda.setCellStyle(estiloNeg10);
			
			fila = hoja.createRow(5);
			
			XSSFCell celdaSucur = fila.createCell(0);
			celdaSucur.setCellValue("Sucursal:");
			celdaSucur.setCellStyle(estiloNeg10Izq);
			celdaSucur = fila.createCell(1);
			celdaSucur.setCellValue(bean.getSucursalID()+" - "+bean.getSucursalDes());
			celdaSucur.setCellStyle(estilo10);
			XSSFCell celdaCliente = fila.createCell(3);
			celdaCliente.setCellValue("Cliente:");
			celdaCliente.setCellStyle(estiloNeg10Izq);
			celdaCliente = fila.createCell(4);
			celdaCliente.setCellValue(bean.getClienteID()+" - "+bean.getNombreCompleto());
			celdaCliente.setCellStyle(estilo10);
		
			
			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			fila = hoja.createRow(6);
			int numCelda = 0;
			celda = fila.createCell(numCelda);
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Fecha");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Cliente");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Nombre Completo");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Monto Máximo Depósitos");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Número de Depósitos");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Monto Máximo Retiros");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Número de Retiros");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			
			for (int celd = 0; celd <= 7; celd++) {
				hoja.autoSizeColumn(celd, true);
			}
			int i = 8;
			if (listaReporte != null) {
				
				int tamanioLista = listaReporte.size();
				
				PerfilTransaccionalBean sitiBean = null;
				for (int iter = 0; iter < tamanioLista; iter++) {
					sitiBean = (PerfilTransaccionalBean) listaReporte.get(iter);
					
					numCelda = 0;
					fila = hoja.createRow(i);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getFecha());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getClienteID());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getNombreCompleto());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getDepositosMax()));
					celda.setCellStyle(estiloMoneda);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getNumDepositos());
					celda.setCellStyle(estilo8);
			
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getRetirosMax()));
					celda.setCellStyle(estiloMoneda);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getNumRetiros());
					celda.setCellStyle(estilo8);
					
					i++;
				}
				
				i = i + 2;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue("Registros Exportados:");
				celda.setCellStyle(estiloNeg8);
				i++;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue(listaReporte.size());
				celda.setCellStyle(estilo8);
				
				i++;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue("PLDPERFILTRANSREP");
				celda.setCellStyle(estilo8);
			
			}

			for (int celd = 0; celd <= 7; celd++) {
				hoja.autoSizeColumn(celd, true);
			}
			//Creo la cabecera
			response.addHeader("Content-Disposition", "inline; filename=ReporteAutPerfilTransaccional.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return listaReporte;
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

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public PerfilTransaccionalServicio getPerfilTransaccionalServicio() {
		return perfilTransaccionalServicio;
	}

	public void setPerfilTransaccionalServicio(PerfilTransaccionalServicio perfilTransaccionalServicio) {
		this.perfilTransaccionalServicio = perfilTransaccionalServicio;
	}

	
}
