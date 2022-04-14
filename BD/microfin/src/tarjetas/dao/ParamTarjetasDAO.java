package tarjetas.dao;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import tarjetas.bean.ParamTarjetasBean;

public class ParamTarjetasDAO extends BaseDAO {

	public ParamTarjetasDAO(){
		super();
	}

	// Proceso de Actualizacion Parametros de Tarjetas
	public MensajeTransaccionBean actualizaParamTarjetas(final ParamTarjetasBean paramTarjetasBean)  {
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		//Abrimos transaccion
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute( new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeTransaccionBean = null;
				try {

					if(paramTarjetasBean.getListaLlaveParametro()  == null || paramTarjetasBean.getListaLlaveParametro().size() == 0||
						paramTarjetasBean.getListaValorParametro() == null || paramTarjetasBean.getListaValorParametro().size() == 0 ) {
						mensajeTransaccionBean = new MensajeTransaccionBean();
						mensajeTransaccionBean.setNumero(999);
						mensajeTransaccionBean.setDescripcion("Especifique los Parámetros de Autorización Terceros a Actualizar.");
						return mensajeTransaccionBean;
					}

					if(paramTarjetasBean.getListaLlaveParametro().size()  != paramTarjetasBean.getListaValorParametro().size()  ) {
						mensajeTransaccionBean = new MensajeTransaccionBean();
						mensajeTransaccionBean.setNumero(999);
						mensajeTransaccionBean.setDescripcion("No Coincide la Cantidad de Parámetros de Autorización Terceros con los Valores a Actualizar.");
						return mensajeTransaccionBean;
					}

					for(int iteracion = 0; iteracion < paramTarjetasBean.getListaLlaveParametro().size(); iteracion++) {

						ParamTarjetasBean paramTarjetas = new ParamTarjetasBean();
					 	paramTarjetas.setLlaveParametro(paramTarjetasBean.getListaLlaveParametro().get(iteracion));
						paramTarjetas.setValorParametro(paramTarjetasBean.getListaValorParametro().get(iteracion));

						mensajeTransaccionBean = actualizaParametro(paramTarjetas);
						if(mensajeTransaccionBean.getNumero() != 0) {
							throw new Exception(mensajeTransaccionBean.getDescripcion());
						}
					}


				}
				catch (Exception exception) {
					if (mensajeTransaccionBean.getNumero() == 0) {
						mensajeTransaccionBean.setNumero(999);
					}
					mensajeTransaccionBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error al actualizar los Parámetros de Configuración", exception);
				}

				return mensajeTransaccionBean;
			}
		});
		return mensajeResultado;
	}//Fin Proceso de Actualizacion Parametros de Tarjetas

	// Actualiza Parametros de Tarjetas
	public MensajeTransaccionBean actualizaParametro(final ParamTarjetasBean paramTarjetasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL PARAMTARJETASACT(?,?," +
																	 "?,?,?," +
																	 "?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_LlaveParametro",paramTarjetasBean.getLlaveParametro());
								sentenciaStore.setString("Par_ValorParametro",paramTarjetasBean.getValorParametro());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","ParamTarjetasDAO.actualizaParametro");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ParamGeneralesDAO.actualizaParametroGenerales");
								}

								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. Error al actualizar la respuesta.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

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

	// Consulta Principal Parametros de Tarjetas
	public ParamTarjetasBean consultaPrincipal(final ParamTarjetasBean paramTarjetasBean, final int tipoConsulta) {
		ParamTarjetasBean parametro = new ParamTarjetasBean();
		parametro = (ParamTarjetasBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ParamTarjetasBean operacionTarjeta = new ParamTarjetasBean();
				try {
					// Query con el Store Procedure
					operacionTarjeta = (ParamTarjetasBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							//Query con el Store Procedure
							String query = "CALL PARAMTARJETASCON(?," +
																 "?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_NumConsulta", tipoConsulta);
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "ParamTarjetasDAO.consultaPrincipal");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							ParamTarjetasBean paramTarjetasBean = new ParamTarjetasBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								paramTarjetasBean.setAutorizaTerceroTranTD(resultadosStore.getString("AutorizaTerceroTranTD"));
								paramTarjetasBean.setRutaConWSAutoriza(resultadosStore.getString("RutaConWSAutoriza"));
								paramTarjetasBean.setTimeOutConWSAutoriza(resultadosStore.getString("TimeOutConWSAutoriza"));
								paramTarjetasBean.setUsuarioConWSAutoriza(resultadosStore.getString("UsuarioConWSAutoriza"));

								paramTarjetasBean.setIDEmisor(resultadosStore.getString("IDEmisor"));
								paramTarjetasBean.setPrefijoEmisor(resultadosStore.getString("PrefijoEmisor"));
							}else{
								paramTarjetasBean = null;
							}
							return paramTarjetasBean;
						}
					});
					if(operacionTarjeta ==  null){
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Fallo. El Procedimiento no Regreso Ningun Resultado");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de Información de Operación Petición en Tarjetas ISOTRX ", exception);
				}
				return operacionTarjeta;
			}
		});
		return parametro;
	}// Fin Consulta Principal Parametros de Tarjetas

	// Lista Principal Parametros de Tarjetas
	public List<ParamTarjetasBean> listaPrincipal(final ParamTarjetasBean paramTarjetasBean, final int tipoLista) {

		List<ParamTarjetasBean> listaParametros = null;
		//Query con el Store Procedure
		try{
			String query = "CALL PARAMTARJETASLIS(?,"
												+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ParamGuardaValoresDAO.listaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL PARAMTARJETASCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamTarjetasBean  paramTarjetasBean = new ParamTarjetasBean();

					paramTarjetasBean.setLlaveParametro(resultSet.getString("LlaveParametro"));
					paramTarjetasBean.setValorParametro(resultSet.getString("ValorParametro"));
					return paramTarjetasBean;
				}
			});

			listaParametros = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Parámetros de Tarjetas ", exception);
			listaParametros = null;
		}

		return listaParametros;
	}// Fin Lista Principal Parametros de Tarjetas

}
