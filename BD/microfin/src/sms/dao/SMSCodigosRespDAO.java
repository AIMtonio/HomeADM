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


import sms.bean.SMSCapaniasBean;
import sms.bean.SMSCodigosRespBean;


public class SMSCodigosRespDAO extends BaseDAO  {

	public SMSCodigosRespDAO() {
		super();
	}

	// Alta de codigos de respuesta sms
	public MensajeTransaccionBean altaCodigoRespuesta(final SMSCodigosRespBean smsCodigosRespBean, final String consecutivo, final long numTransaccion) {
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
								String query = "call SMSCODIGOSRESPALT(?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_CodigoResID",smsCodigosRespBean.getCodigoRespID());
								sentenciaStore.setString("Par_Descripcion",smsCodigosRespBean.getDescripcion());
								sentenciaStore.setInt("Par_Campania",Utileria.convierteEntero(consecutivo));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de codigos de respuesta", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



public MensajeTransaccionBean bajaCodigoRespuesta(final SMSCapaniasBean smsCapaniasBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			//Query cons el Store Procedure
			String query = "call SMSCODIGOSRESPBAJ(?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					Utileria.convierteEntero(smsCapaniasBean.getCampaniaID()),
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"SMSCodigosRespDAO.bajaCodigoRespuesta",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SMSCODIGOSRESPBAJ(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					mensaje.setConsecutivoString(resultSet.getString(4));
					return mensaje;

				}
			});
			return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de codigos de respuesta", e);
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
		}
		return mensaje;
	}



		/* Consuta Campaña por Llave Principal */
		/*public SMSCapaniasBean consultaPrincipal(SMSCapaniasBean smsCapaniasBean,
				int tipoConsulta) {
						// Query con el Store Procedure
			String query = "call SMSCAMPANIASCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { Utileria.convierteEntero(smsCapaniasBean.getCampaniaID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					SMSCapaniasBean smsCapaniasBean = new SMSCapaniasBean();
					smsCapaniasBean.setCampaniaID(String.valueOf(resultSet.getInt(1)));
					smsCapaniasBean.setNombre(resultSet.getString(2));
					smsCapaniasBean.setClasificacion(resultSet.getString(3));
					smsCapaniasBean.setCategoria(resultSet.getString(4));
					smsCapaniasBean.setTipo(String.valueOf(resultSet.getInt(5)));
					return smsCapaniasBean;

				}
			});

			return matches.size() > 0 ? (SMSCapaniasBean) matches.get(0) : null;
		}
		*/

	// Lista de codigos de respuesta por campania
		public List listaPorCampania(SMSCodigosRespBean smsCodigosResp, int tipoLista){
			String query = "call SMSCODIGOSRESPLIS(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(smsCodigosResp.getCampaniaID()),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SMSCODIGOSRESPLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					SMSCodigosRespBean smsCodigosRespBean = new SMSCodigosRespBean();
					smsCodigosRespBean.setCodigoRespID(resultSet.getString(1));
					smsCodigosRespBean.setDescripcion(resultSet.getString(2));
					smsCodigosRespBean.setCampaniaID(String.valueOf(resultSet.getString(3)));

					return smsCodigosRespBean;
				}
			});
			return matches;
		}

		// lista de codigos de respuesta para pantalla de resumen de actividad
		public List listaCodigosResumenAct(SMSCodigosRespBean smsCodigosResp, int tipoLista){
			String query = "call SMSCODIGOSRESPLIS(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(smsCodigosResp.getCampaniaID()),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SMSCODIGOSRESPLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					SMSCodigosRespBean smsCodigosRespBean = new SMSCodigosRespBean();
					smsCodigosRespBean.setCodigoRespID(resultSet.getString(1));
					smsCodigosRespBean.setDescripcion(resultSet.getString(2));
					smsCodigosRespBean.setCampaniaID(String.valueOf(resultSet.getString(3)));

					return smsCodigosRespBean;
				}
			});
			return matches;
		}




}


