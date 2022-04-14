package activos.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import activos.bean.CargaMasivaActivosBean;
import activos.servicio.CargaArchivoMasivoActivoServicio.Enum_Tra_CargaActivos;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class CargaArchivoMasivoActivoDAO extends BaseDAO{

	public CargaArchivoMasivoActivoDAO() {
		super();
	}

	// Inicio Proceso de Layour de Carga Masiva
	public MensajeTransaccionBean procesoLayout(final ArrayList<XSSFRow> listaActivos, final List<CargaMasivaActivosBean> listaCargaMasivaActivosBean, final int tipoOperacion){
		transaccionDAO.generaNumeroTransaccion();
		final Long transaccionID = parametrosAuditoriaBean.getNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			switch (tipoOperacion) {
				// Inicio Validación de Layout
				case Enum_Tra_CargaActivos.validacionArchivos:
					mensaje = valicionLayout(listaActivos, tipoOperacion, transaccionID);
				break;
				// Inicio Alta de Layout
				case Enum_Tra_CargaActivos.altaArchivo:
					mensaje = procesoAltaMasiva(listaCargaMasivaActivosBean, tipoOperacion, transaccionID);
				break;
			}

			mensajeTransaccionBean.setNumero(mensaje.getNumero());
			mensajeTransaccionBean.setDescripcion(mensaje.getDescripcion());
			mensajeTransaccionBean.setNombreControl(mensaje.getNombreControl());
			mensajeTransaccionBean.setConsecutivoString(mensaje.getConsecutivoString());
			mensajeTransaccionBean.setConsecutivoInt(mensaje.getConsecutivoInt());

			if( mensaje.getNumero() != 0) {
				CargaMasivaActivosBean cargaMasivaActivosBean = new CargaMasivaActivosBean();
				cargaMasivaActivosBean.setNumeroError(String.valueOf(mensaje.getNumero()));
				cargaMasivaActivosBean.setMensajeError(mensaje.getDescripcion());
				cargaMasivaActivosBean.setRegistroID(mensaje.getConsecutivoString());
				cargaMasivaActivosBean.setTransaccionID(mensaje.getConsecutivoInt());

				mensaje = bitacoraLayout(cargaMasivaActivosBean);
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+ "Bitácora Carga Masiva de Activos: "+ Utileria.logJsonFormat(mensaje));
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

		} catch (Exception e) {
			e.printStackTrace();
			if( mensajeTransaccionBean.getNumero() == Constantes.ENTERO_CERO ) {
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " + "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref. CargaArchivoMasivoActivoDAO.procesoValidaLayout");
			}
		}

		return mensajeTransaccionBean;
	}// Fin Proceso de Validación de Carga Masiva

	// Inicio Proceso de Validación de Carga Masiva
	public MensajeTransaccionBean valicionLayout(final ArrayList<XSSFRow> listaActivos, final int tipoOperacion, final long transaccionID){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		parametrosAuditoriaBean.setNumeroTransaccion(transaccionID);

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
				try {

					for (int iteracion = 0; iteracion < listaActivos.size(); iteracion++) {

						DataFormatter dataFormatter = new DataFormatter();

						CargaMasivaActivosBean cargaMasivaActivosBean = new CargaMasivaActivosBean();
						cargaMasivaActivosBean.setRegistroID(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(0)));
						cargaMasivaActivosBean.setTipoActivoID(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(1)));
						cargaMasivaActivosBean.setDescripcion(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(2)));
						cargaMasivaActivosBean.setMesesUso(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(3)));
						cargaMasivaActivosBean.setFechaAdquisicion(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(4)));

						cargaMasivaActivosBean.setNumFactura(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(5)));
						cargaMasivaActivosBean.setNumSerie(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(6)));
						cargaMasivaActivosBean.setMoi(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(7)));
						cargaMasivaActivosBean.setDepreciadoAcumulado(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(8)));
						cargaMasivaActivosBean.setTotalDepreciar(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(9)));

						cargaMasivaActivosBean.setPorDepFiscal(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(10)));
						cargaMasivaActivosBean.setPolizaFactura(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(11)));
						cargaMasivaActivosBean.setCentroCostoID(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(12)));
						cargaMasivaActivosBean.setCtaContableRegistro(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(13)));
						cargaMasivaActivosBean.setCtaContable(dataFormatter.formatCellValue(listaActivos.get(iteracion).getCell(14)));

						cargaMasivaActivosBean.setDepFiscalSaldoInicio(cargaMasivaActivosBean.getMoi());
						cargaMasivaActivosBean.setDepFiscalSaldoFin(Constantes.STRING_CERO);

						cargaMasivaActivosBean.setSucursalID(Constantes.STRING_CERO);
						cargaMasivaActivosBean.setTransaccionID(String.valueOf(transaccionID));
						cargaMasivaActivosBean.setFechaRegistro(Constantes.FECHA_VACIA);
						cargaMasivaActivosBean.setNumeroConsecutivo(String.valueOf((iteracion+1)));

						mensajeTransaccionBean = cargaMasiva(cargaMasivaActivosBean, tipoOperacion);
						if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
							mensajeTransaccionBean.setConsecutivoInt(String.valueOf(transaccionID));
							mensajeTransaccionBean.setConsecutivoString(cargaMasivaActivosBean.getRegistroID());
							throw new Exception(mensajeTransaccionBean.getDescripcion());
						}
					}

					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
					mensajeTransaccionBean.setDescripcion("Validación de Layout realizada Correctamente. <br> Total de Activos Verificados: <b>"+(listaActivos.size())+"</b>.");
					mensajeTransaccionBean.setNombreControl("procesar");
					mensajeTransaccionBean.setConsecutivoInt(String.valueOf(transaccionID));
					mensajeTransaccionBean.setConsecutivoString(String.valueOf(transaccionID));

				} catch (Exception exception) {
					if(mensajeTransaccionBean.getNumero()==0){
						mensajeTransaccionBean.setNumero(999);
					}
					mensajeTransaccionBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Validación del Layour de Activos: ", exception);
				}
				return mensajeTransaccionBean;
			}
		});
		return mensaje;
	}// Fin Proceso de Validación de Carga Masiva

	// Inicio Proceso de Alta de Carga Masiva
	public MensajeTransaccionBean procesoAltaMasiva(final List<CargaMasivaActivosBean> listaCargaMasivaActivosBean, final int tipoOperacion, final long transaccionID){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		parametrosAuditoriaBean.setNumeroTransaccion(transaccionID);

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
				try {

					for (int iteracion = 0; iteracion < listaCargaMasivaActivosBean.size(); iteracion++) {
						CargaMasivaActivosBean cargaMasivaActivosBean = (CargaMasivaActivosBean) listaCargaMasivaActivosBean.get(iteracion );
						mensajeTransaccionBean = cargaMasiva(cargaMasivaActivosBean, tipoOperacion);
						if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
							mensajeTransaccionBean.setConsecutivoString(cargaMasivaActivosBean.getRegistroID());
							mensajeTransaccionBean.setConsecutivoInt(cargaMasivaActivosBean.getTransaccionID());
							throw new Exception(mensajeTransaccionBean.getDescripcion());
						}
					}

					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
					mensajeTransaccionBean.setDescripcion("Alta Masiva de Activos realizada Correctamente. <br> Total de Activos Procesados: <b>"+listaCargaMasivaActivosBean.size()+"</b>.");
					mensajeTransaccionBean.setNombreControl("procesar");
					mensajeTransaccionBean.setConsecutivoInt(String.valueOf(transaccionID));
					mensajeTransaccionBean.setConsecutivoString(String.valueOf(transaccionID));

				} catch (Exception exception) {
					if(mensajeTransaccionBean.getNumero()==0){
						mensajeTransaccionBean.setNumero(999);
					}
					mensajeTransaccionBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Validación del Layour de Activos: ", exception);
				}
				return mensajeTransaccionBean;
			}
		});
		return mensaje;
	}// Fin Proceso de Alta de Carga Masiva

	// Inicio Carga Masiva por Layout
	public MensajeTransaccionBean cargaMasiva(final CargaMasivaActivosBean cargaMasivaActivosBean, final int tipoOperacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "CALL ACTIVOLAYOUTPRO(?,?,?,?,?," +
																	"?,?,?,?,?," +
																	"?,?,?,?,?," +
																	"?,?,?,?,?," +
																	"?,?,"+
																	"?,?,?," +
																	"?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ConsecutivoID", Utileria.convierteEntero(cargaMasivaActivosBean.getNumeroConsecutivo()));
								sentenciaStore.setInt("Par_RegistroID", Utileria.convierteEntero(cargaMasivaActivosBean.getRegistroID()));
								sentenciaStore.setLong("Par_TransaccionID", Utileria.convierteLong(cargaMasivaActivosBean.getTransaccionID()));
								sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(cargaMasivaActivosBean.getSucursalID()));
								sentenciaStore.setInt("Par_TipoActivoID", Utileria.convierteEntero(cargaMasivaActivosBean.getTipoActivoID()));

								sentenciaStore.setString("Par_Descripcion", cargaMasivaActivosBean.getDescripcion());
								sentenciaStore.setDate("Par_FechaAdquisicion", OperacionesFechas.conversionStrDate(cargaMasivaActivosBean.getFechaAdquisicion()));
								sentenciaStore.setString("Par_NumFactura",  cargaMasivaActivosBean.getNumFactura());
								sentenciaStore.setString("Par_NumSerie",  cargaMasivaActivosBean.getNumSerie());
								sentenciaStore.setDouble("Par_Moi", Utileria.convierteDoble(cargaMasivaActivosBean.getMoi()));

								sentenciaStore.setDouble("Par_DepreciadoAcumulado", Utileria.convierteDoble(cargaMasivaActivosBean.getDepreciadoAcumulado()));
								sentenciaStore.setDouble("Par_TotalDepreciar", Utileria.convierteDoble(cargaMasivaActivosBean.getTotalDepreciar()));
								sentenciaStore.setInt("Par_MesesUsos", Utileria.convierteEntero(cargaMasivaActivosBean.getMesesUso()));
								sentenciaStore.setLong("Par_PolizaFactura", Utileria.convierteLong(cargaMasivaActivosBean.getPolizaFactura()));
								sentenciaStore.setInt("Par_CentroCostoID", Utileria.convierteEntero(cargaMasivaActivosBean.getCentroCostoID()));

								sentenciaStore.setString("Par_CtaContable", cargaMasivaActivosBean.getCtaContable());
								sentenciaStore.setString("Par_CtaContableRegistro", cargaMasivaActivosBean.getCtaContableRegistro());
								sentenciaStore.setDouble("Par_PorDepFiscal", Utileria.convierteDoble(cargaMasivaActivosBean.getPorDepFiscal()));
								sentenciaStore.setDouble("Par_DepFiscalSaldoInicio", Utileria.convierteDoble(cargaMasivaActivosBean.getDepFiscalSaldoInicio()));
								sentenciaStore.setDouble("Par_DepFiscalSaldoFin", Utileria.convierteDoble(cargaMasivaActivosBean.getDepFiscalSaldoFin()));

								sentenciaStore.setDate("Par_FechaRegistro", OperacionesFechas.conversionStrDate(cargaMasivaActivosBean.getFechaRegistro()));
								sentenciaStore.setInt("Par_NumProceso", tipoOperacion);

								//Parametros de Salida
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargaMasivaActivoDAO.cargaMasiva");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CargaMasivaActivoDAO.cargaMasiva");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la carga Masiva de activos: " + exception);
					exception.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// Fin Carga Masiva por Layout

	// Inicio Alta de Bitacora por Layout
	public MensajeTransaccionBean bitacoraLayout(final CargaMasivaActivosBean cargaMasivaActivosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "CALL BITACARMASACTIVOSALT(?,?,?,?," +
																		 "?,?,?," +
																		 "?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_RegistroID", Utileria.convierteEntero(cargaMasivaActivosBean.getRegistroID()));
								sentenciaStore.setLong("Par_TransaccionID", Utileria.convierteLong(cargaMasivaActivosBean.getTransaccionID()));
								sentenciaStore.setInt("Par_NumeroError", Utileria.convierteEntero(cargaMasivaActivosBean.getNumeroError()));
								sentenciaStore.setString("Par_MensajeError", cargaMasivaActivosBean.getMensajeError());

								//Parametros de Salida
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargaMasivaActivoDAO.AltaLayout");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CargaMasivaActivoDAO.AltaLayout");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Bitacora del Layout de Carga Masiva de activos: " + exception);
					exception.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Lista Principal Bitacora
	public List<CargaMasivaActivosBean> listaLayout(final CargaMasivaActivosBean cargaMasivaActivoBean, final int tipoLista) {

		List<CargaMasivaActivosBean> listaActivos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL TMPACTIVOSLIS(?,?,"
										     +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(cargaMasivaActivoBean.getTransaccionID()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CargaMasivaActivoDAO.listaLayout",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL TMPACTIVOSLIS(" + Arrays.toString(parametros) + ")");
			@SuppressWarnings({ "unchecked", "rawtypes" })
			List<CargaMasivaActivosBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CargaMasivaActivosBean  cargaMasivaActivos = new CargaMasivaActivosBean();
					cargaMasivaActivos.setNumeroConsecutivo(resultSet.getString("NumeroConsecutivo"));
					cargaMasivaActivos.setTransaccionID(resultSet.getString("TransaccionID"));
					cargaMasivaActivos.setSucursalID(cargaMasivaActivoBean.getSucursalID());
					cargaMasivaActivos.setRegistroID(resultSet.getString("RegistroID"));
					cargaMasivaActivos.setTipoActivoID(resultSet.getString("TipoActivoID"));
					cargaMasivaActivos.setDescripcion(resultSet.getString("Descripcion"));

					cargaMasivaActivos.setFechaAdquisicion(resultSet.getString("FechaAdquisicion"));
					cargaMasivaActivos.setNumFactura(resultSet.getString("NumFactura"));
					cargaMasivaActivos.setNumSerie(resultSet.getString("NumSerie"));
					cargaMasivaActivos.setMoi(resultSet.getString("Moi"));
					cargaMasivaActivos.setDepreciadoAcumulado(resultSet.getString("DepreciadoAcumulado"));

					cargaMasivaActivos.setTotalDepreciar(resultSet.getString("TotalDepreciar"));
					cargaMasivaActivos.setMesesUso(resultSet.getString("MesesUso"));
					cargaMasivaActivos.setPolizaFactura(resultSet.getString("PolizaFactura"));
					cargaMasivaActivos.setCentroCostoID(resultSet.getString("CentroCostoID"));
					cargaMasivaActivos.setCtaContable(resultSet.getString("CtaContable"));

					cargaMasivaActivos.setCtaContableRegistro(resultSet.getString("CtaContableRegistro"));
					cargaMasivaActivos.setPorDepFiscal(resultSet.getString("PorDepFiscal"));
					cargaMasivaActivos.setDepFiscalSaldoInicio(resultSet.getString("DepFiscalSaldoInicio"));
					cargaMasivaActivos.setDepFiscalSaldoFin(resultSet.getString("depFiscalSaldoFin"));
					cargaMasivaActivos.setFechaRegistro(cargaMasivaActivoBean.getFechaRegistro());


					return cargaMasivaActivos;
				}
			});

			listaActivos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista del Layout de Carga Masiva: ", exception);
			listaActivos = null;
		}

		return listaActivos;
	}

}
