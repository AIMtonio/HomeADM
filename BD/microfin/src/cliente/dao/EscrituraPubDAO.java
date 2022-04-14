package cliente.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import javax.sql.DataSource;

import cliente.bean.EscrituraPubBean;

public class EscrituraPubDAO extends BaseDAO{

		public EscrituraPubDAO() {
			super();
		}

		/* Alta  de Escritura Publica*/
		public MensajeTransaccionBean alta(final EscrituraPubBean escrituraPub) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				@SuppressWarnings("unchecked")
				public Object doInTransaction(TransactionStatus transaction) {

					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

					try {

						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call ESCRITURAPUBALT(?,?,?,?,?,	?,?,?,?,?,"
																		+ "?,?,?,?,?, ?,?,?,?,?,"
																		+ "?,?,?,?,?, ?,?,?,?,?,"
																		+ "?,?);";//parametros de auditoria

										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(escrituraPub.getClienteID()));
										sentenciaStore.setString("Par_Esc_Tipo",escrituraPub.getEsc_Tipo());
										sentenciaStore.setString("Par_EscriPub",escrituraPub.getEscrituraPub());
										sentenciaStore.setString("Par_LibroEscr",escrituraPub.getLibroEscritura());
										sentenciaStore.setString("Par_VolumenEsc",escrituraPub.getVolumenEsc());

										sentenciaStore.setString("Par_FechaEsc",escrituraPub.getFechaEsc());
										sentenciaStore.setInt("Par_EstadoIDEsc",Utileria.convierteEntero(escrituraPub.getEstadoIDEsc()));
										sentenciaStore.setInt("Par_LocalEsc",Utileria.convierteEntero(escrituraPub.getLocalidadEsc()));
										sentenciaStore.setInt("Par_Notaria",Utileria.convierteEntero(escrituraPub.getNotaria()));
										sentenciaStore.setString("Par_DirecNotar",escrituraPub.getDirecNotaria());

										sentenciaStore.setString("Par_NomNotario",escrituraPub.getNomNotario());
										sentenciaStore.setString("Par_NomApoder",escrituraPub.getNomApoderado());
										sentenciaStore.setString("Par_RFC_Apoder",escrituraPub.getRFC_Apoderado());
										sentenciaStore.setString("Par_RegistroPub",escrituraPub.getRegistroPub());
										sentenciaStore.setString("Par_FolioRegPub",escrituraPub.getFolioRegPub());

										sentenciaStore.setString("Par_VolRegPub",escrituraPub.getVolumenRegPub());
										sentenciaStore.setString("Par_LibroRegPub",escrituraPub.getLibroRegPub());
										sentenciaStore.setString("Par_AuxiRegPub",escrituraPub.getAuxiliarRegPub());
										sentenciaStore.setString("Par_FechaRegPub",escrituraPub.getFechaRegPub());
										sentenciaStore.setInt("Par_EstadoIDReg",Utileria.convierteEntero(escrituraPub.getEstadoIDReg()));

										sentenciaStore.setInt("Par_LocalRegPub",Utileria.convierteEntero(escrituraPub.getLocalidadRegPub()));
										sentenciaStore.setString("Par_Observacion",escrituraPub.getObservaciones());


										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
										//Parametros de Auditoria
										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID","EscrituraPubDAO.alta");
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
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EscrituraPubDAO.alta");
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
								throw new Exception(Constantes.MSG_ERROR + " .EscrituraPubDAO.alta");
							}else if(mensajeBean.getNumero()!=0){

								throw new Exception(mensajeBean.getDescripcion());

							}
						} catch (Exception e) {

							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Escritura Publica" + e);
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




		/* Modificacion de Escritura Publica*/
		public MensajeTransaccionBean modifica(final EscrituraPubBean escrituraPub){
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				@SuppressWarnings("unchecked")
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

						String query = "call ESCRITURAPUBMOD(?,?,?,?,?, ?,?,?,?,?,"
														 + " ?,?,?,?,?, ?,?,?,?,?,"
														 + " ?,?,?,?,?, ?,?,?,?,?,"
														 + " ?,?,?,?);";
						CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(escrituraPub.getClienteID()));
								sentenciaStore.setInt("Par_Consecutivo", Utileria.convierteEntero(escrituraPub.getConsecutivo()));
								sentenciaStore.setString("Par_Esc_Tipo", escrituraPub.getEsc_Tipo());
								sentenciaStore.setString("Par_EscriPub", escrituraPub.getEscrituraPub());
								sentenciaStore.setString("Par_LibroEscr", escrituraPub.getLibroEscritura());

								sentenciaStore.setString("Par_VolumenEsc", escrituraPub.getVolumenEsc());
								sentenciaStore.setString("Par_FechaEsc", Utileria.convierteFecha(escrituraPub.getFechaEsc()));
								sentenciaStore.setInt("Par_EstadoIDEsc",Utileria.convierteEntero(escrituraPub.getEstadoIDEsc()));
								sentenciaStore.setInt("Par_LocalEsc",Utileria.convierteEntero(escrituraPub.getLocalidadEsc()));
								sentenciaStore.setInt("Par_Notaria", Utileria.convierteEntero(escrituraPub.getNotaria()));

								sentenciaStore.setString("Par_DirecNotar", escrituraPub.getDirecNotaria());
								sentenciaStore.setString("Par_NomNotario", escrituraPub.getNomNotario());
								sentenciaStore.setString("Par_NomApoder", escrituraPub.getNomApoderado());
								sentenciaStore.setString("Par_RFC_Apoder", escrituraPub.getRFC_Apoderado());
								sentenciaStore.setString("Par_RegistroPub", escrituraPub.getRegistroPub());

								sentenciaStore.setString("Par_FolioRegPub", escrituraPub.getFolioRegPub());
								sentenciaStore.setString("Par_VolRegPub", escrituraPub.getVolumenRegPub());
								sentenciaStore.setString("Par_LibroRegPub", escrituraPub.getLibroRegPub());
								sentenciaStore.setString("Par_AuxiRegPub", escrituraPub.getAuxiliarRegPub());
								sentenciaStore.setString("Par_FechaRegPub", Utileria.convierteFecha(escrituraPub.getFechaRegPub()));

								sentenciaStore.setInt("Par_EstadoIDReg", Utileria.convierteEntero(escrituraPub.getEstadoIDReg()));
								sentenciaStore.setInt("Par_LocalRegPub", Utileria.convierteEntero(escrituraPub.getLocalidadRegPub()));
								sentenciaStore.setString("Par_Estatus", escrituraPub.getEstatus());
								sentenciaStore.setString("Par_Observacion", escrituraPub.getObservaciones());
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
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));


									}else{

										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EscrituraPubDAO.modifica");
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
							throw new Exception(Constantes.MSG_ERROR + " .EscrituraPubDAO.modifica");
						}else if(mensajeBean.getNumero()!=0){

							throw new Exception(mensajeBean.getDescripcion());

						}
					} catch (Exception e) {

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificación de Escritura Publica" + e);
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



		/* Consuta Escritura Publica por Llave Principal*/
		public EscrituraPubBean consultaPrincipal(EscrituraPubBean escrituraPub, int tipoConsulta){
			String query = "call ESCRITURAPUBCON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = { escrituraPub.getClienteID(),
									escrituraPub.getConsecutivo(),
									Constantes.STRING_VACIO,//escrituraPub.getEscrituraPub(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EscrituraPubDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESCRITURAPUBCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					EscrituraPubBean escrituraPub = new EscrituraPubBean();

					escrituraPub.setClienteID(String.valueOf(resultSet.getInt(1)));
					escrituraPub.setConsecutivo(Utileria.completaCerosIzquierda(resultSet.getInt(2),EscrituraPubBean.LONGITUD_ID));
					escrituraPub.setEsc_Tipo(resultSet.getString(3));
					escrituraPub.setEscrituraPub(resultSet.getString(4));
					escrituraPub.setLibroEscritura(resultSet.getString(5));
					escrituraPub.setVolumenEsc(resultSet.getString(6));
					escrituraPub.setFechaEsc(resultSet.getString(7));
					escrituraPub.setEstadoIDEsc(String.valueOf(resultSet.getInt(8)));
					escrituraPub.setLocalidadEsc(String.valueOf(resultSet.getInt(9)));
					escrituraPub.setNotaria(String.valueOf(resultSet.getInt(10)));
					escrituraPub.setDirecNotaria(resultSet.getString(11));
					escrituraPub.setNomNotario(resultSet.getString(12));
					escrituraPub.setNomApoderado(resultSet.getString(13));
					escrituraPub.setRFC_Apoderado(resultSet.getString(14));
					escrituraPub.setRegistroPub(resultSet.getString(15));
					escrituraPub.setFolioRegPub(resultSet.getString(16));
					escrituraPub.setVolumenRegPub(resultSet.getString(17));
					escrituraPub.setLibroRegPub(resultSet.getString(18));
					escrituraPub.setAuxiliarRegPub(resultSet.getString(19));
					escrituraPub.setFechaRegPub(resultSet.getString(20));
					escrituraPub.setEstadoIDReg(String.valueOf(resultSet.getInt(21)));
					escrituraPub.setLocalidadRegPub(String.valueOf(resultSet.getInt(22)));
					escrituraPub.setEstatus(resultSet.getString(23));
					escrituraPub.setObservaciones(resultSet.getString(24));


					return escrituraPub;
				}
			});

			return matches.size() > 0 ? (EscrituraPubBean) matches.get(0) : null;

			}

		/* Consuta Escritura Publica por Llave Foranea*/
		public EscrituraPubBean consultaForanea(EscrituraPubBean escrituraPub, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call ESCRITURAPUBCON(?,?,?,?,?,?,?,?,?,?,?);";

			Object[] parametros = {	escrituraPub.getClienteID(),
									escrituraPub.getConsecutivo(),
									Constantes.STRING_VACIO,//escrituraPub.getEscrituraPub(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EscrituraPubDAO.consultaForanea",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESCRITURAPUBCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EscrituraPubBean escrituraPub = new EscrituraPubBean();
					escrituraPub.setConsecutivo(Utileria.completaCerosIzquierda(resultSet.getInt(1),EscrituraPubBean.LONGITUD_ID));
					escrituraPub.setEsc_Tipo(resultSet.getString(2));
					escrituraPub.setNomApoderado(resultSet.getString(3));
						return escrituraPub;

				}
			});

			return matches.size() > 0 ? (EscrituraPubBean) matches.get(0) : null;
		}

		/* Consuta Escritura Publica de poderes*/
		public EscrituraPubBean consultaPoderes(EscrituraPubBean escrituraPub, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call ESCRITURAPUBCON(?,?,?,?,?,?,?,?,?,?,?);";

			Object[] parametros = {	Constantes.ENTERO_CERO,//escrituraPub.getClienteID(),
									Constantes.ENTERO_CERO,//escrituraPub.getConsecutivo(),
									escrituraPub.getEscrituraPub(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EscrituraPubDAO.consultaForanea",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESCRITURAPUBCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EscrituraPubBean escrituraPub = new EscrituraPubBean();
					escrituraPub.setEscrituraPub(resultSet.getString(1));
					escrituraPub.setFechaEsc(resultSet.getString(2));
					escrituraPub.setEstadoIDEsc(resultSet.getString(3));
					escrituraPub.setLocalidadEsc(resultSet.getString(4));
					escrituraPub.setNotaria(resultSet.getString(5));
					escrituraPub.setNomNotario(resultSet.getString(6));
					escrituraPub.setDirecNotaria(resultSet.getString(7));
					return escrituraPub;

				}
			});

			return matches.size() > 0 ? (EscrituraPubBean) matches.get(0) : null;
		}


		/* Consuta Escritura Publica de poderes*/
		public EscrituraPubBean consultaEscPubCliente(EscrituraPubBean escrituraPub, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call ESCRITURAPUBCON(?,?,?,?,?,?,?,?,?,?,?);";

			Object[] parametros = {	escrituraPub.getClienteID(),
									Constantes.ENTERO_CERO,
									escrituraPub.getEscrituraPub(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EscrituraPubDAO.consultaForanea",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESCRITURAPUBCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EscrituraPubBean escrituraPub = new EscrituraPubBean();
					escrituraPub.setEscrituraPub(resultSet.getString("EscrituraPublic"));
					escrituraPub.setFechaEsc(resultSet.getString("FechaEsc"));
					escrituraPub.setEstadoIDEsc(resultSet.getString("EstadoIDEsc"));
					escrituraPub.setLocalidadEsc(resultSet.getString("LocalidadEsc"));
					escrituraPub.setNotaria(resultSet.getString("Notaria"));
					return escrituraPub;

				}
			});

			return matches.size() > 0 ? (EscrituraPubBean) matches.get(0) : null;
		}

		/*Lista de  Escritura Publica*/
		public List listaEscritura(EscrituraPubBean escrituraPub, int tipoLista){

			String query = "call ESCRITURAPUBLIS(?,?,?,?,?,  ?,?,?,?,?);";
			Object[] parametros = {	escrituraPub.getClienteID(),
									escrituraPub.getEsc_Tipo(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"EscrituraPubDAO.listaEscritura",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESCRITURAPUBLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					EscrituraPubBean escrituraPub = new EscrituraPubBean();
					escrituraPub.setConsecutivo(String.valueOf(resultSet.getInt(1)));
					escrituraPub.setEsc_Tipo(resultSet.getString(2));
					escrituraPub.setEscrituraPub(resultSet.getString(3));
					escrituraPub.setNomApoderado(resultSet.getString(4));

					return escrituraPub;

				}
			});
			return matches;
		}

		/*Lista de Poderes*/
		public List listaPoderes(EscrituraPubBean escrituraPub, int tipoLista){

			String query = "call ESCRITURAPUBLIS(?,?,?,?,?  ,?,?,?,?,?);";
			Object[] parametros = {	escrituraPub.getClienteID(),
									escrituraPub.getEsc_Tipo(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"EscrituraPubDAO.listaPoderes",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESCRITURAPUBLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EscrituraPubBean escrituraPub = new EscrituraPubBean();
					escrituraPub.setEscrituraPub(resultSet.getString(1));
					escrituraPub.setNomApoderado(resultSet.getString(2));
					escrituraPub.setFechaEsc(resultSet.getString(3));
					return escrituraPub;
				}
			});
			return matches;
		}

		/*Lista de escriturasPublicas Tipo  Poderes por cliente*/
		public List listaEscPublicaCliente(EscrituraPubBean escrituraPub, int tipoLista){


			String query = "call ESCRITURAPUBLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	escrituraPub.getClienteID(),
									escrituraPub.getEsc_Tipo(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"EscrituraPubDAO.listaPoderes",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESCRITURAPUBLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EscrituraPubBean escrituraPub = new EscrituraPubBean();
					escrituraPub.setEscrituraPub(resultSet.getString(1));
					escrituraPub.setFechaEsc(resultSet.getString(2));
					escrituraPub.setEstadoIDEsc(resultSet.getString(3));
					return escrituraPub;
				}
			});
			return matches;
		}


	}

