package pld.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

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
import pld.bean.OpeEscalamientoInternoBean;
import pld.bean.PldEscalaVentBean;

public class OpeEscalamientoInternoDAO extends BaseDAO{
	// Constantes

	java.sql.Date fecha = null;
	ParametrosSesionBean parametrosSesionBean;

	public static interface Enum_EstatusOperacionPLD{
		int SEGUIMIENTO = 501;
		int AUTORIZADA = 502;
		int RECHAZADA = 503;
	}

	public static interface Enum_ProcesoPLD{
		int SEGUIMIENTO = 1;
		int AUTORIZADA = 2;
		int RECHAZADA = 3;
		int FINALIZADA = 4;
	}

	public static interface Enum_EstatusPLD{
		String SEGUIMIENTO = "S";
		String AUTORIZADA = "A";
		String RECHAZADA = "R";
		String FINALIZADA = "F";
	}

	public OpeEscalamientoInternoDAO() {
		super();
	}


	// Valida operaciones de escalamiento interno
	public MensajeTransaccionBean validaOperacionEscalamientoInt(final OpeEscalamientoInternoBean opeEscalamientoInt) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		// mensaje = (MensajeTransaccionBean) transactionTemplate.execute(new TransactionCallback<Object>() {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call DETESCALAINTPLDPRO(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_OperProcID",opeEscalamientoInt.getFolioOperacionID());
								sentenciaStore.setInt("Par_Consecutivo",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_NombreProc",opeEscalamientoInt.getNombreCliente());
								sentenciaStore.setInt("Par_Grupo",Utileria.convierteEntero(opeEscalamientoInt.getResultadoRevision()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0 && mensajeBean.getNumero()!=502){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al validar operacion de escalamiento", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					//transaction.setRollbackOnly();
				}
				return mensajeBean;

		//});
		//return mensaje;
	}


	/* Consulta de Operacion de Escalamimento Interno */
	public OpeEscalamientoInternoBean consultaOperacionEscalamiento(final OpeEscalamientoInternoBean operEscalamientoInternoBean,
																	 final int tipoConsulta) {
		OpeEscalamientoInternoBean operEscalamientoBean;
		try {

		//Query con el Store Procedure
			operEscalamientoBean = (OpeEscalamientoInternoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PLDOPEESCALAINTCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_OperProcID",operEscalamientoInternoBean.getFolioOperacionID());
								sentenciaStore.setString("Par_NombreProc",operEscalamientoInternoBean.getProcesoEscalamientoID());
								sentenciaStore.setInt("Par_TipoConsulta",tipoConsulta);
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_ResulRev", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Aud_FechaActual",fecha);
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","consultaOperacionEscalamiento");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								OpeEscalamientoInternoBean escalamientoInterno = new OpeEscalamientoInternoBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									escalamientoInterno.setFolioOperacionID(resultadosStore.getString(1));
									escalamientoInterno.setProcesoEscalamientoID(resultadosStore.getString(2));
									escalamientoInterno.setFechaDeteccion(resultadosStore.getString(3));
									escalamientoInterno.setSucursalDeteccion(String.valueOf(resultadosStore.getInt(4)));
									escalamientoInterno.setClienteID(String.valueOf(resultadosStore.getInt(5)));
									escalamientoInterno.setMatchNivelRiesgo(resultadosStore.getString(6));
									escalamientoInterno.setMatchPEPs(resultadosStore.getString(7));
									escalamientoInterno.setMatchCuenta3SinDeclarar(resultadosStore.getString(8));
									escalamientoInterno.setMatchDetalleDocumentacion(resultadosStore.getString(9));
									escalamientoInterno.setMatchMontoTransaccion(resultadosStore.getString(10));
									escalamientoInterno.setMatchOtroProceso(resultadosStore.getString(11));
									escalamientoInterno.setDescripcionOtro(resultadosStore.getString(12));
									escalamientoInterno.setFuncionarioUsuarioID(String.valueOf(resultadosStore.getInt(13)));
									escalamientoInterno.setResultadoRevision(resultadosStore.getString(14));
									escalamientoInterno.setClaveJustificacion(String.valueOf(resultadosStore.getInt(15)));
									escalamientoInterno.setSolicitaSeguimiento(resultadosStore.getString(16));
									escalamientoInterno.setNotasComentarios(resultadosStore.getString(17));
									escalamientoInterno.setFechaGestion(resultadosStore.getString(18));
									escalamientoInterno.setNombreCliente(resultadosStore.getString("NombreCompletoCliente"));
									escalamientoInterno.setRfcCliente(resultadosStore.getString("RFCOficial"));
									escalamientoInterno.setFechaSolicitud(resultadosStore.getString("FechaSolicitud"));
									escalamientoInterno.setMontoOperacion(resultadosStore.getString("MontoOperacion"));
									escalamientoInterno.setProductoInstrumentoID(resultadosStore.getString("ProductoInstrumento"));
									escalamientoInterno.setNombreProductoInstrumento(resultadosStore.getString("NombreProductoInstrumento"));
									escalamientoInterno.setUsuarioServicioID(resultadosStore.getString("UsuarioServicioID"));
									escalamientoInterno.setNombreUsuarioServicio(resultadosStore.getString("NombreCompletoUsuario"));
								}
								return escalamientoInterno;
							}
						});
			return operEscalamientoBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de operacion de escalamiento", e);
			return null;
		}
	}

	/* Consulta de Operacion de Escalamimento Interno */
	public MensajeTransaccionBean actualizaEstatusOperacionEscalamiento(final OpeEscalamientoInternoBean operEscalamientoInternoBean,
																		final int tipoActualizacion){
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
								String query = "call PLDOPEESCALAINTACT(?,?,?,?,?, ?,?,?,?,?, ?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_OperProcID",operEscalamientoInternoBean.getFolioOperacionID());
								sentenciaStore.setString("Par_NombreProc",operEscalamientoInternoBean.getProcesoEscalamientoID());
								sentenciaStore.setString("Par_TipResEscID",operEscalamientoInternoBean.getResultadoRevision());
								sentenciaStore.setInt("Par_CveJustif",Utileria.convierteEntero(operEscalamientoInternoBean.getClaveJustificacion()));
								sentenciaStore.setDate("Par_FechRealiza",OperacionesFechas.conversionStrDate(operEscalamientoInternoBean.getFechaGestion()));
								sentenciaStore.setInt("Par_CFuncionar",Utileria.convierteEntero(
																		operEscalamientoInternoBean.getFuncionarioUsuarioID()));
								sentenciaStore.setString("Par_NotasRevisor",operEscalamientoInternoBean.getNotasComentarios());
								sentenciaStore.setString("Par_SolSeguimiento",operEscalamientoInternoBean.getSolicitaSeguimiento());
								sentenciaStore.setInt("Par_TipoAct",tipoActualizacion);
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar estatus de operacion de escalamiento", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}


	//Lista
	public List opeEscalamientolistaPrincipal(final OpeEscalamientoInternoBean operEscalamientoInternoBean,
			 								  final int tipoLista) {
		//Query con el Store Procedure
		String query = "call PLDOPEESCALAINTLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	operEscalamientoInternoBean.getProcesoEscalamientoID(),
								operEscalamientoInternoBean.getNombreCliente(),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
								};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEESCALAINTLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpeEscalamientoInternoBean operEscalamientoInterno = new OpeEscalamientoInternoBean();
				operEscalamientoInterno.setFolioOperacionID(resultSet.getString(1));;
				operEscalamientoInterno.setNombreCliente(resultSet.getString(2));
				return operEscalamientoInterno;
			}
		});

		return matches;
	}

	public List opeEscalamientolistaVentanilla(final OpeEscalamientoInternoBean operEscalamientoInternoBean,
			  final int tipoLista) {
		//Query con el Store Procedure
		String query = "call PLDOPEESCALAINTLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	operEscalamientoInternoBean.getProcesoEscalamientoID(),
		operEscalamientoInternoBean.getNombreCliente(),
		tipoLista,

		parametrosAuditoriaBean.getEmpresaID(),
		parametrosAuditoriaBean.getUsuario(),
		parametrosAuditoriaBean.getFecha(),
		parametrosAuditoriaBean.getDireccionIP(),
		parametrosAuditoriaBean.getNombrePrograma(),
		parametrosAuditoriaBean.getSucursal(),
		Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEESCALAINTLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			OpeEscalamientoInternoBean operEscalamientoInterno = new OpeEscalamientoInternoBean();
			operEscalamientoInterno.setFolioOperacionID(resultSet.getString("FolioEscala"));
			operEscalamientoInterno.setNombreCliente(resultSet.getString("NombreCompleto"));
			operEscalamientoInterno.setOperacionDesc((resultSet.getString("Operacion")));
			operEscalamientoInterno.setMonto((resultSet.getString("Monto")));
			operEscalamientoInterno.setFechaOperacion((resultSet.getString("Fecha")));
			operEscalamientoInterno.setEstatus((resultSet.getString("Estatus")));
			return operEscalamientoInterno;
			}
		});

		return matches;
	}

	/**
	 * Método para la detección de operaciones en ventanilla
	 * @param pldEscalaVentBean : Bean con la Información de la Operación de la Ventanilla
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean validaOpEscalamientoIngreso(final PldEscalaVentBean pldEscalaVentBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion(true);
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL PLDESCALAVENTPRO("
									+ "?,?,?,?,?  ,"
									+ "?,?,?,?,?  ,"
									+ "?,?,?,?,?  ,"
									+ "?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_FolioEscala", pldEscalaVentBean.getFolioEscala());
							sentenciaStore.setInt("Par_OpcionCajaID", Utileria.convierteEntero(pldEscalaVentBean.getOpcionCajaID()));
							sentenciaStore.setString("Par_Proceso", pldEscalaVentBean.getProceso());
							sentenciaStore.setString("Par_ClienteID", pldEscalaVentBean.getClienteID() != null && pldEscalaVentBean.getClienteID().equals("") ? null : pldEscalaVentBean.getClienteID());
							sentenciaStore.setString("Par_UsuarioServicioID", pldEscalaVentBean.getUsuarioServicioID() != null && pldEscalaVentBean.getUsuarioServicioID().equals("") ? null : pldEscalaVentBean.getUsuarioServicioID());

							sentenciaStore.setString("Par_CuentaAhoID", pldEscalaVentBean.getCuentaAhoID() != null && pldEscalaVentBean.getCuentaAhoID().equals("") ? null : pldEscalaVentBean.getCuentaAhoID());
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(pldEscalaVentBean.getMonedaID()));
							sentenciaStore.setString("Par_Monto", pldEscalaVentBean.getMonto());
							sentenciaStore.setString("Par_FechaOperacion", Utileria.convierteFecha(pldEscalaVentBean.getFechaOperacion()));
							sentenciaStore.setString("Par_TipoResultEscID", pldEscalaVentBean.getTipoResultEscID());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0 && mensajeBean.getNumero() != 502) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al validar operacion de escalamiento", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
