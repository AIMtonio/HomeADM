package cliente.reporte;

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

import cliente.bean.ClienteGeneralBean;
import cliente.servicio.ClienteGeneralServicio;
import general.bean.ParametrosAuditoriaBean;

@SuppressWarnings("deprecation")
public class ReporteGeneralClientesControlador extends AbstractCommandController{
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;	
	private ClienteGeneralServicio clienteGeneralServicio = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		int  reportExcel = 1;
		int  reportePDF  = 2;
	}

	public ReporteGeneralClientesControlador() {
		setCommandClass(ClienteGeneralBean.class);
		setCommandName("clienteGeneralBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		ClienteGeneralBean clienteGeneralBean = (ClienteGeneralBean) command;

		int tipoReporte = (request.getParameter("tipoReporte")!=null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;

		switch(tipoReporte){	
			case Enum_Con_TipRepor.reportExcel:
				 listaReporteGeneralClientesExcel(tipoReporte, clienteGeneralBean, response);
			break;
		}	
			
		return null;
	}

	private List listaReporteGeneralClientesExcel(int tipoLista, ClienteGeneralBean clienteBean, HttpServletResponse response) {
		
		List listaClientes = null;
		listaClientes = clienteGeneralServicio.lista(tipoLista, clienteBean, response); 	
		
		int regExport = 0;
	
		try {
		HSSFWorkbook libro = new HSSFWorkbook();
		//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
		HSSFFont fuenteNegrita10= libro.createFont();
		fuenteNegrita10.setFontHeightInPoints((short)10);
		fuenteNegrita10.setFontName("Arial");
		fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);		
		
		//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
		HSSFFont fuenteNegrita8= libro.createFont();
		fuenteNegrita8.setFontHeightInPoints((short)10);
		fuenteNegrita8.setFontName("Arial");
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
		estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
		estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
		estiloCentrado.setFont(fuenteNegrita10);
		
		//estilo centrado para id y fechas
		HSSFCellStyle estiloCentrado2 = libro.createCellStyle();			
		estiloCentrado2.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
		
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
		HSSFSheet hoja = libro.createSheet("Reporte General Clientes");
		HSSFRow fila= hoja.createRow(0);
	
		// Nombre Institucion	
		HSSFCell celdaInst=fila.createCell((short)1);
		celdaInst.setCellValue(clienteBean.getInstitucion());
							
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            0, //primera fila (0-based)
	            0, //ultima fila  (0-based)
	            1, //primer celda (0-based)
	            8  //ultima celda   (0-based)
	    )); 
		celdaInst.setCellStyle(estiloCentrado);	
		
		// inicio usuario,fecha y hora
		HSSFCell celdaUsu = fila.createCell((short)12);
		celdaUsu.setCellValue("Usuario:");
		celdaUsu.setCellStyle(estiloNeg8);	
		celdaUsu = fila.createCell((short)13);
		
		celdaUsu.setCellValue((!clienteBean.getUsuario().isEmpty()) ? clienteBean.getUsuario().toUpperCase() : "TODOS");
		String horaVar=clienteBean.getHoraEmision();
		String fechaVar=clienteBean.getFechaEmision();

				
		fila = hoja.createRow(1);
		// Titulo del Reporte
		HSSFCell celda=fila.createCell((short)1);					
		celda.setCellValue("REPORTE DE CLIENTES");
						
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				 1, //primera fila (0-based)
				 1, //ultima fila  (0-based)
				 1, //primer celda (0-based)
				 8  //ultima celda   (0-based)
		));
		celda.setCellStyle(estiloCentrado);
				
		HSSFCell celdaFec = fila.createCell((short)12);
		celdaFec.setCellValue("Fecha:");
		celdaFec.setCellStyle(estiloNeg8);	
		celdaFec = fila.createCell((short)13);
		celdaFec.setCellValue(fechaVar);
		 
		
		
		fila = hoja.createRow(2);
		HSSFCell celdaHora=fila.createCell((short)1);
		celdaHora = fila.createCell((short)12);
		celdaHora.setCellValue("Hora:");
		celdaHora.setCellStyle(estiloNeg8);	
		celdaHora = fila.createCell((short)13);
		celdaHora.setCellValue(horaVar);
					 
						
		// Creacion de fila
		fila = hoja.createRow(3); // Fila vacia
		fila = hoja.createRow(4);// Campos
		celda = fila.createCell((short)0);
		celda.setCellValue("Sucursal:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)1);
		celda.setCellValue((!clienteBean.getNombSucursal().equals("") ? clienteBean.getNombSucursal() : "TODAS"));
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Estatus:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)4);
		celda.setCellValue((!clienteBean.getEstatus().equals("") ? clienteBean.getTextoEstatus() : "TODOS"));
		
		fila = hoja.createRow(5); //Fila vacía
		
		// Creacion de fila
		fila = hoja.createRow(6); // Fila vacia
		celda = fila.createCell((short)0);
		celda.setCellValue("ClienteID");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		 
		celda = fila.createCell((short)1);
		celda.setCellValue("Nombre Completo");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		 
		celda = fila.createCell((short)2);
		celda.setCellValue("Fecha Registro");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Promotor");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);

		celda = fila.createCell((short)4);
		celda.setCellValue("Estado");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		 
		celda = fila.createCell((short)5);
		celda.setCellValue("Municipio");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		 
		celda = fila.createCell((short)6);
		celda.setCellValue("Colonia");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)7);
		celda.setCellValue("Código Postal");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)8);
		celda.setCellValue("Domicilio");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)9);
		celda.setCellValue("RFC");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)10);
		celda.setCellValue("CURP");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)11);
		celda.setCellValue("Fecha de nacimiento");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
	
		celda = fila.createCell((short)12);
		celda.setCellValue("Teléfono");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)13);
		celda.setCellValue("Celular");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)14);
		celda.setCellValue("Correo");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)15);
		celda.setCellValue("Cuentas Destino Internas");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)16);
		celda.setCellValue("Cuentas Destino Externas");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
	
		// Recorremos la lista para la parte de los datos 	
		int i=7,iter=0;
		int tamanioLista = listaClientes.size();
		ClienteGeneralBean clienteRow = null;
		
		for( iter=0; iter<tamanioLista; iter ++){					
			clienteRow = (ClienteGeneralBean) listaClientes.get(iter);
			
			fila = hoja.createRow(i);
			celda = fila.createCell((short)0);
			celda.setCellValue(clienteRow.getClienteID());
			
			celda = fila.createCell((short)1);
			celda.setCellValue(clienteRow.getNombreCompleto());
			
			celda = fila.createCell((short)2); 
			celda.setCellValue(clienteRow.getFechaRegistro());
			celda.setCellStyle(estiloCentrado2);
								
			celda = fila.createCell((short)3);
			celda.setCellValue(clienteRow.getPromotor());
			
			celda = fila.createCell((short)4);
			celda.setCellValue(clienteRow.getEstado());
			
			celda = fila.createCell((short)5);
			celda.setCellValue(clienteRow.getMunicipio());
			
			celda = fila.createCell((short)6);
			celda.setCellValue(clienteRow.getColonia());
			
			celda = fila.createCell((short)7);
			celda.setCellValue(clienteRow.getCodigoPostal());
			
			celda = fila.createCell((short)8);
			celda.setCellValue(clienteRow.getDomicilio());
			
			celda = fila.createCell((short)9);
			celda.setCellValue(clienteRow.getRfc());
			
			celda = fila.createCell((short)10);
			celda.setCellValue(clienteRow.getCurp());

			celda = fila.createCell((short)11);
			celda.setCellValue(clienteRow.getFechaNacimiento());
			celda.setCellStyle(estiloCentrado2);
			
			celda = fila.createCell((short)12);
			celda.setCellValue(clienteRow.getTelefono());
			
			celda = fila.createCell((short)13);
			celda.setCellValue(clienteRow.getCelular());
			
			celda = fila.createCell((short)14);
			celda.setCellValue(clienteRow.getCorreo());
			
			celda = fila.createCell((short)15);
			celda.setCellValue(clienteRow.getCuentasDestinoInternas());
			
			celda = fila.createCell((short)16);
			celda.setCellValue(clienteRow.getCuentasDestinoExternas());
			
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
		

		for(int celd=0; celd<=16; celd++)
		hoja.autoSizeColumn((short)celd);
							
		//Creo la cabecera
		response.addHeader("Content-Disposition","inline; filename=RepGeneralClientes.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();
		
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Termina Reporte");
		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte: " + e.getMessage());
			e.printStackTrace();
		}
		
	
		return listaClientes;
	}
	
	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ClienteGeneralServicio getClienteGeneralServicio() {
		return clienteGeneralServicio;
	}

	public void setClienteGeneralServicio(ClienteGeneralServicio clienteGeneralServicio) {
		this.clienteGeneralServicio = clienteGeneralServicio;
	}
	
	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

}
