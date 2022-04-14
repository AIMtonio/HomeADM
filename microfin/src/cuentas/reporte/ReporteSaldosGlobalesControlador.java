package cuentas.reporte;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.RepSaldosGlobalesBean;
import cuentas.servicio.CuentasAhoServicio;
import herramientas.Utileria;

public class ReporteSaldosGlobalesControlador extends AbstractCommandController {

	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	CuentasAhoServicio cuentasAhoServicio = null;
	String nomReporte = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  reporExcel = 1;
	}
	
	public ReporteSaldosGlobalesControlador () {
		setCommandClass(RepSaldosGlobalesBean.class);
		setCommandName("repSaldosGlobalesBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		RepSaldosGlobalesBean repSaldosGlobalesBean = (RepSaldosGlobalesBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null) ? Integer.parseInt(request.getParameter("tipoReporte")): 0;
		int tipoLista =(request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")): 0;
		
		String htmlString= "";
		
		switch(tipoReporte){
			case Enum_Con_TipRepor.reporExcel:		
				List<RepSaldosGlobalesBean> listaReportes = saldosGlobalesExcel(tipoLista, repSaldosGlobalesBean, response);
			break;
		}
		
		return null;
	}
	
	 //Reporte de analitico ahorro en excel
	public List<RepSaldosGlobalesBean> saldosGlobalesExcel(int tipoLista, RepSaldosGlobalesBean repSaldosGlobalesBean,  HttpServletResponse response){

		List<RepSaldosGlobalesBean> listaSaldosGlobales = null;
		listaSaldosGlobales = cuentasAhoServicio.listaReporteSaldoGlobal(tipoLista, repSaldosGlobalesBean, response); 	

		try {
			
			Workbook libro = new SXSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)12);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			Font fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)10);
			fuenteNegrita8.setFontName("Arial");
			fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);

			Font fuenteTexto= libro.createFont();
			fuenteTexto.setFontHeightInPoints((short)10);
			fuenteTexto.setFontName("Arial");
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			
			//Estilo negrita de 8  para encabezados del reporte
			CellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			//Estilo negrita de 8  para encabezados del reporte
			CellStyle estiloTexto = libro.createCellStyle();
			estiloTexto.setFont(fuenteTexto);
			
			CellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			
			CellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo negrita de 8  y color de fondo
			CellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			estiloFormatoDecimal.setFont(fuenteTexto);
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja					
			SXSSFSheet hoja = (SXSSFSheet) libro.createSheet("REPORTE_SALDOS_GLOBALES");
			Row fila= hoja.createRow(0);
			
			// inicio usuario
			Cell celdaUsuario=fila.createCell((short)1);
			celdaUsuario = fila.createCell((short)12);
			celdaUsuario.setCellValue("Usuario:");
			celdaUsuario.setCellStyle(estiloNeg8);	
			celdaUsuario = fila.createCell((short)13);
			celdaUsuario.setCellValue((!repSaldosGlobalesBean.getNombreUsuario().isEmpty())?repSaldosGlobalesBean.getNombreUsuario(): "TODOS");
			celdaUsuario.setCellStyle(estiloTexto);

			String horaReporte  = repSaldosGlobalesBean.getHoraEmision();
			String fechaReporte = repSaldosGlobalesBean.getFechaEmision();
			
			if(!listaSaldosGlobales.isEmpty()){
				horaReporte  = listaSaldosGlobales.get(0).getHora().toString();
				fechaReporte = listaSaldosGlobales.get(0).getFecha().toString();
			}
			
			// Fecha
			fila = hoja.createRow(1);
			Cell celdaFecha=fila.createCell((short)1);
			celdaFecha.setCellStyle(estiloNeg10);
			celdaFecha.setCellValue(repSaldosGlobalesBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(
				//funcion para unir celdas
				1, //primera fila (0-based)
			    1, //ultima  fila (0-based)
			    1, //primer celda (0-based)
			    11 //ultima celda (0-based)
			));
			
			celdaFecha = fila.createCell((short)12);
			celdaFecha.setCellValue("Fecha:");
			celdaFecha.setCellStyle(estiloNeg8);	
			celdaFecha = fila.createCell((short)13);
			celdaFecha.setCellValue(fechaReporte);
			celdaFecha.setCellStyle(estiloTexto);
			
			// Titulo del reporte y Hora
			fila = hoja.createRow(2);
			Cell celdaTituloHora=fila.createCell((short)1);
			celdaTituloHora.setCellStyle(estiloNeg10);
			celdaTituloHora.setCellValue("REPORTE DE SALDOS GLOBALES" );
			hoja.addMergedRegion(new CellRangeAddress(
				//funcion para unir celdas
				2, //primera fila (0-based)
			    2, //ultima  fila (0-based)
			    1, //primer celda (0-based)
			    11 //ultima celda (0-based)
			));
			
			celdaTituloHora = fila.createCell((short)12);
			celdaTituloHora.setCellValue("Hora:");
			celdaTituloHora.setCellStyle(estiloNeg8);	
			celdaTituloHora = fila.createCell((short)13);
			celdaTituloHora.setCellValue(horaReporte);
			celdaTituloHora.setCellStyle(estiloTexto);
			
			// Creacion de fila
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			Cell celdaParametros = fila.createCell((short)1);
			celdaParametros = fila.createCell((short)1);
			celdaParametros.setCellValue("Cliente:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaParametros = fila.createCell((short)2);
			celdaParametros.setCellValue(repSaldosGlobalesBean.getNombreCliente());
			celdaParametros.setCellStyle(estiloTexto);
			
			celdaParametros = fila.createCell((short)4);
			celdaParametros.setCellValue("Tipo Cuenta:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaParametros = fila.createCell((short)5);
			celdaParametros.setCellValue(repSaldosGlobalesBean.getNombreTipoCuenta());
			celdaParametros.setCellStyle(estiloTexto);
			
			celdaParametros = fila.createCell((short)7);
			celdaParametros.setCellValue("Sucursal:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaParametros = fila.createCell((short)8);
			celdaParametros.setCellValue(repSaldosGlobalesBean.getNombreSucursal());
			celdaParametros.setCellStyle(estiloTexto);
			
			celdaParametros = fila.createCell((short)10);
			celdaParametros.setCellValue("Cuenta:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaParametros = fila.createCell((short)11);
			celdaParametros.setCellValue(repSaldosGlobalesBean.getNombreCuentaAho());
			celdaParametros.setCellStyle(estiloTexto);
			
			fila = hoja.createRow(5);
			Cell celdaParametros2 = fila.createCell((short)1);
			celdaParametros2 = fila.createCell((short)1);
			celdaParametros2.setCellValue("Moneda:");
			celdaParametros2.setCellStyle(estiloNeg8);
			celdaParametros2 = fila.createCell((short)2);
			celdaParametros2.setCellValue(repSaldosGlobalesBean.getNombreMoneda());
			celdaParametros2.setCellStyle(estiloTexto);
			
			celdaParametros2 = fila.createCell((short)4);
			celdaParametros2.setCellValue("Promotor:");
			celdaParametros2.setCellStyle(estiloNeg8);
			celdaParametros2 = fila.createCell((short)5);
			celdaParametros2.setCellValue(repSaldosGlobalesBean.getNombrePromotor());
			celdaParametros2.setCellStyle(estiloTexto);
			
			celdaParametros2 = fila.createCell((short)7);
			celdaParametros2.setCellValue("Genero:");
			celdaParametros2.setCellStyle(estiloNeg8);
			celdaParametros2 = fila.createCell((short)8);
			celdaParametros2.setCellValue(repSaldosGlobalesBean.getNombreGenero());
			celdaParametros2.setCellStyle(estiloTexto);
			
			celdaParametros2 = fila.createCell((short)10);
			celdaParametros2.setCellValue("Estado:");
			celdaParametros2.setCellStyle(estiloNeg8);
			celdaParametros2 = fila.createCell((short)11);
			celdaParametros2.setCellValue(repSaldosGlobalesBean.getNombreEstado());
			celdaParametros2.setCellStyle(estiloTexto);
			
			fila = hoja.createRow(6);
			Cell celdaParametros3 = fila.createCell((short)1);
			celdaParametros3 = fila.createCell((short)1);
			celdaParametros3.setCellValue("Municipio:");
			celdaParametros3.setCellStyle(estiloNeg8);
			celdaParametros3 = fila.createCell((short)2);
			celdaParametros3.setCellValue(repSaldosGlobalesBean.getNombreMunicipio());
			celdaParametros3.setCellStyle(estiloTexto);
			
			fila = hoja.createRow(7);
			fila = hoja.createRow(8);
			Cell celdaEncabezados = fila.createCell((short)1);
			
			celdaEncabezados = fila.createCell((short)1);
			celdaEncabezados.setCellValue("ID Cliente");
			celdaEncabezados.setCellStyle(estiloNeg8);
			
			celdaEncabezados = fila.createCell((short)2);
			celdaEncabezados.setCellValue("Nombre del Cliente");
			celdaEncabezados.setCellStyle(estiloNeg8);
			
			celdaEncabezados = fila.createCell((short)3);
			celdaEncabezados.setCellValue("RFC Oficial");
			celdaEncabezados.setCellStyle(estiloNeg8);
			
			celdaEncabezados = fila.createCell((short)4);
			celdaEncabezados.setCellValue("ID Sucursal");
			celdaEncabezados.setCellStyle(estiloNeg8);
			
			celdaEncabezados = fila.createCell((short)5);
			celdaEncabezados.setCellValue("N° Cuenta");
			celdaEncabezados.setCellStyle(estiloNeg8);
			
			celdaEncabezados = fila.createCell((short)6);
			celdaEncabezados.setCellValue("Descripción de la cuenta");
			celdaEncabezados.setCellStyle(estiloNeg8);
			
			celdaEncabezados = fila.createCell((short)7);
			celdaEncabezados.setCellValue("Estatus");
			celdaEncabezados.setCellStyle(estiloNeg8);
	
			celdaEncabezados = fila.createCell((short)8);
			celdaEncabezados.setCellValue("Saldo Ini. Mes");
			celdaEncabezados.setCellStyle(estiloNeg8);
			
			celdaEncabezados = fila.createCell((short)9);
			celdaEncabezados.setCellValue("Cargos Mes");
			celdaEncabezados.setCellStyle(estiloNeg8);			

			celdaEncabezados = fila.createCell((short)10);
			celdaEncabezados.setCellValue("Abonos del Mes");
			celdaEncabezados.setCellStyle(estiloNeg8);
			
			celdaEncabezados = fila.createCell((short)11);
			celdaEncabezados.setCellValue("Saldo");
			celdaEncabezados.setCellStyle(estiloNeg8);
			
			celdaEncabezados = fila.createCell((short)12);
			celdaEncabezados.setCellValue("Saldo Bloq.");
			celdaEncabezados.setCellStyle(estiloNeg8);

			celdaEncabezados = fila.createCell((short)13);
			celdaEncabezados.setCellValue("Saldo Disp.");
			celdaEncabezados.setCellStyle(estiloNeg8);
			
			int renglon = 9;
			int iteracion = 0;
			int numRegistros = 0;
			int tamanioLista = listaSaldosGlobales.size();
			RepSaldosGlobalesBean saldosGlobalesBean = null;
			
			for( iteracion =0; iteracion <tamanioLista; iteracion  ++){
				 
				saldosGlobalesBean = (RepSaldosGlobalesBean) listaSaldosGlobales.get(iteracion );
				fila=hoja.createRow(renglon);
				Cell celdaCuerpo = fila.createCell((short)1);
				
				celdaCuerpo=fila.createCell((short)1);
				celdaCuerpo.setCellValue(saldosGlobalesBean.getClienteID());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo=fila.createCell((short)2);
				celdaCuerpo.setCellValue(saldosGlobalesBean.getNombreCompleto());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo=fila.createCell((short)3);
				celdaCuerpo.setCellValue(saldosGlobalesBean.getRfcOficial());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo=fila.createCell((short)4);
				celdaCuerpo.setCellValue(saldosGlobalesBean.getSucursalID());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo=fila.createCell((short)5);
				celdaCuerpo.setCellValue(saldosGlobalesBean.getCuentaAhoID());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo=fila.createCell((short)6);
				celdaCuerpo.setCellValue(saldosGlobalesBean.getTipoCuenta());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo=fila.createCell((short)7);
				celdaCuerpo.setCellValue(saldosGlobalesBean.getEstatus());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo=fila.createCell((short)8);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(saldosGlobalesBean.getSaldoInicial()));
				celdaCuerpo.setCellStyle(estiloFormatoDecimal);
				
				celdaCuerpo=fila.createCell((short)9);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(saldosGlobalesBean.getCargos()));
				celdaCuerpo.setCellStyle(estiloFormatoDecimal);

				celdaCuerpo=fila.createCell((short)10);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(saldosGlobalesBean.getAbonos()));
				celdaCuerpo.setCellStyle(estiloFormatoDecimal);
				
				celdaCuerpo=fila.createCell((short)11);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(saldosGlobalesBean.getSaldo()));
				celdaCuerpo.setCellStyle(estiloFormatoDecimal);
				
				celdaCuerpo=fila.createCell((short)12);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(saldosGlobalesBean.getSaldoBloqueado()));
				celdaCuerpo.setCellStyle(estiloFormatoDecimal);
				
				celdaCuerpo=fila.createCell((short)13);
			    celdaCuerpo.setCellValue(Utileria.convierteDoble(saldosGlobalesBean.getSaldoDisponible()));
				celdaCuerpo.setCellStyle(estiloFormatoDecimal);
				
				renglon++;
				numRegistros = numRegistros+1;
			}
			
			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			Cell celdaPiePagina = fila.createCell((short)1);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue("Registros Exportados");
			celdaPiePagina.setCellStyle(estiloTexto);
			
			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue(numRegistros);
			celdaPiePagina.setCellStyle(estiloTexto);
			
			for(int celdaAjustar=0; celdaAjustar <=14; celdaAjustar++){
				hoja.autoSizeColumn((short)celdaAjustar);
			}

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepSaldosGlobales.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		} catch(Exception exception){
			loggerSAFI.info(this.getClass()+" - "+"Error al crear el reporte Saldos Globales: " + exception.getMessage());
			exception.printStackTrace();
		}
		return listaSaldosGlobales;
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}
	
	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
