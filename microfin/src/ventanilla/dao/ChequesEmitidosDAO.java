package ventanilla.dao;
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

import ventanilla.bean.CancelacionChequesBean;
import ventanilla.bean.ChequesEmitidosBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class ChequesEmitidosDAO extends BaseDAO{

	public ChequesEmitidosDAO (){
		super();
	}
	private final static String salidaPantalla = "S";
	String enTesoreria = "T";
	/* Guarda los datos de los cheques emitidos  */
	public MensajeTransaccionBean chequesEmitidosAlta(final ChequesEmitidosBean chequesEmitidosBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CHEQUESEMITIDOSALT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(chequesEmitidosBean.getInstitucionID()));
									sentenciaStore.setString("Par_CuentaInstitucion",chequesEmitidosBean.getCuentaInstitucion());
									sentenciaStore.setString("Par_NumeroCheque", chequesEmitidosBean.getNumeroCheque());
									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(chequesEmitidosBean.getMonto()));
									sentenciaStore.setInt("Par_SucursalID",parametrosAuditoriaBean.getSucursal());

								    sentenciaStore.setInt("Par_CajaID",Constantes.ENTERO_CERO);
								    sentenciaStore.setInt("Par_UsuarioID", parametrosAuditoriaBean.getUsuario());
								    sentenciaStore.setString("Par_Concepto", chequesEmitidosBean.getConcepto());
								    sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(chequesEmitidosBean.getClienteID()));
								    sentenciaStore.setString("Par_Beneficiario",chequesEmitidosBean.getBeneficiario());

								    sentenciaStore.setString("Par_Referencia",chequesEmitidosBean.getReferencia());
								    sentenciaStore.setString("Par_EmitidoEn",enTesoreria );
								    sentenciaStore.setString("Par_TipoChequera",chequesEmitidosBean.getTipoChequera());

								    //Parametros de OutPut
								    sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									MensajeTransaccionBean mensajeBloqueo = null;

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));


									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ChequesEmitidosDAO.altaChequesEmitidos");
									}
									return mensajeTransaccion;
								}
							});

					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cheques emitidos", e);
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

	/**
	 * Método de consulta principal para la información de los cheques.
	 * @param chequesEmitidosBean : {@link ChequesEmitidosBean} bean con la información a filtrar, InstitucionID,CuentaInstitucion,NumeroCheque, y TipoChequera.
	 * @param tipoConsulta : Consulta 1
	 * @return
	 */
	public ChequesEmitidosBean consultaPrincipal(ChequesEmitidosBean chequesEmitidosBean, int tipoConsulta) {
		ChequesEmitidosBean consultaChequesEmitidos = null;

		try{
			String query = "call CHEQUESEMITIDOSCON(?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(chequesEmitidosBean.getInstitucionID()),
					chequesEmitidosBean.getCuentaInstitucion(),
					Utileria.convierteEntero(chequesEmitidosBean.getNumeroCheque()),
					chequesEmitidosBean.getTipoChequera(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"ChequesEmitidosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ChequesEmitidosBean chequesEmitidos = new ChequesEmitidosBean();

					chequesEmitidos.setAnticipoFact(resultSet.getString("AnticipoFact"));
					chequesEmitidos.setBeneficiario(resultSet.getString("Beneficiario"));
					chequesEmitidos.setComentario(resultSet.getString("Comentario"));
					chequesEmitidos.setConcepto(resultSet.getString("Concepto"));
					chequesEmitidos.setCuentaInstitucion(resultSet.getString("CuentaInstitucion"));
					chequesEmitidos.setEstatus(resultSet.getString("Estatus"));
					chequesEmitidos.setEstatusDisp(resultSet.getString("EstatusDisp"));
					chequesEmitidos.setFacturaProvID(resultSet.getString("FacturaProvID"));
					chequesEmitidos.setFechaEmision(resultSet.getString("FechaEmision"));
					chequesEmitidos.setInstitucionID(resultSet.getString("InstitucionID"));
					chequesEmitidos.setMonto(resultSet.getString("Monto"));
					chequesEmitidos.setMotivoCanDes(resultSet.getString("MotivoCanDes"));
					chequesEmitidos.setMotivoCancela(resultSet.getString("MotivoCancela"));
					chequesEmitidos.setNombreProv(resultSet.getString("NombreProv"));
					chequesEmitidos.setNombreSucurs(resultSet.getString("NombreSucurs"));
					chequesEmitidos.setNumReqGasID(resultSet.getString("NumReqGasID"));
					chequesEmitidos.setNumeroCheque(resultSet.getString("NumeroCheque"));
					chequesEmitidos.setProveedorID(resultSet.getString("ProveedorID"));
					chequesEmitidos.setReferencia(resultSet.getString("Referencia"));
					chequesEmitidos.setSucursalID(resultSet.getString("SucursalID"));
					chequesEmitidos.setUsuarioID(resultSet.getString("UsuarioID"));

					return chequesEmitidos;
				}
			});
			consultaChequesEmitidos= matches.size() > 0 ? (ChequesEmitidosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta Principal de los Cheques", e);
		}
		return consultaChequesEmitidos;
	}

	public ChequesEmitidosBean consultaChequesEmitidos(ChequesEmitidosBean chequesEmitidosBean, int tipoConsulta) {
		ChequesEmitidosBean consultaChequesEmitidos = null;

		try{
			String query = "call CHEQUESEMITIDOSCON(?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(chequesEmitidosBean.getInstitucionID()),
					chequesEmitidosBean.getCuentaInstitucion(),
					Utileria.convierteEntero(chequesEmitidosBean.getNumeroCheque()),
					chequesEmitidosBean.getTipoChequera(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"ChequesEmitidosDAO.consultaChequesEmitidos",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ChequesEmitidosBean chequesEmitidos = new ChequesEmitidosBean();

					chequesEmitidos.setInstitucionID(resultSet.getString("InstitucionID"));
					chequesEmitidos.setCuentaInstitucion(resultSet.getString("CuentaInstitucion"));
					chequesEmitidos.setNumeroCheque(resultSet.getString("NumeroCheque"));
					chequesEmitidos.setFechaEmision(resultSet.getString("FechaEmision"));
					chequesEmitidos.setMonto(resultSet.getString("Monto"));
					chequesEmitidos.setSucursalID(resultSet.getString("SucursalID"));
					chequesEmitidos.setUsuarioID(resultSet.getString("UsuarioID"));
					chequesEmitidos.setConcepto(resultSet.getString("Concepto"));
					chequesEmitidos.setBeneficiario(resultSet.getString("Beneficiario"));
					chequesEmitidos.setEstatus(resultSet.getString("Estatus"));

					return chequesEmitidos;
				}
			});
			consultaChequesEmitidos= matches.size() > 0 ? (ChequesEmitidosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Cheques Emitidos", e);
		}
		return consultaChequesEmitidos;
	}

	/* Consuta de Cheques emitidos se usa en la pantalla de cancelacion de cheques ventanilla*/
	public ChequesEmitidosBean consultaCheques( ChequesEmitidosBean chequesEmitidosBean, int tipoConsulta) {
		ChequesEmitidosBean ChequesEmitidos = null;
		try{
			//Query con el Store Procedure
			String query = "call CHEQUESEMITIDOSCON(?,?,?,?,?,"
											+ "?,?,?,?,?,?,?);";
			Object[] parametros = {
								chequesEmitidosBean.getInstitucionIDCan(),
								chequesEmitidosBean.getNumCtaBancariaCan(),
								chequesEmitidosBean.getNumChequeCan(),
								Constantes.STRING_VACIO,
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CancelacionCheques.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ChequesEmitidosBean chequesEmitidos = new ChequesEmitidosBean();
				chequesEmitidos.setBeneficiarioCan(resultSet.getString("Beneficiario"));
				chequesEmitidos.setMonto(resultSet.getString("Monto"));
				chequesEmitidos.setConcepto(resultSet.getString("Concepto"));
				chequesEmitidos.setFechaEmision(resultSet.getString("FechaEmision"));
				chequesEmitidos.setEmitidoEn(resultSet.getString("EmitidoEn"));
				return chequesEmitidos;
					}
		});
		ChequesEmitidos= matches.size() > 0 ? (ChequesEmitidosBean) matches.get(0) : null;
	}catch(Exception e){

		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Reimpresion de Cheques Emitidos", e);

	}
	return ChequesEmitidos;
	}

	public ChequesEmitidosBean conNumTransaCheques(ChequesEmitidosBean chequesEmitidosBean, int tipoConsulta) {
		ChequesEmitidosBean consultaChequesEmitidos = null;

		try{
			String query = "call CHEQUESEMITIDOSCON(?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(chequesEmitidosBean.getInstitucionID()),
									Utileria.convierteEntero(chequesEmitidosBean.getCuentaInstitucion()),
									chequesEmitidosBean.getNumeroCheque(),
									Constantes.STRING_VACIO,
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"ChequesEmitidosDAO.consultaChequesEmitidos",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ChequesEmitidosBean chequesEmitidos = new ChequesEmitidosBean();
					chequesEmitidos.setEstatus(resultSet.getString("Estatus"));
					chequesEmitidos.setNumeroCheque(resultSet.getString("PolizaID")); //se utilizara para guaradar el num de transaccion.

					return chequesEmitidos;
				}
			});
			consultaChequesEmitidos= matches.size() > 0 ? (ChequesEmitidosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Cheques Emitidos", e);
		}
		return consultaChequesEmitidos;
	}

	public ChequesEmitidosBean conChequesGastAnticipos(ChequesEmitidosBean chequesEmitidosBean, int tipoConsulta) {
		String query = "call CHEQUESEMITIDOSCON(?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								Utileria.convierteEntero(chequesEmitidosBean.getInstitucionID()),
								chequesEmitidosBean.getCuentaInstitucion(),
								chequesEmitidosBean.getNumeroCheque(),
								chequesEmitidosBean.getTipoChequera(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								OperacionesFechas.FEC_VACIA,
								Constantes.STRING_VACIO,
								"ChequesEmitidosDAO.consultaChequesEmitidos",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				ChequesEmitidosBean chequesEmitidos = new ChequesEmitidosBean();
				chequesEmitidos.setFechaEmision(resultSet.getString("FechaEmision"));
				chequesEmitidos.setMonto(resultSet.getString("Monto"));
				chequesEmitidos.setSucursalID(resultSet.getString("SucursalID"));
				chequesEmitidos.setNombreSucurs(resultSet.getString("NombreSucurs"));
				chequesEmitidos.setConcepto(resultSet.getString("Concepto"));
				chequesEmitidos.setBeneficiario(resultSet.getString("Beneficiario"));
				chequesEmitidos.setEstatus(resultSet.getString("Estatus"));

				return chequesEmitidos;
			}
		});
		return matches.size() > 0 ? (ChequesEmitidosBean) matches.get(0) : null;
}

	public ChequesEmitidosBean conChequesSinReq(ChequesEmitidosBean chequesEmitidosBean, int tipoConsulta) {
			String query = "call CHEQUESEMITIDOSCON(?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(chequesEmitidosBean.getInstitucionID()),
									chequesEmitidosBean.getCuentaInstitucion(),
									chequesEmitidosBean.getNumeroCheque(),
									chequesEmitidosBean.getTipoChequera(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"ChequesEmitidosDAO.consultaChequesEmitidos",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					ChequesEmitidosBean chequesEmitidos = new ChequesEmitidosBean();
					chequesEmitidos.setFechaEmision(resultSet.getString("FechaEmision"));
					chequesEmitidos.setMonto(resultSet.getString("Monto"));
					chequesEmitidos.setSucursalID(resultSet.getString("SucursalID"));
					chequesEmitidos.setNombreSucurs(resultSet.getString("NombreSucurs"));
					chequesEmitidos.setConcepto(resultSet.getString("Concepto"));
					chequesEmitidos.setBeneficiario(resultSet.getString("Beneficiario"));
					chequesEmitidos.setEstatus(resultSet.getString("Estatus"));
					chequesEmitidos.setEstatusDisp(resultSet.getString("EstatusDisp"));

					return chequesEmitidos;
				}
			});

			return matches.size() > 0 ? (ChequesEmitidosBean) matches.get(0) : null;
	}

	public ChequesEmitidosBean conChequesConReq(ChequesEmitidosBean chequesEmitidosBean, int tipoConsulta) {
		String query = "call CHEQUESEMITIDOSCON(?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								Utileria.convierteEntero(chequesEmitidosBean.getInstitucionID()),
								chequesEmitidosBean.getCuentaInstitucion(),
								chequesEmitidosBean.getNumeroCheque(),
								chequesEmitidosBean.getTipoChequera(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								OperacionesFechas.FEC_VACIA,
								Constantes.STRING_VACIO,
								"ChequesEmitidosDAO.consultaChequesEmitidos",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				ChequesEmitidosBean chequesEmitidos = new ChequesEmitidosBean();
				chequesEmitidos.setFechaEmision(resultSet.getString("FechaEmision"));
				chequesEmitidos.setMonto(resultSet.getString("Monto"));
				chequesEmitidos.setSucursalID(resultSet.getString("SucursalID"));
				chequesEmitidos.setNombreSucurs(resultSet.getString("NombreSucurs"));
				chequesEmitidos.setConcepto(resultSet.getString("Concepto"));
				chequesEmitidos.setBeneficiario(resultSet.getString("Beneficiario"));
				chequesEmitidos.setNumReqGasID(resultSet.getString("NumReqGasID"));
				chequesEmitidos.setProveedorID(resultSet.getString("ProveedorID"));
				chequesEmitidos.setReferencia(resultSet.getString("Referencia"));
				chequesEmitidos.setNombreProv(resultSet.getString("NombreProv"));
				chequesEmitidos.setEstatus(resultSet.getString("Estatus"));
				chequesEmitidos.setEstatusDisp(resultSet.getString("EstatusDisp"));
				chequesEmitidos.setAnticipoFact(resultSet.getString("AnticipoFact"));
				chequesEmitidos.setFacturaProvID(resultSet.getString("FacturaProvID"));


				return chequesEmitidos;
			}
		});

		return matches.size() > 0 ? (ChequesEmitidosBean) matches.get(0) : null;
}


	public ChequesEmitidosBean conChequesConciliacion(ChequesEmitidosBean chequesEmitidosBean, int tipoConsulta) {
		String query = "call CHEQUESEMITIDOSCON(?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								Utileria.convierteEntero(chequesEmitidosBean.getInstitucionID()),
								chequesEmitidosBean.getCuentaInstitucion(),
								chequesEmitidosBean.getNumeroCheque(),
								chequesEmitidosBean.getTipoChequera(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								OperacionesFechas.FEC_VACIA,
								Constantes.STRING_VACIO,
								"ChequesEmitidosDAO.conChequesConciliacion",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				ChequesEmitidosBean chequesEmitidos = new ChequesEmitidosBean();
				chequesEmitidos.setEstatusMov(resultSet.getString("EstatusMov"));

				return chequesEmitidos;
			}
		});

		return matches.size() > 0 ? (ChequesEmitidosBean) matches.get(0) : null;
}



	public List listaChequesEmitidos(ChequesEmitidosBean chequesEmitidosBean, int tipoLista) {
		List listaChequesEmitidos = null;

		try{
			String query = "call CHEQUESEMITIDOSLIS(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									chequesEmitidosBean.getInstitucionID(),
									chequesEmitidosBean.getCuentaInstitucion(),
									chequesEmitidosBean.getNumeroCheque(),
									chequesEmitidosBean.getBeneficiario(),
									tipoLista,

									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"ChequesEmitidosDAO.listaChequesEmitidos",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};



			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {

					ChequesEmitidosBean chequesEmitidos = new ChequesEmitidosBean();
					chequesEmitidos.setClienteID(resultSet.getString("ClienteID"));
					chequesEmitidos.setBeneficiario(resultSet.getString("Beneficiario"));
					chequesEmitidos.setNumeroCheque(resultSet.getString("NumeroCheque"));
					chequesEmitidos.setEstatus(resultSet.getString("Estatus"));
					chequesEmitidos.setInstitucionID(resultSet.getString("Institucion"));

					return chequesEmitidos;
				}
			});
			listaChequesEmitidos= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Cheques Emitidos", e);
		}
		return listaChequesEmitidos;
	}


	// -- Lista de cheques emitidos usada en la pantalla de cancelacion de cheques emitidos --//
			public List listaPrincipal(ChequesEmitidosBean chequesEmitidosBean, int tipoLista) {
					//Query con el Store Procedure
					String query = "call CHEQUESEMITIDOSLIS(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {	chequesEmitidosBean.getInstitucionIDCan(),
											chequesEmitidosBean.getNumCtaBancariaCan(),
											Constantes.ENTERO_CERO,
											chequesEmitidosBean.getBeneficiarioCan(),
											tipoLista,

											chequesEmitidosBean.getSucursalID(),
											chequesEmitidosBean.getFechaInicio(),
											chequesEmitidosBean.getFechaFinal(),
											chequesEmitidosBean.getTipoChequera(),

											parametrosAuditoriaBean.getEmpresaID(),
											parametrosAuditoriaBean.getUsuario(),
											parametrosAuditoriaBean.getFecha(),
											parametrosAuditoriaBean.getDireccionIP(),
											parametrosAuditoriaBean.getNombrePrograma(),
											parametrosAuditoriaBean.getSucursal(),
											Constantes.ENTERO_CERO};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSLIS(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							CancelacionChequesBean cancelacionCheques = new CancelacionChequesBean();
							cancelacionCheques.setNumChequeCan(resultSet.getString("NumeroCheque"));
							cancelacionCheques.setBeneficiarioCan(resultSet.getString("Beneficiario"));
							cancelacionCheques.setMontoCan(resultSet.getString("Monto"));
							cancelacionCheques.setFechaCan(resultSet.getString("FechaEmision"));
							return cancelacionCheques;
						}
					});
					return matches;
			}

			// -- Lista de cheques de gastos y anticipos usada en la pantalla de tesoreria-bancos-cancelacion de cheques--//
			public List listaChequesGastAnti(ChequesEmitidosBean chequesEmitidosBean, int tipoLista) {
					//Query con el Store Procedure
					String query = "call CHEQUESEMITIDOSLIS(?,?,?,?,?,  ?,?,?,?,  ?,?,?,?,?,?,?);";
					Object[] parametros = {	chequesEmitidosBean.getInstitucionID(),
											chequesEmitidosBean.getCuentaInstitucion(),
											Constantes.ENTERO_CERO,
											chequesEmitidosBean.getBeneficiario(),
											tipoLista,

											chequesEmitidosBean.getSucursalID(),
											chequesEmitidosBean.getFechaInicio(),
											chequesEmitidosBean.getFechaFinal(),
											chequesEmitidosBean.getTipoChequera(),

											parametrosAuditoriaBean.getEmpresaID(),
											parametrosAuditoriaBean.getUsuario(),
											parametrosAuditoriaBean.getFecha(),
											parametrosAuditoriaBean.getDireccionIP(),
											parametrosAuditoriaBean.getNombrePrograma(),
											parametrosAuditoriaBean.getSucursal(),
											Constantes.ENTERO_CERO};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSLIS(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							CancelacionChequesBean cancelacionCheques = new CancelacionChequesBean();
							cancelacionCheques.setNumChequeCan(resultSet.getString("NumeroCheque"));
							cancelacionCheques.setBeneficiarioCan(resultSet.getString("Beneficiario"));
							cancelacionCheques.setMontoCan(resultSet.getString("Monto"));
							cancelacionCheques.setFechaCan(resultSet.getString("FechaEmision"));
							return cancelacionCheques;
						}
					});
					return matches;
			}


			// -- Lista de cheques de dispersiones sin requisiciones usada en la pantalla de tesoreria-bancos-cancelacion de cheques--//
			public List listaChequesDispSinReq(ChequesEmitidosBean chequesEmitidosBean, int tipoLista) {
					//Query con el Store Procedure
					String query = "call CHEQUESEMITIDOSLIS(?,?,?,?,?,  ?,?,?,?,  ?,?,?,?,?,?,?);";
					Object[] parametros = {	chequesEmitidosBean.getInstitucionID(),
											chequesEmitidosBean.getCuentaInstitucion(),
											Constantes.ENTERO_CERO,
											chequesEmitidosBean.getBeneficiario(),
											tipoLista,

											chequesEmitidosBean.getSucursalID(),
											chequesEmitidosBean.getFechaInicio(),
											chequesEmitidosBean.getFechaFinal(),
											chequesEmitidosBean.getTipoChequera(),

											parametrosAuditoriaBean.getEmpresaID(),
											parametrosAuditoriaBean.getUsuario(),
											parametrosAuditoriaBean.getFecha(),
											parametrosAuditoriaBean.getDireccionIP(),
											parametrosAuditoriaBean.getNombrePrograma(),
											parametrosAuditoriaBean.getSucursal(),
											Constantes.ENTERO_CERO};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSLIS(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							CancelacionChequesBean cancelacionCheques = new CancelacionChequesBean();
							cancelacionCheques.setNumChequeCan(resultSet.getString("NumeroCheque"));
							cancelacionCheques.setBeneficiarioCan(resultSet.getString("Beneficiario"));
							cancelacionCheques.setMontoCan(resultSet.getString("Monto"));
							cancelacionCheques.setFechaCan(resultSet.getString("FechaEmision"));
							return cancelacionCheques;
						}
					});
					return matches;
			}

			// -- Lista de cheques de dispersiones con requisiciones usada en la pantalla de tesoreria-bancos-cancelacion de cheques--//
			public List listaChequesDispConReq(ChequesEmitidosBean chequesEmitidosBean, int tipoLista) {
					//Query con el Store Procedure
					String query = "call CHEQUESEMITIDOSLIS(?,?,?,?,?, ?,?,?,?,  ?,?,?,?,?,?,?);";
					Object[] parametros = {	chequesEmitidosBean.getInstitucionID(),
											chequesEmitidosBean.getCuentaInstitucion(),
											Constantes.ENTERO_CERO,
											chequesEmitidosBean.getBeneficiario(),
											tipoLista,

											chequesEmitidosBean.getSucursalID(),
											chequesEmitidosBean.getFechaInicio(),
											chequesEmitidosBean.getFechaFinal(),
											chequesEmitidosBean.getTipoChequera(),

											parametrosAuditoriaBean.getEmpresaID(),
											parametrosAuditoriaBean.getUsuario(),
											parametrosAuditoriaBean.getFecha(),
											parametrosAuditoriaBean.getDireccionIP(),
											parametrosAuditoriaBean.getNombrePrograma(),
											parametrosAuditoriaBean.getSucursal(),
											Constantes.ENTERO_CERO};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESEMITIDOSLIS(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							CancelacionChequesBean cancelacionCheques = new CancelacionChequesBean();
							cancelacionCheques.setNumChequeCan(resultSet.getString("NumeroCheque"));
							cancelacionCheques.setBeneficiarioCan(resultSet.getString("Beneficiario"));
							cancelacionCheques.setMontoCan(resultSet.getString("Monto"));
							cancelacionCheques.setFechaCan(resultSet.getString("FechaEmision"));
							return cancelacionCheques;
						}
					});
					return matches;
			}

}
