package activos.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import activos.bean.ActivosBean;
import activos.bean.TiposActivosBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ActivosDAO extends BaseDAO{

	public ActivosDAO() {
		super();
	}

	/* ALTA DE ACTIVO */
	public MensajeTransaccionBean altaActivo(final ActivosBean activosBean) {
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

								String query = "CALL ACTIVOSALT(?,?,?,?,?," +
															   "?,?,?,?,?," +
															   "?,?,?,?,?," +
															   "?,?,?,?,?," +
															   "?,?," +
															   "?,?,?," +
															   "?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_TipoActivoID",Utileria.convierteEntero(activosBean.getTipoActivoID()));
								sentenciaStore.setString("Par_Descripcion",activosBean.getDescripcion());
								sentenciaStore.setString("Par_FechaAdquisicion",Utileria.convierteFecha(activosBean.getFechaAdquisicion()));
								sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(activosBean.getProveedorID()));
								sentenciaStore.setString("Par_NumFactura",activosBean.getNumFactura());

								sentenciaStore.setString("Par_NumSerie",activosBean.getNumSerie());
								sentenciaStore.setDouble("Par_Moi",Utileria.convierteDoble(activosBean.getMoi()));
								sentenciaStore.setDouble("Par_DepreciadoAcumu",Utileria.convierteDoble(activosBean.getDepreciadoAcumulado()));
								sentenciaStore.setDouble("Par_TotalDepreciar",Utileria.convierteDoble(activosBean.getTotalDepreciar()));
								sentenciaStore.setInt("Par_MesesUsos",Utileria.convierteEntero(activosBean.getMesesUso()));

								sentenciaStore.setLong("Par_PolizaFactura",Utileria.convierteLong(activosBean.getPolizaFactura()));
								sentenciaStore.setInt("Par_CentroCostoID",Utileria.convierteEntero(activosBean.getCentroCostoID()));
								sentenciaStore.setString("Par_CtaContable",activosBean.getCtaContable());
								sentenciaStore.setString("Par_CtaContableRegistro",activosBean.getCtaContableRegistro());
								sentenciaStore.setString("Par_Estatus",activosBean.getEstatus());

								sentenciaStore.setString("Par_TipoRegistro",activosBean.getTipoRegistro());
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(activosBean.getSucursalID()));
								sentenciaStore.setDouble("Par_PorDepFiscal",Utileria.convierteDoble(activosBean.getPorDepFiscal()));
								sentenciaStore.setDouble("Par_DepFiscalSaldoInicio",Utileria.convierteDoble(activosBean.getDepFiscalSaldoInicio()));
								sentenciaStore.setDouble("Par_DepFiscalSaldoFin",Utileria.convierteDoble(activosBean.getDepFiscalSaldoFin()));

								sentenciaStore.setString("Par_FechaRegistro", Utileria.convierteFecha(activosBean.getFechaRegistro()));
								sentenciaStore.registerOutParameter("Par_ActivoID", Types.INTEGER);

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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ActivosDAO.altaActivo");
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
						throw new Exception(Constantes.MSG_ERROR + " .ActivosDAO.altaActivo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de activo: " + e);
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

	/* MODIFICACION DE ACTIVO */
	public MensajeTransaccionBean modificaActivo(final ActivosBean activosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					long numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();

					// Se valida si el Activo esta en Proceso de Modificacion
					mensajeBean = validaActivo(activosBean, numeroTransaccion);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

					// Proceso de Modificacion del Activo
					mensajeBean = modificarActivos(activosBean, numeroTransaccion);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificación de activo: " + e);
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
	/* MODIFICACION DE ACTIVO */
	public MensajeTransaccionBean modificarActivos(final ActivosBean activosBean, final long numTransaccion) {
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

								String query = "call ACTIVOSMOD(?,?,?,?,?," +
															   "?,?,?,?,?," +
															   "?,?,?,?,?," +
															   "?,?,?,?," +
															   "?,?,?," +
															   "?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ActivoID",Utileria.convierteEntero(activosBean.getActivoID()));
								sentenciaStore.setInt("Par_TipoActivoID",Utileria.convierteEntero(activosBean.getTipoActivoID()));
								sentenciaStore.setString("Par_Descripcion",activosBean.getDescripcion());
								sentenciaStore.setString("Par_FechaAdquisicion",Utileria.convierteFecha(activosBean.getFechaAdquisicion()));
								sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(activosBean.getProveedorID()));

								sentenciaStore.setString("Par_NumFactura",activosBean.getNumFactura());
								sentenciaStore.setString("Par_NumSerie",activosBean.getNumSerie());
								sentenciaStore.setDouble("Par_Moi",Utileria.convierteDoble(activosBean.getMoi()));
								sentenciaStore.setDouble("Par_DepreciadoAcumu",Utileria.convierteDoble(activosBean.getDepreciadoAcumulado()));
								sentenciaStore.setDouble("Par_TotalDepreciar",Utileria.convierteDoble(activosBean.getTotalDepreciar()));

								sentenciaStore.setInt("Par_MesesUsos",Utileria.convierteEntero(activosBean.getMesesUso()));
								sentenciaStore.setLong("Par_PolizaFactura",Utileria.convierteLong(activosBean.getPolizaFactura()));
								sentenciaStore.setInt("Par_CentroCostoID",Utileria.convierteEntero(activosBean.getCentroCostoID()));
								sentenciaStore.setString("Par_CtaContable",activosBean.getCtaContable());
								sentenciaStore.setString("Par_Estatus",activosBean.getEstatus());

								sentenciaStore.setString("Par_TipoRegistro",activosBean.getTipoRegistro());
								sentenciaStore.setDouble("Par_PorDepFiscal",Utileria.convierteDoble(activosBean.getPorDepFiscal()));
								sentenciaStore.setDouble("Par_DepFiscalSaldoInicio",Utileria.convierteDoble(activosBean.getDepFiscalSaldoInicio()));
								sentenciaStore.setDouble("Par_DepFiscalSaldoFin",Utileria.convierteDoble(activosBean.getDepFiscalSaldoFin()));

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
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ActivosDAO.modificaActivo");
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
						throw new Exception(Constantes.MSG_ERROR + " .ActivosDAO.modificaActivo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificación de activo: " + e);
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

	/* VALIDA QUE EL ACTIVO NO ESTA EN PROCESO DE MODIFICACION */
	public MensajeTransaccionBean validaActivo(final ActivosBean activosBean, final long numTransaccion) {
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

								String query = "call VALIDAOPEACTIVOSALT(" +
														"?,?,?,?,?," +
														"?,?,?,?,?," +
														"?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ActivoID",Utileria.convierteEntero(activosBean.getActivoID()));

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
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ActivosDAO.validaOpeActivo");
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
						throw new Exception(Constantes.MSG_ERROR + " .ActivosDAO.validaOpeActivo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en validacion de activo: " + e);
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

	/* CONSULTA DE ACTIVO */
	public ActivosBean consultaActivos(int tipoConsulta, ActivosBean activosBean) {
		ActivosBean bean = null;
		try{
			// Query con el Store Procedure
			String query = "CALL ACTIVOSCON(?,?,"
										  +"?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteEntero(activosBean.getActivoID()),
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ActivosDAO.consultaActivos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL ACTIVOSCON(  " + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

					ActivosBean beanConsulta = new ActivosBean();

					beanConsulta.setActivoID(resultSet.getString("ActivoID"));
					beanConsulta.setTipoActivoID(resultSet.getString("TipoActivoID"));
					beanConsulta.setDescripcion(resultSet.getString("Descripcion"));
					beanConsulta.setFechaAdquisicion(resultSet.getString("FechaAdquisicion"));
					beanConsulta.setProveedorID(resultSet.getString("ProveedorID"));

					beanConsulta.setNumFactura(resultSet.getString("NumFactura"));
					beanConsulta.setNumSerie(resultSet.getString("NumSerie"));
					beanConsulta.setMoi(resultSet.getString("Moi"));
					beanConsulta.setDepreciadoAcumulado(resultSet.getString("DepreciadoAcumulado"));
					beanConsulta.setTotalDepreciar(resultSet.getString("TotalDepreciar"));

					beanConsulta.setMesesUso(resultSet.getString("MesesUso"));
					beanConsulta.setPolizaFactura(resultSet.getString("PolizaFactura"));
					beanConsulta.setCentroCostoID(resultSet.getString("CentroCostoID"));
					beanConsulta.setCtaContable(resultSet.getString("CtaContable"));
					beanConsulta.setEstatus(resultSet.getString("Estatus"));

					beanConsulta.setTipoRegistro(resultSet.getString("TipoRegistro"));
					beanConsulta.setFechaRegistro(resultSet.getString("FechaRegistro"));
					beanConsulta.setEsEditable(resultSet.getString("EsEditable"));
					beanConsulta.setNumeroConsecutivo(resultSet.getString("NumeroConsecutivo"));
					beanConsulta.setPorDepFiscal(resultSet.getString("PorDepFiscal"));

					beanConsulta.setDepFiscalSaldoInicio(resultSet.getString("DepFiscalSaldoInicio"));
					beanConsulta.setDepFiscalSaldoFin(resultSet.getString("DepFiscalSaldoFin"));
					beanConsulta.setCtaContableRegistro(resultSet.getString("CtaContableRegistro"));

					return beanConsulta;

				}
			});

			bean= matches.size() > 0 ? (ActivosBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de datos de activos", e);
		}
		return bean;
	}

	/* LISTA DE ACTIVOS */
	public List listaActivos(int tipoLista, ActivosBean activosBean) {
		List<ActivosBean> listaActivosBean = null;
		try{

			// Query con el Store Procedure
			String query = "CALL ACTIVOSLIS(?,?,"
										  +"?,?,?,?,?,?,?);";

			Object[] parametros = {
				activosBean.getDescripcion(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ActivosDAO.listaActivos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL ACTIVOSLIS(  " + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

					ActivosBean bean = new ActivosBean();

					bean.setActivoID(resultSet.getString("ActivoID"));
					bean.setDescripcion(resultSet.getString("Descripcion"));
					bean.setEstatus(resultSet.getString("Estatus"));

					return bean;
				}
			});
			listaActivosBean = matches;

		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Activos: ", exception);
			listaActivosBean = null;
		}

		return listaActivosBean;
	}

}
