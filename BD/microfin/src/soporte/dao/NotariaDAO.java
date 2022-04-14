package soporte.dao;
import org.springframework.dao.DataAccessException;
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

import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import soporte.bean.NotariaBean;

public class NotariaDAO extends BaseDAO{

	public NotariaDAO() {
		super();
	}

	// ------------------ Transacciones ------------------------------------------


	/* Alta de Notaria */

	public MensajeTransaccionBean alta(final NotariaBean notaria) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					@SuppressWarnings("unchecked")
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {

							notaria.setTelefono(notaria.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
							//Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call NOTARIASALT(?,?,?,?,?, ?,?,?,?,?,"
														  + "?,?,?,?,?, ?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);


							sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(notaria.getEstadoID()));
							sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(notaria.getMunicipioID()));
							sentenciaStore.setInt("Par_NotariaID", Utileria.convierteEntero(notaria.getNotariaID()));
							sentenciaStore.setString("Par_Titular", notaria.getTitular());
							sentenciaStore.setString("Par_Direccion", notaria.getDireccion());

							sentenciaStore.setString("Par_Telefono", notaria.getTelefono());
							sentenciaStore.setString("Par_Correo", notaria.getCorreo());
							sentenciaStore.setString("Par_ExtTelefonoPart", notaria.getExtTelefonoPart());
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

							sentenciaStore.setString("Aud_ProgramaID","NotariaDAO.alta");
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
												mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + ".NotariaDAO.alta");
												mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
												mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
												mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
											}

											return mensajeTransaccion;
										}
									}
									);

								if(mensajeBean ==  null){

									mensajeBean = new MensajeTransaccionBean();
									mensajeBean.setNumero(999);
									throw new Exception(Constantes.MSG_ERROR + " .NotariaDAO.alta");
								}else if(mensajeBean.getNumero()!=0){

									throw new Exception(mensajeBean.getDescripcion());

								}
							} catch (Exception e) {

								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Notaria" + e);
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

	/* Baja de Notaria */
	public MensajeTransaccionBean  baja(final NotariaBean notaria) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					String query = "call NOTARIASBAJ(?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							notaria.getEstadoID(),
							notaria.getMunicipioID(),
							notaria.getNotariaID(),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"NotariaDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};


					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOTARIASBAJ(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
										MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
										mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
										mensaje.setDescripcion(resultSet.getString(2));
										mensaje.setNombreControl(resultSet.getString(3));
										return mensaje;

						}
					});

					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de notaria", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	/* Modificacion de Notarias */
	public MensajeTransaccionBean modifica(final NotariaBean notaria){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					notaria.setTelefono(notaria.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

					String query = "call NOTARIASMOD(?,?,?,?,?, ?,?,?,?,?, "
												  + "?,?,?,?,?, ?,?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);


					sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(notaria.getEstadoID()));
					sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(notaria.getMunicipioID()));
					sentenciaStore.setInt("Par_NotariaID", Utileria.convierteEntero(notaria.getNotariaID()));
					sentenciaStore.setString("Par_Titular", notaria.getTitular());
					sentenciaStore.setString("Par_Direccion", notaria.getDireccion());

					sentenciaStore.setString("Par_Telefono", notaria.getTelefono());
					sentenciaStore.setString("Par_Correo", notaria.getCorreo());
					sentenciaStore.setString("Par_ExtTelefonoPart", notaria.getExtTelefonoPart());
					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
					//Parametros de Auditoria
					sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

					sentenciaStore.setString("Aud_ProgramaID","NotariaDAO.modifica");
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + ".NotariaDAO.modifica");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){

							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .NotariaDAO.modifica");
						}else if(mensajeBean.getNumero()!=0){

							throw new Exception(mensajeBean.getDescripcion());

						}
					} catch (Exception e) {

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificación de Notaria" + e);
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

	/* Consuta Notaria por Llave Principal*/
	public NotariaBean consultaPrincipal(NotariaBean notaria, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call NOTARIASCON(?,?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {	notaria.getEstadoID(),
								notaria.getMunicipioID(),
								notaria.getNotariaID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"NotariaDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOTARIASCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NotariaBean notaria = new NotariaBean();
					notaria.setEstadoID(String.valueOf(resultSet.getInt(1)));
					notaria.setMunicipioID(String.valueOf(resultSet.getInt(2)));
					notaria.setNotariaID(String.valueOf(resultSet.getInt(3)));
					notaria.setEmpresaID(String.valueOf(resultSet.getInt(4)));

					notaria.setTitular(resultSet.getString(5));
					notaria.setDireccion(resultSet.getString(6));
					notaria.setTelefono(resultSet.getString(7));
					notaria.setCorreo(resultSet.getString(8));
					notaria.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
					return notaria;

			}
		});

		return matches.size() > 0 ? (NotariaBean) matches.get(0) : null;
	}


	/* Consuta Notaria por Llave Foranea*/
	public NotariaBean consultaForanea(NotariaBean notaria, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call NOTARIASCON(?,?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {	notaria.getEstadoID(),
								notaria.getMunicipioID(),
								notaria.getNotariaID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"NotariaDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOTARIASCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NotariaBean notaria = new NotariaBean();;
					notaria.setNotariaID(String.valueOf(resultSet.getInt(1)));
					notaria.setTitular(resultSet.getString(2));
					notaria.setDireccion(resultSet.getString(3));
					return notaria;

			}
		});

		return matches.size() > 0 ? (NotariaBean) matches.get(0) : null;
	}


	/* Lista de Notarias por Titular */
	public List listaPrincipal(NotariaBean notariaBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call NOTARIASLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								notariaBean.getEstadoID(),
								notariaBean.getMunicipioID(),
								notariaBean.getTitular(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"NotariaDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOTARIASLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				NotariaBean notaria = new NotariaBean();
				notaria.setNotariaID(String.valueOf(resultSet.getInt(1)));
				notaria.setTitular(resultSet.getString(2));
				return notaria;
			}
		});

		return matches;
	}

}
