package nomina.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDataFormatter;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.web.multipart.MultipartFile;

import originacion.bean.SolicitudCreditoBean;
import originacion.dao.SolicitudCreditoDAO;
import pld.bean.PLDListasPersBloqBean;
import pld.bean.SeguimientoPersonaListaBean;
import pld.dao.PLDListasPersBloqDAO;
import pld.dao.SeguimientoPersonaListaDAO;
import nomina.bean.BitacoraPagoNominaBean;
import nomina.bean.CargaPagoErrorBean;
import nomina.bean.PagoNominaBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class BitacoraPagoNominaDAO extends BaseDAO{

	ParametrosSesionBean parametros = null;
	PagoNominaDAO pagoNominaDAO	= null;
	CargaPagoErrorDAO cargaPagoErrorDAO = null;
	SolicitudCreditoDAO	solCreDAO 	= null;
	String nombreArchivo = "";
	String folioCargaID = "";
	String institNominaID = "";
	PLDListasPersBloqDAO pldListasPersBloqDAO = null;
	SeguimientoPersonaListaDAO seguimientoPersonaListaDAO = null;

	// Carga de detalle de pagos de nomina
	public MensajeTransaccionBean altaPagosDetalle(final BitacoraPagoNominaBean bitacoraPagoNominaBean){

		MensajeTransaccionBean resultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		resultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			ArrayList listaExito = null;
			ArrayList listaError = null;
			double listaMonto = 0;

				public Object doInTransaction(TransactionStatus transaction) {

				MensajeTransaccionBean resultadoBean = new MensajeTransaccionBean();
				resultadoBean.setNumero(0);

				PagoNominaBean pagoNominaBean = null;
				CargaPagoErrorBean cargaPagoErrorBean = null;
				try{
					// Guarda fisicamente en la ruta los archivos de pago de nomina
					guardaArchivoPagosNomina(bitacoraPagoNominaBean);

					//Lee el archivo en excel de pago de nomina
					ArrayList listas = (ArrayList) leerArchivoExcel(bitacoraPagoNominaBean);


					 listaExito = (ArrayList) listas.get(0);
					 listaError = (ArrayList) listas.get(1);
					 listaMonto =  (Double) listas.get(2);


					int totalFolios = listaExito.size() + listaError.size();

					bitacoraPagoNominaBean.setNumPagosExito(Integer.toString(listaExito.size()));
					bitacoraPagoNominaBean.setNumPagosError(Integer.toString(listaError.size()));
					bitacoraPagoNominaBean.setMontoPagos(Double.toString(listaMonto));
					bitacoraPagoNominaBean.setNumTotalPagos(Integer.toString(totalFolios));
					bitacoraPagoNominaBean.setRutaArchivosPagos(nombreArchivo);

					// Registra folios de pagos de nomina en BECARGAPAGNOMINA
					resultadoBean = altaCargoPagosNomina(bitacoraPagoNominaBean,parametrosAuditoriaBean.getNumeroTransaccion());

					folioCargaID = resultadoBean.getConsecutivoString();
					institNominaID = bitacoraPagoNominaBean.getInstitNominaID();

					// Registra folios exitosos de pagos de nomina en BEPAGOSNOMINA
					if(!listaExito.isEmpty() && listaError.isEmpty() ){
						for(int i=0; i < listaExito.size(); i++){
							pagoNominaBean = (PagoNominaBean) listaExito.get(i);
							pagoNominaBean.setFolioCargaID(folioCargaID);
							pagoNominaBean.setInstitNominaID(institNominaID);

							resultadoBean = pagoNominaDAO.altaPagosNomina(pagoNominaBean, parametrosAuditoriaBean.getNumeroTransaccion());

						}
					}
					// Registra folios erroneos de pagos de nomina en CARGAPAGONOMERROR
					if(!listaError.isEmpty()){
						for(int i=0; i < listaError.size(); i++){
							cargaPagoErrorBean = (CargaPagoErrorBean) listaError.get(i);
							cargaPagoErrorBean.setFolioCargaID(folioCargaID);
							cargaPagoErrorBean.setInstitNominaID(institNominaID);

							resultadoBean = cargaPagoErrorDAO.altaPagosError(cargaPagoErrorBean, parametrosAuditoriaBean.getNumeroTransaccion());

						}
				}

				}catch(Exception e){
					if (resultadoBean.getNumero() == 0) {
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion(e.getMessage());
						resultadoBean.setNombreControl(resultadoBean.getNombreControl());
						resultadoBean.setConsecutivoString(folioCargaID);
					}

					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de pagos de nomina", e);
					transaction.setRollbackOnly();
				}
				int registroTotal = listaExito.size()+listaError.size();
				int registroExito = listaExito.size();
				int registroError = listaError.size();
				DecimalFormat formateador = new DecimalFormat("###,###.##");
				resultadoBean.setDescripcion ("" +
						"<table border='0'>" +
						"<tr>" +
						"<td>Folio Carga: </td>" +
						"<td style='text-align:right;'>"+ folioCargaID+"</td>" +
						"</tr>" +
						"<tr>" +
						"<td>Registro Total: </td>" +
						"<td style='text-align:right;'>"+registroTotal+"</td>" +
						"</tr>" +
						"<tr>" +
						"<td>Registros Exitosos: </td>" +
						"<td style='text-align:right;'>"+registroExito+"</td>" +
						"</tr>" +
						"<tr>" +
						"<td>Registros Fallidos: </td>" +
						"<td style='text-align:right;'>"+registroError+"</td>" +
						"</tr>" +
						"<tr>" +
						"<td nowrap='nowrap'>Monto Total Exitoso: </td>" +
						"<td style='text-align:right;'>$"+formateador.format(listaMonto)+"</td>" +
						"</tr>" +
						"</table>" +
						"");
				resultadoBean.setConsecutivoString(folioCargaID);

				return resultadoBean;
			}
		});
		return resultado;

	}

public BitacoraPagoNominaBean pagosWS(PagoNominaBean pago){
	BitacoraPagoNominaBean bitacora = new BitacoraPagoNominaBean();
	bitacora.setFolioCargaID(pago.getFolioCargaID());
	bitacora.setInstitNominaID(pago.getInstitNominaID());
	bitacora.setCreditoID(pago.getCreditoID());
	bitacora.setClienteID(pago.getClienteID());
	bitacora.setMontoPagos(pago.getMontoPagos());

	return bitacora;
}

	//Guardar fisicamente el archivo de pagos de nomina en el directorio
	public void guardaArchivoPagosNomina(BitacoraPagoNominaBean bitacoraPagoNominaBean){
		String directorio = "";
		directorio = parametros.getRutaArchivos();
		directorio = directorio +"CargaPagos/";
		Date f = new Date();
		SimpleDateFormat formatoFecha = new SimpleDateFormat("dd-MM-yyyyhh:mm:ss");
		String fecha = formatoFecha.format(f);
		try{

		boolean exists = (new File(directorio)).exists();

		if (exists) {
			MultipartFile file = bitacoraPagoNominaBean.getFile();
			nombreArchivo = directorio+fecha+".xls";

			if (file != null) {
				File filespring = new File(nombreArchivo);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());
			}
		}else {
			File aDir = new File(directorio);
			aDir.mkdir();
			MultipartFile file = bitacoraPagoNominaBean.getFile();
			nombreArchivo = directorio+fecha+".xls";
			if (file != null) {
				File filespring = new File(nombreArchivo);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());
			}
		}

		}catch(Exception e){
		}
	}

	//Funcion para leer el archivo en formato xls
	public ArrayList<HSSFRow> readExcelFile(String fileName, int filaInicio, int numHoja) {
		ArrayList<HSSFRow> list = new ArrayList<HSSFRow>();
		try {
			POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(nombreArchivo));
			HSSFWorkbook libro = new HSSFWorkbook(fs);

			HSSFSheet hoja = libro.getSheetAt(numHoja);
			HSSFRow fila;
			int ultimaFila = hoja.getLastRowNum() + 1;

			for (int i = filaInicio; i < ultimaFila; i++) {

				fila = hoja.getRow(i);

				if (fila != null) {
					list.add(fila);
				}
			}

		} catch (IOException e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo de excel", e);
		}
		return list;
	}

	// Función para leer el Archivo de Excel de Pagos de Nómina
	public List leerArchivoExcel(final BitacoraPagoNominaBean bitacoraPagoNominaBean){

		int contadorExito = 0;
		int contadorError = 0;
		ArrayList listaExito = new ArrayList();
		ArrayList listaError = new ArrayList();
		ArrayList listas	= new ArrayList();

		ArrayList<HSSFRow> listafilas = new ArrayList<HSSFRow>();

		listafilas = readExcelFile(nombreArchivo, 1, 0);	//fila 1, hoja 0

		CargaPagoErrorBean cargaPagoErrorBean = null;
		PagoNominaBean pagoNominaBean = null;
		SolicitudCreditoBean  solCreBean = null;
		solCreBean = new SolicitudCreditoBean();
		String creditoID = "";
		String folioCtrl = "";
		Double montos;
		String montoPago = "";
		boolean existe = false;
		double montoTotal = 0;
		String strMonto = "";

		try {
			for (int i = 0; i < listafilas.size(); i++) { //Mientras se encuentren resultados

				HSSFDataFormatter formatter = new HSSFDataFormatter();
				cargaPagoErrorBean = new CargaPagoErrorBean();
				pagoNominaBean = new PagoNominaBean();

				HSSFCell celda1 = listafilas.get(i).getCell(0); // Cliente
				HSSFCell celda2 = listafilas.get(i).getCell(1); // Credito
				HSSFCell celda3 = listafilas.get(i).getCell(2); // Monto

				DataFormatter dataFormatter = new DataFormatter();

				creditoID = dataFormatter.formatCellValue(celda2).trim();
				folioCtrl = dataFormatter.formatCellValue(celda1).trim();
				strMonto = dataFormatter.formatCellValue(celda3).trim();

				if (creditoID.isEmpty() && folioCtrl.isEmpty() && strMonto.isEmpty()) {
					continue;
				}

				if (creditoID.isEmpty() == false) { // valida que celda 2 contenga datos

					solCreBean  = new SolicitudCreditoBean();
					solCreBean.setSolicitudCreditoID(creditoID);
					solCreBean.setInstitucionNominaID(bitacoraPagoNominaBean.getInstitNominaID());
					solCreBean = solCreDAO.consultaExisSol(solCreBean, 7);

					existe = solCreBean != null;

					if (existe) {

						if (folioCtrl.isEmpty() == false) {// valida que celda 1 contenga datos

							String auxClien = "";
							solCreBean = new SolicitudCreditoBean();
							solCreBean.setSolicitudCreditoID(creditoID);
							solCreBean.setInstitucionNominaID(bitacoraPagoNominaBean.getInstitNominaID());
							solCreBean = solCreDAO.consultaEmpleadoCre(solCreBean, 9);

							if (solCreBean != null) {
								auxClien = solCreBean.getFolioCtrl();
								existe = folioCtrl.equals(auxClien);
							} else {
								existe = false;
							}

							if (existe) {
								if (strMonto.isEmpty() == false) {// valida que celda 3 contenga datos

									double auxsuma = 0;
									try {
										auxsuma = Double.parseDouble(strMonto);
									} catch (NumberFormatException e) {
										auxsuma = 0;
									}

									if (auxsuma > 0) { //valida que el monto de pago sea mayor a cero
										montos = auxsuma;
										montoPago = formatter.formatRawCellContents(montos,0,"#.##");

										solCreBean = new SolicitudCreditoBean();
										solCreBean.setSolicitudCreditoID(creditoID);
										solCreBean.setInstitucionNominaID(bitacoraPagoNominaBean.getInstitNominaID());
										solCreBean = solCreDAO.consultaClienCre(solCreBean, 8);
										PLDListasPersBloqBean pldListasPersBloqBean = new PLDListasPersBloqBean();
										SeguimientoPersonaListaBean seguimientoPersonaListaBean = new SeguimientoPersonaListaBean();
										if (solCreBean != null) {
											pldListasPersBloqBean.setPersonaBloqID(solCreBean.getClienteID());
											pldListasPersBloqBean.setTipoPers("CTE");
											pldListasPersBloqBean.setCreditoID(creditoID);
										} else {
											pldListasPersBloqBean = null;
										}

										if (pldListasPersBloqBean != null) {
											PLDListasPersBloqBean listasPersBloqBean = pldListasPersBloqDAO.consultaEstaBloq(pldListasPersBloqBean, 2);
											seguimientoPersonaListaBean.setTipoLista(pldListasPersBloqBean.getTipoPers());
											seguimientoPersonaListaBean.setListaDeteccion("LPB");
											seguimientoPersonaListaBean.setNumRegistro(pldListasPersBloqBean.getPersonaBloqID());
											SeguimientoPersonaListaBean listaSeguimientoBean  = seguimientoPersonaListaDAO.consultaPermite(seguimientoPersonaListaBean, 2);

											if (listasPersBloqBean.getEstaBloqueado().equalsIgnoreCase("S") && listaSeguimientoBean.getPermiteOperacion().equalsIgnoreCase("N")) {
												cargaPagoErrorBean.setCreditoID(creditoID);
												cargaPagoErrorBean.setDescripcionError("PERSONA EN LISTA DE PERSONAS BLOQUEADAS."+" FOLIO: "+listaSeguimientoBean.getOpeInusualID());
												listaError.add(contadorError,cargaPagoErrorBean);
												contadorError++;
											} else {
												pagoNominaBean.setCreditoID(creditoID);
												pagoNominaBean.setClienteID(folioCtrl);
												pagoNominaBean.setMontoPagos(montoPago);

												listaExito.add(contadorExito,pagoNominaBean);
												montoTotal = montoTotal + auxsuma;
												contadorExito++;
											}
										} else {
											pagoNominaBean.setCreditoID(creditoID);
											pagoNominaBean.setClienteID(folioCtrl);
											pagoNominaBean.setMontoPagos(montoPago);

											listaExito.add(contadorExito,pagoNominaBean);
											montoTotal = montoTotal + auxsuma;
											contadorExito++;
										}
									} else {
										cargaPagoErrorBean.setCreditoID(creditoID);
										cargaPagoErrorBean.setDescripcionError("EL MONTO DEBE SER UN NUMERO MAYOR A CERO.");
										listaError.add(contadorError,cargaPagoErrorBean);
										contadorError++;
									}
								} else {
									cargaPagoErrorBean.setCreditoID(creditoID);
									cargaPagoErrorBean.setDescripcionError("EL MONTO ESTA VACIO.");
									listaError.add(contadorError,cargaPagoErrorBean);
									contadorError++;
								}
							} else {
								cargaPagoErrorBean.setCreditoID(creditoID);
								cargaPagoErrorBean.setDescripcionError("EL CREDITO NO PERTENECE AL EMPLEADO");
								listaError.add(contadorError,cargaPagoErrorBean);
								contadorError++;
							}
						} else {
							cargaPagoErrorBean.setCreditoID(creditoID);
							cargaPagoErrorBean.setDescripcionError("EL EMPLEADO ESTA VACIO.");
							listaError.add(contadorError,cargaPagoErrorBean);
							contadorError++;
						}
					} else {
						cargaPagoErrorBean.setCreditoID(creditoID);
						cargaPagoErrorBean.setDescripcionError("EL CREDITO NO EXISTE O NO PERTENCE A LA INSTITUCION.");
						listaError.add(contadorError,cargaPagoErrorBean);
						contadorError++;
					}
				} else {
					cargaPagoErrorBean.setDescripcionError("EL CREDITO ESTA VACIO.");
					listaError.add(contadorError,cargaPagoErrorBean);
					contadorError++;
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}

		listas.add(0, listaExito);
		listas.add(1, listaError);
		listas.add(2, montoTotal);

		return listas;
	}


	/* Alta de Archivos de Pagos de Nomina en CARGAPAGONOMINA */
	public MensajeTransaccionBean altaCargoPagosNomina(final BitacoraPagoNominaBean bitacoraPagoNominaBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call BECARGAPAGNOMINALT(?,?,?,?,?,?,?,?,	?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_FolioCargaIDBE",Utileria.convierteEntero(bitacoraPagoNominaBean.getFolioCargaIDBE()));
									sentenciaStore.setInt("Par_EmpresaNominaID",Utileria.convierteEntero(bitacoraPagoNominaBean.getInstitNominaID()));
									sentenciaStore.setString("Par_ClaveUsuario",bitacoraPagoNominaBean.getClaveUsuario());
									sentenciaStore.setInt("Par_NumTotalPagos",Utileria.convierteEntero(bitacoraPagoNominaBean.getNumTotalPagos()));
									sentenciaStore.setInt("Par_NumPagosExito",Utileria.convierteEntero(bitacoraPagoNominaBean.getNumPagosExito()));
									sentenciaStore.setInt("Par_NumPagosError",Utileria.convierteEntero(bitacoraPagoNominaBean.getNumPagosError()));
									sentenciaStore.setDouble("Par_MontoPagos",Utileria.convierteDoble(bitacoraPagoNominaBean.getMontoPagos()));
									sentenciaStore.setString("Par_RutaArchivoPagoNom",bitacoraPagoNominaBean.getRutaArchivosPagos());

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;


								} //public sql exception
							} // new CallableStatementCreator
							,new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}// public
							}// CallableStatementCallback
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cargo de pagos de nomina", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}//catch
				return mensajeBean;
			} //public Object doInTransaction
		}); //men
		return mensaje;
	}

	// Lista para carga de errores de archivos de pagos de nomina
	public List listaErrorBitacoraArchivo(CargaPagoErrorBean cargaPagoErrorBean, int tipoLista){
		String query = "call CARGAPAGONOMERRORLIS(?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(cargaPagoErrorBean.getFolioCargaID()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"BitacoraPagoNominaDAO.listaErrorBitacoraArchivo",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARGAPAGONOMERRORLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CargaPagoErrorBean bitacoraBean = new CargaPagoErrorBean();
				bitacoraBean.setFolioCargaID(resultSet.getString("FolioCargaID"));
				bitacoraBean.setCreditoID(resultSet.getString("CreditoID"));
				bitacoraBean.setInstitNominaID(resultSet.getString("EmpresaNominaID"));
				bitacoraBean.setDescripcionError(resultSet.getString("DescripcionError"));

				return bitacoraBean;
			}
		});
		return matches;
	}

	//Consulta nombre de Institucion de Nomina
		public BitacoraPagoNominaBean consultaInstitucion(BitacoraPagoNominaBean bitacoraPagoNominaBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call INSTITNOMINACON(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(bitacoraPagoNominaBean.getInstitNominaID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"BitacoraPagoNominaDAO.consultaInstitucion",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINACON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					BitacoraPagoNominaBean nombre = new BitacoraPagoNominaBean();
					nombre.setInstitNominaID(resultSet.getString(1));
					nombre.setNombreInstit(resultSet.getString(2));

					return nombre;

				}
			});
			return matches.size() > 0 ? (BitacoraPagoNominaBean) matches.get(0) : null;

		}

		// Lista de los Folios Por Aplicar
		public List listaComboPorAplicar(BitacoraPagoNominaBean bitacoraPagoNominaBean, int tipoConsulta){
			String query = "call BECARGAPAGNOMINALIS(?,?,?,	?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(bitacoraPagoNominaBean.getInstitNominaID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"BitacoraPagoNominaDAO.listaCargaPagoNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BECARGAPAGNOMINALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					BitacoraPagoNominaBean bitacoraBean = new BitacoraPagoNominaBean();

					bitacoraBean.setFolioCargaID(resultSet.getString("FolioCargaID"));

					return bitacoraBean;
				}
			});
			return matches;
		}
//Consulta el monto de un folio de carga
	public BitacoraPagoNominaBean consultaMonto(BitacoraPagoNominaBean bitacoraPagoNominaBean, int tipoConsulta) {
					//Query con el Store Procedure
					String query = "call BECARGAPAGNOMINACON(?,?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
											Utileria.convierteEntero(bitacoraPagoNominaBean.getFolioCargaID()),
											Utileria.convierteEntero(bitacoraPagoNominaBean.getInstitNominaID()),
											tipoConsulta,

											Constantes.ENTERO_CERO,
											Constantes.ENTERO_CERO,
											Constantes.FECHA_VACIA,
											Constantes.STRING_VACIO,
											"BitacoraPagoNominaDAO.consultaMonto",
											Constantes.ENTERO_CERO,
											Constantes.ENTERO_CERO};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BECARGAPAGNOMINACON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

							BitacoraPagoNominaBean monto = new BitacoraPagoNominaBean();
							monto.setMontoPagos(resultSet.getString("MontoPagos"));

							return monto;

						}
					});
					return matches.size() > 0 ? (BitacoraPagoNominaBean) matches.get(0) : null;

				}

	// Carga de detalle de pagos de nomina de Banca en Linea
		public MensajeTransaccionBean altaPagosDetalleBE(final BitacoraPagoNominaBean bitacoraPagoNominaBean){
			MensajeTransaccionBean resultado = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();

			resultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {

					MensajeTransaccionBean resultadoBean = new MensajeTransaccionBean();
					resultadoBean.setNumero(0);
				// Registra folios de pagos de nomina en BECARGAPAGNOMINA
				try{
				resultadoBean = altaCargoPagosNomina(bitacoraPagoNominaBean,parametrosAuditoriaBean.getNumeroTransaccion());


			}catch(Exception e){
				if (resultadoBean.getNumero() == 0) {
					resultadoBean.setNumero(999);
					resultadoBean.setDescripcion(e.getMessage());
					resultadoBean.setNombreControl(resultadoBean.getNombreControl());
					resultadoBean.setConsecutivoString(folioCargaID);
				}

				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de carga pagos de nomina", e);
				transaction.setRollbackOnly();
			}
				return resultadoBean;
			}
		});
	return resultado;
	}

	//--------GETTERS Y SETTERS---------

	public ParametrosSesionBean getParametros() {
		return parametros;
	}

	public void setParametros(ParametrosSesionBean parametros) {
		this.parametros = parametros;
	}

	public PagoNominaDAO getPagoNominaDAO() {
		return pagoNominaDAO;
	}

	public void setPagoNominaDAO(PagoNominaDAO pagoNominaDAO) {
		this.pagoNominaDAO = pagoNominaDAO;
	}

	public CargaPagoErrorDAO getCargaPagoErrorDAO() {
		return cargaPagoErrorDAO;
	}

	public void setCargaPagoErrorDAO(CargaPagoErrorDAO cargaPagoErrorDAO) {
		this.cargaPagoErrorDAO = cargaPagoErrorDAO;
	}

	public SolicitudCreditoDAO getSolCreDAO() {
		return solCreDAO;
	}

	public void setSolCreDAO(SolicitudCreditoDAO solCreDAO) {
		this.solCreDAO = solCreDAO;
	}

	public PLDListasPersBloqDAO getPldListasPersBloqDAO() {
		return pldListasPersBloqDAO;
	}

	public void setPldListasPersBloqDAO(PLDListasPersBloqDAO pldListasPersBloqDAO) {
		this.pldListasPersBloqDAO = pldListasPersBloqDAO;
	}

	public SeguimientoPersonaListaDAO getSeguimientoPersonaListaDAO() {
		return seguimientoPersonaListaDAO;
	}

	public void setSeguimientoPersonaListaDAO(
			SeguimientoPersonaListaDAO seguimientoPersonaListaDAO) {
		this.seguimientoPersonaListaDAO = seguimientoPersonaListaDAO;
	}



}
