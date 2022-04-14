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

import pld.bean.NivelRiesgoPunBean;
import pld.servicio.NivelRiesgoPunServicio;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class ReporteHistNivelRiesgoPuntControlador extends AbstractCommandController {
	String					nombreReporte			= null;
	String					successView				= null;
	ParametrosSesionBean	parametrosSesionBean	= null;
	ParametrosSisServicio	parametrosSisServicio	= null;
	NivelRiesgoPunServicio nivelRiesgoPunServicio = null;	
	public static interface Enum_Con_TipRepor {
		int	EXCEL	= 1;
	}

	public ReporteHistNivelRiesgoPuntControlador() {
		setCommandClass(NivelRiesgoPunBean.class);
		setCommandName("nivelRiesgoPun");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		NivelRiesgoPunBean bean = (NivelRiesgoPunBean) command;
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		String htmlString = "";
		switch (tipoReporte) {
			case Enum_Con_TipRepor.EXCEL :
						reporteExcel(bean, request, response, tipoReporte);
				break;
		}
		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}
	private List<NivelRiesgoPunBean> reporteExcel(NivelRiesgoPunBean bean, HttpServletRequest request, HttpServletResponse response, int tipoReporte) {
		List<NivelRiesgoPunBean> listaReporte = null;
		try {
			listaReporte = nivelRiesgoPunServicio.listaReporte(tipoReporte,bean);
			
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
			hoja = libro.createSheet("HistoricoNivelRiesgo");
			
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
			celda.setCellValue("REPORTE HISTÓRICO DE NIVEL DE RIESGO DEL "+bean.getFechaInicio()+" AL "+bean.getFechaFinal());
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
			celda.setCellValue("Antecedentes del "+safilocaleCliente);
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Localidad");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Actividad Económica");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Origen de los Recursos");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Destino de los Recursos");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell(numCelda++);
			celda.setCellValue("Perfil Transaccional");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("EBR");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Total Ponderado");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Nivel Riesgo");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Proceso");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			for (int celd = 0; celd <= 42; celd++) {
				hoja.autoSizeColumn(celd, true);
			}
			int i = 8;
			if (listaReporte != null) {
				
				int tamanioLista = listaReporte.size();
				
				NivelRiesgoPunBean sitiBean = null;
				for (int iter = 0; iter < tamanioLista; iter++) {
					sitiBean = (NivelRiesgoPunBean) listaReporte.get(iter);
					
					numCelda = 0;
					fila = hoja.createRow(i);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getFecha()+sitiBean.getHora());
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
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getPorc1TotalAntec()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getPorc2Localidad()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getPorc3ActividadEc()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getPorc4TotalOriRe()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getPorc5TotalDesRe()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getPorc6TotalPerf()));
					celda.setCellStyle(estiloDecimalSinSimbol);

					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getPorc1TotalEBR()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(sitiBean.getTotalPonderado()));
					celda.setCellStyle(estiloDecimalSinSimbol);

					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getNivelRiesgoObt());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getTipoProceso());
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
				if(listaReporte!=null){
				celda.setCellValue(listaReporte.size());
				}
				celda.setCellStyle(estilo8);
				
				i++;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
			
			}

			for (int celd = 0; celd <= 42; celd++) {
				hoja.autoSizeColumn(celd, true);
			}
			//Creo la cabecera
			response.addHeader("Content-Disposition", "inline; filename=ReporteHistNivelRiesgo.xls");
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

	public NivelRiesgoPunServicio getNivelRiesgoPunServicio() {
		return nivelRiesgoPunServicio;
	}

	public void setNivelRiesgoPunServicio(NivelRiesgoPunServicio nivelRiesgoPunServicio) {
		this.nivelRiesgoPunServicio = nivelRiesgoPunServicio;
	}
	
}
