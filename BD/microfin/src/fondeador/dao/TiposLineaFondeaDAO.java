package fondeador.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
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


import fondeador.bean.TiposLineaFondeaBean;

public class TiposLineaFondeaDAO extends BaseDAO{

	public TiposLineaFondeaDAO() {
		super();
	}

	// ------------------ Transacciones ------------------------------------------


	/* Alta de  Tipo Linea Fondeador*/
		public MensajeTransaccionBean alta(final TiposLineaFondeaBean tiposLineaFondea) {
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
									String query = "call TIPOSLINEAFONDEAALT (?,?,?,?,?, ?,?,?,?,?, ?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_DescTipoLin",tiposLineaFondea.getDescripcion());
									sentenciaStore.setInt("Par_InstitutFondID",Utileria.convierteEntero(tiposLineaFondea.getInstitutFondID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
								    loggerSAFI.info(sentenciaStore.toString());
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
						loggerSAFI.error("error en  alta de  Tipo Linea Fondeador", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



		/* Modificacion de  Tipo Linea Fondeador*/
		public MensajeTransaccionBean modifica(final TiposLineaFondeaBean tiposLineaFondea) {
			System.out.println(Utileria.convierteEntero(tiposLineaFondea.getTipoLinFondeaID()));
			System.out.println(tiposLineaFondea.getDescripcion());
			System.out.println(Utileria.convierteEntero(tiposLineaFondea.getInstitutFondID()));

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
									String query = "call TIPOSLINEAFONDEAMOD(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_TipoLinFondeaID",Utileria.convierteEntero(tiposLineaFondea.getTipoLinFondeaID()));
									sentenciaStore.setString("Par_DescTipoLin",tiposLineaFondea.getDescripcion());
									sentenciaStore.setInt("Par_InstitutFondID",Utileria.convierteEntero(tiposLineaFondea.getInstitutFondID()));

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
								    loggerSAFI.info(sentenciaStore.toString());
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
						loggerSAFI.error("error en Modificacion de  Tipo Linea Fondeador", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	/* Consuta Tipo LineaFondeador por Llave Principal*/
	public TiposLineaFondeaBean consultaPrincipal(TiposLineaFondeaBean tiposLineaFondea, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TIPOSLINEAFONDEACON(?,?,?, ?,?,?, ?,?,?,?);";

		Object[] parametros = {	Utileria.convierteEntero(tiposLineaFondea.getTipoLinFondeaID()),
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposLineaFondeaDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info("call TIPOSLINEAFONDEACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposLineaFondeaBean tiposLineaFondea = new TiposLineaFondeaBean();
				tiposLineaFondea.setTipoLinFondeaID(String.valueOf(resultSet.getInt(1)));
				tiposLineaFondea.setDescripcion(resultSet.getString(2));

					return tiposLineaFondea;

			}
		});

		return matches.size() > 0 ? (TiposLineaFondeaBean) matches.get(0) : null;
	}


	/* Consuta Tipo LineaFondeador por Llave Foranea*/
	public TiposLineaFondeaBean consultaForanea(TiposLineaFondeaBean tiposLineaFondea, int tipoConsulta) {
		//Query con el Store Procedure
				String query = "call TIPOSLINEAFONDEACON(?,?,?, ?,?,?, ?,?,?,?);";

								Object[] parametros = {
										Utileria.convierteEntero(tiposLineaFondea.getTipoLinFondeaID()),
										Constantes.ENTERO_CERO,
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"TiposLineaFondeaDAO.consultaForanea",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info("call TIPOSLINEAFONDEACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						TiposLineaFondeaBean tiposLineaFondea = new TiposLineaFondeaBean();

							tiposLineaFondea.setTipoLinFondeaID(String.valueOf(resultSet.getInt(1)));
							tiposLineaFondea.setDescripcion(resultSet.getString(2));
							tiposLineaFondea.setInstitutFondID(String.valueOf(resultSet.getInt(3)));
							return tiposLineaFondea;

				}
				});

return matches.size() > 0 ? (TiposLineaFondeaBean) matches.get(0) : null;
}


	//consulta por el tipo de institucion
	public   TiposLineaFondeaBean consultaTipoInst(int tipoLinFondeaID, int institutFondID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TIPOSLINEAFONDEACON(?,?,?, ?,?,?, ?,?,?, ?);";
		Object[] parametros = {	tipoLinFondeaID,
								institutFondID,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposLineaFondeaDAO.consultaTipoInst",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info("call TIPOSLINEAFONDEACON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposLineaFondeaBean tiposLineaFondea = new TiposLineaFondeaBean();

					tiposLineaFondea.setTipoLinFondeaID(String.valueOf(resultSet.getInt(1)));
					tiposLineaFondea.setDescripcion(resultSet.getString(2));
					tiposLineaFondea.setInstitutFondID(String.valueOf(resultSet.getInt(3)));


					return tiposLineaFondea;

			}
		});
		return matches.size() > 0 ? (TiposLineaFondeaBean) matches.get(0) : null;

	}


	/* Lista de Tipo Linea Fondeador */
	public List listaPrincipal(TiposLineaFondeaBean tiposLineaFondea, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSLINEAFONDEALIS(?,?,?, ?,?,?, ?,?,?, ?);";
		Object[] parametros = {
								tiposLineaFondea.getDescripcion(),
								Constantes.ENTERO_CERO,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"TiposLineaFondeaDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info("call TIPOSLINEAFONDEALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposLineaFondeaBean tiposLineaFondea = new TiposLineaFondeaBean();
				tiposLineaFondea.setTipoLinFondeaID(String.valueOf(resultSet.getInt(1)));
				tiposLineaFondea.setDescripcion(resultSet.getString(2));
					return tiposLineaFondea;
			}
		});

		return matches;
	}


	/* Lista de Tipo Linea Fondeador */
	public List listaForanea(TiposLineaFondeaBean tiposLineaFondea, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSLINEAFONDEALIS(?,?,?, ?,?,?, ?,?,?, ?);";
		Object[] parametros = {
								tiposLineaFondea.getTipoLinFondeaID(),
								tiposLineaFondea.getInstitutFondID(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"TiposLineaFondeaDAO.listaForanea",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info("call TIPOSLINEAFONDEALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposLineaFondeaBean tiposLineaFondea = new TiposLineaFondeaBean();
				tiposLineaFondea.setTipoLinFondeaID(String.valueOf(resultSet.getInt(1)));
				tiposLineaFondea.setDescripcion(resultSet.getString(2));
					return tiposLineaFondea;
			}
		});

		return matches;
	}

}

