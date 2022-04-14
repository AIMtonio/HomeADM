package tarjetas.servicio;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

import tarjetas.bean.CargaArchivosTarjetaBean;
import tarjetas.bean.TarjetaCreditoBean;
import tarjetas.dao.CargaArchivosTarjetaDAO;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CargaArchivosTarjetaServicio extends BaseServicio{
	
	CargaArchivosTarjetaDAO cargaArchivosTarjetaDAO = null;
	
	public CargaArchivosTarjetaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Tra_CargaArchivo {
		int cargaTitulo		= 1;
		int cargaLineas		= 2;
		int procesaArchivo	= 3;
		int procesaPagos	= 4;
	}
	
	
	public MensajeTransaccionArchivoBean grabaArchivo(int tipoTransaccion, CargaArchivosTarjetaBean  cargaArchivosTarjetaBean){
		MensajeTransaccionArchivoBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_CargaArchivo.cargaTitulo:
			mensaje = cargaArchivosTarjetaDAO.cargaTituloArchivo(tipoTransaccion, cargaArchivosTarjetaBean);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CargaArchivosTarjetaBean  cargaArchivosTarjetaBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_CargaArchivo.cargaLineas:
				mensaje = cargaArchivosTarjetaDAO.cargaLineasArchivo(tipoTransaccion, cargaArchivosTarjetaBean);
				break;	
			case Enum_Tra_CargaArchivo.procesaArchivo:
				mensaje = cargaArchivosTarjetaDAO.procesaRegistro(tipoTransaccion, cargaArchivosTarjetaBean);
				break;	
			case Enum_Tra_CargaArchivo.procesaPagos:
				mensaje = procesaPagosExcel(cargaArchivosTarjetaBean);
				break;		
		}
		return mensaje;
	}

	public MensajeTransaccionBean procesaPagosExcel( CargaArchivosTarjetaBean  cargaArchivosTarjetaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String rutaArchivo = cargaArchivosTarjetaBean.getNombreArchivo();
		String nombreArchivo = "";
		String extension ="";
		List listaPagos = new ArrayList();
		
		XSSFWorkbook worbook = null;
		XSSFSheet sheet = null;
		HSSFWorkbook worbookXls = null;
		HSSFSheet sheetXls = null;
		Iterator<Row> rowIterator = null;

		try  {
			FileInputStream file = new FileInputStream(new File(rutaArchivo));
			
			nombreArchivo = new File(rutaArchivo).getName();
			extension = nombreArchivo.substring(nombreArchivo.lastIndexOf(".") + 1,
					nombreArchivo.length());
						
			if (extension.equalsIgnoreCase("xlsx")){
				worbook = new XSSFWorkbook(file);
				sheet = worbook.getSheetAt(0);
				rowIterator = sheet.iterator();
			}
			
			if (extension.equalsIgnoreCase("xls")){
				worbookXls = new HSSFWorkbook(file);
				sheetXls = worbookXls.getSheetAt(0);
				rowIterator = sheetXls.iterator();
			}
			
			Row row;
			int fila = 1;
			int columna = 1;
			TarjetaCreditoBean pagoCreditoBean;
			
			// se recorre cada fila hasta el final
			while (rowIterator.hasNext()) {
				row = rowIterator.next();
				//se obtiene las celdas por fila
				Iterator<Cell> cellIterator = row.cellIterator();
				Cell cell;
				//se recorre cada celda
				pagoCreditoBean = new TarjetaCreditoBean();
				while (cellIterator.hasNext()) {
										
					// se obtiene la celda en específico y se la imprime
					cell = cellIterator.next();
					if (fila==1){
						switch(columna) {
						case 1:
							if(!cell.getStringCellValue().trim().equalsIgnoreCase("Fecha")){
								return getErrorFormato();
							}
							break;
						case 2:
							if(!cell.getStringCellValue().trim().equalsIgnoreCase("Depositante")){
								return getErrorFormato();
							}
							break;
						case 3:
							if(!cell.getStringCellValue().trim().equalsIgnoreCase("Alias")){
								return getErrorFormato();
							}
							break;
						case 4:
							if(!cell.getStringCellValue().trim().equalsIgnoreCase("Identificador")){
								return getErrorFormato();
							}
							break;
						case 5:
							if(!cell.getStringCellValue().trim().equalsIgnoreCase("CLABE")){
								return getErrorFormato();
							}
							break;
						case 6:
							if(!cell.getStringCellValue().trim().equalsIgnoreCase("Cantidad")){
								return getErrorFormato();
							}
							break;
						case 7:
							if(!cell.getStringCellValue().trim().equalsIgnoreCase("Correo electrónico")){
								return getErrorFormato();
							}
							break;
						case 8:
							if(!cell.getStringCellValue().trim().equalsIgnoreCase("Divisa")){
								return getErrorFormato();
							}
							break;
						
						}
						
					}else{
					
					
						switch(columna) {
						case 1:
							pagoCreditoBean.setFecha(cell.getStringCellValue());
							break;
						case 2:
							pagoCreditoBean.setDepositante(cell.getStringCellValue());
							break;
						case 3:
							switch(cell.getCellType()) {
								case Cell.CELL_TYPE_NUMERIC:
									pagoCreditoBean.setAlias(cell.getNumericCellValue()+"");
									break;
								case Cell.CELL_TYPE_STRING:
									pagoCreditoBean.setAlias(cell.getStringCellValue()+"");
									break;
									
							}						
							break;
						case 4:
							switch(cell.getCellType()) {
								case Cell.CELL_TYPE_NUMERIC:
									pagoCreditoBean.setIdentificador(cell.getNumericCellValue()+"");
									break;
								case Cell.CELL_TYPE_STRING:
									pagoCreditoBean.setIdentificador(cell.getStringCellValue()+"");
									break;
									
							}	
							break;
						case 5:
							switch(cell.getCellType()) {
								case Cell.CELL_TYPE_NUMERIC:
									pagoCreditoBean.setClabe(cell.getNumericCellValue()+"");
									break;
								case Cell.CELL_TYPE_STRING:
									pagoCreditoBean.setClabe(cell.getStringCellValue()+"");
									break;
									
							}	
							break;
						case 6:
							switch(cell.getCellType()) {
								case Cell.CELL_TYPE_NUMERIC:
									pagoCreditoBean.setCantidad(cell.getNumericCellValue()+"");
									break;
								case Cell.CELL_TYPE_STRING:
									pagoCreditoBean.setCantidad(cell.getStringCellValue()+"");
									break;
									
							}
							break;
						case 7:
							pagoCreditoBean.setCorreo(cell.getStringCellValue());
							break;
						case 8:
							pagoCreditoBean.setDivisa(cell.getStringCellValue());
							break;
						
						}
					
					}
									
					
					columna++;
				}
				if (fila > 1){
					listaPagos.add(pagoCreditoBean);
				}
								
				columna=1;
				fila++;
			}
			
			// Llamada al metodo para grabar los pagos en el DAO
			mensaje = cargaArchivosTarjetaDAO.aplicaPagosLinCred(listaPagos);
			
			
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		return mensaje;
	}
	
	public MensajeTransaccionBean getErrorFormato(){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(101);
		mensaje.setDescripcion("Error de Formato");
		return mensaje;
	}
	
	public CargaArchivosTarjetaDAO getCargaArchivosTarjetaDAO() {
		return cargaArchivosTarjetaDAO;
	}


	public void setCargaArchivosTarjetaDAO(
			CargaArchivosTarjetaDAO cargaArchivosTarjetaDAO) {
		this.cargaArchivosTarjetaDAO = cargaArchivosTarjetaDAO;
	}
	

}

