package activos.servicio;

import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import activos.bean.RepDepAmortizaActivosBean;
import activos.dao.RepDepAmortizaActivosDAO;

public class RepDepAmortizaActivosServicio extends BaseServicio{

	//---------- Variables ------------------------------------- //
	RepDepAmortizaActivosDAO repDepAmortizaActivosDAO = null;
	static int tamanioTexto = 10;

	public RepDepAmortizaActivosServicio(){
		super();
	}

	// ---------- Reporte de Depreciacion de Activos ----------- //
	public static interface Enum_Rep_DepAmortizaActivos {
		int  reporteContable = 1;
		int  reporteFiscal 	 = 2;
		int  reporteAmbos 	 = 3;
	}

	// Reporte Excel Depreciacion y Amortizacion de Activos
	public void listaDepAmortizaActivos(int tipoReporte, RepDepAmortizaActivosBean repDepAmortizaActivosBean, HttpServletResponse httpServletResponse){
		switch(tipoReporte){
			case Enum_Rep_DepAmortizaActivos.reporteContable:
				reporteContable(repDepAmortizaActivosBean, httpServletResponse);
			break;
			case Enum_Rep_DepAmortizaActivos.reporteFiscal:
				reporteFiscal(repDepAmortizaActivosBean, httpServletResponse);
			break;
			case Enum_Rep_DepAmortizaActivos.reporteAmbos:
				reporteContableFiscal(repDepAmortizaActivosBean, httpServletResponse);
			break;
			default:
				reporteContableFiscal(repDepAmortizaActivosBean, httpServletResponse);
			break;
		}
	}

	// Reporte Contable
	public void reporteContable(RepDepAmortizaActivosBean repDepAmortizaActivosBean, HttpServletResponse httpServletResponse){

		try{

			List<RepDepAmortizaActivosBean> listaActivos = repDepAmortizaActivosDAO.reporteDepAmortizaActivos(Enum_Rep_DepAmortizaActivos.reporteContable, repDepAmortizaActivosBean);

			XSSFWorkbook libro = new XSSFWorkbook();

			//Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFCellStyle estiloTitulo = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para los Parametros del reporte.
			XSSFCellStyle estiloParametros = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_BOLD);

			//Fuente tamaño 10 para Texto
			XSSFCellStyle estiloTexto = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Centrado
			XSSFCellStyle estiloTextoCentrado = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Decimal
			XSSFCellStyle estiloTextoDecimal = Utileria.crearFuenteDecimal(libro, tamanioTexto, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Porcentaje
			XSSFCellStyle estiloTextoDerecha = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_DERECHA, Constantes.FUENTE_NOBOLD);

			//Fuente Negrita con tamaño 10 para Texto Decimal
			XSSFCellStyle estiloTextoDecimalTotal = Utileria.crearFuenteDecimal(libro, tamanioTexto, Constantes.FUENTE_BOLD);

			// Creacion de hoja
			XSSFSheet hoja = (XSSFSheet) libro.createSheet("REPORTE_DEPRECIACIÓN_AMORTIZACIÓN");
			XSSFRow fila = hoja.createRow(0);

			// Nombre Institucion y Usuario
			fila = hoja.createRow(1);
			XSSFCell celda=fila.createCell((short)1);
			celda.setCellValue(repDepAmortizaActivosBean.getNombreInstitucion());
			celda.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(1, 1, 1, 11));

			celda = fila.createCell((short)12);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue((!repDepAmortizaActivosBean.getClaveUsuario().isEmpty())?repDepAmortizaActivosBean.getClaveUsuario(): "TODOS");
			celda.setCellStyle(estiloTexto);

			String horaReporte  = repDepAmortizaActivosBean.getHoraEmision();
			String fechaReporte = repDepAmortizaActivosBean.getFechaEmision();

			// Titulo del Reporte y Fecha
			fila = hoja.createRow(2);
			celda = fila.createCell((short)1);
			celda.setCellValue("REPORTE DE DEPRECIACIÓN Y AMORTIZACIÓN DE ACTIVOS CONTABLE DEL " + repDepAmortizaActivosBean.getFechaInicio() + " AL " + repDepAmortizaActivosBean.getFechaFin());
			celda.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 11));

			celda = fila.createCell((short)12);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue(fechaReporte);
			celda.setCellStyle(estiloTexto);

			// Hora del Reporte
			fila = hoja.createRow(3);
			celda = fila.createCell((short)12);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue(horaReporte);
			celda.setCellStyle(estiloTexto);

			fila = hoja.createRow(4);
			fila = hoja.createRow(5);
			celda = fila.createCell((short)1);
			celda.setCellValue("Fecha Inicio Registro:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)2);
			celda.setCellValue(repDepAmortizaActivosBean.getFechaInicio());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)3);
			celda.setCellValue("Fecha Final Registro:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)4);
			celda.setCellValue(repDepAmortizaActivosBean.getFechaFin());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)5);
			celda.setCellValue("Centro de Costos:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)6);
			celda.setCellValue(repDepAmortizaActivosBean.getDescCentroCosto());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)7);
			celda.setCellValue("Tipo de Activo:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)8);
			celda.setCellValue(repDepAmortizaActivosBean.getDescTipoActivo());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)9);
			celda.setCellValue("Clasificación:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)10);
			celda.setCellValue(repDepAmortizaActivosBean.getDescClasificacion());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)11);
			celda.setCellValue("Estatus:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)12);
			celda.setCellValue(repDepAmortizaActivosBean.getDescEstatus());
			celda.setCellStyle(estiloTexto);

			fila = hoja.createRow(6);
			fila = hoja.createRow(7);

			int posicion = 11;
			if(listaActivos.size() != Constantes.ENTERO_CERO){
				posicion = 11 + listaActivos.get(Constantes.ENTERO_CERO).getColumnas().split("\\|").length;
			}

			celda = fila.createCell((short)posicion);
			celda.setCellValue("Meses");
			celda.setCellStyle(estiloCabecera);
			hoja.addMergedRegion(new CellRangeAddress(7, 7,posicion, posicion + 11));

			fila = hoja.createRow(8);
			celda = fila.createCell((short)1);
			celda.setCellValue("Tipo de Activo");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)2);
			celda.setCellValue("Descripción Activo");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)3);
			celda.setCellValue("Fecha de Adquisición");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)4);
			celda.setCellValue("Número Factura");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)5);
			celda.setCellValue("Póliza");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)6);
			celda.setCellValue("Centro de Costos");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)7);
			celda.setCellValue("MOI");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)8);
			celda.setCellValue("% Depreciación Anual Contable");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)9);
			celda.setCellValue("Tiempo Amortizar en Meses");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)10);
			celda.setCellValue("Depreciación Contable Anual");
			celda.setCellStyle(estiloCabecera);

			// Obtengo los elementos dinamicos
			int numeroColumna = 10;
			int iteracion = Constantes.ENTERO_CERO;

			if(listaActivos.size() != Constantes.ENTERO_CERO){
				String[] listaColumnas = listaActivos.get(Constantes.ENTERO_CERO).getColumnas().split("\\|");

				for( iteracion=Constantes.ENTERO_CERO; iteracion<listaColumnas.length; iteracion++ ){
					numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
					celda = fila.createCell((short)numeroColumna);
					celda.setCellValue("Año " + (String)listaColumnas[iteracion]);
					celda.setCellStyle(estiloCabecera);
				}
			}

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Enero");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Febrero");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Marzo");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Abril");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Mayo");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Junio");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Julio");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Agosto");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Septiembre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Octubre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Noviembre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Diciembre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Depreciado Acumulado");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Saldo por Depreciar");
			celda.setCellStyle(estiloCabecera);

			int numeroFila = 8;
			int activos = Constantes.ENTERO_CERO;
			int numRegistros = Constantes.ENTERO_CERO;

			for( activos=Constantes.ENTERO_CERO; activos<listaActivos.size(); activos++){

				RepDepAmortizaActivosBean depAmortizaActivosBean = (RepDepAmortizaActivosBean) listaActivos.get(activos);
				numeroFila = numeroFila + Constantes.ENTERO_UNO;
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					numRegistros = numRegistros + Constantes.ENTERO_UNO;
				}
				fila=hoja.createRow(numeroFila);

				celda = fila.createCell((short)1);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getDescTipoActivo());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)2);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getDescActivo());
					celda.setCellStyle(estiloTexto);
				};

				celda=fila.createCell((short)3);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getFechaAdquisicion());
					celda.setCellStyle(estiloTextoCentrado);
				}

				celda=fila.createCell((short)4);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getNumFactura());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)5);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getPoliza());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)6);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getDescCentroCosto());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)7);
				celda.setCellValue(Constantes.STRING_VACIO);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getMoi()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				celda=fila.createCell((short)8);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getPorDepreContaAnual()+"%");
					celda.setCellStyle(estiloTextoDerecha);
				}

				celda=fila.createCell((short)9);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getTiempoAmortiMeses());
					celda.setCellStyle(estiloTextoCentrado);
				}

				celda=fila.createCell((short)10);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getDepreciaContaAnual()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				// Obtengo los elementos dinamicos
				numeroColumna = 10;
				int iteracionAux = Constantes.ENTERO_CERO;
				String[] listaColumnasAnio = depAmortizaActivosBean.getColumnasAnio().split("\\|");

				for( iteracionAux=Constantes.ENTERO_CERO; iteracionAux<listaColumnasAnio.length; iteracionAux++ ){

					numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
					celda = fila.createCell((short)numeroColumna);
					celda.setCellValue(Utileria.convierteDoble((String)listaColumnasAnio[iteracionAux]));
					celda.setCellStyle(estiloTextoDecimalTotal);
					if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
						celda.setCellStyle(estiloTextoDecimal);
					}

				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getEnero()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getFebrero()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getMarzo()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getAbril()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getMayo()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getJunio()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getJulio()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getAgosto()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getSeptiembre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getOctubre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getNoviembre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getDiciembre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getDepreciadoAcumulado()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getSaldoPorDepreciar()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}
			}

			numeroFila = numeroFila + Constantes.ENTERO_UNO;
			fila = hoja.createRow(numeroFila);
			celda = fila.createCell((short)1);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloParametros);

			numeroFila = numeroFila + Constantes.ENTERO_UNO;
			fila = hoja.createRow(numeroFila);
			celda = fila.createCell((short)0);
			celda.setCellValue(numRegistros);
			celda.setCellStyle(estiloTexto);

			for(int celdaAjustar = Constantes.ENTERO_CERO; celdaAjustar <= numeroColumna; celdaAjustar++){
				hoja.autoSizeColumn((short)celdaAjustar);
			}

			//Creo la cabecera
			httpServletResponse.addHeader("Content-Disposition","inline; filename=RepDepAmortizaActivosContable.xls");
			httpServletResponse.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = httpServletResponse.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();

		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.info("Error al crear el reporte Depreciación/Amortización Activos en Formato Contable " + exception);
		}
	}

	// Reporte Fiscal
	public void reporteFiscal(RepDepAmortizaActivosBean repDepAmortizaActivosBean, HttpServletResponse httpServletResponse){

		try{

			List<RepDepAmortizaActivosBean> listaActivos = repDepAmortizaActivosDAO.reporteDepAmortizaActivos(Enum_Rep_DepAmortizaActivos.reporteFiscal, repDepAmortizaActivosBean);

			XSSFWorkbook libro = new XSSFWorkbook();

			//Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFCellStyle estiloTitulo = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para los Parametros del reporte.
			XSSFCellStyle estiloParametros = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_BOLD);

			//Fuente tamaño 10 para Texto
			XSSFCellStyle estiloTexto = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Centrado
			XSSFCellStyle estiloTextoCentrado = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Porcentaje
			XSSFCellStyle estiloTextoDerecha = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_DERECHA, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Decimal
			XSSFCellStyle estiloTextoDecimal = Utileria.crearFuenteDecimal(libro, tamanioTexto, Constantes.FUENTE_NOBOLD);

			//Fuente Negrita con tamaño 10 para Texto Decimal
			XSSFCellStyle estiloTextoDecimalTotal = Utileria.crearFuenteDecimal(libro, tamanioTexto, Constantes.FUENTE_BOLD);

			// Creacion de hoja
			XSSFSheet hoja = (XSSFSheet) libro.createSheet("REPORTE_DEPRECIACIÓN_AMORTIZACIÓN");
			XSSFRow fila = hoja.createRow(0);

			// Nombre Institucion y Usuario
			fila = hoja.createRow(1);
			XSSFCell celda=fila.createCell((short)1);
			celda.setCellValue(repDepAmortizaActivosBean.getNombreInstitucion());
			celda.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(1, 1, 1, 11));

			celda = fila.createCell((short)12);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue((!repDepAmortizaActivosBean.getClaveUsuario().isEmpty())?repDepAmortizaActivosBean.getClaveUsuario(): "TODOS");
			celda.setCellStyle(estiloTexto);

			String horaReporte  = repDepAmortizaActivosBean.getHoraEmision();
			String fechaReporte = repDepAmortizaActivosBean.getFechaEmision();

			// Titulo del Reporte y Fecha
			fila = hoja.createRow(2);
			celda = fila.createCell((short)1);
			celda.setCellValue("REPORTE DE DEPRECIACIÓN Y AMORTIZACIÓN DE ACTIVOS FISCAL DEL " + repDepAmortizaActivosBean.getFechaInicio() + " AL " + repDepAmortizaActivosBean.getFechaFin());
			celda.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 11));

			celda = fila.createCell((short)12);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue(fechaReporte);
			celda.setCellStyle(estiloTexto);

			// Hora del Reporte
			fila = hoja.createRow(3);
			celda = fila.createCell((short)12);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue(horaReporte);
			celda.setCellStyle(estiloTexto);

			fila = hoja.createRow(4);
			fila = hoja.createRow(5);
			celda = fila.createCell((short)1);
			celda.setCellValue("Fecha Inicio Registro:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)2);
			celda.setCellValue(repDepAmortizaActivosBean.getFechaInicio());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)3);
			celda.setCellValue("Fecha Final Registro:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)4);
			celda.setCellValue(repDepAmortizaActivosBean.getFechaFin());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)5);
			celda.setCellValue("Centro de Costos:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)6);
			celda.setCellValue(repDepAmortizaActivosBean.getDescCentroCosto());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)7);
			celda.setCellValue("Tipo de Activo:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)8);
			celda.setCellValue(repDepAmortizaActivosBean.getDescTipoActivo());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)9);
			celda.setCellValue("Clasificación:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)10);
			celda.setCellValue(repDepAmortizaActivosBean.getDescClasificacion());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)11);
			celda.setCellValue("Estatus:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)12);
			celda.setCellValue(repDepAmortizaActivosBean.getDescEstatus());
			celda.setCellStyle(estiloTexto);

			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			int posicion = 13;
			if(listaActivos.size() != Constantes.ENTERO_CERO){
				 posicion = 13+ listaActivos.get(Constantes.ENTERO_CERO).getColumnas().split("\\|").length;
			}
			celda = fila.createCell((short)posicion);
			celda.setCellValue("Meses");
			celda.setCellStyle(estiloCabecera);
			hoja.addMergedRegion(new CellRangeAddress(7, 7,posicion, posicion + 11));

			fila = hoja.createRow(8);
			celda = fila.createCell((short)1);
			celda.setCellValue("Tipo de Activo");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)2);
			celda.setCellValue("Descripción Activo");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)3);
			celda.setCellValue("Fecha de Adquisición");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)4);
			celda.setCellValue("Número Factura");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)5);
			celda.setCellValue("Póliza");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)6);
			celda.setCellValue("Centro de Costos");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)7);
			celda.setCellValue("MOI");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)8);
			celda.setCellValue("% Depreciación Anual Fiscal");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)9);
			celda.setCellValue("Tiempo Amortizar en Meses");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)10);
			celda.setCellValue("Dep. Fiscal Saldo Inicial");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)11);
			celda.setCellValue("Dep. Fiscal Saldo Final");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)12);
			celda.setCellValue("Depreciación Fiscal Anual");
			celda.setCellStyle(estiloCabecera);

			// Obtengo los elementos dinamicos
			int numeroColumna = 12;
			int iteracion = Constantes.ENTERO_CERO;

			if(listaActivos.size() != Constantes.ENTERO_CERO){
				String[] listaColumnas = listaActivos.get(Constantes.ENTERO_CERO).getColumnas().split("\\|");

				for( iteracion=Constantes.ENTERO_CERO; iteracion<listaColumnas.length; iteracion++ ){
					numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
					celda = fila.createCell((short)numeroColumna);
					celda.setCellValue("Año " + (String)listaColumnas[iteracion]);
					celda.setCellStyle(estiloCabecera);
				}
			}

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Enero");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Febrero");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Marzo");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Abril");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Mayo");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Junio");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Julio");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Agosto");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Septiembre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Octubre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Noviembre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Diciembre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Depreciado Acumulado");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Saldo por Depreciar");
			celda.setCellStyle(estiloCabecera);

			int numeroFila = 8;
			int activos = Constantes.ENTERO_CERO;
			int numRegistros = Constantes.ENTERO_CERO;

			for( activos=Constantes.ENTERO_CERO; activos<listaActivos.size(); activos++){

				RepDepAmortizaActivosBean depAmortizaActivosBean = (RepDepAmortizaActivosBean) listaActivos.get(activos);
				numeroFila = numeroFila + Constantes.ENTERO_UNO;
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					numRegistros = numRegistros + Constantes.ENTERO_UNO;
				}
				fila=hoja.createRow(numeroFila);

				celda = fila.createCell((short)1);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getDescTipoActivo());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)2);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getDescActivo());
					celda.setCellStyle(estiloTexto);
				};

				celda=fila.createCell((short)3);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getFechaAdquisicion());
					celda.setCellStyle(estiloTextoCentrado);
				}

				celda=fila.createCell((short)4);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getNumFactura());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)5);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getPoliza());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)6);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getDescCentroCosto());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)7);
				celda.setCellValue(Constantes.STRING_VACIO);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getMoi()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				celda=fila.createCell((short)8);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getPorDepreFiscalAnual()+"%");
					celda.setCellStyle(estiloTextoDerecha);
				}

				celda=fila.createCell((short)9);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getTiempoAmortiMeses());
					celda.setCellStyle(estiloTextoCentrado);
				}

				celda=fila.createCell((short)10);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getDepFiscalSaldoInicial()));
					celda.setCellStyle(estiloTextoDecimal);
				}

				celda=fila.createCell((short)11);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getDepFiscalSaldoFinal()));
					celda.setCellStyle(estiloTextoDecimal);
				}

				celda=fila.createCell((short)12);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getDepreciaFiscalAnual()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				// Obtengo los elementos dinamicos
				numeroColumna = 12;
				int iteracionAux = Constantes.ENTERO_CERO;
				String[] listaColumnasAnio = depAmortizaActivosBean.getColumnasAnio().split("\\|");

				for( iteracionAux=Constantes.ENTERO_CERO; iteracionAux<listaColumnasAnio.length; iteracionAux++ ){

					numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
					celda = fila.createCell((short)numeroColumna);
					celda.setCellValue(Utileria.convierteDoble((String)listaColumnasAnio[iteracionAux]));
					celda.setCellStyle(estiloTextoDecimalTotal);
					if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
						celda.setCellStyle(estiloTextoDecimal);
					}

				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getEnero()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getFebrero()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getMarzo()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getAbril()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getMayo()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getJunio()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getJulio()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getAgosto()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getSeptiembre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getOctubre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getNoviembre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getDiciembre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getDepreciadoAcumulado()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getSaldoPorDepreciar()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}
			}

			numeroFila = numeroFila + Constantes.ENTERO_UNO;
			fila = hoja.createRow(numeroFila);
			celda = fila.createCell((short)1);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloParametros);

			numeroFila = numeroFila + Constantes.ENTERO_UNO;
			fila = hoja.createRow(numeroFila);
			celda = fila.createCell((short)0);
			celda.setCellValue(numRegistros);
			celda.setCellStyle(estiloTexto);

			for(int celdaAjustar = Constantes.ENTERO_CERO; celdaAjustar <= numeroColumna; celdaAjustar++){
				hoja.autoSizeColumn((short)celdaAjustar);
			}

			//Creo la cabecera
			httpServletResponse.addHeader("Content-Disposition","inline; filename=RepDepAmortizaActivosFiscal.xls");
			httpServletResponse.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = httpServletResponse.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();

		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.info("Error al crear el reporte Depreciación/Amortización Activos en Formato Fiscal " + exception);
		}
	}

	// Reporte Contable y Fiscal
	public void reporteContableFiscal(RepDepAmortizaActivosBean repDepAmortizaActivosBean, HttpServletResponse httpServletResponse){

		try{

			List<RepDepAmortizaActivosBean> listaActivos = repDepAmortizaActivosDAO.reporteDepAmortizaActivos(Enum_Rep_DepAmortizaActivos.reporteAmbos, repDepAmortizaActivosBean);

			XSSFWorkbook libro = new XSSFWorkbook();

			//Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFCellStyle estiloTitulo = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para los Parametros del reporte.
			XSSFCellStyle estiloParametros = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_BOLD);

			//Fuente tamaño 10 para Texto
			XSSFCellStyle estiloTexto = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Porcentaje
			XSSFCellStyle estiloTextoDerecha = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_DERECHA, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Centrado
			XSSFCellStyle estiloTextoCentrado = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Decimal
			XSSFCellStyle estiloTextoDecimal = Utileria.crearFuenteDecimal(libro, tamanioTexto, Constantes.FUENTE_NOBOLD);

			//Fuente Negrita con tamaño 10 para Texto Decimal
			XSSFCellStyle estiloTextoDecimalTotal = Utileria.crearFuenteDecimal(libro, tamanioTexto, Constantes.FUENTE_BOLD);

			//Fuente tamaño 10 para Texto Decimal a 4 Decimales
			XSSFCellStyle estiloTextoDecimal4 = Utileria.crearFuenteTasaMoneda(libro, tamanioTexto, Constantes.FUENTE_NOBOLD);

			// Creacion de hoja
			XSSFSheet hoja = (XSSFSheet) libro.createSheet("REPORTE_DEPRECIACIÓN_AMORTIZACIÓN");
			XSSFRow fila = hoja.createRow(0);

			// Nombre Institucion y Usuario
			fila = hoja.createRow(1);
			XSSFCell celda=fila.createCell((short)1);
			celda.setCellValue(repDepAmortizaActivosBean.getNombreInstitucion());
			celda.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(1, 1, 1, 11));

			celda = fila.createCell((short)12);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue((!repDepAmortizaActivosBean.getClaveUsuario().isEmpty())?repDepAmortizaActivosBean.getClaveUsuario(): "TODOS");
			celda.setCellStyle(estiloTexto);

			String horaReporte  = repDepAmortizaActivosBean.getHoraEmision();
			String fechaReporte = repDepAmortizaActivosBean.getFechaEmision();

			// Titulo del Reporte y Fecha
			fila = hoja.createRow(2);
			celda = fila.createCell((short)1);
			celda.setCellValue("REPORTE DE DEPRECIACIÓN Y AMORTIZACIÓN DE ACTIVOS DEL " + repDepAmortizaActivosBean.getFechaInicio() + " AL " + repDepAmortizaActivosBean.getFechaFin());
			celda.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 11));

			celda = fila.createCell((short)12);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue(fechaReporte);
			celda.setCellStyle(estiloTexto);

			// Hora del Reporte
			fila = hoja.createRow(3);
			celda = fila.createCell((short)12);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue(horaReporte);
			celda.setCellStyle(estiloTexto);

			fila = hoja.createRow(4);
			fila = hoja.createRow(5);
			celda = fila.createCell((short)1);
			celda.setCellValue("Fecha Inicio Registro:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)2);
			celda.setCellValue(repDepAmortizaActivosBean.getFechaInicio());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)3);
			celda.setCellValue("Fecha Final Registro:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)4);
			celda.setCellValue(repDepAmortizaActivosBean.getFechaFin());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)5);
			celda.setCellValue("Centro de Costos:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)6);
			celda.setCellValue(repDepAmortizaActivosBean.getDescCentroCosto());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)7);
			celda.setCellValue("Tipo de Activo:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)8);
			celda.setCellValue(repDepAmortizaActivosBean.getDescTipoActivo());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)9);
			celda.setCellValue("Clasificación:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)10);
			celda.setCellValue(repDepAmortizaActivosBean.getDescClasificacion());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)11);
			celda.setCellValue("Estatus:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)12);
			celda.setCellValue(repDepAmortizaActivosBean.getDescEstatus());
			celda.setCellStyle(estiloTexto);

			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			int posicion = 14;
			if(listaActivos.size() != Constantes.ENTERO_CERO){
				posicion = 14 + listaActivos.get(Constantes.ENTERO_CERO).getColumnas().split("\\|").length;
			}
			celda = fila.createCell((short)posicion);
			celda.setCellValue("Meses");
			celda.setCellStyle(estiloCabecera);
			hoja.addMergedRegion(new CellRangeAddress(7, 7,posicion, posicion + 11));

			fila = hoja.createRow(8);
			celda = fila.createCell((short)1);
			celda.setCellValue("Tipo de Activo");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)2);
			celda.setCellValue("Descripción Activo");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)3);
			celda.setCellValue("Fecha de Adquisición");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)4);
			celda.setCellValue("Número Factura");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)5);
			celda.setCellValue("Póliza");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)6);
			celda.setCellValue("Centro de Costos");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)7);
			celda.setCellValue("MOI");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)8);
			celda.setCellValue("INPC Mes Registro");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)9);
			celda.setCellValue("INPC Actual");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)10);
			celda.setCellValue("Factor Actualización");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)11);
			celda.setCellValue("% Depreciación Anual Fiscal");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)12);
			celda.setCellValue("Tiempo Amortizar en Meses");
			celda.setCellStyle(estiloCabecera);

			celda = fila.createCell((short)13);
			celda.setCellValue("Depreciación Fiscal Anual");
			celda.setCellStyle(estiloCabecera);

			// Obtengo los elementos dinamicos
			int numeroColumna = 13;
			int iteracion = Constantes.ENTERO_CERO;
			if(listaActivos.size() != Constantes.ENTERO_CERO){
				String[] listaColumnas = listaActivos.get(Constantes.ENTERO_CERO).getColumnas().split("\\|");

				for( iteracion=Constantes.ENTERO_CERO; iteracion<listaColumnas.length; iteracion++ ){
					numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
					celda = fila.createCell((short)numeroColumna);
					celda.setCellValue("Año " + (String)listaColumnas[iteracion]);
					celda.setCellStyle(estiloCabecera);
				}
			}
			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Enero");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Febrero");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Marzo");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Abril");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Mayo");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Junio");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Julio");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Agosto");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Septiembre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Octubre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Noviembre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Diciembre");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Depreciado Acumulado");
			celda.setCellStyle(estiloCabecera);

			numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
			celda = fila.createCell((short)numeroColumna);
			celda.setCellValue("Saldo por Depreciar");
			celda.setCellStyle(estiloCabecera);

			int numeroFila = 8;
			int activos = Constantes.ENTERO_CERO;
			int numRegistros = Constantes.ENTERO_CERO;

			for( activos=Constantes.ENTERO_CERO; activos<listaActivos.size(); activos++){

				RepDepAmortizaActivosBean depAmortizaActivosBean = (RepDepAmortizaActivosBean) listaActivos.get(activos);
				numeroFila = numeroFila + Constantes.ENTERO_UNO;
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					numRegistros = numRegistros + Constantes.ENTERO_UNO;
				}
				fila=hoja.createRow(numeroFila);

				celda = fila.createCell((short)1);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getDescTipoActivo());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)2);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getDescActivo());
					celda.setCellStyle(estiloTexto);
				};

				celda=fila.createCell((short)3);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getFechaAdquisicion());
					celda.setCellStyle(estiloTextoCentrado);
				}

				celda=fila.createCell((short)4);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getNumFactura());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)5);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getPoliza());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)6);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getDescCentroCosto());
					celda.setCellStyle(estiloTexto);
				}

				celda=fila.createCell((short)7);
				celda.setCellValue(Constantes.STRING_VACIO);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getMoi()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				celda=fila.createCell((short)8);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getInpcInicial()));
					celda.setCellStyle(estiloTextoDecimal4);
				}

				celda=fila.createCell((short)9);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getInpcActual()));
					celda.setCellStyle(estiloTextoDecimal4);
				}

				celda=fila.createCell((short)10);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getFactorActualizacion()));
					celda.setCellStyle(estiloTextoDecimal4);
				}

				celda=fila.createCell((short)11);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getPorDepreFiscalAnual()+"%");
					celda.setCellStyle(estiloTextoDerecha);
				}

				celda=fila.createCell((short)12);
				celda.setCellValue(Constantes.STRING_VACIO);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellValue(depAmortizaActivosBean.getTiempoAmortiMeses());
					celda.setCellStyle(estiloTextoCentrado);
				}

				celda=fila.createCell((short)13);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getDepreciaFiscalAnual()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				// Obtengo los elementos dinamicos
				numeroColumna = 13;
				int iteracionAux = Constantes.ENTERO_CERO;
				String[] listaColumnasAnio = depAmortizaActivosBean.getColumnasAnio().split("\\|");

				for( iteracionAux=Constantes.ENTERO_CERO; iteracionAux<listaColumnasAnio.length; iteracionAux++ ){

					numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
					celda = fila.createCell((short)numeroColumna);
					celda.setCellValue(Utileria.convierteDoble((String)listaColumnasAnio[iteracionAux]));
					celda.setCellStyle(estiloTextoDecimalTotal);
					if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
						celda.setCellStyle(estiloTextoDecimal);
					}

				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getEnero()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getFebrero()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getMarzo()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getAbril()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getMayo()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getJunio()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getJulio()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getAgosto()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getSeptiembre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getOctubre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getNoviembre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getDiciembre()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getDepreciadoAcumulado()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}

				numeroColumna = numeroColumna + Constantes.ENTERO_UNO;
				celda = fila.createCell((short)numeroColumna);
				celda.setCellValue(Utileria.convierteDoble(depAmortizaActivosBean.getSaldoPorDepreciar()));
				celda.setCellStyle(estiloTextoDecimalTotal);
				if(depAmortizaActivosBean.getTipoFila().equals(Constantes.STRING_VACIO) ){
					celda.setCellStyle(estiloTextoDecimal);
				}
			}

			numeroFila = numeroFila + Constantes.ENTERO_UNO;
			fila = hoja.createRow(numeroFila);
			celda = fila.createCell((short)1);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloParametros);

			numeroFila = numeroFila + Constantes.ENTERO_UNO;
			fila = hoja.createRow(numeroFila);
			celda = fila.createCell((short)0);
			celda.setCellValue(numRegistros);
			celda.setCellStyle(estiloTexto);

			for(int celdaAjustar = Constantes.ENTERO_CERO; celdaAjustar <= numeroColumna; celdaAjustar++){
				hoja.autoSizeColumn((short)celdaAjustar);
			}

			//Creo la cabecera
			httpServletResponse.addHeader("Content-Disposition","inline; filename=RepDepAmortizaActivos.xls");
			httpServletResponse.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = httpServletResponse.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();

		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.info("Error al crear el reporte Depreciación/Amortización Activos " + exception);
		}
	}

	public RepDepAmortizaActivosDAO getRepDepAmortizaActivosDAO() {
		return repDepAmortizaActivosDAO;
	}

	public void setRepDepAmortizaActivosDAO(RepDepAmortizaActivosDAO repDepAmortizaActivosDAO) {
		this.repDepAmortizaActivosDAO = repDepAmortizaActivosDAO;
	}
}