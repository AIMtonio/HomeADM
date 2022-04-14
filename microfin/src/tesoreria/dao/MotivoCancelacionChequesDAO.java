package tesoreria.dao;

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

import tesoreria.bean.MotivoCancelacionChequesBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class MotivoCancelacionChequesDAO extends BaseDAO{

	public MotivoCancelacionChequesDAO() {
		super();
	}

	public MensajeTransaccionBean grabaMotivosCancelaCheques(final MotivoCancelacionChequesBean motivoCancelChequeBean, final List listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					MotivoCancelacionChequesBean motivoCancelBean;
					mensajeBean = bajaMotivosCancelacion(motivoCancelChequeBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					if(listaBean!=null){
					for(int i=0; i<listaBean.size(); i++){
						motivoCancelBean = (MotivoCancelacionChequesBean)listaBean.get(i);
						mensajeBean = altaMotivosCancelacion(motivoCancelBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				  }
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al grabar los motivos de cancelacion de cheques", e);
					if(mensajeBean.getNumero()==0){
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

	/*------------Alta de Motivos de Cancelacion de cheques-------------*/

	public MensajeTransaccionBean altaMotivosCancelacion(final MotivoCancelacionChequesBean motivoCancelChequeBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CATMOTCANCELCHEQUEALT(" +
									"?,?,?, ?,?,?," +
									"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_MotivoID",motivoCancelChequeBean.getMotivoID());
								sentenciaStore.setString("Par_Descripcion",motivoCancelChequeBean.getDescripcion());
								sentenciaStore.setString("Par_Estatus",motivoCancelChequeBean.getEstatus());
								//Parametros de OutPut
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " MotivoCancelacionChequesDAO.altaMotivosCancelacion");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " MotivoCancelacionChequesDAO.altaMotivosCancelacion");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Motivos de cancelacion de cheques" + e);
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


	/*------------Baja de Motivos de Cancelacion de cheques-------------*/

		public MensajeTransaccionBean bajaMotivosCancelacion(final MotivoCancelacionChequesBean motivoCancelChequeBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CATMOTCANCELCHEQUEBAJ(?, ?,?,?, ?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de motivos de cancelacion de cheques", e);
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


		// Lista Grid de Motivos de cancelacion de cheques
		public List listaGridMotivos(MotivoCancelacionChequesBean motivoCancelChequeBean,int tipoLista){
			String query = "call CATMOTCANCELCHEQUELIS(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
						Utileria.convierteEntero(motivoCancelChequeBean.getMotivoID()),
						Constantes.STRING_VACIO,
						tipoLista,
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"MotivoCancelacionChequesDAO.listaGridMotivos",
						parametrosAuditoriaBean.getSucursal(),
						Constantes.ENTERO_CERO
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATMOTCANCELCHEQUELIS(  " + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MotivoCancelacionChequesBean bean = new MotivoCancelacionChequesBean();
					bean.setMotivoID(resultSet.getString("motivoID"));
					bean.setDescripcion(resultSet.getString("descripcion"));
					bean.setEstatus(resultSet.getString("estatus"));
					return bean;
				}
			});
			return matches;

		}

		// Lista de  Motivos de cancelacion para pantalla
		public List listaMotivosCancelacion(MotivoCancelacionChequesBean motivoCancelChequeBean,int tipoLista){
			String query = "call CATMOTCANCELCHEQUELIS(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
						Constantes.ENTERO_CERO,
						motivoCancelChequeBean.getDescripcion(),
						tipoLista,
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"MotivoCancelacionChequesDAO.listaMotivosCancela",
						parametrosAuditoriaBean.getSucursal(),
						Constantes.ENTERO_CERO
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATMOTCANCELCHEQUELIS(  " + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MotivoCancelacionChequesBean bean = new MotivoCancelacionChequesBean();
					bean.setMotivoID(resultSet.getString("motivoID"));
					bean.setDescripcion(resultSet.getString("descripcion"));
					return bean;
				}
			});
			return matches;

		}


		public MotivoCancelacionChequesBean conMotivosCancelacion(MotivoCancelacionChequesBean motivoCancelacionCheques, int tipoConsulta) {
			String query = "call CATMOTCANCELCHEQUECON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(motivoCancelacionCheques.getMotivoID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"MotivoCancelacionChequesDAO.conMotivosCancelacion",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATMOTCANCELCHEQUECON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					MotivoCancelacionChequesBean motivosCancela = new MotivoCancelacionChequesBean();
					motivosCancela.setMotivoID(resultSet.getString("MotivoID"));
					motivosCancela.setDescripcion(resultSet.getString("Descripcion"));
					motivosCancela.setEstatus(resultSet.getString("Estatus"));


					return motivosCancela;
				}
			});

			return matches.size() > 0 ? (MotivoCancelacionChequesBean) matches.get(0) : null;
	}


	public MotivoCancelacionChequesBean conChequesCancela(MotivoCancelacionChequesBean motivoCancelacionCheques, int tipoConsulta) {
			String query = "call CATMOTCANCELCHEQUECON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(motivoCancelacionCheques.getMotivoID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"MotivoCancelacionChequesDAO.conMotivosCancelacion",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATMOTCANCELCHEQUECON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					MotivoCancelacionChequesBean motivosCancela = new MotivoCancelacionChequesBean();
					motivosCancela.setNumCancela(resultSet.getString("NumCancela"));

					return motivosCancela;
				}
			});

			return matches.size() > 0 ? (MotivoCancelacionChequesBean) matches.get(0) : null;
	}
}