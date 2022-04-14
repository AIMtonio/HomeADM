package inversiones.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.TipoInversionBean;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

public class TipoInversionesDAO extends BaseDAO {

	public TipoInversionesDAO(){
		super();
	}


	public MensajeTransaccionBean alta(final TipoInversionBean tipoInversion)  {
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
									String query = "call TIPOINVERSIONALT(?,?,?,?,?,	?,?,?,?,?,"
											   					   + "?,?,?,?,?,	?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Descripcion",tipoInversion.getDescripcion());
									sentenciaStore.setInt("Par_MonedaID",tipoInversion.getMonedaId());
									sentenciaStore.setString("Par_Reinversion",tipoInversion.getReinversion());
									sentenciaStore.setString("Par_Reinvertir",tipoInversion.getReinvertir());
									sentenciaStore.setString("Par_ClaveCNBV",tipoInversion.getClaveCNBV());
									sentenciaStore.setString("Par_ClaveCNBVAmpCred",tipoInversion.getClaveCNBVAmpCred());

									//nuevos datos para RECA
									sentenciaStore.setString("Par_NumRegistroRECA",tipoInversion.getNumRegistroRECA());
									sentenciaStore.setString("Par_FechaInscripcion",tipoInversion.getFechaInscripcion());
									sentenciaStore.setString("Par_NombreComercial",tipoInversion.getNombreComercial());

									sentenciaStore.setString("Par_PagoPeriodico",tipoInversion.getPagoPeriodico());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","InversionDAO.modificaInversion");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINVERSIONALT "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TipoInversionDAO.alta");
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
							throw new Exception(Constantes.MSG_ERROR + " .TipoInversionDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Tipos de inversion" + e);
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


	public MensajeTransaccionBean modificaTipoInvercion(final TipoInversionBean tipoInversion)  {
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
									String query = "call TIPOINVERSIONMOD(?,?,?,?,?,	?,?,?,?,?,"
											   					   + "?,?,?,?,?,	?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TipoInversionID",tipoInversion.getTipoInvercionID());
									sentenciaStore.setString("Par_Descripcion",tipoInversion.getDescripcion());
									sentenciaStore.setInt("Par_MonedaID",tipoInversion.getMonedaId());
									sentenciaStore.setString("Par_Reinversion",tipoInversion.getReinversion());
									sentenciaStore.setString("Par_Reinvertir",tipoInversion.getReinvertir());

									//nuevos datos para RECA
									sentenciaStore.setString("Par_NumRegistroRECA",tipoInversion.getNumRegistroRECA());
									sentenciaStore.setString("Par_FechaInscripcion",tipoInversion.getFechaInscripcion());
									sentenciaStore.setString("Par_NombreComercial",tipoInversion.getNombreComercial());

									sentenciaStore.setString("Par_ClaveCNBV",tipoInversion.getClaveCNBV());
									sentenciaStore.setString("Par_ClaveCNBVAmpCred",tipoInversion.getClaveCNBVAmpCred());
									sentenciaStore.setString("Par_PagoPeriodico", tipoInversion.getPagoPeriodico());
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","InversionDAO.modificaInversion");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINVERSIONMOD "+ sentenciaStore.toString());
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

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TipoInversionDAO.modificaTipoInvercion");
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
							throw new Exception(Constantes.MSG_ERROR + " .TipoInversionDAO.modificaTipoInvercion");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion de Tipos de inversion" + e);
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


	public TipoInversionBean consultaPrincipal(TipoInversionBean tipoInversion, int tipoConsulta){

		String query = "call TIPOINVERSIONCON(?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {	Integer.parseInt(tipoInversion.getTipoInvercionID()),
								tipoInversion.getMonedaId(),
								tipoConsulta,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoInversionesDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINVERSIONCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TipoInversionBean tipoInversionBean = new TipoInversionBean();

				tipoInversionBean.setTipoInvercionID(Utileria.completaCerosIzquierda(String.valueOf(resultSet.getInt(1)), 5));
				tipoInversionBean.setDescripcion(resultSet.getString(2));
				tipoInversionBean.setReinvertir(resultSet.getString(3));
				tipoInversionBean.setDescripcionMoneda(resultSet.getString(4));
				tipoInversionBean.setReinversion(resultSet.getString(5));
				tipoInversionBean.setEstatus(resultSet.getString("Estatus"));

				return tipoInversionBean;

			}
		});

		return matches.size() > 0 ? (TipoInversionBean) matches.get(0) : null;

	}

	public TipoInversionBean consultaForanea(TipoInversionBean tipoInversion, int tipoConsulta){

		String query = "call TIPOINVERSIONCON(?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {
						Utileria.convierteEntero(tipoInversion.getTipoInvercionID()),
								tipoInversion.getMonedaId(),
								tipoConsulta,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoInversionesDAO.consultaGeneral",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINVERSIONCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TipoInversionBean tipoInversionBean = new TipoInversionBean();

				tipoInversionBean.setTipoInvercionID(Utileria.completaCerosIzquierda(String.valueOf(resultSet.getInt(1)), 5));
				tipoInversionBean.setDescripcion(resultSet.getString(2));
				tipoInversionBean.setReinversion(resultSet.getString(3));
				tipoInversionBean.setDescripcionMoneda(resultSet.getString(4));
				tipoInversionBean.setMonedaId(resultSet.getInt(5));
				tipoInversionBean.setEstatus(resultSet.getString("Estatus"));

				return tipoInversionBean;

			}
		});

		return matches.size() > 0 ? (TipoInversionBean) matches.get(0) : null;

	}

public TipoInversionBean consultaGeneral(TipoInversionBean tipoInversion, int tipoConsulta){

		String query = "call TIPOINVERSIONCON(?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {	Utileria.convierteEntero(tipoInversion.getTipoInvercionID()),
								tipoInversion.getMonedaId(),
								tipoConsulta,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoInversionesDAO.consultaGeneral",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINVERSIONCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TipoInversionBean tipoInversionBean = new TipoInversionBean();

				tipoInversionBean.setTipoInvercionID(Utileria.completaCerosIzquierda(String.valueOf(resultSet.getInt(1)), 5));
				tipoInversionBean.setDescripcion(resultSet.getString(2));
				tipoInversionBean.setReinversion(resultSet.getString(3));
				tipoInversionBean.setReinvertir(resultSet.getString(4));
				tipoInversionBean.setMonedaId(resultSet.getInt(5));
				tipoInversionBean.setClaveCNBV(resultSet.getString(6));
				tipoInversionBean.setClaveCNBVAmpCred(resultSet.getString(7));
				//Datos RECA
				tipoInversionBean.setNumRegistroRECA(resultSet.getString(8));
				tipoInversionBean.setFechaInscripcion(resultSet.getString(9));
				tipoInversionBean.setNombreComercial(resultSet.getString(10));

				tipoInversionBean.setPagoPeriodico(resultSet.getString(11));
				tipoInversionBean.setEstatus(resultSet.getString("Estatus"));


				return tipoInversionBean;

			}
		});

		return matches.size() > 0 ? (TipoInversionBean) matches.get(0) : null;

	}

	public List listaPrincipal(TipoInversionBean tipoInversionBean, int tipoLista){
		String query = "call TIPOINVERSIONLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	tipoInversionBean.getDescripcion(),
								tipoInversionBean.getMonedaId(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),

								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"TipoInversionesDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
								};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINVERSIONLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoInversionBean tipoInversionBean = new TipoInversionBean();
				tipoInversionBean.setTipoInvercionID(Utileria.completaCerosIzquierda(String.valueOf(resultSet.getInt(1)), 5));
				tipoInversionBean.setDescripcion(resultSet.getString(2));
				return tipoInversionBean;
			}
		});

		return matches;
	}

	public List listaForanea(TipoInversionBean tipoInversionBean, int tipoLista){
		String query = "call TIPOINVERSIONLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	tipoInversionBean.getDescripcion(),
								tipoInversionBean.getMonedaId(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),

								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"TipoInversionesDAO.listaForanea",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINVERSIONLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoInversionBean tipoInversionBean = new TipoInversionBean();
				tipoInversionBean.setTipoInvercionID(Utileria.completaCerosIzquierda(String.valueOf(resultSet.getInt(1)), 5));
				tipoInversionBean.setDescripcion(resultSet.getString(2));
				return tipoInversionBean;
			}
		});

		return matches;
	}


	public List listaGeneral(TipoInversionBean tipoInversionBean, int tipoLista){
		String query = "call TIPOINVERSIONLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	tipoInversionBean.getDescripcion(),
								tipoInversionBean.getMonedaId(),
								tipoLista,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoInversionesDAO.listaGeneral",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINVERSIONLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoInversionBean tipoInversionBean = new TipoInversionBean();
				tipoInversionBean.setTipoInvercionID(Utileria.completaCerosIzquierda(String.valueOf(resultSet.getInt(1)), 5));
				tipoInversionBean.setDescripcion(resultSet.getString(2));
				return tipoInversionBean;
			}
		});
		return matches;
	}
	public List listaPormoneda(TipoInversionBean tipoInversionBean, int tipoLista){
		String query = "call TIPOINVERSIONLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	tipoInversionBean.getDescripcion(),
								tipoInversionBean.getMonedaId(),
								tipoLista,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoInversionesDAO.listaGeneral",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINVERSIONLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoInversionBean tipoInversionBean = new TipoInversionBean();
				tipoInversionBean.setTipoInvercionID(String.valueOf(resultSet.getInt(1)));
				tipoInversionBean.setDescripcion(resultSet.getString(2));
				return tipoInversionBean;
			}
		});
		return matches;
	}

}
