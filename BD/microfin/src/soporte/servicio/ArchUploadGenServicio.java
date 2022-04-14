package soporte.servicio;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.springframework.web.multipart.MultipartFile;

import credito.bean.CreditosBean;
import credito.dao.CreditosDAO;
import cuentas.bean.CuentasAhoBean;
import cuentas.dao.CuentasAhoDAO;
import cuentas.servicio.CuentasAhoServicio.Enum_Con_CuentasAho;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Utileria;
import soporte.bean.ArchUploadGenBean;
import soporte.controlador.ArchUploadGenControlador.Enum_Path_Upload;
import soporte.dao.ArchUploadGenDAO;

/**
 * Clase Servicio para la subida de archivos.
 * @author pmontero
 * @category servicio
 */
public class ArchUploadGenServicio extends BaseServicio {
	
	ArchUploadGenDAO				archUploadGenDAO				= null;
	CreditosDAO						creditosDAO						= null;
	ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;
	CuentasAhoDAO					cuentasAhoDAO					= null;

	public MensajeTransaccionArchivoBean condonacionUpload(ArchUploadGenBean bean) {
		
		MensajeTransaccionArchivoBean mensaje = null;
		try {
			ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
			String rutaArchivos = parametros.getRutaArchivos();
			long numeroTransaccion = archUploadGenDAO.numTransaccion();
			String directorio = "";
			String archivoNombre = "";
			String rutaFinal = null;
			if(bean.getFecha()==null || bean.getFecha().isEmpty())
			{
				throw new Exception("La Fecha esta Vacia.");
			}
			MultipartFile file = bean.getFile();
			/*Validando extencion*/
			String ext = FilenameUtils.getExtension(file.getOriginalFilename());
			if(ext!=null && !ext.toLowerCase().equals("xls") ) {
				throw new Exception("La extensión del archivo debe ser xls");
			}
			
			directorio = rutaArchivos + "CREDITOS/"+Enum_Path_Upload.condonacionMasiva + "/" + bean.getFecha() + "/" + numeroTransaccion + "/";
			bean.setRecurso(directorio);
			loggerSAFI.info("Directorio:" + directorio);

			boolean exists = (new File(directorio)).exists();
			File aDir = new File(directorio);
			if (!exists) {
				aDir.mkdirs();
			}

			archivoNombre = directorio + file.getOriginalFilename();
			if (file != null) {
				File filespring = new File(archivoNombre);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());
				rutaFinal = filespring.getAbsolutePath();
			}
			mensaje = validarXLSCondonacion(rutaFinal);

			if(mensaje.getNumero()!=0) {
				File archivo=new File(rutaFinal);
				archivo.delete();
				return mensaje;
			}
			mensaje = new MensajeTransaccionArchivoBean();
			mensaje.setNumero(0);
			mensaje.setDescripcion("Archivo Subido Exitosamente.");
			mensaje.setConsecutivoString(rutaFinal);
			loggerSAFI.info("Ruta final:"+rutaFinal);
			mensaje.setNombreControl(bean.getRutaLocal());
		} catch (Exception ex) {
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionArchivoBean();
			}
			if(mensaje.getNumero()==0) {
				mensaje.setNumero(888);
			}
			mensaje.setDescripcion(ex.getMessage());
		}
		return mensaje;
	}
	public MensajeTransaccionArchivoBean castigoUpload(ArchUploadGenBean bean) {
		System.out.println("Entro en castigo:");
		MensajeTransaccionArchivoBean mensaje = null;
		try {
			ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
			String rutaArchivos = parametros.getRutaArchivos();
			long numeroTransaccion = archUploadGenDAO.numTransaccion();
			String directorio = "";
			String archivoNombre = "";
			String rutaFinal = null;
			if(bean.getFecha()==null || bean.getFecha().isEmpty())
			{
				throw new Exception("La Fecha esta Vacia.");
			}
			MultipartFile file = bean.getFile();
			/*Validando extencion*/
			String ext = FilenameUtils.getExtension(file.getOriginalFilename());
			if(ext!=null && !ext.toLowerCase().equals("xls") ) {
				throw new Exception("La extensión del archivo debe ser xls");
			}
			
			directorio = rutaArchivos + "CREDITOS/"+Enum_Path_Upload.castigoMasivo + "/" + bean.getFecha() + "/" + numeroTransaccion + "/";
			bean.setRecurso(directorio);
			loggerSAFI.info("Directorio:" + directorio);

			boolean exists = (new File(directorio)).exists();
			File aDir = new File(directorio);
			if (!exists) {
				aDir.mkdirs();
			}

			archivoNombre = directorio + file.getOriginalFilename();
			if (file != null) {
				File filespring = new File(archivoNombre);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());
				rutaFinal = filespring.getAbsolutePath();
			}
			mensaje = validarXLSCastigo(rutaFinal, numeroTransaccion);

			if(mensaje.getNumero()!=0) {
				File archivo=new File(rutaFinal);
				archivo.delete();
				return mensaje;
			}
			mensaje = new MensajeTransaccionArchivoBean();
			mensaje.setNumero(0);
			mensaje.setDescripcion("Archivo Subido Exitosamente.");
			mensaje.setConsecutivoString(rutaFinal);
			loggerSAFI.info("Ruta final:"+rutaFinal);
			mensaje.setNombreControl(bean.getRutaLocal());
		} catch (Exception ex) {
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionArchivoBean();
			}
			if(mensaje.getNumero()==0) {
				mensaje.setNumero(888);
			}
			mensaje.setDescripcion(ex.getMessage());
		}
		return mensaje;
	}


	private MensajeTransaccionArchivoBean validarXLSCondonacion(String rutaFinal) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		// paso 0. Definir una colección con nombres de las columnas a procesar
		// considera que esto lo puedes leer de un archivo de configuración,
		// input de usuario o cualquier otra fuente
		try {
			List<String> columnas = Arrays.asList("CreditoID", "MontoCapital", "MontoInteres", "MontoInteresMoratorio", "Comisiones", "MotivoCondonacion");
			ArrayList<HSSFRow> listafilas = new ArrayList<HSSFRow>();
			listafilas = readExcelFile(rutaFinal, 0, 0);
			HSSFCell columna;
			for (int i = 0; i < listafilas.size(); i++) {
				long credito = 0;
				double montoCondenar = 0;
				if (i == 0) {// Validar columnas
					if (columnas.size() > 6) {
						mensaje.setNumero(1);
						throw new Exception("Las Columnas no Corresponden al Formato del Layout.");
					}
					for (int j = 0; j < columnas.size(); j++) {
						columna = listafilas.get(i).getCell(j);
						if (!columna.getStringCellValue().equals(columnas.get(j))) {
							mensaje.setNumero(2);
							throw new Exception("Las Columnas no Corresponden al Formato del Layout.");
						}
					}
				} else {
					CreditosBean creditoBean = new CreditosBean();
					for (int j = 0; j < columnas.size(); j++) {
						columna = listafilas.get(i).getCell(j);
						DataFormatter formatter = new DataFormatter();
						String valor = formatter.formatCellValue(listafilas.get(i).getCell(j));
						if (j == 0) {
							credito = Utileria.convierteLong(valor);
							if (credito == 0) {
								mensaje.setNumero(4);
								throw new Exception("El Número de Crédito esta Vacío o la Información esta Incorrecta.");
							}

							creditoBean.setCreditoID(String.valueOf(credito));
							creditoBean = creditosDAO.consultaPrincipal(creditoBean, 1);
							if (creditoBean == null || creditoBean.getCreditoID() == null || creditoBean.getCreditoID().isEmpty()) {
								mensaje.setNumero(5);
								throw new Exception("El Crédito " + credito + " No Existe.");
							}
							if (!creditoBean.getEstatus().equalsIgnoreCase("V")) {
								if (!creditoBean.getEstatus().equalsIgnoreCase("B")) {
									mensaje.setNumero(6);
									throw new Exception("El Crédito " + credito + " no se encuentra Activo.");
								}
							}

						} else if (j > 0 && j <= 4) {
							if (valor == null || valor.trim().isEmpty()) {
								mensaje.setNumero(7);
								throw new Exception("El Campo esta Vacío para el Crédito " + credito);
							}
							switch (columna.getCellType()) {
							case HSSFCell.CELL_TYPE_NUMERIC:
								break;
							default:
								mensaje.setNumero(8);
								throw new Exception("Información Incorrecta.");
							}
							montoCondenar = montoCondenar + Utileria.convierteDoble(valor);
						} else if (j == 5) {
							if (columna.getStringCellValue().isEmpty()) {
								mensaje.setNumero(9);
								throw new Exception("El Motivo de Condonación esta Vacío para el crédito " + credito + ".");
							}
							CuentasAhoBean cta = new CuentasAhoBean();
							cta.setCuentaAhoID(creditoBean.getCuentaID());
							cta = cuentasAhoDAO.consultaPrincipal(cta, Enum_Con_CuentasAho.principal);
							double saldoDisp = Utileria.convierteDoble(cta.getSaldoDispon());
							if (saldoDisp > 0) {
								mensaje.setNumero(10);
								throw new Exception("La Cuenta <b>" + cta.getCuentaAhoID() + "</b> del Crédito <b>" + credito + "</b> no debe tener Saldo mayor a 0.");
							}
						}
					}
				}

			}

		} catch (Exception ex) {
			ex.printStackTrace();
			if (mensaje.getNumero() > 0) {
				mensaje.setDescripcion(ex.getMessage());
			} else {
				mensaje.setNumero(888);
				mensaje.setDescripcion("Formato Inválido.");
			}
		}
		return mensaje;
	}
	private MensajeTransaccionArchivoBean validarXLSCastigo(String rutaFinal, long numTransaccion) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		// paso 0. Definir una colección con nombres de las columnas a procesar
		// considera que esto lo puedes leer de un archivo de configuración,
		// input de usuario o cualquier otra fuente
		try {
			List<String> columnas = Arrays.asList("CreditoID", "MotivoCastigo", "CobranzaRealizada", "Observaciones");
			ArrayList<HSSFRow> listafilas = new ArrayList<HSSFRow>();
			listafilas = readExcelFile(rutaFinal, 0, 0);
			HSSFCell columna;
			for (int i = 0; i < listafilas.size(); i++) {
				long credito = 0;
				double montoCondenar = 0;
				if (i == 0) {// Validar columnas
					if (columnas.size() != 4 ) {
						mensaje.setNumero(1);
						throw new Exception("Las Columnas no Corresponden al Formato del Layout.");
					}
					for (int j = 0; j < columnas.size(); j++) {
						columna = listafilas.get(i).getCell(j);
						if (!columna.getStringCellValue().equals(columnas.get(j))) {
							mensaje.setNumero(2);
							throw new Exception("Las Columnas no Corresponden al Formato del Layout.");
						}
					}
				} else {
					CreditosBean creditoBean = new CreditosBean();
					for (int j = 0; j < columnas.size(); j++) {
						columna = listafilas.get(i).getCell(j);
						DataFormatter formatter = new DataFormatter();
						String valor = formatter.formatCellValue(listafilas.get(i).getCell(j));
						System.out.println(">"+valor+"\t"+i+"\t"+j);
						if (j == 0) {
							credito = Utileria.convierteLong(valor);
							if (credito == 0) {
								mensaje.setNumero(4);
								throw new Exception("El Número de Crédito esta Vacío o la Información esta Incorrecta.");
							}
							creditoBean.setCreditoID(String.valueOf(credito));
						} else if(j<3) {
							int id = Utileria.convierteEntero(valor);
							if(id==0) {
								mensaje.setNumero(4);
								throw new Exception("Formato no Válido.");
							}
							switch(j) {
								case 1: creditoBean.setMotivoCastigoID(String.valueOf(id));
									break;
								case 2:creditoBean.setTipoCobranza(String.valueOf(id));
									break;
							}
						} else if(j==3) {
							MensajeTransaccionBean msg=new MensajeTransaccionBean();
							msg = archUploadGenDAO.castigoMasVal(creditoBean, numTransaccion);
							if(msg.getNumero()!=0) {
								mensaje.setNumero(msg.getNumero());
								mensaje.setDescripcion(msg.getDescripcion());
								throw new Exception(msg.getDescripcion());
							}
							creditoBean = new CreditosBean();
						}//End if(j==0)
					}
				}

			}

		} catch (Exception ex) {
			ex.printStackTrace();
			if (mensaje.getNumero() > 0) {
				mensaje.setDescripcion(ex.getMessage());
			} else {
				mensaje.setNumero(888);
				mensaje.setDescripcion("Formato Inválido.");
			}
		}
		return mensaje;
	}
	
	public ArrayList<HSSFRow> readExcelFile(String fileName,
			int filaInicio, int numHoja) {
		ArrayList<HSSFRow> list = new ArrayList<HSSFRow>();
		try {
			POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(
					fileName));
			HSSFWorkbook libro = new HSSFWorkbook(fs);
			HSSFSheet hoja = libro.getSheetAt(numHoja);
			HSSFRow fila;
			Iterator iterator = hoja.rowIterator();
			while (iterator.hasNext()) {
				fila = hoja.getRow(filaInicio);
				if (fila != null) {
					list.add(fila);
				}
				iterator.next();
				filaInicio++;
			} // Fin While
		} catch (IOException e) {
			loggerSAFI.info("Error al leer el fichero!");
		}
		return list;
	}

	public ArchUploadGenDAO getArchUploadGenDAO() {
		return archUploadGenDAO;
	}

	public void setArchUploadGenDAO(ArchUploadGenDAO archUploadGenDAO) {
		this.archUploadGenDAO = archUploadGenDAO;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}

	public CreditosDAO getCreditosDAO() {
		return creditosDAO;
	}

	public void setCreditosDAO(CreditosDAO creditosDAO) {
		this.creditosDAO = creditosDAO;
	}

	public CuentasAhoDAO getCuentasAhoDAO() {
		return cuentasAhoDAO;
	}

	public void setCuentasAhoDAO(CuentasAhoDAO cuentasAhoDAO) {
		this.cuentasAhoDAO = cuentasAhoDAO;
	}

}

