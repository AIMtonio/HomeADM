package activos.reporte;

import herramientas.Constantes;
import herramientas.Utileria;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Calendar;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import activos.bean.RepCatalogoActivosBean;
import activos.servicio.RepCatalogoActivosServicio;

public class RepCatalogoActivosControlador extends AbstractCommandController{

	RepCatalogoActivosServicio repCatalogoActivosServicio = null;

	String nombreReporte = null;
	String successView = null;

	public static interface Enum_Con_TipoReporte {
		int  ReporteExcel = 1;
	}

	public RepCatalogoActivosControlador(){
		setCommandClass(RepCatalogoActivosBean.class);
 		setCommandName("repCatalogoActivosBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		RepCatalogoActivosBean repCatalogoActivosBean =(RepCatalogoActivosBean)command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;

		switch(tipoReporte){
			case Enum_Con_TipoReporte.ReporteExcel:
				 List<RepCatalogoActivosBean>listaReportes = repCatalogoActivosExcel(tipoLista,repCatalogoActivosBean,response,request);
			break;
		}
		return null;
	}

	// Reporte Catalogo de Activos en Excel
	public List repCatalogoActivosExcel(int tipoLista,RepCatalogoActivosBean repCatalogoActivosBean,  HttpServletResponse response,HttpServletRequest request){
		List listaCatalogoActivos = null;
		listaCatalogoActivos = repCatalogoActivosServicio.listaCatalogoActivos(tipoLista,repCatalogoActivosBean,response);

		int regExport = 0;

		try {

			XSSFWorkbook libro = new XSSFWorkbook();
			
			//Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFCellStyle estiloTitulo = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para los Parametros del reporte.
			XSSFCellStyle estiloParametros = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Sin Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTextoDer = Utileria.crearFuente(libro, 10, Constantes.FUENTE_DERECHA, Constantes.FUENTE_NOBOLD);
			
			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTextoNeg = Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_BOLD);
			
			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTextoDerNeg = Utileria.crearFuente(libro, 10, Constantes.FUENTE_DERECHA, Constantes.FUENTE_BOLD);

			//Sin Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTextoCentrado = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_NOBOLD);

			//Sin Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloDecimal = Utileria.crearFuenteDecimal(libro, 10,  Constantes.FUENTE_NOBOLD);
			
			//Fuente Negrita con tamaño 10 para informacion del reporte Valores de Total.
			XSSFCellStyle estiloDecimalNeg = Utileria.crearFuenteDecimal(libro, 10,  Constantes.FUENTE_BOLD);


			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("CatalogoActivos");
			XSSFRow fila= hoja.createRow(0);

			// Nombre Usuario
			XSSFCell celdaini = fila.createCell((short)1);
			celdaini = fila.createCell((short)11);
			celdaini.setCellValue("Usuario:");
			celdaini.setCellStyle(estiloTextoNeg);
			celdaini = fila.createCell((short)12);
			celdaini.setCellValue(repCatalogoActivosBean.getClaveUsuario());

			// Descripcion del Reporte
			fila	= hoja.createRow(1);

			// Fecha en que se genera el reporte
			XSSFCell celdafin = fila.createCell((short)11);
			celdafin.setCellValue("Fecha:");
			celdafin.setCellStyle(estiloTextoNeg);
			celdafin = fila.createCell((short)12);
			celdafin.setCellValue(repCatalogoActivosBean.getFechaSistema());

			// Nombre Institucion
			XSSFCell celdaInst=fila.createCell((short)1);
			celdaInst=fila.createCell((short)1);
			celdaInst.setCellStyle(estiloTitulo);
			celdaInst.setCellValue(repCatalogoActivosBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //first row (0-based)
		            1, //last row  (0-based)
		            1, //first column (0-based)
		            9  //last column  (0-based)
		    ));

			// Hora en que se genera el reporte
			fila = hoja.createRow(2);
			XSSFCell celda=fila.createCell((short)1);
			celda = fila.createCell((short)11);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloTextoNeg);
			celda = fila.createCell((short)12);

			String horaVar="";

			Calendar calendario = Calendar.getInstance();
			int hora =calendario.get(Calendar.HOUR_OF_DAY);
			int minutos = calendario.get(Calendar.MINUTE);
			int segundos = calendario.get(Calendar.SECOND);

			String h = Integer.toString(hora);
			String m = "";
			String s = "";
			if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
			if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);

			horaVar= h+":"+m+":"+s;

			celda.setCellValue(horaVar);

			XSSFCell celdaR=fila.createCell((short)2);
			celdaR	= fila.createCell((short)1);
			celdaR.setCellStyle(estiloTitulo);
			celdaR.setCellValue("REPORTE DE CATÁLOGO DE ACTIVOS DEL " + repCatalogoActivosBean.getFechaInicio() + " AL " + repCatalogoActivosBean.getFechaFin());
			hoja.addMergedRegion(new CellRangeAddress(
		            2, //first row (0-based)
		            2, //last row  (0-based)
		            1, //first column (0-based)
		            9  //last column  (0-based)
		    ));

			// Encabezado del Reporte
			fila = hoja.createRow(3);

			// Filtros
			fila = hoja.createRow(4);

			celda = fila.createCell((short)0);
			celda.setCellValue("Fecha Inicio Registro");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)1);
			celda.setCellValue(repCatalogoActivosBean.getFechaInicio());

			celda = fila.createCell((short)2);
			celda.setCellValue("Fecha Final Registro");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)3);
			celda.setCellValue(repCatalogoActivosBean.getFechaFin());

			celda = fila.createCell((short)4);
			celda.setCellValue("Centro de Costos");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)5);
			celda.setCellValue(repCatalogoActivosBean.getDescCentroCosto());

			celda = fila.createCell((short)6);
			celda.setCellValue("Tipo de Activo");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)7);
			celda.setCellValue(repCatalogoActivosBean.getDescTipoActivo());

			celda = fila.createCell((short)8);
			celda.setCellValue("Clasificación");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)9);
			celda.setCellValue(repCatalogoActivosBean.getDescClasificacion());

			celda = fila.createCell((short)10);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)11);
			celda.setCellValue(repCatalogoActivosBean.getDescEstatus());

			fila = hoja.createRow(5);

			fila = hoja.createRow(6); // Detalle de Cabecera de Registros
			
			XSSFCell celdaDet=fila.createCell((short)6);
			celdaDet	= fila.createCell((short)9);
			celdaDet.setCellStyle(estiloCabecera);
			celdaDet.setCellValue(" CONTABLE ");
			hoja.addMergedRegion(new CellRangeAddress(
		            6, //first row (0-based)
		            6, //last row  (0-based)
		            9, //first column (0-based)
		            13  //last column  (0-based)
		    ));
			
			celdaDet	= fila.createCell((short)14);
			celdaDet.setCellStyle(estiloCabecera);
			celdaDet.setCellValue(" FISCAL ");
			hoja.addMergedRegion(new CellRangeAddress(
		            6, //first row (0-based)
		            6, //last row  (0-based)
		            14, //first column (0-based)
		            19  //last column  (0-based)
		    ));
			
			
			fila = hoja.createRow(7); // Cabecera de Registros

			celda = fila.createCell((short)0);
			celda.setCellValue("Tipo de Activo");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)1);
			celda.setCellValue("Descripción Activo");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)2);
			celda.setCellValue("Fecha de Adquisición");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)3);
			celda.setCellValue("Número Factura");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)4);
			celda.setCellValue("Póliza");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)5);
			celda.setCellValue("Centro de Costos");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)6);
			celda.setCellValue("Clasificación");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)7);
			celda.setCellValue("MOI");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)8);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)9);
			celda.setCellValue("% Depreciación Anual");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)10);
			celda.setCellValue("Tiempo Amortizar en Meses");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)11);
			celda.setCellValue("Depreciación Contable Anual");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)12);
			celda.setCellValue("Depreciado Acumulado");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)13);
			celda.setCellValue("Saldo por Depreciar");
			celda.setCellStyle(estiloParametros);
			
			celda = fila.createCell((short)14);
			celda.setCellValue("% Depreciación Anual");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)15);
			celda.setCellValue("Tiempo Amortizar en Meses");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)16);
			celda.setCellValue("Depreciación Fiscal Anual");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)17);
			celda.setCellValue("Depreciado Acumulado");
			celda.setCellStyle(estiloParametros);

			celda = fila.createCell((short)18);
			celda.setCellValue("Saldo por Depreciar");
			celda.setCellStyle(estiloParametros);
			

			int row = 8,iter=0;
			int tamanioLista = listaCatalogoActivos.size();
			RepCatalogoActivosBean activos = null;
			for(iter=0; iter<tamanioLista; iter ++){
				activos = (RepCatalogoActivosBean) listaCatalogoActivos.get(iter);
				fila=hoja.createRow(row);

				celda = fila.createCell((short)0);
				celda.setCellValue(activos.getDescTipoActivo());

				celda = fila.createCell((short)1);
				celda.setCellValue(activos.getDescActivo());

				celda = fila.createCell((short)2);
				celda.setCellValue(activos.getFechaAdquisicion());
				celda.setCellStyle(estiloTextoCentrado);

				celda = fila.createCell((short)3);
				celda.setCellValue(activos.getNumFactura());

				celda = fila.createCell((short)4);
				celda.setCellValue(activos.getPolizaFactura());

				celda = fila.createCell((short)5);
				celda.setCellValue(activos.getCentroCostoID());

				celda = fila.createCell((short)6);
				celda.setCellValue(activos.getClasificacion());

				celda = fila.createCell((short)7);
				if(activos.getTipoRegistro().equalsIgnoreCase("T")){
					celda.setCellValue(activos.getMoi());
				}else{
					celda.setCellValue(Utileria.convierteDoble(activos.getMoi()));
					celda.setCellStyle(estiloDecimal);
				}

				celda = fila.createCell((short)8);
				celda.setCellValue(activos.getEstatus());

				celda = fila.createCell((short)9);
				celda.setCellValue(activos.getDepreciacionAnual());
				celda.setCellStyle(estiloTextoDer);

				celda = fila.createCell((short)10);
				celda.setCellValue(activos.getTiempoAmortiMeses());
				celda.setCellStyle(estiloTextoCentrado);
				if(activos.getTipoRegistro().equalsIgnoreCase("T")){
					celda.setCellStyle(estiloTextoDerNeg);
				}
				
				celda = fila.createCell((short)11);
				celda.setCellValue(Utileria.convierteDoble(activos.getDepreContaAnual()));
				celda.setCellStyle(estiloDecimal);
				if(activos.getTipoRegistro().equalsIgnoreCase("T")){
					celda.setCellStyle(estiloDecimalNeg);
				}

				celda = fila.createCell((short)12);
				celda.setCellValue(Utileria.convierteDoble(activos.getDepreciadoAcumulado()));
				celda.setCellStyle(estiloDecimal);
				if(activos.getTipoRegistro().equalsIgnoreCase("T")){
					celda.setCellStyle(estiloDecimalNeg);
				}

				celda = fila.createCell((short)13);
				celda.setCellValue(Utileria.convierteDoble(activos.getTotalDepreciar()));
				celda.setCellStyle(estiloDecimal);
				if(activos.getTipoRegistro().equalsIgnoreCase("T")){
					celda.setCellStyle(estiloDecimalNeg);
				}
				
				celda = fila.createCell((short)14);
				celda.setCellValue(activos.getDepreciacionAnualFiscal());
				celda.setCellStyle(estiloTextoDer);

				celda = fila.createCell((short)15);
				celda.setCellValue(activos.getTiempoAmortiMesesFiscal());
				celda.setCellStyle(estiloTextoCentrado);
				if(activos.getTipoRegistro().equalsIgnoreCase("T")){
					celda.setCellStyle(estiloTextoDerNeg);
				}

				celda = fila.createCell((short)16);
				celda.setCellValue(Utileria.convierteDoble(activos.getDepreFiscalAnual()));
				celda.setCellStyle(estiloDecimal);
				if(activos.getTipoRegistro().equalsIgnoreCase("T")){
					celda.setCellStyle(estiloDecimalNeg);
				}

				celda = fila.createCell((short)17);
				celda.setCellValue(Utileria.convierteDoble(activos.getDepreciadoAcumuladoFiscal()));
				celda.setCellStyle(estiloDecimal);
				if(activos.getTipoRegistro().equalsIgnoreCase("T")){
					celda.setCellStyle(estiloDecimalNeg);
				}

				celda = fila.createCell((short)18);
				celda.setCellValue(Utileria.convierteDoble(activos.getSaldoDepreciarFiscal()));
				celda.setCellStyle(estiloDecimal);
				if(activos.getTipoRegistro().equalsIgnoreCase("T")){
					celda.setCellStyle(estiloDecimalNeg);
				}

				row++;
			}

			for(int celd=0; celd<=18; celd++){
				hoja.autoSizeColumn((short)celd);
			}

			//Se crea la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepCatalogoActivos.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();

			}catch(Exception e){
	    		e.printStackTrace();
	    	}//Fin del catch

		return listaCatalogoActivos;
	}

	// ================== GETTER & SETTER ============== //

	public RepCatalogoActivosServicio getRepCatalogoActivosServicio() {
		return repCatalogoActivosServicio;
	}

	public void setRepCatalogoActivosServicio(
			RepCatalogoActivosServicio repCatalogoActivosServicio) {
		this.repCatalogoActivosServicio = repCatalogoActivosServicio;
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
