package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tarjetas.bean.TarDebConciEncabezaBean;
import tarjetas.bean.TarDebConciliaDetalleBean;
import tarjetas.bean.TarDebConciliaResumBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TarDebConciliaPosDAO extends BaseDAO{

	public TarDebConciliaPosDAO(){
		super();
	}

	/* Alta de Header Conciliacion Tarjetas*/
	public MensajeTransaccionBean altaEncabezadoConcilia(final TarDebConciEncabezaBean conciliaHeaderBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TARDEBCONCIENCABEZAALT(" +
													"?,?,?,?,?, ?,?,?," +
													"?,?,?,?,?, ?,?,?);";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_NomInstituGene", conciliaHeaderBean.getNomInstituGenera());
									sentenciaStore.setString("Par_NomInstituReci",conciliaHeaderBean.getNomInstituRecibe());
									sentenciaStore.setString("Par_FechaProceso",conciliaHeaderBean.getFechaProceso());
									sentenciaStore.setString("Par_Consecutivo",conciliaHeaderBean.getConsecutivo());
									sentenciaStore.setString("Par_NombreArchivo",conciliaHeaderBean.getNombreArchivo());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_ConciID", Types.VARCHAR);

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesPROFUNDAO.altaClientesPROFUN");
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
						throw new Exception(Constantes.MSG_ERROR + " .ClientesPROFUNDAO.altaClientesPROFUN");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Cliente PROFUN" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* Alta de Detalles Conciliacion Tarjetas*/
	public MensajeTransaccionBean altaDetallesConcilia(final TarDebConciliaDetalleBean conciliaDetalleBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TARDEBCONCILIADETAALT("
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?);";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_ConciliaID", conciliaDetalleBean.getConciliaID());
									sentenciaStore.setString("Par_BancoEmisor", conciliaDetalleBean.getBancoEmisor());
									sentenciaStore.setString("Par_NumCuenta", conciliaDetalleBean.getNumCuenta());
									sentenciaStore.setString("Par_NaturalezaConta", conciliaDetalleBean.getNaturalezaConta());
									sentenciaStore.setString("Par_MarcaProducto", conciliaDetalleBean.getMarcaProducto());

									sentenciaStore.setString("Par_FechaConsumo", conciliaDetalleBean.getFechaConsumo());
									sentenciaStore.setString("Par_FechaProceso", conciliaDetalleBean.getFechaProceso());
									sentenciaStore.setString("Par_TipoTransaccion", conciliaDetalleBean.getTipoTransaccion());
									sentenciaStore.setString("Par_NumLiquidacion", conciliaDetalleBean.getNumLiquidacion());
									sentenciaStore.setDouble("Par_ImporteOrigenTrans", conciliaDetalleBean.getImporteOrigenTrans());

									sentenciaStore.setDouble("Par_ImporteOrigenCon", conciliaDetalleBean.getImporteOrigenCon());
									sentenciaStore.setString("Par_CodigoMonedaOrigen", conciliaDetalleBean.getCodigoMonedaOrigen());
									sentenciaStore.setDouble("Par_ImporteDestinoTotal", conciliaDetalleBean.getImporteDestinoTotal());
									sentenciaStore.setDouble("Par_ImporteDestinoCon", conciliaDetalleBean.getImporteDestinoCon());
									sentenciaStore.setString("Par_ClaveMonedaDestino", conciliaDetalleBean.getClaveMonedaDestino());

									sentenciaStore.setDouble("Par_ImporteLiquidado", conciliaDetalleBean.getImporteLiquidado());
									sentenciaStore.setDouble("Par_ImporteLiquidadoCon", conciliaDetalleBean.getImporteLiquidadoCon());
									sentenciaStore.setString("Par_ClaveMonedaLiqui", conciliaDetalleBean.getClaveMonedaLiqui());
									sentenciaStore.setString("Par_ClaveComercio", conciliaDetalleBean.getClaveComercio());
									sentenciaStore.setString("Par_GiroNegocio", conciliaDetalleBean.getGironegocio());

									sentenciaStore.setString("Par_NombreComercio", conciliaDetalleBean.getNombreComercio());
									sentenciaStore.setString("Par_PaisOrigen", conciliaDetalleBean.getPaisOrigen());
									sentenciaStore.setString("Par_RFCComercio", conciliaDetalleBean.getRfcComercio());
									sentenciaStore.setString("Par_NumeroFuente", conciliaDetalleBean.getNumeroFuente());
									sentenciaStore.setString("Par_NumAutorizacion", conciliaDetalleBean.getNumAutorizacion());

									sentenciaStore.setString("Par_BancoReceptor", conciliaDetalleBean.getBancoReceptor());
									sentenciaStore.setString("Par_ReferenciaTrans", conciliaDetalleBean.getReferenciaTrans());
									sentenciaStore.setString("Par_FIIDEmisor", conciliaDetalleBean.getFiidEmisor());
									sentenciaStore.setString("Par_FIIDAdquiriente", conciliaDetalleBean.getFiidAdquiriente());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesPROFUNDAO.altaClientesPROFUN");
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
							throw new Exception(Constantes.MSG_ERROR + " .TarDebConciliaPOSDATO.altaDetalleConcilia");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Detalle de Conciliacion" + e);
						e.printStackTrace();

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	/* Alta de Resumen Conciliacion Tarjetas*/
	public MensajeTransaccionBean altaResumenConcilia(final TarDebConciliaResumBean conciliaResumBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TARDEBCONCIRESUMALT("
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?);";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_ConciliaID", conciliaResumBean.getConciliaID());
									sentenciaStore.setString("Par_NoTotalTransac", conciliaResumBean.getNoTotalTransac());
									sentenciaStore.setString("Par_NoTotalVentas", conciliaResumBean.getNoTotalVentas());
									sentenciaStore.setDouble("Par_ImporteVtas", conciliaResumBean.getImporteVtas());
									sentenciaStore.setString("Par_NoTotalDisposic", conciliaResumBean.getNoTotalDisposic());

									sentenciaStore.setDouble("Par_ImporteDisposicion", conciliaResumBean.getImporteDisposicion());
									sentenciaStore.setString("Par_NoTotalTransDebito", conciliaResumBean.getNoTotalTransDebito());
									sentenciaStore.setDouble("Par_ImporteTransDebito", conciliaResumBean.getImporteTransDebito());
									sentenciaStore.setString("Par_NoTotalPagosInter", conciliaResumBean.getNoTotalPagosInter());
									sentenciaStore.setDouble("Par_ImportePagosInter", conciliaResumBean.getImportePagosInter());

									sentenciaStore.setString("Par_NoTotalDevolucion", conciliaResumBean.getNoTotalDevolucion());
									sentenciaStore.setDouble("Par_ImporteTotalDevol", conciliaResumBean.getImporteTotalDevol());
									sentenciaStore.setString("Par_NoTotalTransCto", conciliaResumBean.getNoTotalTransCto());
									sentenciaStore.setDouble("Par_ImporteTransCto", conciliaResumBean.getImporteTransCto());
									sentenciaStore.setString("Par_NoTotalRepresenta", conciliaResumBean.getNoTotalRepresenta());

									sentenciaStore.setDouble("Par_ImporteRepresenta", conciliaResumBean.getImporteRepresenta());
									sentenciaStore.setString("Par_NoTotalContracargos", conciliaResumBean.getNoTotalContracargos());
									sentenciaStore.setDouble("Par_ImporteContracargos", conciliaResumBean.getImporteContracargos());
									sentenciaStore.setDouble("Par_ImporteComisiones", conciliaResumBean.getImporteComisiones());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + "TarDebConciliaPosDAO.altaResumenConcilia");
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
							throw new Exception(Constantes.MSG_ERROR + " .TarDebConciliaPOSDATO.altaDetalleConcilia");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Detalle de Conciliacion" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public TarDebConciEncabezaBean consultaFechaProceso(int tipoConsulta, TarDebConciEncabezaBean tarDebEncabeza){
		String query = "call TARDEBCONCIENCACON(?,?,?,?,  ?,?,?,?,?,?,?);";

		Object[] parametros = {
				tarDebEncabeza.getFechaProceso(),
				tarDebEncabeza.getConsecutivo(),
				tarDebEncabeza.getNombreArchivo(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarDebConciliaPosDAO.consultaFechaProceso",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBCONCIENCACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarDebConciEncabezaBean conciliaTarDeb = new TarDebConciEncabezaBean();
				conciliaTarDeb.setContinuaCarga(resultSet.getString(1));
				return conciliaTarDeb;
			}
		});
		return matches.size() > 0 ? (TarDebConciEncabezaBean) matches.get(0) : null;
	}
}
