package sms.dao;
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
/*
import contabilidad.bean.DetallePolizaBean;
import contabilidad.bean.PolizaBean;
import contabilidad.dao.DetallePolizaDAO;
import contabilidad.servicio.PolizaServicio.Enum_Tra_Poliza;
*/

import sms.bean.SMSCapaniasBean;
import sms.bean.SMSCodigosRespBean;




public class SMSCapaniasDAO extends BaseDAO  {
	SMSCodigosRespDAO smsCodigosRespDAO = null;
	public SMSCapaniasDAO() {
		super();
	}


	// Alta de campaña sms
	public MensajeTransaccionBean altaCampania(final SMSCapaniasBean smsCapaniasBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SMSCAMPANIASALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_CampaniaID",Utileria.convierteEntero(smsCapaniasBean.getCampaniaID()));
								sentenciaStore.setString("Par_Nombre",smsCapaniasBean.getNombre());
								sentenciaStore.setString("Par_Clasific",smsCapaniasBean.getClasificacion());
								sentenciaStore.setString("Par_Categoria",smsCapaniasBean.getCategoria());
								sentenciaStore.setInt("Par_Tipo",Utileria.convierteEntero(smsCapaniasBean.getTipo()));
								sentenciaStore.setString("Par_FecLimRes",Utileria.convierteFecha(smsCapaniasBean.getFechaLimiteRes()));
								sentenciaStore.setString("Par_MsgRecepcion",smsCapaniasBean.getMsgRecepcion());
								sentenciaStore.setInt("Par_PlantillaID",Utileria.convierteEntero(smsCapaniasBean.getPlantillaID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);


								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta campañas de SMS", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	// Modificacion de campaña sms
		public MensajeTransaccionBean modificaCampania(final SMSCapaniasBean smsCapaniasBean, final long numTransaccion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SMSCAMPANIASMOD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_CampaniaID",Utileria.convierteEntero(smsCapaniasBean.getCampaniaID()));
									sentenciaStore.setString("Par_Nombre",smsCapaniasBean.getNombre());
									sentenciaStore.setString("Par_Clasific",smsCapaniasBean.getClasificacion());
									sentenciaStore.setString("Par_Categoria",smsCapaniasBean.getCategoria());
									sentenciaStore.setInt("Par_Tipo",Utileria.convierteEntero(smsCapaniasBean.getTipo()));
									sentenciaStore.setString("Par_FecLimRes",Utileria.convierteFecha(smsCapaniasBean.getFechaLimiteRes()));
									sentenciaStore.setString("Par_MsgRecepcion",smsCapaniasBean.getMsgRecepcion());
									sentenciaStore.setInt("Par_PlantillaID",Utileria.convierteEntero(smsCapaniasBean.getPlantillaID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de campañas", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		public MensajeTransaccionBean grabaListaCodigosResp(final SMSCapaniasBean smsCapaniasBean, final List listaCodigosResp) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						SMSCodigosRespBean smsCodigosRespBean;

						mensajeBean = altaCampania(smsCapaniasBean, parametrosAuditoriaBean.getNumeroTransaccion());

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						int numero = mensajeBean.getNumero();
						String ErrMen = mensajeBean.getDescripcion();
						String control= mensajeBean.getNombreControl();
						String consecutivo= mensajeBean.getConsecutivoString();

						for(int i=0; i<listaCodigosResp.size(); i++){
							smsCodigosRespBean = (SMSCodigosRespBean)listaCodigosResp.get(i);
							mensajeBean = smsCodigosRespDAO.altaCodigoRespuesta(smsCodigosRespBean, consecutivo, parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}

						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(numero);
						mensajeBean.setDescripcion(ErrMen);
						mensajeBean.setNombreControl(control);
						mensajeBean.setConsecutivoString(consecutivo);

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en graba lista codigos", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


		public MensajeTransaccionBean modificaListaCodigosResp(final SMSCapaniasBean smsCapaniasBean, final List listaCodigosResp) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = smsCodigosRespDAO.bajaCodigoRespuesta(smsCapaniasBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						SMSCodigosRespBean smsCodigosRespBean;
						mensajeBean = modificaCampania(smsCapaniasBean, parametrosAuditoriaBean.getNumeroTransaccion());
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						int numero = mensajeBean.getNumero();
						String ErrMen = mensajeBean.getDescripcion();
						String control= mensajeBean.getNombreControl();
						String consecutivo= mensajeBean.getConsecutivoString();

						for(int i=0; i<listaCodigosResp.size(); i++){
							smsCodigosRespBean = (SMSCodigosRespBean)listaCodigosResp.get(i);
							mensajeBean = smsCodigosRespDAO.altaCodigoRespuesta(smsCodigosRespBean, consecutivo, parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(numero);
						mensajeBean.setDescripcion(ErrMen);
						mensajeBean.setNombreControl(control);
						mensajeBean.setConsecutivoString(consecutivo);

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modifica lista codigos", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}




		public MensajeTransaccionBean eliminarListaCodigosResp(final SMSCapaniasBean smsCapaniasBean, final List listaCodigosResp) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = smsCodigosRespDAO.bajaCodigoRespuesta(smsCapaniasBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						SMSCodigosRespBean smsCodigosRespBean;
						mensajeBean = bajaCampaña(smsCapaniasBean,parametrosAuditoriaBean.getNumeroTransaccion());
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en eliminar lista de codigos", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


		/* Consuta Campaña por Llave Principal */
		public SMSCapaniasBean consultaPrincipal(SMSCapaniasBean smsCapaniasBean,int tipoConsulta) {
						// Query con el Store Procedure
			String query = "call SMSCAMPANIASCON(?,?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { Utileria.convierteEntero(smsCapaniasBean.getCampaniaID()),
									Constantes.STRING_VACIO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SMSCAMPANIASCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					SMSCapaniasBean smsCapaniasBean = new SMSCapaniasBean();
					smsCapaniasBean.setCampaniaID(String.valueOf(resultSet.getInt(1)));
					smsCapaniasBean.setNombre(resultSet.getString(2));
					smsCapaniasBean.setClasificacion(resultSet.getString(3));
					smsCapaniasBean.setCategoria(resultSet.getString(4));
					smsCapaniasBean.setTipo(String.valueOf(resultSet.getInt(5)));
					smsCapaniasBean.setEstatus(resultSet.getString(6));
					smsCapaniasBean.setFechaLimiteRes(resultSet.getString(7));
					smsCapaniasBean.setMsgRecepcion(resultSet.getString(8));
					smsCapaniasBean.setPlantillaID(String.valueOf(resultSet.getInt(9)));

					return smsCapaniasBean;

				}
			});

			return matches.size() > 0 ? (SMSCapaniasBean) matches.get(0) : null;
		}

		/* Consuta Campaña por Llave Foranea */
		public SMSCapaniasBean consultaForanea(SMSCapaniasBean smsCapaniasBean,	int tipoConsulta) {
						// Query con el Store Procedure
			String query = "call SMSCAMPANIASCON(?,?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { Utileria.convierteEntero(smsCapaniasBean.getCampaniaID()),
									Constantes.STRING_VACIO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SMSCAMPANIASCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					SMSCapaniasBean smsCapaniasBean = new SMSCapaniasBean();
					smsCapaniasBean.setCampaniaID(String.valueOf(resultSet.getInt(1)));
					smsCapaniasBean.setNombre(resultSet.getString(2));
					smsCapaniasBean.setEstatus(resultSet.getString("Estatus"));
					return smsCapaniasBean;

				}
			});

			return matches.size() > 0 ? (SMSCapaniasBean) matches.get(0) : null;
		}


		/* Lista de Campañas sms */
		public List listaPrincipal(SMSCapaniasBean smsCapaniasBean, int tipoLista) {
			//Query con el Store Procedure
			String query = "call SMSCAMPANIASLIS(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									smsCapaniasBean.getNombre(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SMSCAMPANIASLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SMSCapaniasBean smsCapaniasBean = new SMSCapaniasBean();
					smsCapaniasBean.setCampaniaID(String.valueOf(resultSet.getInt(1)));
					smsCapaniasBean.setNombre(resultSet.getString(2));
					return smsCapaniasBean;
				}
			});

			return matches;
		}



		public MensajeTransaccionBean bajaCampaña(final SMSCapaniasBean smsCapaniasBean, final long numTransaccion) {
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
									String query = "call SMSCAMPANIASBAJ(?,?,?,?,? ,?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_CampaniaID",Utileria.convierteEntero(smsCapaniasBean.getCampaniaID()));
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de campaña de SMS", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		public void setSmsCodigosRespDAO(SMSCodigosRespDAO smsCodigosRespDAO) {
			this.smsCodigosRespDAO = smsCodigosRespDAO;
		}
}


